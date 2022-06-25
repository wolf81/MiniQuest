Actor = Entity:extend()

function Actor:new(def, dungeon, x, y)
    Entity.new(self, def, x, y)

    self.direction = 'down'
    self.health = def.health or 1
    self.solid = true

    self.stateMachine = StateMachine {
        ['idle'] = function() return ActorIdleState(self) end,
        ['move'] = function() return ActorMoveState(self, dungeon) end,
    }
    self:changeState('idle')
end

function Actor:isMoving()
    return getmetatable(self.stateMachine.current) == ActorMoveState
end

function Actor:isIdling()
    return getmetatable(self.stateMachine.current) == ActorIdleState
end