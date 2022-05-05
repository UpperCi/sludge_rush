Input = Class:extend()

function Input:new()
	self.just_pressed = {}
	self.pressed = {}
end

function Input:update()
	self.just_pressed = {}
end

function Input:on_key_down(k)
	table.insert(self.pressed, k)
	table.insert(self.just_pressed, k)
end

function Input:on_key_up(k)
	local new_pressed = {}
	
	for i, p in pairs(self.pressed) do
		if p ~= k then
			table.insert(new_pressed, p)
		end
	end

	self.pressed = new_pressed
end

function Input:is_pressed(k)
	for i, p in ipairs(self.pressed) do
		if p == k then
			return true
		end
	end
	return false	
end

function Input:is_just_pressed(k)
	for i, p in ipairs(self.just_pressed) do
		if p == k then
			return true
		end
	end
	return false
end
