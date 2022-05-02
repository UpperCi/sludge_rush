Scene = Class:extend()


function Scene:new()
	self.groups = {}
	self.paused = false
end

function Scene:update(dt)
	if self.paused then
		return
	end

	for _, g in ipairs(self.groups) do
		g:update(dt)
	end
end

function Scene:draw()
	for _, g in ipairs(self.groups) do
		g:draw()
	end
end

function Scene:add_group(g)
	table.insert(self.groups, g)
	g:start()
end
