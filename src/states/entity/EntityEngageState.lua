--[[
    GD50
    MiniQuest

    Author: Wolfgang Schreurs
    info+miniquest@wolftrail.net
]]

local mabs, mceil = math.abs, math.ceil

EntityEngageState = BaseState:extend()

-- calculate of this entity is standing next to a hero
local function isAdjacent(actor, target)
    local actor_x, actor_y = actor:nextPosition()
    local target_x, target_y = target:nextPosition()   
    local dx, dy = mabs(actor_x - target_x), mabs(actor_y - target_y)
    return dx <= 1 and dy <= 1
end

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

function EntityEngageState:enter()
    print('enter engage state')
end

function EntityEngageState:new(entity, dungeon)
    self.entity = entity
    self.dungeon = dungeon
    self.action = nil
end

function EntityEngageState:update()
    self.action = nil

    local hero = self.dungeon.hero
    local sight = 5

    -- if hero out of range, transition to idle state
    if (hero.x < self.entity.x - sight or 
        hero.x > self.entity.x + sight or
        hero.y < self.entity.y - sight or
        hero.y > self.entity.y + sight) then
        self.entity.strategy:idle()
        return
    end
end

function EntityEngageState:getAction()
    local actions = {}
    local attack_cost = mceil(BASE_ENERGY_COST / self.entity.attack_speed)
    local move_cost = mceil(BASE_ENERGY_COST / self.entity.move_speed)

    while true do
        if isAdjacent(self.entity, self.dungeon.hero) then
            if self.entity.energy >= attack_cost then
                self.entity.energy = self.entity.energy - attack_cost
                actions[#actions + 1] = AttackAction(self.entity, self.dungeon.hero)
            else
                break
            end
        elseif self.entity.energy >= move_cost then        
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

            table.sort(adjacent_cells, function(a, b) return a.v < b.v end)

            if #adjacent_cells > 0 then
                local cell = adjacent_cells[1]
                if not isNan(cell.v) then
                    self.entity.energy = self.entity.energy - cell.cost
                    actions[#actions + 1] = MoveAction(self.entity, cell.dir)
                end
            end
        else
            break
        end
    end

    if #actions == 0 then
        return nil
    elseif #actions == 1 then
        return actions[1]
    else
        return CompositeAction(self.entity, actions)
    end
end