--
-- Author: Guo Jia
-- Date: 2014-02-28 13:38:52
--
function __G__TRACKBACK__(errorMessage)
    print("----------------------------------------")
    print("LUA ERROR: " .. tostring(errorMessage) .. "\n")
    print(debug.traceback("", 2))
    print("----------------------------------------")
end

require("config");
require("version_control")
require("framework.init")
require("framework.shortcodes")
require("izxFW.BaseFunctions");


if device.platform=="windows" then
    require("gap");
end
izx = izx or {};

scheduler = require(cc.PACKAGE_NAME .. ".scheduler");
StartUpdater = {LOGIN_STEP_DURA={},DOWNLOADING={}};
ONLINE_PARAM = nil;
izx.resourceManager = require("izxFW.ResourceManager").new();
izx.baseView = require "izxFW.BaseView";
izx.basePage = require "izxFW.BasePage";
izx.baseCtrller = require "izxFW.BaseCtrller";
gBaseLogic  = require("izxFW.BaseLogic").new();

local Updater = class("Updater")
local packageNames = {interfaces="主界面",interfacesGame="游戏界面",sounds="音效",soundsGame="游戏音效",images="美术资源",imagesGame="游戏美术资源",script="游戏逻辑"};
local msg = {[10]="网络不太给力，建议您选择单机游戏或者重试。",
	[13]="游戏初始化失败，请检查网络"};

function Updater:ctor()
	self.updateManager = require("izxFW.UpdateManager").new();
	self.updateManager.listener = self;

	gBaseLogic:initPluginManager();
    self.proxy = gBaseLogic.MBPluginManager.pluginProxy;
    
    self.startTimer1 = self.proxy:getMilliseconds();
    self.fwVersion = self.proxy:getFrameworkVersion();
    echoInfo("INIT UPDATER! My framework version is %d", self.fwVersion);
    self.state = "init";
    self.startTimers  = {};
    self.endTimers = {};
	

    gBaseLogic.MBPluginManager:loadPluginsConfig();
    echoInfo("MBManager.loadPluginsConfig success in updater");
    gBaseLogic.MBPluginManager:loadPlatformPlugins();
    echoInfo("MBManager.loadPlatformPlugins success in updater");
	gBaseLogic.MBPluginManager:loadAnalysePlugins();
	echoInfo("MBManager.loadAnalysePlugins success in updater");

	self.packageName = gBaseLogic.MBPluginManager.packetName;

	local testUpgrade = CCUserDefault:sharedUserDefault():getIntegerForKey("testUpgradeNew");	
	echoInfo("sharedUserDefault testUpgradeNew is :");
	var_dump(testUpgrade);

	if (testUpgrade~=nil and testUpgrade>0) then
		PLUGIN_ENV = testUpgrade-1;
	end	
	
	if (gBaseLogic.MBPluginManager.distributions.usetestenv) then
		PLUGIN_ENV = ENV_TEST;
		CCUserDefault:sharedUserDefault():setIntegerForKey("LAST_PLUGIN_ENV", PLUGIN_ENV+10);
	end

	if (gBaseLogic.MBPluginManager.distributions.skipupgrade) then
		SKIP_UPGRADE = true;
	end
	URL = getURL();
	local configNames = {[ENV_OFFICIAL]= "ENV_OFFICIAL",
		[ENV_TEST] = "ENV_TEST",
		[ENV_MIRROR] = "ENV_MIRROR"};

	echoInfo("PLUGIN_ENV is %d as %s", PLUGIN_ENV,configNames[PLUGIN_ENV]);
	
	self.updateManager:init({packageName=self.packageName,versionInfo=gBaseLogic.MBPluginManager:getVersionInfo(),fwVersion = self.fwVersion});
end

function Updater:onNextState(state)
	self.state = state;
	self:onStateChange(state);
end

function Updater:onAnalyseTimerBegin(tag,label)
	if (self.startTimers[tag]==nil) then
		self.startTimers[tag]={};
	end
	self.startTimers[tag][label]= self.proxy:getMilliseconds();
end

function Updater:onAnalyseTimerEnd(tag,label)
	if (self.endTimers[tag]==nil) then
		self.endTimers[tag]={};
	end
	if (self.startTimers[tag]==nil) then
		self.startTimers[tag]={};
	end
	if (self.startTimers[tag][label]==nil) then
		self.startTimers[tag][label] = self.proxy:getMilliseconds();
	end
	self.endTimers[tag][label]= self.proxy:getMilliseconds();
	StartUpdater[tag][label] = self.endTimers[tag][label] - self.startTimers[tag][label];
end

function Updater:onCheckMainVer(result)
    if (result==-1) then
        gBaseLogic.MBPluginManager:loadSessionPlugins();
        self:getMainGameListHTTPConfig();
    elseif (result==-2) then
        self:setTips("游戏版本信息获取失败");
            
        self:onUpdateFail();
    elseif (result==1) then


    end
end

function Updater:setTips(msg)
	if (self.loadingScene) then
		self.loadingScene.view:setTips(msg);
	end
end

function Updater:run()
	
	self.onDealFail = false;
	CCTextureCache:sharedTextureCache():removeAllTextures();
	if (SKIP_UPGRADE) then
		self.updateManager:runMain("pre");
	else
		if gBaseLogic.MBPluginManager.distributions.mopudonghua~=nil and gBaseLogic.MBPluginManager.distributions.mopudonghua==true then 
			self:thirdDonghua()
		else
			self:showLoadingPage();			
		end
	end
end

function Updater:onUpdateFail()
	self.state = "fail";

	print("Updater:onUpdateFail");

	if (self.onDealFail) then
		return;
	end

	self.onDealFail = true;
	local buttonCount = 1;

	if (MAIN_GAME_ID==10) then
		buttonCount = 2;
	end

	gBaseLogic:confirmBox({
				btnTitle = {
					btnCancel="进入单机",
					btnConfirm="重试"
				},
				callbackConfirm = function()
					self.onDealFail = false;
					scheduler.performWithDelayGlobal(function() self.updateManager:runSameState(); end, 0.1)
				end,
				callbackCancel = function()
					self.onDealFail = false;
					echoInfo("UpdaterSceneCode:onPressbtnSingle");
					if (self.updateManager.mainGameCfg.code==nil or self.updateManager.mainGameCfg.code=="") then
						self.updateManager:runMain("pre",false);
					else
						if (io.exists(self.updateManager.mainGameCfg.code)) then
							self.updateManager:runMain("download",false);
						else
							self.updateManager:runMain("pre",false);
						end
					end
				end,
				msg = msg[MAIN_GAME_ID],
				title = "连接失败",
				buttonCount = buttonCount,
				closeWhenClick = true
		});
end

function Updater:onCheckFail(params)
-- {canContinue=false,failState=self.state,failReason="totalUpdateHTTP"}
	self:onUpdateFail();
end

function Updater:onStateChange(state)
	local configString = {
		init="正在载入资源",
		CheckTotal="游戏初始化",
		CheckSDK="插件初始化",
		CheckLua="载入游戏",
		SilenceDownload="正在载入游戏资源",
		Finish ="正在进入游戏"};
	if (configString[state]) then
		self:setTips(configString[state]);
	else
		self:setTips("正在载入资源");
	end

end

function Updater:onCheckUIState(params)
	echoInfo("onCheckUIState:%s",params.state);
	var_dump(params);
	self.updateInfo = params.info;
	
	-- {canContinue=canContinue,state=self.state,info=new_version}
	if (params.state == "CheckTotal") then
		self:setTips(self.updateInfo.msg);
		local buttonCount = 2;
		local cancelText = "关闭游戏";
		if (params.info.force_update==false) then
			cancelText = "暂不升级";
		else
			if (device.platform=="ios") then
				buttonCount = 1;
			end
		end

		
		gBaseLogic:confirmBox({
				btnTitle = {
					btnCancel=cancelText,
					btnConfirm="现在更新"
				},
				callbackConfirm = function()
					echoInfo("confirm click");
					if (device.platform=="ios") then
						CCNative:openURL(self.updateInfo.download_url);
					elseif (device.platform=="android") then
						local fileCacheName = (crypto.md5(self.updateInfo.download_url))..".apk";
						local param = json.encode(params);
						function onJSCallback(event) 
							echoInfo("showUpgradeDialog onJSCallback");
							local callbackEvent = json.decode(event);
							if (callbackEvent.event=="cancelDownload") then
								scheduler.performWithDelayGlobal(function() self.updateManager:runSameState(); end, 0.1)
							end
						end
						-- final String url,final String title,final String msg,final String name,final int luaCallbackFunction
					    -- call Java method
					    local javaClassName = "com.izhangxin.utils.luaj"
					    local javaMethodName = "showUpgradeDialog"
					    local javaParams = {
					                self.updateInfo.download_url,
					                "下载中",
					                "正在更新游戏资源",
					                fileCacheName,
					                function(event)
					                    onJSCallback(event);                 
					                end
					    }
					    local javaMethodSig = "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;I)V";
					    luaj.callStaticMethod(javaClassName, javaMethodName, javaParams, javaMethodSig);
					end
				end,
				callbackCancel = function()
					if (params.info.force_update==false) then
						scheduler.performWithDelayGlobal(function() self.updateManager:runNextState(); end, 0.1)
					else
						self:exit()
					end
				end,
				msg = self.updateInfo.msg,
				title = "发现新版本",
				buttonCount = buttonCount,
				closeWhenClick = true
		});
	elseif (params.state == "CheckLua") then
		
		-- local btn_list = {"btnUpdateLua"};
		-- local plusStr = "";
		-- if (params.force_update==false) then
		-- 	if (params.allDownloadSize=="0") then
		-- 		plusStr = "推荐您进行更新";
		-- 	else
		-- 		plusStr = "推荐您进行更新,文件大小"..params.allDownloadSize;
		-- 	end
		-- 	btn_list = {"btnUpdateLua","btnUpdateCancelLua"};
		-- else
		-- 	plusStr = "文件大小"..params.allDownloadSize;
		-- 	btn_list = {"btnUpdateLua","btnClose"};

		-- end
		-- self.tipsNow = string.format("游戏有新版本,%s,是否更新?",plusStr);
		-- self:showRetryCancel(btn_list);
	end
end


function Updater:showLoadingPage()
	-- Guojia 308 loading页面要求越来越多,直接用框架
	self.loadingScene = izx.basePage.new(self,"UpdaterSceneCode","moduleLobby",{
			pageType = izx.basePage.PAGE_TYP_CODE,
			isCodeScene = true,
			initParam = {},
			slideIn = "no"
		}
	);
	self.loadingScene:enterScene(false);
	
end


function Updater:thirdDonghua()
	
	local sharedDirector = CCDirector:sharedDirector();
	local scene = display.newScene("thirdDonghuaScene");
	local rootNode = display.newLayer();
	scene:addChild(rootNode);
	rootNode = tolua.cast(rootNode,"CCLayer");
	rootNode:addKeypadEventListener(function(event)
        if event == "back" then self:exit() end
    end)
    local bgSprite = display.newColorLayer(ccc4(255,255,255,255))
    --local bgSprite = display.newSprite("images/DengLu/login_bg.jpg",display.cx, display.cy)
    -- local bgSprite = display.newScale9Sprite("images/DengLu/login_bg.jpg", display.cx,display.cy, CCSizeMake(display.width, display.height))
    bgSprite:setContentSize(CCSizeMake(display.width, display.height))
  
    scene:addChild(bgSprite);
   
	if sharedDirector:getRunningScene() then
        sharedDirector:replaceScene(scene)
    else
        sharedDirector:runWithScene(scene);
    end
     local YzAnimTool = require("thirdparty.mopu.YzAnimTool").new();
	YzAnimTool:PlayStartSplash(scene,function()
		 self:showLoadingPage()
		 self.updateManager:run();
		end);
end

function Updater:showLoadingPercent(done,need)
	self.loadingScene.view:showLoadingPercent(done, need);
end

function Updater:addChild(ele)
	self.page.rootNode:addChild(ele);
end

function Updater:exit()
	echoInfo("will exit game!!!");
	CCDirector:sharedDirector():endToLua();
	echoInfo("are you kidding me?");
end

function Updater:dispatchCachedEvent()


end

updaterSuccOrFail = false;
updater = Updater.new();
updater:run();