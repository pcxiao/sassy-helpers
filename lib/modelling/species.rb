class Species
	@@insts = 1
	def initialize
		@name = "species_#{@@insts}"
		@initial = "0"
		@@insts+= 1
	end
end