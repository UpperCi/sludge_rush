Game_Object = Class:extend()

function Game_Object:new(group, x, y, opts)
	self:init(group, x, y, opts)
end

function Game_Object:init(group, x, y, opts)
	local opts = opts or {}
	if opts then
		for k, v in pairs(opts) do
			self[k] = v
		end
	end
	
	self.id = uuid()
	self.group = group
	self.x = x
	self.y = y
	self.group:add_game_object(self)
	self.scene = self.group.scene
	self.name = "game_object"
end

function Game_Object:start()
	
end

function Game_Object:update(dt)
	
end

function Game_Object:draw()
	
end

function Game_Object:delete()
	self.group:remove_object(self.id)
end
