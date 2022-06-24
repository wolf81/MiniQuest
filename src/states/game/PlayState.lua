--[[
    GD50
    MiniQuest

    Author: Wolfgang Schreurs
    info+miniquest@wolftrail.net
]]

PlayState = BaseState:extend()

function PlayState:new()
    self.dungeon = Dungeon('dat/map.lua')    
end

function PlayState:update(dt)
    self.dungeon:update(dt)
end

function PlayState:draw()
    self.dungeon:draw()
end