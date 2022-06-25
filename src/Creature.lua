Creature = Entity:extend()

function Creature:new(def, dungeon)
    Entity.new(self, def)

    self.direction = 'down'

    self.health = def.health or 1

    self.stateMachine = StateMachine {
        ['idle'] = function() return CreatureIdleState(self) end,
        ['move'] = function() return CreatureMoveState(self, dungeon) end,
    }
    self:changeState('idle')
end