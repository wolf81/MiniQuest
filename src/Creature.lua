Creature = Entity:extend()

function Creature:new(def, dungeon)
    Entity.new(self, def)

    self.direction = 'down'

    self.health = def.health or 1

    self.stateMachine = StateMachine {
        ['idle'] = function() return EntityIdleState(self) end,
        ['move'] = function() return EntityMoveState(self, dungeon) end,
    }
    self:changeState('idle')
end