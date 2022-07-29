--[[
    GD50
    MiniQuest

    Author: Wolfgang Schreurs
    info+miniquest@wolftrail.net
]]

DestroyAction = BaseAction:extend()

function DestroyAction:new(actor)
    BaseAction.new(self, actor)

    self.actor.alpha = 0.0
end

function DestroyAction:perform(actor, duration, onFinish)
    actor.sync(duration, function()
        self.actor.remove = true
        onFinish()
    end)
end