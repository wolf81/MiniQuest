--[[
    GD50
    MiniQuest

    Author: Wolfgang Schreurs
    info+miniquest@wolftrail.net
]]

HeroStrategy = BaseStrategy:extend()

-- the hero strategy just returns actions based on keyboard input
function HeroStrategy:getAction()
    if self.actor.action then return self.actor.action end

    local dir = nil

    if love.keyboard.isDown('kp4') then
        dir = Direction.W
    elseif love.keyboard.isDown('kp6') then
        dir = Direction.E
    elseif love.keyboard.isDown('kp8') then
        dir = Direction.N
    elseif love.keyboard.isDown('kp2') then
        dir = Direction.S
    elseif love.keyboard.isDown('kp9') then
        dir = Direction.NE
    elseif love.keyboard.isDown('kp7') then        
        dir = Direction.NW
    elseif love.keyboard.isDown('kp1') then
        dir = Direction.SW
    elseif love.keyboard.isDown('kp3') then        
        dir = Direction.SE
    elseif love.keyboard.isDown('kp5') then
        dir = Direction.NONE
    end

    if not dir then return nil end

    local heading = Direction.heading[dir]
    local x, y = self.actor.x + heading.x, self.actor.y + heading.y

    local target = self.dungeon:getActor(x, y)
    if dir == Direction.NONE then
        return IdleAction(self.actor)
    elseif target then
        return AttackAction(self.actor, target)
    elseif not self.dungeon:isBlocked(x, y) then
        return MoveAction(self.actor, dir)
    end

    return nil
end

