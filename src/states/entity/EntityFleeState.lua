--[[
    GD50
    MiniQuest

    Author: Wolfgang Schreurs
    info+miniquest@wolftrail.net
]]

EntityFleeState = EntityBaseState:extend()

local DIJKSTRA_SAFETY_CONSTANT = -1.6

function EntityFleeState:enter()
    if DEBUG then
        self.actor:addEffect('state', 'flee')
    end

    self.actor:addEffect('fear')
end

function EntityFleeState:exit()
    self.actor:removeEffect('state')

    self.actor:removeEffect('fear')
end

function EntityFleeState:update(actor)
    local hero = self.dungeon.scheduler.hero

    if not self:isTargetInSight(hero, self.actor.sight * 2) then
        return self.actor:idle()
    end
end

function EntityFleeState:getAction()
    local actions = {}

    while true do
        local move_cost = math.ceil(BASE_ENERGY_COST / self.actor.move_speed)
        local ord_move_cost = math.ceil(move_cost * ORDINAL_MOVE_FACTOR)

        if self.actor.energy < move_cost then break end

        local adjacent_cells = self:getAdjacentCells(move_cost, 
            self.actor.energy >= ord_move_cost and ord_move_cost or nil)

        for idx, cell in ripairs(adjacent_cells) do
            local heading = Direction.heading[cell.dir]
            local x1, y1 = self.actor.x + heading.x, self.actor.y + heading.y
            local v = self.dungeon.movement.get(x1, y1)
            local target = self.dungeon:getActor(x1, y1)

            if isNan(v) or target then 
                table.remove(adjacent_cells, idx)
            else 
                cell.v = v * DIJKSTRA_SAFETY_CONSTANT
            end
        end

        table.sort(adjacent_cells, function(a, b) return a.v < b.v end)

        if #adjacent_cells > 0 then
            local adj_cell = adjacent_cells[1]
            self.actor.energy = self.actor.energy - adj_cell.cost
            actions[#actions + 1] = MoveAction(self.actor, adj_cell.dir)
        else            
            break
        end        
    end

    if #actions == 0 then 
        return nil
    elseif #actions == 1 then 
        self.actor.morale = self.actor.morale + 1
        return actions[1]
    else 
        self.actor.morale = self.actor.morale + 1
        return CompositeAction(self.actor, actions) 
    end
end
