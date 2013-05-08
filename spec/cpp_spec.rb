# -*- encoding: utf-8 -*-
require "treetop"
require "sassy-helpers"
require 'tempfile'

describe Modelling::CPPModel do
	it 'writes cpp models' do
		Dir.mktmpdir do |dir|
			m = Modelling::Model.new
			m.from_sassy('spec/testmodels/sassy/herzel')

			ffname = File.join(dir, "herzel")
			m.to_cpp(ffname)

			modeltext = File.read(ffname + ".cpp").gsub("\r", "")
			modeltexts = File.read("spec/testmodels/cpp/herzel.cpp").gsub("\r", "")
			modeltext.should eql(modeltexts)				
		end
	end

end