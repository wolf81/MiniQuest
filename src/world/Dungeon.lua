--[[
    GD50
    MiniQuest

    Author: Wolfgang Schreurs
    info+miniquest@wolftrail.net
]]

Dungeon = Object:extend()

local WALL_SHADOW_TILE_ID = 176

local function updateCamera(self)
    self.camera.x = CAMERA_X_OFFSET - self.hero.x * TILE_SIZE
    self.camera.y = CAMERA_Y_OFFSET - self.hero.y * TILE_SIZE
end

local function getTheme()
    return shuffle({ Theme.cavern(), Theme.dungeon(), Theme.swamp() })[1]
end

function Dungeon:new(map, start, spawns)
    self.map = map

    self.finished = false

    local tiles = {}
    local shadow = {}
    local objects = {}

    local theme = getTheme()

    local map_w, map_h = map.size()
    for x, y, tile in map.iter() do
        local tile_obj = theme:getFloorTile(x, y)

        if bit.band(tile, amazing.Tile.WALL) == amazing.Tile.WALL then
            tile_obj = theme:getWallTileV(x, y)

            if y > 0 and y < map_h then
                local tile_below = map.get(x, y + 1)
                local floor_door = bit.bor(amazing.Tile.FLOOR, amazing.Tile.DOOR)
                if bit.band(tile_below, floor_door) ~= 0 then
                    tile_obj = theme:getWallTileH(x, y) 
                    shadow[x .. '.' .. y] = 
                        Tile({ id = WALL_SHADOW_TILE_ID, }, x, y + 1)
                end
            elseif y == map_h then
                tile_obj = theme:getWallTileH(x, y)                
            end
        elseif bit.band(tile, amazing.Tile.STAIR_UP) == amazing.Tile.STAIR_UP then
            objects[x .. '.' .. y] = theme:getStairUp(x, y)
        elseif bit.band(tile, amazing.Tile.STAIR_DN) == amazing.Tile.STAIR_DN then
            objects[x .. '.' .. y] = theme:getStairDown(x, y)
        end
        
        tiles[x .. '.' .. y] = tile_obj 
    end

    if start ~= nil then
        self.hero = Actor(ACTOR_DEFS['hero'], self, start.x, start.y, HeroStrategy)
    end

    self.layers = { tiles, shadow, objects }

    self.actors = { self.hero }

    for _, spawn in ipairs(spawns) do
        local actor = Actor(ACTOR_DEFS[spawn.id], self, spawn.x, spawn.y)
        self.actors[#self.actors + 1] = actor
    end

    self.effects = {}
    self.entitiesToAdd = {}

    self.scheduler = Scheduler(self.actors)

    self.camera = { x = 0, y = 0 }

    self:updateMovementGraph()
end

function Dungeon:updateMovementGraph()
    local isBlocked = function(x, y)
        return bit.band(self.map.get(x, y), amazing.Tile.WALL) == amazing.Tile.WALL
    end

    local x, y = self.hero:nextPosition()
    self.movement = amazing.dijkstra.map(self.map, x, y, isBlocked)
end

function Dungeon:getActor(x, y)
    return self.scheduler:getActor(x, y)
end

function Dungeon:addEntity(entity)
    self.entitiesToAdd[#self.entitiesToAdd + 1] = entity
end

function Dungeon:isBlocked(x, y)
    return isNan(self.movement.get(x, y))
end

function Dungeon:update(dt)
    -- first add all entities that might have been added last update loop
    for _, entity in ipairs(self.entitiesToAdd) do
        if entity:is(Effect) then
            self.effects[#self.effects + 1] = entity
        end
    end
    self.entitiesToAdd = {}

    -- make camera follow hero
    updateCamera(self)

    -- update actors
    for _, actor in ipairs(self.actors) do
        actor:update(dt)
    end

    -- update effects and remove immediately on completion
    for i, effect in ripairs(self.effects) do
        effect:update(dt)
        if effect.remove then
            table.remove(self.effects, i)
        end
    end

    self.scheduler:update(dt)
    
    -- iterate through all actors, removing actors flagged for removal
    for i, actor in ripairs(self.actors) do
        local actor = self.actors[i]
        if actor.remove then
            table.remove(self.actors, i)

            if actor == self.hero then
                self.finished = true
            end
        end
    end
end

function Dungeon:draw()
    -- push graphics state, as not to interfere with FPS counter
    love.graphics.push()

    -- target camera towards hero
    love.graphics.translate(math.floor(self.camera.x), math.floor(self.camera.y))

    -- now draw all tile layers
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

    -- draw actors on top of tiles
    for _, actor in ipairs(self.actors) do
        actor:draw()
    end

    -- draw effects on top of tiles & actors
    for _, effect in ipairs(self.effects) do
        effect:draw()
    end

    -- after drawing is finished, we can pop state again and main loop can draw
    -- FPS counter on top
    love.graphics.pop()
end
