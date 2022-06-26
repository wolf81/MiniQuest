--[[
    GD50
    MiniQuest

    Author: Wolfgang Schreurs
    info+miniquest@wolftrail.net
]]

HeroStrategy = BaseStrategy:extend()

-- the hero strategy just returns actions based on keyboard input
function HeroStrategy:getAction()
    if self.actor.action then return end

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
    local x, y = self.actor.x + dxy.x, self.actor.y + dxy.y

    local target = self.dungeon:getActor(x, y)
    if target then
        return AttackAction(self.actor, target)
    elseif not self.dungeon:isBlocked(x, y) then
        return MoveAction(self.actor, direction)
    end

    return nil
end

