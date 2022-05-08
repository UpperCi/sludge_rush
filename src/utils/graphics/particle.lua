Particle = Class:extend()


function Particle:new(color, t, x, y, dx, dy, ddx, ddy)
	self.color = color
	self.t = t
	self.x = x
	self.y = y
	self.dx = dx or 0
	self.dy = dy or 0
	self.ddx = ddx or 0
	self.ddy = ddy or self.ddx
	self.on_collision = nil
	self.mask = nil
	self.collision_group = nil
end

function Particle:update(dt)
	self.t = self.t - dt
	self.x = self.x + self.dx * dt
	self.y = self.y + self.dy * dt
	self.dx = self.dx + self.ddx * dt
	self.dy = self.dy + self.ddy * dt
end

function Particle:draw()
	set_color(self.color)
	love.graphics.points(self.x - 0.5, self.y - 0.5)
end

function particle_remove(self)
	self.t = 0
end

function Particle:add_collision(group, after, mask)
	self.mask = mask or "tiles"
	self.group = group
	self.on_collision = after
end
