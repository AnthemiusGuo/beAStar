local LoginSceneCtrller = class("LoginSceneCtrller",izx.baseCtrller)

function LoginSceneCtrller:ctor(pageName,moduleName,initParam)
    self.data = {
        versionNum = SHOW_VERSION,
        helpDesk = '...',
        user = {
        	userName = '未登录',--self.logic.userData.ply_status_.ply_nickname_,
        	avatar = '',
        	userMoney = 0,--self.logic.userData.ply_status_.money_,
            vipLevel = 0,
            vipStatus = 0,
    	}
    };
	LoginSceneCtrller.super.ctor(self,pageName,moduleName,initParam);

    local runEnv = "";
    if (PLUGIN_ENV==ENV_TEST) then

        runEnv = "测试环境"
    elseif (PLUGIN_ENV== ENV_MIRROR ) then
        runEnv = "镜像环境"
    end

    if (PLUGIN_ENV ~=ENV_OFFICIAL ) then
        self.data.versionNum = string.format("%s on %s ;DV:%s;PV:%d;FWV:%d;",SHOW_VERSION,runEnv, VERSION,CASINO_VERSION_DEFAULT,gBaseLogic.MBPluginManager.frameworkVersion);

    end 
    gBaseLogic.lobbyLogic:addLogicEvent("MSG_userName_rst_send",handler(self, self.onUserNameUpdate),self)
end

function LoginSceneCtrller:onUserNameUpdate(event)
    --izxMessageBox(event.message.sessionInfo.nickname,event.message.msg)
    print("LoginSceneCtrller:onUserNameUpdate")
    --dump(event)
    var_dump(self.logic.userData.ply_lobby_data_)
    self.logic.haschangename = true -- is it need?
    if (self.logic.userData.ply_lobby_data_) then
        self.logic.userData.ply_lobby_data_.nickname_ = event.message.sessionInfo.nickname
    end
    self:resetData()
end

function LoginSceneCtrller:resetData()
    if (self.logic.userData.ply_lobby_data_) then
        self.data.user.userName =  self.logic.userData.ply_lobby_data_.nickname_;
        self.data.user.userMoney = tostring(self.logic.userData.ply_lobby_data_.money_); --string.format("%d",self.logic.userData.ply_lobby_data_.money_);
        self.data.user.avatar = gBaseLogic.lobbyLogic.face
        self.data.user.vipLevel = self.logic.userData.ply_vip_.level_
        self.data.user.vipStatus = self.logic.userData.ply_vip_.status_
        self.view:setEnabled();
    else
        self.data.user.userName =  "未登录";
        self.data.user.userMoney = "0";
        self.data.user.avatar =''
        self.data.user.vipLevel = 0
        self.data.user.vipStatus = 0
        self.view:setDisabled();
    end
    self.view:initUserInfo();
end

function LoginSceneCtrller:run()
    -- gBaseLogic.debugCounter = gBaseLogic.debugCounter+1;
    -- echoError("LoginSceneCtrller:run:"..gBaseLogic.debugCounter)
    --已经有持久化数据直接显示
    if (updaterSuccOrFail == false) then
        self.logic:onNoNet(3,"检查更新下载失败");
        return;
    end
    self:resetData();

    if (self.initParam.isFirstRun) then
        local toCheckLogin = 1;
        self.logic:requestHTTGongGao(toCheckLogin); --cbackchecklogin
        -- gBaseLogic:checkLogin(); 
    end
    self.logic:requestHTTPHelpDesk();    
    self.logic:addLogicEvent("MSG_HTTP_HelpDesk",handler(self, self.onMsgHelpDesk),self)
    self.logic:addLogicEvent("MSG_SOCK_pt_lc_get_continuous_game_award_ack",handler(self, self.onMsgDengLu),self);
    self.logic:addLogicEvent("MSG_Socket_UserData",handler(self, self.onMsgUser),self)
    self.logic:addLogicEvent("MSG_Socket_pt_lc_send_user_data_change_not",handler(self, self.pt_lc_send_user_data_change_not_rec),self)
    -- self.logic:addLogicEvent("closeGongGao",handler(self, self.showGonggaoBtn),self)

end
-- function LoginSceneCtrller:showGonggaoBtn(event)
--     self.view.btnGonggao:setVisible(true)
-- end
function LoginSceneCtrller:onMsgHelpDesk(event)
    if (self.running and self.view~=nil) then
        self.view:initBaseInfo();
    end
end

function LoginSceneCtrller:onMsgUser(event)
    -- var_dump(event.message.ply_lobby_data_);
    -- print(event.message.ply_lobby_data_.nickname_);
    if (self.logic.userData.ply_lobby_data_) then
        self.data.user.userName =  self.logic.userData.ply_lobby_data_.nickname_;
        self.data.user.userMoney = tostring(self.logic.userData.ply_lobby_data_.money_);--string.format("%d",self.logic.userData.ply_lobby_data_.money_);
        self.data.user.avatar = gBaseLogic.lobbyLogic.face
        self.data.user.vipLevel = self.logic.userData.ply_vip_.level_
        self.data.user.vipStatus = self.logic.userData.ply_vip_.status_
        self.view:setEnabled();
        gBaseLogic:unblockUI();
    else
        self.data.user.userName =  "未登录";
        self.data.user.userMoney = 0;
        self.data.user.avatar =''
        self.data.user.vipLevel = 0
        self.data.user.vipStatus = 0
        self.view:setDisabled();
    end
    
    self.view:initUserInfo();
end
function LoginSceneCtrller:pt_lc_send_user_data_change_not_rec()
    self:onMsgUser();
end
-- function LoginSceneCtrller:onMsgDengLu(event)
--     -- var_dump(event.message);
--     if (event.message~=nil)then
--         if (event.message.ret_==0) then
            
--             if (event.message.money_>0) then
--                 print(event.message.money_)
--                 self.logic.userData.ply_lobby_data_.money_ = event.message.money_;
--                 self.data.user.userMoney = event.message.money_; --?userMoney is string?
--                 self.view:initUserInfo();
--                 gBaseLogic:coin_drop();
--             end
            
--         end
--     end
    
-- end

function LoginSceneCtrller:onEnter()
    -- body
end

return LoginSceneCtrller;