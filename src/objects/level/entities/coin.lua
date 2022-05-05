Coin = Collider:extend()

function Coin:new(group, x, y, opts)
	self:init(group, x + 1, y + 1, opts)
	
	self.w = 6
	self.h = 6
	self.frame = 0
	self.animation = timer:every(0.1, function() self:next_frame() end)
	self:add_mask("player")
	self.name = "coin"
end

function Coin:next_frame()
	self.frame = (self.frame + 1) % 4
end

function Coin:collide_with(coll)
	if self:is_colliding_with(coll) then
		timer:cancel(self.animation)
		self:delete()
	end
end

function Coin:draw()
	local current_frame = self.frame
	if current_frame == 3 then current_frame = 1 end
	sheet:draw_sprite(self.x - 1, self.y - 1, 22 + current_frame)
end
