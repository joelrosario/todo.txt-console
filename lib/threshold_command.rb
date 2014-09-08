class ThresholdCommand
	include ModificationCommand

	def initialize(arguments)
		@index = to_index(arguments[0])
		@threshold = arguments[1].to_s
	end

	def perform_modification
		@todos.set_threshold(@index, @threshold)
		VARS['last_added_index'] = @index
	end
end
