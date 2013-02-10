# -*- encoding: utf-8 -*-
require 'libSBML'
require 'sassy-helpers'

include LibSBML

describe Modelling::SBML do
	it 'loads files via libsbml' do 
		name = "spec/testmodels/sbml/cellcycle_gerard10_5var.xml"
		d = readSBML(name)
		d.should_not eql(nil)
	end
end