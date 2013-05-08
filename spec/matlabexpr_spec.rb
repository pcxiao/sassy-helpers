# -*- encoding: utf-8 -*-
require "sassy-helpers"

require "modelling/parser/matlabexpression"

describe Modelling::MATLABExprParser do
	def test_parse(str)
		parser = Modelling::MATLABExprParser.new
		parser.transform_pows(str)
	end

	it "transforms some MATLAB formulas correctly" do
		# simple exp
		p = test_parse("(a+d)*(b+c)")
		p.to_s.should eql( "(a+d)*(b+c)" )

		p = test_parse("a^b")
		p.to_s.should eql( "pow(a, b)" )

		p = test_parse("a*b^2^(2-e)")
		p.to_s.should eql( "a*pow(pow(b, 2), (2-e))" )

		# bracketed exp
		p = test_parse("5+(a*b).^2")
		p.to_s.should eql( "5+pow((a*b), 2)" )

		p = test_parse("5+(a*b)^(2+d)")
		p.to_s.should eql( "5+pow((a*b), (2+d))" )

		# exp with ws
		p = test_parse("c*(a * b).^2")
		p.to_s.should eql( "c*pow((a * b), 2)" )

		p = test_parse("c * (a * b).^2+8*q")
		p.to_s.should eql( "c * pow((a * b), 2)+8*q" )

		p = test_parse("c * (a * b).^2 + 8 * q")
		p.to_s.should eql( "c * pow((a * b), 2 )+ 8 * q" )
	end

end
