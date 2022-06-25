--[[
    GD50
    MiniQuest

    Author: Wolfgang Schreurs
    info+miniquest@wolftrail.net
]]

ActorIdleState = BaseState:extend()

function ActorIdleState:new(entity)
    self.entity = entity
end

function ActorIdleState:enter(params)
    self.entity:changeAnimation(self.entity.direction)
end

function ActorIdleState:update(dt)
    self.entity:changeState('move')
end

function ActorIdleState:draw()
    local anim = self.entity.currentAnimation

    love.graphics.draw(
        gTextures[anim.texture], 
        gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.entity.x * TILE_SIZE), 
        math.floor(self.entity.y * TILE_SIZE)
    )
end
