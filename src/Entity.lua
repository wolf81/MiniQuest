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

    return animations
end

function Entity:new(def)
    self.direction = 'down'

    self.animations = createAnimations(def.animations)

    self.x = def.x or 0
    self.y = def.y or 0

    self.health = def.health or 1

    self.stateMachine = def.stateMachine
end

function Entity:update(dt)
    self.stateMachine:update(dt)

    if self.currentAnimation then
        self.currentAnimation:update(dt)
    else
        error('no animation defined')
    end    
end

function Entity:draw()
    self.stateMachine:draw()
end

function Entity:collides(target)
    return not (
        self.x + self.width < target.x or 
        self.x > target.x + target.width or
        self.y + self.height < target.y or 
        self.y > target.y + target.height
    )
end

function Entity:changeState(state)
    self.stateMachine:change(state)
end

function Entity:changeAnimation(name)
    self.currentAnimation = self.animations[name]
end
