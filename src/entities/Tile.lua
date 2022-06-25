Tile = Entity:extend()

function Tile:new(def, x, y)
    Entity.new(self, def, x, y)

    self.id = def.id
    self.solid = def.solid or false
end