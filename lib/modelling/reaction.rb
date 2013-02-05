# -*- encoding: utf-8 -*-
module Modelling
	# Reaction class
	class Reaction
		attr_accessor :equation
		attr_accessor :name
		attr_accessor :in
		attr_accessor :out

		@@insts = 1

		def initialize(eqn, inp = [], outp = [])
			assert eqn.kind_of? Equation
			@name = "reaction_#{@@insts}"
			@equation = eqn

			@in = []
			@out = []
			inp.each do |v|
				raise "Inputs must be species" unless v.kind_of? Species 
				@in.push 			
			end
			outp.each do |v|
				raise "Outputs must be species" unless v.kind_of? Species 
				@out.push 
			end

			@@insts+= 1
		end
	end
end