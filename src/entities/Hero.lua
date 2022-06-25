--[[
    GD50
    MiniQuest

    Author: Wolfgang Schreurs
    info+miniquest@wolftrail.net
]]

Hero = Creature:extend()

function Hero:new(def, dungeon, x, y)
    Creature.new(self, def, dungeon, x, y)

    self.stateMachine = StateMachine {
        ['idle'] = function() return HeroIdleState(self) end,
        ['move'] = function() return HeroMoveState(self, dungeon) end,
    }
    self:changeState('idle')
end

function Hero:isMoving()
    return getmetatable(self.stateMachine.current) == HeroMoveState
end

function Hero:update(dt)
    Creature.update(self, dt)
end

function Hero:draw()
    Creature.draw(self)
end