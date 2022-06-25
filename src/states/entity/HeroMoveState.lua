--[[
    GD50
    MiniQuest

    Author: Wolfgang Schreurs
    info+miniquest@wolftrail.net
]]

HeroMoveState = CreatureMoveState:extend()

function HeroMoveState:update(dt)
    if self.started then return end

    self.started = true

    local direction = nil
    local dx, dy = 0, 0

    if love.keyboard.isDown('left') then
        direction = 'left'
        dx = -1
    elseif love.keyboard.isDown('right') then
        direction = 'right'
        dx = 1
    elseif love.keyboard.isDown('up') then
        direction = 'up'
        dy = -1
    elseif love.keyboard.isDown('down') then
        direction = 'down'
        dy = 1
    end

    if direction then
        self.entity.direction = direction
        self.entity:changeAnimation(self.entity.direction)

        Timer.tween(0.2, {
            [self.entity] = { 
                x = self.entity.x + dx,
                y = self.entity.y + dy,
            }
        })
        :finish(function()
            self.entity:changeState('idle')
        end)
    else
        self.entity:changeState('idle')
    end
end