--[[
    GD50
    MiniQuest

    Author: Wolfgang Schreurs
    info+miniquest@wolftrail.net
]]

MoveAction = BaseAction:extend()

-- This is duplicated in AttackAction
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

function MoveAction:new(actor, direction)
    BaseAction.new(self, actor)
    
    self.direction = direction
    self.cost = math.ceil(self.cost / actor.move_speed) 
    if Direction.isOrdinal(direction) then
        self.cost = math.ceil(self.cost * ORDINAL_MOVE_FACTOR)
    end

    local heading = Direction.heading[direction]
    self.actor.direction = self.direction
    self.actor.x = self.actor.x + heading.x
    self.actor.y = self.actor.y + heading.y
end

function MoveAction:perform(actor, duration, onFinish)
    actor:changeAnimation(directionString[self.actor.direction])
    actor.sync(duration, onFinish)
end
