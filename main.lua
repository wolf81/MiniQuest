--[[
    GD50
    MiniQuest

    Author: Wolfgang Schreurs
    info+miniquest@wolftrail.net
]]

io.stdout:setvbuf('no') -- show debug output live in SublimeText console

require 'src.Dependencies'

local function showFPS()
    love.graphics.setFont(gFonts['tiny-dungeon-shadow'])
    love.graphics.setColor(1.0, 1.0, 1.0, 1.0)
    love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), 10, 10)
end

local prefab_map = [[
#####################
# %    %#%      %   #
#       #%#         #
#     % #####       #
#       % % #       #
#  @    ### # %     #
#      %#%# #       #
#%      #%#%        #
#####################
]]

--[[
########################################            
#           +    #    #                ####         
#  %     %  #  % # %  #       %           ###       
#           #    #    ###                   ###     
###+#########    #            %                ##   
#           #    #    ###              ##   %   ##  
#  %     %  # %  #  % #       %        # >  %    #  
#           #    #    ###              ##   %   ##  
########+####    #            %                ##   
#           #    #    ###                   ###     
+@          #  % # %  #       %           ###       
#           #    +    #                ####         
########################################            
]]

local spawn_table = amazing.RandomTable({
   ['spider']      = 60,
    ['bat']         = 60,
    ['skeleton']    = 25,
    ['zombie']      = 15,
    ['skel_mage']   = 10,
    ['vampire']     = 5,
})

function love.load(args)
    love.math.setRandomSeed(os.time())

    local builder = amazing.builder.prefab({ 
        ['spawn_table'] = spawn_table,
        ['map'] = prefab_map,
    })
    local map, start, spawns = builder.build()

    love.window.setTitle('MiniQuest')
    love.graphics.setDefaultFilter('nearest', 'nearest')

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = true,
        highdpi = false,
    })

    love.keyboard.keysPressed = {}

    gStateMachine:change('play', { map = map, start = start, spawns = spawns })
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

function love.keypressed(key, code)
    love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key, code)
    return love.keyboard.keysPressed[key]
end
