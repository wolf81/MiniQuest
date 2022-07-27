--[[
    GD50
    MiniQuest

    Author: Wolfgang Schreurs
    info+miniquest@wolftrail.net
]]

IdleAction = BaseAction:extend()

function IdleAction:new(actor, sleeping)
    BaseAction.new(self, actor)

    self.sleeping = sleeping or false
end

function IdleAction:perform(actor, duration, onFinish)
    if self.sleeping then
        self.actor:changeAnimation('sleep')
    end

    actor.sync(duration, onFinish)
end
