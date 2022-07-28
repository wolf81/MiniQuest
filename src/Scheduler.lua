--[[
    GD50
    MiniQuest

    Author: Wolfgang Schreurs
    info+miniquest@wolftrail.net
]]

--[[
	The Scheduler coordinates actions for all entities. The Scheduler will 
	always expect the Hero to move first. After the hero has selected an action,
	the Scheduler retrieves the energy cost for the action. Each other entity
	will receive the same energy. Each other entity then determined what action
	to take, based on available energy.
--]]

Scheduler = Object:extend()

local function performActions(actions, duration, onFinish)
	if #actions == 0 then onFinish() end

	local n_actions = #actions
	for _, action_info in ipairs(actions) do	
		action_info.action:perform(action_info.entity, duration, function()
			n_actions = n_actions - 1
			if n_actions == 0 then onFinish() end
		end)
	end
end

local function performActionsSeq(actions, duration, onFinish)
	if #actions == 0 then return onFinish() end

	local action_info = table.remove(actions, 1)
	action_info.action:perform(action_info.entity, duration, function()
		print('iter')
		performActionsSeq(actions, duration, onFinish)
	end)
end

function Scheduler:new(entities)
	self.entities = {}
	self.hero = nil
	self.busy = false

	for idx, entity in ipairs(entities) do
		if entity.strategy == HeroStrategy then		
			self.hero = ScheduledEntity.new(entity, { 'x', 'y' })
		else
			self.entities[#self.entities + 1] = ScheduledEntity.new(entity, { 'x', 'y' })
		end
	end
end

function Scheduler:update(dt)
	if self.busy then return end

	local hero_action = self.hero:getAction(0)	
	if not hero_action then return end

	self.busy = true

	local actions_p1 = { { action = hero_action, entity = self.hero } }
	local actions_p2 = { }

	for idx, entity in ripairs(self.entities) do
		if entity.remove then table.remove(self.entities, idx) end
		
		local action = entity:getAction(hero_action.cost)
		if not action then goto continue end

		if action:isCombatAction() then
			actions_p2[#actions_p2 + 1] = { action = action, entity = entity }
		else
			actions_p1[#actions_p1 + 1] = { action = action, entity = entity }
		end

		::continue::
	end

	performActions(actions_p1, 0.25, function()
		performActionsSeq(actions_p2, 0.25, function()
			self.busy = false
		end)
	end)
end

function Scheduler:getActor(x, y)
	if self.hero.x == x and self.hero.y == y then return self.hero end
	
    for _, entity in ipairs(self.entities) do
        local entity_x, entity_y = entity:nextPosition()
        if entity_x == x and entity_y == y then
            return entity
        end
    end

    return nil
end
