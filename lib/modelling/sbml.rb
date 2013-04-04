require "rexml/document"

module Modelling	
	module SBMLModel

		# write out model as SBML
		def to_sbml(name)
			File.open("#{name}", "w") do |file|
				doc = REXML::Document.new 

				top = REXML::Element.new "sbml"
				top.add_attributes ({ 
					"xmlns" => "http://www.sbml.org/sbml/level1",
					"level" => "1",
					"version" => "2"
				})

				model = REXML::Element.new("model")
				model.add_attribute('name', 'Exported_Model')
				
				if @notes.length > 0
					nel = REXML::Elements.new("notes")
					nel << REXML::Text.new("#{@notes.gsub("%%%%-cb-%%%%", "\n# ")}")
					model << nel
				end

				lc = REXML::Element.new "listOfCompartments"
				cm = REXML::Element.new "compartment"
				cm.add_attributes({ "name" => "cell", "volume" => "1"})
				lc << cm
				model << lc

				ls = REXML::Element.new "listOfSpecies"
				@species.each do |n,spec|
					s = REXML::Element.new "species"
					pcc = "y(#{spec.matlab_no})"
					s << REXML::Comment.new(_comment_repl(pcc))
					s.add_attributes({
						"name" => spec.name,
						"initialAmount" => spec.initial,
						"compartment" => "cell",
						"boundaryCondition" => "true"
						})
					ls << s
				end
				model << ls

				lp = REXML::Element.new "listOfParameters"
				@parameters.each do |n,par|
					p = REXML::Element.new "parameter"
					if par.description
						pcc = par.description.gsub("%%%%-cb-%%%%", "\n# ")
						p << REXML::Comment.new(_comment_repl(pcc))
					end
					p.add_attributes({
						"name" => par.name,
						"value" => par.value
						})
					lp << p
				end
				model << lp

				lr = REXML::Element.new "listOfRules"
				@rules.each do |r|
					rt = "speciesConcentrationRule"
					re = REXML::Element.new rt
					eqc = r.equation.comments.gsub("%%%%-cb-%%%%", "\n# ")
					re << REXML::Comment.new(_comment_repl(eqc))
					re.add_attributes({
						"species" => r.output.name,
						"type" => r.type,
						"formula" => r.equation.to_s
						})
					lr << re
				end
				model << lr

				top << model

				doc << REXML::XMLDecl.new(1.0, "utf-8")
				doc << top

				# Write to file
				formatter = REXML::Formatters::Pretty.new(5)
				formatter.write(doc, file)
    		end
		end

		# Convert notes to comments
		def _comment_repl(value)
			" " + value.gsub(/\-\-+/, "") + " "
		end
	end
end