--[[
    GD50
    MiniQuest

    Author: Wolfgang Schreurs
    info+miniquest@wolftrail.net
]]

local mfloor = math.floor

Actor = Entity:extend()

local function parseFlags(self, flags)
    local flags = flags or {}
    for _, v in ipairs(flags) do
        if v == 'undead' then self.undead = true end
    end
end

function Actor:new(def, dungeon, x, y)
    Entity.new(self, def, x, y)

    self.dungeon = dungeon

    self.direction = Direction.S
    self.hitpoints = def.hitpoints or 1
    self.energy = 0

    self.move_speed = def.move_speed or 1.0
    self.attack_speed = def.attack_speed or 1.0
    self.morale = def.morale or 10
    self.sight = def.sight or 5
    self.next_x = x
    self.next_y = y

    parseFlags(self, def.flags)

    self.strategy = ActorStrategy(self, dungeon)
end

function Actor:nextPosition()
    if self.next_x and self.next_y then 
        return self.next_x, self.next_y 
    end

    return self.x, self.y
end

function Actor:getAction(energy_gain)
    if self.remove then return nil end

    if self.action then return self.action end

    self.energy = self.energy + energy_gain
    self.action = self.strategy:getAction()

    return self.action
end

-- inflict some damage on this actor; if hitpoints are reduced to 0, then set 
-- remove flag to true, so the game loop can remove the entity next iteration
function Actor:inflict(damage)
    self.hitpoints = math.max(self.hitpoints - damage, 0)

    self.remove = self.hitpoints == 0
    
    self.morale = self.morale - 1
end

function Actor:draw()
    local anim = self.currentAnimation

    love.graphics.draw(
        gTextures[anim.texture], 
        gFrames[anim.texture][anim:getCurrentFrame()],
        mfloor(self.x * TILE_SIZE), 
        mfloor(self.y * TILE_SIZE)
    )
end
