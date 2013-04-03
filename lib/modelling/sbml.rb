require "rexml/document"

module Modelling	
	module SBMLModel
		def to_sbml(name)
			File.open("#{name}", "w") do |file|
				doc = REXML::Document.new 

				top = REXML::Element.new "sbml"
				top.add_attributes ({ 
					"xmlns" => "http://www.sbml.org/sbml/level1",
					"level" => "1",
					"version" => "2"
				})
				
				doc.add_element top
				formatter = REXML::Formatters::Default.new( 5 )
				formatter.write(doc, file)
    		end
		end
	end
end