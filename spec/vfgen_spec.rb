# -*- encoding: utf-8 -*-
require "treetop"
require "sassy-helpers"
require 'tempfile'

describe Modelling::VFGenModel do
	it 'writes vfgen models' do
		Dir.mktmpdir do |dir|
			m = Modelling::Model.new
			m.from_sassy('spec/testmodels/sassy/herzel')

			ffname = File.join(dir, "herzel.vf")
			m.to_vfgen(ffname)

			modeltext = File.read(ffname).gsub("\r", "")
			modeltexts = File.read("spec/testmodels/vfgen/herzel.vf").gsub("\r", "")
			modeltext.should eql(modeltexts)
		end
	end

end