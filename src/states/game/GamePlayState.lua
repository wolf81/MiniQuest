--[[
    GD50
    MiniQuest

    Author: Wolfgang Schreurs
    info+miniquest@wolftrail.net
]]

GamePlayState = BaseState:extend()

function GamePlayState:enter(params)
    self.dungeon = Dungeon(params.map, params.start, params.spawns)
end

function GamePlayState:new(...)
    -- body
end

function GamePlayState:update(dt)
    self.dungeon:update(dt)
end

function GamePlayState:draw()
    self.dungeon:draw()
end