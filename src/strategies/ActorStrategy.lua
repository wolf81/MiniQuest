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
    local dirs = { 
        Direction.W, Direction.E, Direction.N, Direction.S, 
        Direction.NW, Direction.NE, Direction.SE, Direction.SW 
    }
    return dirs[math.random(#dirs)]
end

local function canMove(actor, dungeon)
    local dir = getRandomDirection()
    local heading = Direction.heading[dir]
    local actor_x, actor_y = actor:nextPosition()
    local actor_x, actor_y = actor_x + heading.x, actor_y + heading.y
    local target = dungeon:getActor(actor_x, actor_y)

    if not dungeon:isBlocked(actor_x, actor_y) and not target then
        return dir
    end

    return nil
end

function ActorStrategy:getAction()
    if self.actor.energy == 0 then return end

    local actions = {}

    -- depending on energy available and energy cost of actions, an actor might
    -- be able to do 0, 1 or multiple actions
    while true do
        -- attack or move cost might be changed through other actions, therefore
        -- recalculate on every loop
        local attack_cost = math.ceil(BASE_ENERGY_COST / self.actor.attack_speed)
        local move_cost = math.ceil(BASE_ENERGY_COST / self.actor.move_speed)

        -- make sure we have enough energy for any action
        if self.actor.energy < math.min(attack_cost, move_cost) then break end

        local dir = canMove(self.actor, self.dungeon)
        local is_adjacent_to_hero = isAdjacent(self.actor, self.dungeon.hero)

        -- if we're standing next to the hero, attack hero
        if is_adjacent_to_hero then
            if self.actor.energy >= attack_cost then
                self.actor.energy = self.actor.energy - attack_cost
                actions[#actions + 1] = AttackAction(self.actor, self.dungeon.hero)
            else
                -- we're standing next to the hero, but not enough energy to 
                -- attack, so bail
                break
            end

        -- occasionally idle
        elseif math.random(5) == 1 then
            if self.actor.energy >= move_cost then
                self.actor.energy = self.actor.energy - move_cost
                actions[#actions + 1] = IdleAction(self.actor)
            end

        -- if direction is not blocked a tile or actor, move in direction
        elseif dir then
            if self.actor.energy >= move_cost then
                self.actor.energy = self.actor.energy - move_cost
                actions[#actions + 1] = MoveAction(self.actor, dir)
            else
                -- we were not standing next to the hero and we don't have any
                -- energy left to move, so bail
                break
            end
        else
            -- no direction was found, so try to idle
            if self.actor.energy >= move_cost then
                self.actor.energy = self.actor.energy - move_cost
                actions[#actions + 1] = IdleAction(self.actor)
            else
                break
            end            
        end 
    end

    -- we should always return a single action object, so if the action list 
    -- contains a single action, return it, otherwise return a composite action
    if #actions == 1 then 
        return actions[1]
    elseif #actions > 1 then
        return CompositeAction(self.actor, actions)
    end

    return nil
end