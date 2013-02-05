# -*- encoding: utf-8 -*-
module Modelling
	# Equation class
	class Equation
		attr_accessor :formula
		attr_accessor :name

		@@insts = 1
		def initialize(eq = nil)
			@name = "equation_#{@@insts}"

			if eq
				@formula = self.from_matlab(eq)
			else
				@formula = "1"
			end
			@@insts += 1
		end

		# Convert from MATLAB
		#
		# Reads the formula from matlab, and does some normalising
		def from_matlab(matlab_eq)
			@formula = matlab_eq
				.gsub(/\.\.\..*([\n\r]+|$)/, "")
				.gsub(/\%.*([\n\r]+|$)/, "")
				.gsub(/\s*([\/*])\s*/, '\1')
				.gsub(/\s+/, " ")
				.strip
			raise "Empty formula" if @formula == ""
			@formula
		end

		# Replace an identifier
		# 
		# Replace an identifier and make sure it's a whole word
		def replace_ident(oldid, newid)
			@formula = @formula.gsub(/(^|[\s]|[^_A-Za-z0-9])#{Regexp.quote(oldid)}($|[\s]|[^_A-Za-z0-9])/) { $1 + newid + $2}
		end

		# Check if formula has an identifier
		def has_ident?(id)
			!@formula.match(/(^|[\s]|[^_A-Za-z0-9])#{Regexp.quote(id)}($|[\s]|[^_A-Za-z0-9])/).nil?
		end

		def to_s
			@formula
		end
	end
end