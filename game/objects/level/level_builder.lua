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
		local opts = {}
		local tile_class = Tile

		if t == 1 then -- grass
			sprite = 39 + weighted_random({40, 3, 3, 1})
			if grid[i - w] ~= 1 then
				sprite = sprite - 10
			elseif grid[i + w] ~= 1 then
				sprite = sprite - 6
			end

		elseif t == 2 then -- stone
			sprite = 43 + weighted_random({2, 2, 1, 2})
			
		elseif t == 3 then -- bg_dirt
			sprite = 49 + weighted_random({12, 1, 1, 1})
			layer = "background"
		
		elseif t == 4 then -- tree
			layer = "background"
			if grid[i - 1] ~= 4 and grid[i + 1] ~= 4 then -- stump
				if grid[i + w] == 4 then
					sprite = 61
				else -- bottom part of stump
					sprite = 60
				end
			else -- foliage
				tile_class = One_Way_Tile
				layer = "tiles"
				if grid[i - 1] ~= 4 then -- left
					opts['flip_h'] = true
					x = x + 1
				end
				if grid[i - 1] ~= 4 or grid[i + 1] ~= 4 then -- sides
					sprite = 63
					x = x - 0.5
				else -- center
					sprite = 62
				end
			end
		end

		tile = tile_class(self.group, x * self.size, y * self.size,
			self.size, self.size, sprite, opts)
		tile:add_layer(layer)

		::skip_tile::
	end
end

function Level_Builder:build_entities()
	local entities = self.data['entities']
	for t, e_list in pairs(entities) do
		local e = e_list[1]
		local ex = e.x * self.size
		local ey = e.y * self.size
		if t == 'Player' then
			local p = Player(self.group, ex, ey + 1, 8, 6)
			p:add_mask("tiles")
			p:add_layer("player")
			cam.x = p.x - gw / 2
			cam.y = p.y - gh / 2
			self.group.player = p
		
		elseif t == "Coin" then
			local c = Coin(self.group, ex, ey)
		
		elseif t == "Key" then
			local c = Key(self.group, ex, ey)
		
		elseif t == "Chest" then
			local c = Chest(self.group, ex, ey)
		end
	end
end
