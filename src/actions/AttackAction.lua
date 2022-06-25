--[[
    GD50
    MiniQuest

    Author: Wolfgang Schreurs
    info+miniquest@wolftrail.net
]]

AttackAction = BaseAction:extend()

function AttackAction:new(actor, target)
    BaseAction.new(self, actor)

    self.target = target
end

function AttackAction:perform(onFinish)
    onFinish = onFinish or function() end

    self.target:inflict(1)

    self.actor.action = nil

    onFinish()
end