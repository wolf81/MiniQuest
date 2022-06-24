--[[
    GD50
    MiniQuest

    Author: Wolfgang Schreurs
    info+miniquest@wolftrail.net
]]

Dungeon = Object:extend()

function Dungeon:new(path)
    local map = dofile(path)

    self.layers = {}

    for layerIdx, layer in ipairs(map.layers) do
        local tiles = {}
        self.layers[#self.layers + 1] = tiles

        for y = 0, map.height - 1 do
            for x = 0, map.width - 1 do
                local tileId = layer[y * map.width + x + 1]
                if tileId == 0 then goto continue end

                tiles[#tiles + 1] = { 
                    x = x * TILE_SIZE, 
                    y = y * TILE_SIZE,
                    gridX = x,
                    gridY = y,
                    id = tileId,
                }

                ::continue::
            end
        end
    end
end

function Dungeon:draw()
    for _, tiles in ipairs(self.layers) do
        for _, tile in ipairs(tiles) do
            love.graphics.draw(gTextures['world'], gFrames['tiles'][tile.id],
                tile.x, 
                tile.y)
        end
    end
end
