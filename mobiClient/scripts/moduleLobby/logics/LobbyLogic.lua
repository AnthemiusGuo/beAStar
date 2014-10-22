local LobbyLogic = class("LobbyLogic");
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler");
LobbyLogic.MSG_HTTP_HelpDesk = "MSG_HTTP_HelpDesk";
LobbyLogic.MSG_HTTP_GongGaoCommon = "MSG_HTTP_GongGaoCommon";
-- self:getChongZhiJiangLiData()
--MSG_SOCK_pt_lc_get_daily_task_award_ack
--[[message:   {opcode:"pt_lc_get_daily_task_award_ack",res_:'0', money_:300,
			 gift_:12,prop_1_:3,prop_2_:5,prop_3_:6,prop_4_:7,prop_5_:7}]]--

-- pt_lc_get_achieve_list_ack
-- pt_lc_get_achieve_award_ack 
--     message:   {opcode:"pt_lc_get_achieve_award_ack",res_:'0', money_:300,
			-- gift_:12,prop_1_:3,prop_2_:5,prop_3_:6,prop_4_:7,prop_5_:7}
-- pt_lc_get_safe_data_ack --保险箱数据
-- pt_lc_set_password_safe_ack -- 保险箱设置密码
-- pt_lc_store_safe_amount_ack -- 保险箱存钱
-- pt_lc_remove_safe_amount_ack -- 保险箱取钱
-- pt_lc_modify_password_safe_ack --保险箱修改密码
-- pt_lc_get_safe_history_ack

-- LobbyLogic.MSG_HTTP_ShopHistory = "MSG_HTTP_ShopHistory"; --商城充值记录


function LobbyLogic:ctor()
	self.match_current_score = 0;
	self.lobbyErr = 0;--lobby服务器是否出错
	self.showXinShouTiShi = nil --是否出新手提示
	self.curSocketConfigList = nil
	self.helpDesk = HELP_QQ;
	self.userData = {};
	self.chatData = {};
	self.mailData = {};
	self.achieveListData = {};
	self.eventCache = {};
	self.server_datas_ = {};
 	self.server_status_ = {};

 	self.gotoGameName = "";
 	self.paymentItemList = nil;
    self.VIPItemList = nil;
    self.payVIPItemList = nil;
    self.payItemNormal = {};
    self.payItemSMS = {};
    self.payItemProp = {};
    self.payItemNormalCounter = 0;
    self.payItemSMSCounter = 0;
    self.guangBaoList = {} --广播记录
 	self.hasNewMsg = 0;
 	self.closeGameErr = 0;

 	self.gongGaoContent = "暂无公告";
	self.gongGaotitle = "公告";
	self.hasqiangtuigonggao = 0;

	self.haschangename = false

	self.payInitList = nil;
	self.getPayNum = 10;
	self.gametomove = 0
	self.distrank = 0;
	self.lowMoney = false;
	self.lowMoneyMsg = "";
	self.gameType = -1;
	self.relief_times_ = 0;

	self.pochanTolobby = 0;
	self.gametoback = 0;
	self.winRoundInfo = {
		score = 0,
		winNum = 0,
		maxScore = 0,
		maxWinNum = 0
	}
	self.selfTips = {
		isTips = false,
		userMoney = 0,
		needMoney = 0,
		boxInfo = {},
		status = 0,
	}
	self.vipData = {vipLevel=0,vipRate=0,nextVipneedMoney=1
    }
	self.isShow = false;
	self.otherplayin = 0 -- 1:抢帐号 2：大厅断网
	self.isOnGameExit = 0 -- 1:主动退出游戏
	
	self.needSessionLogout = 0 --切换帐号时是否需要loginout
	--双倍宝箱数据
	self.doubleChestids = {}
	require("framework.api.EventProtocol").extend(self)
	require("moduleLobby.logics.PicConfig");
	require('moduleLobby.logics.LobbyGameLogic').extend(self);
	require("moduleLobby.logics.AudioConfig");
	izx.baseAudio:init();
	-- self.taskData = {};

	--appstore check
	self.vip = 0;
	self.jihuoma = 0;
	self.ver_codes = 0;
	self.exitgame = 0;
	self.minigamedownload = 0;
	self.promotion = 0;
	self.gonggao = 0;
	self.safe = 0;
	self.minigame = 0;
	self.guidhelp = 0;
	--match 
	self.isMatch = 0;
	self.isMatchOnGameExit = 0;
	-- self.curMatchID = 0;
	-- self.curMatchOrderID =0;
	-- self.curMatchScore = 0;
	-- self.curMatchRound = 0;
	-- self.curMatchTRound = 0;
	
	
end

function LobbyLogic:resetLocation()
	self.locationData = {
		location = 0,
		imgId = 0,
		locationName = '未知地点',
		cityName = '未知城市',

	}
end

function LobbyLogic:run()
	self:resetLocation();
	self:resetUserInfo();
	self:enterLocationScene();
end

function LobbyLogic:dispatchLogicEvent(event)
	-- var_dump(event)
	if (gBaseLogic.sceneManager.inTransition) then
		print("LobbyLogic:dispatchLogicEvent cache")
		table.insert(self.eventCache, event);
	else
		print("LobbyLogic:dispatchLogicEvent dis")
		-- var_dump(self.listeners_,4);
		self:dispatchEvent(event)
	end
end

function LobbyLogic:dispatchEventToCache(event)
	table.insert(self.eventCache, event);
end

function LobbyLogic:dispatchCachedEvent()
	for k,event in pairs(self.eventCache) do
		self:dispatchEvent(event);
	end
	self.eventCache = {};
end

function LobbyLogic:addLogicEvent(eventName,handler,target)
	target.handlerPool = target.handlerPool or {};
	target.handlerPool[eventName] = self:addEventListener(eventName,handler);
end

function LobbyLogic:removePage(pageName,needEnterLobby)
	if (needEnterLobby) then
	    self:enterLocation();
	end 
end

function LobbyLogic:startLobbySocket(lobbySocketConfig)
	print("lobbySocket:connect");
	gBaseLogic.MBPluginManager:logEventLabelMyBegin("LOGIN_STEP_DURA","connectLobby");
	 
	self.lobbySocket = self.lobbySocket or require("izxFW.SocketWrapper").new(self,
		gBaseLogic.socketConfig.socketType,
		lobbySocketConfig,
		'lobby');
	self.lobbySocket:connect();
end

function LobbyLogic:closeSocket()
	if (self.lobbySocket) then
		self.lobbySocket:close();
		self.lobbySocket = nil;
	end
end

function LobbyLogic:resetUserInfo()
	print("LobbyLogic:resetUserInfo")
	self.userData = nil;
	self.userData = {
		avatarId = 1,
        uname = "未登录",
        vip_level = 0,
        uid = "0",
        level = 0,
        exp = 0,
        exp_len = 0,
        money = 0,
        voucher = 0,
        credits = 0,
        money_show = 0,
        avatar_url = "/images/avatar/0.png",
        avatar_id = 0,
        show_uid = "0",
        is_anonym = 1,
        energy = 0,
        mood = 0
	};
	
	self.haschangename = false
	self.userHasLogined = false;

	
	self:dispatchLogicEvent({
        name = "MSG_Socket_UserData",
        message = {}
    })
end


function LobbyLogic:destroyListen()
	local scene = display.getRunningScene()
  	scene:removeChild(self.rootNode)
end

function LobbyLogic:resetLogin(block,msg)
	gBaseLogic:unblockUI();
	if (gBaseLogic.gameLogic) then
		if (gBaseLogic.gameLogic.resDir) then
			izx.resourceManager:removeSearchPath(gBaseLogic.gameLogic.resDir);
		end
		if (gBaseLogic.gameLogic.onGameExit) then
			gBaseLogic.gameLogic:onGameExit();
		end
		gBaseLogic.gameLogic = nil;
	end
	self.userData = nil;
	self.userData = {};
	self.userHasLogined = false
	local initParam = {};
	-- if changeUser==nil then
	-- 	initParam={}
	-- else
	-- 	initParam = {reload=1}
	-- end
	initParam = {reload=1,showMsg=msg}

	gBaseLogic.onLogining = false;
	gBaseLogic.currentState = gBaseLogic.stateInLobby;

	self:enterLocation();
end

function LobbyLogic:goBackToMain(withLoading)
	
	if (gBaseLogic.gameLogic) then
		if (gBaseLogic.gameLogic.resDir) then
			izx.resourceManager:removeSearchPath(gBaseLogic.gameLogic.resDir);
		end
		if (gBaseLogic.gameLogic.onGameExit) then
			gBaseLogic.gameLogic:onGameExit();
		end
		gBaseLogic.gameLogic = nil;
		self.gametoback = 1;
	end
	if (withLoading) then
		self:showFakeLoadingScene("moduleLobby");
	else
		self:enterLocation();
	end
end


function LobbyLogic:showFakeLoadingScene(moduleName)
	local slideIn = "";
	-- local cback = nil;
	if (moduleName=="moduleLobby") then
		slideIn = "right"
	else 
		slideIn = "left"
		print(moduleName)

		if (moduleName=="moduleMainGame") then
			print("gamessdsssss");
		end
	end
	-- local LoadingScene = izx.basePage.new(self,"FakeLoadingScene","moduleLobby",{
	-- 		pageType = izx.basePage.PAGE_TYP_CCB,
	-- 		ccbFileName = "interfaces/Loading.ccbi",
	-- 		ccbController = "sceneLoading",
	-- 		initParam = {moduleName=moduleName},
	-- 		slideIn = slideIn
	-- 	}
	-- );
	-- Guojia 20140616 改ccb改煩了,改用純代碼
	local LoadingScene = izx.basePage.new(self,"FakeLoadingSceneCode","moduleLobby",{
			pageType = izx.basePage.PAGE_TYP_CODE,
			isCodeScene = true,
			initParam = {moduleName=moduleName},
			slideIn = slideIn
		}
	);
	LoadingScene:enterScene(false);
end
function LobbyLogic:showLoadingScene(moduleName,miniGameId)
	-- Guojia 20140616 改ccb改煩了,改用純代碼
	-- local LoadingScene = izx.basePage.new(self,"LoadingScene","moduleLobby",{
	-- 		pageType = izx.basePage.PAGE_TYP_CCB,
	-- 		ccbFileName = "interfaces/Loading.ccbi",
	-- 		ccbController = "sceneLoading",
	-- 		initParam = {moduleName=moduleName,gameId=miniGameId},
	-- 		slideIn = "left"
	-- 	}
	-- );

	local LoadingScene = izx.basePage.new(self,"LoadingSceneCode","moduleLobby",{
			pageType = izx.basePage.PAGE_TYP_CODE,
			isCodeScene = true,
			initParam = {moduleName=moduleName,gameId=miniGameId},
			slideIn = "left"
		}
	);
	LoadingScene:enterScene(false);
end

function LobbyLogic:enterLocationScene(initParam)
	if (initParam == nil or initParam.locationInfo == nil) then
		initParam = {
			locationInfo = self.locationInfo
			
		};
	end
	local locationScene = izx.basePage.new(self,"LocationScene","moduleLobby",{
			pageType = izx.basePage.PAGE_TYP_CCJ,
			ccjFileName = "interfaces/location.json",
			slideIn = "right",
			initParam = initParam
		}
	);
	locationScene:enterScene(false);
	gBaseLogic.currentState = gBaseLogic.stateInLocation;
end

function LobbyLogic:showGameList(type)
	self.gamePageList = nil
	self.gamePageList = izx.basePage.new(self,"GamePageList","moduleLobby",{
			pageType = izx.basePage.PAGE_TYP_CODE,
			initParam = {type=type},
			
		}
	);
	local block = false;
	if type==2 then
		block=true
	end
	self.gamePageList:addToScene({block=block,targetX=display.cx,
			targetY=display.cy,
			slideIn = "left"});
	
end

-- function LobbyLogic:getCharacterNameChangeHTTP()
--     local url = string.gsub(URL.NAMECHANGE,"{pid}",self.userData.ply_guid_); --test
--     echoInfo("checking nikename is change: "..url);
--     --"http://statics.hiigame.com/get/modify/count.do"
--     --"uid=1113134339110250"
--     gBaseLogic:HTTPGetdata(url, 0, function(event)
-- 	    	if event.count then 
-- 	        self.haschangename = true
-- 	        else
-- 	        self.haschangename = false	
-- 	    	end
--         end)
-- end 

function LobbyLogic:getCharacterNameChangeHTTP()
    local url = string.gsub(URL.NAMECHANGE,"{pid}",self.userData.ply_guid_); --test
    echoInfo("checking nikename is change: "..url);
    --"http://statics.hiigame.com/get/modify/count.do"
    --"uid=1113134339110250"
    gBaseLogic:HTTPGetdata(url, 0, function(event)
	    	if event.count then 
	        self.haschangename = true
	        else
	        self.haschangename = false	
	    	end
        end)
end 

function LobbyLogic:showPersonalInformationScene(initParam)
	
	self.personalScene = nil
	self.personalScene = izx.basePage.new(self,"PersonalScene","moduleLobby",{
			pageType = izx.basePage.PAGE_TYP_CCB,
			ccbFileName = "interfaces/GeRenXinXi.ccbi",
			ccbController = "informationControll",
			initParam = initParam
		}
	);
	self.personalScene:enterScene(false);
	if (MAIN_GAME_ID==13) then
		self:requestHTTPAchieve(self.userData.ply_guid_,1);
	end
end


function LobbyLogic:onCheckGameModules(msg)
	
    local event = json.decode(msg);
    if (event.e == 'progress') then
    	self:dispatchLogicEvent({
	        name = "MSG_PLUGIN_ASSET_PROGRESS",
	        message = {plugin=self.upgradingPluginModule,
	        			package = event.p,
	        			progress = event.data
	    	}
	    })
    elseif (event.e == "success") then
    	self:dispatchLogicEvent({
	        name = "MSG_PLUGIN_ASSET_SUCCESS",
	        message = {plugin=self.upgradingPluginModule,
	        			typ="DOWNLOAD"
	    	}
	    })
    elseif (event.e == "error") then
    	if (event.type == "errorNoNewVersion") then
    		self:dispatchLogicEvent({
		        name = "MSG_PLUGIN_ASSET_SUCCESS",
		        message = {plugin=self.upgradingPluginModule,
		        			typ="NO_NEW_VERSION"
		    	}
		    })
		else
			self:dispatchLogicEvent({
	        name = "MSG_PLUGIN_ASSET_ERROR",
	        message = {plugin=self.upgradingPluginModule,
	        			typ=event.type
	    	}
	    })
    	end
    end
end


function LobbyLogic:onSocketOpen()
	gBaseLogic.MBPluginManager:logEventLabelMyEnd("LOGIN_STEP_DURA","connectLobby");
	self:reqLogin();
end

function LobbyLogic:onSocketClose()
	self.lobbySocket = nil;
	self.otherplayin = 2;
	self:onKickNet("网络断开，请检查网络");
end

function LobbyLogic:onConnectFailure()
	self.lobbySocket = nil;
	self:onKickNet("网络连接失败，请检查网络");
end

function LobbyLogic:reqPluginLogin()
	echoInfo("checkLogin!!");
	
	self.userHasLogined = false;

	local everLogin = CCUserDefault:sharedUserDefault():getBoolForKey("everLogin",false);
	-- echoInfois_login = false;

	if everLogin == true then
		-- 已经登录过的自动选择上次的登录方式

	    local sessionType = CCUserDefault:sharedUserDefault():getStringForKey("sessionType");
	    echoInfo("will load:sessionType:"..sessionType);
	    
	    if (gBaseLogic.MBPluginManager.allLoginTyp[sessionType]~=nil) then
		    gBaseLogic.MBPluginManager:sessionLogin(sessionType);
	    	return;
	    end
	end

	local hasSessionGuest = 0;
	local defaultSession = "";
	for sessionName,sessionInfo in pairs(gBaseLogic.MBPluginManager.allLoginTyp) do
		if (sessionName=="SessionGuest") then
			defaultSession = "SessionGuest";
		else
			if sessionInfo.default==1 then				
				defaultSession = sessionName;
			end
		end
		
	end
	if (defaultSession~="") then		
		scheduler.performWithDelayGlobal(function()
			gBaseLogic.MBPluginManager:sessionLogin(defaultSession); 
	    end, 0.01);
	else

		gBaseLogic:unblockUI();
		self:showLoginTypeLayer();
	end
end

function LobbyLogic:reqLogin()	
	print("LobbyLogic:reqLogin")
	gBaseLogic.MBPluginManager:logEventLabelMyBegin("LOGIN_STEP_DURA","socketLobbyLogin");
	gBaseLogic.MBPluginManager:logEventEnd("loginDuration");
	gBaseLogic:blockUI({autoUnblock=false,msg=LOGIN_LOADING_TIPS3,hasCancel=true,callback=handler(gBaseLogic,gBaseLogic.onPressCancelLogin)});
	 gBaseLogic.inGamelist = -1;
	local socketMsg = {opcode = 'pt_cl_verify_ticket_req',
						ply_guid_ = tonumber(self.userData.ply_guid_),
						ply_nickname_ = self.userData.ply_nickname_,
						ply_ticket_ = self.userData.ply_ticket_,
						game_id_ = MAIN_GAME_ID,
						version_ = CASINO_VERSION_DEFAULT,
						ext_param_ = '',
						sex_ = self.userData.ply_sex,
						packet_name_ = gBaseLogic.packageName,

	};
	if self.lobbySocket==nil then
		self:closeSocket();
        gBaseLogic:unblockUI();
        self:onNoNet(2,"登录失败，请检查网络");
        gBaseLogic.onLogining = false;
        return
	end
	self:sendLobbySocket(socketMsg);
	-- self.lobbyResendCounter = 0;
	-- local _loginTimeTick = function ()
	-- 	self.lobbyResendCounter = self.lobbyResendCounter+1;
	-- 	if (self.lobbyResendCounter>5) then
	--         self:closeSocket();
	--         gBaseLogic:unblockUI();
	--         self:onNoNet(2,"登录失败，请检查网络");
	--         gBaseLogic.onLogining = false;
	--     else
	--     	self:sendLobbySocket(socketMsg);
	--     	self.loginTimeTickScheduler = scheduler.performWithDelayGlobal(_loginTimeTick, 2)
	--     end
 --    end
 --    self.loginTimeTickScheduler = scheduler.performWithDelayGlobal(_loginTimeTick, 2)

end

function LobbyLogic:onSocketMessage(message)
	if self.loginTimeTickScheduler then 
        scheduler.unscheduleGlobal(self.loginTimeTickScheduler) 
    end
	print ("lobby get Messgage::" .. message.opcode);	
	-- var_dump(message);
	if (self[message.opcode .. "_handler"]~=nil) then
		print("11111");
		self[message.opcode .. "_handler"](self,message);
		return;
	else
		--echoError("------------------ 没有处理函数的消息: [%s] !!!!!!!!!!!!!!!!",message.opcode);
		print("11112");
		self:dispatchLogicEvent({
	        name = "MSG_SOCK_"..message.opcode,
	        message = message
	    })
	end
end

function LobbyLogic:onKickNet(msg)
	echoInfo("LobbyLogic:onKickNet %s",msg);
	var_dump(gBaseLogic.currentState)
	self.userHasLogined = false
	if (gBaseLogic.currentState == gBaseLogic.stateLogin) then
		self.userData = nil;
		self.userData = {};
		if gBaseLogic.sceneManager.currentPage.ctrller.resetData ~= nil then
			gBaseLogic.sceneManager.currentPage.ctrller:resetData();
		end
		self:onNoNet(2,msg)
	elseif (gBaseLogic.currentState ~= gBaseLogic.stateLogin) then
		if (gBaseLogic.currentState == stateInRealGame or gBaseLogic.currentState == stateInMiniGame ) then
			self.gameSocket.close();
		end
		print("=====")
		self:reShowLoginScene(false,msg);	
	end

end

-- typ=0 没网络，typ=1，socket断，typ=2, 被踢下线，msg=nil或空用默认的话，typ=3 ,update fail
function LobbyLogic:onNoNet(typ,msg)
	gBaseLogic:unblockUI();
	self:resetUserInfo();
	if (msg==nil) then
		msg = '登录失败，请尝试重新登录或进入单机游戏';
	end
	gBaseLogic:confirmBox({
        msg=msg,
        btnTitle={btnConfirm="单机游戏",btnCancel="登录"},
        callbackConfirm = function()
            echoInfo("Into Robot game!!!");
			gBaseLogic.is_robot = 1
			gBaseLogic.lobbyLogic:startRobotGame() 
        end,
        callbackCancel = function()
            gBaseLogic.lobbyLogic:showLoginTypeLayer();
        end});
end

function LobbyLogic:gobackGameforonExitConfirm()
	local function callback()
		print("进入游戏！")
		-- self.pt_cl_get_ply_status_req
		local socketMsg = {opcode = 'pt_cl_get_ply_status_req',
						players_ = {self.userData.ply_guid_} 	
						};
		gBaseLogic.lobbyLogic:sendLobbySocket(socketMsg);
	end
	local initParam = {msg="您上局游戏还没有结束，快回去虐他们！",cback=callback,type=1000};
	self:showYouXiTanChu(initParam)
end


function LobbyLogic:sendReloadUserData()
	local socketMsg = {opcode = 'pt_cl_reload_user_data_req'};
	self:sendLobbySocket(socketMsg);
	--var_dump(socketMsg)
end 

function LobbyLogic:onSocketTempClose()
	echoInfo("服务器断开，正在为您重连服务器，请稍候");
	print("LobbyLogic:onTempClose1111")
	gBaseLogic:blockUI({autoUnblock=false,msg="服务器断开，正在为您重连服务器，请稍候!"})
	-- gBaseLogic.sceneManager.currentPage.view:ShowGameTip("服务器断开，正在为您重连服务器，请稍候")

end

function LobbyLogic:onSocketReOpen()
	print("LobbyLogic:onSocketReOpen")
	gBaseLogic:unblockUI()
	self:onSocketOpen();
end

function LobbyLogic:SendTrumpetReq(message)
  local socketMsg = {opcode = 'pt_cl_trumpet_req',
            type_ = 0, 
            message_ = message,         
            };
  self:sendLobbySocket(socketMsg);
end

function LobbyLogic:sendLobbySocket(socketMsg)
	if self.lobbySocket==nil then
		gBaseLogic:reqLogin()
	else
		self.lobbySocket:send(socketMsg)
	end
end

return LobbyLogic; 