local Array2D = {}
Array2D.__index = Array2D

local nan = 0/0

local function isnan(v)
    return v ~= v
end

function Array2D:new(w, h, v)
    local items = {}

    for i = 0, w * h - 1 do
        items[i] = v or nan
    end

    return setmetatable({
        w = w,
        h = h,
        items = items,
    }, Array2D)
end

function Array2D:size()
    return self.w, self.h
end

function Array2D:get(x, y)
    local v = self.items[y * self.w + x]
    if isnan(v) then return nil else return v end
end

function Array2D:set(x, y, val)
    self.items[y * self.w + x] = val
end

function Array2D:count()
    return self.w * self.h
end

function Array2D:__tostring()
    local s = 'Array2D {\n'

    for y = 0, self.h - 1 do 
        s = s .. '\t'

        for x = 0, self.w - 1 do
            s = s .. self.items[y * self.w + x] .. ', '
        end

        s = s .. '\n'
    end

    s = s .. '}'

    return s
end

return setmetatable(Array2D, {
    __call = Array2D.new,
})