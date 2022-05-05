One_Way_Tile = Tile:extend()


function One_Way_Tile:new(group, x, y, w, h, spr, opts)
	self.collision_dir = {x = 0, y = 1}
	self.flip_h = false
	self.flip_v = false

	self:init(group, x, y, opts)
	
	self.w = w
	self.h = h
	self.spr = spr
end

function One_Way_Tile:draw()
	sheet:draw_sprite(self.x, self.y, self.spr, self.flip_h, self.flip_v)
end

-- TODO implement horizontal collision
function One_Way_Tile:is_colliding_with(coll)
	if self.collision_dir.y > 0 then
		if coll.last_y + coll.h > self:top() then return false end
	elseif self.collision_dir.y < 0 then
		if coll.last_y < self:bottom() then return false end
	end

	local dir = self:coll_direction(coll)

	if (dir.x == self.collision_dir.x and dir.y == self.collision_dir.y) then
		return true
	end

	return false
end
