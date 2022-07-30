--[[
    GD50
    MiniQuest

    Author: Wolfgang Schreurs
    info+miniquest@wolftrail.net
]]

local lrandom, msqrt, mceil = love.math.random, math.sqrt, math.ceil

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

function oneIn(count)
    return lrandom(count) == 1
end

-- shuffle an array
function shuffle(arr)    
    for i = #arr, 2, -1 do
        local j = lrandom(i)
        arr[i], arr[j] = arr[j], arr[i]
    end

    return arr
end

-- check if a value is not a number
function isNan(x)
    return x ~= x
end

function getDistance(x1, y1, x2, y2)
    local dx = x2 - x1
    local dy = y2 - y1
    return msqrt((dx ^ 2) + (dy ^ 2)) 
end

function getActionCosts(actor)
    local move_cost_cart = mceil(BASE_ENERGY_COST / actor.stats:get('mov_speed'))
    local att_cost = mceil(BASE_ENERGY_COST / actor.stats:get('att_speed'))

    return { 
        attack = att_cost, 
        move_cart = move_cost_cart, 
        move_ordi = mceil(move_cost_cart * ORDINAL_MOVE_FACTOR), 
        idle = move_cost_cart 
    }
end

