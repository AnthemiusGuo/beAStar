local HuoDongSceneCtrller = class("HuoDongSceneCtrller",izx.baseCtrller)

function HuoDongSceneCtrller:ctor(pageName,moduleName,initParam)
    self.data = {
    };

	self.super.ctor(self,pageName,moduleName,initParam);
end

function HuoDongSceneCtrller:onEnter()
    -- body
end
function HuoDongSceneCtrller:run()
    HuoDongSceneCtrller.super.run(self);
end

return HuoDongSceneCtrller;