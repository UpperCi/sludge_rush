Physics_Collider = Collider:extend()

function Physics_Collider:new(group, x, y, w, h, opts)
	self:init(group, x, y, opts)
	
	self.w = w
	self.h = h
	self.dx = 0
	self.dy = 0
end

function Physics_Collider:collide_with(coll)
	self:physics_collision(coll)
end
-- colliding against top when standing still against wall
function Physics_Collider:physics_collision(coll)
	local is_colliding = self:is_colliding_with(coll) and coll:is_colliding_with(self)

	if not is_colliding then return end
	
	local collision = self:coll_direction(coll, self.last_x, self.last_y)

	-- don't lose speed when clipping through corner
	local corner = 3

	if collision.x == 1 then -- left
		if collision.d > corner then self.dx = math.max(0, self.dx) end
		self.x = coll.x + coll.w
	elseif collision.y == 1 then -- top
		if collision.d > corner then self.dy = math.max(0, self.dy) end
		self.y = coll.y + coll.h
	elseif collision.x == -1 then -- right
		if collision.d > corner then self.dx = math.min(0, self.dx) end
		self.x = coll.x - self.w
	else -- bottom
		self.dy = math.min(0, self.dy)
		self.y = coll.y - self.h
	end
end
