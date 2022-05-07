Menu_Scene = Scene:extend()

function Menu_Scene:start()
	self.levels = {"Oasis", "Hive", "Level_2"}
	self.current_level = 2
	self.level_button_seperation = 28
	self.level_button_height = 17
	self.level_button_width = 72
	self.offset = self.current_level
	self.level_switch_time = 0.75
	self.current_level_anim = nil
	self.font = font_jinxed

	for i, lvl in ipairs(self.levels) do
		if lvl == current_level then self.current_level = i end
	end
	self.offset = self.current_level
end

function Menu_Scene:update(dt)
	if input:action_just_pressed("ui_down") then
		if self.current_level_anim then timer:cancel(self.current_level_anim) end
		self.current_level = self.current_level + 1
		if self.current_level > #self.levels then self.current_level = 1 end
		self.current_level_anim = timer:tween(self.level_switch_time, self, 
		{offset = self.current_level}, 'out-elastic')
	end
	if input:action_just_pressed("ui_up") then
		if self.current_level_anim then timer:cancel(self.current_level_anim) end
		self.current_level = self.current_level - 1
		if self.current_level < 1 then self.current_level = #self.levels end
		self.current_level_anim = timer:tween(self.level_switch_time, self, 
		{offset = self.current_level}, 'out-elastic')
	end
	if input:action_just_pressed("ui_confirm") then
		current_level = self.levels[self.current_level]
		switch_scene(Level_Scene())
		cam:start_cinematic()
	end

	-- self.offset = self.current_level
end


function Menu_Scene:draw_level_button(text, pos)
	local rel_pos = pos - self.offset
	local y_start = gh / 2 - self.level_button_height / 2
	y_start = round(y_start + rel_pos * self.level_button_seperation)
	local x_start = gw / 2 - self.level_button_width / 2

	set_color(pal[10])
	if pos == self.current_level then set_color(pal[11]) end
	
	love.graphics.rectangle("fill", x_start, y_start, 
	self.level_button_width, self.level_button_height, 7, 7)

	-- local opacity = 1 - math.max(0, (math.abs(rel_pos) - 0.4) * 2)
	local opacity = 0
	if pos == self.current_level then opacity = 1 end

	set_color({pal[13][1], pal[13][2], pal[13][3], opacity})
	local margin = 1.5
	local mod = math.max(0, math.min(10, rel_pos * 30))

	love.graphics.rectangle("line", x_start - margin - mod, y_start - margin - mod, 
	self.level_button_width + margin * 2 + mod * 2,
	self.level_button_height + margin * 2 + mod * 2, 8 + mod / 2, 8 + mod / 2)

	
	local draw_txt = love.graphics.newText(self.font, text)
	local draw_x = gw / 2 - self.font:getWidth(text) / 2
	local draw_y = y_start + (self.level_button_height - self.font:getHeight(text)) / 2 + 1
	set_color(pal[1])
	for dx = -1, 1 do
		for dy = -1, 1 do
			love.graphics.draw(draw_txt, draw_x + dx, draw_y + dy)
		end
	end
	set_color(pal[13])
	love.graphics.draw(draw_txt, draw_x, draw_y)

	reset_color()
end

function Menu_Scene:draw()
	self.super.draw(self)
	for i, l in ipairs(self.levels) do
		self:draw_level_button(l, i)
	end
end
