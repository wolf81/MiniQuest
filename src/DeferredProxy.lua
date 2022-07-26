--[[
    GD50
    MiniQuest

    Author: Wolfgang Schreurs
    info+miniquest@wolftrail.net
]]

DeferredProxy = {}
DeferredProxy.__index = DeferredProxy

function DeferredProxy.new(object)
    local members = {}

    DeferredProxy.__index = function(t, k)
        if not members[k] then members[k] = object[k] end
        return members[k]
    end

    DeferredProxy.__newindex = function(t, k, v)
        if not members[k] then members[k] = object[k] end
        members[k] = v
    end

    -- update the original object with values stored in the proxy object
    local update = function()
        for k, v in pairs(members) do
            object[k] = v
        end
    end

    return setmetatable({
        update = update,
    }, DeferredProxy)
end

setmetatable(DeferredProxy, {
    __call = function(_, ...) return DeferredProxy.new(...) end,
})
