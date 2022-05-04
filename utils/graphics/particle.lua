Particle = Class:extend()


function Particle:new(color, t, x, y, dx, dy, ddx, ddy)
	self.color = color
	self.t = t
	self.x = x
	self.y = y
	self.dx = dx or 0
	self.dy = dy or self.dx
	self.ddx = ddx or 0
	self.ddy = ddy or self.ddx
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
	love.grapihcs.points(self.x - 0.5, self.y - 0.5)
end
