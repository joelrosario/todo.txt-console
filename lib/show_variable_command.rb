class ShowVariableCommand
	def initialize(arguments)
		@name = arguments.length > 0 ? arguments[0].to_s : nil
	end

	def display_key(key)
		puts "#{key}='#{VARS[key]}'"
	end

	def execute(previous_input)
		if @name
			display_key(@name)
		else
			VARS.keys.sort.each {|key| display_key(key) }
		end
	end
end
