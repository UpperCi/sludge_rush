Level_Builder = Class:extend()


function Level_Builder:new(group, data)
	self.group = group
	self.data = data
	self.size = sheet.tile_w

	self:build_tiles()
	self:build_entities()
end

function Level_Builder:build_tiles()
	local tiles = self.data['tiles']
	local w = tiles['w']
	local h = tiles['h']
	cam.limit_left = 8
	cam.limit_right = w * 8 - gw - 8
	cam.limit_top = 8
	cam.limit_bottom = h * 8 - gh - 8
	local grid = tiles['grid']
	for i, t in ipairs(grid) do
		if t == 0 then goto skip_tile end
		local x = (i - 1) % w
		local y = math.floor((i - 1) / w)
		local sprite = 99
		local layer = "tiles"

		if t == 1 then -- grass
			sprite = 9 + weighted_random({9, 1, 1, 1})
			if grid[i - w] == 0 then
				sprite = sprite - 10
			elseif grid[i + w] == 0 then
				sprite = sprite - 6
			end
		end

		tile = Tile(self.group, x * self.size, y * self.size,
			self.size, self.size, sprite)
		tile:add_layer(layer)

		::skip_tile::
	end
end

function Level_Builder:build_entities()
	local entities = self.data['entities']
	for t, e_list in pairs(entities) do
		if t == 'Player' then
			local e = e_list[1]
			local p = Player(self.group, e.x * self.size, e.y * self.size + 1, 8, 6)
			p:add_mask("tiles")
			cam.x = p.x - gw / 2
			cam.y = p.y - gh / 2
		end
	end
end
