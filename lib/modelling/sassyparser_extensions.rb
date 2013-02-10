require "treetop"
module Modelling
	module Sassy
		class ParsedModelFile < Treetop::Runtime::SyntaxNode
			def validate(fun, eval, d)
				if fun[:returns].length > 1
					raise "Model function must contain only one value"
				end
				if fun[:parameters].length != 3
					raise "Model function must get exactly tree parameters"
				end
				if fun[:returns][0] != d[:dd]
					raise "Return assignment is invalid"
				end
				if eval.length != 1 || eval[0] != fun[:parameters][2]
					raise("Invalid eval statement")
				end
			end
		end

		class Equation < Treetop::Runtime::SyntaxNode
			attr_accessor :equation
			attr_accessor :comments

			def initialize
				@equation = ""
				@comments = ""
				super
			end
	end
end