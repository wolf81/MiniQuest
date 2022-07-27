--[[
    GD50
    MiniQuest

    Author: Wolfgang Schreurs
    info+miniquest@wolftrail.net
]]

EntityFleeState = BaseState:extend()

local DIJKSTRA_SAFETY_CONSTANT = -1.6

local function getAdjacentCells(cart_move_cost, ord_move_cost)
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

function EntityFleeState:enter(actor)
    actor:addEffect('state', 'flee')
end

function EntityFleeState:new(dungeon)
    self.dungeon = dungeon
end

function EntityFleeState:update(actor)
    local hero = self.dungeon.scheduler.hero
    local sight = actor.sight * 2

    if (hero.x < actor.x - sight or 
        hero.x > actor.x + sight or
        hero.y < actor.y - sight or
        hero.y > actor.y + sight) then
        return actor:idle()
    end
end

function EntityFleeState:getAction(actor)
    local actions = {}

    while true do
        local move_cost = math.ceil(BASE_ENERGY_COST / actor.move_speed)
        local ord_move_cost = math.ceil(move_cost * ORDINAL_MOVE_FACTOR)

        if actor.energy < move_cost then break end

        local adjacent_cells = getAdjacentCells(move_cost, 
            actor.energy >= ord_move_cost and ord_move_cost or nil)

        local x, y = actor:nextPosition()
        for idx, cell in ripairs(adjacent_cells) do
            local heading = Direction.heading[cell.dir]
            local x1, y1 = x + heading.x, y + heading.y
            local v = self.dungeon.movement.get(x1, y1)
            local target = self.dungeon:getActor(x1, y1)

            if isNan(v) or target ~= nil then 
                table.remove(adjacent_cells, idx)
            else 
                cell.v = v * DIJKSTRA_SAFETY_CONSTANT
            end
        end

        table.sort(adjacent_cells, function(a, b) return a.v < b.v end)

        if #adjacent_cells > 0 then
            local cell = adjacent_cells[1]
            actor.energy = actor.energy - cell.cost
            actions[#actions + 1] = MoveAction(actor, cell.dir)
        else
            break
        end        
    end

    if #actions == 0 then 
        return nil
    elseif #actions == 1 then 
        actor.morale = actor.morale + 1
        return actions[1]
    else 
        actor.morale = actor.morale + 1
        return CompositeAction(actor, actions) 
    end
end
