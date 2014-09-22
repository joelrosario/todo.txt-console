class SetVariableCommand
	def initialize(arguments)
		@name, remainder = arguments[0].to_s.split('=')
		@name = @name.strip

		arguments = arguments.drop(1).unshift(remainder)
		@value = arguments.collect {|arg| arg.to_s }.join(' ')
	end

	def execute(previous_input)
		VARS[@name] = @value
	end
end

