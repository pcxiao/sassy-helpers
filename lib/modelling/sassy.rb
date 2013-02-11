# -*- encoding: utf-8 -*-
require "treetop"
require "modelling/parser/sassyparser"

module Modelling	
	module SassyModel
		# our m file parser (only needed once)
		@@sassyparser =  Modelling::SassyParser.new

		# read from sassy/matlab format
		# 
		# Parameters: 
		# basepath          : the base path to the model (suffixed with _model.m to get the file name)
		# parameters        : the name of the parameters file (optional)
		# initvals          : optional initial values file
		# species_prefix    : prefix for the species names
		# parameter_prefix  : prefix for the parameter names
		def from_matlab(basepath, parameters = nil, initvals = nil, species_prefix = "", parameter_prefix = "")
			if parameters.nil?
				parameters = "#{basepath}.par"
			end
			if initvals.nil?
				initvals = "#{basepath}.y"
			end
			model = "#{basepath}_model.m"
			unless File.exists?(model) and File.exists?(parameters)
				raise "Both #{model} and #{parameters} must exist."
			end
			mdata = @@sassyparser.parse(File.read(model))
			if mdata.nil? or mdata.value.nil?
				raise <<-END
Error parsing #{model}, reason:
#{@@sassyparser.failure_reason}
#{@@sassyparser.failure_line}:#{@@sassyparser.failure_column}

END
			end
			mdata = mdata.value

			if @model == "" || @model.nil?
				@model = basepath.gsub(/^.*[\\\/]/, "")
				if @model == ""
					@model = "Imported from #{basepath}"
				end
			else
				@model = @model + " " + basepath.gsub(/^.*[\\\/]/, "")
			end

			if @notes.nil?
				@notes = mdata[:comments_top]
			else
				@notes = @notes + mdata[:comments_top]
			end

			if @sassy_extra.nil?
				@sassy_extra = mdata[:comments_bottom]
			else
				@sassy_extra = @sassy_extra + mdata[:comments_bottom]
			end

			species_offset = @species.length

			mdata[:equations].each_with_index.map do |e, i| 
				if @species["#{species_prefix}y_#{i+1}"]
					raise "Duplicate species #{species_prefix}y_#{i+1}\n"
				end
				@species["#{species_prefix}y_#{i+1}"] = Species.new("#{species_prefix}y_#{i+1}", 0, i+1+species_offset) 
			end

			File.open(parameters, "r").each do |l|
				lspl = l.split(/\s+/)
				pname = lspl.shift
				pval = lspl.shift
				comment = lspl.join(" ").gsub(/^"/, "").gsub(/"$/, "").gsub(/\\"/, "\"")
				if @parameters[parameter_prefix+pname]
					puts "[W] Identical name for parameter #{parameter_prefix+pname}\n"
				end
				@parameters[parameter_prefix+pname] = Parameter.new(pname, pval.to_f, comment)
			end

			if File.exists?(initvals)
				File.open(initvals).each do |l|
					l.match(/^y([0-9]+)\s+(.*)$/) {|m| @species["#{species_prefix}y_#{$1}"].initial=($2).to_f}
				end
			end

			# rename species
			eqns = mdata[:equations].map { |e| Equation.new(e[:equation], e[:comments]) }
			eqns.each do |eq|
				@species.each do |name, spec|
					eq.replace_ident("y(#{spec.matlab_no})", spec.name)
				end
				if parameter_prefix != ""
					@parameters.each do |k,p|
						eq.replace_ident(k, p.name)
					end
				end
			end
			@parameters.each do |k, p|
				p.name=(k)
			end

			mdata[:equations].each_with_index.map { |e, i|
			 	@rules.push (Rule.new(@species["#{species_prefix}y_#{i+1}"], eqns[i], 'rate')) 
			}

			self.validate
			self
		end

		# Write matlab files with model, parameters and initial values
		# 
		# This will convert reactions into rules
		def to_matlab(basepath)
			if @reactions.length > 0
				self.reactions_to_rules
			end
			File.open("#{basepath}.par", "w") do |f|
				@parameters.each do |p|
					f.puts(p.to_par)
				end
			end
			File.open("#{basepath}.y", "w") do |f|
				mno = 1
				@species = (@species.sort {|x,y| x.matlab_no <=> y.matlab_no })
				@species.each do |sp|
					f.puts("y#{sp.matlab_no} #{sp.initial}\n")
					# redo matlab numbers
					sp.matlab_no=(mno)
					mno = mno + 1
				end
			end
			File.open("#{basepath}_model.m", "w") do |f|
				@rules.each do |rule| 
					raise "Cannot export parameter rules to Sassy format" unless rule.output.kind_of? Species
					raise "Cannot export scalar rules to Sassy format" unless rule.type == 'rate'
				end
				f.puts <<-END
function dydt = f(t, y, p)
   
% #{@notes}

eval(p);

dydt = [  

END
				species_eqns = []
				(@rules.sort {|x,y| x.output.matlab_no <=> y.output.matlab_no}).each do |rule|
					eq = rule.equation.clone
					@species.each do |s|
						eq.rename_ident(s.name, "y(#{s.matlab_no})")
					end
					species_rules[rule.output.matlab_no] = eq.to_s
				end

				@species.each do |s|
					if species_eqns[s.matlab_no]
						f.puts("\t #{species_eqns[s.matlab_no]} ;\n")
					else
						puts("[W] Species #{s.name} has no rate rule, setting to zero.")
						f.puts("\t 0 ;\n")
					end
				end
				formatted_sassy_extra = @sassy_extra.gsub(/\%/, "\n%%")
				f.puts <<-END
]; 

% #{formatted_sassy_extra}

end
END
			end
		end
	end
end