# -*- encoding: utf-8 -*-
module Modelling
	# Reaction class
	class Reaction
		# forward rate equation
		attr_accessor :equation

		# backward rate equation
		attr_accessor :equation_backward

		# reaction name (optional)
		attr_accessor :name
		
		# list of inputs/lhs species
		attr_accessor :in

		# list of outputs/rhs species
		attr_accessor :out

		# hash of stochiometries (nil is interpreted as 1)
		attr_accessor :in_stochiometry

		# hash of stochiometries (nil is interpreted as 1)
		attr_accessor :out_stochiometry

		@@insts = 1

		def initialize(inp, outp, eqn, eqn_b = nil)
			if not eqn.kind_of? Equation
				raise "Reaction rates must be specified as Equation object, got #{eqn.to_s}"
			end
			if (not eqn_b.nil?) and (not eqn_b.kind_of? Equation)
				raise "Reaction rates must be specified as Equation object, got #{eqn_b.to_s}"
			end

			@name = "reaction_#{@@insts}"
			@equation = eqn
			@equation_backward = eqn_b

			@in_stochiometry = {}
			@out_stochiometry = {}

			@in = []
			@out = []
			inp.each do |v|
				raise "Inputs must be species" unless v.kind_of? Species 
				@in.push v
			end
			outp.each do |v|
				raise "Outputs must be species" unless v.kind_of? Species 
				@out.push v
			end

			if @in.length == 0 and @out.length == 0
				raise "Reaction without inputs or outputs"
			end

			@@insts+= 1
		end

		# return true if the reaction is reversible (i.e. has a backward rate)
		def reversible?
			not @equation_backward.nil?
		end

		# return the forward rate equation as a string
		def forward_rate
			result = "#{@equation.to_s}"
			if @in.length > 0
				inp_rate = (@in.map { |e| e.name }).join("*")
				result = "(#{result})*#{inp_rate}"
			end

			result
		end

		# return the backward rate equation as a string
		def backward_rate
			result = "0"
			if reversible?
				result = "#{@equation_backward.to_s}"
				if @out.length > 0
					out_rate = (@out.map { |e| e.name }).join("*")
					result = "(#{result})*#{out_rate}"
				end
			end
			result
		end

	end
end