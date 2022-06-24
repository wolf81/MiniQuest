--[[
    GD50
    MiniQuest

    Author: Wolfgang Schreurs
    info+miniquest@wolftrail.net
]]

Dungeon = Object:extend()

local function updateCamera(self)
    self.camera.x = VIRTUAL_WIDTH / 2 - self.hero.x - TILE_SIZE / 2
    self.camera.y = VIRTUAL_HEIGHT / 2 - self.hero.y - TILE_SIZE / 2
end

function Dungeon:new()
    self.map = Map

    self.layers = {}

    for layerIdx, layer in ipairs(self.map.layers) do
        local tiles = {}
        self.layers[#self.layers + 1] = tiles

        for y = 1, self.map.height do
            for x = 1, self.map.width do
                local tileId = layer[(y - 1) * self.map.width + x]
                if tileId == 0 then goto continue end

                tiles[#tiles + 1] = { 
                    gridX = x,
                    gridY = y,
                    x = (x - 1) * TILE_SIZE,
                    y = (y - 1) * TILE_SIZE,
                    id = tileId,
                }

                ::continue::
            end
        end
    end

    self.hero = Hero(ENTITY_DEFS['hero'], self)
    self.hero.x = 1 * TILE_SIZE
    self.hero.y = 4 * TILE_SIZE

    self.camera = { x = 0, y = 0 }
end

function Dungeon:update(dt)
    updateCamera(self)

    self.hero:update(dt)
end

function Dungeon:draw()
    love.graphics.push()

    love.graphics.translate(math.floor(self.camera.x), math.floor(self.camera.y))

    for _, tiles in ipairs(self.layers) do
        for _, tile in ipairs(tiles) do
            love.graphics.draw(
                gTextures['world'], 
                gFrames['tiles'][tile.id],
                tile.x, 
                tile.y
            )
        end
    end

    self.hero:draw()

    love.graphics.pop()
end
