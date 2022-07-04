local Set = {}
Set.__index = Set

function Set:new(list)
    local items = {}

    for _, item in ipairs(list or {}) do
        items[item] = true
    end

    return setmetatable({
        items = items,
    }, Set)
end

function Set:count()
    local count = 0

    for _, v in pairs(self.items) do
        count = count + 1
    end

    return count
end

function Set:insert(item)
    if item == nil then return end

    self.items[item] = true
end

function Set:remove(item)
    self.items[item] = nil
end

function Set:removeAll(tbl)
    if tbl then
        for _, item in pairs(tbl) do
            self.items[item] = nil
        end
    else
        self.items = {}    
    end
end

function Set:contains(item)
    if item == nil then return false end

    return self.items[item]
end

function Set:map(f)
    local tbl = {}
    for k, v in pairs(self.items) do
        tbl[#tbl + 1] = f(k)
    end
    return tbl
end

return setmetatable(Set, {
    __call = Set.new,
})