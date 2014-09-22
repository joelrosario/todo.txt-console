class DeleteCommand
	include ModificationCommand

	def initialize(arguments)
		@index = to_index(arguments[0])
	end

	def perform_modification
		for_each_index {|index| puts index.inspect; @todos.delete(index) }
	end
end

