class SetPriorityCommand
	include ModificationCommand

	def initialize(arguments)
		if arguments.length == 2
			@index = to_index(arguments[0])
			@priority = arguments[1].to_s.upcase
		else
			@priority = arguments[0].to_s.upcase
		end
	end

	def perform_modification
		for_each_index {|index| @todos.set_priority(index, @priority) }
	end
end

