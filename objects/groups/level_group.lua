Level_Group = Group:extend()


function Level_Group:start()
	local builder = Level_Builder(self, level_parser.levels[1])
	self.t = Level_Timer(self, builder.data['time'])
end
