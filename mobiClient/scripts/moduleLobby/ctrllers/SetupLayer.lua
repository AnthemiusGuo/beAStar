local SetupLayerCtrller = class("SetupLayerCtrller",izx.baseCtrller)

function SetupLayerCtrller:ctor(pageName,moduleName,initParam)
    self.data = {
    };

	SetupLayerCtrller.super.ctor(self,pageName,moduleName,initParam);
end

function SetupLayerCtrller:onEnter()
    -- body
end

return SetupLayerCtrller;