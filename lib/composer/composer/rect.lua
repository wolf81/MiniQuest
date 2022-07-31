local Rect = {}
Rect.__index = Rect

function Rect.new(x, y, w, h)
    assert(w >= 0 and h >= 0, 'width and height cannot be negative')

    return setmetatable({
        x = x,
        y = y, 
        w = w,
        h = h,
    }, Rect)
end

function Rect:cutLeft(a)
    local x = self.x
    self.x = self.x + a
    self.w = math.max(self.w - a, 0)
    return Rect(x, self.y, a, self.h)
end

function Rect:cutRight(a)
    local x = self.x + self.w
    self.w = math.max(self.w - a, 0)
    return Rect(x - a , self.y, a, self.h)
end

function Rect:cutTop(a)
    local y = self.y
    self.y = self.y + a
    self.h = math.max(self.h - a, 0)
    return Rect(self.x, y, self.w, a)
end

function Rect:cutBottom(a)
    local y = self.y + self.h
    self.h = math.max(self.h - a, 0)
    return Rect(self.x, y - a, self.w, a)
end

function Rect:unpack()
    return self.x, self.y, self.w, self.h
end

function Rect:__tostring()
    return 'Rect { x = ' .. self.x .. ', y = ' .. self.y .. ', w = ' .. self.w .. ', h = ' .. self.h .. ' }'
end

return setmetatable(Rect, {
    __call = function(_, ...) return Rect.new(...) end,
})