--[[
    GD50
    MiniQuest

    Author: Wolfgang Schreurs
    info+miniquest@wolftrail.net
]]

Actor = Entity:extend()

local function getRandomDirection()
    local directions = { 'left', 'right', 'up', 'down' }
    return directions[math.random(#directions)]
end

function Actor:new(def, dungeon, x, y)
    Entity.new(self, def, x, y)

    self.direction = 'down'
    self.hitpoints = def.hitpoints or 1
    self.solid = true

    self.dungeon = dungeon

    self.action = nil
end

function Actor:getAction()
    if self.action ~= nil then return end

    local direction = getRandomDirection()
    local dxy = directionToVector(direction)

    if math.random(5) == 1 then
        self.action = IdleAction(self)
    elseif not self.dungeon:isBlocked(self.x + dxy.x, self.y + dxy.y) then
        self.action = MoveAction(self, direction)
    else
        local target = self.dungeon:getActor(x, y)
        if target ~= nil then
            self.action = AttackAction(self, target)
        end
    end

    return self.action
end

function Actor:inflict(damage)
    self.hitpoints = math.max(self.hitpoints - damage, 0)

    print('hp', self.hitpoints)

    self.remove = self.hitpoints == 0
end

function Actor:draw()
    local anim = self.currentAnimation

    love.graphics.draw(
        gTextures[anim.texture], 
        gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.x * TILE_SIZE), 
        math.floor(self.y * TILE_SIZE)
    )end