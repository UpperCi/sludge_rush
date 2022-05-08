Scene = Class:extend()


function Scene:new()
	self.groups = {}
	self.particles = {}
	self.paused = false
end

function Scene:start()

end

function Scene:debug_update(dt)

end

function Scene:update(dt)
	self:debug_update(dt)
	if self.paused then
		return
	end

	for _, g in ipairs(self.groups) do
		g:update(dt)
	end

	for _, p in ipairs(self.particles) do
		p:update(dt)
	end
end

function Scene:draw()
	for _, g in ipairs(self.groups) do
		g:draw()
	end

	for i, p in ipairs(self.particles) do
		p:draw()
		if p.on_collision ~= nil then
			for _, coll in ipairs(p.group:get_layer(p.mask)) do
				if coll:point_in(p.x, p.y) then
					p:on_collision()
				end	
			end
		end
		if p.t <= 0 then
			table.remove(self.particles, i)
		end
	end
	reset_color()
end

function Scene:reset()
	self:new()
	self:start()
end

function Scene:add_group(g)
	table.insert(self.groups, g)
	g:start()
end

function Scene:add_particle(p)
	table.insert(self.particles, p)
end
