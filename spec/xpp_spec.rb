# -*- encoding: utf-8 -*-
require "treetop"
require "sassy-helpers"
require 'tempfile'

describe Modelling::XPPModel do
	it 'loads xpp models' do 
		m = Modelling::Model.new
		m.from_xpp('spec/testmodels/ode/cellcycle_gerard10_5var.ode')
		m.species.length.should eql(5)
		m.parameters.length.should eql(24)
	end
end