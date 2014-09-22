class ListCommand
	def initialize(arguments)
		@arguments = VARS['filter'].split(' ') if VARS['filter']
		arguments = arguments.collect {|arg| arg.to_s }

		if arguments.find {|arg| arg.length == 1 }
			@arguments = @arguments.reject {|filter| filter.length == 1 }
		end

		@arguments += arguments
	end

	def accepted(todo, acceptance_checks)
		accepted = acceptance_checks.find {|check| check.call(todo) == false } ? false : true
		return accepted
	end

	def execute(previous_input)
		todos = load_todos
		acceptance_checks = []

		if VARS['future_tasks'] == 'hidden'
			acceptance_checks << proc {|todo| !todo.future? }
		end

		acceptance_checks << proc {|todo| todo.matches(@arguments) }

		return {
			display: todos.to_colored_text {|todo| accepted(todo, acceptance_checks) },
			data: todos.get_ids {|todo| accepted(todo, acceptance_checks) }
		}
	end
end

