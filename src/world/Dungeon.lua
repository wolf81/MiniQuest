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

local function nextActor(self)
    self.actorIdx = math.max(1, (self.actorIdx + 1) % (#self.actors + 1))
end

function Dungeon:new()
    self.map = Map

    self.finished = false

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

    self.hero = Actor(ACTOR_DEFS['hero'], self, 1, 4)
    self.hero.strategy = HeroStrategy(self.hero, self)

    self.actors = { self.hero }
    self.actors[#self.actors + 1] = Actor(ACTOR_DEFS['skeleton'], self, 5, 3)
    self.actors[#self.actors + 1] = Actor(ACTOR_DEFS['spider'], self, 8, 5)
    self.actors[#self.actors + 1] = Actor(ACTOR_DEFS['bat'], self, 9, 6)
    self.actors[#self.actors + 1] = Actor(ACTOR_DEFS['vampire'], self, 11, 10)
    self.actorIdx = 1

    self.effects = {}
    self.entitiesToAdd = {}

    self.camera = { x = 0, y = 0 }
end

function Dungeon:getActor(x, y)
    for _, actor in ipairs(self.actors) do
        if actor.x == x and actor.y == y then
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

    -- get action for current active actor
    local actor = self.actors[self.actorIdx]    
    local action = actor:getAction()    

    -- no action was found, try again next iteration of update
    if action == nil then return end

    -- we did get an action, so execute it and on finish, change active actor
    action:perform(function()
        nextActor(self)
    end)

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
