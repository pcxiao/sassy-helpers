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

			mdata[:equations].each_with_index.map do |e, i| 
				if @species["#{species_prefix}y_#{i+1}"]
					raise "Duplicate species #{species_prefix}y_#{i+1}\n"
				end
				@species["#{species_prefix}y_#{i+1}"] = Species.new("#{species_prefix}y_#{i+1}", 0, i+1) 
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
		def to_matlab(basepath)
			
		end
	end
end