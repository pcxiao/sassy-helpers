# -*- encoding: utf-8 -*-

require "rexml/document"

module Modelling
	# Species class
	class Species
		attr_accessor :matlab_no
		attr_accessor :name

		@@insts = 1
		def initialize(name, initial = nil, matlab_no = nil)
			@name = name || "species_#{@@insts}"
			@initial = initial || 0.0
			if matlab_no.nil?
				@matlab_no = @@insts
			else
				@matlab_no = matlab_no
			end
			@@insts+= 1
		end

		# write SBML
		def to_sbml
			e = REXML::Element::new 'species'
			e.add_attribute('name', @name)
			e.add_attribute('initialAmount', @initial)
			e.add_attribute('compartment', 'default')
			e
		end

		def to_s
			"#{@name} (init: #{@initial})"
		end
	end
end