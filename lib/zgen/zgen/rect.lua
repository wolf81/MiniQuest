local Rect = {}

Rect.new = function(_, x, y, w, h)
	local self = {
		x = x,
		y = y,
		w = w,
		h = h,
	}

	Rect.__tostring = function()
		return 'Rect { x = ' .. x .. ', y = ' .. y .. ', w = ' .. w .. ', h = ' .. h .. ' }'
	end

	self.distanceTo = function(other)
		local x1 = self.x + self.w / 2
		local y1 = self.y + self.h / 2

		local x2 = other.x + other.w / 2
		local y2 = other.y + other.h / 2

		-- https://math.stackexchange.com/questions/2724537/finding-the-clear-spacing-distance-between-two-rectangles
		return math.max(
			math.abs(x1 - x2) - (self.w + other.w) / 2,
			math.abs(y1 - y2) - (self.h + other.h) / 2
		)
	end

	return setmetatable(self, Rect)
end

return setmetatable(Rect, { __call = Rect.new })