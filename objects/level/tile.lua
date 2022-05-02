Tile = Collider:extend()


function Tile:new(group, x, y, w, h, spr, opts)
	self:init(group, x, y, opts)
	
	self.w = w
	self.h = h
	self.spr = spr
end

function Tile:draw()
	sheet:draw_sprite(self.x, self.y, self.spr)
end
