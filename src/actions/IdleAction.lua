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

function IdleAction:perform(duration, onFinish)
    if self.sleeping then
        self.actor:changeAnimation('sleep')

        local effect = Effect(EFFECT_DEFS['sleep'], self.actor.x, self.actor.y)
        self.actor.dungeon:addEntity(effect)
    end

    self.actor.action = nil
    onFinish()
end
