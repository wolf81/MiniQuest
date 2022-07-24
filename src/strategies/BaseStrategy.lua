--[[
    GD50
    MiniQuest

    Author: Wolfgang Schreurs
    info+miniquest@wolftrail.net
]]

BaseStrategy = Object:extend()

function BaseStrategy:new(actor, dungeon)
    self.actor = actor
    self.dungeon = dungeon

    self.stateMachine = StateMachine {
        ['idle'] = function() return EntityIdleState(self.actor, self.dungeon) end,
        ['combat'] = function() return EntityCombatState(self.actor, self.dungeon) end,
        ['flee'] = function() return EntityFleeState(self.actor, self.dungeon) end,
        ['roam'] = function() return EntityRoamState(self.actor, self.dungeon) end,
        ['sleep'] = function() return EntitySleepState(self.actor, self.dungeon) end,
    }

    if self.actor.undead then
        self:idle()
    else
        self:sleep()
    end
end

function BaseStrategy:update(dt)
    -- body
end

function BaseStrategy:sleep()
    self.stateMachine:change('sleep')
end

function BaseStrategy:idle()
    self.stateMachine:change('idle')
end

function BaseStrategy:combat()
    self.stateMachine:change('combat')
end

function BaseStrategy:flee()
    self.stateMachine:change('flee')
end

function BaseStrategy:roam()
    self.stateMachine:change('roam')
end

function BaseStrategy:getAction()
    error('should be implemented by subclasses')
end