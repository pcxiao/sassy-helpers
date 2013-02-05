# -*- encoding: utf-8 -*-
require "sassy-helpers"
describe Modelling::Parameter do

  it "can parse par lines" do
	p = Modelling::Parameter.new
	p.from_par("k  1  \"The value of parameter k\"")
	p.to_s.should eql(
		"Parameter 'k' = 1.0 (The value of parameter k)"
		)
  end

  it "writes sbml" do
	p = Modelling::Parameter.new("t", 1.0, "Value of t")
	p.to_sbml.to_s.should eql(
		"<parameter name='t' value='1.0'/>"
		)
  end

end