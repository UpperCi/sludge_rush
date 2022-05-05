-- function camera:attach(x,y,w,h, noclip)
	-- x,y = x or 0, y or 0
	-- w,h = w or love.graphics.getWidth(), h or love.graphics.getHeight()
-- 
	-- self._sx,self._sy,self._sw,self._sh = love.graphics.getScissor() -- used to remember previous scissor
	-- if not noclip then
		-- love.graphics.setScissor(x,y,w,h)
	-- end
-- 
	-- local cx,cy = x+w/2, y+h/2
	-- love.graphics.push()
	-- love.graphics.translate(cx, cy)
	-- love.graphics.scale(self.scale)
	-- love.graphics.rotate(self.rot)
	-- love.graphics.translate(-self.x, -self.y)
-- end

Camera = Class:extend()

function Camera:new(x, y, w, h)
	self.x = x or 0
	self.y = y or 0
	self.target_x = 0
	self.target_y = 0
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
end

function Camera:center_x()
	return self.x + gw / 2
end

function Camera:center_y()
	return self.y + gh / 2
end

function Camera:update(dt)
	if self.x < self.limit_left then
		self.x = self.limit_left
	end
	if self.target_x < self.limit_left then
		self.target_x = self.limit_left
	end
	if self.x > self.limit_right then
		self.x = self.limit_right
	end
	if self.target_x > self.limit_right then
		self.target_x = self.limit_right
	end
	if self.y < self.limit_top then
		self.y = self.limit_top
	end
	if self.target_y < self.limit_top then
		self.target_y = self.limit_top
	end
	if self.y > self.limit_bottom then
		self.y = self.limit_bottom
	end
	if self.target_y > self.limit_bottom then
		self.target_y = self.limit_bottom
	end
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
