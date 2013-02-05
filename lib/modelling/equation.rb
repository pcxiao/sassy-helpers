# Equation class
class Equation
	@@insts = 1
	def initialize
		@name = "equation_#{@@insts}"
		@formula = "1"
		@@insts += 1
	end
end
