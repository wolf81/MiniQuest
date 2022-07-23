Theme = Object:extend()

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

function Theme:getFloorTile()
    return self.floor_tiles.roll()
end

function Theme:getWallTileH()
    return self.wall_tiles_h.roll()
end

function Theme:getWallTileV()
    return self.wall_tiles_v.roll()
end

function Theme:getStairUp()
    return self.stair_up
end

function Theme:getStairDown()
    return self.stair_down
end
