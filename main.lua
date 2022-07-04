--[[
    GD50
    MiniQuest

    Author: Wolfgang Schreurs
    info+miniquest@wolftrail.net
]]

io.stdout:setvbuf('no') -- show debug output live in SublimeText console

require 'src.Dependencies'

local zgen = require 'lib.zgen'

for i = 1, 10 do
    local dungeon = zgen.Dungeon(15, 15)
    print(dungeon)
end

local function showFPS()
    love.graphics.setFont(gFonts['tiny-dungeon-shadow'])
    love.graphics.setColor(1.0, 1.0, 1.0, 1.0)
    love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), 10, 10)
end

function love.load(args)
    math.randomseed(os.time())

    love.window.setTitle('MiniQuest')
    love.graphics.setDefaultFilter('nearest', 'nearest')

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = true,
        highdpi = false,
    })

    love.keyboard.keysPressed = {}

    gStateMachine:change('play')
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.update(dt)
    Timer.update(dt)

    gStateMachine:update(dt)

    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()

    gStateMachine:draw()

    showFPS()

    push:finish()
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end
