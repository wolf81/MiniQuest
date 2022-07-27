--[[
    GD50
    MiniQuest

    Author: Wolfgang Schreurs
    info+miniquest@wolftrail.net
]]

EntityIdleState = BaseState:extend()

function EntityIdleState:enter(actor)
    actor:addEffect('state', 'idle')
end

function EntityIdleState:new(dungeon)
    self.dungeon = dungeon
end

function EntityIdleState:update(actor)
    local hero_x, hero_y = self.dungeon.scheduler.hero:nextPosition()
    local sight = actor.sight

    if (hero_x > actor.x - sight and 
        hero_x < actor.x + sight and
        hero_y > actor.y - sight and
        hero_y < actor.y + sight) then
        return actor:combat()
    end
end

function EntityIdleState:getAction(actor, duration, onFinish)
    local actions = {}

    while true do
        local idle_cost = math.ceil(BASE_ENERGY_COST / actor.move_speed)
        if actor.energy < idle_cost then break end

        actor.energy = actor.energy - idle_cost
        actions[#actions + 1] = IdleAction(actor)
    end

    if #actions == 0 then 
        return nil
    elseif #actions == 1 then 
        return actions[1]
    else 
        return CompositeAction(actor, actions) 
    end
end
