Collider = Game_Object:extend()


function Collider:new(group, x, y, w, h, opts)
	self:init(group, x, y, opts)
	
	self.w = w
	self.h = h
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
function Collider:minkowski(coll)
	-- half of length / height
	local mw = 0.5 * (self.w + coll.w);
	local mh = 0.5 * (self.h + coll.h);
	-- center coordinates
	local mdx = self:center_x() - coll:center_x();
	local mdy = self:center_y() - coll:center_y();

	return mw, mh, mdx, mdy
end

function Collider:is_colliding_with(coll)
	local mw, mh, mdx, mdy = self:minkowski(coll)

	return (math.abs(mdx) <= mw and math.abs(mdy) <= mh)
end

function Collider:coll_direction(coll)
	local mw, mh, mdx, mdy = self:minkowski(coll)

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
