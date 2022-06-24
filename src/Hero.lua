--[[
    GD50
    MiniQuest

    Author: Wolfgang Schreurs
    info+miniquest@wolftrail.net
]]

Hero = Entity:extend()

function Hero:new(def, dungeon)
    Entity.new(self, def)

    self.stateMachine = StateMachine {
        ['idle'] = function() return EntityIdleState(self) end,
        ['move'] = function() return EntityMoveState(self, dungeon) end,
    }
    self:changeState('idle')
end

function Hero:update(dt)
    Entity.update(self, dt)
end

function Hero:draw()
    Entity.draw(self)
end