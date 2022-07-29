--[[
    GD50
    MiniQuest

    Author: Wolfgang Schreurs
    info+miniquest@wolftrail.net
]]

EntityBaseState = BaseState:extend()

function EntityBaseState:new(actor, dungeon)
    self.actor = actor
    self.dungeon = dungeon
end

function EntityBaseState:getAdjacentCells(cart_move_cost, ord_move_cost)
    if ord_move_cost then 
        return {
            { dir = Direction.N,  cost = cart_move_cost },
            { dir = Direction.W,  cost = cart_move_cost },
            { dir = Direction.E,  cost = cart_move_cost },
            { dir = Direction.S,  cost = cart_move_cost },
            { dir = Direction.NW, cost = ord_move_cost  },
            { dir = Direction.SW, cost = ord_move_cost  },
            { dir = Direction.NE, cost = ord_move_cost  },
            { dir = Direction.SE, cost = ord_move_cost  },
        }
    end

    return {
        { dir = Direction.N, cost = cart_move_cost },
        { dir = Direction.W, cost = cart_move_cost },
        { dir = Direction.E, cost = cart_move_cost },
        { dir = Direction.S, cost = cart_move_cost },
    }
end

function EntityBaseState:isAdjacent(target)
    return getDistance(self.actor.x, self.actor.y, target.x, target.y) <= ORDINAL_MOVE_FACTOR
end

function EntityBaseState:isTargetInSight(target, sight)
    local sight = sight or self.actor.sight
    return getDistance(self.actor.x, self.actor.y, target.x, target.y) <= sight 
end

function EntityBaseState:getAction()
    error('should be implemented by subclasses')
end
