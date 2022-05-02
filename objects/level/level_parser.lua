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
		local entities = {}
		local tiles = {w = 0, h = 0, grid = {}}
		for _, layer in ipairs(lvl['layerInstances']) do
			local layer_type = layer['__identifier']

			if layer_type == "Tiles" then
				tiles['w'] = layer['__cWid']
				tiles['h'] = layer['__cHei']
				tiles['grid'] = layer['intGridCsv']
			elseif layer_type == "Entities" then
				for __, e in ipairs(layer['entityInstances']) do
					local entity_type = e['__identifier']
					if entities[entity_type] == nil then
						entities[entity_type] = {}
					end
					local e_data = {x = e['__grid'][1], y = e['__grid'][2]}

					table.insert(entities[entity_type], e_data)
				end
			end
		end
		local level = {entities= entities, tiles= tiles}
		table.insert(self.levels, level)
	end
end