--[[
    GD50
    MiniQuest

    Author: Wolfgang Schreurs
    info+miniquest@wolftrail.net
]]

io.stdout:setvbuf('no') -- show debug output live in SublimeText console

require 'src/Dependencies'

function love.load(args)
    math.randomseed(os.time())
    love.window.setTitle('MiniQuest')
    love.graphics.setDefaultFilter('nearest', 'nearest')

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = true
    })

    love.keyboard.keysPressed = {}

    dungeon = Dungeon('dat/map.lua')
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.update(dt)
    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()

    dungeon:draw()

    push:finish()
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end