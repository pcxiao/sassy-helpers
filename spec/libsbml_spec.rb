# -*- encoding: utf-8 -*-
require 'sassy-helpers'


describe Modelling::SBMLModel do
	# generic test if libSBML works
	# require 'libSBML'
	# include LibSBML
	# it 'loads files via libsbml' do 
	# 	name = "spec/testmodels/sbml/cellcycle_gerard10_5var.xml"
	# 	d = readSBML(name)
	# 	d.should_not eql(nil)
	# end

	it 'writes sbml' do
		m1 = Modelling::Model::new("Model1")
		m1.add_species('X')
		m1.add_parameter('k1_x', 1)
		m1.add_parameter('k2_x', 1)
		m1.add_rule('X', 'k1_x*X - k2_x*X', 'rate')

		file1 = Tempfile.new('model_tmp')
		p = file1.path
		file1.close
		file1.unlink   # deletes the temp file
		
		# write an ode file
		m1.to_sbml("#{p}.xml")

		modeltext = File.read("#{p}.xml").gsub("\r", "")
		modeltext.should eql( "<?xml version='1.0' encoding='UTF-8'?>\n<sbml xmlns='http://www.sbml.org/sbml/level1' level='1' version='2'>\n     <model name='Exported_Model'>\n          <listOfCompartments>\n               <compartment name='cell' volume='1'/>\n          </listOfCompartments>\n          <listOfSpecies>\n               <species name='X' initialAmount='0' compartment='cell' boundaryCondition='true'>\n                    <!-- y(2) -->\n               </species>\n          </listOfSpecies>\n          <listOfParameters>\n               <parameter name='k1_x' value='1.0'>\n                    <!--  -->\n               </parameter>\n               <parameter name='k2_x' value='1.0'>\n                    <!--  -->\n               </parameter>\n          </listOfParameters>\n          <listOfRules>\n               <speciesConcentrationRule species='X' type='rate' formula='k1_x*X - k2_x*X'>\n                    <!--  -->\n               </speciesConcentrationRule>\n          </listOfRules>\n     </model>\n</sbml>")
	end
end