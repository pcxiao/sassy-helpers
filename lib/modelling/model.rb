# Model Class
class Model
	attr_accessor :name
	
	def initialize
		@reactions = []
		@parameters = []
		@name = "Model"
	end
end