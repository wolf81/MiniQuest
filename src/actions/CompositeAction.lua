CompositeAction = BaseAction:extend()

local function performActions(actions, onFinish)
    if #actions == 0 then 
        onFinish() 
    else
        local action = table.remove(actions, 1)
        action:perform(function()
            performActions(actions, onFinish)
        end)
    end
end

function CompositeAction:new(actor, actions)
    BaseAction.new(self, actor)

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

function CompositeAction:perform(onFinish)
    performActions(self.actions, onFinish)
end

