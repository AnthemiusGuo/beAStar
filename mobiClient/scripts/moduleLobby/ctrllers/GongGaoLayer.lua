local GongGaoLayerCtrller = class("GongGaoLayerCtrller",izx.baseCtrller)

function GongGaoLayerCtrller:ctor(pageName,moduleName,initParam) 
	GongGaoLayerCtrller.super.ctor(self,pageName,moduleName,initParam);
end

function GongGaoLayerCtrller:run()
	self.view:initBaseInfo();
	GongGaoLayerCtrller.super.run(self);
end

 

return GongGaoLayerCtrller;