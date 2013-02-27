# -*- encoding: utf-8 -*-
require "rexml/document"
module Modelling
	# Parameter class
	class Parameter
		attr_accessor :name
		attr_accessor :value
		attr_accessor :description

		# instance counter
		@@insts = 1

		def initialize(name = nil, value = nil, desc = nil)
			@name = name || "parameter_#{@@insts}"
			@value = (value || "0.0").to_f
			@description = desc || ""
			@@insts = @@insts + 1
		end

		# initialize from a line in a sassy par file
		#
		# === Example:
		#
		#     Parameter.new.to_par("k  1  \"The value of parameter k\"").to_s
		#
		#     gives
		#
		# 	  Parameter 'k' = 1 (The value of parameter k)
		#
		def from_par(str)
			pa = str.split(/\s+/)
			if pa.length < 2
				raise "Failed to create a parameter from input."
			end
			@name = pa[0]
			@value = pa[1].to_f
			@description = str.sub(/\s*[^\s]+\s+[^\s]+\s*/, "").sub(/^[\\"']+\s*/, "").sub(/\s*[\\"']+$/, "") || ""
		end

		# Return the parameter as an XML node
		def to_sbml
			e = REXML::Element::new 'parameter'
			e.add_attribute('name', @name)
			e.add_attribute('value', @value)
			e
		end

		# Make a parameter line
		def to_par
			"#{@name}    #{@value}   \"#{@description}\"\n"
		end

		# Make a string
		def to_s
			"Parameter '#{@name}' = #{@value} " + (@description.length > 0 ? "(#{@description})" : "")
		end

	end
end