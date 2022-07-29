--[[
    GD50
    MiniQuest

    Author: Wolfgang Schreurs
    info+miniquest@wolftrail.net
]]

local mabs, mceil = math.abs, math.ceil

EntityCombatState = EntityBaseState:extend()

function EntityCombatState:enter()
    if DEBUG then
        self.actor:addEffect('state', 'combat')
    end
end

function EntityCombatState:exit()
    self.actor:removeEffect('state')
end

function EntityCombatState:update()
    local hero = self.dungeon.scheduler.hero

    if not hero:isAlive() then
        self.actor:idle()
    end

    if self.actor.morale == 1 then
        return self.actor:flee()
    end

    if not self:isTargetInSight(hero, self.actor.sight) then
        if not self.actor.undead then
            return self.actor:roam()            
        else
            return self.actor:idle()
        end
    end
end

function EntityCombatState:getAction()
    if not self.actor:isAlive() then return nil end

    local actions = {}
    local hero = self.dungeon.scheduler.hero

    while true do
        local cost = self:getActionCosts()

        local done = false

        if self:isAdjacent(hero) and hero:isAlive() then
            if self.actor.energy >= cost.attack then
                self.actor.energy = self.actor.energy - cost.attack
                actions[#actions + 1] = AttackAction(self.actor, hero)
            else
                done = true
            end
        elseif self.actor.energy >= cost.move_cart then        
            local adjacent_cells = self:getAdjacentCells(cost.move_cart, 
                self.actor.energy >= cost.move_ordi and cost.move_ordi or nil)

            local x, y = self.actor:nextPosition()
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

            if #adjacent_cells == 0 then
                done = true
            else
                local cell = adjacent_cells[1]
                if not isNan(cell.v) then
                    self.actor.energy = self.actor.energy - cell.cost
                    actions[#actions + 1] = MoveAction(self.actor, cell.dir)
                end
            end
        else
            done = true
        end

        if done then break end
    end

    if #actions == 0 then
        return nil
    elseif #actions == 1 then
        return actions[1]
    else
        return CompositeAction(self.actor, actions)
    end
end
