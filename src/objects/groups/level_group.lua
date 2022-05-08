Level_Group = Group:extend()


function Level_Group:start()
	-- local builder = Level_Builder(self, level_parser.levels["Hive"])
	self.chests = 0
	local builder = Level_Builder(self, level_parser.levels[current_level])
	cam:add_cinema_target({x = self.player.x / 8, y = self.player.y / 8})
	self.t = Level_Timer(self, builder.data['time'])
	self.start_paused = true
end

function Level_Group:update(dt)
	if self.start_paused then
		if cam.cinema_mode then goto skip_update end
		for _, a in ipairs({'jump', 'move_left', 'move_right'}) do
			if input:action_just_pressed(a) then self.start_paused = false end
		end
	else
		self.super.update(self, dt)
	end

	::skip_update::

	if input:action_just_pressed("ui_quit") then
		switch_scene(Menu_Scene())
	end
	if self.player.dead then
		self.scene:reset()
	end
end

function Level_Group:time_up()
	if self.chests > 0 then
		self.player:die()
	end
end

function Level_Group:check_chests()
	if self.chests <= 0 then
		timer:after(0.2, function() switch_scene(Menu_Scene()) end)
	end
end
