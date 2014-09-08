class AddCommand
	include ModificationCommand

	def initialize(arguments)
		@task = arguments.collect {|arg| arg.to_s }.join(" ")
	end

	def perform_modification
		VARS['last_added_index'] = @todos.add(@task)
	end
end

