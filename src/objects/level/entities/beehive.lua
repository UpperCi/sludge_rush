Beehive = Collider:extend()

function Beehive:new(group, x, y, flip_h, opts)
	self:init(group, x, y + 4, opts)
	
	self.w = 8
	self.h = 80
	self:add_mask("player")
	self.name = "beehive"
	self.particle_timer = 0
	self.particle_time = 0.18
	self.flip_h = flip_h or false
end

function Beehive:collide_with(coll)
		if self:is_colliding_with(coll) then
			coll.sticky = true
			debug:log("honey!")
		end
end

function Beehive:update(dt)
	self.particle_timer = self.particle_timer - dt
	if self.particle_timer <= 0 then
		local part_x = self.x + 3
		if self.flip_h then part_x = part_x + 2 end
		self.particle_timer = self.particle_timer + self.particle_time
		local p = Particle(pal[5], 1, part_x + math.random(), self.y + 5,
		math.random() * 3 - 1.5, (math.random() + 3) * 10, 0, 20)
		self.scene:add_particle(p)
	end	
end

function Beehive:draw()
	sheet:draw_sprite(self.x, self.y, 26, self.flip_h)
end
