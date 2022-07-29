--[[
    GD50
    MiniQuest

    Author: Wolfgang Schreurs
    info+miniquest@wolftrail.net
]]

Theme = Object:extend()

Theme.dungeon = function()
    return Theme(66, 1, 7)    
end

Theme.cavern = function()
    return Theme(82, 17, 23)    
end

Theme.swamp = function()
    return Theme(82, 33, 39)
end

local function generateTilesTable(offset, count, decrement_spawn_chance)
    local decrement_spawn_chance = decrement_spawn_chance or false

    local tiles = {}

    local chance = 25
    for i = 0, count - 1 do
        tiles[i + offset] = chance

        if decrement_spawn_chance then
            chance = math.max(math.ceil(chance / 2), 1)
        end
    end

    return amazing.RandomTable(tiles)
end

function Theme:new(floor_offset, wall_h_offset, wall_v_offset)
    self.floor_tiles = generateTilesTable(floor_offset, 5)
    self.wall_tiles_h = generateTilesTable(wall_h_offset, 6, true)
    self.wall_tiles_v = generateTilesTable(wall_v_offset, 6, true)

    self.stair_up = wall_v_offset + 7
    self.stair_down = wall_v_offset + 6
end

function Theme:getFloorTile(x, y)
    return Tile({ id = self.floor_tiles.roll() }, x, y)
end

function Theme:getWallTileH(x, y)
    return Tile({ id = self.wall_tiles_h.roll(), solid = true }, x, y)
end

function Theme:getWallTileV(x, y)
    return Tile({ id = self.wall_tiles_v.roll(), solid = true }, x, y)
end

function Theme:getStairUp(x, y)
    return Tile({ id = self.stair_up }, x, y)
end

function Theme:getStairDown(x, y)
    return Tile({ id = self.stair_down }, x, y)
end
