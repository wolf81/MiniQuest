--[[
    GD50
    MiniQuest

    Author: Wolfgang Schreurs
    info+miniquest@wolftrail.net
]]

StateMachine = Object:extend()

function StateMachine:new(states)
    self.empty = {
        draw = function() end,
        update = function() end,
        enter = function() end,
        exit = function() end
    }
    self.states = states or {} -- [name] -> [function that returns states]
    self.current = self.empty
end

function StateMachine:change(stateName, enterParams)
    assert(self.states[stateName], 'state does not exist: ', stateName) -- state must exist!
    self.current:exit()
    self.current = self.states[stateName]()
    self.current:enter(enterParams)
end

function StateMachine:update(dt)
    self.current:update(dt)
end

function StateMachine:draw()
    self.current:draw()
end
