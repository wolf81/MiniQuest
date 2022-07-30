--[[
    GD50
    MiniQuest

    Author: Wolfgang Schreurs
    info+miniquest@wolftrail.net
]]

local mceil = math.ceil

EntityRoamState = EntityBaseState:extend()

function EntityRoamState:enter()
    if DEBUG then
        self.actor:addEffect('state', 'roam')
    end

    self.turns = love.math.random(5, 10)
end

function EntityRoamState:exit()
    self.actor:removeEffect('state')
end

function EntityRoamState:update()
    if self:isTargetInSight(self.dungeon.scheduler.hero) then
        return self.actor:combat()
    end

    self.turns = self.turns - 1

    if self.turns == 0 then
        return self.actor:sleep()
    end
end

function EntityRoamState:getAction()
     local actions = {}
 
     local dirs = shuffle({ 
         Direction.N, Direction.E, Direction.S, Direction.W, 
     })    
     if oneIn(2) then
        table.insert(dirs, 1, self.actor.direction)
     end
 
    while true do
        local cost = getActionCosts(self.actor)
 
        if self.actor.energy < cost.move then return nil end 
 
        local done = true

        for _, dir in ipairs(dirs) do
            local heading = Direction.heading[dir]
            local x1, y1 = self.actor.x + heading.x, self.actor.y + heading.y
            local target = self.dungeon:getActor(x1, y1)
            if not self.dungeon:isBlocked(x1, y1) and not target then
                self.actor.energy = self.actor.energy - cost.move
                actions[#actions + 1] = MoveAction(self.actor, cost.move, dir)
                done = true
                break
             end
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
