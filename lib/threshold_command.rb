class ThresholdCommand
	include ModificationCommand

	def initialize(arguments)
		@index = to_index(arguments[0])
		@threshold = arguments[1].to_s
	end

	def perform_modification
		for_each_index {|index| @todos.set_threshold(index, @threshold) }
	end
end
