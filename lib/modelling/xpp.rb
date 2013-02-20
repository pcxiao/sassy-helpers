
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
				# xpp options
				if l.match(/^(.*)\#(.*)$/)
					if comment_used
						last_comment = ""
						comment_used = false
					end
					last_comment = last_comment + $2
					l = $1
				end
				# parameters or numbers
				if l.match(/[pn][a-zA-Z]*\s+([a-zA-Z].*)$/)
					ll = $1
					ps = ll.split(/\s*,\s*/)
					ps.each do |pl|
						if pl.strip.match(/([a-zA-Z\_][a-zA-Z\_0-9]*)\s+\=\s+([0-9eE+\-\.])/
							@parameters[$1] = Parameter.new($1, $2.to_f, last_comment)
						elsif pl.strip.match(/([a-zA-Z\_][a-zA-Z\_0-9]*)/
							@parameters[$1] = Parameter.new($1, 0.0, last_comment)
						else
							puts "[W] ignoring invalid parameter #{pl}\n"
						end
					end
					comment_used = true
				# aux vars and shortcuts are translated to scalar rules
				elsif l.match(/(aux\s+)?([a-zA-Z0-9][a-zA-Z0-9]*)\s*\=\s*(.+)/)
					pname = $2
					eqn = $3
					if not @parameters[pname]
						@parameters[pname] = Parameter.new(pname, 0.0, last_comment)
					end
					@rules.push Rule.new(@parameters[pname], Equation.new(eqn, last_comment), 'scalar')
					comment_used = true
				# initial value assignment
				elsif l.match(/i[a-zA-Z]*\s+([a-zA-Z].*)$/)
					ll = $1
					ps = ll.split(/\s*,\s*/)
					ps.each do |pl|
						if pl.strip.match(/([a-zA-Z\_][a-zA-Z\_0-9]*)\s+\=\s+([0-9eE+\-\.])/
							@species[$1] = Species.new($1, $2.to_f)
						elsif pl.strip.match(/([a-zA-Z\_][a-zA-Z\_0-9]*)/
							@species[$1] = Species.new($1, 0.0)
						else
							puts "[W] ignoring invalid parameter #{pl}\n"
						end
					end
				# x(0) = ...
				elsif l.match(/([a-zA-Z][a-zA-Z0-9\_]*)\(0\)\s*\=(.*)/)
					@species[$1] = Species.new($1, $2.to_f)
				else
					if not l.match(/^@/)
						puts "[W] unsupported XPP line: #{l}\n"
					end
					@xpp_extra.push l unless l == ""
					if not comment_used and last_comment != ""
						if @notes == ""
							@notes = @notes + "%%%%-cb-%%%%"
						end
						@notes = @notes + last_comment
					end
					last_comment = ""
					comment_used = false
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

			self.validate
		end

		def to_xpp(filename)
			
		end

	end
end