Camera = Class:extend()

function Camera:new(x, y, w, h)
	self.x = x or 0
	self.y = y or 0
	self.limit_left = 0
	self.limit_right = gw
	self.limit_top = 0
	self.limit_bottom = 0
	self.offset_x = 0
	self.offset_y = 0
	self.w = w or love.graphics.getWidth()
	self.h = h or love.graphics.getHeight()
	self.scale = 1
	self.rot = 0

	self.cinema_targets = {}
	self.cinema_mode = false
	self.cinema_tween = nil
end

function Camera:add_cinema_target(point)
	local px = self:clamp_x(point.x * 8 - gw / 2)
	local py = self:clamp_y(point.y * 8 - gh / 2)
	table.insert(self.cinema_targets, {x = px, y = py})
end

function Camera:cancel_cinematic()
	self.cinema_mode = false
	if self.cinema_tween ~= nil then timer:cancel(self.cinema_tween) end
end	

function Camera:start_cinematic()
	self.target_index = 1
	self.cinema_mode = true
	self.x = self.cinema_targets[1].x
	self.y = self.cinema_targets[1].y
	table.remove(self.cinema_targets, 1)
	self.cinema_tween = timer:after(0.8, function() self:next_cinematic() end)
end

function Camera:next_cinematic()
	if #self.cinema_targets <= 0 then
		self.cinema_mode = false
		return
	end

	local next_target = self.cinema_targets[1]
	table.remove(self.cinema_targets, 1)

	local next_time = 0.4
	if #self.cinema_targets <= 0 then next_time = 0 end
	self.cinema_tween = timer:tween(2, self, {x = next_target.x, y = next_target.y}, 'in-out-quad', 
	function() self.cinema_tween = timer:after(next_time, function() self:next_cinematic() end) end)
end

function Camera:center_x()
	return self.x + gw / 2
end

function Camera:center_y()
	return self.y + gh / 2
end

function Camera:clamp_x(x)
	if x < self.limit_left then
		x = self.limit_left
	end
	if x > self.limit_right then
		x = self.limit_right
	end
	return x
end

function Camera:clamp_y(y)
	if y < self.limit_top then
		y = self.limit_top
	end
	if y > self.limit_bottom then
		y = self.limit_bottom
	end
	return y
end

function Camera:update(dt)
	self.x = self:clamp_x(self.x)
	self.y = self:clamp_y(self.y)
end

function Camera:focus()
	love.graphics.setScissor(0, 0, self.w, self.h)

	love.graphics.push()
	love.graphics.scale(self.scale)
	love.graphics.rotate(self.rot)
	love.graphics.translate(round(-self.x - self.offset_x), round(-self.y - self.offset_y))
end

function Camera:unfocus()
	love.graphics.pop()
end
