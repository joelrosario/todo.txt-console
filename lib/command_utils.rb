def to_index(value)
	value = value.to_s
	value = ENV_['last_added_index'] if value == '.'
	return value.to_i
end

