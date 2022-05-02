function move_toward(n, n_end, delta)
	local diff = n_end - n
	local move_distance = math.min(math.abs(delta), math.abs(diff))
	local move = move_distance * sign(diff)
	return n + move
end

function sign(n)
	return (n > 0 and 1) or (n == 0 and 0) or -1
end
