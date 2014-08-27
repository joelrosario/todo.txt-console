def get_completeable_tokens
	todos = load_todos
	todos.completeable_tokens
end

Readline.basic_word_break_characters = Readline.basic_word_break_characters.delete("@")

Readline.completion_proc = proc {|incomplete_token|
	get_completeable_tokens.find_all {|token| token.index(incomplete_token) == 0 }
}

