--[[
    GD50
    MiniQuest

    Author: Wolfgang Schreurs
    info+miniquest@wolftrail.net
]]

-- Based on: http://howtomakeanrpg.com/a/how-to-make-an-rpg-stats.html

Stats = Object:extend()

function Stats:new(def)
    self.base = {}
    self.modifiers = {}

    for id, value in pairs(def) do
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
        local value = modifier[id]
        if type(value) == 'string' then
            local dice = ndn.dice(modifier[id])
            total = total + dice.roll()
        else
            total = total + modifier[id] or 0            
        end
    end

    return total
end

function Stats:addModifier(id, modifier)
    assert(self.modifiers[id] == nil, 'already added modifier with id: ' .. id)
    self.modifiers[id] = modifier
end

function Stats:removeModifier(id)
    self.modifiers[id] = nil
end
