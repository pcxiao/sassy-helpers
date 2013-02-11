# -*- encoding: utf-8 -*-
module Modelling
	# Equation class
	class Equation
		attr_accessor :formula
		attr_accessor :name
		attr_accessor :comments

		@@insts = 1
		def initialize(eq = nil, comment = "")
			@name = "equation_#{@@insts}"

			if eq
				@formula = self.from_matlab(eq)
			else
				@formula = "1"
			end
			@comments = comment
			@@insts += 1
		end

		# Convert from MATLAB
		#
		# Reads the formula from matlab, and does some normalising
		def from_matlab(matlab_eq)
			@formula = matlab_eq.gsub(/\.\.\..*([\n\r]+|$)/, "")	\
				.gsub(/\%.*([\n\r]+|$)/, "")	\
				.gsub(/\s*([\/*])\s*/, '\1')	\
				.gsub(/\s+/, " ")				\
				.gsub(/\(\s+/, "(")				\
				.gsub(/\s+\)/, ")")				\
				.strip
			raise "Empty formula" if @formula == ""
			@formula
		end

		# Replace an identifier
		# 
		# Replace an identifier and make sure it's a whole word
		def replace_ident(oldid, newid)
			@formula = @formula.gsub(/(^|[^_A-Za-z0-9])#{Regexp.quote(oldid)}($|[^_A-Za-z0-9])/) { $1 + newid + $2}
		end

		# Check if formula has an identifier
		def has_ident?(id)
			!@formula.match(/(^|[^_A-Za-z0-9])#{Regexp.quote(id)}($|[^_A-Za-z0-9])/).nil?
		end

		# get all identifiers in this formula
		def all_idents
			idents = []
			@formula.scan(/(^|[^_A-Za-z0-9])([A-Za-z_][_A-Za-z0-9]*)($|[^_A-Za-z0-9])/) {|x| idents.push($2)}
			idents.uniq
		end

		def to_s
			@formula
		end
	end
end