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

	it 'writes xpp models' do
		m = Modelling::Model.new
		m.from_sassy('spec/testmodels/sassy/mammalian')

		# make a temp file
		file1 = Tempfile.new('model_tmp')
		p = file1.path
		file1.close
		file1.unlink   # deletes the temp file
		
		# write an ode file
		m.to_xpp("#{p}.ode")

		modeltext = File.read("#{p}.ode").gsub("\r", "")
		modeltext.should eql(File.read("spec/testmodels/ode/mammalian.ode").gsub("\r", ""))
	end

	it 'parses various ode files' do
		files = Dir["spec/testmodels/ode/*.ode"]
		files.each do |variable|
			m = Modelling::Model.new
			m.from_xpp(variable)
			m.species.length.should be > 0
		end
	end

end