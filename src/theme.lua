Theme = Object:extend()

function Theme:new(floor_offset, wall_h_offset, wall_v_offset)
    local tiles = {}
    for i = 0, 4 do
        tiles[i + floor_offset] = 25 - (i * 5)
    end    
    self.floor_tiles = amazing.RandomTable(tiles)

    tiles = {}
    for i = 0, 5 do
        tiles[i + wall_h_offset] = 25 - (i * 4)
    end
    self.wall_tiles_h = amazing.RandomTable(tiles)

    tiles = {}
    for i = 0, 5 do
        tiles[i + wall_v_offset] = 25 - (i * 4)
    end
    self.wall_tiles_v = amazing.RandomTable(tiles)

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
