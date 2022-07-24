--[[
    GD50
    MiniQuest

    Author: Wolfgang Schreurs
    info+miniquest@wolftrail.net
]]

EntityIdleState = BaseState:extend()

function EntityIdleState:enter()
    print('enter idle state')
end

function EntityIdleState:new(entity, dungeon)
    self.entity = entity
    self.dungeon = dungeon
    self.action = nil
end

function EntityIdleState:update()
    local hero = self.dungeon.hero

    local sight = 5

    if (hero.x > self.entity.x - sight and 
        hero.x < self.entity.x + sight and
        hero.y > self.entity.y - sight and
        hero.y < self.entity.y + sight) then
        self.entity.strategy:combat()
    end
end

function EntityIdleState:getAction()
    local idle_cost = math.ceil(BASE_ENERGY_COST / self.entity.move_speed)
    local actions = {}

    while self.entity.energy >= idle_cost do
        self.entity.energy = self.entity.energy - idle_cost
        actions[#actions + 1] = IdleAction(self.entity)
    end

    if #actions == 0 then 
        return nil
    elseif #actions == 1 then 
        return actions[1]
    else 
        return CompositeAction(self.entity, actions) 
    end
end
