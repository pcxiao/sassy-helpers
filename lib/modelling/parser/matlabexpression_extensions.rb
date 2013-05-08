# -*- encoding: utf-8 -*- 

module Modelling
	module MatlabPowTransform
		def transform_pows(str)
			parser = Modelling::MATLABExprParser.new
			q = self.parse(str)
			if !q
			  raise "parser.failure_reason: l:#{parser.failure_line}, c:#{parser.failure_column}"
			end
			# p q

			# puts "Before: #{str}\n"
			
			rsteps = 1
			pel = q.find_pow_element()
			while pel
				# replace one pel
				if pel[:next].interval.exclude_end?
					fullrange = (pel[:previous].interval.first)...(pel[:next].interval.last)
				else
					fullrange = (pel[:previous].interval.first)..(pel[:next].interval.last)
				end
				beforest = str[fullrange].clone
				str[fullrange] = "pow(#{pel[:previous].text_value}, #{pel[:next].text_value})"
				# puts "Replacement step #{rsteps} for #{beforest} range #{fullrange.to_s}: #{str}\n"

				q = self.parse(str)
				if !q
				  raise "failed: #{str} -- parser.failure_reason: l:#{parser.failure_line}, c:#{parser.failure_column}"
				end
				pel = q.find_pow_element()
				rsteps = rsteps + 1
			end

			# puts "After: #{str}\n"

			str
		end
	end

	module MatlabExpression
		@previous_atomic = nil
		@previous_expop = nil

		def find_pow_element()
			@previous_expop = nil
			@previous_atomic = nil
			_find_pow_elements(self)
		end

		def _find_pow_elements(el)
			pels = nil
			if el.elements
				el.elements.each do |el|
					if @previous_expop.nil?
						pels = _find_pow_elements(el)
						if pels
							return (pels)
						end
					end
					if el.respond_to?('atomic') and el.atomic
						if @previous_expop
							pels = {:previous => @previous_atomic, :op => @previous_expop, :next => el,}
							return (pels)
						end
						@previous_atomic = el
					end
					if el.respond_to?('expop') and el.expop 
						@previous_expop = el;
					end
					if not @previous_expop.nil?
						pels = _find_pow_elements(el)
						if pels
							return (pels)
						end
					end
				end
			end
			pels
		end
	end
end
