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
        hero.x < self.entity.x + sight + 1 and
        hero.y > self.entity.y - sight and
        hero.y < self.entity.y + sight + 1) then
        self.entity.strategy:engage()
    end
end

function EntityIdleState:draw()
    -- body
end

function EntityIdleState:getAction()
    local idle_cost = math.ceil(BASE_ENERGY_COST / self.entity.move_speed)
    if self.entity.energy >= idle_cost then
        self.entity.energy = self.entity.energy - idle_cost
        return IdleAction(self.entity)
    end

    return nil
end
