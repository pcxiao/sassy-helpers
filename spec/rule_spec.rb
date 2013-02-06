# -*- encoding: utf-8 -*-
require "sassy-helpers"
describe Modelling::Rule do

  it "writes rate eqn sbml" do
	s = Modelling::Species.new("A", 1.0)
	e = Modelling::Equation.new("10*x")
	p = Modelling::Rule.new(s, e)
	p.to_sbml.to_s.should eql(
		"<species compartment='default' initialAmount='1.0' name='t'/>"
		)
  end

end