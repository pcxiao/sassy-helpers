# -*- encoding: utf-8 -*-
require "modelling/sbml"
require "modelling/sassy"
module Modelling
	# Model Class
	class Model
		include Modelling::SBMLModel
		include Modelling::SassyModel

		# The name of the model
		attr_accessor :name

		# an array of reactions
		attr_accessor :reactions

		# a hash of parameters
		attr_accessor :parameters

		# a hash of species
		attr_accessor :species

		# an array of rules
		attr_accessor :rules

		# notes about the model
		attr_accessor :notes

		# extra comment for sassy
		attr_accessor :sassy_extra
		
		def initialize
			@reactions = []
			@rules = []
			@parameters = {}
			@species = {}
			@name = "Model"
			@parser = Modelling::SassyParser.new
			@sassy_extra = ""
			@notes = ""
		end

		# validate a model, i.e. make sure we all species and parameters
		def validate
			syms = {}
			idents = []
			@species.each {|k, v| syms[k] = v}
			@parameters.each do |k, v| 
				raise "Parameter and species share id: #{k}" if syms[k]
				syms[k] = v
			end
			syms.each do |k, v|
				raise "Symbol #{v.to_s} mapped to wrong id: #{k}" if v.name != k
			end
			@rules.each do |rule|
				if !syms.key?(rule.output.name)
					raise "rule #{rule.to_s} has undefined output: #{rule.output.name}"
				end
				rule.equation.all_idents.each do |id|
					idents = idents | [id]
					if !syms.key?(id)
						raise "rule #{rule.to_s} has undefined input: #{id}"
					# else
					# 	puts "#{id} used in #{rule.to_s}\n"
					end
				end
			end
			@reactions.each do |reaction|
				reaction.in do |input|
					if !@species.key?(input.name)
						raise "reaction #{reaction.to_s} has undefined input: #{input.name}"
					end
				end
				reaction.out do |output|
					if !@species.key?(output.name)
						raise "reaction #{reaction.to_s} has undefined output: #{output.name}"
					end
				end
				reaction.all_idents.each do |id|
					idents = idents | [id]
					if !syms.key?(id)
						raise "rule #{rule.to_s} has undefined input: #{id}"
					end
				end

			end

			unused = idents.reject { |e| syms.key?(e)  }
			unused = unused | (syms.keys.reject { |e| idents.index(e) })
			if unused.length > 0
				puts "[W] Model has unused symbols: #{unused}\n"
			end
		end

	end
end