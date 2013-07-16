# -*- encoding: utf-8 -*-
require "treetop"
require "modelling/parser/matlabexpression"
require "rexml/document"

module Modelling
	module VFGenModel
		# Write CPP file which gives the model equations
		#
		def to_vfgen(basepath)
			File.open("#{basepath}", "w") do |f|
				mname = basepath.gsub(%r((.*[\\/])?([^/\\]+)$), "\\2").gsub(%r(\.vf$), "").gsub(%r([^A-Za-z0-9\-\_]), "_")
				doc = REXML::Document.new 

				top = REXML::Element.new "VectorField"
				top.add_attributes({
					"Name" => mname,
					"Description" => @notes.gsub("%%%%-cb-%%%%", " ")
					})

				mno = 1
				@species = (@species.sort {|x,y| x[1].matlab_no <=> y[1].matlab_no })
				@species.each do |n, sp|
					# redo matlab numbers
					sp.matlab_no=(mno)
					mno = mno + 1
				end

				@rules.each do |rule|
					if rule.type == 'rate' and rule.output.kind_of?(Parameter)
						raise "Parameters cannot have rate rules"
					end
				end

				species_eqns = []
				species_comments = []
				((@rules.reject { |e| e.output.kind_of? Parameter}) \
					.sort {|x,y| x.output.matlab_no <=> y.output.matlab_no}) \
				    .each do |rule|
						eq = rule.equation.clone

						species_comments[rule.output.matlab_no] = eq.comments.gsub("%%%%-cb-%%%%", " ")
						species_eqns[rule.output.matlab_no] = eq.to_s
					end

				para_has_rule = {}

				(@rules.reject { |e| e.output.kind_of? Species}) \
				    .each do |rule|
						eq = rule.equation.clone
						eqstr = eq.to_s

						rel = REXML::Element.new "Expression"
						rel.add_attributes({
							"Name" => rule.output.name,
							"Formula" => eqstr,
							"Description" => eq.comments.gsub("%%%%-cb-%%%%", " ")
							})

						top << rel

						para_has_rule[rule.output.name] = 1
					end

				(@parameters.reject {|p| para_has_rule[p]}).each do |p, par|

					rel = REXML::Element.new "Parameter"

					if par.description
						pcc = par.description.gsub("%%%%-cb-%%%%", "\n# ")
					else
						pcc = ""
					end

					rel.add_attributes({
						"Name" => par.name,
						"DefaultValue" => par.value,
						"Description" => pcc
						})

					top << rel
				end

				@species.each do |n,s|
					pcc = ""
					if species_comments[s.matlab_no]
						pcc = species_comments[s.matlab_no]
					end
					
					speq = "0"
					if species_eqns[s.matlab_no]
						speq = species_eqns[s.matlab_no]
					else
						puts("[W] Species #{s.name} has no rate rule, setting to zero.")
					end
					rel = REXML::Element.new "StateVariable"

					rel.add_attributes({
						"Name" => s.name,
						"DefaultInitialCondition" => s.initial,
						"Formula" => speq,
						"Description" => pcc
						})

					top << rel

				end

				doc << REXML::XMLDecl.new(1.0, "utf-8")
				doc << top

				# Write to file
				formatter = REXML::Formatters::Pretty.new(5)
				formatter.write(doc, f)
			end
		end
	end
end
