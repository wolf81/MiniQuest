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

    self.energy = 0

    self.move_speed = def.move_speed or 1.0
    self.attack_speed = def.attack_speed or 1.0
    self.morale = def.morale or 10
    self.strategy = strategy or ActorStrategy

    assert(def.stats ~= nil, 'stats must be defined')
    self.stats = Stats(def.stats)
    self.hp = self.stats:get('hp')

    parseFlags(self, def.flags)
end

-- we configure the state machine seperately, in order for use to be able to 
-- use the scheduled entity as self object - this way the state machine can use 
-- final states for decision making, while drawing code can rely on intermediate 
-- state
function Actor:configureStateMachine()
    assert(self.getObject() ~= nil, 'a ScheduledEntity should be used')    

    self.stateMachine = StateMachine {
        ['idle'] = function() return EntityIdleState(self, self.dungeon) end,
        ['combat'] = function() return EntityCombatState(self, self.dungeon) end,
        ['flee'] = function() return EntityFleeState(self, self.dungeon) end,
        ['roam'] = function() return EntityRoamState(self, self.dungeon) end,
        ['sleep'] = function() return EntitySleepState(self, self.dungeon) end,
        ['destroy'] = function() return EntityDestroyState(self, self.dungeon) end,
    }    

    if self.undead or self.strategy == HeroStrategy then
        self:idle()
    else
        if oneIn(2) then self:sleep() else self:roam() end
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

function Actor:destroy()
    self.stateMachine:change('destroy', self)
end

function Actor:isAlive()
    return self.hp > 0
end

function Actor:draw()
    if self.stencilFunc then
        love.graphics.stencil(self.stencilFunc, 'replace', 1)
        love.graphics.setStencilTest('equal', 0)
    end

    Entity.draw(self)

    love.graphics.setStencilTest()
end

-- inflict some damage on this actor; if hitpoints are reduced to 0, then set 
-- remove flag to true, so the game loop can remove the entity next iteration
function Actor:inflict(damage)
    if self.hp <= 0 then return end

    self.hp = self.hp - damage

    if not self.undead then
        self.morale = self.morale - 1
    end

    if self.hp <= 0 then
        self:destroy()
    end
end
