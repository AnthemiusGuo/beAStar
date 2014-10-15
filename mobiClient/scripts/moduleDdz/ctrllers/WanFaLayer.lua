local WanFaLayerCtrller = class("WanFaLayerCtrller",izx.baseCtrller)

function WanFaLayerCtrller:ctor(pageName,moduleName,initParam)
    -- self.data = {}    
	self.super.ctor(self,pageName,moduleName,initParam);

end

function WanFaLayerCtrller:onEnter()
    -- body
end
function WanFaLayerCtrller:run()
	WanFaLayerCtrller.super.run(self);
end

return WanFaLayerCtrller;