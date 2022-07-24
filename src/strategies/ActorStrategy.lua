--[[
    GD50
    MiniQuest

    Author: Wolfgang Schreurs
    info+miniquest@wolftrail.net
]]

ActorStrategy = BaseStrategy:extend()

local BASE_ENERGY_COST = 100

function ActorStrategy:getAction()
    self.stateMachine.current:update()

    return self.stateMachine.current:getAction()
end
