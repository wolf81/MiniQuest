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

function directionToVector(direction)
    if direction == 'left' then return { x = -1, y = 0 }
    elseif direction == 'right' then return { x = 1, y = 0 }
    elseif direction == 'up' then return { x = 0, y = -1 }
    elseif direction == 'down' then return { x = 0, y = 1 }
    else error('invalid direction:', direction) end
end

function getKeys(tbl)
    local keys = {}
    for key, _ in pairs(tbl) do
        keys[#keys + 1] = key
    end
    return keys
end

local ripairs_iter = function(t, i)
  i = i - 1
  local v = t[i]
  if v ~= nil then
    return i, v
  end
end

-- reverse ipairs, based on code from the lume library
function ripairs(t)
  return ripairs_iter, t, (#t + 1)
end