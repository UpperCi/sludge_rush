Group = Class:extend()

function Group:new(scene)
	self.game_objects = {}
	self.id = uuid()
	self.scene = scene
	self.layers = {}
	self.masks = {}
	self.paused = false
	
	self.scene:add_group(self)
end

function Group:start()
	
end

function Group:collide_with_layer(obj, layer)
	for __, coll in ipairs(self.layers[layer]) do
		obj:collide_with(coll)
	end
end

function Group:update_collision()
	for mask, arr in pairs(self.masks) do
		if self.layers[mask] ~= nil then
			for _, obj in ipairs(self.masks[mask]) do
				self:collide_with_layer(obj, mask)
			end
		end
	end
end

function Group:update(dt)
	if self.paused then return end
	for _, go in ipairs(self.game_objects) do
		go:update(dt)
	end
	self:update_collision()
end

function Group:draw()
	for _, go in ipairs(self.game_objects) do
		go:draw()
	end
end

function Group:add_game_object(go)
	table.insert(self.game_objects, go)
	go:start()
end

function Group:add_to_layer(go, layer)
	if self.layers[layer] == nil then
		self.layers[layer] = {}
	end
	table.insert(self.layers[layer], go)
end

function Group:add_to_mask(go, mask)
	if self.masks[mask] == nil then
		self.masks[mask] = {}
	end
	table.insert(self.masks[mask], go)
end

function Group:get_layer(layer)
	if self.layers[layer] ~= nil then return self.layers[layer] end
	return {}
end

function Group:remove_object(obj_uuid)
	for i, obj in ipairs(self.game_objects) do
		if obj.id == obj_uuid then
			table.remove(self.game_objects, i)
			return
		end
	end
end
