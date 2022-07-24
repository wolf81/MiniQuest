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

    if love.keyboard.isDown('kp4') or love.keyboard.isDown('h') then
        dir = Direction.W
    elseif love.keyboard.isDown('kp6') or love.keyboard.isDown('l') then
        dir = Direction.E
    elseif love.keyboard.isDown('kp8') or love.keyboard.isDown('k') then
        dir = Direction.N
    elseif love.keyboard.isDown('kp2') or love.keyboard.isDown('j') then
        dir = Direction.S
    elseif love.keyboard.isDown('kp9') or love.keyboard.isDown('u') then
        dir = Direction.NE
    elseif love.keyboard.isDown('kp7') or love.keyboard.isDown('y') then        
        dir = Direction.NW
    elseif love.keyboard.isDown('kp1') or love.keyboard.isDown('b') then
        dir = Direction.SW
    elseif love.keyboard.isDown('kp3') or love.keyboard.isDown('n') then        
        dir = Direction.SE
    elseif love.keyboard.isDown('kp5') or love.keyboard.isDown('.') then
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
        local move = MoveAction(self.actor, dir)
        -- TODO: this is ugly, but I think we need to do this order to get the
        -- next position of hero set properly, so other entities can move 
        -- towards hero
        self.dungeon:updateMovementGraph()
        return move
    end

    return nil
end

