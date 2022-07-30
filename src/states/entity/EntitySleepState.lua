--[[
    GD50
    MiniQuest

    Author: Wolfgang Schreurs
    info+miniquest@wolftrail.net
]]

EntitySleepState = EntityBaseState:extend()

function EntitySleepState:enter(actor)
    if DEBUG then
        actor:addEffect('state', 'sleep')
    end

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
        if self:isTargetInSight(hero, self.actor.stats:get('sight')) then
            self.actor:combat()
        else
            self.actor:roam()
        end        
    end
end

function EntitySleepState:getAction()
    local actions = {}

    while true do
        local cost = getActionCosts(self.actor)
        
        if self.actor.energy < cost.idle then break end

        self.actor.energy = self.actor.energy - cost.idle
        actions[#actions + 1] = IdleAction(self.actor, cost.idle, true)
    end

    if #actions == 0 then 
        return nil
    elseif #actions == 1 then 
        return actions[1]
    else 
        return CompositeAction(self.actor, actions) 
    end
end
