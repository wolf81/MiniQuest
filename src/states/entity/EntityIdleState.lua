--[[
    GD50
    MiniQuest

    Author: Wolfgang Schreurs
    info+miniquest@wolftrail.net
]]

EntityIdleState = BaseState:extend()

function EntityIdleState:new(entity)
    self.entity = entity
end

function EntityIdleState:enter(params)
    self.entity:changeAnimation(self.entity.direction)
end

function EntityIdleState:update(dt)
    if (love.keyboard.isDown('left') or 
        love.keyboard.isDown('right') or
        love.keyboard.isDown('up') or 
        love.keyboard.isDown('down')) then
        self.entity:changeState('move')
    end
end

function EntityIdleState:draw()
    local anim = self.entity.currentAnimation

    love.graphics.draw(
        gTextures[anim.texture], 
        gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.entity.x), 
        math.floor(self.entity.y)
    )
end
