class AppendCommand
	include ModificationCommand

	def initialize(arguments)
		arguments = arguments.collect {|arg| arg.to_s }
		@index = to_index(arguments[0])
		@threshold = arguments.drop(1).join("\n")
	end

	def perform_modification
		@todos.append(@index, @threshold)
	end
end

