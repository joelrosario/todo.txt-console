def execute_command(line)
	begin
		command = parse(line)
		command.execute
	rescue CommandError => ce
		puts "Command error: #{ce.message}"
	rescue Parslet::ParseFailed => pe
		puts "Parse error: #{pe.message}"
	rescue Object => e
		puts e.class.to_s + ": " + e.message
		puts e.backtrace
	end
end

def run_repl
	loop {
		prompt = ">> "
		prompt = "CONFLICT".light_red + prompt if conflict_exists
		line = Readline.readline(prompt, true)
		line = line.strip if line

		break if line == 'quit' || line == nil

		execute_command(line) if line.length > 0
	}
end
