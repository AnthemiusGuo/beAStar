local LocationSceneCtrller = class("LocationSceneCtrller",izx.baseCtrller)

function LocationSceneCtrller:ctor(pageName,moduleName,initParam)
    self.data = {
        userName = '',
        userMoney = 0,
        ply_vip_ = {},
        locationInfo = initParam.locationInfo,

        userInfo = {
            avatarId = 1,
            uname = "张三",
            vip_level = 0,
            uid = "5442305d511deeb1010041a7",
            level = 0,
            exp = 0,
            exp_len = 0,
            money = 0,
            voucher = 1000,
            credits = 2000,
            money_show = 0,
            avatar_url = "./images/avatar/1.png",
            avatar_id = 1,
            show_uid = "XGSA3",
            is_anonym = 1,
            energy = 100,
            mood = 100
        }
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
