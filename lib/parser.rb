class Token
	def initialize(token)
		@token = token
	end

	def to_s; @token; end
end

class CommandParser < Parslet::Parser
	rule(:whitespace) { str(' ').repeat(1) }

	rule(:token_in_single_quoted_string) { ((str('\\').present? >> match["'"]) | match["^' "]).repeat(1) }
	rule(:single_quoted_string) { str("'") >> ((token_in_single_quoted_string >> whitespace) | token_in_single_quoted_string).repeat(1).as(:string) >> str("'") }

	rule(:token_in_double_quoted_string) { ((str('\\').present? >> match['"']) | match['^" ']).repeat(1) }
	rule(:double_quoted_string) { str('"') >> ((token_in_double_quoted_string >> whitespace) | token_in_double_quoted_string).repeat(1).as(:string) >> str('"') }

	rule(:quoted_string) { single_quoted_string | double_quoted_string }
	rule(:unquoted_word) { match['^ \'"'].repeat(1).as(:token) }

	rule(:fragment) { (quoted_string | unquoted_word) }

	rule(:commands) { ((str("set") | str("show") | str("clear") | str("ls") | str("add") | str("append") | str("app") | str("rm") | str("u") | str("do") | str("pri") | str("t")).as(:token) >> (whitespace >> ((fragment >> whitespace) | fragment).repeat(1)).maybe).as(:command) }

	root(:commands)
end

class CommandTransformation < Parslet::Transform
	rule(:token => simple(:token)) { Token.new(token.to_s) }
	rule(:string => simple(:string)) { Token.new(string.to_s) }
	rule(:command => subtree(:tree)) {
		tokens = tree.is_a?(Array) ? tree : [tree]
		command_name = tokens[0].to_s
		tokens = tokens.drop(1)

		case command_name
			when 'ls'
				ListCommand.new(tokens)
			when 'add'
				AddCommand.new(tokens)
			when 'rm'
				DeleteCommand.new(tokens)
			when 'u'
				UpdateCommand.new(tokens)
			when 'do'
				DoneCommand.new(tokens)
			when 'pri'
				SetPriorityCommand.new(tokens)
			when 'set'
				SetVariableCommand.new(tokens)
			when 'show'
				ShowVariableCommand.new(tokens)
			when 'clear'
				ClearVariableCommand.new(tokens)
			when 't'
				ThresholdCommand.new(tokens)
			when 'app'
				AppendCommand.new(tokens)
			else
				raise CommandError.new("Command #{command_name} not recognized")
		end
	}
end

def parse(data)
	parser = CommandParser.new
	tree = parser.parse(data)
	transformer = CommandTransformation.new
	return transformer.apply(tree)
end

