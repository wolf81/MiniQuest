CompositeAction = BaseAction:extend()

function CompositeAction:new()
    BaseAction.new(self, actor)
end

function CompositeAction:prepare()
end

function CompositeAction:perform(onFinish)
    onFinish()
end

