--
-- Author: Guo Jia
-- Date: 2014-06-10 11:21:12
--
local UpdateManager = class("UpdateManager")

function UpdateManager:ctor() 
    self.updateCfg = {}
    self.downloadTag = "mainGameDownload";
	self.state = "init";
	self:preparePath();
    self:initPreInstall();
    self.allDownloadSize = 0;
    self.updateInfo = {};
    self.onlineparam = {};
    self.gameStarted = false;
end

function UpdateManager:init(params)
	self.packageName = params.packageName;
	self.versionInfo = params.versionInfo;
	self.fwVersion = params.fwVersion;
	self.packageName = params.packageName;
	self.packageName = params.packageName;
end

function UpdateManager:checkNetState()
	if (device.platform=="windows") then
		return true;
	end
	local state = network.getInternetConnectionStatus();
	echoInfo("THE NETWORK IS %d kCCNetworkStatusNotReachable:%d kCCNetworkStatusReachableViaWiFi:%d,kCCNetworkStatusReachableViaWWAN:%d", state,kCCNetworkStatusNotReachable,kCCNetworkStatusReachableViaWiFi,kCCNetworkStatusReachableViaWWAN);
	self.netState = (state~=kCCNetworkStatusNotReachable);
	return self.netState;
end

function UpdateManager:runSameState()
	echoInfo("UpdateManager runSameState status:%s",self.state);

	self["run"..self.state](self);
end

function UpdateManager:runNextState()
	local next_state = {init = "CheckTotal",CheckTotal="CheckSDK",CheckSDK="CheckLua",CheckLua="SilenceDownload",CheckLuaForce="ForceDownload",Finish="Finish"};
	echoInfo("now UpdateManager status:%s",self.state);
	self.state = next_state[self.state];
	echoInfo("now UpdateManager status:%s",self.state);
	if (self.listener and self.listener.onNextState) then
		self.listener:onNextState(self.state);
	end
	self["run"..self.state](self);
end

function UpdateManager:run()
    echoInfo("UpdateManager run");
	
    self:runNextState();
end

function UpdateManager:runFinish()
	echoInfo("UpdateManager runFinish ,null function here");
	self:runMain("pre");
end

function UpdateManager:runForceDownload()
	self.allDownloadSize = izx.resourceManager:getBatchDownloadSize(self.versionFiles);
	self:startDownloadLua();
end

function UpdateManager:analyseOnlineParam()
	-- if (self.versionInfo.version_code == self.updateInfo.onlineparam.ver_code) then
		
	-- else
	-- 	ONLINE_PARAM = {};
	-- end
	if (self.versionInfo.version_code == self.updateInfo.onlineparam.ver_code) then
	ONLINE_PARAM = self.updateInfo.onlineparam;
	else
		ONLINE_PARAM = {};
	end
end

function UpdateManager:runCheckTotal()
	if (self:checkNetState()==false) then
		echoInfo("TMD no network at all!");
		if (self.listener) then

				self.listener:onCheckFail({canContinue=false,failState=self.state,failReason="totalUpdateHTTP"})
		end
		return;
	end
    local params = {
            pn = self.packageName,
            gameid = MAIN_GAME_ID,
            pid = 0,
            version = VERSION,
            fwversion = self.fwVersion,
            versioncode = LUA_VERSION,
            paramname = self.packageName ..".config2"
    };

    var_dump(params);
    -- local url = URL.TOTALUPDATE
    local url = URL.APP_UPDATE_INIT_ALL
    
    if (self.listener) then
		self.listener.tipsNow = "正在获取游戏版本信息";
    	self.listener:onAnalyseTimerBegin("LOGIN_STEP_DURA","UpdaterTotalHttp");
    	self.listener:showLoadingPercent(10,100);
    end
    HTTPPostRequest(url, params, function(event)
    	if (self.listener) then
	    	self.listener:onAnalyseTimerEnd("LOGIN_STEP_DURA","UpdaterTotalHttp");
	    	self.listener:showLoadingPercent(30,100);
	    end
    	if (event==nil) then
    		if (self.listener) then
				self.listener:onCheckFail({canContinue=false,failState=self.state,failReason="totalUpdateHTTP"})
			end
    		return;
    	end
    	self.updateInfo = event;
    	if (self.updateInfo.versionupdate==nil) then
    		if (self.listener) then
				self.listener:onCheckFail({canContinue=false,failState=self.state,failReason="totalUpdateHTTP"})
			end
    		return;
    	end
    	if (self.updateInfo.gameconfig==nil) then
    		if (self.listener) then
				self.listener:onCheckFail({canContinue=false,failState=self.state,failReason="totalUpdateHTTP"})
			end
    		return;
    	end
    	if (self.updateInfo.onlineparam==nil) then
    		if (self.listener) then
				self.listener:onCheckFail({canContinue=false,failState=self.state,failReason="totalUpdateHTTP"})
			end
    		return;
    	end
    	self:analyseOnlineParam();
    	if (self.onlineparam.skipUpgrade==1) then
    		self.state = "Finish";
    		self:runNextState();
    		return;
    	end

        --self:getMainGameListHTTPConfig();

        --{"vs":"V2.2.0","vn":100,"url":"http://www.izhangxin.com","msg":"发现新版本，是否更新？","ip":"s3.casino.hiigame.net","port":"7200","ef":0,"channel":164,"gameid":10}
        local new_version = {};

        new_version.version_name = self.updateInfo.versionupdate["vs"];
        new_version.version_code = tonumber(self.updateInfo.versionupdate["vn"]);
        new_version.download_url = self.updateInfo.versionupdate["url"];
        new_version.msg = self.updateInfo.versionupdate["msg"];
        var_dump(new_version);
        if new_version.version_name==nil or new_version.version_code ==nil then
			-- 未配置
            self:runNextState();
            return;
        end

        if (new_version.version_code<=self.versionInfo.version_code) then
			-- 无新版本
			self:runNextState();
            return;
        end

        if (tonumber(self.updateInfo.versionupdate["ef"])==0) then
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
		if (self.listener) then
			local canContinue = true;
			if (self.isForceUpgrade) then
				canContinue = false
			end
			self.listener:onCheckUIState({canContinue=canContinue,state=self.state,info=new_version})
		end
    end)
end

function UpdateManager:runCheckSDK()
	if (self:checkNetState()==false) then
		if (self.listener) then
				self.listener:onCheckFail({canContinue=false,failState=self.state,failReason="totalUpdateHTTP"})
		end
		return;
	end
	if (self.listener) then
		self.listener:showLoadingPercent(40,100);
		gBaseLogic.MBPluginManager:loadSessionPlugins();
	end
	print("gBaseLogic.MBPluginManager:loadSessionPlugins")
	local delay = 0.0;
	if (gBaseLogic.MBPluginManager.distributions.sdkUpgradeDelay) then
		delay = 0.5;
	end
	scheduler.performWithDelayGlobal(function() self:runNextState() end, delay);
end

function UpdateManager:runCheckLua()
	if (self:checkNetState()==false) then
		if (self.listener) then
				self.listener:onCheckFail({canContinue=false,failState=self.state,failReason="totalUpdateHTTP"})
		end
		return;
	end
	self:getMainGameListHTTPConfig();
	
end

function UpdateManager:runSilenceDownload()
	self:startDownloadLua();
	self:runMain("pre");
end

function UpdateManager:preparePath()
	self.mainGameCfg = {};
	self.mainGameCfg.code = CCUserDefault:sharedUserDefault():getStringForKey("mainGameCode");

	local last_res = CCUserDefault:sharedUserDefault():getStringForKey("mainGameRes");
	if (last_res==nil or last_res=="" or last_res=="null") then
		self.mainGameCfg.resDir = {};
		CCUserDefault:sharedUserDefault():setStringForKey("mainGameRes","{}");
	else
		self.mainGameCfg.resDir = json.decode(last_res);
	end

	local isFirstRunLua = CCUserDefault:sharedUserDefault():getIntegerForKey("firstRunLua");
	if (isFirstRunLua==1) then

		for k,v in pairs(self.mainGameCfg.resDir) do
			echoInfo("rmDir download as "..k);
			rmDir(k);
		end
		CCUserDefault:sharedUserDefault():setStringForKey("mainGameRes","{}");
		self.mainGameCfg.resDir = {};
	end
	CCUserDefault:sharedUserDefault():setIntegerForKey("firstRunLua",0);
	
	for k,v in pairs(RES_LOAD_PRE_PATH) do
		echoInfo("addSearchPath default as "..v);
		CCFileUtils:sharedFileUtils():addSearchPath(v);
	end
	
	for k,v in pairs(self.mainGameCfg.resDir) do
		echoInfo("addSearchPath download as "..k);
		izx.resourceManager.fileManager:addSearchPath(k);
	end
end

function UpdateManager:initPreInstall()
    local version = CCUserDefault:sharedUserDefault():getStringForKey("mainGameVersion");
	if ((version==nil or version=="")) then
		-- first run!
		-- write back the sub package version to userdefault
		for pkg_name,pkg_version in pairs(PRE_INSTALLED_VERSION) do
			self:writeSubPkgVer(MAIN_GAME_ID,pkg_name,pkg_version);
		end
	end
end


function UpdateManager:getMainGameListHTTPConfig()
	local event = self.updateInfo.gameconfig;
	var_dump({name="getMainGameListHTTPConfig event",event=event},4);
	if (#event == 0) then
		-- no data configed, so run pre version
		echoInfo("No Update Info configed");
		self:runMain("pre");
		return;
	end
	for k,v in pairs(event) do


		echoInfo("INIT FOR MiniGame "..v.game_id);
		v.game_id = tonumber(v.game_id);
		
		self.mainGameCfg.versionReady = false;
		self.mainGameCfg.isDownloading = false;
		self.mainGameCfg.version = v.version;

		self.mainGameCfg.versionFiles = v.version_files;    		
		self.mainGameCfg.luaversion = v.versioncode;    	
		self.mainGameCfg.extparam = v.extparam;   
		if (v.forceupdate==1) then
			self.mainGameCfg.forceupdate = true;
		else
			self.mainGameCfg.forceupdate = false;
		end
		
		self:checkMainGameVersion(tonumber(v.versioncode),self.mainGameCfg.versionFiles);
	end
end
function UpdateManager:getMainGameListHTTPConfigOld()
	local params = {
					gameid = MAIN_GAME_ID,
                    pid = 0,
                    pn = self.packageName,
                    version = VERSION,
                    fwversion = self.fwVersion,
                    versioncode = LUA_VERSION
            };
    local url = URL.MAINGAME_VERSION_CTL
    var_dump({name="getMainGameListHTTPConfig param",params=params});
    self.tipsNow = "正在获取服务器信息";
    if (self.listener) then
    	self.listener:onAnalyseTimerBegin("LOGIN_STEP_DURA","UpdaterHTTP");
    	self.listener:showLoadingPercent(70,100);
    end
    HTTPPostRequest(url, params, function(event)
    	if (self.listener) then
	    	self.listener:onAnalyseTimerEnd("LOGIN_STEP_DURA","UpdaterHTTP");
	    	self.listener:showLoadingPercent(80,100);
	    end
    	if (event==nil) then
    		self:onUpdateFail("服务器信息获取失败",'UpdaterHTTP');
    		return;
    	end
    	var_dump({name="getMainGameListHTTPConfig event",event=event},4);
    	if (#event == 0) then
    		-- no data configed, so run pre version
    		echoInfo("No Update Info configed");
    		self:runMain("pre");
    		return;
    	end
    	for k,v in pairs(event) do


    		echoInfo("INIT FOR MiniGame "..v.game_id);
    		v.game_id = tonumber(v.game_id);
    		
    		self.mainGameCfg.versionReady = false;
    		self.mainGameCfg.isDownloading = false;
    		self.mainGameCfg.version = v.version;

    		self.mainGameCfg.versionFiles = v.version_files;    		
    		self.mainGameCfg.luaversion = v.versioncode;    	
			self.mainGameCfg.extparam = v.extparam;   
			if (v.forceupdate==1) then
				self.mainGameCfg.forceupdate = true;
			else
				self.mainGameCfg.forceupdate = false;
			end

			self:checkMainGameVersion(tonumber(v.versioncode),self.mainGameCfg.versionFiles);
    	end
    	
    end)
end

function UpdateManager:checkDownloadStatus()
	local processInfo = izx.resourceManager:checkDlStatus(MAIN_GAME_ID);
	if (self.allDownloadSize~=nil and self.allDownloadSize>0) then
		processInfo.downloadTotal = self.allDownloadSize;
	end
	return processInfo;
end

function UpdateManager:checkMainGameVersion(gameVersion,versionFiles)
	echoInfo("Updater:checkMainGameVersion");
	if (self.listener) then
    	self.listener:onAnalyseTimerBegin("DOWNLOADING","UpdaterSucc");
    end
	local downloadedVersion = tonumber(CCUserDefault:sharedUserDefault():getStringForKey("mainGameVersion"));
    izx.resourceManager:setFrameworkVersion(self.fwVersion);

    -- 本地版本号更高的永远只更新lazy部分
	if (tonumber(LUA_VERSION) >= gameVersion) then
		echoInfo("Updater:checkMainGameVersion :: pre installed same Version!!");
		-- the pre-installed code is same with online version
		local has_lazy = false;
		for name,v in pairs(versionFiles) do

			if (tonumber(v.isLazy)~=1) then
				-- for lazy ones 
				versionFiles[name] = nil;
			else
				has_lazy = true;
			end
		end
		if (has_lazy) then

			izx.resourceManager:addBatchLazyDownload(versionFiles,"mainGameDownload",MAIN_GAME_ID,self);
		end
		CCUserDefault:sharedUserDefault():setStringForKey("mainGameVersion",LUA_VERSION);
		self:runMain("pre");
		-- 
		return;
	elseif (downloadedVersion==gameVersion) then
		echoInfo("Updater:checkMainGameVersion :: ever download same Version!!");

		self.mainGameCfg.versionReady = true;
		self.mainGameCfg.isDownloading = false;

    	-- the downloaded version can be run directly
    	self:runMain("download");
    	return;
	else
		echoInfo("Updater:checkMainGameVersion :: need diff minor Versions!!");
		self.mainGameCfg.gameVersion = gameVersion;
		self.mainGameCfg.versionReady = false;

		self.mainGameCfg.isDownloading = true;
		self.mainGameCfg.code = "";
		
		--检查小版本号
		local hasDiff = false;
		local hasLazy = false;
		for name,info in pairs(versionFiles) do
			local version = self:readSubPkgVer(gameId,name);
			if (version==info.v) then
				echoInfo("getBatchDownloadSize skip same %s", name);
				versionFiles[name].hasDiff = false;
			elseif (info.isLazy==1) then
				echoInfo("getBatchDownloadSize skip lazy %s", name);
				versionFiles[name].hasDiff = false;
				hasLazy =true;
			else
				versionFiles[name].hasDiff = true;
				hasDiff = true;
			end
		end
		self.versionFiles = versionFiles;
		if (hasLazy) then
			izx.resourceManager:addBatchLazyDownload(versionFiles,"mainGameDownload",MAIN_GAME_ID,self);
		end
		if (hasDiff==false) then
			self:runMain("pre");
			return;
		end
		
		if (device.platform=="windows") then
			if (self.listener) then

				self.listener.loadingScene.view.state = "downloading";
				self.listener.loadingScene.view:showHideLoadingBar("show");
			end
			scheduler.performWithDelayGlobal(function() self:startDownloadLua(); end, 0.1)
		else 
			self.wifiState = network.isLocalWiFiAvailable();
			if (self.wifiState) then
				self:runNextState();

				-- self.loadingScene.view.state = "downloading";
				-- self.loadingScene.view:showHideLoadingBar("show");
				-- self.updateManager.state = "CheckLuaForce";
				-- self.updateManager:runNextState();

			else
				if (params.forceupdate==true) then
					if (self.listener) then
						self.listener.loadingScene.view.state = "downloading";
						self.listener.loadingScene.view:showHideLoadingBar("show");
					end
					self:startDownloadLua();
				else
					self:runNextState();
				end
			end
		end		

	end
end

function UpdateManager:startDownloadLua()
	izx.resourceManager:startBatchDownload(self.versionFiles,"mainGameDownload",MAIN_GAME_ID,self);
end

function UpdateManager:onBatchDownloadError(gameId, ret, msg)

end

function UpdateManager:readSubPkgVer(gameId,pkgName)
	local v = CCUserDefault:sharedUserDefault():getStringForKey("mainGamePkgVer_"..pkgName);
	if (v==nil) then
		v="";
	end
	print("read pkg Version: ".."mainGamePkgVer_"..pkgName.." as "..v)
    return v;
end

function UpdateManager:writeSubPkgVer(gameId,pkgName,version)
	print("write pkg Version: mainGamePkgVer_"..pkgName.." as "..version)
    CCUserDefault:sharedUserDefault():setStringForKey("mainGamePkgVer_"..pkgName,version);
end

function UpdateManager:onAddLazyBatchFinished(gameId,versionInfo)
	if (self.mainGameCfg.resDir==nil) then
		self.mainGameCfg.resDir = {}
	end
	for name,info in pairs(versionInfo) do
		var_dump(info);
		if (info.targetPath~=nil) then
			self.mainGameCfg.resDir[info.targetPath] = 1;
		end
	end
	for name,k in pairs(self.mainGameCfg.resDir) do
		izx.resourceManager.fileManager:addSearchPath(name);
	end
	CCUserDefault:sharedUserDefault():setStringForKey("mainGameRes",json.encode(self.mainGameCfg.resDir));

end

function UpdateManager:onCheckBatchFinished(gameId,versionInfo)        
    --dispatch succ
    echoInfo("Updater:DOWNLOAD FINISHED!!!"..gameId)
    -- for mini game, only support one res dir
    self.mainGameCfg.resDir = {};
    for name,info in pairs(versionInfo) do
        local version = info.v;
        self:writeSubPkgVer(gameId,name,version);
        --unzip all resource file
        if (tonumber(info.type)==0) then
            -- for code not upgrade, don't need copy this file

            echoInfo("-----GGGG-----Do with code package!!!----gameId:"..gameId);
            if (info.unzipFileName and info.codeTarget) then
                echoInfo("-----GGGG-----copied file!!!from"..info.unzipFileName.." to "..info.codeTarget);
                if (not io.exists(info.unzipFileName)) then
                    self:onBatchDownloadFinish({
                        ret = -11,
                        gameId = gameId,
                        msg = msg[MAIN_GAME_ID]
                    });
                    echoError("ResourceManager:FILE DOWNLOAD FAIL");
                    return;
                end
                removeFile(info.codeTarget);
                izx.resourceManager.fileManager:copyFile(info.unzipFileName, info.codeTarget);
                
            end
            if (info.codeTarget) then
                self.mainGameCfg.code = info.codeTarget;
            end

        elseif (tonumber(info.type)==1) then
            if (info.unzipFileName) then
                echoInfo("ResourceManager:will unzip "..info.unzipFileName.." to "..info.targetPath);
                local result = izx.resourceManager.fileManager:uncompress(info.unzipFileName, info.targetPath);
            end
            -----copiedor main game, support multi res dir

            self.mainGameCfg.resDir[info.targetPath] = 1;
        end;
        
    end

    CCUserDefault:sharedUserDefault():setStringForKey("mainGameCode",self.mainGameCfg.code);
    CCUserDefault:sharedUserDefault():setStringForKey("mainGameRes",json.encode(self.mainGameCfg.resDir));

    self:onBatchDownloadFinish({
        ret = 0,
        gameId = gameId,
        versionFile = self.mainGameCfg
    });
        
end

function UpdateManager:onBatchDownloadFinish(msg)
	local gameId = msg.gameId;
	local ret = tonumber(msg.ret);
	
	if (ret == 0) then
		self.mainGameCfg.versionReady = true;
		self.mainGameCfg.isDownloading = false;
		self.mainGameCfg.versionFile = msg.versionFile;	
		if (self.listener) then
		    	self.listener:onAnalyseTimerEnd("DOWNLOADING","UpdaterSucc");
		    end

		CCUserDefault:sharedUserDefault():setStringForKey("mainGameVersion",self.mainGameCfg.gameVersion);		
		self:runMain("download");
	else
		if (self.gameStarted) then

		else
			self:onUpdateFail(msg.msg,'downloadFail');
		end
	end
	
	
end

function UpdateManager:onUpdateFail(msg,failReason)
	if (self.listener) then
		self.listener:onCheckFail({canContinue=false,failState=self.state,msg=msg,failReason=failReason})
	end
end

function UpdateManager:runMain(preOrDownload,succOrFail)
	-- if (true) then
	-- 	return;
	-- end
	echoInfo("UpdateManager:runMain(preOrDownload=%s,succOrFail)",preOrDownload);
	if (self.gameStarted) then
		echoError("UpdateManager:runMain has runned!!!!");
		return
	end
	self.gameStarted = true;
	self.onDealFail = false;
	
	if (self.listener) then
		StartUpdater.LOGIN_STEP_DURA.UpdaterTotal = gBaseLogic.MBPluginManager.pluginProxy:getMilliseconds() - self.listener.startTimer1;
	end
	if (succOrFail==nil) then
		succOrFail = true;
	end
	self.listener = nil;
	updaterSuccOrFail = succOrFail;
	if (preOrDownload=="pre") then
			-- same version as pre-installed
			-- nothing to do with code, just add res dir
		echoInfo("Updater:runMain :: pre installed run!");
		
		require("ios_main");
	else
		echoInfo("Updater:runMain :: downloaded version run!");
		

		CCLuaLoadChunksFromZIP(self.mainGameCfg.code);
		for k,v in pairs(self.mainGameCfg.resDir) do
			echoInfo("addSearchPath as "..k);
			izx.resourceManager.fileManager:addSearchPath(k);
		end
		self:cleanupAll();
		require("ios_main");
	end
	
end

function UpdateManager:cleanupAll()
	izx.baseView = nil;
	izx.basePage = nil;
	izx.baseCtrller = nil;
	izx = nil;
	URL = nil;
	gBaseLogic = nil;
	
	for k,v in pairs(package.loaded) do
		local i,j = string.find(k, 'extensions');
		if (i~=nil) then
			package.loaded[k] = nil;
		end;
		i,j = string.find(k, 'izxFW');
		if (i~=nil) then
			package.loaded[k] = nil;
		end;
		i,j = string.find(k, 'module');
		if (i~=nil) then
			package.loaded[k] = nil;
		end;
		i,j = string.find(k, 'thirdparty');
		if (i~=nil) then
			package.loaded[k] = nil;
		end;
		i,j = string.find(k, 'config');
		if (i~=nil) then
			package.loaded[k] = nil;
		end;
		i,j = string.find(k, 'version_control');
		if (i~=nil) then
			package.loaded[k] = nil;
		end;
		i,j = string.find(k, 'distribution');
		if (i~=nil) then
			package.loaded[k] = nil;
		end;
	end
end


return UpdateManager;