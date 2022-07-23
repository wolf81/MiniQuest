--[[ DIRECTION ]]--

-- constants
Direction = {
    N  = 0x1,
    S  = 0x2,
    E  = 0x4,
    W  = 0x8,
    NW = 0x10,
    NE = 0x20,
    SW = 0x40,
    SE = 0x80,    
}

-- get direction heading as a vector
Direction.heading = {
    [Direction.N]  = { x =  0, y = -1 },
    [Direction.S]  = { x =  0, y =  1 },
    [Direction.E]  = { x =  1, y =  0 },
    [Direction.W]  = { x = -1, y =  0 },
    [Direction.NW] = { x = -1, y = -1 },
    [Direction.NE] = { x =  1, y = -1 },
    [Direction.SW] = { x = -1, y =  1 },
    [Direction.SE] = { x =  1, y =  1 },
}

return Direction