class DoneCommand
	include ModificationCommand

	def initialize(arguments)
		@index = to_index(arguments[0])
	end

	def perform_modification
		for_each_index {|index| @todos.mark_done(index) }
	end
end

