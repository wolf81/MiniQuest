--[[
    GD50
    MiniQuest

    Author: Wolfgang Schreurs
    info+miniquest@wolftrail.net
]]

Hero = Actor:extend()

function Hero:getAction()
    if self.action ~= nil then return end

    local direction = nil

    if love.keyboard.isDown('left') then
        direction = 'left'
    elseif love.keyboard.isDown('right') then
        direction = 'right'
    elseif love.keyboard.isDown('up') then
        direction = 'up'
    elseif love.keyboard.isDown('down') then
        direction = 'down'
    end

    if not direction then return nil end

    local dxy = directionToVector(direction)
    local x, y = self.x + dxy.x, self.y + dxy.y

    if not self.dungeon:isBlocked(x, y) then
        self.action = MoveAction(self, direction)
    else
        local target = self.dungeon:getActor(x, y)
        if target ~= nil then
            self.action = AttackAction(self, target)
        end
    end

    return self.action
end