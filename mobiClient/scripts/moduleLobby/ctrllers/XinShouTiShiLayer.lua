local XinShouTiShiLayerCtrller = class("XinShouTiShiLayerCtrller",izx.baseCtrller)

function XinShouTiShiLayerCtrller:ctor(pageName,moduleName,initParam)
    -- self.data = {
    -- };
    self.typNum = initParam.num;
	XinShouTiShiLayerCtrller.super.ctor(self,pageName,moduleName,initParam);
	
end

function XinShouTiShiLayerCtrller:run()
	self.logic.showXinShouTiShi = nil;
	XinShouTiShiLayerCtrller.super.run(self);
end
function XinShouTiShiLayerCtrller:onEnter()
    -- body
end

return XinShouTiShiLayerCtrller;