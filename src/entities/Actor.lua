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

function Actor:new(def, dungeon, x, y, strategy)
    Entity.new(self, def, x, y)

    self.dungeon = dungeon

    self.direction = Direction.S
    self.hitpoints = def.hitpoints or 1
    self.energy = 0

    self.move_speed = def.move_speed or 1.0
    self.attack_speed = def.attack_speed or 1.0
    self.morale = def.morale or 10
    self.sight = def.sight or 5
    self.strategy = strategy or ActorStrategy

    parseFlags(self, def.flags)
end

-- we configure the state machine seperately, in order for use to be able to 
-- use the scheduled entity as self object - this way the state machine can use 
-- final states for decision making, while drawing code can rely on intermediate 
-- state
function Actor:configureStateMachine()
    assert(self.getObject() ~= nil, 'a ScheduledEntity should be used')

    if self.strategy == HeroStrategy then return end

    self.stateMachine = StateMachine {
        ['idle'] = function() return EntityIdleState(self, self.dungeon) end,
        ['combat'] = function() return EntityCombatState(self, self.dungeon) end,
        ['flee'] = function() return EntityFleeState(self, self.dungeon) end,
        ['roam'] = function() return EntityRoamState(self, self.dungeon) end,
        ['sleep'] = function() return EntitySleepState(self, self.dungeon) end,
    }    

    if self.undead or self.strategy == HeroStrategy then
        self:idle(self)
    else
        self:sleep(self)
    end
end

function Actor:nextPosition()
    return self.x, self.y
end

function Actor:getAction(energy_gain)
    if self.remove then return nil end

    self.energy = self.energy + energy_gain

    return self.strategy.getAction(self)
end

function Actor:sleep()
    self.stateMachine:change('sleep', self)
end

function Actor:idle()
    self.stateMachine:change('idle', self)
end

function Actor:combat()
    self.stateMachine:change('combat', self)
end

function Actor:flee()
    self.stateMachine:change('flee', self)
end

function Actor:roam()
    self.stateMachine:change('roam', self)
end

-- inflict some damage on this actor; if hitpoints are reduced to 0, then set 
-- remove flag to true, so the game loop can remove the entity next iteration
function Actor:inflict(damage)
    self.hitpoints = math.max(self.hitpoints - damage, 0)

    self.remove = self.hitpoints == 0
    
    self.morale = self.morale - 1
end
