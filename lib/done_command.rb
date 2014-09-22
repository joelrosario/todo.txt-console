class DoneCommand
	include ModificationCommand

	def initialize(arguments)
		@index = (arguments && arguments.length > 0) ? to_index(arguments[0]) : nil
	end

	def perform_modification
		for_each_index {|index| @todos.mark_done(index) }
	end
end

