# -*- encoding: utf-8 -*-
require "modelling/xpp"
require "modelling/sassy"
require "modelling/sbml"
require "modelling/cpp"
require "modelling/vfgen"

module Modelling
	# Model Class
	class Model
		include Modelling::XPPModel
		include Modelling::SassyModel
		include Modelling::SBMLModel
		include Modelling::CPPModel
		include Modelling::VFGenModel

		# The name of the model
		attr_accessor :name

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
		
		def initialize(_name = "Model")
			@rules = []
			@parameters = {}
			@species = {}
			@name = _name
			@parser = Modelling::SassyParser.new
			@sassy_extra = ""
			@notes = ""
		end

		# validate a model, i.e. make sure we all species and parameters
		def validate
			# time always exists
			syms = { 't' => Parameter.new('t', 0) }
			idents = []
			@species.each {|k, v| syms[k] = v}
			@parameters.each do |k, v| 
				raise "Parameter and species share id: #{k}" if syms[k]
				syms[k] = v
			end
			syms.each do |k, v|
				raise "Symbol #{v.to_s} mapped to wrong id: #{k}" if v.name != k
			end

			rule_output_names = {}

			@rules.each do |rule|
				if rule_output_names.key? (rule.output.name)
					raise "Two rules for one output (#{rule.output.name})"
				end
				rule_output_names[rule.output.name] = 1

				if !syms.key?(rule.output.name)
					raise "rule #{rule.to_s} has undefined output: #{rule.output.name}"
				end

				if syms[rule.output.name] != rule.output
					raise "Inconsistent model: rule #{rule.to_s} does not output to the correct variable #{syms[rule.output.name]}"
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

			unused = idents.reject { |e| syms.key?(e) }
			unused = unused | (syms.keys.reject { |e| idents.index(e) })
			# dawn dusk and force are in every model (at least after sassy opens it)
			unused = unused.reject { |e| e == 't' || e == 'dawn' || e == 'dusk' || e == 'force' \
				|| rule_output_names.key?(e) || @species.key?(e) }
			if unused.length > 0
				puts "[W] Model has unused symbols: #{unused}\n"
			end
			self
		end

		# replace all occurrances of a parameter by its numeric value
		# and remove the parameter
		def unparameterize(pname)
			par = nil
			if @parameters.key?(pname)
				par = @parameters[pname]
			else
				raise "Parameter #{pname} not found."
			end

			@rules.each do |r|
				if r.output.name == pname
					raise "Parameter #{pname} has an output rule associated with it, cannot unparameterize."
				end
				r.equation.replace_ident(pname, "#{par.value}")
			end
			delete_symbol(pname)
		end

		# Turn a parameter into a species
		# Returns: the Species object of the newly generated species
		def parameter_to_species(pname)
			raise "Unknown parameter #{pname}" if not @parameters.key?(pname)
			matlab_number = @species.values.inject (1) { |mem, var| mem < var.matlab_no ? var.matlab_no + 1 : mem }
			raise "Species #{pname} already exists, cannot replace." if @species.key?(pname)

			p = @parameters.delete pname
			spec = Species.new(pname, p.value, matlab_number)
			@species[pname] = spec

			self.validate
			spec
		end

		# get a symbol (species or parameter) object
		def get_symbol(sym)
			if @parameters.key?(sym)
				return @parameters[sym]
			elsif @species[sym]
				return @species[sym]
			else
				raise "Symbol #{sym} not found in model"
			end
		end

		# Test if model has a certain symbol
		def has_symbol?(sym)
			@parameters.key?(sym) or @species.key?(sym)
		end

		def delete_symbol(sym)
			if @parameters.key?(sym)
				@parameters.delete sym
			elsif @species.key?(sym)
				@species.delete sym
			else
				raise "Symbol #{sym} not found in model"
			end
			self.validate
		end

		# Replace a symbol in all equations
		# Removes the object for sym and returns it
		def replace_symbol(sym, new_sym)
			syo = get_symbol(sym)
			syn = get_symbol(new_sym)

			@rules.each do |r|
				r.equation.replace_ident(sym, new_sym)
			end

			if @parameters[sym]
				@parameters.delete(sym)
			else
				@species.delete(sym)
			end

			self.validate

			syo
		end

		# Combine with another model
		def combine_with(m2)
			m2 = m2.make_copy

			@name = @name + " & " + m2.name

			max_matlab_no = @species.inject(1) do |mval, s|
				[mval, s[1].matlab_no].max
			end

			m2.species.each do |n,sp|
				if @species.key?(n)
					raise "Cannot combine models, duplicate species #{n}"
				end

				# if we have a parameter by this name, turn it into a species
				if @parameters.key?(n)
					@parameters.delete(n)
				end

				sp.matlab_no=(sp.matlab_no + max_matlab_no)
				@species[n] = sp
			end

			m2.parameters.each do |n, p|
				# We only get parameters which are not already species
				if not @species.key?(n)
					if @parameters.key?(n)
						raise "Cannot combine models, duplicate parameter #{n}"
					end
					@parameters[n] = p
				else
					puts "[N] Parameter #{n} is converted to Species\n"
				end
			end				

			# keep only rules for things which haven't been turned from parameter to species
			@rules = @rules | m2.rules.reject { |r| m2.parameters.key?(r.output.name) and @species.key?(r.output.name) }

			self.validate
		end

		# Deep copy via Marshalling
		def make_copy
			Marshal.load(Marshal.dump(self))
		end

		# add a new parameter
		def add_parameter(name, value = 0, description = "")
			if (@parameters.key? name) or (@species.key? name)
				raise "duplicate parameter #{name}"
			end

			@parameters[name] = Parameter.new(name, value, description)

			self
		end

		# add a new parameter
		def add_species(name, initvalue = 0, description = "")
			if (@parameters.key? name) or (@species.key? name)
				raise "duplicate symbol #{name}"
			end

			max_matlab_no = @species.inject(1) do |mval, s|
				[mval, s[1].matlab_no].max
			end

			@species[name] = Species.new(name, initvalue, max_matlab_no+1)

			self.validate
		end

		# Make a rule
		def add_rule(output, equation, type = "scalar", comment = "")
			@rules.push(Rule.new(get_symbol(output), Equation.new(equation, comment), type))

			self.validate
		end

		# get the rule which outputs to a symbol
		def get_symbol_output_rule(sym, type = 'scalar')
			rule = nil
			@rules.each do |r|
				if r.output.name == sym 
					if r.type != type
						raise "Conflicting rule types for symbol #{sym} : Type #{type} is needed, but a rule of type #{r.type} is present"
					end
					rule = r
					return rule
				end
			end
			rule
		end

	end
end