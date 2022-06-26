--[[
    GD50
    MiniQuest

    Author: Wolfgang Schreurs
    info+miniquest@wolftrail.net
]]

BaseStrategy = Object:extend()

function BaseStrategy:new(actor, dungeon)
    self.actor = actor
    self.dungeon = dungeon
end

function BaseStrategy:getAction()
    error('should be implemented by subclasses')
end