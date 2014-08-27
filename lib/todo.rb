class Todo
	attr_reader :priority

	def initialize(line)
		process(line)
	end

	def process(line)
		@line = line.strip

		tokens = @line.split(' ')

		@done = false
		if tokens[0] == 'x'
			@done = true
			tokens.delete_at(0)
		end

		@tags = tokens.find_all {|token| token[0] == '+' }
		@lists = tokens.find_all {|token| token[0] == '@' }

		@priority = ''
		if tokens[0].length == 3 && tokens[0][0] == '(' && tokens[0][2] == ')'
			@priority = tokens[0]
			tokens.delete_at(0)
		end

		@threshold_date = nil

		token = tokens.each_with_index {|token, index|
			if _threshold?(token)
				_update_threshold(tokens, index)
				break
			end
		}

		@line = tokens.join(' ')
	end

	def _update_threshold(tokens, index)
		token = tokens[index]

		date = (token.split(':')[1] || "").downcase
		time = Time.now

		copy_threshold_to_token = proc {
			tokens[index] = "t:#{@threshold_date.year}-#{@threshold_date.month.to_s.rjust(2, '0')}-#{@threshold_date.day.to_s.rjust(2, '0')}"
		}

		days_of_the_week = {
			sun: 0, sunday: 0,
			mon: 1, monday: 1,
			tue: 2, tuesday: 2,
			wed: 3, wednesday: 3,
			thu: 4, thur: 4, thursday: 4,
			fri: 5, friday: 5,
			sat: 6, saturday: 6,
			sun: 7, sunday: 7
		}

		one_day = 86400

		if date == 'today'
			@threshold_date = Time.new(time.year, time.month, time.day)
		elsif date == 'tomorrow'
			@threshold_date = Time.new(time.year, time.month, time.day) + one_day
		elsif days_of_the_week.include?(date.to_sym)
			difference = (time.wday - days_of_the_week[date.to_sym]).abs
			difference += 7 if difference == 0
			@threshold_date = time + (one_day* difference)
		else	
			date_tokens = date.split('-').collect {|token| token.to_i }

			if date_tokens.length > 0
				date_tokens.unshift(time.month) if date_tokens.length == 1
				date_tokens.unshift(time.year) if date_tokens.length == 2

				year, month, date = date_tokens

				@threshold_date = Time.new(year, month, date)
			end
		end

		if @threshold_date
			copy_threshold_to_token.call
		end
	end

	def _threshold?(token)
 		token =~ /\bt:[a-zA-Z0-9-]+\b/
	end

	def future?
		@threshold_date && @threshold_date > Time.now
	end

	def non_regex_match(criteria)
		non_regex_matches = criteria.find_all {|criterion|
			@tags.find {|tag| tag == criterion } || @lists.find {|list| list == criterion } || @priority == criterion
		}

		return (non_regex_matches.length == criteria.length)
	end

	def regex_match(regexes)
		matching_regexes = regexes.find_all {|regex|
			Regexp.new(regex, Regexp::IGNORECASE | Regexp::EXTENDED).match(@line.to_s)
		}

		return (matching_regexes.length == regexes.length)
	end

	def matches(criteria)
		return true if criteria.length == 0
		criteria = criteria.dup

		regexes = criteria.find_all {|criterion|
			criterion.index('/') == 0 && criterion.reverse.index('/') == 0
		}

		regexes.each {|regex| criteria.delete(regex) }

		regexes = regexes.collect {|regex|
			regex[1..regex.length-2]
		}

		return non_regex_match(criteria) && regex_match(regexes)
	end

	def mark_done
		@done = true
	end

	def not_done?
		!@done
	end

	def done?
		@done
	end

	def set_priority(priority)
		priority = '' if priority.nil?
		priority = priority.strip.upcase

		priority = "(" + priority + ")" if priority.length > 0
		
		@priority = priority
	end

	def set_threshold(threshold)
		tokens = @line.split(' ')

		begin
			tokens.each_with_index {|token, index|
				if _threshold?(token)
					tokens[index] = "t:#{threshold}"
					_update_threshold(tokens, index)
					return
				end
			}

			tokens << "t:#{threshold}"
			_update_threshold(tokens, tokens.length - 1)
		ensure
			@line = tokens.join(' ')
		end
	end

	def append(addition)
		process("#{line_text} #{addition}")
	end

	def line_text
		[(@done ? 'x' : ''), @priority, @line].reject {|piece| piece == nil || piece.strip.length == 0 }.join(' ')
	end

	def to_colored_text(line_number)
		text = to_plaintext(line_number)
		case @priority
			when done?
				text.gray
			when "(A)"
				text.light_red
			when "(B)"
				text.light_yellow
			when "(C)"
				text.light_green
			when "(D)"
				text.light_blue
			else
				text
		end
	end

	def to_plaintext(line_number)
		[line_number, line_text].join("\t")
	end

	def to_file_format
		line_text
	end

	def completeable_tokens
		(@tags || []) + (@lists || [])
	end
end
