Spritesheet = Class:extend()


function Spritesheet:new(src, w, h)
	self.src = src
	self.img = love.graphics.newImage(self.src)
	self.tile_w = w or 0
	self.tile_h = h or w
	self.columns = round(self.img:getWidth() / self.tile_w)
end

function Spritesheet:draw_section(x, y, sx, sy, sw, sh, flip_h, flip_v)
	local scale_x = 1
	local scale_y = 1
	if flip_h == true then
		scale_x = -1
		x = x + sw
	end
	local scale_y = 1
	if flip_v == true then
		scale_y = -1
		y = y + sh
	end
	local q = love.graphics.newQuad(sx, sy, sw, sh, self.img:getDimensions())
	love.graphics.draw(self.img, q, x, y, 0, scale_x, scale_y)
end

function Spritesheet:draw_sprite(x, y, spr, flip_h, flip_v)
	local sx = (spr % self.columns) * self.tile_w
	local sy = math.floor(spr / self.columns) * self.tile_h
	self:draw_section(x, y, sx, sy, self.tile_w, self.tile_h, flip_h, flip_v)
end
