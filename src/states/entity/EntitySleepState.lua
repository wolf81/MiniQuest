--[[
    GD50
    MiniQuest

    Author: Wolfgang Schreurs
    info+miniquest@wolftrail.net
]]

EntitySleepState = EntityBaseState:extend()

function EntitySleepState:enter(actor)
    actor:addEffect('state', 'sleep')

    self.turns = love.math.random(5, 10)
    
    self.actor:addEffect('sleep')
end

function EntitySleepState:exit()
    self.actor:removeEffect('sleep')    
end

function EntitySleepState:update()
    local hero = self.dungeon.scheduler.hero

    self.turns = self.turns - 1

    if self.turns > 0 then
        if self:isAdjacent(hero) then
            self.actor:combat()
        end
    else
        if self:isTargetInSight(hero, self.actor.sight) then
            self.actor:combat()
        else
            self.actor:roam()
        end        
    end
end

function EntitySleepState:getAction()
    local actions = {}

    while true do
        local idle_cost = math.ceil(BASE_ENERGY_COST / self.actor.move_speed)
        
        if self.actor.energy < idle_cost then break end

        self.actor.energy = self.actor.energy - idle_cost
        actions[#actions + 1] = IdleAction(self.actor, true)
    end

    if #actions == 0 then 
        return nil
    elseif #actions == 1 then 
        return actions[1]
    else 
        return CompositeAction(self.actor, actions) 
    end
end
