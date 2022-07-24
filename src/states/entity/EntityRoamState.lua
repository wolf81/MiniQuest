--[[
    GD50
    MiniQuest

    Author: Wolfgang Schreurs
    info+miniquest@wolftrail.net
]]

local mceil = math.ceil

EntityRoamState = BaseState:extend()

function EntityRoamState:enter()
    print('enter roam state')
    self.turns = love.math.random(5, 10)
end

function EntityRoamState:new(entity, dungeon)
    self.entity = entity
    self.dungeon = dungeon
end

function EntityRoamState:update()
    local hero_x, hero_y = self.dungeon.hero:nextPosition()
    local sight = self.entity.sight

    if (hero_x > self.entity.x - sight and 
        hero_x < self.entity.x + sight and
        hero_y > self.entity.y - sight and
        hero_y < self.entity.y + sight) then
        return self.entity.strategy:combat()
    end

    self.turns = self.turns - 1
    if self.turns == 0 then
        return self.entity.strategy:sleep()
    end
end

function EntityRoamState:getAction()
    local actions = {}

    local dirs = shuffle({ 
        Direction.N, Direction.E, Direction.S, Direction.W, 
    })    
    if oneIn(2) then
        table.insert(dirs, 1, self.entity.direction)
    end

    while true do
        local move_cost = mceil(BASE_ENERGY_COST / self.entity.move_speed)

        if self.entity.energy < move_cost then break end 

        local x, y = self.entity:nextPosition()

        local is_stuck = true

        for _, dir in ipairs(dirs) do
            local heading = Direction.heading[dir]
            local x1, y1 = x + heading.x, y + heading.y
            local target = self.dungeon:getActor(x1, y1)
            if not self.dungeon:isBlocked(x1, y1) and not target then
                self.entity.energy = self.entity.energy - move_cost
                actions[#actions + 1] = MoveAction(self.entity, dir)
                is_stuck = false
                break
            end
        end

        if is_stuck then break end
    end

    if #actions == 0 then 
        return nil
    elseif #actions == 1 then 
        return actions[1]
    else 
        return CompositeAction(self.entity, actions) 
    end
end
