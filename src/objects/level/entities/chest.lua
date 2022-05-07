Chest = Collider:extend()

function Chest:new(group, x, y, opts)
	self:init(group, x, y, opts)
	
	self.w = 8
	self.h = 6
	self.frame = 0
	self.start_y = y - 1.99
	self.end_y = y + 1.99
	
	self:add_mask("player")
end

function Chest:collide_with(coll)
	if self:is_colliding_with(coll) then
		if coll:search_inventory("key") then
			self.group.chests = self.group.chests - 1
			self.group:check_chests()
			self:delete()
		end
	end
end

function Chest:draw()
	sheet:draw_sprite(math.floor(self.x), math.floor(self.y), 20)
end
