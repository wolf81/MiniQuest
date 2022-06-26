--[[
    GD50
    MiniQuest

    Author: Wolfgang Schreurs
    info+miniquest@wolftrail.net
]]

AttackAction = BaseAction:extend()

function AttackAction:new(actor, target, direction)
    BaseAction.new(self, actor)

    self.target = target
    self.direction = direction
end

function AttackAction:perform(onFinish)
    self.actor.direction = self.direction
    self.actor:changeAnimation(self.actor.direction)

    self.target:inflict(1)    

    local effect = Effect(EFFECT_DEFS['strike'], self.target.x, self.target.y)
    self.actor.dungeon:addEntity(effect)

    if effect.sound then
        gSounds[effect.sound]:play()
    end

    self.actor.action = nil
    onFinish()
end