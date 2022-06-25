--[[
    GD50
    MiniQuest

    Author: Wolfgang Schreurs
    info+miniquest@wolftrail.net
]]

CreatureMoveState = BaseState:extend()

local function getRandomDirection()
    local directions = { 'left', 'right', 'up', 'down' }
    local direction = directions[math.random(#directions)]
    local dx, dy = 0, 0

    if direction == 'left' then
        dx = -1
    elseif direction == 'right' then
        dx = 1
    elseif direction == 'up' then
        dy = -1
    elseif direction == 'down' then
        dy = 1
    end

    return direction, dx, dy
end

function CreatureMoveState:new(entity, dungeon)
    self.entity = entity
    self.dungeon = dungeon

    self.started = false
end

function CreatureMoveState:enter(params)
    self.entity:changeAnimation(self.entity.direction)
end

function CreatureMoveState:update(dt)
    if self.started then return end

    self.started = true

    local direction, dx, dy = 'left', 0, 0
    
    -- TODO: better to shuffle all directions and then try one by one,
    -- if no direction possible, move to idle state
    while true do
        direction, dx, dy = getRandomDirection()
        if not self.dungeon:isBlocked(self.entity.x + dx, self.entity.y + dy) then
            break
        end
    end

    self.entity.direction = direction
    self.entity:changeAnimation(self.entity.direction)

    Timer.tween(0.2, {
        [self.entity] = { 
            x = self.entity.x + dx,
            y = self.entity.y + dy,
        }
    })
    :finish(function()
        self.entity:changeState('idle')
    end)
end

function CreatureMoveState:draw()
    local anim = self.entity.currentAnimation

    love.graphics.draw(
        gTextures[anim.texture], 
        gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.entity.x * TILE_SIZE), 
        math.floor(self.entity.y * TILE_SIZE)
    )
end