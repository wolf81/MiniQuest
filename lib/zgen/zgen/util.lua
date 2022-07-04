function getKeys(tbl)
    local keys = {}

    for key, _ in pairs(tbl) do
        keys[#keys + 1] = key
    end

    return keys
end

function getRandom(list)
    return list[math.random(#list)]
end

function oneIn(v)
    return math.random(1, v) == 1
end

function contains(tbl, value)
    for _, v in pairs(tbl) do
        if v == value then return true end
    end

    return false
end

function skip(list, count)
    local t = {}

    for i = count, #list do
        t[#t + 1] = list[i + 1]
    end

    return t
end

function removeWhere(list, f)
    for i = #list, 1, -1 do
        if f(list[i]) then
            table.remove(list, i)
        end
    end
end