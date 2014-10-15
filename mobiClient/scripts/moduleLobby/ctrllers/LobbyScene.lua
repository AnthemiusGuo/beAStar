local LobbySceneCtrller = class("LobbySceneCtrller",izx.baseCtrller)

function LobbySceneCtrller:ctor(pageName,moduleName,initParam)
    self.data = {
        userName = '',
        userMoney = 0,
        ply_vip_ = {}
        --gBaseLogic.lobbyLogic.userHasLogined
    };
    

	LobbySceneCtrller.super.ctor(self,pageName,moduleName,initParam);
end

function LobbySceneCtrller:reSetData()
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

function LobbySceneCtrller:run()
    print ("LobbySceneCtrller:run")
    if self.initParam.isFirstRun then
        gBaseLogic.inGamelist = -1;
        if gBaseLogic.MBPluginManager.distributions.removeLogin then
            gBaseLogic:unblockUI();
            gBaseLogic.lobbyLogic:showLoginTypeLayer();
        else

            gBaseLogic:checkLogin(); 
        end
        -- self.logic:requestHTTGongGao(1); 
    end
    
    -- 领取登陆奖励
    if self.logic.userData.ply_lobby_data_ then  
                
        if gBaseLogic.lobbyLogic.pochanTolobby == 1 then
            self.logic:showFreeCoinLayer();
            gBaseLogic.lobbyLogic.pochanTolobby = 0
            
        end
    end
    if self.initParam.reload==1 then
        gBaseLogic.inGamelist = -1;
        if (self.initParam.showMsg) then
            gBaseLogic.lobbyLogic:onNoNet(2,self.initParam.showMsg);
        else
            gBaseLogic.lobbyLogic:showLoginTypeLayer();
        end 
        
        if gBaseLogic.lobbyLogic.needSessionLogout==1 then
            gBaseLogic.lobbyLogic.needSessionLogout=0
            gBaseLogic.lobbyLogic:closeSocket();
            gBaseLogic.MBPluginManager:sessionLogout();
        end
    end

    -- self.logic:addLogicEvent("MSG_Socket_pt_lc_match_require_status_ack",handler(self, self.pt_lc_match_require_status_ack),self)
    self.logic:addLogicEvent("MSG_Sock_pt_lc_match_require_status_ack",handler(self, self.pt_lc_match_require_status_ack),self)
    if self.logic.gametoback==1 and self.logic.isOnGameExit==0 then
    	self.logic.gametoback=0;
    	print("sdasdasfas")
		if self.logic.hasNewMatch == 1 then
			self.logic.hasNewMatch = 0;
			if self.logic.newMatchInfo~=nil then
    			self.logic:pt_cl_match_require_status_req(self.logic.newMatchInfo)
    			
    		end
    	end
    end
    -- var_dump(self.logic.userData.ply_vip_);
    --self.view:initBaseInfo()

    self.logic:addLogicEvent("MSG_Socket_UserData",handler(self, self.onMsgUser),self)
    self.logic:addLogicEvent("MSG_SOCK_pt_lc_trumpet_not",handler(self, self.pt_lc_trumpet_not_rec),self)
    self.logic:addLogicEvent("MSG_Socket_pt_lc_send_friend_msg_not",handler(self, self.pt_lc_send_friend_msg_not_rec),self)

    self.logic:addLogicEvent("MSG_Socket_pt_lc_send_user_data_change_not",handler(self, self.pt_lc_send_user_data_change_not_rec),self)
     -- self.logic:addLogicEvent("MSG_Socket_pt_lc_get_user_money_ack",handler(self, self.pt_lc_get_user_money_ack),self)
    
    self.logic:addLogicEvent("MSG_Socket_ChongZhiJiangLi",handler(self, self.changChongzhijiangli),self)

    self.logic:addLogicEvent("MSG_GAME_SOCKET_NOLOGIN",handler(self, self.on_game_error),self)
    self.logic:addLogicEvent("MSG_GAME_SOCKET_ERR",handler(self, self.on_game_error),self)
    self.logic:addLogicEvent("MSG_GAME_SOCKET_KICK",handler(self, self.on_game_error),self)

    self.logic:addLogicEvent("MSG_userName_rst_send",handler(self, self.onUserNameUpdate),self)
    self.logic:addLogicEvent("MSG_change_user_money",handler(self, self.changeUserMoner),self)

    self:getHuoDongData()

    -- self.logic:addLogicEvent("MSG_SOCK_pt_lc_get_miniGame_ack",handler(self, self.pt_lc_get_miniGame_ack_handler),self);
    -- if CONFIG_USE_SOUND==false then
    --     izxMessageBox("CONFIG_USE_SOUND==false", "notic")
    -- end

    -- if SKIP_PLUGIN==true then
    --     izxMessageBox("SKIP_PLUGIN==true", "notic")
    -- end
    -- if SKIP_UPGRADE==true then
    --     izxMessageBox("SKIP_UPGRADE==true", "notic")
    -- end
    LobbySceneCtrller.super.run(self);
    if self.logic.needShowMatchResult then
    	self.logic:showBiSaiWinScene()
    	self.logic.needShowMatchResult = nil;
    end
    if(gBaseLogic.MBPluginManager.distributions.nominigame) then
        self.logic.showXinShouTiShi = nil
    end
    if self.logic.showXinShouTiShi~=nil then
        --[[
        local num = self.logic.showXinShouTiShi
        local puid = self.logic.userData.ply_guid_;
        local aa = CCUserDefault:sharedUserDefault():getIntegerForKey("Xin"..puid .."_"..num);
        print(puid .."---"..aa);
        if (CCUserDefault:sharedUserDefault():getIntegerForKey("Xin"..puid .."_"..num)~=1) then
            CCUserDefault:sharedUserDefault():setIntegerForKey("Xin"..puid .."_"..num,1)
            self.logic:showXinShouTiShiLayer(self.logic.showXinShouTiShi)
        else
            self.logic.showXinShouTiShi = nil
        end
        --]]

        local num = self.logic.showXinShouTiShi
        local puid = self.logic.userData.ply_guid_;
        local aa = CCUserDefault:sharedUserDefault():getStringForKey("Xin"..puid .."_"..num);
        print(puid .."---"..aa);
        local curday = tostring(os.date("%x", os.time()))
        if (aa~=curday) then
            local config_game = {[2]=100,[3]=101}
				if (MAIN_GAME_ID==11) then
					config_game = {[2]=100,[3]=101,[6]=103,[7]=104}
				end
            local flag=0
            if config_game[num]~=nil then 
                local miniGameInfo = izx.miniGameManager:getMiniGame(config_game[num]);
                if miniGameInfo==nil then
                    flag=1;
                end
            end
            if flag==0 then
                CCUserDefault:sharedUserDefault():setStringForKey("Xin"..puid .."_"..num,curday)
                self.logic:showXinShouTiShiLayer(self.logic.showXinShouTiShi)
            end
        else
            self.logic.showXinShouTiShi = nil
        end
        
    end 
    if gBaseLogic.inGamelist == nil then
        gBaseLogic.inGamelist = -1;
    end
    if gBaseLogic.inGamelist~=-1 then
        print("gBaseLogic.inGamelist"..gBaseLogic.inGamelist)
        self.view:showGameLists(gBaseLogic.inGamelist,true)
    end
    

end

function LobbySceneCtrller:changeUserMoner(event)
    print("LobbySceneCtrller:changeUserMoner")
    local message = event.message;
    if message.ret == 0 then 
        self.data.userMoney = string.format("%d",self.logic.userData.ply_lobby_data_.money_);
        self.view:formatUserMoney(self.data.userMoney)
    end
end

function LobbySceneCtrller:getHuoDongData()
    print("LobbySceneCtrller:getHuoDongData")
    local tableRst = {uid = self.logic.userData.ply_guid_,code = code};
    --local url = "http://igame.b0.upaiyun.com/readme/bbbb.htm"
	if (MAIN_GAME_ID==10) then
        self.view:showHuoDongHight()
	end
    --[[
    HTTPPostRequest(URL.ISHUODONG, nil, function(event)
    --gBaseLogic:HTTPGetdata(url,0,function(event)
          print("LobbySceneCtrller:getHuoDongData2")
        var_dump(event)
        
        if event ~= nil then
            if event.ret == 1 then
                self.view:showHuoDongHight()
            end
        end     
        end);
    --]]
end

function LobbySceneCtrller:onUserNameUpdate(event)
    --izxMessageBox(event.message.sessionInfo.nickname,event.message.msg)
    print("LobbySceneCtrller:onUserNameUpdate")
    --dump(event)
    self.logic.haschangename = true -- is it need?
    self.data.userName = event.message.sessionInfo.nickname
    self.view.labelNickName:setString(izx.UTF8.sub(self.data.userName,1,7))
    -- if (self.running) then
    --    self.view:initBaseInfo();
    -- end
end

function LobbySceneCtrller:onMsgUser()
	print("LobbySceneCtrller:onMsgUser")
    if (self.running) then
        -- self.data.userName = self.logic.userData.ply_lobby_data_.nickname_;
        -- self.data.userMoney = string.format("%d",self.logic.userData.ply_lobby_data_.money_);
        -- self.data.ply_vip_ = self.logic.userData.ply_vip_;
	    self.view:initBaseInfo();
    end
end

function LobbySceneCtrller:on_game_error(event)
  print("===========on_game_ERROR");
    if (event.name == "MSG_GAME_SOCKET_ERR") then
        if (izx.resourceManager:getNetState() == false) then
            gBaseLogic.lobbyLogic:reShowLoginScene();
        else
            izxMessageBox(event.message.info, event.message.title)
        end
    else
        local initParam = {}
        if event.message.initParam~=nil then
            initParam = event.message.initParam;
			  if (MAIN_GAME_ID==11) then
		        if(event.name == "MSG_GAME_SOCKET_KICK" and initParam.type == 2) then
		            gBaseLogic:onNeedMoney("gameenter",event.message.initParam.needMoney,2)
		            return
		        end
		        if(event.name == "MSG_GAME_SOCKET_NOLOGIN" and initParam.type == -3) then
		            gBaseLogic:onNeedMoney("gameenter",event.message.initParam.needMoney,1)
		            return
		        end
				end
        else
            initParam = {msg=event.message.info,type=1000};
        end
        self.logic:showYouXiTanChu(initParam)
        -- izxMessageBox(event.message.info, event.message.title)
    end
end
function LobbySceneCtrller:pt_lc_trumpet_not_rec(event)
    var_dump(message)
    local message = event.message
    --local msg_ = message.message_;
    -- --if 0 == message.ply_guid_ then
    -- if "" == message.ply_nickname_ then
    --     msg_ = ("【系统】:" .. msg_)
    -- else
    --     msg_ = ("【" .. message.ply_nickname_ .. "】:" .. msg_)
    -- end
    
    -- self.view.labelGonggao:setString(gBaseLogic.MBPluginManager:replaceText(msg_))
    self.view.labelGonggao:setString(message.message_)
end
function LobbySceneCtrller:changChongzhijiangli(event)
    self.view:changeChongzhijiangliButton();
    
end
function LobbySceneCtrller:pt_lc_send_friend_msg_not_rec(event)
    self.view:showNewMsg();
end
function LobbySceneCtrller:pt_lc_send_user_data_change_not_rec()
    print("pt_lc_send_user_data_change_not_rec")
    self.data.userName = self.logic.userData.ply_lobby_data_.nickname_;
    self.data.userMoney = string.format("%d",self.logic.userData.ply_lobby_data_.money_);
    self.data.ply_vip_ = self.logic.userData.ply_vip_;
    self.view:initBaseInfo()
end
-- function LobbySceneCtrller:pt_lc_get_user_money_ack()
--     self:pt_lc_send_user_data_change_not_rec();
-- end
function LobbySceneCtrller:pt_lc_match_require_status_ack(event)
	local message = event.message;
	print("LobbySceneCtrller:pt_lc_match_require_status_ack")
	var_dump(message,4);
	if message.ret_==1 then
		print("LobbySceneCtrller:pt_lc_match_require_status_ack111")
		self.logic:startMatchGames(self.logic.newMatchInfo)
		self.logic.newMatchInfo =nil;
	end
end
return LobbySceneCtrller;
