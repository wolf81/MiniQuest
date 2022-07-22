--[[
    GD50
    MiniQuest

    Author: Wolfgang Schreurs
    info+miniquest@wolftrail.net
]]

amazing = require 'lib.amazing'

Dungeon = Object:extend()

local function updateCamera(self)
    self.camera.x = CAMERA_X_OFFSET - self.hero.x * TILE_SIZE
    self.camera.y = CAMERA_Y_OFFSET - self.hero.y * TILE_SIZE
end

local function nextActor(self)
    self.actorIdx = math.max(1, (self.actorIdx + 1) % (#self.actors + 1))
end

function Dungeon:new(map, spawns)
    self.map = map

    self.finished = false

    local tiles = {}
    local shadow = {}

    local map_w, map_h = map.size()
    for x, y, tile in map.iter() do
        local tileDef = {
            id = 0,
            animations = {},
            solid = false,
        }

        if bit.band(tile, amazing.Tile.WALL) == amazing.Tile.WALL then
            tileDef.solid = true
            tileDef.id = love.math.random(7, 11)

            if y > 0 and y < map_h then
                local tile_below = map.get(x, y + 1)
                local floor_door = bit.bor(amazing.Tile.FLOOR, amazing.Tile.DOOR)
                if bit.band(tile_below, floor_door) ~= 0 then
                    tileDef.id = love.math.random(1, 4)
                    shadow[x .. '.' .. y] = Tile({
                        id = 176,
                        animations = {},
                        solid = false,
                    }, x, y + 1)
                end
            end
        elseif bit.band(tile, amazing.Tile.STAIR_UP) == amazing.Tile.STAIR_UP then
            tileDef.id = 13
        elseif bit.band(tile, amazing.Tile.STAIR_DN) == amazing.Tile.STAIR_DN then
            tileDef.id = 14
        else
            tileDef.id = love.math.random(98, 102)
        end
        
        tiles[x .. '.' .. y] = Tile(tileDef, x, y)

        if bit.band(tile, amazing.Tile.STAIR_DN) == amazing.Tile.STAIR_DN then
            self.hero = Actor(ACTOR_DEFS['hero'], self, x, y)
            self.hero.strategy = HeroStrategy(self.hero, self)
        end
    end

    self.layers = { tiles, shadow }

    self.actors = { self.hero }

    for _, spawn in ipairs(spawns) do
        self.actors[#self.actors + 1] = Actor(ACTOR_DEFS[spawn.id], self, spawn.x, spawn.y)        
    end
    self.actorIdx = 1

    self.effects = {}
    self.entitiesToAdd = {}

    self.scheduler = Scheduler(self.actors)

    self.camera = { x = 0, y = 0 }
end

function Dungeon:getActor(x, y)
    for _, actor in ipairs(self.actors) do
        local actor_x, actor_y = actor:nextPosition()
        if actor_x == x and actor_y == y then
            return actor
        end
    end

    return nil
end

function Dungeon:addEntity(entity)
    self.entitiesToAdd[#self.entitiesToAdd + 1] = entity
end

function Dungeon:isBlocked(x, y)
    local blocked = false

    for _, layer in ipairs(self.layers) do
        local tile = layer[x .. '.' .. y]
        local solid = (tile and tile.solid) or false
        if solid then
            blocked = true
        end
    end

    return blocked
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

    --[[
    local offset = 3
    local action = nil

    -- get action for current active actor
    local actor = self.actors[self.actorIdx]    
    if (actor.x < self.hero.x - offset or 
        actor.x > self.hero.x + offset or 
        actor.y < self.hero.y - offset or 
        actor.y > self.hero.y + offset) then
        nextActor(self)
        return
    end

    local action = actor:getAction()    

    -- no action was found, try again next iteration of update
    if action == nil then return end

    -- we did get an action, so execute it and on finish, change active actor
    action:perform(function()
        nextActor(self)
    end)
    --]]
    
    -- iterate through all actors, removing actors flagged for removal
    for i, actor in ripairs(self.actors) do
        local actor = self.actors[i]
        if actor.remove then
            table.remove(self.actors, i)

            -- make sure the active actor index doesnt go out of bounds after
            -- an actor is removed
            if self.actorIdx > #self.actors then
                nextActor(self)
            end

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
