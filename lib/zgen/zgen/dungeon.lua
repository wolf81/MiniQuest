local PATH = (...):match("(.-)[^%.]+$")
local Rect = require(PATH .. '.rect')
local Set = require(PATH .. '.set')
local Array2D = require(PATH .. '.array2d')
local vector = require(PATH .. '.vector')

require(PATH .. '.util')

local Dungeon = {}

local TileType = { 
	['FLOOR'] = 0, 
	['WALL'] = 1,
	['DOOR'] = 2,
}

local Direction = {
	['LEFT'] = vector(-1, 0), 
	['RIGHT'] = vector(1, 0), 
	['UP'] = vector(0, -1),
	['DOWN'] = vector(0, 1),
}

local directions = { Direction.LEFT, Direction.RIGHT, Direction.UP, Direction.DOWN }

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

		regions = nil,
		currentRegion = -1,

		extraConnectorChance = 20,
		roomExtraSize = 0,
		windingPercent = 0,

		-- TODO: use a proper value based on size
		numRoomTries = 30,
	}

	local setTile = function(x, y, tileType)
		self.tiles:set(x, y, tileType)
	end

	local getTile = function(x, y)
		return self.tiles:get(x, y)
	end

	local getRooms = function()
		return self.rooms
	end

	local fill = function(tileType)
		self.tiles = Array2D(self.width, self.height)

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
		self.regions:set(pos.x, pos.y, self.currentRegion)
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

			for _, dir in ipairs(directions) do
				if canCarve(cell, dir) then
					table.insert(unmadeCells, dir)
				end
			end

			if #unmadeCells > 0 then
				local dir = nil

				if contains(unmadeCells, lastDir) and math.random(0, 100) > self.windingPercent then
					dir = lastDir
				else 
					dir = getRandom(unmadeCells)
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

	local addJunction = function(pos)
		setTile(pos.x, pos.y, TileType.DOOR)
	end

	local connectRegions = function()
		local connectorRegions = {} -- <Vec, Set<int>>

		local bounds = Rect(0, 0, self.width, self.height):inflate(-1)

		for x, y in bounds:each() do
			if getTile(x, y) ~= TileType.WALL then goto continue end

			local regions = Set()

			for _, dir in ipairs(directions) do
				local region = self.regions:get(x + dir.x, y + dir.y)
				if region then 
					regions:insert(region)
				end
			end

			if regions:count() < 2 then goto continue end

			connectorRegions[vector(x, y)] = regions

			::continue::
		end

		local connectors = getKeys(connectorRegions)
		local merged = {}
		local openRegions = Set()
		for i = 0, self.currentRegion do
			merged[i] = i
			openRegions:insert(i)
		end

		while openRegions:count() > 1 do
			local connector = getRandom(connectors)

			if connector == nil then break end

			addJunction(connector)

			local regions = connectorRegions[connector]
			regions = regions:map(function(region) return merged[region] end)

			local dest = regions[1]
			local sources = skip(regions, 1)

			for i = 0, self.currentRegion - 1 do
				if contains(sources, merged[i]) then
					merged[i] = dest
				end
			end

			openRegions:removeAll(sources)

			removeWhere(connectors, function(pos)
				local dist = (connector - pos):len()

				if dist < 2 then return true end

				local regions = Set(connectorRegions[pos]:map(function(p)
					return merged[region]
				end))

				if regions:count() > 1 then return false end

				if oneIn(self.extraConnectorChance) then
					addJunction(pos)
				end

				return true
			end)
		end
	end

	local removeDeadEnds = function()
		local done = false

		local bounds = Rect(0, 0, self.width, self.height):inflate(-1)

		while not done do
			done = true

			for x, y in bounds:each() do
				if getTile(x, y) == TileType.WALL then goto continue end

				local exits = 0
				for _, dir in ipairs(directions) do
					if getTile(x + dir.x, y + dir.y) ~= TileType.WALL then
						exits = exits + 1
					end
				end

				if exits ~= 1 then goto continue end

				done = false

				setTile(x, y, TileType.WALL)

				::continue::
			end
		end
	end

	local addRooms = function()
		for i = 1, self.numRoomTries do
			local size = math.random(1, 3 + self.roomExtraSize) * 2 + 1
			local rectangularity = math.random(0, 1 + math.floor(size / 2)) * 2
			local width = size
			local height = size
			if oneIn(2) then
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
	self.regions = Array2D(self.width, self.height)
	addRooms()

	for y = 1, self.height - 1, 2 do
		for x = 1, self.width - 1, 2 do
			if getTile(x, y) ~= TileType.WALL then
				growMaze(vector(x, y))
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
		getTile = getTile,
		setTile = setTile,
		getRooms = getRooms,
	}, Dungeon)
end

return setmetatable(Dungeon, {
	__call = Dungeon.new,
})