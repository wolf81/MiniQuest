--[[
    GD50
    MiniQuest

    Author: Wolfgang Schreurs
    info+miniquest@wolftrail.net
]]

local mceil = math.ceil

EntityBaseState = BaseState:extend()

function EntityBaseState:new(actor, dungeon)
    self.actor = actor
    self.dungeon = dungeon
end

function EntityBaseState:isAdjacent(target)
    return getDistance(self.actor.x, self.actor.y, target.x, target.y) <= ORDINAL_MOVE_FACTOR
end

function EntityBaseState:isTargetInSight(target, sight)
    local sight = sight or self.actor.stats:get('sight')
    return getDistance(self.actor.x, self.actor.y, target.x, target.y) <= sight 
end

function EntityBaseState:getAction()
    error('should be implemented by subclasses')
end
