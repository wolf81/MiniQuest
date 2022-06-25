IdleAction = BaseAction:extend()

function IdleAction:new(actor)
    BaseAction.new(self, actor)
end

function IdleAction:perform(onFinish)
    onFinish = onFinish or function() end

    self.actor.action = nil

    onFinish()
end