--[[
    GD50
    MiniQuest

    Author: Wolfgang Schreurs
    info+miniquest@wolftrail.net
]]

Actor = Entity:extend()

-- calculate of this entity is standing next to a hero
local function isAdjacentToHero(self)
    return (
        math.abs(self.x - self.dungeon.hero.x) + 
        math.abs(self.y - self.dungeon.hero.y)
    ) == 1
end

-- select a random direction
local function getRandomDirection()
    local directions = { 'left', 'right', 'up', 'down' }
    return directions[math.random(#directions)]
end

function Actor:new(def, dungeon, x, y)
    Entity.new(self, def, x, y)

    self.direction = 'down'
    self.hitpoints = def.hitpoints or 1
    self.solid = true

    self.dungeon = dungeon

    self.action = nil
end

function Actor:getAction()
    if self.action ~= nil then return end

    local direction = getRandomDirection()
    local dxy = directionToVector(direction)
    local x, y = self.x + dxy.x, self.y + dxy.y

    -- if we're standing next to the hero, attack hero
    if isAdjacentToHero(self) then
        self.action = AttackAction(self, self.dungeon.hero)

    -- occasionally idle
    elseif math.random(5) == 1 then
        self.action = IdleAction(self)

    -- if not idling or attacking, try to move
    elseif not self.dungeon:isBlocked(x, y) then
        self.action = MoveAction(self, direction)
    end

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
        math.floor(self.x * TILE_SIZE), 
        math.floor(self.y * TILE_SIZE)
    )end