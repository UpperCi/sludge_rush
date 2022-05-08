-- takes list of weights as parameter, return random list item
-- {3, 1} has a 75% chance to return 1; 25% chance to return 2
function weighted_random(weights)
	local total = 0
	for _, w in ipairs(weights) do
		total = total + w
	end

	local randi = math.random() * total

	for i, w in ipairs(weights) do
		randi = randi - w
		if randi <= 0 then
			return i
		end
	end
	return #weights
end
