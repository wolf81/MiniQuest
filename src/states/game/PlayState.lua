--[[
    GD50
    MiniQuest

    Author: Wolfgang Schreurs
    info+miniquest@wolftrail.net
]]

PlayState = BaseState:extend()

function PlayState:enter(params)
    local map, spawns = params.map, params.spawns
    print(map, spawns)

    self.dungeon = Dungeon(map, spawns)
end

function PlayState:new(...)
end

function PlayState:update(dt)
    self.dungeon:update(dt)
end

function PlayState:draw()
    self.dungeon:draw()
end