local InformationLayerCtrller = class("InformationLayerCtrller",izx.baseCtrller)

function InformationLayerCtrller:ctor(pageName,moduleName,initParam)
    
	self.super.ctor(self,pageName,moduleName,initParam);
end

function InformationLayerCtrller:onEnter()
    -- body
end

return InformationLayerCtrller;