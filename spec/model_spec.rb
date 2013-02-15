# -*- encoding: utf-8 -*-
require "sassy-helpers"
require "ap"
describe Modelling::Model do
  it "can create a model" do
	m = Modelling::Model::new
	m.name.should eql("Model")
  end

  it 'can merge models' do
	m1 = Modelling::Model::new("Model1")
	m2 = Modelling::Model::new("Model2")

	m1.add_species('X')
	m1.add_parameter('k1_x', 1)
	m1.add_parameter('k2_x', 1)
	m1.add_rule('X', 'k1_x*X - k2_x*X')
	m2.add_species('Y', 2)
	m2.add_parameter('X', 1)
	m2.add_parameter('k2_y', 1)
	m2.add_rule('Y', 'X*Y - k2_y*Y')
	m2.add_species('Z')
	m2.add_reaction('Z', [], "k2_y")
	m2.add_reaction('Y', ['Z'], "X")

	m1.combine_with(m2)

	m1.name.should eql("Model1 & Model2")
	m1.species.length.should eql(3)
	m1.rules.length.should eql(2)
	m1.parameters.length.should eql(3)
	m1.reactions.length.should eql(2)
	m1.get_symbol('X').kind_of?(Modelling::Species).should eql(true)
	m1.get_symbol('Y').kind_of?(Modelling::Species).should eql(true)
	m1.get_symbol('k1_x').kind_of?(Modelling::Parameter).should eql(true)
	m1.get_symbol('k2_x').kind_of?(Modelling::Parameter).should eql(true)
	m1.get_symbol('k2_y').kind_of?(Modelling::Parameter).should eql(true)
  end

  it 'can convert reactions to rules' do
	m = Modelling::Model::new("Model1")
	m.add_species('X')
	m.add_species('Y')
	m.add_parameter('a', 0.04)
	m.add_parameter('b', 0.0005)
	m.add_parameter('c', 0.2)
	m.add_parameter('d', 0.1)
	
	m.add_reaction([], ['X'], "a")
	m.add_reaction([], ['Y'], "c")
	m.add_reaction(['X'], ['X', 'Y'], "-b")
	m.add_reaction(['Y'], ['X', 'Y'], "d")

	m.reactions_to_rules

	ap m

  end

end