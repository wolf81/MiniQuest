--[[
    GD50
    MiniQuest

    Author: Wolfgang Schreurs
    info+miniquest@wolftrail.net
]]

IdleAction = BaseAction:extend()

function IdleAction:new(actor, cost, sleeping)
    BaseAction.new(self, actor, cost)

    self.sleeping = sleeping or false
end

function IdleAction:perform(duration, onFinish)
    if self.sleeping then
        self.actor:changeAnimation('sleep')
    end

    self.actor.sync(duration, onFinish)
end
