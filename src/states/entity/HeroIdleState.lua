--[[
    GD50
    MiniQuest

    Author: Wolfgang Schreurs
    info+miniquest@wolftrail.net
]]

HeroIdleState = ActorIdleState:extend()

function HeroIdleState:update(dt)
    if (love.keyboard.isDown('left') or 
        love.keyboard.isDown('right') or
        love.keyboard.isDown('up') or 
        love.keyboard.isDown('down')) then
        self.entity:changeState('move')
    end
end
