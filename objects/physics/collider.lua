Collider = Game_Object:extend()


function Collider:new(group, x, y, w, h, opts)
	self:init(group, x, y, opts)
	
	self.w = w
	self.h = h
	self.last_x = 0
	self.lasy_y = 0
end

function Collider:collide_with(coll)
	print("empty collision!")
end

function Collider:center_x()
	return self.x + (self.w / 2)
end

function Collider:center_y()
	return self.y + (self.h / 2)
end

-- Minkowski sum (?)
function Collider:minkowski(coll, c_x, c_y)
	c_x = c_x or self:center_x()
	c_y = c_y or self:center_y()
	-- half of length / height
	local mw = 0.5 * (self.w + coll.w);
	local mh = 0.5 * (self.h + coll.h);
	-- center coordinates
	local mdx = c_x - coll:center_x();
	local mdy = c_y - coll:center_y();

	return mw, mh, mdx, mdy
end

function Collider:is_colliding_with(coll)
	local mw, mh, mdx, mdy = self:minkowski(coll)

	return (math.abs(mdx) <= mw and math.abs(mdy) <= mh)
end

function Collider:coll_direction(coll, start_x, start_y)
	-- backtrace steps to prevent incorrect collision at high speeds
	if start_x then
		local _dx = self.x - start_x
		local _dy = self.y - start_y
		local speed = get_length(_dx, _dy)
		
		local dir_x = _dx / speed
		local dir_y = _dy / speed

		local speed_step = 0.1
		local steps = math.ceil(speed / speed_step)

		for i = 1, steps do
			local dist = (i - 1) * speed_step
			local percentage = dist / speed
			local current_x = start_x + _dx * dist + (self.w / 2)
			local current_y = start_y + _dy * dist + (self.h / 2)

			local coll_dir = self:calc_coll_dir(
				self:minkowski(coll, current_x, current_y))
			if coll_dir then return coll_dir end
		end
	end

	return self:calc_coll_dir(self:minkowski(coll))
end

function Collider:calc_coll_dir(mw, mh, mdx, mdy)
	if (math.abs(mdx) <= mw and math.abs(mdy) <= mh) then
		local diff_x = math.abs(math.abs(mdx) - mw)
		local diff_y = math.abs(math.abs(mdy) - mh)
		local diff = math.abs(math.abs(mdx) - mw + math.abs(mdy) - mh)
		local wy = mw * mdy;
		local hx = mh * mdx;
		
		if (wy > hx) then
			if (wy > -hx) then
				-- bottom
				return {x = 0, y = 1, d = diff, dx = diff_x, dy = diff_y}
			else
				-- left
				return {x = -1, y = 0, d = diff, dx = diff_x, dy = diff_y}
			end
		else
			if (wy > -hx) then
				-- right
				return {x = 1, y = 0, d = diff, dx = diff_x, dy = diff_y}
			else
				-- top
				return {x = 0, y = -1, d = diff, dx = diff_x, dy = diff_y}
			end
		end
	end
	return false
end

function Collider:left()
	return math.min(self.x, self.x + self.w)
end

function Collider:right()
	return math.max(self.x, self.x + self.w)
end

function Collider:top()
	return math.min(self.y, self.y + self.h)
end

function Collider:bottom()
	return math.max(self.y, self.y + self.h)
end

function Collider:point_in(x, y)
	return (x >= self:left() and x <= self:right() and
			y >= self:top() and y <= self:bottom())
end

function Game_Object:add_mask(mask)
	self.group:add_to_mask(self, mask)
end

function Game_Object:add_layer(layer)
	self.group:add_to_layer(self, layer)
end
