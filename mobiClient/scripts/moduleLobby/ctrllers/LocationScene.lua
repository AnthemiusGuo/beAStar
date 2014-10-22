local LocationSceneCtrller = class("LocationSceneCtrller",izx.baseCtrller)

function LocationSceneCtrller:ctor(pageName,moduleName,initParam)
	LocationSceneCtrller.super.ctor(self,pageName,moduleName,initParam);
end

function LocationSceneCtrller:reSetData()
    self.logic:resetUserInfo();
    self.logic:resetLocation();
    self.view:resetPage();
end

function LocationSceneCtrller:run()
    LocationSceneCtrller.super.run(self);
    if (self.logic.userHasLogined==false) then
        self.logic:reqPluginLogin();
    end
end

return LocationSceneCtrller;
