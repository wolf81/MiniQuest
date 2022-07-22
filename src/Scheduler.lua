Scheduler = Object:extend()

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

	local hero_action, energy_cost = self.hero:getAction() 
	if not hero_action then return end

	self.busy = true

	local actions = { hero_action }
	for _, entity in ipairs(self.entities) do
		entity.energy = entity.energy + hero_action.cost
		local action = entity:getAction()
		if action then
			actions[#actions + 1] = action
		end
	end

	local n_actions = #actions
	for _, action in ipairs(actions) do
		action:perform(function()
			n_actions = n_actions - 1
			self.busy = n_actions > 0
		end)
	end
end
