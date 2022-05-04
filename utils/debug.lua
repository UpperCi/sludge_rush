Debug = Class:extend()
-- allow for easily displaying variables

function Debug:new()
	self.color = {1, 1, 1, 0.8}
	self.log_text = {}
	self.log_permanent = {}
end

function Debug:log(text)
	table.insert(self.log_text, text)
end

function Debug:perma_log(text)
	table.insert(self.log_permanent, text)
end

function Debug:bool_to_string(v)
	if v then return "true" end
	return "false"
end

function Debug:draw()
	local font = font_karen
	for i, t in ipairs(self.log_text, self.log_permanent) do
		if type(t) == "boolean" then t = self:bool_to_string(t) end
		txt = love.graphics.newText(font, t)
		love.graphics.draw(txt, 2, (i - 1) * 12)
	end
	self.log_text = {}
end
