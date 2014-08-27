module ModificationCommand
	def execute
		@todos = load_todos
		perform_modification
		@todos.save
	end
end

