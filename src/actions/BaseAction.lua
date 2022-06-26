--[[
    GD50
    MiniQuest

    Author: Wolfgang Schreurs
    info+miniquest@wolftrail.net
]]

BaseAction = Object:extend()

function BaseAction:new(actor)
    self.actor = actor
end

function BaseAction:perform(onFinish)
    error('perform should be implemented by subclasses')
end