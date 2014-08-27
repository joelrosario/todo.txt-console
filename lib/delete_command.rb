class DeleteCommand
	include ModificationCommand

	def initialize(arguments)
		@index = to_index(arguments[0])
	end

	def perform_modification
		@todos.delete(@index)
	end
end

