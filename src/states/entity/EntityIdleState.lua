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
end

function EntityIdleState:update()
    local hero_x, hero_y = self.dungeon.hero:nextPosition()
    local sight = self.entity.sight

    if (hero_x > self.entity.x - sight and 
        hero_x < self.entity.x + sight and
        hero_y > self.entity.y - sight and
        hero_y < self.entity.y + sight) then
        return self.entity:combat()
    end
end

function EntityIdleState:getAction()
    local actions = {}

    while true do
        local idle_cost = math.ceil(BASE_ENERGY_COST / self.entity.move_speed)
        if self.entity.energy < idle_cost then break end

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
