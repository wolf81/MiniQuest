--[[
    GD50
    MiniQuest

    Author: Wolfgang Schreurs
    info+miniquest@wolftrail.net
]]

CompositeAction = BaseAction:extend()

local function getTotalCost(actions)
    local total = 0

    for _, action in ipairs(actions) do
        total = total + action.cost
    end

    return total
end

local function performActions(actions, duration, onFinish)
    if #actions == 0 then 
        onFinish() 
    else
        local action = table.remove(actions, 1)
        action:perform(duration, function()
            performActions(actions, duration, onFinish)
        end)
    end
end

function CompositeAction:new(actor, actions)
    BaseAction.new(self, getTotalCost(actions), actor)

    self.actions = actions
end

function CompositeAction:isCombatAction()
    local is_combat = false

    for _, action in ipairs(self.actions) do
        if action:is(AttackAction) then is_combat = true end
    end

    return is_combat
end

function CompositeAction:prepare()
    for _, action in ipairs(self.actions) do
        action:prepare()
    end
end

function CompositeAction:perform(duration, onFinish)
    self.actor.sync(duration, onFinish)
end

