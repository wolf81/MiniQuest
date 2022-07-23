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
        ['engage'] = function() return EntityEngageState(self.actor, self.dungeon) end,
    }
    self.stateMachine:change('idle', {})
end

function BaseStrategy:update(dt)
    -- body
end

function BaseStrategy:idle()
    self.stateMachine:change('idle')
end

function BaseStrategy:engage()
    self.stateMachine:change('engage')
end

function BaseStrategy:getAction()
    error('should be implemented by subclasses')
end