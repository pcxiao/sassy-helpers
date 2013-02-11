# -*- encoding: utf-8 -*-
require "treetop"
require "sassy-helpers"

describe Modelling::SassyModel do
	it 'loads sassy models' do 
		m = Modelling::Model.new
		m.from_matlab('spec/testmodels/sassy/herzel')
	end
end