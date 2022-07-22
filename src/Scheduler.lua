Scheduler = Object:extend()

local function performActions(actions, duration, on_finish)
	if #actions == 0 then on_finish() end

	local n_actions = #actions
	for _, action in ipairs(actions) do
		action:perform(duration, function()
			n_actions = n_actions - 1
			if n_actions == 0 then on_finish() end
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

	hero_action:prepare()

	local actions = { hero_action }
	local combat_actions = {}

	for _, entity in ipairs(self.entities) do
		local action = entity:getAction(hero_action.cost)
		if action then
			action:prepare()
			
			if action:isCombatAction() then
				combat_actions[#combat_actions + 1] = action
			else
				actions[#actions + 1] = action
			end
		end
	end

	performActions(actions, 0.25, function()
		performActions(combat_actions, 0.25, function()
			self.busy = false
		end)
	end)
end
