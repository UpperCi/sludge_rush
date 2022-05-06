Input = Class:extend()

function Input:new()
	self.just_pressed = {}
	self.pressed = {}
	self.bindings = {}
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

function Input:action_pressed(a)
	if self.bindings[a] == nil then return false end
	for _, k in ipairs(self.bindings[a]) do
		if self:key_pressed(k) then return true end
	end
	return false
end

function Input:action_just_pressed(a)
	if self.bindings[a] == nil then return false end
	for _, k in ipairs(self.bindings[a]) do
		if self:key_just_pressed(k) then return true end
	end
	return false
end

function Input:key_pressed(k)
	for i, p in ipairs(self.pressed) do
		if p == k then
			return true
		end
	end
	return false	
end

function Input:key_just_pressed(k)
	for i, p in ipairs(self.just_pressed) do
		if p == k then
			return true
		end
	end
	return false
end

function Input:bind(binding, keys)
	if self.bindings[binding] == nil then self.bindings[binding] = {} end
	for _, k in ipairs(keys) do
		table.insert(self.bindings[binding], k)
	end
end
