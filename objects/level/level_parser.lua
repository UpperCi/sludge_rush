Level_Parser = Class:extend()


function Level_Parser:new(file_src)
	self.file_src = file_src
	self.file = love.filesystem.read(self.file_src)
	self.file_data = Json.decode(self.file)
	self:parse()
end

function Level_Parser:parse()
	self.levels = {}
	local levels = self.file_data['levels']
	for i, lvl in ipairs(levels) do
		local player = {x = 0, y = 0}
		local tiles = {w = 0, h = 0, grid = {}}
		for _, layer in ipairs(lvl['layerInstances']) do
			local layer_type = layer['__identifier']

			if layer_type == "Tiles" then
				tiles['w'] = layer['__cWid']
				tiles['h'] = layer['__cHei']
				tiles['grid'] = layer['intGridCsv']
			end
		end
		local level = {player= player, tiles= tiles}
		table.insert(self.levels, level)
	end
end
