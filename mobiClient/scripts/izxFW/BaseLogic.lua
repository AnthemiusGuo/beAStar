local BaseLogic = class("BaseLogic")
local _instance
BaseLogic.httpClient_url = "http://192.168.30.34/card/"

BaseLogic.DownloadPath = device.writablePath .. "/download/";

BaseLogic.stateUpgrade = 0;
BaseLogic.stateLogin = 1;
BaseLogic.stateInLocation = 2;
BaseLogic.stateInRealGame = 5;
BaseLogic.stateInSingleGame = 6;
BaseLogic.stateInMiniGame = 7;
BaseLogic.stateInNewbieGuide = 8;
BaseLogic.stateInMatchGame = 9; --for match

BaseLogic.nowLocation = 0;

function BaseLogic.getInstance()
    if not _instance then
        _instance = BaseLogic.new();
        _instance:init();
    end

    return _instance
end

function BaseLogic:ctor()
	require("framework.api.EventProtocol").extend(self);
	self.sceneManager = require("izxFW.SceneManager").new();
	self.currentState = self.stateUpgrade;
	
end

function BaseLogic:init()
	
	self.lobbyLogic = require("moduleLobby.logics.LobbyLogic").new();
	local notificationCenter = CCNotificationCenter:sharedNotificationCenter()
    notificationCenter:registerScriptObserver(nil, handler(self, self.onEnterBackground), "APP_ENTER_BACKGROUND")
    notificationCenter:registerScriptObserver(nil, handler(self, self.onEnterForeground), "APP_ENTER_FOREGROUND")

    self.is_robot = 0
	self.currentGame = '';
	self.inPayBox = 0;
	self.onLogining = false;
	self.scheduler = require(cc.PACKAGE_NAME .. ".scheduler");
	
	self.debugCounter = 0;
	
	self.miniGameResPath = '';
	self.isForceUpgrade = false;
	self.isInCancelLogin = false;

	self.onbackGroundtime = 0
	self.inGround1 = 0;
	self.inGround2 = 0
	self.inGamelist = -1;--lobby 界面判断

	self.isshuangbeipay = 0; --pay double

	self.gameItems = CONFIG_GAME_USE_ITEMS
	self:initLogCounter();
	
	self.hasDownloadBiaoqing = false;
	self.hasDownloadShengyin = false;
	
    CCUserDefault:sharedUserDefault():setStringForKey("currGameInfo", "0")
    CCUserDefault:sharedUserDefault():setStringForKey("chargeCancel", "0")


    return self
end 

function BaseLogic:getStartData()
	if (self.MBPluginManager.distributions.startdata) then

	    -- call Java method
	    local javaClassName = "com.izhangxin.utils.luaj"
	    local javaMethodName = "getStartData"
	    local javaParams = {
	                
	    }
	    local javaMethodSig = "()Ljava/lang/String;";
	     echoInfo("来自java StartData函数");
	     luaj.callStaticMethod(javaClassName, javaMethodName, javaParams)
	    local rst,ret = luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig);

	    var_dump(rst);
	    var_dump(ret);
	    echoInfo("来自java StartData函数");

	    if (rst == false) then
	    	return;
	    end

	    local startData = json.decode(ret);
	    if (startData.music) then
	    	izx.baseAudio:SetEffectValue(1.0);
	    	izx.baseAudio:SetAudioValue(1.0);
	    else
	    	izx.baseAudio:SetEffectValue(0);
	    	izx.baseAudio:SetAudioValue(0);
	    end
	end
end

function BaseLogic:initLogCounter()
	--自定义统一在这里说明，避免事件ID不统一，
	--页面停留直接使用该页面类名，不在这里定义
	self.logCounter = {
		matchCounter=0,--游戏局数，1，2,3,5,10
		--payTypeCounter=0,--支付方式点击次数 use shopPay instead
		--payMoneryCounter=0,--支付次数 use shopPay instead
		--payOkCounter=0--支付成功次数 use payOkDuration instead
	}
	self.logDuration = {
		startDuration={start=0,duration_plus=0,stop=0},--启动到登录之间的时间
		-- loginDuration=0,--开始登录到登录完成的时间
		-- upper has changed function

		--gameDuration=0,--开始游戏到开始发牌的时间
		--gameLoginDuration=0,--点击场次到游戏开始的时间
		--shopDuration=0,--商店页面停留时间 
		--payOkDuration=0,--确认购买后到充值成功的时间 use begin end instead
		--payTipDuration={start=0,duration_plus=0,stop=0} use begin end instead
	}

	self.loglabelDuration ={
		gameTime={login=0,ready=0}
		--LOGIN_STEP={connectLobby=0,socketLobbyLogin=0,requestHTTGongGao=0}
	}

	-- self.logDefine = {
	-- shopPay={payType=0,payMonery=0,vipPayType=0,vipPayMonery=0}
	-- gameType={robot=robot1,happy=happy1,laizi=laizi1,mini=mini1}

	-- }
end

function BaseLogic:addLogCounter(tag,count)
	self.logCounter[tag] = self.logCounter[tag]+count;
	if (tag=="matchCounter") then
		if (self.logCounter[tag]==1 or self.logCounter[tag]==2 or self.logCounter[tag]==3 or self.logCounter[tag]==5 or self.logCounter[tag]==10) then
			gBaseLogic.MBPluginManager:logEvent("matchCounter"..self.logCounter[tag]);
		end 
	else 
		gBaseLogic.MBPluginManager:logEvent(tag);
	end
end

function BaseLogic:logDurationSetPlus(tag,plus)
	if (self.logDuration[tag]==nil) then
		self.logDuration[tag] = {
			start = os.time(),
			duration_plus = plus,
			stop = 0
		}
	else
		self.logDuration[tag].duration_plus = self.logDuration[tag].duration_plus + plus;
	end
end

function BaseLogic:logDurationStart(tag)
	if (self.logDuration[tag]==nil) then
		self.logDuration[tag] = {
			start = os.time(),
			duration_plus = 0,
			stop = 0
		}
	else
		self.logDuration[tag].start = os.time();
	end
end

function BaseLogic:logDurationEnd(tag)
	if (self.logDuration[tag]==nil) then
		return;
	end
	self.logDuration[tag].stop = os.time();
	local duration = (self.logDuration[tag].stop-self.logDuration[tag].start)+self.logDuration[tag].duration_plus;
	gBaseLogic.MBPluginManager:logEventDuration(tag,duration*1000)
end

function BaseLogic:logEventLabelDuration(tag,label,duration)
	if self.loglabelDuration[tag]==nil or self.loglabelDuration[tag].label==nil then
		return
	end

	if duration == 0 then 
		self.loglabelDuration[tag][label] = os.time()
	elseif duration == 1 then  
		self.loglabelDuration[tag][label] = os.time() - self.loglabelDuration[tag][label]
		print(tag..":"..label..":"..self.loglabelDuration[tag][label])
		gBaseLogic.MBPluginManager:logEventLabelDuration(tag, label,self.loglabelDuration[tag][label]);
	else
		print(tag..":"..label..":"..self.loglabelDuration[tag][label])
		gBaseLogic.MBPluginManager:logEventLabelDuration(tag, label, self.loglabelDuration[tag][label]);
	end 	
end

function BaseLogic:addLogDdefine(tag,name,value)
	if tag == "gameType" then 
		print("addLogDdefine:",tag,name,name..value)
		local param = {};
		param[name] = name..value;
		gBaseLogic.MBPluginManager:logEventKV(tag,param)
	else
		print("addLogDdefine:",tag,name,value)
		local param = {};
		param[name] = value;
		gBaseLogic.MBPluginManager:logEventKV(tag,param)
	end
end


function BaseLogic:onEnterBackground()
	self.isInBackground = true;
	print("----------------BaseLogic:onEnterBackground");
	self.onbackGroundtime = 0
	self.inGround1 = os.time();
	self.lobbyLogic:dispatchLogicEvent({name = "msgEnterBack",
	        message = {}})
	print("----------------BaseLogic:onEnterBackground end");
	if self.lobbyLogic.lobbySocket~=nil then
		self.lobbyLogic.lobbySocket:setNeedReConn(false)
	end
	if self.gameLogic~=nil and self.gameLogic.gameSocket~=nil then
		self.gameLogic.gameSocket:setNeedReConn(false)
	end
end

function BaseLogic:onEnterForeground()
	self.isInBackground = false;
	print("----------------BaseLogic:onEnterForeground");
	self.inGround2 = os.time();
	if self.lobbyLogic.lobbySocket~=nil then
		self.lobbyLogic.lobbySocket:setNeedReConn(true)
	end
	if self.gameLogic~=nil and self.gameLogic.gameSocket~=nil then
		self.gameLogic.gameSocket:setNeedReConn(true)
	else --add by lxy
		izx.baseAudio:stopMusic();
	end
	self.onbackGroundtime = self.inGround2 - self.inGround1;
	print("BaseLogic:onEnterForeground"..self.onbackGroundtime)
	print(self.inGround1)
	if self.inGround1==0 or self.onbackGroundtime>=180 then
		if self.inGround1~=0 and self.onbackGroundtime>=180 then
			if self.gameLogic~=nil then
				if self.gameLogic.inGamepage==1 and self.gameLogic.LeaveGameScene~=nil then
					self.gameLogic:LeaveGameScene(-1)
				end
			end
		end
	else
		self.lobbyLogic:dispatchLogicEvent({name = "msgEnterForeground",
	        message = {restime=self.onbackGroundtime}})
	end
	self.lobbyLogic:dispatchLogicEvent({name = "msgEnterFore",
	        message = {}})
	self.inGround2 = 0
	self.inGround1 = 0
	if(self.MBPluginManager ~= nil) then
		self.MBPluginManager:refreshConfig();
	end
end

function BaseLogic:runModule(gameModule,miniGameInfo)
	if (self.gameLogic == nil or self.currentGame ~=gameModule) then
		self.gameLogic = require(gameModule ..".logics.GameLogic").new();
		self.currentGame = gameModule;
	end
	self.gameLogic:setGameConfig(miniGameInfo);
	self.gameLogic:run();
	gBaseLogic:logEventLabelDuration("gameTime","login",1)
end
function BaseLogic:HTTPRequest(rst_url,pdata,cback)
	HTTPPostRequest(rst_url,pdata,cback);
end
-- is_test 参数 1:测试
function BaseLogic:HTTPGetdata(rst_url,is_test,cback)
 
	echoVerb("BaseLogic:HTTPGetdata")
 	
	local url
	if is_test ~= 0 then
		url = self.httpClient_url .. rst_url
	else
	 	url = rst_url
	end
    function callback(event)
    	
    	if (event.name == "inprogress") then
    		return
    	end
	    local ok = (event.name == "completed")
	    local request = event.request
	    var_dump(event,5)
	    if not ok then
	    	-- var_dump(event)
	        echoError("HTTP err %s,%s", request:getErrorCode(),request:getErrorMessage());
	        if cback then cback(nil) end
	    else
	    	local code = request:getResponseStatusCode()
	    	print(code);
		    if code ~= 200 then
		        if cback then cback(nil) end
		    else
		    	local response = request:getResponseString()
		    	var_dump(response)
		    	--解析成table
		    	local thistable = json.decode(response)
		    	--返回table数据
		    	print(22222222);
		    	var_dump(thistable)
		    	if cback then cback(thistable) end
		    end
	    end
	end
	local request = network.createHTTPRequest(callback, url, "GET")	
	request:setTimeout(20);
	request:start()
end

function BaseLogic:LoadpayList()
	print("BaseLogic:LoadpayList")
	var_dump(gBaseLogic.MBPluginManager.distributions.forceusesimtyp)
	local mb = self.MBPluginManager;	
	self.payMidUse = nil;
	self.payMidUse = {};
	print(mb:getSimType())
	gBaseLogic.MBPluginManager.distributions.quickpay = false;
	local forceusesimtyp = gBaseLogic.MBPluginManager.distributions.forceusesimtyp
	-- forceusesimtyp = 1
	if forceusesimtyp~=nil then
		forceusesimtyp = tonumber(forceusesimtyp)
	end
	-- print(gBaseLogic.MBPluginManager.distributions.forceusesimtyp)
	-- var_dump(mb.allIAPSmsType)
	print(11111)
	 gBaseLogic.MBPluginManager.IAPSmsUseMid = 0;
	if forceusesimtyp~=nil and forceusesimtyp>=1 and forceusesimtyp<=3 then
		for k,v in pairs(mb.allIAPSmsType) do 
			v.simTyp = tonumber(v.simTyp)
			local mid = tonumber(v.mid)
			if forceusesimtyp==v.simTyp  then
				table.insert(self.payMidUse,{mid=mid,imgPrev="",payTyp="SMS"})
	            gBaseLogic.MBPluginManager.IAPSmsType = v.pluginName;
	            gBaseLogic.MBPluginManager.IAPSmsUseMid = mid;
	            gBaseLogic.MBPluginManager.IAPSmsNeedConfirm = v.needConfirm
	            gBaseLogic.MBPluginManager.distributions.quickpay = true;
				return self.payMidUse
	        end			
		end
		

	end
	local mbSimTyp = tonumber(mb:getSimType())
	local thisselflag = 0
	if gBaseLogic.MBPluginManager.distributions.forceuseDirectSMS then
		if mbSimTyp~=nil and mbSimTyp>0 then			
			for k,v in pairs(mb.allIAPSmsType) do 
				local mid = tonumber(v.mid)
				if v.simTyp==-1 then
					thisselflag = 1;
					table.insert(self.payMidUse,{mid=mid,imgPrev="",payTyp="SMS"})
		            gBaseLogic.MBPluginManager.IAPSmsType = v.pluginName;
		            gBaseLogic.MBPluginManager.IAPSmsNeedConfirm = v.needConfirm
		            gBaseLogic.MBPluginManager.IAPSmsUseMid = mid;
		            gBaseLogic.MBPluginManager.distributions.quickpay = true;
					break;  
				end
			end
		end
	end
	if  thisselflag == 0 then
		if mbSimTyp~=nil and mbSimTyp>0 then
			for k,v in pairs(mb.allIAPSmsType) do 
				-- if mb:getSimStatue() and ((tonumber(mb:getSimType())>0 and tonumber(mb:getSimType())==v.simTyp) or v.simTyp==0 )  then
				v.simTyp = tonumber(v.simTyp)
				local mid = tonumber(v.mid)
				if (mbSimTyp==v.simTyp) or v.simTyp==0   then
					table.insert(self.payMidUse,{mid=mid,imgPrev="",payTyp="SMS"})
		            gBaseLogic.MBPluginManager.IAPSmsType = v.pluginName;
		            gBaseLogic.MBPluginManager.IAPSmsNeedConfirm = v.needConfirm
		            gBaseLogic.MBPluginManager.IAPSmsUseMid = mid;
		            gBaseLogic.MBPluginManager.distributions.quickpay = true;
					break;                            
		        end					
				
			end
		end
	end


	if gBaseLogic.MBPluginManager.distributions.checkapple then 
		for k,v in pairs(mb.allIApTyp) do 
			if v=="IAPAppStore" then
				table.insert(self.payMidUse,{mid=tonumber(k),imgPrev=v,payTyp="Normal"})
				gBaseLogic.MBPluginManager.IAPType = v
				break;
			end
		end

	else
		for k,v in pairs(mb.allIApTyp) do 
			table.insert(self.payMidUse,{mid=tonumber(k),imgPrev=v,payTyp="Normal"})
		end
	end
	var_dump({"gBaseLogic.MBPluginManager.IAPSmsType",gBaseLogic.MBPluginManager.IAPSmsType});
	var_dump(self.payMidUse)
	return self.payMidUse;
end

function BaseLogic:getPayMidList()
	if self.payMidUse==nil then
		return self:LoadpayList()
	end
	-- local mb = self.MBPluginManager;	
	-- self.payMidUse = nil;
	-- self.payMidUse = {};
	-- for k,v in pairs(mb.allIAPSmsType) do 
	-- 	if mb:getSimStatue() and tonumber(mb:getSimType())==v.simTyp then
	-- 		table.insert(self.payMidUse,{mid=tonumber(k),imgPrev="",payTyp="SMS"})
 --            self.IAPSmsType = v.pluginName;
	-- 		break;                            
 --        end
		
		
	-- end
	-- for k,v in pairs(mb.allIApTyp) do 
	-- 	table.insert(self.payMidUse,{mid=tonumber(k),imgPrev=v,payTyp="Normal"})
	-- end
	return self.payMidUse;
end

function BaseLogic:initPluginManager()
	echoInfo("BaseLogic:initPluginManager");
	self.MBPluginManager = require("izxFW.MBPluginManager").new();
	self.MBPluginManager:loadPluginsConfig();
	self:setPackage(self.MBPluginManager.packetName);
	self.deviceInfo = self.MBPluginManager:getDeviceInfo();
	echoInfo("self.deviceInfo");
	var_dump(self.deviceInfo);
end

function BaseLogic:run(updaterSuccOrFail)
	echoInfo('BEGIN!!!!!!BaseLogic:run');
	if (updaterSuccOrFail==nil) then
		self.updaterSuccOrFail = true;
	else
		self.updaterSuccOrFail = updaterSuccOrFail;
	end
	
	self:initPluginManager();
	
	-- gBaseLogic.lobbyLogic:requestHTTPHelpDesk()
	if (izx.resourceManager.netState == false) then
		self.lobbyLogic:onNoNet();
		return;
	end
	gBaseLogic.lobbyLogic:enterLocation({isFirstRun=true});
end



function BaseLogic:prepareRelogin()
	self.lobbyLogic:closeSocket();
    self.lobbyLogic:resetUserInfo();
    self.isInCancelLogin = false;
    self:blockUI({autoUnblock=false,msg=LOGIN_LOADING_TIPS1,hasCancel=true,callback=handler(self,self.onPressCancelLogin)});
end

function BaseLogic:onPressCancelLogin()
	echoInfo("BaseLogic:onPressCancelLogin");
	self:unblockUI();
	if (self.lobbyLogic.userHasLogined~=true) then
		self.isInCancelLogin = true;
	end
	self.lobbyLogic:closeSocket();
end

function BaseLogic:reqLogin()	
	echoInfo "START LOOBY SESSION"
	self:blockUI({autoUnblock=false,msg=LOGIN_LOADING_TIPS2,hasCancel=true,callback=handler(self,self.onPressCancelLogin)});
	if (self.lobbyLogic.lobbySocket) then
		self.lobbyLogic:reqLogin();
	else 

		self.lobbyLogic:startLobbySocket(self.socketConfig.lobbySocketConfig);
	end
end

function BaseLogic:setPackage(packageName)
	echoInfo("-----SET PACKAGE NAME:"..packageName.."-----");
	self.packageName = packageName;
	local packageInfo = split(packageName,'.');
	self.packagePlat = packageInfo[4] or "lua";
	self.packageVender = packageInfo[5] or "base";
end

function BaseLogic:setVersion(versionNum)
	self.versionNum = versionNum;
end

function BaseLogic:setSocketConfig(socketConfig)
	self.socketConfig = socketConfig;
end

function BaseLogic:setDefaultUser(userInfo,sessionType,writeToLocal)
	echoVerb("BaseLogic:setDefaultUser")
	local needSendRelogin = true;
	if (self.lobbyLogic.userData and (self.lobbyLogic.userData.ply_guid_ == userInfo.ply_guid_) and self.lobbyLogic.userHasLogined) then
		needSendRelogin = false;
		echoInfo("Same User!! Don't need resend login MSG");
	end

	self.lobbyLogic.userData = userInfo; 
	self.lobbyLogic.userHasLogined = false;
	if (writeToLocal) then
		CCUserDefault:sharedUserDefault():setStringForKey("ply_guid_", userInfo.ply_guid_)
	    CCUserDefault:sharedUserDefault():setStringForKey("ply_nickname_", userInfo.ply_nickname_)
	    CCUserDefault:sharedUserDefault():setStringForKey("ply_ticket_", userInfo.ply_ticket_)
	    --CCUserDefault:sharedUserDefault():setStringForKey("ply_Level_", userInfo.param_2_)
	    CCUserDefault:sharedUserDefault():setStringForKey("ply_face_", userInfo.ply_face)

	    CCUserDefault:sharedUserDefault():setBoolForKey("everLogin", true);
	    CCUserDefault:sharedUserDefault():setStringForKey("sessionType", sessionType);
	end
	return needSendRelogin;
end

function BaseLogic:setTestUser(userInfo)
	CCUserDefault:sharedUserDefault():setStringForKey("ply_guid_", userInfo.ply_guid_)
    CCUserDefault:sharedUserDefault():setStringForKey("ply_nickname_", userInfo.ply_nickname_)
    CCUserDefault:sharedUserDefault():setStringForKey("ply_ticket_", userInfo.ply_ticket_)
    --CCUserDefault:sharedUserDefault():setStringForKey("ply_Level_", userInfo.param_2_)
    CCUserDefault:sharedUserDefault():setBoolForKey("everLogin", true)
end

function BaseLogic:checkLogin()
	echoInfo("checkLogin!!");
	

	self.lobbyLogic.userHasLogined = false;
	local everLogin = CCUserDefault:sharedUserDefault():getBoolForKey("everLogin");
	-- echoInfois_login = false;
	echoInfo("BaseLogic:checkLogin")

	if everLogin == true then
	    local sessionType = CCUserDefault:sharedUserDefault():getStringForKey("sessionType");
	    echoInfo("will load:sessionType:"..sessionType);
	    
	    --write back the updater 
	    if (StartUpdater~=nil) then
	    	-- var_dump(StartUpdater);

	    	gBaseLogic.MBPluginManager:logEventDurationTable(StartUpdater);
	    	StartUpdater = nil;
	    end
	    gBaseLogic.MBPluginManager:logEventLabelMyBegin("LOGIN_STEP_DURA","sessionLogin");
	    
	    
	    if (self.MBPluginManager.allLoginTyp[sessionType]~=nil) then
		    self.MBPluginManager:sessionLogin(sessionType);
	    	return;
	    end
	end
	-- local canAutoReg = true;
	-- if (VenderAutoReg[self.packagePlat] and VenderAutoReg[self.packagePlat][self.packageVender]) then
	-- 	canAutoReg = false;
	-- end
	
	-- if (canAutoReg) then
		self:autoReg();
	-- end

end

function BaseLogic:autoReg()
	echoVerb("=============================BaseLogic:autoReg")
	local hasSessionGuest = 0;
	local defaultSession = "";
	for sessionName,sessionInfo in pairs(self.MBPluginManager.allLoginTyp) do
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
			self.MBPluginManager:sessionLogin(defaultSession); 
	    end, 0.01);
	else

		gBaseLogic:unblockUI();
		gBaseLogic.lobbyLogic:showLoginTypeLayer();
	end
	 

end

-- function BaseLogic:checkGameModules(gameModule)
-- 	self.upgradingGameModule = gameModule;
-- 	-- 检查版本
-- 	local url = string.gsub(URL.CHECK_PACAKGE_VERSION,"{moduleName}",gameModule);
-- 	echoInfo(url);

-- 	local upgradeManager = UpgradeManager:new(gameModule,url,RESOURCE_PATH);
--     upgradeManager:deleteVersion();
-- 	local needUpdate = upgradeManager:checkUpgrade();
-- 	echoInfo("needUpdate of "..gameModule.." is :"..needUpdate);
-- 	self.total_packages = 0;
-- 	if (needUpdate>0) then
-- 		self.total_packages = needUpdate;
        
--         -- 进入下载页面
        
--         upgradeManager:startDownload();
--         upgradeManager:registerScriptHandler(handler(self.lobbyLogic,self.lobbyLogic.onCheckGameModules));
--         self.lobbyLogic:dispatchLogicEvent({
-- 	        name = "MSG_PLUGIN_ASSET_START",
-- 	        message = {plugin=self.upgradingGameModule}
-- 	    })
-- 	elseif (needUpdate==0) then
-- 		-- 没下载也进下载页面
		
-- 	    function NO_NEW_VERSION()
-- 			self.lobbyLogic:dispatchLogicEvent({
-- 		        name = "MSG_PLUGIN_ASSET_SUCCESS",
-- 		        message = {plugin=self.upgradingGameModule,
-- 		    	typ="NO_NEW_VERSION"
-- 		    	}
-- 		    })
-- 		end
-- 	    self.scheduler.performWithDelayGlobal(NO_NEW_VERSION, 1)
-- 	else
-- 		-- 出错处理
		
-- 	end
	
-- end

function BaseLogic:checkGameUpdate(sessionInfo)
	if (true) then
		return false
	end
--  
--  {
--      nickname = 
--GT-N7100
--      reply = 
--0
--      first = 
--0
--      maxid = 
--213
--      ip = 
--s3.casino.hiigame.net
--      url = 
--http://www.baidu.com
--      face = 
--http://iface.b0.upaiyun.com/b2a6c527-dd96-476a-bc99-d8eca151d3fd.png!p300
--      tips = 
--登录成功!
--      ret = 
--0
--      vs = 
--2.1.9
--      port = 
--7200
--      ef = 
--0
--      sex = 
--0
--      plat = 
--11
--      vn = 
--11
--      pid = 
--1103134337925157
--      ticket = 
--8aa0371a0f406cabc48ef9a0d213d692
--  },
--  msg = 
--登录服务器成功
--  SessionResultCode = 
--0
--},
	local new_version = {};

	new_version.version_name = sessionInfo["vs"];
	new_version.version_code = tonumber(sessionInfo["vn"]);
	new_version.download_url = sessionInfo["url"];
	new_version.msg = sessionInfo["msg"];
	if new_version.version_name==nil or new_version.version_code ==nil then
		return false
	end

	local myVersion = self.MBPluginManager:getVersionInfo();
	var_dump(myVersion)
	if (new_version.version_code<=myVersion.version_code) then
		return false
	end

    if (tonumber(sessionInfo["ef"])==0) then
    	new_version.force_update = false;
    	if (new_version.msg==nil) then
    		new_version.msg = "发现新版本，是否升级？"
    	end
    	self.isForceUpgrade = false;
    else
    	new_version.force_update = true;
    	if (new_version.msg==nil) then
    		new_version.msg = "发现新版本，请升级!"
    	end
    	self.isForceUpgrade = true;
    end

	--local myVersion = self.MBPluginManager:getVersionInfo();
	var_dump(new_version);
	var_dump(myVersion);
	local closeWhenClick = true;
	if (new_version.version_code>myVersion.version_code) then
		local buttonCount = 2;
		if (new_version.force_update) then
			-- self:prepareRelogin();
			buttonCount = 1;
			closeWhenClick = false;
		end
		self:confirmBox({
			callbackConfirm = function()
				CCNative:openURL(new_version.download_url);	
			end,
			msg = new_version.msg,
			title = '版本升级通知',
			buttonCount = buttonCount,
			closeWhenClick = closeWhenClick
			})
	return true;

	end
	return false;
end

function BaseLogic:onSessionResult(sessionRst)
	

	echoInfo("BaseLogic:onSessionResult fired!");
	echoVerb("------------");
	var_dump(sessionRst);
	echoVerb("------------");
	
	var_dump(sessionRst);
	local needUpdate = self:checkGameUpdate(sessionRst.sessionInfo);
	if (sessionRst.SessionResultCode == 0) then
		gBaseLogic.MBPluginManager:logEventLabelMyEnd("LOGIN_STEP_DURA","sessionLogin");
		-- self:unblockUI();
		if (self.isInCancelLogin) then
			return;
		end;
		if (self.onLogining) then
			print("Bloody Tencent QQ Login!!!!!!!!!!!!, is in login now...........");
			return
		end
		self.onLogining = true;
		
		local userInfo = {
			ply_guid_ = sessionRst.sessionInfo.pid,
			ply_nickname_ = sessionRst.sessionInfo.nickname,
			ply_ticket_ = string.sub(sessionRst.sessionInfo.ticket,1,32),
			ply_sex = tonumber(sessionRst.sessionInfo.sex),
			ply_age = (sessionRst.sessionInfo.age ~= nil and tonumber(sessionRst.sessionInfo.age) or 18),
			ply_face = "",
			ply_Level = 0,
		};
		self.ply_guid_ = userInfo.ply_guid_;
		if (sessionRst.sessionInfo.face==nil) then
			local tempface = CCUserDefault:sharedUserDefault():getStringForKey(self.ply_guid_.."_faceUrl","")
			if tempface ~= "" then 
				self.lobbyLogic.face = tempface;
			else
				self.lobbyLogic.face = "http://img.cache.bdo.banding.com.cn/faces/default.png";
			end
		else
			self.lobbyLogic.face = sessionRst.sessionInfo.face;
		end
		userInfo.ply_face = self.lobbyLogic.face;
		--userInfo.ply_Level = 
		self:setDefaultUser(userInfo,self.MBPluginManager.sessionType,true);
		self:reqLogin();
		self.MBPluginManager.m_bPlatformLogined = true
		self.MBPluginManager:StartPushSDK();
		
		self.lobbyLogic:closeLoginTypeLayer()
	elseif (sessionRst.SessionResultCode == 3) then
		--switch user
		gBaseLogic.lobbyLogic.achieveListData = nil;
	    gBaseLogic.lobbyLogic.achieveListData = {};
		gBaseLogic.lobbyLogic:reShowLoginScene(false);
		gBaseLogic:prepareRelogin();
		self:unblockUI();
	elseif (sessionRst.SessionResultCode == 5) then
	elseif (sessionRst.SessionResultCode == 4) then
		self:unblockUI();
		-- self.lobbyLogic:showLoginTypeLayer()
	elseif (sessionRst.SessionResultCode == 7) then --kSessionUpdateSessionInfo
		-- local userInfo = {
		-- 	ply_guid_ = sessionRst.sessionInfo.pid,
		-- 	ply_nickname_ = sessionRst.sessionInfo.nickname,
		-- 	ply_ticket_ = string.sub(sessionRst.sessionInfo.ticket,1,32)
		-- };
		--self:setDefaultUser(userInfo,self.MBPluginManager.sessionType,true);
		echoInfo("------------测试改名")
		if gBaseLogic.lobbyLogic.userData.ply_lobby_data_ then 
			gBaseLogic.lobbyLogic.userData.ply_lobby_data_.nickname_ = sessionRst.sessionInfo.nickname
		end
		CCUserDefault:sharedUserDefault():setStringForKey("ply_nickname_", sessionRst.sessionInfo.nickname)
		gBaseLogic.lobbyLogic:dispatchLogicEvent({
                    name = "MSG_userName_rst_send",
                    message = sessionRst
                });
	else
		self:unblockUI();
		gBaseLogic.MBPluginManager:logEventLabelMyEnd("LOGIN_STEP_DURA","sessionLogin");
		if (self.isInCancelLogin) then
			return;
		end;
		self.lobbyLogic:showLoginTypeLayer();
		if (gBaseLogic.MBPluginManager.distributions['showloginfaildialog']) then
	        self.lobbyLogic:onNoNet(2,sessionRst.msg);
	    end
		
	end
end

function BaseLogic:onPayResult(payRst)
	self:unblockUI();
	gBaseLogic.MBPluginManager:logEventLabelDurationMyEnd("payDuration","res"..payRst.PayResultCode);
	self.inPayBox = 0;
	print("BaseLogic:onPayResult====")
	var_dump(payRst)
	self.lobbyLogic.isShow = false;
	-- gBaseLogic.lobbyLogic:
	self.lobbyLogic:dispatchLogicEvent({
        name = "MSG_change_chongzhi_btn",
        message = {code=payRst.PayResultCode,msg = payRst.msg}
    });
 --    if self.gameLogic~=nil then
	-- 	if self.gameLogic.moneyNotEnough == 1 then
	-- 		self.gameLogic:LeaveGameScene(-1)
	-- 	end
	-- end
	if (payRst.PayResultCode~=0) then
		self.MBPluginManager:createToolbar();	
		if 0~= gBaseLogic.is_robot then 
			-- if boxid == 1000 then 
			-- 	gBaseLogic.lobbyLogic:showYouXiTanChu({msg="支付失败,"..payRst.msg,type=1007}) 
			-- 	return
			-- end
			--gBaseLogic.lobbyLogic:showYouXiTanChu({msg="支付失败,"..payRst.msg,type=1007}) 
			return
		end 
		if (self.lobbyLogic.userHasLogined ~= true) then 
			return;
		end
		if (payRst.PayResultCode==2) then

		elseif (payRst.PayResultCode~=3 and payRst.PayResultCode~=5 and payRst.PayResultCode~=6 and payRst.PayResultCode~=7 ) then
			izxMessageBox(payRst.msg, "支付失败")		
		elseif (payRst.PayResultCode==6) then
			izxMessageBox(payRst.msg, "支付提示")
		elseif (payRst.PayResultCode==7) then
			local boxid = tonumber(payRst.payInfo.boxid);
			print("boxid:",boxid);
			local thisData = {}
			for k,v in pairs(self.lobbyLogic.paymentItemList) do
				if tonumber(v.boxid)==boxid then
					--print "v = "
					--var_dump(v)
					thisData = v
					break
				end
			end
			local initParam = {
	            msg=payRst.msg,
	        	buttonCount=1,
	            callbackConfirm = function()
	                gBaseLogic.lobbyLogic:pay(thisData,"Normal",3);
	                
	            end
				}
			self:confirmBox(initParam)
		end

		return;
	end

	gBaseLogic.MBPluginManager:logEvent("paySuccess");
	if self.gameLogic~=nil and self.currentState == gBaseLogic.stateInRealGame and self.gameLogic.diBaoMsg ~= "" then
		-- self.gameLogic.diBaoMsg = "";
		-- self.gameLogic.moneyNotEnough=0;
	end
	local puid = self.lobbyLogic.userData.ply_guid_
	if puid then
		CCUserDefault:sharedUserDefault():setStringForKey("payday"..puid,"0")
	    CCUserDefault:sharedUserDefault():setIntegerForKey("paydayNeedMoney"..puid,0)
	end

	
	local boxid = tonumber(payRst.payInfo.boxid);
	print("boxid:",boxid);
	
	local function getPayDesc(boxinfo)
		local items = self.lobbyLogic.userData.ply_items_
		local descStr = ""
		if items ~= nil then
			local tblItemName = {}
			for ki,vi in pairs(items) do
				tblItemName[vi.index_] = vi.name_
			end
			--print "tblItemName = "
			--var_dump(tblItemName)
			tblItemName[7] = "VIP"
			for ki,vi in pairs(boxinfo.content) do
				--print("ki = "..ki)
				--var_dump(vi)
				if tblItemName[vi.idx] ~= nil then
					--print("descStr1 = "..descStr)
					
					--print("descStr2 = "..descStr)
					if vi.idx == 0 then
						if self.isshuangbeipay==1 then
							descStr = descStr..(vi.num*2)
						else
							descStr = descStr..vi.num
						end
					elseif vi.idx == 5 or vi.idx == 7 then
						descStr = descStr..vi.num.."天"
					else
						if self.isshuangbeipay==1 then
							descStr = descStr..(vi.num*2).."个"
						else
							descStr = descStr..(vi.num).."个"
						end
					end
					--print("descStr3 = "..descStr)
					descStr = descStr..tblItemName[vi.idx].."，"
					--print("descStr4 = "..descStr)
				end
			end
			if descStr:len() > 0 then
				descStr = string.sub(descStr,1,descStr:len()-3)
				descStr = descStr.."。"
			end
			self.isshuangbeipay = 0
		end
		return descStr
	end
	-- boxid = 409
	local payItemName = "";
	local x = {};
	var_dump(payRst)
	if (MAIN_GAME_ID==10) then
		for k,v in pairs(self.lobbyLogic.paymentItemList) do
			if tonumber(v.boxid)==boxid then
				--print "v = "
				--var_dump(v)
				payItemName = getPayDesc(v)
				x = v
				break
			end
		end

		if payItemName=="" then
			for k,v in pairs(self.lobbyLogic.payVIPItemList) do
				print("payVIPItemList:",v.boxid)
				if tonumber(v.boxid)==boxid then
					payItemName = v.desc
					x=v
					break
				end
			end  
		end
		
	elseif (MAIN_GAME_ID==13) then
		for k,v in pairs(self.lobbyLogic.paymentItemList) do
			if tonumber(v.boxid)==boxid then
				--print "v = "
				--var_dump(v)
				payItemName = getPayDesc(v)
				x = v
				break
			end
		end
	end
	-- print("=================================self.lobbyLogic.payItemNormal")
	-- var_dump(self.lobbyLogic.payItemNormal);
	-- print("=================================self.lobbyLogic.payVIPItemList")
	-- var_dump(self.lobbyLogic.payVIPItemList)
	-- for i=1,#payInfo do
	-- 	local kv = split(payInfo[i],"=");

	-- 	if (#kv < 2) then
	-- 		break;
	-- 	end;
	-- 	if (#kv > 2) then
	-- 		for i=3,#kv do
	-- 			kv[2] = kv[2].."="..kv[i]
	-- 		end
	-- 	end;

	-- 	if (kv[1] == "body") then
	-- 		payItemName = kv[2];
	-- 	end
	-- 	if (kv[1] == "productName") then
	-- 		payItemName2 = kv[2];
	-- 	end
		
	-- end
	
	-- if (PLUGIN_ENV==0 or PLUGIN_ENV==1) then

	-- end
	-- if (payItemName=="") then
	-- 	payItemName = payItemName2
	-- end
	if self.gameLogic~=nil then
		self.gameLogic.dibaomoneyNotEnough=0
	end
	if 0~= gBaseLogic.is_robot then 
		
		print(payItemName)
		--"content":[{"num":1,"idx":7},{"num":10000,"idx":0}]

		for k,v in pairs(x.content) do
			if tonumber(v.idx)==0 then
				local robotMonery = CCUserDefault:sharedUserDefault():getIntegerForKey("p_money_4",0)
				if robotMonery < 0 then 
					robotMonery = 0
				end
				robotMonery = robotMonery + v.num 
				CCUserDefault:sharedUserDefault():setIntegerForKey("p_money_4",robotMonery)

				gBaseLogic.lobbyLogic:showYouXiTanChu({msg="支付成功,您购买了"..payItemName,type=1006}) 
				break 
			elseif tonumber(v.idx)==58 then
				local ply_guid_ = CCUserDefault:sharedUserDefault():getStringForKey("ply_guid_");
				local betterseat = CCUserDefault:sharedUserDefault():getIntegerForKey("better_seat"..ply_guid_,0)
				if betterseat < 0 then 
					betterseat = 0
				end 
				betterseat = betterseat + v.num
				CCUserDefault:sharedUserDefault():setIntegerForKey("better_seat"..ply_guid_,betterseat)

				gBaseLogic.lobbyLogic:showYouXiTanChu({msg="支付成功,您购买了"..payItemName,type=1008}) 
				break
			end 
		end	
	else 

		izxMessageBox("您购买了\n"..payItemName,"支付成功");
	end
-- 	{
-- [171.6390]     PayResultCode = 
-- [171.6393] 0
-- [171.6397]     msg = 
-- [171.6400] 支付成功
-- [171.6408]     payInfo = 
-- [171.6414]     
-- [171.6416]     {
-- [171.6418]         boxid = 
-- [171.6422] 270
-- [171.6425]         RSA_ALIPAY_PUBLIC = 
-- [171.6428] MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDdj8hFu/dP1fgz/xVOU+eqnwuInO2km8alkb0Y 6w1j8EDFKnEihewGCrLZR82ueXJ356UJwwadjEg/ZEaVsqN4G9/IkHvjDmJqBWD9T2uO4Gp8Yo/l EiH+Gkm1rsnWzotJ33IOZJvQ1IehK0hPrdvCoDbk1BWvL9fkspY4UeTdtwIDAQAB
-- [171.6435]         sign = 
-- [171.6439] Puz5ANXfI2CT3kWTUUr0ZuFxDV3bKnNmAD8oAFOqoOoQKfKkJ0iipFVUyLS34R6+8QvPvdV4VEKATVyQZkujrNXg0A/VqoEyXlHiTzqooZlJ7abqaAU7y6dn8KF0cjiPi9WaNhB7UQDK1gxwY+mglSFLDgYOWTF4tE5AcXRGdg4=
-- [171.6441]         result_tip2 = 
-- [171.6444] 
-- [171.6446]         ret = 
-- [171.6448] 0
-- [171.6451]         orderInfo = 
-- [171.6453] partner="2088901165876504"&seller="2088901165876504"&out_trade_no="201401061803849315"&subject="快速支付测试=￥2元"&body="内含2w游戏币"&total_fee="2.0"&notify_url="http://t.mall.hiigame.com/alipay/notify/default"
-- [171.6478]         result_tip1 = 
-- [171.6483] 支付成功
-- [171.6485]         order = 
-- [171.6488] 201401061803849315
-- [171.6490]     },
-- [171.6494] },


end

-- INIT_HEADFACE_SUCCESS 	  	 = 0;
-- INIT_HEADFACE_FAIL 	 		 = 1;
-- UPLOAD_HEADFACE_SUCCESS       = 2;
-- UPLOAD_HEADFACE_FAIL 	     = 3;
function BaseLogic:onHeadImageResult(headImageRst)
	print("onHeadImageResult")
	self.lobbyLogic:dispatchLogicEvent({
			        name = "MSG_headImage_rst_send",
			        message = headImageRst
			    });
end 

function BaseLogic:switchEnv(env)
	PLUGIN_ENV = env;
	CCUserDefault:sharedUserDefault():setIntegerForKey("LAST_PLUGIN_ENV", PLUGIN_ENV+10);
	URL = getURL();
	self:setSocketConfig(SOCKET_CONFIGS[PLUGIN_ENV]);
	self.MBPluginManager:loadPluginsConfig();
	self.MBPluginManager.pluginProxy:switchPluginXRunEnv(PLUGIN_ENV);
	self.lobbyLogic:enterLocation();
end

function BaseLogic:unblockUI()
	--echoError("who unblock me??");
	self.sceneManager:unblockUI();
end

function BaseLogic:waitingAni(target,tag)
	self:stopWaitingAni(tag);
	local contentSize = target:getContentSize();
	local ani = getAnimation("blockUI");
    local frame =  tolua.cast(ani:getFrames():objectAtIndex(0),"CCAnimationFrame"):getSpriteFrame()
    local m_playAni = CCSprite:createWithSpriteFrame(frame);
    local action = CCRepeatForever:create(CCAnimate:create(ani));

    m_playAni:setPosition(contentSize.width/2,contentSize.height/2 + 40);
    m_playAni:setColor(ccc3(166,166,166));
    target:addChild(m_playAni);
    m_playAni:runAction(action);
    if (self.waitingAnis==nil) then
    	self.waitingAnis = {}
    end
    self.waitingAnis[tag] = m_playAni;
end

function BaseLogic:stopWaitingAni(tag)
	if (self.waitingAnis and self.waitingAnis[tag]) then
		self.waitingAnis[tag] = tolua.cast(self.waitingAnis[tag], "CCNode");
		if (self.waitingAnis[tag]~=nil) then
			self.waitingAnis[tag]:stopAllActions();
			self.waitingAnis[tag]:removeFromParentAndCleanup(true);
		end
		self.waitingAnis[tag] = nil;
	end
end

function BaseLogic:blockUI(opt)
	self.sceneManager:blockUI(opt)
end 
--  smsQuickPayEnterGame = 1,	//	进入游戏时游戏币不足
-- 	smsQuickPayPlayingGame,		//	游戏中游戏币不足
-- 	smsQuickPayCharge,			//  游戏时玩家主动充值
-- 	smsQuickPayLowMoney,		//	游戏中低保
-- 	smsQuickPayExitGame,		//  游戏退出时提示充值

function BaseLogic:onNeedMoney(msgTyp,money, status)
	if (status~=3) then
		-- pay tip has no duration ,remove duration ,only record a event
		gBaseLogic.MBPluginManager:logEvent("showPayTip");
	end
	if self.lobbyLogic.userData==nil or self.lobbyLogic.userData.ply_lobby_data_==nil or self.lobbyLogic.userData.ply_lobby_data_.money_==nil then

		if gBaseLogic.is_robot == 0 then 
			local initParam={msg="请先登录！",type=1000};
			gBaseLogic.lobbyLogic:showYouXiTanChu(initParam);
		else
			local initParam={msg="请先登录！",type=1005};
			gBaseLogic.lobbyLogic:showYouXiTanChu(initParam);
    	end
		return
	end
	local diffMoney = money - self.lobbyLogic.userData.ply_lobby_data_.money_;
	
	self.lobbyLogic:quickPay(diffMoney,status);--smsQuickPayEnterGame = 1,	//	进入游戏时游戏币不足
end


function BaseLogic:showMessageRstBox(msg,maskType,zOrder)
    self.sceneManager.currentPage.view.popChildren = require("moduleLobby.views.MessageRstBox").new(msg,self.sceneManager.currentPage.view);
    self.sceneManager.currentPage.view:showPopBoxCCB("interfaces/MessageRstBox.ccbi",self.sceneManager.currentPage.view.popChildren,true,maskType,zOrder);
end
-- 掉钱动画
function BaseLogic:coin_drop(cback)
	local Px = display.cx;
	local Py = display.cy; 
	local positionAni = {{Px+105,Py+40},
	{Px-150,Py+90},{Px+55,Py+160},{Px+215,Py+185},
	{Px-165,Py+245},{Px-220,Py+270},{Px+135,Py+270},
	{Px-75,Py+310},{Px+220,Py+370},{Px+135,Py+390},
	{Px-135,Py+390},{Px-55,Py+455},{Px+65,Py+430}}
	
	local winSize = CCDirector:sharedDirector():getWinSize();
	local ani = getAnimation("ani_coin_drop");
	local frame =  tolua.cast(ani:getFrames():objectAtIndex(0),"CCAnimationFrame"):getSpriteFrame()
	
	local nodeAni = display.newNode();
	self.sceneManager.currentPage.scene:addChild(nodeAni)
	self.nodeAni = nodeAni
	local m_playAni_list = {}
	for k,v in pairs(positionAni) do
		local frame =  tolua.cast(ani:getFrames():objectAtIndex(k%6),"CCAnimationFrame"):getSpriteFrame()
		local m_playAni = CCSprite:createWithSpriteFrame(frame);
		
		self.nodeAni:addChild(m_playAni); 
		m_playAni:setTag(k);
		m_playAni:setPosition(v[1],v[2]);
		m_playAni:setVisible(true);	
		m_playAni:runAction(CCRepeatForever:create(CCAnimate:create(ani)));
		local pos = CCPointMake(v[1],-50);
		local action2 = CCMoveTo:create(1, pos);
		local FinishAni = function()
			print("FinishAni"..k)
			self.nodeAni:removeChildByTag(k)
			if k == #positionAni then
				print("FinishAni00"..k)
				self.nodeAni:removeAllChildrenWithCleanup(true);
				self.nodeAni = nil;
				if cback then
					cback();
				end
				
			end
		end
		local actionMoveDone = CCCallFuncN:create(FinishAni);
		m_playAni:runAction(transition.sequence({action2,CCDelayTime:create(0.2),actionMoveDone}))
	end
	scheduler.performWithDelayGlobal(function()
		izx.baseAudio:playSound("laba_drop");	
		end, 0.2)
	-- for i=1,20 do 
	-- 	self.audio:PlayAudio(40);
	-- end
	-- local actionMoveDone = CCCallFuncN:create(FinishAni);
	
	-- m_playAni:runAction(transition.sequence({CCAnimate:create(ani),CCDelayTime:create(10),actionMoveDone}));
end

function BaseLogic:confirmBox(initParam)
	print("confirmBox")
	var_dump(initParam)
	local popBoxExit = {};
	function popBoxExit:onPressCancel()
		if (initParam.closeWhenClick~=false) then
			gBaseLogic.sceneManager.currentPage.view:realClosePopBox();
		end
		if (initParam.callbackCancel~=nil) then
			initParam.callbackCancel();
		end
		
	end
	function popBoxExit:onPressConfirm()
		if (initParam.closeWhenClick~=false) then
			gBaseLogic.sceneManager.currentPage.view:realClosePopBox();
		end
		if (initParam.callbackConfirm~=nil) then
			initParam.callbackConfirm();
		end
		
	end
	function popBoxExit:onTouches(event,x,y)
		
	end
	function popBoxExit:onAssignVars()
		self.labelTips = tolua.cast(self["labelTips"],"CCLabelTTF");
		if (MAIN_GAME_ID==13) then
			self.labelTipsBg = tolua.cast(self["labelTipsBg"],"CCLabelTTF");
			local gameInfo = CCUserDefault:sharedUserDefault():getStringForKey("currGameInfo");
			if(gameInfo ~= "0")then
				self.labelTips:setString(gameInfo)
				self.labelTipsBg:setString(gameInfo)
			end
		end
		if nil ~= self["labelTitile"] then
	        self.labelTitle = tolua.cast(self["labelTitle"],"CCLabelTTF")
		end
		if nil ~= self["btnConfirm"] then
			self.btnConfirm = tolua.cast(self["btnConfirm"],"CCControlButton")
			-- self.btnConfirm:addTouchEventListener(function(event,x,y)
			-- 	print("btnConfirm====event:"..event);
			-- 	return true;
			-- end,false,-1,false);
			if initParam.btnTitle~=nil then
				if initParam.btnTitle.btnConfirm~=nil then
					local tempString = CCString:create(initParam.btnTitle.btnConfirm.."");
		            self.btnConfirm:setTitleForState(tempString,CCControlStateNormal);
				end
			end
	    end
		if nil ~= self["BtnCancel"] then
			self.BtnCancel = tolua.cast(self["BtnCancel"],"CCControlButton");
			-- self.BtnCancel:addTouchEventListener(function(event,x,y)
			-- 	print("btnConfirm====event:"..event);
			-- 	return true;
			-- end,false,-1,false);
			if initParam.btnTitle~=nil then
				if initParam.btnTitle.btnCancel~=nil then
					local tempString = CCString:create(initParam.btnTitle.btnCancel.."");
		            self.BtnCancel:setTitleForState(tempString,CCControlStateNormal);
				end
			end
	    end
	    if (initParam.msg~=nil) then
	    	self.labelTips:setString(initParam.msg);
	    end
		if (initParam.title~=nil) then
	    	self.labelTitle:setString(initParam.title);
	    end
	    if (initParam.buttonCount~=nil and initParam.buttonCount==1) then
	    	self.BtnCancel:setVisible(false);
	    	local parent = self.btnConfirm:getParent();
	    	local contentSize = parent:getContentSize();

	    	self.btnConfirm:setPositionX(contentSize.width / 2);
	    	self.btnConfirm:setAnchorPoint(ccp(0.5,0.5));
	    end
	    
	    
	end
	local clickMaskToClose = false
	if initParam.clickMaskToClose ~= nil then 
		clickMaskToClose = initParam.clickMaskToClose
	end
	self.sceneManager.currentPage.view:showPopBoxCCB("interfaces/TanChu.ccbi",popBoxExit,clickMaskToClose);
	
	print("interfaces/TanChu.ccbi")

end

-- ChangeLog
-- 退出提示优化，斗地主305版本引入，注意有新CCB务必引入
-- TuiChu。ccbi
function BaseLogic:gameExit()
	local popBoxExit = {};
	function popBoxExit:onPressCancel()
		
		gBaseLogic.sceneManager.currentPage.view:closePopBox();
		
	end
	function popBoxExit:onPressConfirm()
		
		gBaseLogic.sceneManager.currentPage.view:closePopBox();
		echoInfo("will exit game!!!");
			

		CCDirector:sharedDirector():endToLua();
		echoInfo("are you kidding me?");
		
	end
	function popBoxExit:onTouches(event,x,y)
		
	end
	function popBoxExit:onAssignVars()
		if nil ~= self["libao"] then
	        self.libao = tolua.cast(self["libao"],"CCSprite")
	        self.libao:setTouchEnabled(true)
		    self.libao:addTouchEventListener(function(event, x, y, prevX, prevY)
		       
			    if event == "began" then
			    	gBaseLogic.sceneManager.currentPage.view:closePopBox();		        
			    	if (gBaseLogic.lobbyLogic.userHasLogined==false) then
			    		izxMessageBox("暂未登录!", "提示");
			    		return true;
			    	end
			    	
				     gBaseLogic.lobbyLogic:showFreeCoinLayer()
				    
			        print("self.libao:addTouchEventListener")
			    end
			    return true;
		    end)
		end
		if (gBaseLogic.MBPluginManager.distributions.nominigame==true) then
			if nil ~= self["nodeMinigame"] then
				self.nodeMinigame:setVisible(false);
				self.nodePay:setPositionX(0);
			end
		else
			if nil ~= self["laba"] then
				self.laba = tolua.cast(self["laba"],"CCSprite")
				self.laba:setTouchEnabled(true)
			    self.laba:addTouchEventListener(function(event, x, y, prevX, prevY)
			       
				    if event == "began" then			        
				    	print("laba:gotogaojiChang12121")
				    	if (gBaseLogic.lobbyLogic.userHasLogined==false) then
				    		izxMessageBox("暂未登录!", "提示");
				    		return true;
				    	end
						local miniGameInfo = izx.miniGameManager:getMiniGame(101);
						gBaseLogic.sceneManager.currentPage.view:closePopBox();
						if (miniGameInfo==nil) then
							izxMessageBox( "暂未开放","提示");
							return true;
						end					
						gBaseLogic.lobbyLogic:startMiniGame(101)
				    end
				    return true;
			    end)
		    end 
		end
	end
	
	self.sceneManager.currentPage.view:showPopBoxCCB("interfaces/TuiChu.ccbi",popBoxExit,false);

end

function BaseLogic:confirmExit(notback)
	if self.isForceUpgrade then
		return
	end
	if self.inGamelist ~= -1 and notback == nil then
		if gBaseLogic.sceneManager.currentPage.pageName=="LobbyScene" then
			gBaseLogic.sceneManager.currentPage.view:onPressGameBack();
			return;
		end
	end

	var_dump(self.MBPluginManager.distributions);
	
	if (self.MBPluginManager.distributions.thirdplatformexitpage) then
		self.MBPluginManager:confirmExit();
		return;
	end
	self:gameExit()
	-- self:confirmBox({
	-- 	callbackConfirm = function()
	-- 		echoInfo("will exit game!!!");
			

	-- 		CCDirector:sharedDirector():endToLua();
	-- 		echoInfo("are you kidding me?");
	-- 	end})
end
 
-- type:0 单机赖子
function BaseLogic:showLaiZiTips(type,k,target)

    local LaiziTip = CCUserDefault:sharedUserDefault():getBoolForKey("laizitip")
    if true == LaiziTip then 
    	if type == 0 then 
        	gBaseLogic.sceneManager.currentPage.ctrller:initRobotInfo(1)
        else 
        	target:startGameByTypLevel2(type,k)
        end
        return
    end

    local popBoxLaiZiTips = {};
   
    function popBoxLaiZiTips:onPressNoTipAgain()
        print("onPressNoTipAgain") 
        if self.spriteNoTipAgain:isVisible() then 
            self.spriteNoTipAgain:setVisible(false) 
        else 
            self.spriteNoTipAgain:setVisible(true) 
        end
    end
    function popBoxLaiZiTips:onPressBack()
        print("onPressBack") 
        CCUserDefault:sharedUserDefault():setBoolForKey("laizitip",self.spriteNoTipAgain:isVisible())
        gBaseLogic.sceneManager.currentPage.view:closePopBox();
        if type == 0 then
            gBaseLogic.sceneManager.currentPage.view.logic:showWanFa()
        end
    end
    function popBoxLaiZiTips:onPressConfirm()
        print("onPressConfirm")        
        CCUserDefault:sharedUserDefault():setBoolForKey("laizitip",self.spriteNoTipAgain:isVisible())
        gBaseLogic.sceneManager.currentPage.view:closePopBox();
        if type == 0 then
        	gBaseLogic.sceneManager.currentPage.ctrller:initRobotInfo(1)
        else 
        	target:startGameByTypLevel2(type,k)
        end
    end

    function popBoxLaiZiTips:onAssignVars()
        self.spriteNoTipAgain = tolua.cast(self["spriteNoTipAgain"],"CCSprite");     
    end
    
    gBaseLogic.sceneManager.currentPage.view:showPopBoxCCB("interfaces/LaiZiTiShi.ccbi",popBoxLaiZiTips,false);
    gBaseLogic.sceneManager.currentPage.view.nodePopBox:setPosition(display.cx,display.cy);

end

--显示可变大小的提示框 target:父对象，type：提示框类型，msg：提示的信息 x,y：位置 size：区域大小
function BaseLogic:showTips(target,type,msgt,title,tx,ty,size)
	if (MAIN_GAME_ID==10) then
		self:showTips_ddz(target,type,msgt,title,tx,ty,size)
	elseif (MAIN_GAME_ID==13) then
		self:showTips_ermj(target,type,msgt,title,tx,ty,size)
	else
		--其他游戏
		self:showTips_ddz(target,type,msgt,title,tx,ty,size)
	end
end

function BaseLogic:showTips_ddz(target,type,msgt,title,tx,ty,size)	
	local node = display.newScale9Sprite("images/bg.png", display.cx,display.cy, CCSizeMake(display.width, display.height));
    target.rootNode:addChild(node)
    target.nodeTips = node

    local hasmovex = 0
    local hasmovey = 0
    function clickMask(event, x, y)
        if (event=="began") then
        	hasmovex = x
           	hasmovey = y
            return true;
        end
        if (event=="ended") then
            if math.abs(y - hasmovey) + math.abs(x - hasmovex) > 30 then 
               return true;
            end
            echoInfo(event..":MASK!");
	        target.nodeTips:unregisterScriptHandler();
	        target.nodeTips:removeFromParentAndCleanup(true);
	        target.nodeTips = nil;	        
        end
        return true;
    end
    node:setTouchEnabled(true);
    node:addTouchEventListener(clickMask);
    --蒙版层
    -- local maskLayerColor = display.newScale9Sprite("images/bg.png", display.cx,display.cy, CCSizeMake(display.width, display.height));
    -- node:addChild(maskLayerColor)

    if nil == size then 
    	size = CCSizeMake(600, 400)
    end 
    --背景层
    local nodeTipsBg = CCScale9Sprite:create("images/TanChu/popup_bg_qianhong.png")
    nodeTipsBg:setAnchorPoint(ccp(.5,.5))
    nodeTipsBg:setPreferredSize(size)
    nodeTipsBg:setPosition(ccp(display.cx, display.cy))
    node:addChild(nodeTipsBg) 
    --标题层
    local th = 36
    local nodeTipstitle = CCLabelTTF:create(title, "Helvetica", 30)
    nodeTipstitle:setAnchorPoint(ccp(.5,1))
    nodeTipstitle:setPosition(ccp(size.width/2,size.height-5))
    nodeTipstitle:setColor(ccc3(218,128,128))
    nodeTipsBg:addChild(nodeTipstitle)
    size.height = size.height-th
    size.width = size.width - 10
    --内容层，type：1滚动，0普通
    if type == 1 then
    	local tabViewLayer = display.newLayer()
    	--tabViewLayer:setPreferredSize(size)
    	tabViewLayer:setPosition(ccp(5,5))
    	nodeTipsBg:addChild(tabViewLayer) 
	    function tabViewLayer.cellSizeForTable(table,idx)
	    	return 32, size.width
	    end
	    function tabViewLayer.numberOfCellsInTableView(table)
	    	return #table:getParent().data
	    end
	    function tabViewLayer.tableCellAtIndex(table, idx)
	    	local cell = table:dequeueCell()
		    if nil == cell then        
		        cell = CCTableViewCell:new()
		    else
		        cell:removeAllChildrenWithCleanup(true);
		    end 
	    	local nodeTipsmsg = CCLabelTTF:create(table:getParent().data[idx+1], "Helvetica", 28.0)
		    nodeTipsmsg:setAnchorPoint(ccp(0,1))
		    nodeTipsmsg:setPosition(ccp(0,0))
		    nodeTipsmsg:setColor(ccc3(219,128,128))
		    cell:addChild(nodeTipsmsg)
		    return cell
	    end

	    createTabView(tabViewLayer,size,type,msgt,tabViewLayer);
	else
	    local nodeTipsmsg = CCLabelTTF:create(msg, "Helvetica", 28, size, ui.TEXT_ALIGN_LEFT, ui.TEXT_VALIGN_TOP)
	    nodeTipsmsg:setAnchorPoint(ccp(0,1))
	    nodeTipsmsg:setPreferredSize(size)
	    nodeTipsmsg:setPosition(ccp(5,size.height-th))
	    nodeTipsmsg:setColor(ccc3(219,128,128))
	    nodeTipsBg:addChild(nodeTipsmsg)
	end
end

function BaseLogic:showTips_ermj(target,typ,msg,x,y,size)
    target.maskLayerColor = display.newScale9Sprite("images/bg.png", display.cx,display.cy, CCSizeMake(display.width, display.height));
    target.maskLayerColor:setTouchEnabled(true);
    function clickMask(event, x, y, prevX, prevY)
        if (event=="began") then
            return true;
        end
        echoInfo(event..":MASK!");
        target.maskLayerColor:unregisterScriptHandler();
        target.maskLayerColor:removeFromParentAndCleanup(true);
        target.maskLayerColor = nil;
        target.nodeTipsBg:removeFromParentAndCleanup(true);
        target.nodeTipsBg = nil
        target.nodeTipsmsg:removeFromParentAndCleanup(true);
        target.nodeTipsmsg = nil
        return true;
    end
    
    target.maskLayerColor:setTouchEnabled(true);
    target.maskLayerColor:addTouchEventListener(clickMask);
    target:addChild(target.maskLayerColor)

    local size = CCSizeMake(400, 120)
    target.nodeTipsBg = CCScale9Sprite:create("images/TongYong/list_btn_lan1.png")
    target.nodeTipsBg:setAnchorPoint(ccp(.5,.5))
    target.nodeTipsBg:setPreferredSize(size)
    target.nodeTipsBg:setPosition(ccp(display.cx, display.cy))
    target:addChild(target.nodeTipsBg)

    target.nodeTipsmsg = CCLabelTTF:create(msg, "Helvetica", 28.0, size, ui.TEXT_ALIGN_LEFT, ui.TEXT_VALIGN_TOP)
    target.nodeTipsmsg:setAnchorPoint(ccp(0,1))
    target.nodeTipsmsg:setPosition(ccp(display.cx-size.width/2+5,display.cy+size.height/2-5))
    
    target:addChild(target.nodeTipsmsg)
end

function BaseLogic:showVersion(target)
	local runEnv = "正式环境"
    if (PLUGIN_ENV==ENV_TEST) then
        runEnv = "测试环境"
    elseif (PLUGIN_ENV== ENV_MIRROR ) then
        runEnv = "镜像环境"
    end
    --标题
   	local title = "游戏版本信息" 	
    --1.基本信息
	local msg1 = string.format("[INFO] # %s%s on %s ;\n[INFO] # DV:%s; PV:%d; FWV:%d;\n",gBaseLogic.packageName,SHOW_VERSION,runEnv, VERSION,CASINO_VERSION_DEFAULT,gBaseLogic.MBPluginManager.frameworkVersion);
	--2.插件信息
	local msg2 = ""
	for key, plugin_config in pairs(gBaseLogic.MBPluginManager.pluginConfigs) do  

	    plugin_SDKVersion = gBaseLogic.MBPluginManager.pluginProxy:getSDKVersion(key,plugin_config.type);
	    plugin_Version = gBaseLogic.MBPluginManager.pluginProxy:getPluginVersion(key,plugin_config.type);
	    msg2 = string.format("[INFO] # %s on SDK %s-%s \n",key,plugin_SDKVersion,plugin_Version);

	    msg1 = msg1..msg2
	end 
	--3.主版本信息
	local msg3 = ""
	-- for pkg_name,pkg_version in pairs(PRE_INSTALLED_VERSION) do
	-- 	msg3 = string.format("[INFO] # gameID:%d on %s:%s\n",MAIN_GAME_ID,pkg_name, pkg_version);
	-- msg1 = msg1..msg3
	-- end
	--4.小游戏信息
	local msg4 = ""
	for k,v in pairs(izx.miniGameManager.miniGameCfg) do
       	msg4 = string.format("[INFO] # gameID:%d on %s:%s\n",k,v.gameName, v.version);
       	msg1 = msg1..msg4
    end

	local msgt = split(msg1,'\n')
	self:showTips(target,1,msgt,title,x,y,CCSizeMake(display.width, display.height))
    	
end

function BaseLogic:showTopTips(tips)
	if (self.topTips) then
		self.topTips:stopAllActions();
		self.topTips.removeFromParentAndCleanup(true);
		self.topTips = nil;
	end
	self.topTips = display.newNode();
	self.topTips:setPosition(display.cx, display.height+20);
	local bg = display.newSprite("images/DaTing/lobby_bg_gonggao.png");

	local label = CCLabelTTF:create(tips, "", 28);
	label:setColor(ccc3(254,254,254));

	
	self.topTips:addChild(bg);
	self.topTips:addChild(label);
	self.sceneManager.currentPage.scene:addChild(self.topTips);

	function releaseMe() 
		if (self.topTips) then
			self.topTips:removeFromParentAndCleanup(true);
			self.topTips = nil;
		end
	end

	actions = {};
    actions[#actions + 1] = CCEaseExponentialOut:create(CCMoveTo:create(0.5, ccp(display.cx,display.height-20)));
    actions[#actions + 1] = CCDelayTime:create(5.0);
    actions[#actions + 1] = CCEaseExponentialOut:create(CCMoveTo:create(0.5, ccp(display.cx,display.height+20)));
    actions[#actions + 1] = CCCallFunc:create(releaseMe);

    self.topTips:runAction(transition.sequence(actions));

end
function BaseLogic:alertbox(msg,flag)
	local initParam = {msg=msg,buttonCount=1,flag=flag};
	
	self:confirmBox(initParam)
end

return BaseLogic;
