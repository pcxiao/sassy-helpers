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

		# an array of parameters
		attr_accessor :parameters

		# an array of species
		attr_accessor :species

		# an array of rules
		attr_accessor :rules
		
		def initialize
			@reactions = []
			@rules = []
			@parameters = []
			@species = []
			@name = "Model"
			@parser = Modelling::SassyParser.new
		end

	end
end