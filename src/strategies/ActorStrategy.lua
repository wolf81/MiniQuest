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
    local target = self.dungeon:getActor(x, y)

    if self.actor.energy == 0 then return end

    --[[
    -- stop any movement and attacks if the dungeon is finished
    if self.dungeon.finished then
        return IdleAction(self.actor) 
    --]]

    -- if we're standing next to the hero, attack hero
    if isAdjacent(self.actor, self.dungeon.hero) then
        if self.actor.energy >= 100 then
            self.actor.energy = self.actor.energy - 100
            return AttackAction(self.actor, self.dungeon.hero)
        end

    -- occasionally idle
    elseif math.random(5) == 1 then
        if self.actor.energy >= 100 then
            self.actor.energy = self.actor.energy - 100
        end
        return IdleAction(self.actor)

    -- if direction is not blocked a tile or actor, move in direction
    elseif not self.dungeon:isBlocked(x, y) and not target then
        local energy_cost = 100 * self.actor.move_speed
        if self.actor.energy >= energy_cost then
            self.actor.energy = self.actor.energy - energy_cost
            return MoveAction(self.actor, direction)
        end
    end

    return nil
end