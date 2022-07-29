--[[
    GD50
    MiniQuest

    Author: Wolfgang Schreurs
    info+miniquest@wolftrail.net
]]

EntityDestroyState = EntityBaseState:extend()

function EntityDestroyState:enter()
    if DEBUG then
        self.actor:addEffect('state', 'destroy')
    end
end

function EntityDestroyState:exit()
    self.actor:removeEffect('state')
end

function EntityDestroyState:getAction()
    return DestroyAction(self.actor)
end