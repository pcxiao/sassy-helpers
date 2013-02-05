# -*- encoding: utf-8 -*-
require "sassy-helpers"
describe Modelling::Species do

  it "writes sbml" do
	p = Modelling::Species.new("t", 1.0)
	p.to_sbml.to_s.should eql(
		"<species compartment='default' initialAmount='1.0' name='t'/>"
		)
  end

end