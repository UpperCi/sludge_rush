Level_Timer = Game_Object:extend()


function Level_Timer:new(group, time)
	self.super.init(self, group, gw / 2, 0)
	self.max_time = time
	self.time_left = time
	self.font = font_karen
	self.bar_width = 80
	self.bar_height = 9
end

function Level_Timer:update(dt)
	self.time_left = self.time_left - dt
	if self.time_left < 0 then 
		self.time_left = 0
		self.group:time_up()
	end
end

function Level_Timer:draw_bar()
	-- local start_y = self.y + 2
	local start_y = self.y + 2
	local start_x = self.x - self.bar_width / 2

	set_color(pal[13])
	-- 0.5 offset because outlines assume center of pixels
	love.graphics.rectangle("line", start_x + 0.5, start_y + 0.5,
	self.bar_width - 1, self.bar_height - 1, 3, 3)

	local max_w = self.bar_width - 4
	local time_percentage = self.time_left / self.max_time
	local draw_w = math.ceil(max_w * time_percentage) - 0.5
	if draw_w < 1 then
		return
	end

	love.graphics.rectangle("fill", start_x + 2, start_y + 2,
	draw_w, self.bar_height - 4, 2, 2, 2)
end

function Level_Timer:draw()
	cam:unfocus()
	local time = math.max(0, math.ceil(self.time_left))
	self:draw_bar()
	txt = love.graphics.newText(self.font, time)
	
	for x = -1, 1 do
		for y = -1, 1 do
			love.graphics.draw(txt, self.x - self.font:getWidth(time) / 2 + x, self.y + y)
		end
	end

	set_color(pal[1])
	love.graphics.draw(txt, self.x - self.font:getWidth(time) / 2, self.y)
	reset_color()

	cam:focus()
end
