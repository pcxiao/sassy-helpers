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
		
		def initialize(_name = "Model")
			@reactions = []
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

			reaction_outputs = {}

			@reactions.each do |reaction|
				reaction.in do |input|
					if !@species.key?(input.name)
						raise "reaction #{reaction.to_s} has undefined input: #{input.name}"
					end
				end
				reaction.out do |output|
					reaction_outputs[output.name] = true
					if rule_output_names.key? output.name
						raise "Reaction output #{output.name} is already defined by a rule."
					end
					if !@species.key?(output.name)
						raise "reaction #{reaction.to_s} has undefined output: #{output.name}"
					end
				end
				reaction.equation.all_idents.each do |id|
					idents = idents | [id]
					if !syms.key?(id)
						raise "rule #{rule.to_s} has undefined input: #{id}"
					end
				end
				if reaction.reversible?
					reaction.equation_backward.all_idents.each do |id|
						idents = idents | [id]
						if !syms.key?(id)
							raise "rule #{rule.to_s} has undefined input: #{id}"
						end
					end
				end
			end

			unused = idents.reject { |e| syms.key?(e) }
			unused = unused | (syms.keys.reject { |e| idents.index(e) })
			# dawn dusk and force are in every model (at least after sassy opens it)
			unused = unused.reject { |e| e == 'dawn' || e == 'dusk' || e == 'force' \
				|| rule_output_names.key?(e) || @species.key?(e) }
			if unused.length > 0
				puts "[W] Model has unused symbols: #{unused}\n"
			end
			self
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

			@reactions.each do |r|
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

			# reactions we can just concatenate
			@reactions = @reactions | m2.reactions

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

		# Make a reaction
		def add_reaction(inputs, outputs, rate, back_rate=nil, comment = "")
			if !inputs.kind_of?(Array)
				inputs = [ inputs ]
			end
			if !outputs.kind_of?(Array)
				outputs = [ outputs ]
			end
			back_eq = nil
			if back_rate
				back_eq = Equation.new(back_rate, comment)
			end
			@reactions.push(Reaction.new(inputs.map { |e| get_symbol(e) }, outputs.map { |e| get_symbol(e) }, 
				Equation.new(rate, comment), back_eq))

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

		# convert reactions to rate rules
		def reactions_to_rules
			@reactions.each do |r|
				forward_rate = r.forward_rate
				if r.reversible?
					backward_rate = r.backward_rate
				end

				r.in.each do |variable|
					orule = get_symbol_output_rule(variable.name, 'rate')
					if orule.nil?
						orule = Rule.new(variable, Equation.new("-" + backward_rate), 'rate')
						@rules.push(orule)
					else
						orule.equation.add("-" + backward_rate)
					end
				end
				output_eqn_str = forward_eqn_str
				if backward_eqn_str != ""
					output_eqn_str = output_eqn_str + "-" + backward_eqn_str
				end
				(r.out.reject { |e| r.in.include? e }).each do |variable|
					orule = get_symbol_output_rule(variable.name, 'rate')
					if orule.nil?
						orule = Rule.new(variable, Equation.new("#{variable.name}*(#{output_eqn_str})"), 'rate')
						@rules.push(orule)
					else
						orule.equation.add(output_eqn_str)
					end
				end
			end
			self.validate
		end
	end
end