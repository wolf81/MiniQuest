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
    self.target:inflict(1)    

    local effect = Effect(EFFECT_DEFS['strike'], self.target.x, self.target.y)
    self.actor.dungeon:addEntity(effect)

    self.actor.action = nil
    onFinish()
end