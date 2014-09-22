class ClearVariableCommand
	def initialize(arguments)
		@name = arguments[0].to_s
	end

	def execute(previous_input)
		VARS.delete(@name)
	end
end

