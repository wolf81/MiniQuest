ScheduledEntity = {}
ScheduledEntity.__index = ScheduledEntity

ScheduledEntity.new = function(object, member_keys)
	local members = {}
	for _, key in ipairs(member_keys) do
		members[key] = object[key]
	end

	local sync = function(duration, onFinish)
		Timer.tween(duration, { [object] = members }):finish(onFinish)
	end

	local getObject = function()
		return object
	end

	ScheduledEntity.__index = getIndex
	ScheduledEntity.__newindex = setIndex

	local mt = {
		__index = function(t, k)
			if members[k] then return members[k]
			else return object[k] end
		end,
		__newindex = function(t, k, v)
			if members[k] then members[k] = v
			else object[k] = v end
		end
	}

	return setmetatable({
		sync = sync,
		getObject = getObject
	}, mt)
end
