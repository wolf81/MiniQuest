--[[
    GD50
    MiniQuest

    Author: Wolfgang Schreurs
    info+miniquest@wolftrail.net
]]

local mceil = math.ceil

EntityRoamState = BaseState:extend()

function EntityRoamState:enter(actor)
    actor:addEffect('state', 'roam')

    self.turns = love.math.random(5, 10)
end

function EntityRoamState:new(dungeon)
    self.dungeon = dungeon
end

function EntityRoamState:update(actor)
    local hero_x, hero_y = self.dungeon.scheduler.hero:nextPosition()
    local sight = actor.sight

    if (hero_x > actor.x - sight and 
        hero_x < actor.x + sight and
        hero_y > actor.y - sight and
        hero_y < actor.y + sight) then
        return actor:combat()
    end

    self.turns = self.turns - 1
    if self.turns == 0 then
        return actor:sleep()
    end
end

function EntityRoamState:getAction(actor)
     local actions = {}
 
     local dirs = shuffle({ 
         Direction.N, Direction.E, Direction.S, Direction.W, 
     })    
     if oneIn(2) then
        table.insert(dirs, 1, actor.direction)
     end
 
    while true do
        local move_cost = mceil(BASE_ENERGY_COST / actor.move_speed)
 
        if actor.energy < move_cost then return nil end 
 
        local done = true

        for _, dir in ipairs(dirs) do
            local heading = Direction.heading[dir]
            local x1, y1 = actor.x + heading.x, actor.y + heading.y
            local target = self.dungeon:getActor(x1, y1)
            if not self.dungeon:isBlocked(x1, y1) and not target then
                actor.energy = actor.energy - move_cost
                actions[#actions + 1] = MoveAction(actor, dir)
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
        print('roam ' .. #actions .. ' tiles')
        return CompositeAction(actor, actions) 
    end
 end
