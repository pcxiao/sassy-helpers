# -*- encoding: utf-8 -*-
require "modelling/sbml"
require "modelling/sassy"
module Modelling
	# Model Class
	class Model
		include Modelling::SBMLModel
		include Modelling::SassyModel

		# The name of the model
		attr_accessor :name

		# an array of reactions
		attr_accessor :reactions

		# a hash of parameters
		attr_accessor :parameters

		# a hash of species
		attr_accessor :species

		# an array of rules
		attr_accessor :rules

		# notes about the model
		attr_accessor :notes

		# extra comment for sassy
		attr_accessor :sassy_extra
		
		def initialize
			@reactions = []
			@rules = []
			@parameters = {}
			@species = {}
			@name = "Model"
			@parser = Modelling::SassyParser.new
			@sassy_extra = ""
			@notes = ""
		end

	end
end