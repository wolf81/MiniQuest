Creature = Entity:extend()

function Creature:new(def, dungeon, x, y)
    Entity.new(self, def, x, y)

    self.direction = 'down'
    self.health = def.health or 1
    self.solid = true

    self.stateMachine = StateMachine {
        ['idle'] = function() return CreatureIdleState(self) end,
        ['move'] = function() return CreatureMoveState(self, dungeon) end,
    }
    self:changeState('idle')
end

function Creature:isMoving()
    return getmetatable(self.stateMachine.current) == CreatureMoveState
end

function Creature:isIdling()
    return getmetatable(self.stateMachine.current) == CreatureIdleState
end