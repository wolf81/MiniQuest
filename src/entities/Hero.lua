--[[
    GD50
    MiniQuest

    Author: Wolfgang Schreurs
    info+miniquest@wolftrail.net
]]

Hero = Actor:extend()

function Hero:getAction()
    if self.action ~= nil then return end

    local direction, dx, dy = nil, 0, 0

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

    if direction and not self.dungeon:isBlocked(self.x + dx, self.y + dy) then
        self.action = MoveAction(self, direction)
        return self.action
    end
end