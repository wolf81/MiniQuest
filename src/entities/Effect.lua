--[[
    GD50
    MiniQuest

    Author: Wolfgang Schreurs
    info+miniquest@wolftrail.net
]]

Effect = Entity:extend()

function Effect:new(def, x, y)
    Entity.new(self, def, x, y)

    local animKeys = {}
    for key, _ in pairs(self.animations) do
        animKeys[#animKeys + 1] = key
    end

    local animKey = animKeys[math.random(#animKeys)]

    self:changeAnimation(animKey)

    self.currentAnimation.looping = false
end

function Effect:update(dt)
    Entity.update(self, dt)

    if self.currentAnimation.looping then return end

    if self.remove == false then
        self.remove = self.currentAnimation.timesPlayed > 0
    end
end