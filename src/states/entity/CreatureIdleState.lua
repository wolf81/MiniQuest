--[[
    GD50
    MiniQuest

    Author: Wolfgang Schreurs
    info+miniquest@wolftrail.net
]]

CreatureIdleState = BaseState:extend()

function CreatureIdleState:new(entity)
    self.entity = entity
end

function CreatureIdleState:enter(params)
    self.entity:changeAnimation(self.entity.direction)
end

function CreatureIdleState:update(dt)
    self.entity:changeState('move')
end

function CreatureIdleState:draw()
    local anim = self.entity.currentAnimation

    love.graphics.draw(
        gTextures[anim.texture], 
        gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.entity.x * TILE_SIZE), 
        math.floor(self.entity.y * TILE_SIZE)
    )
end
