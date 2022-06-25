--[[
    GD50
    MiniQuest

    Author: Wolfgang Schreurs
    info+miniquest@wolftrail.net
]]

Hero = Creature:extend()

function Hero:new(def, dungeon)
    Creature.new(self, def, dungeon)

    self.stateMachine = StateMachine {
        ['idle'] = function() return CreatureIdleState(self) end,
        ['move'] = function() return HeroMoveState(self, dungeon) end,
    }
    self:changeState('idle')
end

function Hero:update(dt)
    Creature.update(self, dt)
end

function Hero:draw()
    Creature.draw(self)
end