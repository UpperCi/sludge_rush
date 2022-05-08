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
		local time = 0
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
					for ___, v in ipairs(e['fieldInstances']) do
						e_data[v.__identifier] = v.__value
					end

					table.insert(entities[entity_type], e_data)
				end
			end
		end

		for _, field in ipairs(lvl['fieldInstances']) do
			local field_type = field['__identifier']

			if field_type == "Time" then
				time = field['__value']
			end
		end
		local level = {name= lvl['identifier'], id=i, entities= entities, tiles= tiles, time= time}
		self.levels[lvl['identifier']] = level
	end
end
