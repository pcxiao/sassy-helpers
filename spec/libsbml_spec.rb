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
		m1.add_rule('X', 'k1_x*X - k2_x*X')

		file1 = Tempfile.new('model_tmp')
		p = file1.path
		file1.close
		file1.unlink   # deletes the temp file
		
		# write an ode file
		m1.to_sbml("#{p}.xml")

		modeltext = File.read("#{p}.xml").gsub("\r", "")
		p modeltext
	end
end