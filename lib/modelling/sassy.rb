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
		def from_sassy(basepath, parameters = nil, initvals = nil)
			# reset object
			initialize
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

			@sassy_extra = mdata[:sassyfooter]

			species_offset = @species.length

			mdata[:equations].each_with_index.map do |e, i| 
				if @species["y_#{i+1}"]
					raise "Duplicate species y_#{i+1}\n"
				end
				@species["y_#{i+1}"] = Species.new("y_#{i+1}", 0, i+1+species_offset) 
			end

			File.open(parameters, "r").each do |l|
				lspl = l.split(/\s+/)
				pname = lspl.shift
				pval = lspl.shift
				comment = lspl.join(" ").gsub(/^"/, "").gsub(/"$/, "").gsub(/\\"/, "\"")
				if @parameters[pname]
					puts "[W] Identical name for parameter #{pname}\n"
				end
				@parameters[pname] = Parameter.new(pname, pval.to_f, comment)
			end

			if File.exists?(initvals)
				File.open(initvals).each do |l|
					l.match(/^y([0-9]+)\s+(.*)$/) {|m| @species["y_#{$1}"].initial=($2).to_f}
				end
			end

			# rename species
			eqns = mdata[:equations].map { |e| Equation.new(e[:equation], e[:comments]) }
			eqns.each do |eq|
				@species.each do |name, spec|
					eq.replace_ident("y(#{spec.matlab_no})", spec.name)
				end
			end

			idx = -mdata[:rules].length
			mdata[:rules].each do |r|
				if @species.key? r[:output]
					raise "Cannot assign species values in sassy rules"
				end
				if not @parameters.key? r[:output]
					@parameters[r[:output]] = Parameter.new(r[:output], 0, r[:comment])
				end
				eq = Equation.new(r[:equation], r[:comment])
				@species.each do |name, spec|
					eq.replace_ident("y(#{spec.matlab_no})", spec.name)
				end

				@rules.push (Rule.new(@parameters[r[:output]], eq, 'scalar'))
			end

			mdata[:equations].each_with_index.map { |e, i|
			 	@rules.push (Rule.new(@species["y_#{i+1}"], eqns[i], 'rate')) 
			}

			# fix parameters
			@parameters.each do |k, p|
				p.name=(k)
			end

			self.validate
			self
		end

		# Write matlab files with model, parameters and initial values
		# 
		# This will convert reactions into rules
		def to_sassy(basepath)
			File.open("#{basepath}.par", "w") do |f|
				@parameters.each do |n, p|
					f.puts(p.to_par)
				end
			end
			File.open("#{basepath}.y", "w") do |f|
				mno = 1
				@species = (@species.sort {|x,y| x[1].matlab_no <=> y[1].matlab_no })
				@species.each do |n, sp|
					f.puts("y#{sp.matlab_no} #{sp.initial}\n")
					# redo matlab numbers
					sp.matlab_no=(mno)
					mno = mno + 1
				end
			end
			File.open("#{basepath}_model.m", "w") do |f|
				@rules.each do |rule| 
					if rule.type == 'scalar' and rule.output.kind_of?(Species)
						raise "Cannot export scalar species rules to Sassy format"
					end
					if rule.type == 'rate' and rule.output.kind_of?(Parameter)
						raise "Parameters cannot have rate rules"
					end
				end
				f.puts <<-END
function dydt = f(t, y, p)
   
% #{@notes.gsub("%%%%-cb-%%%%", "\n% ")}

eval(p);

END
				species_eqns = []
				species_comments = []
				((@rules.reject { |e| e.output.kind_of? Parameter}) \
					.sort {|x,y| x.output.matlab_no <=> y.output.matlab_no}) \
				    .each do |rule|					
						eq = rule.equation.clone
						@species.each do |n,s|
							eq.replace_ident(s.name, "y(#{s.matlab_no})")
						end
						species_comments[rule.output.matlab_no] = eq.comments.gsub("%%%%-cb-%%%%", " ")
						species_eqns[rule.output.matlab_no] = eq.to_s
					end

				(@rules.reject { |e| e.output.kind_of? Species}) \
				    .each do |rule|					
						eq = rule.equation.clone
						@species.each do |n,s|
							eq.replace_ident(s.name, "y(#{s.matlab_no})")
						end
						
						f.puts ("% " + eq.comments.gsub("%%%%-cb-%%%%", " ") + "\n#{rule.output.name} = "  + eq.to_s + ";\n")
					end

				f.puts("\ndydt = [ \n")

				@species.each do |n,s|
					if species_comments[s.matlab_no]
						f.puts("     % #{species_comments[s.matlab_no]}\n")
					end
					if species_eqns[s.matlab_no]
						f.puts("     #{species_eqns[s.matlab_no]} ;\n")
					else
						puts("[W] Species #{s.name} has no rate rule, setting to zero.")
						f.puts("     0 ;\n")
					end
				end
				formatted_sassy_extra = @sassy_extra.gsub("%%%%-cb-%%%%", "\n%") \
					.gsub(/\n%$/, '')	\
					.gsub(/%([^%])/, '% \1')
				f.puts <<-END
]; 

% #{formatted_sassy_extra}

END
			end
		end
	end
end