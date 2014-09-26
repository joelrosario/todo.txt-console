module ModificationCommand
	def for_each_index
		raise "Input was piped in and an index was specified. Don't know which to use." if @previous_input && @index

		if @previous_input && @previous_input.length > 0
			ids = @previous_input.collect {|input| input.to_i }.sort.reverse
			ids.each {|id| yield(id) }
		else
			yield(@index)
		end
	end

	def execute(previous_input)
		@previous_input = previous_input
		@todos = load_todos
		perform_modification
		@todos.save

		return {}
	end
end

