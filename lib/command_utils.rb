def to_index(value)
	value = value.to_s
	value = VARS['last_added_index'] if value == '.'
	return value.to_i
end

