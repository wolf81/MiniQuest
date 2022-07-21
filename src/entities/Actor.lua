--[[
    GD50
    MiniQuest

    Author: Wolfgang Schreurs
    info+miniquest@wolftrail.net
]]

local mfloor = math.floor

Actor = Entity:extend()

function Actor:new(def, dungeon, x, y)
    Entity.new(self, def, x, y)

    self.dungeon = dungeon

    self.direction = 'down'
    self.hitpoints = def.hitpoints or 1
    self.strategy = ActorStrategy(self, dungeon)

    self.action = nil
end

function Actor:getAction()
    if self.action ~= nil then return end

    self.action = self.strategy:getAction()

    return self.action
end

-- inflict some damage on this actor; if hitpoints are reduced to 0, then set 
-- remove flag to true, so the game loop can remove the entity next iteration
function Actor:inflict(damage)
    self.hitpoints = math.max(self.hitpoints - damage, 0)

    self.remove = self.hitpoints == 0
end

function Actor:draw()
    local anim = self.currentAnimation

    love.graphics.draw(
        gTextures[anim.texture], 
        gFrames[anim.texture][anim:getCurrentFrame()],
        mfloor(self.x * TILE_SIZE), 
        mfloor(self.y * TILE_SIZE)
    )end