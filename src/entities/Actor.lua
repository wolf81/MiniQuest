--[[
    GD50
    MiniQuest

    Author: Wolfgang Schreurs
    info+miniquest@wolftrail.net
]]

local mfloor = math.floor

Actor = Entity:extend()

local function parseFlags(self, flags)
    local flags = flags or {}
    for _, v in ipairs(flags) do
        if v == 'undead' then self.undead = true end
    end
end

function Actor:new(def, dungeon, x, y)
    Entity.new(self, def, x, y)

    self.dungeon = dungeon

    self.direction = Direction.S
    self.hitpoints = def.hitpoints or 1
    self.energy = 0

    self.move_speed = def.move_speed or 1.0
    self.attack_speed = def.attack_speed or 1.0
    self.morale = def.morale or 10
    self.sight = def.sight or 5
    self.next_x = x
    self.next_y = y

    parseFlags(self, def.flags)

    self.stateMachine = StateMachine {
        ['idle'] = function() return EntityIdleState(self, self.dungeon) end,
        ['combat'] = function() return EntityCombatState(self, self.dungeon) end,
        ['flee'] = function() return EntityFleeState(self, self.dungeon) end,
        ['roam'] = function() return EntityRoamState(self, self.dungeon) end,
        ['sleep'] = function() return EntitySleepState(self, self.dungeon) end,
    }

    self.strategy = ActorStrategy

    self:idle()
end

function Actor:nextPosition()
    if self.next_x and self.next_y then 
        return self.next_x, self.next_y 
    end

    return self.x, self.y
end

function Actor:getAction(energy_gain)
    if self.remove then return nil end

    self.energy = self.energy + energy_gain

    return self.strategy.getAction(self)
end

function Actor:sleep()
    self.stateMachine:change('sleep')
end

function Actor:idle()
    self.stateMachine:change('idle')
end

function Actor:combat()
    self.stateMachine:change('combat')
end

function Actor:flee()
    self.stateMachine:change('flee')
end

function Actor:roam()
    self.stateMachine:change('roam')
end

-- inflict some damage on this actor; if hitpoints are reduced to 0, then set 
-- remove flag to true, so the game loop can remove the entity next iteration
function Actor:inflict(damage)
    self.hitpoints = math.max(self.hitpoints - damage, 0)

    self.remove = self.hitpoints == 0
    
    self.morale = self.morale - 1
end
