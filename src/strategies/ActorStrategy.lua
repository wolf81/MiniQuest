--[[
    GD50
    MiniQuest

    Author: Wolfgang Schreurs
    info+miniquest@wolftrail.net
]]

ActorStrategy = BaseStrategy:extend()

local BASE_ENERGY_COST = 100

-- calculate of this entity is standing next to a hero
local function isAdjacent(actor, target)
    local actor_x, actor_y = actor:nextPosition()
    local target_x, target_y = target:nextPosition()   
    local dx, dy = math.abs(actor_x - target_x), math.abs(actor_y - target_y)
    return dx <= 1 and dy <= 1
end

local function canMove(actor, dungeon)
    local dirs = shuffle({ 
        Direction.W, Direction.E, Direction.N, Direction.S, 
        Direction.NW, Direction.NE, Direction.SE, Direction.SW 
    })

    local cart_cost = math.ceil(BASE_ENERGY_COST / actor.move_speed)
    local ordi_cost = math.ceil(cart_cost * ORDINAL_MOVE_FACTOR)

    for _, dir in ipairs(dirs) do
        local heading = Direction.heading[dir]
        local actor_x, actor_y = actor:nextPosition()
        local actor_x, actor_y = actor_x + heading.x, actor_y + heading.y
        local target = dungeon:getActor(actor_x, actor_y)
        local cost = Direction.isOrdinal(dir) and ordi_cost or cart_cost

        if not dungeon:isBlocked(actor_x, actor_y) and not target then
            if actor.energy >= cost then
                return dir, cost
            end
        end        
    end

    return nil
end

function ActorStrategy:getAction()
    self.stateMachine.current:update()

    return self.stateMachine.current:getAction()
end
