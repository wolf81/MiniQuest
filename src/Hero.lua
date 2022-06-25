--[[
    GD50
    MiniQuest

    Author: Wolfgang Schreurs
    info+miniquest@wolftrail.net
]]

Hero = Creature:extend()

function Hero:new(def, dungeon)
    Creature.new(self, def, dungeon)
end

function Hero:update(dt)
    Creature.update(self, dt)
end

function Hero:draw()
    Creature.draw(self)
end