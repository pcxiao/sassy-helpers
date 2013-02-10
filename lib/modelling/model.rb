# -*- encoding: utf-8 -*-
require "treetop"
require "modelling/parser/sassyparser"
module Modelling
	# Model Class
	class Model
		attr_accessor :name
		
		def initialize
			@reactions = []
			@rules = []
			@parameters = []
			@species = []
			@name = "Model"
			@parser = Modelling::SassyParser.new
		end

		# read from sassy/matlab format
		def from_matlab(code, parameters, spec_init = nil)
		end
	end
end