--[[
    GD50
    MiniQuest

    Author: Wolfgang Schreurs
    info+miniquest@wolftrail.net
]]

EntityMoveState = BaseState:extend()

function EntityMoveState:new(entity, dungeon)
    self.entity = entity
    self.dungeon = dungeon

    self.isMoving = false
end

function EntityMoveState:enter(params)
    self.entity:changeAnimation(self.entity.direction)
end

function EntityMoveState:update(dt)
    if self.isMoving then return end

    self.isMoving = true

    local dx = 0
    local dy = 0

    if love.keyboard.isDown('left') then
        self.entity.direction = 'left'
        dx = -1
    elseif love.keyboard.isDown('right') then
        self.entity.direction = 'right'
        dx = 1
    elseif love.keyboard.isDown('up') then
        self.entity.direction = 'up'
        dy = -1
    elseif love.keyboard.isDown('down') then
        self.entity.direction = 'down'
        dy = 1
    end

    self.entity:changeAnimation(self.entity.direction)

    if dx == 0 and dy == 0 then
        self.entity:changeState('idle')
        return        
    end

    Timer.tween(0.1, {
        [self.entity] = { 
            x = self.entity.x + dx * TILE_SIZE,
            y = self.entity.y + dy * TILE_SIZE,
        }
    })
    :finish(function()
        self.isMoving = false
    end)
end

function EntityMoveState:draw()
    local anim = self.entity.currentAnimation

    love.graphics.draw(
        gTextures[anim.texture], 
        gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.entity.x), 
        math.floor(self.entity.y)
    )
end