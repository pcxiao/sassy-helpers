# -*- encoding: utf-8 -*-
module Modelling
	# Rule class
	class Rule
		attr_reader :output
		attr_reader :equation
		attr_accessor :type

		def initialize(out, eqn, type = nil)
			raise "Rules must assign to species or parameters" unless (out.kind_of? Species) || (out.kind_of? Parameter)
			raise "Rules must involve an equation" unless (eqn.kind_of? Equation)
			@output = out
			@equation = eqn
			@type = 'scalar' || type
		end

		# write SBML
		def to_sbml
			case @type
			when "scalar"
				
			end
		end

		def to_s
			out.name + " = " + eqn.to_s			
		end

	end
end