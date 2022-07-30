--[[
    GD50
    MiniQuest

    Author: Wolfgang Schreurs
    info+miniquest@wolftrail.net
]]

-- Based on: http://howtomakeanrpg.com/a/how-to-make-an-rpg-stats.html

Stats = Object:extend()

function Stats:new(def, converter)
    converter = converter or function(id, value) return value end

    self.base = {}
    self.modifiers = {}

    for id, value in pairs(def) do
        value = converter(id, value)
        self.base[id] = value
    end

    if def.hd then
        local dice = ndn.dice(def.hd)
        self.base['hp'] = dice.average()
    end
end

function Stats:getBase(id)
    return self.base[id]
end

function Stats:get(id)
    local total = self.base[id] or 0
    for _, modifier in pairs(self.modifiers) do
        local value = modifier[id] or 0
        if type(value) == 'string' then
            local dice = ndn.dice(modifier[id])
            total = total + dice.roll()
        else
            total = total + value
        end
    end

    return total
end

function Stats:__tostring()
    local s = 'base = {\n'
    for k, v in pairs(self.base) do
        s = s .. '\t ' .. k .. ' = ' .. v .. ',\n' 
    end
    s = s .. '}'
    return s
end

-- TODO: in case of string, directly add ndn dice object, so user of stats class
-- can then decide to roll a random value, average value, max value, etc...
function Stats:addModifier(id, modifier)
    assert(self.modifiers[id] == nil, 'already added modifier with id: ' .. id)
    self.modifiers[id] = modifier
end

function Stats:removeModifier(id)
    self.modifiers[id] = nil
end
