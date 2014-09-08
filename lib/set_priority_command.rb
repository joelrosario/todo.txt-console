class SetPriorityCommand
	include ModificationCommand

	def initialize(arguments)
		@index = to_index(arguments[0])
		@priority = arguments[1].to_s.upcase
	end

	def perform_modification
		@todos.set_priority(@index, @priority)
		VARS['last_added_index'] = @index
	end
end

