# -*- encoding: utf-8 -*-
module Modelling
	# Rule class
	class Rule
		# output (Species or Parameter)
		attr_accessor :output

		# the equation of the rule (equation  object)
		attr_accessor :equation

		# type: 'scalar' or 'rate'
		attr_accessor :type

		def initialize(out, eqn, type = 'scalar')
			raise "Rules must assign to species or parameters" unless (out.kind_of? Species) || (out.kind_of? Parameter)
			raise "Rules must involve an equation" unless (eqn.kind_of? Equation)
			@output = out
			@equation = eqn
			@type = type || 'scalar' 
			raise 'Rate rules are only valid for species' if !(out.kind_of? Species) && @type == 'rate'
			raise 'Rule type must be "rate" or "scalar"' if @type != 'rate' && @type != 'scalar'
		end

		def to_s
			if @type == 'rate'
				"d#{@output.name}/dt = #{@equation.to_s}"	
			else
				"#{@output.name} = #{@equation.to_s}"	
			end
		end

	end
end