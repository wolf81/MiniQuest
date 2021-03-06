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
    self.alpha = 1.0
    self.color = { 1.0, 1.0, 1.0, 0.0 }

    self.effects = {}

    self.remove = false
end

function Entity:addEffect(name, sub)
    local def_name = sub and name .. '_' .. sub or name

    assert(EFFECT_DEFS[def_name] ~= nil, 'effect not defined: ' .. name)

    local effect = Effect(EFFECT_DEFS[def_name], 0, 0)
    self.effects[name] = effect
end

function Entity:removeEffect(name)
    self.effects[name] = nil
end

function Entity:update(dt)
    if self.currentAnimation then
        self.currentAnimation:update(dt)
    else
        error('no animation defined')
    end 

    for _, effect in pairs(self.effects) do
        effect:update(dt)
    end
end

function Entity:draw()
    local anim = self.currentAnimation

    love.graphics.push()
    love.graphics.translate(mfloor(self.x * TILE_SIZE), mfloor(self.y * TILE_SIZE))

    local shader = gShaders['color_mix']
    shader:send('blendColor', self.color)
    shader:send('alpha', self.alpha)
    love.graphics.setShader(shader)

    --love.graphics.setColor(self.color[1], self.color[2], self.color[3], self.alpha)
    love.graphics.draw(
        gTextures[anim.texture], 
        gFrames[anim.texture][anim:getCurrentFrame()]
    )

    love.graphics.setShader()

    --love.graphics.setColor(1.0, 1.0, 1.0, 1.0)
    for _, effect in pairs(self.effects) do effect:draw() end

    love.graphics.pop()
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
