HeroMoveState = CreatureMoveState:extend()

function HeroMoveState:update(dt)
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

    Timer.tween(0.2, {
        [self.entity] = { 
            x = self.entity.x + dx * TILE_SIZE,
            y = self.entity.y + dy * TILE_SIZE,
        }
    })
    :finish(function()
        self.isMoving = false
    end)
end