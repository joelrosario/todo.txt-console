def conflict_exists
	dir = File.dirname(todo_file)
	Dir["#{dir}/*todo*.txt"].count > 1
end

def conflict_warning
	"CONFLICT FOUND!!!".light_red
end
