--[[
    GD50
    MiniQuest

    Author: Wolfgang Schreurs
    info+miniquest@wolftrail.net
]]

Tile = Entity:extend()

function Tile:new(def, x, y)
    Entity.new(self, def, x, y)

    self.id = def.id

    -- solid tiles block be passed through
    self.solid = def.solid or false
end