local PATH = (...):match("(.-)[^%.]+$")
local Rect = require(PATH .. '.rect')

local Dungeon = {}

function Dungeon.new(cls, width, height)
	assert(width % 2 ~= 0 and height % 2 ~= 0, "The dungeon must be odd-sized")

	local self = {
		width = width,
		height = height,
		
		tiles = {},
		rooms = {},

		regions = {},
		currentRegion = -1,

		extraConnectorChance = 20,
		roomExtraSize = 0,
		windingPercent = 0,

		-- TODO: use a proper value based on size
		numRoomTries = 80,
	}

	local setTile = function(x, y, tileType)
		self.tiles[y * self.width + x + 1] = tileType
	end

	local getTile = function(x, y)
		return self.tiles[y * self.width + x + 1]
	end

	local fill = function(tileType)
		for y = 0, self.height - 1 do
			for x = 0, self.width - 1 do
				setTile(x, y, tileType)
			end
		end
	end

	local startRegion = function()
		self.currentRegion = self.currentRegion + 1
	end

	local carve = function(x, y, tileType)
		setTile(x, y, tileType)
		self.regions[x * self.width + y + 1] = self.currentRegion
	end

	local addRooms = function()
		for i = 1, self.numRoomTries do
			local size = math.random(1, 3 + self.roomExtraSize) * 2 + 1
			local rectangularity = math.random(0, 1 + math.floor(size / 2)) * 2
			local width = size
			local height = size
			if math.random(0, 1) == 0 then
				width = width + rectangularity
			else
				height = height + rectangularity
			end

			local x = math.random(0, math.floor((self.width - width) / 2) - 1) * 2 + 1
			local y = math.random(0, math.floor((self.height - height) / 2) - 1) * 2 + 1

			local room = Rect(x, y, width, height)
			local overlaps = false

			for _, other in ipairs(self.rooms) do
				if room.distanceTo(other) <= 0 then
					overlaps = true
					break
				end
			end

			if overlaps then goto continue end

			table.insert(self.rooms, room)

			startRegion()

			for y = y, y + height - 1 do
				for x = x, x + width - 1 do
					carve(x, y, 1)
				end
			end

			::continue::
		end
	end

	fill(0)	
	addRooms()

	Dungeon.__tostring = function()
		s = ''

		for y = 0, self.height - 1 do
			for x = 0, self.width - 1 do
				s = s .. getTile(x, y)
			end
			s = s .. '\n'
		end

		return s
	end

	return setmetatable({
		-- list of methods
		getTile = getTile,
		setTile = setTile,
	}, Dungeon)
end

return setmetatable(Dungeon, {
	__call = Dungeon.new,
})