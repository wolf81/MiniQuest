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

    local dir = nil

    if love.keyboard.isDown('left') or love.keyboard.isDown('kp4') then
        dir = Direction.W
    elseif love.keyboard.isDown('right') or love.keyboard.isDown('kp6') then
        dir = Direction.E
    elseif love.keyboard.isDown('up') or love.keyboard.isDown('kp8') then
        dir = Direction.N
    elseif love.keyboard.isDown('down') or love.keyboard.isDown('kp2') then
        dir = Direction.S
    end

    if not dir then return nil end

    local heading = Direction.heading[dir]
    local x, y = self.actor.x + heading.x, self.actor.y + heading.y

    local target = self.dungeon:getActor(x, y)
    if target then
        return AttackAction(self.actor, target)
    elseif not self.dungeon:isBlocked(x, y) then
        return MoveAction(self.actor, dir)
    end

    return nil
end

