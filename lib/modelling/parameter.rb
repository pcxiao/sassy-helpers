# Parameter class
class Parameter
	# instance counter
	@@insts = 1

	def initialize
		@name = "parameter_#{@@insts}"
		@value = 0
		@desc = ""
		@@insts = @@insts + 1
	end

	# Return the parameter as an XML node
	def to_sbml
		e = REXML::Element::new 'parameter'
		e.add_attribute('name', @name)
		e.add_attribute('value', @value)
	end

end
