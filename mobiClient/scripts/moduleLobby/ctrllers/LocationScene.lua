local LocationSceneCtrller = class("LocationSceneCtrller",izx.baseCtrller)

function LocationSceneCtrller:ctor(pageName,moduleName,initParam)
    self.data = {
        userName = '',
        userMoney = 0,
        ply_vip_ = {},
        locationInfo = initParam.locationInfo
        --gBaseLogic.lobbyLogic.userHasLogined
    };

    

	LocationSceneCtrller.super.ctor(self,pageName,moduleName,initParam);
end

function LocationSceneCtrller:reSetData()
    if self.logic.userData.ply_lobby_data_ then 
        self.data.userName = self.logic.userData.ply_lobby_data_.nickname_;
        self.data.userMoney = string.format("%d",self.logic.userData.ply_lobby_data_.money_);
        self.data.ply_vip_ = self.logic.userData.ply_vip_;
    else 
        self.data.userName =  "未登录";
        self.data.userMoney = "0";
        self.data.ply_vip_.level_ = 0
        self.data.ply_vip_.status_ = 0 
        gBaseLogic.lobbyLogic.face = ""
        --images/DaTing/lobby_pic_touxiang75.png
        gBaseLogic.lobbyLogic.userHasLogined = false
    end
end

function LocationSceneCtrller:run()
    LocationSceneCtrller.super.run(self);
end

return LocationSceneCtrller;
