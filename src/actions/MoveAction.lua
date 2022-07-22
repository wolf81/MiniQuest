--[[
    GD50
    MiniQuest

    Author: Wolfgang Schreurs
    info+miniquest@wolftrail.net
]]

MoveAction = BaseAction:extend()

function MoveAction:new(actor, direction)
    BaseAction.new(self, actor)
    
    self.dx = 0
    self.dy = 0
    self.direction = direction
    self.cost = math.ceil(self.cost / actor.move_speed) 

    if self.direction == 'left' then
        self.dx = -1
    elseif self.direction == 'right' then
        self.dx = 1
    elseif self.direction == 'up' then
        self.dy = -1
    elseif self.direction == 'down' then
        self.dy = 1
    else
        error('invalid direction: ' .. self.direction)
    end
end

function MoveAction:prepare()
    self.actor.direction = self.direction
    self.actor.next_x = self.actor.x + self.dx
    self.actor.next_y = self.actor.y + self.dy
end

function MoveAction:perform(onFinish)
    self.actor:changeAnimation(self.actor.direction)

    Timer.tween(0.25, {
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