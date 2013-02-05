# Reaction class
class Reaction
	@@insts = 1
	def initialize
		@name = "reaction_#{@@insts}"
		@initial = "0"
		@@insts+= 1
	end

end
