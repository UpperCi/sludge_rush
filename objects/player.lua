Player = Physics_Collider:extend()


-- immediately blocked after jumping while against wall
function Player:start()
	-- movement physics
	self.acc = 300
	self.acc_decrease = 1.8
	self.acc_air_mod = 0.7
	self.fric = 250
	self.fric_air_mod = 0.5
	self.max_spd = 150

	self.grounded = false

	-- jump physics
	self.base_jump = 95
	self.jump_speed_increase = 0

	self.down_grav = 700
	self.up_grav = 375
	self.max_grav = 250
	self.grav_peak = 60

	-- jump even if key pressed just before landing
	self.jump_buffer = 0.1 
	self.buffer_timer = 0
	
	-- jump even if key pressed just after leaving floor
	self.coyote_time = 0.1 
	self.coyote_timer = 0

	self.jump_hold_time = 0.25
	self.jump_hold_timer = 0
	self.jump_hold_grav = 30
	self.max_dy = 0

	-- sprites
	self.front_facing = false
	self.front_facing_speed = 50
	self.flipped = false
	
	-- landing sprites
	self.squish_time = 0.07
	self.squish_timer = 0
	self.squish_treshold = 60
	self.squish_mod = 0.0005

	-- camera control
	self.h_margins = 16
	self.v_margins = 8
	self.h_mod = 0.1

	-- particles
	self.particle_time = 0.08
	self.particle_timer = 0
	self.jump_treshold = 240
	self.jump_divider = 17
	self.part_col = pal[8]

	-- misc
	self.inventory = {}
end

function Player:update_grounded()
	local gy = self.y + self.h + 0.9

	for _, coll in ipairs(self.group:get_layer("tiles")) do
		if (coll:point_in(self.x + 0.5, gy) or coll:point_in(self.x + self.w - 0.5, gy)) then
			if not self.grounded then
				if self.max_dy > self.squish_treshold then
					self.squish_timer = self.squish_time + self.squish_mod * self.max_dy
				end
				if self.max_dy > self.jump_treshold then
					local count = math.floor(self.max_dy / self.jump_divider)
					local str = self.max_dy / 70 - 0.5
					for i=1, count do
						local dir_x = math.random() - 0.5 + self.dx / 150
						local str_y = str + math.random() * 2
						self.scene:add_particle(Particle(self.part_col, str/3 + math.random() / 2, 
						self:center_x(), self.y + self.h,
						dir_x * 30, -str_y * 20, 0, 150))
					end
					self.max_dy = 0
				end
			end
			self.grounded = true
			return
		end
	end
	self.grounded = false
end

function die()
	debug:perma_log("Death!")
	self.group.paused = true
end

function Player:update_move(dt)
	local move_dir = 0
	self.front_facing = true
	if input:is_pressed('d') then
		move_dir = 1
		self.front_facing = false
	end
	if input:is_pressed('a') then
		move_dir = -1
		self.front_facing = false
	end

	if move_dir > 0 then self.flipped = false end
	if move_dir < 0 then self.flipped = true end

	if move_dir == 0 then
		local fric = self.fric
		if not self.grounded then fric = fric * self.fric_air_mod end
		self.dx = move_toward(self.dx, 0, fric * dt)
	else
		local acc = self.acc
		local acc_mod = (self.acc_decrease * math.abs(self.dx))
		if sign(self.dx) == move_dir then
			acc = acc - acc_mod
		else
			acc = acc + acc_mod
		end
		if not self.grounded then acc = acc * self.acc_air_mod end
		self.dx = move_toward(self.dx, self.max_spd * move_dir, acc * dt)
	end

	if math.abs(self.dx) > 50 and self.grounded then -- generate particles
		self.particle_timer = self.particle_timer - dt
		
		if self.particle_timer <= 0 then
			self.particle_timer = self.particle_timer + self.particle_time
			local abs_str = math.abs(self.dx) * 0.01 + 1 -- 1.5 - 2.5
			local count = math.floor(math.random() * 2 + abs_str / 2)
			for i = 1, count do
				local str = math.random() * 2 + abs_str -- 1.5 - 4.5
				local x_dir = -sign(self.dx) - 0.3 + math.random() * 0.6
				
				local p = Particle(self.part_col, str/8, self:center_x(), self.y + self.h,
				x_dir * 8 * str, -12 * str, 0, 200)
				self.scene:add_particle(p)
			end
		end
	end
	
	if math.abs(self.dx) == self.max_spd then debug:log("Max Speed!") end
end

function Player:update_camera()
	local x_diff = self.x - cam:center_x()
	local y_diff = self.y - cam:center_y()

	if math.abs(x_diff) > self.h_margins then
		if x_diff > 0 then
			cam.x = self.x - self.h_margins - gw / 2
		else
			cam.x = self.x + self.h_margins - gw / 2
		end
	end

	if math.abs(y_diff) > self.v_margins then
		if y_diff > 0 then
			cam.y = self.y - self.v_margins - gh / 2
		else
			cam.y = self.y + self.v_margins - gh / 2
		end
	end

	-- cam.offset_x = self.dx * self.h_modd
	-- debug:log(cam.offset_x)
end

function Player:update_jump(dt)
	if self.grounded then
		self.coyote_timer = self.coyote_time
	elseif self.coyote_timer > 0 then
		self.coyote_timer = self.coyote_timer - dt
	end

	if not self.grounded then
		if self.dy > self.max_dy then
			self.max_dy = self.dy
		end
	end

	if input:is_just_pressed('space') then
		self.buffer_timer = self.jump_buffer
	end
	if self.buffer_timer > 0 then
		if self.coyote_timer > 0 then
			local jump = self.base_jump + self.jump_speed_increase * math.abs(self.dx)
			self.dy = -jump
			self.buffer_timer = 0
			self.coyote_timer = 0
			self.jump_hold_timer = self.jump_hold_time
			self.max_dy = 0
		else
			self.buffer_timer = self.buffer_timer - dt
		end
	end
end

function Player:update_gravity(dt)
	if not self.grounded then
		if self.dy < self.max_grav then
			local grav = self.up_grav
			if self.dy > self.grav_peak then grav = self.down_grav end
			if self.jump_hold_timer > 0 then
				if input:is_pressed('space') then
					self.jump_hold_timer = self.jump_hold_timer - dt
					grav = self.jump_hold_grav
				else
					self.jump_hold_timer = 0
				end
			end
			self.dy = self.dy + grav * dt
			if self.dy > self.max_grav then
				self.dy = self.max_grav
			end
		end
	end
end

function Player:update(dt)
	self:update_grounded()
	self:update_gravity(dt)

	if self.squish_timer > 0 then 
		self.squish_timer = self.squish_timer - dt
	end

	self:update_move(dt)
	self:update_jump(dt)

	self.last_x = self.x
	self.last_y = self.y

	self.x = self.x + self.dx * dt
	self.y = self.y + self.dy * dt

	self:update_camera()
end

function Player:draw()
	local px = round(self.x)
	local py = round(self.y) - 2
	local spr = 0
	if not self.grounded then
		if math.abs(self.dy) < self.grav_peak then
			spr = 3
		elseif self.dy < 0 then
			spr = 1
		else
			spr = 2
		end
	elseif self.squish_timer > 0 then
		-- (x, y, sx, sy, sw, sh, flip_h, flip_v)
		local sheet_y = 0
		if self.front_facing then sheet_y = 8 end
		sheet:draw_section(px - 4, py, 32, sheet_y, 16, 8, self.flipped, false)
		return
	end
	if self.front_facing and math.abs(self.dx) < self.front_facing_speed then
		spr = spr + 10
	end
	
	sheet:draw_sprite(px, py, spr, self.flipped, false)
end

function Player:add_inventory(item)
	table.insert(self.inventory, item)
end

function Player:search_inventory(item, autodestroy)
	autodestroy = autodestroy or true
	for i, itm in ipairs(self.inventory) do
		if itm == item then
			if autodestroy then
				table.remove(self.inventory, i)
			end
			return true
		end
	end
	return false
end
