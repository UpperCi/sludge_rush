Tile = Collider:extend()


function Tile:new(group, x, y, w, h, spr, opts)
	self.flip_h = false
	self.flip_v = false

	self:init(group, x, y, opts)
	
	self.w = w
	self.h = h
	self.spr = spr
	self.name = "tile"
end

function Tile:draw()
	sheet:draw_sprite(self.x, self.y, self.spr, self.flip_h, self.flip_v)
end
