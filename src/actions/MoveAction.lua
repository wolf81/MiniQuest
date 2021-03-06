--[[
    GD50
    MiniQuest

    Author: Wolfgang Schreurs
    info+miniquest@wolftrail.net
]]

MoveAction = BaseAction:extend()

-- This is duplicated in AttackAction
local directionString = {
    [Direction.N]  = 'up',
    [Direction.NW] = 'up',
    [Direction.W]  = 'left',
    [Direction.SW] = 'left',
    [Direction.S]  = 'down',
    [Direction.SE] = 'down',
    [Direction.E]  = 'right',
    [Direction.NE] = 'right',
}

local stencilInfo = {
    [Direction.N] = function(dungeon, x, y) return false end,
    [Direction.W] = function(dungeon, x, y) return false end,
    [Direction.S] = function(dungeon, x, y) return false end,
    [Direction.E] = function(dungeon, x, y) return false end,
    [Direction.NW] = function(dungeon, x, y) return dungeon:getTileType(x - 1, y) == amazing.Tile.WALL, x - 1, y end,
    [Direction.NE] = function(dungeon, x, y) return dungeon:getTileType(x + 1, y) == amazing.Tile.WALL, x + 1, y end,
    [Direction.SW] = function(dungeon, x, y) return dungeon:getTileType(x, y + 1) == amazing.Tile.WALL, x, y + 1 end,
    [Direction.SE] = function(dungeon, x, y) return dungeon:getTileType(x, y + 1) == amazing.Tile.WALL, x, y + 1 end,
}

function MoveAction:new(actor, cost, direction)
    BaseAction.new(self, actor, cost)
    
    self.direction = direction 
    self.last_x = self.actor.x
    self.last_y = self.actor.y

    local heading = Direction.heading[direction]
    self.actor.x = self.actor.x + heading.x
    self.actor.y = self.actor.y + heading.y
end

function MoveAction:perform(duration, onFinish)
    self.actor.direction = self.direction
    self.actor:changeAnimation(directionString[self.actor.direction])

    local draw_stencil, stencil_x, stencil_y = stencilInfo[self.direction](self.actor.dungeon, self.last_x, self.last_y)
    if draw_stencil then
        self.actor.stencilFunc = function()
            love.graphics.rectangle('fill', 
                stencil_x * TILE_SIZE, 
                stencil_y * TILE_SIZE, 
                TILE_SIZE, 
                TILE_SIZE
            )
        end         
    end

    self.actor.sync(duration, function()
        self.actor.stencilFunc = nil
        onFinish()
    end)
end
