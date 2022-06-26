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

    -- solid tiles block movement of most actors
    self.solid = def.solid or false
end