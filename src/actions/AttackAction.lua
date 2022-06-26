--[[
    GD50
    MiniQuest

    Author: Wolfgang Schreurs
    info+miniquest@wolftrail.net
]]

AttackAction = BaseAction:extend()

function AttackAction:new(actor, target)
    BaseAction.new(self, actor)

    local dx, dy = actor.x - target.x, actor.y - target.y
    local direction = nil
    if dx < 0 then direction = 'right'
    elseif dx > 0 then direction = 'left'
    elseif dy < 0 then direction = 'down'
    elseif dy > 0 then direction = 'up'
    else error('invalid direction') end

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

    Timer.after(0.1, function()
        self.actor.action = nil
        onFinish()
    end)
end