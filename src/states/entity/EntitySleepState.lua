--[[
    GD50
    MiniQuest

    Author: Wolfgang Schreurs
    info+miniquest@wolftrail.net
]]

EntitySleepState = BaseState:extend()

function EntitySleepState:enter()
    print('enter sleep state')
    self.turns = love.math.random(5, 10)
end

function EntitySleepState:new(entity, dungeon)
    self.entity = entity
    self.dungeon = dungeon
end

function EntitySleepState:update()
    local hero_x, hero_y = self.dungeon.hero:nextPosition()
    local sight = 2

    if (hero_x > self.entity.x - sight and 
        hero_x < self.entity.x + sight and
        hero_y > self.entity.y - sight and
        hero_y < self.entity.y + sight) then
        return self.entity.strategy:combat()
    end

    self.turns = self.turns - 1
    if self.turns == 0 then
        self.entity.strategy:roam()
    end
end

function EntitySleepState:getAction()
    local actions = {}

    while true do
        local idle_cost = math.ceil(BASE_ENERGY_COST / self.entity.move_speed)
        
        if self.entity.energy < idle_cost then break end

        self.entity.energy = self.entity.energy - idle_cost
        actions[#actions + 1] = IdleAction(self.entity, true)
    end

    if #actions == 0 then 
        return nil
    elseif #actions == 1 then 
        return actions[1]
    else 
        return CompositeAction(self.entity, actions) 
    end
end
