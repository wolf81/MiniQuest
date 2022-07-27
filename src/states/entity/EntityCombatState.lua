--[[
    GD50
    MiniQuest

    Author: Wolfgang Schreurs
    info+miniquest@wolftrail.net
]]

local mabs, mceil = math.abs, math.ceil

EntityCombatState = BaseState:extend()

-- calculate if this entity is standing next to a hero
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

function EntityCombatState:enter(actor)
    actor:addEffect('state', 'combat')

    print('enter combat state')
end

function EntityCombatState:new(dungeon)
    self.dungeon = dungeon
end

function EntityCombatState:update(actor)
    local hero_x, hero_y = self.dungeon.scheduler.hero:nextPosition()
    local sight = actor.sight

    if actor.morale == 1 then
        return actor:flee()
    end

    -- if hero out of range, transition to idle state
    if (hero_x < actor.x - sight or 
        hero_x > actor.x + sight or
        hero_y < actor.y - sight or
        hero_y > actor.y + sight) then
        if not actor.undead then
            return actor:roam()
        else
            return actor:idle()
        end
    end
end

function EntityCombatState:getAction(actor)
    local actions = {}

    while true do
        local attack_cost = mceil(BASE_ENERGY_COST / actor.attack_speed)
        local move_cost = mceil(BASE_ENERGY_COST / actor.move_speed)

        if isAdjacent(actor, self.dungeon.scheduler.hero) then
            if actor.energy >= attack_cost then
                actor.energy = actor.energy - attack_cost
                actions[#actions + 1] = AttackAction(actor, self.dungeon.scheduler.hero)
            else
                break
            end
        elseif actor.energy >= move_cost then        
            local ord_move_cost = math.ceil(move_cost * ORDINAL_MOVE_FACTOR)
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
                    cell.v = v
                end
            end

            table.sort(adjacent_cells, function(a, b) return a.v < b.v end)

            if #adjacent_cells > 0 then
                local cell = adjacent_cells[1]
                if not isNan(cell.v) then
                    actor.energy = actor.energy - cell.cost
                    actions[#actions + 1] = MoveAction(actor, cell.dir)
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
        return CompositeAction(actor, actions)
    end
end
