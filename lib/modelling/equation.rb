# -*- encoding: utf-8 -*-
module Modelling
	# Equation class
	class Equation

		# things which can't be used as identifiers
		# because they are built-in functions in MATLAB
		RESERVED_IDENTS = [
			"sin", "asin", "cos", "acos", "tan", "atan", "atan2",
			"sinh", "asinh", "cosh", "acosh", "tanh", "atanh", "floor", 
			"log", "log2", "log10", "pow", "exp", "sqrt", "pi", "abs"
			];

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
				.gsub(/\s*\(\s*/, "(")				\
				.gsub(/\s*\)/, ")")				\
				.strip
			raise "Empty formula" if @formula == ""
			@formula
		end

		# Replace an identifier
		# 
		# Replace an identifier and make sure it's a whole word
		def replace_ident(oldid, newid)
			# sometimes matches overlap, so we do it a few times
			while @formula.match(/(^|[^_A-Za-z0-9])#{Regexp.quote(oldid)}($|[^_A-Za-z0-9])/)
				@formula = @formula.gsub(/(^|[^_A-Za-z0-9])#{Regexp.quote(oldid)}($|[^_A-Za-z0-9])/) { $1 + newid + $2}
			end
			@formula
		end

		# Check if formula has an identifier
		def has_ident?(id)
			!@formula.match(/(^|[^_A-Za-z0-9])#{Regexp.quote(id)}($|[^_A-Za-z0-9])/).nil?
		end

		# add a term string
		def add(term)
			@formula = "(#{@formula}) + (#{term})"
		end

		# get all identifiers in this formula
		def all_idents
			idents = []
			@formula.scan(/([A-Za-z_][_A-Za-z0-9]*)/) {|x| idents.push($1)}
			idents.uniq.reject { |e| RESERVED_IDENTS.include? e  }
		end

		def to_s
			@formula
		end
	end
end