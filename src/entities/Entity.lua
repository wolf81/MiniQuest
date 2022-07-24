--[[
    GD50
    MiniQuest

    Author: Wolfgang Schreurs
    info+miniquest@wolftrail.net
]]

local mfloor = math.floor

Entity = Object:extend()

local function createAnimations(animationDefs)
    local animations = {}

    for k, animationDef in pairs(animationDefs) do
        animations[k] = Animation {
            texture = animationDef.texture,
            frames = animationDef.frames,
            interval = animationDef.interval,
            looping = animationDef.looping,
        }
    end

    return animations
end

function Entity:new(def, x, y)    
    self.animations = createAnimations(def.animations or {})
    self.currentAnimation = self.animations['down']

    self.x = x or 0
    self.y = y or 0

    self.remove = false
end

function Entity:update(dt)
    if self.currentAnimation then
        self.currentAnimation:update(dt)
    else
        error('no animation defined')
    end    
end

function Entity:draw()
    local anim = self.currentAnimation

    love.graphics.draw(
        gTextures[anim.texture], 
        gFrames[anim.texture][anim:getCurrentFrame()],
        mfloor(self.x * TILE_SIZE), 
        mfloor(self.y * TILE_SIZE)
    )
end

function Entity:collides(target)
    return not (
        self.x + self.width < target.x or 
        self.x > target.x + target.width or
        self.y + self.height < target.y or 
        self.y > target.y + target.height
    )
end

function Entity:changeAnimation(name)
    self.currentAnimation = self.animations[name]
end
