--[[
    GD50
    MiniQuest

    Author: Wolfgang Schreurs
    info+miniquest@wolftrail.net
]]

ActorStrategy = {}

local BASE_ENERGY_COST = 100

function ActorStrategy.getAction(actor)
    actor.stateMachine.current:update(actor)

    return actor.stateMachine.current:getAction(actor)
end
