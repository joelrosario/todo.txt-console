class ClearVariableCommand
	def initialize(arguments)
		@name = arguments[0].to_s
	end

	def execute
		VARS.delete(@name)
	end
end

