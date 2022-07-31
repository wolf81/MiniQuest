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

local function animateHit(target, duration)
    local halfDuration = duration / 2

    Timer.tween(
        halfDuration, 
        target, 
        { color = { 1.0, 0.0, 0.0, 1.0 }}, 
        'linear', 
        function()
            Timer.tween(
                halfDuration,
                target,
                { color = { 1.0, 0.0, 0.0, 0.0 }}, 
                'linear'
            )
        end
    )
end

function AttackAction:new(actor, cost, target)
    BaseAction.new(self, actor, cost)

    local dx, dy = actor.x - target.x, actor.y - target.y
    local direction = nil
    if dx < 0 then direction = Direction.E
    elseif dx > 0 then direction = Direction.W
    elseif dy < 0 then direction = Direction.S
    elseif dy > 0 then direction = Direction.N
    else error('invalid direction') end

    self.target = target
    self.direction = direction

    local dmg_melee = self.actor.stats:get('dmg_melee')
    local att_bonus = self.actor.stats:get('att_melee')
    local att_roll = ndn.dice('1d20').roll()
    local target_ac = target.stats:get('ac')

    -- TODO: support critical hits on natural 20 roll
    self.is_hit = (att_roll + att_bonus) > target_ac

    print(att_roll .. ' + ' .. att_bonus .. ' vs ' .. target_ac)

    if self.is_hit then
        print('hit for ' .. dmg_melee)
        target:inflict(dmg_melee)   
    else
        print('miss')
    end
end

function AttackAction:isCombatAction()
    return true
end

function AttackAction:perform(duration, onFinish)
    if self.is_hit then
        animateHit(self.target, duration)
    end

    self.actor.direction = self.direction
    self.actor:changeAnimation(directionString[self.actor.direction])

    local effect = Effect(EFFECT_DEFS['strike'], self.target.x, self.target.y)
    self.actor.dungeon:addEntity(effect)

    if effect.sound then
        gSounds[effect.sound]:play()
    end

    self.actor.sync(duration, onFinish)
end
