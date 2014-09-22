class ListCommand
	def initialize(arguments)
		@arguments = VARS['filter'].split(' ') if VARS['filter']
		arguments = arguments.collect {|arg| arg.to_s }
		arguments.each {|arg| if arg[0] == '(' then @arguments = @arguments.reject {|filter| filter[0] == '(' } end }
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

		puts todos.to_colored_text {|todo| accepted(todo, acceptance_checks) }
		return todos.get_ids {|todo| accepted(todo, acceptance_checks) }
	end
end

