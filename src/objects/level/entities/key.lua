Key = Collider:extend()

function Key:new(group, x, y, opts)
	self:init(group, x, y, opts)
	
	self.w = 8
	self.h = 6
	self.frame = 0
	self.start_y = y - 1.99
	self.end_y = y + 1.99
	self.name = "key"
	
	self.to_start = function() 
		timer:tween(1, self, {y = self.start_y}, 'in-out-linear', self.to_end)
	end
	self.to_end = function() 
		timer:tween(1, self, {y = self.end_y}, 'in-out-linear', self.to_start)
	end
	
	self.to_start()
	self:add_mask("player")
end

function Key:collide_with(coll)
	if self:is_colliding_with(coll) then
		coll:add_inventory("key")
		self:delete()
	end
end

function Key:draw()
	sheet:draw_sprite(math.floor(self.x), math.floor(self.y), 21)
end
