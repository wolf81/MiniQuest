--[[
    GD50
    MiniQuest

    Author: Wolfgang Schreurs
    info+miniquest@wolftrail.net
]]

EntityFleeState = EntityBaseState:extend()

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

function EntityFleeState:update()
    local hero = self.dungeon.scheduler.hero

    local morale_max = self.actor.stats:get('morale')
    if not self:isTargetInSight(hero, self.actor.stats:get('sight') * 2) or self.actor.morale == morale_max then
        return self.actor:idle()
    end
end

function EntityFleeState:getAction()
    local actions = {}

    while true do
        local cost = getActionCosts(self.actor)

        if self.actor.energy < cost.move_cart then break end

        local adjacent_cells = self:getAdjacentCells(cost.move_cart, 
            self.actor.energy >= cost.move_ordi and cost.move_ordi or nil)

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
        local morale_max = self.actor.stats:get('morale')
        self.actor.morale = math.min(self.actor.morale + 1, morale_max)

        return actions[1]
    else 
        local morale_max = self.actor.stats:get('morale')
        self.actor.morale = math.min(self.actor.morale + 1, morale_max)

        return CompositeAction(self.actor, actions) 
    end
end
