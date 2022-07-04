local Rect = {}
Rect.__index = Rect

function Rect:new(x, y, w, h)
	return setmetatable({
		x = x,
		y = y,
		w = w,
		h = h,
	}, Rect)
end

function Rect:__tostring()
	return 'Rect { x = ' .. x .. ', y = ' .. y .. ', w = ' .. w .. ', h = ' .. h .. ' }'
end

function Rect:distanceTo(other)
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

function Rect:inflate(distance)
	return Rect(self.x - distance, self.y - distance, self.w + (distance * 2), self.h + (distance * 2))
end

function Rect:contains(x, y)
	return x >= self.x and x < self.x + self.w and y >= self.y and y < self.y + self.h
end

function Rect:each()
	local x = self.x - 1
	local y = self.y

	return function()
		while y < self.y + self.h do
			x = x + 1

			if x >= self.x + self.w then
				x = self.x
				y = y + 1
			end

			if y < self.y + self.h then
				return x, y
			end
		end

		return nil
	end
end

function Rect:__tostring()
	return 'Rect { x = ' .. self.x .. ', y = ' .. self.y .. ', w = ' .. self.w .. ', h = ' .. self.h .. ' }' 
end

return setmetatable(Rect, { __call = Rect.new })