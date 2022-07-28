--[[
    GD50
    MiniQuest

    Author: Wolfgang Schreurs
    info+miniquest@wolftrail.net
]]

EntitySleepState = BaseState:extend()

function EntitySleepState:enter(actor)
    actor:addEffect('state', 'sleep')

    self.turns = love.math.random(5, 10)
    --self.entity:addEffect('sleep')
end

function EntitySleepState:exit()
    print('exit sleep state')

    --self.entity:removeEffect('sleep')    
end

function EntitySleepState:new(dungeon)
    self.dungeon = dungeon
end

function EntitySleepState:update(actor)
    local hero = self.dungeon.scheduler.hero
    local sight = 2

    if getDistance(actor.x, actor.y, hero.x, hero.y) <= sight then
        return actor:combat()
    end

    self.turns = self.turns - 1
    if self.turns == 0 then
        actor:roam()
    end
end

function EntitySleepState:getAction(actor)
    local actions = {}

    while true do
        local idle_cost = math.ceil(BASE_ENERGY_COST / actor.move_speed)
        
        if actor.energy < idle_cost then break end

        actor.energy = actor.energy - idle_cost
        actions[#actions + 1] = IdleAction(actor, true)
    end

    if #actions == 0 then 
        return nil
    elseif #actions == 1 then 
        return actions[1]
    else 
        return CompositeAction(actor, actions) 
    end
end
