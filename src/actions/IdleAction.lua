--[[
    GD50
    MiniQuest

    Author: Wolfgang Schreurs
    info+miniquest@wolftrail.net
]]

IdleAction = BaseAction:extend()

function IdleAction:new(actor)
    BaseAction.new(self, actor)
end

function IdleAction:perform(onFinish)
    self.actor.action = nil
    onFinish()
end
