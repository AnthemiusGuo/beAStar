--
-- Author: Xupinhui
-- Date: 2014-08-27 10:15:41
--
local pingjiaLayerCtrller = class("pingjiaLayerCtrller",izx.baseCtrller)

function pingjiaLayerCtrller:ctor(pageName,moduleName,initParam) 
	pingjiaLayerCtrller.super.ctor(self,pageName,moduleName,initParam);
end

function pingjiaLayerCtrller:run()
	pingjiaLayerCtrller.super.run(self);
end

 

return pingjiaLayerCtrller;