--[[
    GD50
    MiniQuest

    Author: Wolfgang Schreurs
    info+miniquest@wolftrail.net
]]

MoveAction = BaseAction:extend()

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
    
    self.dx = 0
    self.dy = 0
    self.direction = direction
    self.cost = math.ceil(self.cost / actor.move_speed) 
    if Direction.isOrdinal(direction) then
        self.cost = self.cost + math.sqrt(2)
    end

    local heading = Direction.heading[direction]
    self.dx = heading.x
    self.dy = heading.y

    local x, y = self.actor:nextPosition()
    self.actor.direction = directionString[self.direction]
    self.actor.next_x = x + self.dx
    self.actor.next_y = y + self.dy
end

function MoveAction:perform(duration, onFinish)
    self.actor:changeAnimation(self.actor.direction)

    Timer.tween(duration, {
        [self.actor] = { 
            x = self.actor.next_x,
            y = self.actor.next_y,
        }
    })
    :finish(function()
        self.actor.action = nil
        onFinish()
    end)
end
