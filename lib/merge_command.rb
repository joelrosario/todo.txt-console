class MergeCommand
	def initialize(*arguments)
	end

	def execute
		diff_command = VARS['diff_command']
		system("#{diff_command} -D test todo\ \(conflicted\ copy\).txt todo.txt | grep -v '#ifdef' | grep -v '#ifndef' | grep -v '#else' | grep -v '#endif'")
	end
end

