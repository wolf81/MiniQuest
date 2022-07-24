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
	for _, action in ipairs(actions) do
		action:perform(duration, function()
			n_actions = n_actions - 1
			if n_actions == 0 then onFinish() end
		end)
	end
end

function Scheduler:new(entities)
	self.entities = {}
	self.hero = nil
	self.busy = false

	for _, entity in ipairs(entities) do
		if entity.strategy:is(HeroStrategy) then		
			self.hero = entity
		else
			self.entities[#self.entities + 1] = entity  
		end
	end
end

function Scheduler:update(dt)
	if self.busy then return end

	local hero_action = self.hero:getAction(0)	
	if not hero_action then return end

	self.busy = true

	local move_actions = { hero_action }
	local combat_actions = {}

	for _, entity in ipairs(self.entities) do
		local action = entity:getAction(hero_action.cost)
		if action then
			if action:isCombatAction() then
				combat_actions[#combat_actions + 1] = action
			else
				move_actions[#move_actions + 1] = action
			end
		end
	end

	performActions(move_actions, 0.25, function()
		performActions(combat_actions, 0.25, function()
			self.busy = false
		end)
	end)
end
