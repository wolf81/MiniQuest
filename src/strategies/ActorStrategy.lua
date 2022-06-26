--[[
    GD50
    MiniQuest

    Author: Wolfgang Schreurs
    info+miniquest@wolftrail.net
]]

ActorStrategy = BaseStrategy:extend()

-- calculate of this entity is standing next to a hero
local function isAdjacent(actor, target)
    return (
        math.abs(actor.x - target.x) + 
        math.abs(actor.y - target.y)
    ) == 1
end

-- select a random direction
local function getRandomDirection()
    local directions = { 'left', 'right', 'up', 'down' }
    return directions[math.random(#directions)]
end

function ActorStrategy:getAction()
    local direction = getRandomDirection()
    local dxy = directionToVector(direction)
    local x, y = self.actor.x + dxy.x, self.actor.y + dxy.y

    if self.dungeon.finished then 
        return IdleAction(self.actor) 
    end

    local target = self.dungeon:getActor(x, y)
    if target == self.dungeon.hero then
        return AttackAction(self.actor, self.dungeon.hero)
    end

    -- if we're standing next to the hero, attack hero
    if isAdjacent(self.actor, self.dungeon.hero) then
        return AttackAction(self.actor, self.dungeon.hero)

    -- occasionally idle
    elseif math.random(5) == 1 then
        return IdleAction(self.actor)

    -- if not idling or attacking, try to move
    elseif not self.dungeon:isBlocked(x, y) and not target then
        return MoveAction(self.actor, direction)
    end

    return nil
end