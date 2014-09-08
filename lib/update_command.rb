class UpdateCommand
	include ModificationCommand

	def initialize(arguments)
		@index = to_index(arguments[0])
		@task = arguments.drop(1).collect {|arg| arg.to_s }.join(" ")
	end

	def perform_modification
		@todos.update(@index, @task)
		VARS['last_added_index'] = @index
	end
end

