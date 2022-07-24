--[[
    GD50
    MiniQuest

    Author: Wolfgang Schreurs
    info+miniquest@wolftrail.net
]]

EntityFleeState = BaseState:extend()

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

function EntityFleeState:enter()
    print('enter flee state')
end

function EntityFleeState:new(entity, dungeon)
    self.entity = entity
    self.dungeon = dungeon
    self.action = nil
end

function EntityFleeState:update()
    local hero = self.dungeon.hero

    local sight = 5

    if (hero.x < self.entity.x - sight or 
        hero.x > self.entity.x + sight or
        hero.y < self.entity.y - sight or
        hero.y > self.entity.y + sight) then
        self.entity.strategy:idle()
    end
end

function EntityFleeState:getAction()
    local move_cost = math.ceil(BASE_ENERGY_COST / self.entity.move_speed)
    local actions = {}

    while self.entity.energy >= move_cost do
        self.entity.energy = self.entity.energy - move_cost

        local ord_move_cost = math.ceil(move_cost * ORDINAL_MOVE_FACTOR)
        local adjacent_cells = getAdjacentCells(move_cost, 
            self.entity.energy >= ord_move_cost and ord_move_cost or nil)

        local x, y = self.entity:nextPosition()
        for idx, cell in ripairs(adjacent_cells) do
            local heading = Direction.heading[cell.dir]
            local x1, y1 = x + heading.x, y + heading.y
            local v = self.dungeon.movement.get(x1, y1)
            local target = self.dungeon:getActor(x1, y1)

            if isNan(v) or target ~= nil then 
                table.remove(adjacent_cells, idx)
            else 
                cell.v = v
            end
        end

        table.sort(adjacent_cells, function(a, b) return a.v > b.v end)

        if #adjacent_cells > 0 then
            local cell = adjacent_cells[1]
            if not isNan(cell.v) then
                self.entity.energy = self.entity.energy - cell.cost
                actions[#actions + 1] = MoveAction(self.entity, cell.dir)
            end
        end        
    end

    if #actions == 0 then 
        return nil
    elseif #actions == 1 then 
        self.entity.morale = self.entity.morale + 1
        return actions[1]
    else 
        self.entity.morale = self.entity.morale + 1
        return CompositeAction(self.entity, actions) 
    end
end
