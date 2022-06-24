--[[
    GD50
    MiniQuest

    Author: Wolfgang Schreurs
    info+miniquest@wolftrail.net
]]

Entity = Object:extend()

local function createAnimations(animationDefs)
    local animations = {}

    for k, animationDef in pairs(animationDefs) do
        animations[k] = Animation {
            texture = animationDef.texture,
            frames = animationDef.frames,
            interval = animationDef.interval
        }
    end

    return animationsReturned
end

function Entity:new(def)
    self.direction = 'down'

    self.animations = createAnimations(def.animations)

    self.x = def.x or 0
    self.y = def.y or 0

    self.health = def.health or 1
end

function Entity:update(dt)
    -- body
end

function Entity:draw()
    love.graphics.setColor(0.0, 0.5, 0.5, 0.5)
    love.graphics.rectangle('fill', self.x, self.y, TILE_SIZE, TILE_SIZE)
    love.graphics.setColor(1.0, 1.0, 1.0, 1.0)
end

function Entity:collides(target)
    return not (
        self.x + self.width < target.x or 
        self.x > target.x + target.width or
        self.y + self.height < target.y or 
        self.y > target.y + target.height
    )
end
