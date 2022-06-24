--[[
    GD50
    MiniQuest

    Author: Wolfgang Schreurs
    info+miniquest@wolftrail.net
]]

Hero = Entity:extend(def)

function Hero:new(def)
    Entity.new(self, def)
end

function Hero:update(dt)
    Entity.update(self, dt)
end

function Hero:draw()
    Entity.draw(self)
end