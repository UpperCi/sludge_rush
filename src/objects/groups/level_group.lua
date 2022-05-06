Level_Group = Group:extend()


function Level_Group:start()
	local builder = Level_Builder(self, level_parser.levels["Hive"])
	self.t = Level_Timer(self, builder.data['time'])
end

function Level_Group:update(dt)
	self.super.update(self, dt)
end

function Level_Group:time_up()
	self.player:die()
end
