# -*- encoding: utf-8 -*-
module Modelling
	# Model Class
	class Model
		attr_accessor :name
		
		def initialize
			@reactions = []
			@parameters = []
			@species = []
			@name = "Model"
		end
	end
end