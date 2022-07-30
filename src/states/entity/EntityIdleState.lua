--[[
    GD50
    MiniQuest

    Author: Wolfgang Schreurs
    info+miniquest@wolftrail.net
]]

EntityIdleState = EntityBaseState:extend()

function EntityIdleState:enter()
    if DEBUG then
        self.actor:addEffect('state', 'idle')
    end
end

function EntityIdleState:exit()
    self.actor:removeEffect('state')
end

function EntityIdleState:update()
    if self:isTargetInSight(self.dungeon.scheduler.hero) then
        return self.actor:combat()
    end
end

function EntityIdleState:getAction()
    local actions = {}

    while true do
        local cost = getActionCosts(self.actor)
        if self.actor.energy < cost.idle then break end

        self.actor.energy = self.actor.energy - cost.idle
        actions[#actions + 1] = IdleAction(self.actor)
    end

    if #actions == 0 then 
        return nil
    elseif #actions == 1 then 
        return actions[1]
    else 
        return CompositeAction(self.actor, actions) 
    end
end
