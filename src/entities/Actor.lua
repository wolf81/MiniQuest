Actor = Entity:extend()

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

function Actor:new(def, dungeon, x, y)
    Entity.new(self, def, x, y)

    self.direction = 'down'
    self.health = def.health or 1
    self.solid = true

    self.dungeon = dungeon

    self.action = nil
end

function Actor:getAction()
    if self.action ~= nil then return end

    local direction, dx, dy = getRandomDirection()

    if not self.dungeon:isBlocked(self.x + dx, self.y + dy) then
        self.action = MoveAction(self, direction)
        return self.action
    end
end

function Actor:draw()
    local anim = self.currentAnimation

    love.graphics.draw(
        gTextures[anim.texture], 
        gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.x * TILE_SIZE), 
        math.floor(self.y * TILE_SIZE)
    )end