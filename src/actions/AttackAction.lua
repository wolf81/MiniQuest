--[[
    GD50
    MiniQuest

    Author: Wolfgang Schreurs
    info+miniquest@wolftrail.net
]]

AttackAction = BaseAction:extend()

-- This is duplicated in MoveAction
local directionString = {
    [Direction.N]  = 'up',
    [Direction.NW] = 'up',
    [Direction.W]  = 'left',
    [Direction.SW] = 'left',
    [Direction.S]  = 'down',
    [Direction.SE] = 'down',
    [Direction.E]  = 'right',
    [Direction.NE] = 'right',
}

function AttackAction:new(actor, target)
    BaseAction.new(self, actor)

    local dx, dy = actor.x - target.x, actor.y - target.y
    local direction = nil
    if dx < 0 then direction = Direction.E
    elseif dx > 0 then direction = Direction.W
    elseif dy < 0 then direction = Direction.S
    elseif dy > 0 then direction = Direction.N
    else error('invalid direction') end

    local cost = getActionCosts(self.actor)
    self.direction = direction
    self.cost = cost.attack

    self.effect_x = target.x
    self.effect_y = target.y

    target:inflict(1)   
end

function AttackAction:isCombatAction()
    return true
end

function AttackAction:perform(actor, duration, onFinish)    
    actor.direction = self.direction
    actor:changeAnimation(directionString[actor.direction])

    local effect = Effect(EFFECT_DEFS['strike'], self.effect_x, self.effect_y)
    actor.dungeon:addEntity(effect)

    if effect.sound then
        gSounds[effect.sound]:play()
    end

    actor.sync(duration, onFinish)
end
