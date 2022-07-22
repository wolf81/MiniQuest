--[[
    GD50
    MiniQuest

    Author: Wolfgang Schreurs
    info+miniquest@wolftrail.net
]]

ActorStrategy = BaseStrategy:extend()

local BASE_ENERGY_COST = 100

-- calculate of this entity is standing next to a hero
local function isAdjacent(actor, target)
    local actor_x, actor_y = actor:nextPosition()
    local target_x, target_y = target:nextPosition()    
    return (
        math.abs(actor_x - target_x) + 
        math.abs(actor_y - target_y)
    ) == 1
end

-- select a random direction
local function getRandomDirection()
    local directions = { 'left', 'right', 'up', 'down' }
    return directions[math.random(#directions)]
end

local function canMove(actor, dungeon)
    local direction = getRandomDirection()
    local dxy = directionToVector(direction)
    local actor_x, actor_y = actor:nextPosition()
    local actor_x, actor_y = actor_x + dxy.x, actor_y + dxy.y
    local target = dungeon:getActor(actor_x, actor_y)

    if not dungeon:isBlocked(actor_x, actor_y) and not target then
        return direction
    end

    return nil
end

function ActorStrategy:getAction()
    if self.actor.energy == 0 then return end

    local actions = {}

    while true do

    -- local direction = getRandomDirection()
    -- local dxy = directionToVector(direction)
    -- local x, y = self.actor:nextPosition()
    -- local x, y = x + dxy.x, y + dxy.y
    -- local target = self.dungeon:getActor(x, y)

        local attack_cost = math.ceil(BASE_ENERGY_COST / self.actor.attack_speed)
        local move_cost = math.ceil(BASE_ENERGY_COST / self.actor.move_speed)
        local min_cost = math.min(attack_cost, move_cost)
        local can_attack = true

        if self.actor.energy < min_cost then break end

        local direction = canMove(self.actor, self.dungeon)

        local is_adjacent_to_hero = isAdjacent(self.actor, self.dungeon.hero)

        -- if we're standing next to the hero, attack hero
        if is_adjacent_to_hero then
            if self.actor.energy >= attack_cost then
                self.actor.energy = self.actor.energy - attack_cost
                actions[#actions + 1] = AttackAction(self.actor, self.dungeon.hero)
            end

        -- occasionally idle
        elseif math.random(5) == 1 then
            if self.actor.energy >= move_cost then
                self.actor.energy = self.actor.energy - move_cost
                actions[#actions + 1] = IdleAction(self.actor)
            end

        -- if direction is not blocked a tile or actor, move in direction
        elseif direction then
            if self.actor.energy >= move_cost then
                self.actor.energy = self.actor.energy - move_cost
                actions[#actions + 1] = MoveAction(self.actor, direction)
            end
        end 

        if is_adjacent_to_hero then
            if self.actor.energy < attack_cost then break end
        else
            if self.actor.energy < move_cost then break end
        end
    end

    if #actions == 1 then 
        return actions[1]
    elseif #actions > 1 then
        return CompositeAction(self.actor, actions)
    end

    return nil
end