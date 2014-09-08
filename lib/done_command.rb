class DoneCommand
	include ModificationCommand

	def initialize(arguments)
		@index = to_index(arguments[0])
	end

	def perform_modification
		@todos.mark_done(@index)
		VARS['last_added_index'] = @index
	end
end

