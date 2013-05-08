# -*- encoding: utf-8 -*-
require "treetop"
require "modelling/parser/matlabexpression"

module Modelling
	module CPPModel
		# Write CPP file which gives the model equations
		#
		def to_cpp(basepath)
			File.open("#{basepath}.cpp", "w") do |f|
				mname = basepath.gsub(%r((.*[\\/])?([^/\\]+)$), "\\2")

				f.puts <<-END
/**
 * @file #{mname}.cpp
 * 
 * Model implementation for Model '#{mname}'
 *
 */

#include <cmath>

struct Model_#{mname} {
	Model_#{mname}() {
		reset_parameters();
	}

	void reset_parameters() {
END
				@parameters.each do |n, p|
					f.puts("\t\t#{n} = #{p.value};\n")
				end
				f.puts <<-END
	}

	void initial_state(double * y) {
END

				mno = 1
				@species = (@species.sort {|x,y| x[1].matlab_no <=> y[1].matlab_no })
				@species.each do |n, sp|
					f.puts("\t\ty[#{sp.matlab_no}] = #{sp.initial};\n")
					# redo matlab numbers
					sp.matlab_no=(mno)
					mno = mno + 1
				end
				f.puts <<-END
	}
END
				@rules.each do |rule|
					if rule.type == 'rate' and rule.output.kind_of?(Parameter)
						raise "Parameters cannot have rate rules"
					end
				end
				f.puts <<-END

	// #{@notes.gsub("%%%%-cb-%%%%", "\n// ")}
	double * operator() (double t, const double * y, double * dydt) {
END
				species_eqns = []
				orig_species_eqns = []
				species_comments = []
				((@rules.reject { |e| e.output.kind_of? Parameter}) \
					.sort {|x,y| x.output.matlab_no <=> y.output.matlab_no}) \
				    .each do |rule|
						eq = rule.equation.clone
						@species.each do |n,s|
							eq.replace_ident(s.name, "y[#{s.matlab_no-1}]")
						end
						species_comments[rule.output.matlab_no] = eq.comments.gsub("%%%%-cb-%%%%", " ")
						orig_species_eqns[rule.output.matlab_no] = eq.to_s
						species_eqns[rule.output.matlab_no] = _eqn_matlab_to_pow(eq.to_s)
					end

				(@rules.reject { |e| e.output.kind_of? Species}) \
				    .each do |rule|
						eq = rule.equation.clone
						@species.each do |n,s|
							eq.replace_ident(s.name, "y(#{s.matlab_no})")
						end

						orig_eq = eq.to_s
						translated_eq =  _eqn_matlab_to_pow(orig_eq)
						f.puts ("\t\t// " + eq.comments.gsub("%%%%-cb-%%%%", " ") + "\n" \
							+ "\t\t// Original: #{orig_eq}"  \
							+ "#{rule.output.name} = #{translated_eq};\n")
					end

				f.puts("\n")

				@species.each do |n,s|
					if species_comments[s.matlab_no]
						f.puts("\t\t// #{species_comments[s.matlab_no]}\n")
					end
					f.puts("\t\t// Original: dydt[#{s.matlab_no-1}] = #{orig_species_eqns[s.matlab_no]}\n")
					if species_eqns[s.matlab_no]
						f.puts("\t\tdydt[#{s.matlab_no-1}] = #{species_eqns[s.matlab_no]} ;\n")
					else
						puts("[W] Species #{s.name} has no rate rule, setting to zero.")
						f.puts("\t\tdydt[#{s.matlab_no-1}] = 0;\n")
					end
				end
				f.puts <<-END
		return dydt;
	}

END
				f.puts("\tenum { NSPECIES = #{mno} };\n\n")
				@parameters.each do |n, p|
					f.puts("\tdouble #{n};\n")
				end
				f.puts <<-END
};
END
			end
		end

		# Convert matlab notation for powers (a^b) to c++ notation (pow(a,b))
		def _eqn_matlab_to_pow(eqstr)
			eqstr = eqstr.clone
			if not @exprparser
				@exprparser = Modelling::MATLABExprParser.new
			end
			qs = @exprparser.transform_pows(eqstr)
			qs
		end

	end
end
