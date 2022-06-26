--[[
    GD50
    MiniQuest

    Author: Wolfgang Schreurs
    info+miniquest@wolftrail.net
]]

Effect = Entity:extend()

function Effect:new(def, x, y)
    Entity.new(self, def, x, y)

    local animKeys = getKeys(self.animations)
    local animKey = animKeys[math.random(#animKeys)]

    self:changeAnimation(animKey)

    self.sound = def.sound
end

function Effect:update(dt)
    Entity.update(self, dt)

    self.remove = self.currentAnimation.timesPlayed > 0
end