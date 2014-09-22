def to_index(value)
	return nil if value == nil

	value = value.to_s
	value = VARS['last_added_index'] if value == '.'
	return value.to_i
end

