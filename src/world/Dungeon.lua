--[[
    GD50
    MiniQuest

    Author: Wolfgang Schreurs
    info+miniquest@wolftrail.net
]]

Dungeon = Object:extend()

local function updateCamera(self)
    self.camera.x = CAMERA_X_OFFSET - self.hero.x * TILE_SIZE
    self.camera.y = CAMERA_Y_OFFSET - self.hero.y * TILE_SIZE
end

function Dungeon:new()
    self.map = Map

    self.layers = {}

    for layerIdx, layer in ipairs(self.map.layers) do
        local tiles = {}
        self.layers[#self.layers + 1] = tiles

        for y = 0, self.map.height - 1 do
            for x = 0, self.map.width - 1 do
                local tileId = layer[y * self.map.width + x + 1]
                if tileId == 0 then goto continue end

                local tileDef = { 
                    id = tileId, 
                    animations = {},
                    solid = tileId == 7 or tileId == 1,
                }

                tiles[x .. '.' .. y] = Tile(tileDef, x, y)

                ::continue::
            end
        end
    end

    self.hero = Hero(ENTITY_DEFS['hero'], self, 1, 4)

    self.monsters = {}
    self.monsters[#self.monsters + 1] = Creature(ENTITY_DEFS['skeleton'], self, 5, 3)

    self.camera = { x = 0, y = 0 }
end

function Dungeon:isBlocked(x, y)
    local blocked = false

    for _, layer in ipairs(self.layers) do
        local tile = layer[x .. '.' .. y]
        local solid = tile and tile.solid or false
        if solid then
            blocked = true
        end
    end

    return blocked
end

function Dungeon:update(dt)
    updateCamera(self)

    self.hero:update(dt)

    for _, monster in ipairs(self.monsters) do
        monster:update(dt)
    end
end

function Dungeon:draw()
    love.graphics.push()

    love.graphics.translate(math.floor(self.camera.x), math.floor(self.camera.y))

    for _, tiles in ipairs(self.layers) do
        for _, tile in pairs(tiles) do
            love.graphics.draw(
                gTextures['world'], 
                gFrames['tiles'][tile.id],
                tile.x * TILE_SIZE, 
                tile.y * TILE_SIZE
            )
        end
    end

    for _, creature in ipairs(self.monsters) do
        creature:draw()
    end

    self.hero:draw()

    love.graphics.pop()
end
