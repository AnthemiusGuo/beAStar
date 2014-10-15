--
-- Author: Guo Jia
-- Date: 2014-02-28 16:38:04
--
local MiniGameManager = class("MiniGameManager")


function MiniGameManager:ctor() 
	self.miniGameCfg = {}
    self.downloadTag = "miniGameDownload";
end

function MiniGameManager:init()
	echoInfo("MiniGameManager init");
    self:initPreInstall();
	if (MINIGAME_IN_DEVELOP and MINIGAME_IN_DEVELOP_CONFIG ) then
    	self.miniGameCfg = MINIGAME_IN_DEVELOP_CONFIG;
    else
    	self:getMiniGameListHTTPConfig();--取小游戏配置
    end

end

function MiniGameManager:initPreInstall()
    preLoadMiniGame();
    if (PRE_INSTALLED_MINIGAME==nil) then
        echoInfo("MiniGameManager:initPreInstall has no PRE_INSTALLED_MINIGAME")
        return;
    end
    echoInfo("MiniGameManager:initPreInstall has PRE_INSTALLED_MINIGAME")
    local runned = CCUserDefault:sharedUserDefault():getStringForKey("MiniGameManager:initPreInstall");
    if (runned==nil or runned=="") then
        echoInfo("MiniGameManager:initPreInstall not set installed")
        CCUserDefault:sharedUserDefault():setStringForKey("MiniGameManager:initPreInstall","installed");
    else
         echoInfo("MiniGameManager:initPreInstall set installed")
        return;
    end
    for gameId,versionInfo in pairs(PRE_INSTALLED_MINIGAME) do
        var_dump(versionInfo);
        CCUserDefault:sharedUserDefault():setStringForKey("miniGameVersion_"..tostring(gameId),versionInfo.version);
        CCUserDefault:sharedUserDefault():setStringForKey("miniGameCode_"..tostring(gameId),versionInfo.code);
        CCUserDefault:sharedUserDefault():setStringForKey("miniGameRes_"..tostring(gameId),versionInfo.resDir);
    end

end

function MiniGameManager:getMiniGameCfg(gameId,key)
	if (self.miniGameCfg[gameId]) then
		return self.miniGameCfg[gameId][key];
	else
		return nil;
	end
end

function MiniGameManager:getMiniGame(gameId)
	return self.miniGameCfg[gameId];
end

function MiniGameManager:getMiniGameListHTTPConfig()
    if (gBaseLogic.MBPluginManager.distributions.nominigame) then
        return;
    end

    local params = {
                    pid = gBaseLogic.lobbyLogic.userData.ply_guid_,
                    pn = gBaseLogic.packageName,
                    version = VERSION,
            };
    local url = URL.MINIGAME_CONFIG

    HTTPPostRequest(url, params, function(event)
    	
    	if (event==nil) then
    		-- event = json.decode('[{"game_id":"100","game_module":"moduleLaba","game_name":"拉霸游戏","version":"3.0.0.1","icon":"http://pic.yupoo.com/anthemius_v/DxWI24gR/Nbkxm.png","icon2":"http://pic.yupoo.com/anthemius_v/DxWI1zOI/kkwnL.png","version_files":{"script":{"v":"1","path":"http://127.0.0.1/codes.zip","ext":"/sdcard/wp/script","isLazy":"0","type":"0"},"images":{"v":"1","path":"http://127.0.0.1/codes.zip","ext":"/sdcard/wp/images","isLazy":"0","type":"0"}}},{"game_id":"101","game_module":"moduleYao","game_name":"摇摇乐小游戏","version":"3.0.0.1","icon":"http://pic.yupoo.com/anthemius_v/DxWI2eK8/AXLpQ.png","icon2":"http://pic.yupoo.com/anthemius_v/DxWI2fJJ/4TLJl.png","version_files":{"script":{"v":"2","path":"http://127.0.0.1/codes.zip","ext":"/sdcard/wp/script","isLazy":"1","type":"1"},"images":{"v":"2","path":"http://127.0.0.1/codes.zip","ext":"/sdcard/wp/images","isLazy":"1","type":"1"}}}]');
    		return;
    	end
        print("MiniGameManager:getMiniGameListHTTPConfig")
        var_dump(event)
        print("MiniGameManager:getMiniGameListHTTPConfig")
    	for k,v in pairs(event) do
    		echoInfo("INIT FOR MiniGame "..v.game_id);
    		v.game_id = tonumber(v.game_id);
    		self.miniGameCfg[v.game_id] = {};
            self.miniGameCfg[v.game_id].game_id = v.game_id;
    		self.miniGameCfg[v.game_id].versionReady = false;
    		self.miniGameCfg[v.game_id].isDownloading = false;
    		self.miniGameCfg[v.game_id].gameModule = v.game_module;
    		self.miniGameCfg[v.game_id].gameName = v.game_name;
    		self.miniGameCfg[v.game_id].version = v.version;
    		self.miniGameCfg[v.game_id].icon = v.icon;
    		self.miniGameCfg[v.game_id].icon2 = v.icon2;
            self.miniGameCfg[v.game_id].order = tonumber(v.order);
            self.miniGameCfg[v.game_id].SocketConfigList = {};
            self.miniGameCfg[v.game_id].initparamList = {};
    		
    		self.miniGameCfg[v.game_id].versionFiles = v.version_files;
    		

    		
    		self.miniGameCfg[v.game_id].iconFile1 = "images/DaTing/miniGameDefualt.png";
    		self.miniGameCfg[v.game_id].iconFile2 = "images/DaTing/miniGameDefualt.png";
    		izx.resourceManager:imgFileDown(self.miniGameCfg[v.game_id].icon,true,function(fileName)
    			self.miniGameCfg[v.game_id].iconFile1 = fileName;
    		end)
    		izx.resourceManager:imgFileDown(self.miniGameCfg[v.game_id].icon2,true,function(fileName)
    			self.miniGameCfg[v.game_id].iconFile2 = fileName;
    		end)

			self.miniGameCfg[v.game_id].code = CCUserDefault:sharedUserDefault():getStringForKey("miniGameCode_"..v.game_id);
			self.miniGameCfg[v.game_id].resDir = CCUserDefault:sharedUserDefault():getStringForKey("miniGameRes_"..v.game_id);

    		if (MINIGAME_IN_DEVELOP) then
    			self.miniGameCfg[v.game_id].versionReady = true;
    			self.miniGameCfg[v.game_id].isDownloading = false;    		
    		else

    			self:checkMiniGameVersion(v.game_id,v.version);
    		end
    	end
    	gBaseLogic.lobbyLogic:reqMiniGameSend()
    	
    end)
end

function MiniGameManager:reCheckVersion(gameId)
    if (true) then
        return false;
    end
    local params = {
                    pid = gBaseLogic.lobbyLogic.userData.ply_guid_,
                    pn = gBaseLogic.packageName,
                    version = VERSION,
            };
    local url = URL.MINIGAME_CONFIG

    HTTPPostRequest(url, params, function(event)
        
        if (event==nil) then
            -- event = json.decode('[{"game_id":"100","game_module":"moduleLaba","game_name":"拉霸游戏","version":"3.0.0.1","icon":"http://pic.yupoo.com/anthemius_v/DxWI24gR/Nbkxm.png","icon2":"http://pic.yupoo.com/anthemius_v/DxWI1zOI/kkwnL.png","version_files":{"script":{"v":"1","path":"http://127.0.0.1/codes.zip","ext":"/sdcard/wp/script","isLazy":"0","type":"0"},"images":{"v":"1","path":"http://127.0.0.1/codes.zip","ext":"/sdcard/wp/images","isLazy":"0","type":"0"}}},{"game_id":"101","game_module":"moduleYao","game_name":"摇摇乐小游戏","version":"3.0.0.1","icon":"http://pic.yupoo.com/anthemius_v/DxWI2eK8/AXLpQ.png","icon2":"http://pic.yupoo.com/anthemius_v/DxWI2fJJ/4TLJl.png","version_files":{"script":{"v":"2","path":"http://127.0.0.1/codes.zip","ext":"/sdcard/wp/script","isLazy":"1","type":"1"},"images":{"v":"2","path":"http://127.0.0.1/codes.zip","ext":"/sdcard/wp/images","isLazy":"1","type":"1"}}}]');
            return;
        end
        for k,v in pairs(event) do
            echoInfo("INIT FOR MiniGame "..v.game_id);
            v.game_id = tonumber(v.game_id);
            if (v.game_id==gameId) then            
                self.miniGameCfg[v.game_id].versionReady = false;
                self.miniGameCfg[v.game_id].isDownloading = false;
                self.miniGameCfg[v.game_id].version = v.version;

                
                self.miniGameCfg[v.game_id].versionFiles = v.version_files;
                
                self.miniGameCfg[v.game_id].code = CCUserDefault:sharedUserDefault():getStringForKey("miniGameCode_"..v.game_id);
                self.miniGameCfg[v.game_id].resDir = CCUserDefault:sharedUserDefault():getStringForKey("miniGameRes_"..v.game_id);
                self:checkMiniGameVersion(v.game_id,v.version);
            end
        end        
        
    end)
end

function MiniGameManager:resetDownload(gameId)
    gameId = tonumber(gameId);
    self.miniGameCfg[gameId].versionReady = false;
    self.miniGameCfg[gameId].isDownloading = false;
    self.miniGameCfg[gameId].code = nil;
    self.miniGameCfg[gameId].resDir = nil;


    CCUserDefault:sharedUserDefault():setStringForKey("miniGameVersion_"..gameId,"");
    CCUserDefault:sharedUserDefault():setStringForKey("miniGameCode_"..gameId,"");
    CCUserDefault:sharedUserDefault():setStringForKey("miniGameRes_"..gameId,"");
    local version = "";
    self:writeSubPkgVer(gameId,"script",version)
    self:writeSubPkgVer(gameId,"images",version)
    self:writeSubPkgVer(gameId,"sounds",version)
    self:writeSubPkgVer(gameId,"interfaces",version)

end

function MiniGameManager:onBatchDownloadFinish(msg)
	local gameId = tonumber(msg.gameId);
    local ret = tonumber(msg.ret);
	echoInfo("LobbyLogic:onBatchDownloadFinish gameId:%d,ret:%d",gameId,ret);
	if (ret == 0) then
		self.miniGameCfg[gameId].versionReady = true;
		self.miniGameCfg[gameId].isDownloading = false;
		self.miniGameCfg[gameId].versionFile = msg.versionFile;	

		CCUserDefault:sharedUserDefault():setStringForKey("miniGameVersion_"..gameId,self.miniGameCfg[gameId].gameVersion);
		if (self.miniGameCfg[gameId].code==nil or self.miniGameCfg[gameId].code=="") then
            self.miniGameCfg[gameId].code = CCUserDefault:sharedUserDefault():getStringForKey("miniGameCode_"..gameId);
        else
            CCUserDefault:sharedUserDefault():setStringForKey("miniGameCode_"..gameId,self.miniGameCfg[gameId].code);
        end
        if (self.miniGameCfg[gameId].resDir==nil or self.miniGameCfg[gameId].resDir=="") then
            self.miniGameCfg[gameId].resDir = CCUserDefault:sharedUserDefault():getStringForKey("miniGameRes_"..gameId);
        else
            CCUserDefault:sharedUserDefault():setStringForKey("miniGameRes_"..gameId,self.miniGameCfg[gameId].resDir);
        end
        

	end
	--dispatch
	gBaseLogic.lobbyLogic:dispatchLogicEvent({
		name = "MSG_RES_MODULE_BATCH_DOWNLOAD",
		message = msg;
	});
	
end

function MiniGameManager:checkMiniGameVersion(gameId,gameVersion)
    local versionFiles = self.miniGameCfg[gameId].versionFiles;
	echoInfo("MiniGameManager:checkMiniGameVersion");
    local counter = 0;
	local version = CCUserDefault:sharedUserDefault():getStringForKey("miniGameVersion_"..gameId);
	if (version==gameVersion or gBaseLogic.MBPluginManager.distributions.nominigamedownload) then
		echoInfo("MiniGameManager:checkMiniGameVersion :: same Version!!");
		self.miniGameCfg[gameId].versionReady = true;
		self.miniGameCfg[gameId].isDownloading = false;
	else
		self.miniGameCfg[gameId].gameVersion = gameVersion;
		self.miniGameCfg[gameId].versionReady = false;

        --检查小版本号
        local hasDiff = false;
        
        for name,info in pairs(versionFiles) do
            local version = self:readSubPkgVer(gameId,name);
            if (version==info.v or info.isLazy==1) then
                self.miniGameCfg[gameId].versionFiles[name].hasDiff = false;
            else
                self.miniGameCfg[gameId].versionFiles[name].hasDiff = true;
                hasDiff = true;
            end
        end
        if (hasDiff==false) then
            self.miniGameCfg[gameId].versionReady = true;
            self.miniGameCfg[gameId].isDownloading = false;
            return;
        end

		if (izx.resourceManager:getWifiState()) then
			
            -- self.miniGameCfg[gameId].downloadScheduler = scheduler.performWithDelayGlobal(function()
            --     if (self.miniGameCfg[gameId].isDownloading==false) then
            --         self.miniGameCfg[gameId].isDownloading = true;
            --         izx.resourceManager:startBatchDownload(versionFiles,self.downloadTag,gameId,self)
            --     end
            -- end, counter*30);
            -- counter = counter + 1;
			--,function()
			--  	CCUserDefault:sharedUserDefault():setStringForKey("miniGameVersion_"..gameId,""..gameVersion);

			-- end
		else 
			self.miniGameCfg[gameId].isDownloading = false;
		end
		
		
	end
end

function MiniGameManager:onBatchDownloadError(gameId, ret, msg)

end

function MiniGameManager:onSockConfig(message)
	local SocketConfig = -1;
    local initparam = {};
    print("-------------MiniGameManager:onSockConfig---------------");
    var_dump(message,3);
    -- var_dump(self.miniGameCfg)
    for k,v in pairs(message.server_datas_) do
    	-- print(v.game_id_)
    	-- var_dump(self.miniGameCfg[v.game_id_])
    	-- tostring(e)
    	v.game_id_ = tonumber(v.game_id_)
        if (self.miniGameCfg[v.game_id_]) then
        	-- print("inherre")
            self.miniGameCfg[v.game_id_].SocketConfig = {socketIp = v.server_addr_,socketPort = v.server_port_};
            self.miniGameCfg[v.game_id_].initparam = {min_money_=v.min_money_,base_bet_=v.base_bet_};
            table.insert(self.miniGameCfg[v.game_id_].SocketConfigList,{socketIp = v.server_addr_,socketPort = v.server_port_});
            table.insert(self.miniGameCfg[v.game_id_].initparamList, {min_money_=v.min_money_,base_bet_=v.base_bet_});
        else
        	print("-----------DELETE HERE---------------");
            self.miniGameCfg[v.game_id_] = nil;
        end
    end

end

function MiniGameManager:readSubPkgVer(gameId,pkgName)
    return CCUserDefault:sharedUserDefault():getStringForKey("miniGamePkgVer_"..gameId.."_"..pkgName);
end

function MiniGameManager:writeSubPkgVer(gameId,pkgName,version)
    CCUserDefault:sharedUserDefault():setStringForKey("miniGamePkgVer_"..gameId.."_"..pkgName,version);
end


function MiniGameManager:onProgress(gameId,processInfo)
    echoInfo("Updater:onProgress %s %s/%s", processInfo.nowdl,tostring(processInfo.now),tostring(processInfo.total));

    local name = packageNames[processInfo.nowdl];
    local percentInfo = processInfo.info[processInfo.nowdl];
    local percent = 0 ;
    if (percentInfo.total>0) then
        percent = percentInfo.now / percentInfo.total * 100;
    end

    self.miniGameCfg[gameId].tipsNow = string.format("正在下载最新%s %d/100 : %d / %d",name,percent,percentInfo.now,percentInfo.total);
end

function MiniGameManager:onCheckBatchFinished(gameId,versionInfo)        
    --dispatch succ
    echoInfo("MiniGameManager:DOWNLOAD FINISHED!!!"..gameId)
    -- for mini game, only support one res dir

    for name,info in pairs(versionInfo) do
        local version = info.v;
        self:writeSubPkgVer(gameId,name,version);
        --unzip all resource file
        if (tonumber(info.type)==0) then
            -- for code not upgrade, don't need copy this file

            echoInfo("-----GGGG-----Do with code package!!!----gameId:%d,info.unzipFileName:%s,info.codeTarget,%s",gameId,info.unzipFileName,info.codeTarget);
            if (info.unzipFileName and info.codeTarget) then
                echoInfo("-----GGGG-----copied file!!!from"..info.unzipFileName.." to "..info.codeTarget);
                if (not io.exists(info.unzipFileName)) then
                    self:onBatchDownloadFinish({
                        ret = -11,
                        gameId = gameId,
                        msg = '下载文件失败'
                    });
                    echoError("ResourceManager:FILE DOWNLOAD FAIL");
                    return;
                end
                removeFile(info.codeTarget);
                izx.resourceManager.fileManager:copyFile(info.unzipFileName, info.codeTarget);
                if (not io.exists(info.codeTarget)) then
                    self:onBatchDownloadFinish({
                        ret = -11,
                        gameId = gameId,
                        msg = '更新文件失败，您的手机可能装有一些软件限制了更新功能'
                    });
                    echoError("ResourceManager:FILE COPY FAIL");
                    return;
                end

            else
                echoError("WTF is the code target!");
                var_dump(info)
            end
            if (info.codeTarget) then
                self.miniGameCfg[gameId].code = info.codeTarget;
            end

        elseif (tonumber(info.type)==1) then
            if (info.unzipFileName) then
                echoInfo("ResourceManager:will unzip "..info.unzipFileName.." to "..info.targetPath);
                local result = izx.resourceManager.fileManager:uncompress(info.unzipFileName, info.targetPath);
            end
            -----copiedor mini game, only support one res dir

            self.miniGameCfg[gameId].resDir = info.targetPath;
        else
            echoError("WTF is this????????");
            var_dump(info)
        end;
        
    end

    
    self:onBatchDownloadFinish({
        ret = 0,
        gameId = gameId,
        versionFile = self.miniGameCfg[gameId]
    });
        
end

return MiniGameManager;