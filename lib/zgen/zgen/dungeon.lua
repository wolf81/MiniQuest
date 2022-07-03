local PATH = (...):match("(.-)[^%.]+$")
local Rect = require(PATH .. '.rect')
local vector = require(PATH .. '.vector')

local Dungeon = {}

local TileType = { 
	['FLOOR'] = 0, 
	['WALL'] = 1,
}

local Directions = {
	['LEFT'] = vector(-1, 0), 
	['RIGHT'] = vector(1, 0), 
	['UP'] = vector(0, -1),
	['DOWN'] = vector(0, 1),
}

local function contains(tbl, val) 
	if val == nil then return false end

	for _, v in ipairs(tbl) do
		if v == val then return true end
	end

	return false
end

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
		numRoomTries = 30,
	}

	local setTile = function(x, y, tileType)
		self.tiles[y * self.width + x + 1] = tileType
	end

	local getTile = function(x, y)
		return self.tiles[y * self.width + x + 1]
	end

	local fill = function(tileType)
		tileType = tileType or TileType.FLOOR

		for y = 0, self.height - 1 do
			for x = 0, self.width - 1 do
				setTile(x, y, tileType)
			end
		end
	end

	local startRegion = function()
		self.currentRegion = self.currentRegion + 1
	end

	local carve = function(pos, tileType)
		setTile(pos.x, pos.y, tileType or TileType.FLOOR)
		self.regions[pos.x * self.width + pos.y + 1] = self.currentRegion
	end

	local canCarve = function(pos, dir)
		local bounds = Rect(0, 0, self.width, self.height)
		local p = pos + dir * 3

		if not bounds:contains(p.x, p.y) then
			return false
		end

		local p = pos + dir * 2
		return getTile(p.x, p.y) == TileType.WALL
	end

	local growMaze = function(pos)
		local cells = {}
		local lastDir = nil

		startRegion()
		carve(pos)

		table.insert(cells, pos)

		while #cells > 0 do
			local cell = cells[#cells]

			local unmadeCells = {}

			local dirs = { Directions.LEFT, Directions.RIGHT, Directions.UP, Directions.DOWN }

			for _, dir in ipairs(dirs) do
				if canCarve(cell, dir) then
					table.insert(unmadeCells, dir)
				end
			end

			if #unmadeCells > 0 then
				local dir = nil

				if contains(unmadeCells, lastDir) and math.random(0, 100) > self.windingPercent then
					dir = lastDir
				else 
					dir = unmadeCells[math.random(#unmadeCells)]
					print('dir', dir)
				end

				carve(cell + dir)
				carve(cell + dir * 2)	

				table.insert(cells, cell + dir * 2)
				lastDir = dir
			else
				table.remove(cells, #cells)

				lastDir = nil
			end
		end
	end

	local connectRegions = function()
		local connectorRegions = {}
		for y = 0, self.width - 1 do
			for x = 0, self.height - 1 do
				-- local pos = 
			end
		end
	end

	local removeDeadEnds = function()
		-- body
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
				if room:distanceTo(other) <= 0 then
					overlaps = true
					break
				end
			end

			if overlaps then goto continue end

			table.insert(self.rooms, room)

			startRegion()

			for x, y in room:each() do
				carve(vector(x, y), TileType.FLOOR)
			end

			::continue::
		end
	end

	fill(TileType.WALL)	
	addRooms()

	for y = 1, self.height - 1, 2 do
		for x = 1, self.width - 1, 2 do
			if getTile(x, y) ~= TileType.WALL then
				-- growMaze(vector(x, y))
			end
		end
	end

	connectRegions()
	removeDeadEnds()

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