
require "sassy-helpers"
module Modelling

	# XPP in/output
	module XPPModel
		
		# read an xpp file
		def from_xpp(filename)
			lines = []
			current_line = ""
			cont = false
			# handle line continuations
			File.foreach(filename) do |line| 
				if line.match(/^(.*)\\\s*$/)
					current_line= current_line + $1
					cont = true
				else  
					current_line= current_line + line
					cont = false
				end
				if not cont
					lines.push current_line
					current_line = ""
				end
			end
			if current_line != ""
				lines.push current_line
			end

			lines = lines.map { |e| e.strip  }

			last_comment = ""
			comment_used = false
			@xpp_extra = []
			lines.each do |l|
				# xpp options -- we don't really know what to do with them but save
				# them in case someone else does
				if l.match(/^\@/)
					@xpp_extra.push l unless l == ""
					if not comment_used and last_comment != ""
						if @notes == ""
							@notes = @notes + "%%%%-cb-%%%%"
						end
						@notes = @notes + last_comment
					end
					last_comment = ""
					comment_used = false
					next
				end

				if l.match(/^(.*)\#(.*)$/)
					if comment_used
						last_comment = ""
						comment_used = false
					end
					last_comment = last_comment + $2
					l = $1
				end

				# parameters or numbers
				if l.match(/^[pn][a-zA-Z]*\s+([a-zA-Z].*)$/)
					ll = $1
					ps = ll.split(/\s*,\s*/)
					ps.each do |pl|
						if pl.strip.match(/([a-zA-Z\_][a-zA-Z\_0-9]*)\s*\=\s*([0-9eE+\-\.]+)/)
							@parameters[$1] = Parameter.new($1, $2.to_f, last_comment)
						elsif pl.strip.match(/([a-zA-Z\_][a-zA-Z\_0-9]*)/)
							@parameters[$1] = Parameter.new($1, 0.0, last_comment)
						else
							puts "[W] ignoring invalid parameter #{pl}\n"
						end
			#			puts "Par:  (#{@parameters[$1].to_s})\n"
					end
					comment_used = true
				elsif l.match(%r(d([a-zA-Z0-9\_]+)/dt\s*\=(.*)))
					pname = $1
					eqn = $2

					if !@species[pname]
						@species[pname] = Species.new(pname, 0.0)
					end

					@rules.push Rule.new(@species[pname], Equation.new(eqn, last_comment), 'rate')
					comment_used = true

			#		puts "dxdt:  (d#{@species[pname].to_s}/dt <- #{eqn})\n"
				# aux vars and shortcuts are translated to scalar rules
				elsif l.match(/^([a][a-zA-Z]*\s+)?([a-zA-Z0-9][a-zA-Z0-9]*)\s*\=\s*(.+)/)
					pname = $2
					eqn = $3
					if not @parameters[pname]
						@parameters[pname] = Parameter.new(pname, 0.0, last_comment)
					end
			#		puts "aux:  (#{@parameters[pname].to_s} <- #{eqn})\n"
					@rules.push Rule.new(@parameters[pname], Equation.new(eqn, last_comment), 'scalar')
					comment_used = true
				# initial value assignment
				elsif l.match(/^i[a-zA-Z]*\s+([a-zA-Z0-9\_]+\s*\=.*)$/)
					ll = $1
					ps = ll.split(/\s*,\s*/)
					ps.each do |pl|
						if pl.strip.match(/([a-zA-Z\_][a-zA-Z\_0-9]*)\s*\=\s*([0-9eE\+\-\.]+)/)
							@species[$1] = Species.new($1, $2.to_f)
						elsif pl.strip.match(/([a-zA-Z\_][a-zA-Z\_0-9]*)/)
							@species[$1] = Species.new($1, 0.0)
						else
							puts "[W] ignoring invalid species #{pl}\n"
						end
			#			puts "X0i:  (#{@species[$1].to_s})\n"
					end
				# x(0) = ...
				elsif l.match(/^([a-zA-Z][a-zA-Z0-9\_]*)\(0\)\s*\=(.*)/)
					@species[$1] = Species.new($1, $2.to_f)
			#		puts "X0:  (#{@species[$1].to_s})\n"
				# single parameter assignments
				elsif l.match(/^!?([a-zA-Z][a-zA-Z0-9\_]*)\s*\=\s*(.*)/)
					pname = $1
					eqn = $2
					if eqn.strip.match(/^[-+]?[0-9]*\.?[0-9]+([eE][-+]?[0-9]+)?$/)
						@parameters[$1] = Parameter.new(pname, eqn.to_f, last_comment)
			#			puts "Par:  (#{@parameters[$1].to_s})\n"
					else
						if not @parameters[pname]
							@parameters[pname] = Parameter.new(pname, 0.0, last_comment)
						end
						@rules.push Rule.new(@parameters[pname], Equation.new(eqn, last_comment), 'scalar')
			#			puts "auxa:  (#{@parameters[pname].to_s} <- #{eqn})\n"
					end
					comment_used = true
					# puts "X0:  (#{@parameters[$1].to_s})\n"
				elsif l == "done"
					break
				elsif l != ""
					puts "[W] unmatched xpp line: #{l}\n"
				end
			end
			if not comment_used and last_comment != ""
				if @notes == ""
					@notes = @notes + "%%%%-cb-%%%%"
				end
				@notes = @notes + last_comment
			end
			no = 1
			@species.each do |n, s|
				s.matlab_no=(no)
				no = no + 1				
			end

			# fix rule outputs
			@rules.each do |r|
				if @species.key? r.output.name
					r.output=(@species[r.output.name])
				elsif @parameters.key? r.output.name
					r.output=(@parameters[r.output.name])
				else
					raise "invalid rule #{r} \n"
				end
						
			end

			self.validate
		end

		def to_xpp(filename)
			
		end

	end
end