MoveAction = BaseAction:extend()

function MoveAction:new(actor, direction)
    BaseAction.new(self, actor)

    self.dx = 0
    self.dy = 0
    self.direction = direction

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

function MoveAction:perform(onFinish)
    onFinish = onFinish or function() end

    self.actor.direction = self.direction
    self.actor:changeAnimation(self.actor.direction)

    Timer.tween(0.1, {
        [self.actor] = { 
            x = self.actor.x + self.dx,
            y = self.actor.y + self.dy,
        }
    })
    :finish(function()
        self.actor.action = nil
        onFinish()
    end)
end