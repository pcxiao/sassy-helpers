# -*- encoding: utf-8 -*-
require "sassy-helpers"
describe Modelling::Rule do

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