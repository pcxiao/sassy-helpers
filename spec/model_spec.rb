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

	m1.combine_with(m2)

	m1.name.should eql("Model1 & Model2")
	m1.species.length.should eql(3)
	m1.rules.length.should eql(2)
	m1.parameters.length.should eql(3)
	m1.get_symbol('X').kind_of?(Modelling::Species).should eql(true)
	m1.get_symbol('Y').kind_of?(Modelling::Species).should eql(true)
	m1.get_symbol('k1_x').kind_of?(Modelling::Parameter).should eql(true)
	m1.get_symbol('k2_x').kind_of?(Modelling::Parameter).should eql(true)
	m1.get_symbol('k2_y').kind_of?(Modelling::Parameter).should eql(true)
  end

end