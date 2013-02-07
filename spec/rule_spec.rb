# -*- encoding: utf-8 -*-
require "sassy-helpers"
describe Modelling::Rule do

  it "writes rate eqn sbml" do
	s = Modelling::Species.new("A", 1.0)
	e = Modelling::Equation.new("10*x")
	p = Modelling::Rule.new(s, e, 'rate')
	p.to_sbml.to_s.should eql(
		"<speciesConcentrationRule formula='10*x' species='A' type='rate'/>"
		)
  end

  it "writes scalar eqn sbml" do
	s = Modelling::Species.new("A", 1.0)
	e = Modelling::Equation.new("10*x")
	p = Modelling::Rule.new(s, e)
	p.to_sbml.to_s.should eql(
		"<speciesConcentrationRule formula='10*x' species='A' type='scalar'/>"
		)
  end

  it "writes scalar parameter eqn sbml" do
	s = Modelling::Parameter.new("A", 1.0)
	e = Modelling::Equation.new("10*x")
	p = Modelling::Rule.new(s, e)
	p.to_sbml.to_s.should eql(
		"<parameterRule formula='10*x' name='A' type='scalar'/>"
		)
  end

  it "makes a string" do
	s = Modelling::Species.new("A", 1.0)
	e = Modelling::Equation.new("10*x")
	p = Modelling::Rule.new(s, e)
	p.to_s.should eql(
		"A = 10*x"
		)
  end

  it "makes a rate string" do
	s = Modelling::Species.new("A", 1.0)
	e = Modelling::Equation.new("10*x")
	p = Modelling::Rule.new(s, e, 'rate')
	p.to_s.should eql(
		"dA/dt = 10*x"
		)
  end

end