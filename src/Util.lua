--[[
    GD50
    MiniQuest

    Author: Wolfgang Schreurs
    info+miniquest@wolftrail.net
]]

function GenerateQuads(atlas, tilewidth, tileheight)
    local sheetWidth = math.floor(atlas:getWidth() / tilewidth)
    local sheetHeight = math.floor(atlas:getHeight() / tileheight)

    local spritesheet = {}

    for y = 0, sheetHeight - 1 do
        for x = 0, sheetWidth - 1 do
            spritesheet[#spritesheet + 1] = love.graphics.newQuad(
                    x * tilewidth, 
                    y * tileheight, 
                    tilewidth,
                    tileheight, 
                    atlas:getDimensions()
            )
        end
    end

    return spritesheet
end

function clamp(value, min, max)
    return math.max(math.min(value, max), min)
end