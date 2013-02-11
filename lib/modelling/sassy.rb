# -*- encoding: utf-8 -*-
require "treetop"
require "modelling/parser/sassyparser"

module Modelling	
	module SassyModel

		# our m file parser (only needed once)
		@@sassyparser =  Modelling::SassyParser.new

		# read from sassy/matlab format
		def from_matlab(basepath, parameters = nil, initvals = nil)
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
			@model = basepath.gsub(/^.*[\\\/]/, "")
			if @model == ""
				@model = "Imported from #{basepath}"
			end
			@reactions = []
			@parameters = {}
			@species = {}

			mdata[:equations].map { |e, i| @species["y_#{i+1}"] = Species.new("y_#{i+1}", 0, i+1) }

			# rename species
			eqns = mdata[:equations].map { |e| Equation.new(e) }
			eqns.each do |eq|
				@species.each do |spec|
					eqns.replace_ident("y(#{spec.matlab_no})", spec.name)
				end
			end

			@rules = mdata[:equations].enum_with_index.map { |e, i|
			 	Rule.new(@species["y_#{i+1}"], eqns[i], 'rate') 
			}

			File.open(parameters, "r").each do |l|
				lspl = l.split(/\s+/)
				pname = lspl.shift
				pval = lspl.shift
				comment = lspl.join(" ").gsub(/^"/, "").gsub(/"$/, "").gsub(/\\"/, "\"")
				@parameters[pname] = Parameter.new(pname, pval.to_f, comment)
			end

		end
	end
end