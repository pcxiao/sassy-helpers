# -*- encoding: utf-8 -*-
require "sassy-helpers"
describe Modelling::Equation do

  it "normalises MATLAB" do
	p = Modelling::Equation.new("a * y ...\n + b % linear eqn")
	p.to_s.should eql(
		"a*y + b"
		)
  end

  it "replaces identifiers" do
	p = Modelling::Equation.new("ay * cyc ...\n + y % linear eqn")
	p.replace_ident('y', 'x').to_s.should eql(
		"ay*cyc + x"
		)
  end

  it "finds identifiers" do
	p = Modelling::Equation.new("(1-transcription)*V_3max*((1 + g*(y_1/k_t3)^v)/(1 + ((y_18 + y_19)/k_i3)^w*(y_1/k_t3)^v + (y_1/k_t3)^v)) - d_y3*y_2")
	q = p.all_idents.sort
	q.should eql([
		"transcription",
		"V_3max",
		"g",
		"y_1",
		"k_t3",
		"v",
		"w",
		"y_18",
		"y_19",
		"k_i3",
		"d_y3",
		"y_2"
		].sort)
  end

  it "recognises identifiers" do
	p = Modelling::Equation.new("ay * cyc ...\n + y % linear eqn")
	p.has_ident?('y').should eql(true)
	p.has_ident?('a').should eql(false)
  end

  it "replaces species" do
	p = Modelling::Equation.new("ay * y(1) ...\n + cy(2) % linear eqn")
	p.replace_ident('y(1)', 'x').to_s.should eql(
		"ay*x + cy(2)"
		)
  end

end