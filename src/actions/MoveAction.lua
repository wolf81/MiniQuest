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
    self.actor.direction = self.direction
    self.actor:changeAnimation(self.actor.direction)

    local x = self.actor.x + self.dx
    local y = self.actor.y + self.dy

    Timer.tween(0.01, {
        [self.actor] = { 
            x = x,
            y = y,
        }
    })
    :finish(function()
        self.actor.action = nil
        onFinish()
    end)
end