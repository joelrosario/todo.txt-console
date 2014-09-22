def todo_file
	todo_file = ENV_['todo_file']
end

def load_todos
	TodoList.new(todo_file)
end

class TodoList
	def initialize(filename)
		@todos = File.read(filename).split("\n").collect {|line| Todo.new(line.strip) }
		@filename = filename
	end

	def to_plaintext(&should_include)
		to_text(should_include) {|todo, line_number| todo.to_plaintext(line_number) }
	end

	def to_colored_text(&should_include)
		to_text(should_include) {|todo, line_number| todo.to_colored_text(line_number) }
	end

	def todos_with_id
		@todos.zip((0..(@todos.length - 1)))
	end

	def to_text(should_include, &text_formatter)
		todos = todos_with_id.collect {|todo, line_number|
			{todo: todo, line_number: line_number}
		}

		todos = todos.find_all {|data|
			todo = data[:todo]
			todo.not_done? && should_include.call(todo)
		}

		todos.sort {|data1, data2|
			p1 = data1[:todo].priority.strip
			p2 = data2[:todo].priority.strip

			if (p1.length == p2.length && p2.length == 0) || (p1 == p2)
				0
			elsif p1.length == 0
				1
			elsif p2.length == 0
				-1
			else
				p1 <=> p2
			end
		}.collect {|data|
			todo = data[:todo]
			line_number = data[:line_number]

			text_formatter.call(todo, line_number)
		}.join("\n")
	end

	def to_file_format
		@todos.collect {|todo| todo.to_file_format }.join("\n")
	end

	def add(task)
		@todos << Todo.new(task)
		return @todos.length - 1
	end

	def delete(index)
		@todos.delete_at(index)
	end

	def update(index, task)
		@todos[index] = Todo.new(task)
	end

	def set_priority(index, priority)
		@todos[index].set_priority(priority)
	end

	def mark_done(index)
		@todos[index].mark_done
	end

	def set_threshold(index, threshold)
		@todos[index].set_threshold(threshold)
	end

	def append(index, addition)
		@todos[index].append(addition)
	end

	def save
		File.open(@filename, "w") {|f| f.write(to_file_format) }
	end

	def completeable_tokens
		@todos.collect {|todo| todo.completeable_tokens }.flatten.uniq
	end

	def get_ids
		todos_with_id.collect {|todo, id| if yield(todo) then id else nil end }.compact
	end
end
