local ResourceManager = class("ResourceManager")

local DOWNLOAD_STATUS_NOT_BEGAN = 0;
local DOWNLOAD_STATUS_WAIT = 1;
local DOWNLOAD_STATUS_BEGAN = 2;
local DOWNLOAD_STATUS_FINISH = 3;
local DOWNLOAD_STATUS_FAIL = -1;
local DOWNLOAD_STATUS_UNMATCH = -2;
local EXT_TYP = {[0] = 'jpg',[1] = 'png',[2] = 'jpg',[3] = 'gif'};

local DownloadThread = class("DownloadThread")

function DownloadThread:ctor(url,gameId,name,targetPath,pResourceManager)
	self.listener = pResourceManager;
	self.gameId = gameId;
	self.url = url;
	self.name = name;
	self.targetPath = targetPath;
	self.isResumeDownload = false;
	self.listenInfo = self.listener.downloadInfo[self.gameId][self.name];
end

function DownloadThread:setDownloadPath(path)
	self.downloadPath = path;
end


function DownloadThread:start()
	self:setStatus(DOWNLOAD_STATUS_BEGAN);
	self.fileCacheName = (self.downloadPath)..(crypto.md5(self.url)).."."..getUrlExtension(self.url);
	
	self:zipFileDown();
end

function DownloadThread:checkProcess()
	-- echoInfo("DownloadThread:checkProcess %s %s",tostring(self.canGetProgress),tostring(self.request));
	
	if (self.canGetProgress and self.request) then
		self.dltotal = self.request:getDlTotal();
		self.dlnow = self.request:getDlNow();
	else
		self.dltotal = 0;
		self.dlnow = 0;
	end

end

function DownloadThread:onError(error)
	self.listener:onError(self.gameId,{
		ret = error.ret,
		gameId = self.gameId,
		msg = error.msg
	});
end

function DownloadThread:onFail()
	self:setStatus(DOWNLOAD_STATUS_FAIL);
	self:onError({
			ret = -11,
			msg = '资源文件加载失败，请检查网络或稍后重试'
	});
end

function DownloadThread:setStatus(status)
	self.downloadStatus = status;
	self.listenInfo.downloadStatus = status;
end

function DownloadThread:checkDownloadFile()

	if (not io.exists(self.fileCacheName)) then
		self:setStatus(DOWNLOAD_STATUS_FAIL);
		self:onError({
			ret = -11,
			msg = '资源文件加载失败，请重新启动应用'
		});
		echoError("ResourceManager:FILE DOWNLOAD FAIL");
		return false;
	end
	
	-- check file download correct
	if (not self.listener:checkFile(self.fileCacheName,self.listenInfo.v)) then
		--dispatch error
		self:setStatus(DOWNLOAD_STATUS_FAIL);
		
		echoInfo("!!!!!!!!!!ResourceManager:FILE DON'T MATCH!%s for %s",self.name,self.gameId);
		removeFile(self.fileCacheName);
		self:onError({
			ret = -8,
			msg = '资源文件无法对应'
		});
		return false;
	end

	if (tonumber(self.listenInfo.type)==0) then
		if (not checkDirOK(self.targetPath..self.listenInfo.ext.."/")) then
			self:setStatus(DOWNLOAD_STATUS_FAIL);
			self:onError(gameId,{
					ret = -10,
					gameId = gameId,
					msg = '无法创建目录'
				});
			return;
		end
	else
		if (not checkDirOK(self.targetPath..self.listenInfo.ext.."/")) then
			self:setStatus(DOWNLOAD_STATUS_FAIL);
			self:onError(gameId,{
					ret = -10,
					gameId = gameId,
					msg = '无法创建目录'
				});
			return;
		end
	end

	return true;
end

function DownloadThread:onComplete()
	if (self:checkDownloadFile()==false) then
		return
	end
	echoInfo("ResourceManager:---finish download %s for %s",self.name,self.gameId);
	if (tonumber(self.listenInfo.type)==0) then
		-- code, just copy to target dir
		self.listenInfo.unzipFileName = self.fileCacheName;
		self.listenInfo.codeTarget = self.targetPath..self.listenInfo.ext..'/'..self.name..'.zip';	    					
	else
		-- resources						
		self.listenInfo.unzipFileName = self.fileCacheName;
		self.listenInfo.targetPath = self.targetPath..self.listenInfo.ext..'/';
	end
	self:setStatus(DOWNLOAD_STATUS_FINISH);
	self.downloadHandler(self.gameId);
end


function DownloadThread:setDownloadHandler(handler)
	self.downloadHandler = handler;

end

function DownloadThread:zipFileDown()

	local fileSize = 0;

	local function onMsg(event) 
		if (event.name=="inprogress") then
			return
		end
		print("---------------------");
		var_dump(event);
		print("---------------------");
		
		echoInfo("----------------zipFileDown callback------------%s", event.name);

		local ok = (event.name == "completed")  
		local request = event.request 
	    if ok then
		     
		    if (self.isResumeDownload==false) then
				request:saveResponseData(self.fileCacheName)  
			else
				--断点续传无需保存
			end
		    
		    self:onComplete();
	 	else
	 		echoError("download fail for"..self.url);
	 		echoInfo("fail reason:%s",request:getErrorMessage());
	 		self:onFail();
	 	end
	end

	self.isResumeDownload = false;
	if (DownloadRequest==nil) then
		self.request = CCHTTPRequest:createWithUrl(onMsg,self.url, kCCHTTPRequestMethodGET);
		self.canGetProgress = false;

	else
		self.request = DownloadRequest:createWithUrlLua(onMsg,self.url, kCCHTTPRequestMethodGET);
		self.canGetProgress = true;
		if (self.listener.frameworkVersion>=14090401) then
			--断点续传
			echoInfo("will begain resume download!!!")
			if (io.exists(self.fileCacheName)) then
				-- 文件存在，先检查文件是不是已经下好了
				if (self.listener:checkFile(self.fileCacheName,self.listenInfo.v)) then
					echoInfo("have download the file, onComplete directly")
					self.isResumeDownload = true;
					self:onComplete();
					return;
				else
					echoInfo("Resume Download!!!! %s", self.fileCacheName);
					self.request:setDownloadFilePath(self.fileCacheName)
					self.isResumeDownload = true;
				end
			else
				echoInfo("no resume file to download!!!")
				self.request:setDownloadFilePath(self.fileCacheName)
				self.isResumeDownload = true;
			end
			
		else
			echoInfo("not support resume file!!!")
			--非断点续传,删除旧文件
			if (io.exists(self.fileCacheName)) then
				removeFile(self.fileCacheName);
			end
		end
	end
	self.request:setTimeout(3600);
	self.request:start();  
end

-----------------------------------------------------------------

function ResourceManager:ctor() 
	-- device.writablePath = "/storage/extSdCard/data/";
	if (device.platform=="ios") then
		device.writablePath = device.cachePath;
	end
	echoInfo("INIT ResourceManager");
    self.wifiState = network.isLocalWiFiAvailable();
    self.netState = network.isInternetConnectionAvailable();
    self.downloadPath = device.writablePath .. "download/";
    checkDirOK(self.downloadPath);
    self.isInLazyDownload = false;
    self.fileManager = FileManager:new();
    self.listener = {};
end

function ResourceManager:setFrameworkVersion(frameworkVersion)
	self.frameworkVersion = frameworkVersion;
end

function ResourceManager:checkPlugResource()
    
end

function ResourceManager:removeSearchPath(path)
	-- echoInfo("quick-cocos-2dx don't support this function now : removeSearchPath");
	self.fileManager:removeSearchPath(path);
end

function ResourceManager:checkFile(fileName, cryptoCode)
    
    
    
    if not io.exists(fileName) then
        return false
    end

    if cryptoCode==nil then
        return true
    end

    local ms = self.fileManager:MD5File(fileName);
    print("cryptoCode:", cryptoCode,";file cryptoCode:", ms);

    if ms==cryptoCode or ms=="WTF" then
        return true
    end

    return false
end

function ResourceManager:getNetState()
	self.netState = network.isInternetConnectionAvailable();
	return self.netState;
end

function ResourceManager:getWifiState()
	self.wifiState = network.isLocalWiFiAvailable();
	return self.wifiState
end

function ResourceManager:addBatchLazyDownload(versionFiles,tag,gameId,listener)
	self.listener[gameId] = listener;
	var_dump(self.listener,2);
	local targetPath = device.writablePath .. RESOURCE_PATH .. tag .. gameId .. "/";
	if (not checkDirOK(device.writablePath .. RESOURCE_PATH)) then
		--dispatch error
		self:onError(gameId,{
			ret = -10,
			gameId = gameId,
			msg = '无法创建目录'
		});
		echoError("ResourceManager:CAN'T SET download PATH");
		return;
	end
	
	if (not checkDirOK(targetPath)) then
		--dispatch error
		self:onError(gameId,{
			ret = -10,
			gameId = gameId,
			msg = '无法创建目录'
		});
		echoError("ResourceManager:CAN'T SET download PATH");
		return;
	end
	echoInfo("ResourceManager:addBatchLazyDownload-----------------");

	--cache the version descs
	if (self.downloadInfo==nil) then
		self.downloadInfo = {}
	end
	self.downloadInfo[gameId] = self.downloadInfo[gameId] or versionFiles;

	for name,info in pairs(versionFiles) do
		-- check version first
		local version = self.listener[gameId]:readSubPkgVer(gameId,name);
		if (version==info.v) then
			print("ResourceManager:---same package ".. name .." for "..gameId);
			if (tonumber(self.downloadInfo[gameId][name].type)==0) then
				-- if code is same version, record this
				self.downloadInfo[gameId][name].codeTarget = targetPath..self.downloadInfo[gameId][name].ext..'/'..name..'.zip';
			else
				self.downloadInfo[gameId][name].targetPath = targetPath..self.downloadInfo[gameId][name].ext..'/';
			end
			self.downloadInfo[gameId][name].downloadStatus = DOWNLOAD_STATUS_FINISH;
		else
			if (version==nil) then
				print("ResourceManager:---diff package ".. name .." as nil and new one is "..info.v);
			
			else
				print("ResourceManager:---diff package ".. name .." as "..version.." and new one is "..info.v);
			end
			--for rerun same batch loading, only restart the same one
			if (self.downloadInfo[gameId][name].downloadStatus ~= DOWNLOAD_STATUS_FINISH) then
				
				if (self.downloadInfo[gameId][name].isLazy==1) then
					-- for lazy ones 
					self.downloadInfo[gameId][name].targetPath = targetPath..self.downloadInfo[gameId][name].ext..'/';
					self:addLazyDownload(gameId.."_"..name,self.downloadInfo[gameId][name]);
					self.downloadInfo[gameId][name].downloadStatus = DOWNLOAD_STATUS_FINISH;
				end
			end	
		end
	end
	self.listener[gameId]:onAddLazyBatchFinished(gameId,self.downloadInfo[gameId]);
end

function ResourceManager:prepareBatchDownload(versionFiles,tag,gameId,listener)
	self.listener[gameId] = listener;
	local targetPath = device.writablePath .. RESOURCE_PATH .. tag .. gameId .. "/";
	if (not checkDirOK(device.writablePath .. RESOURCE_PATH)) then
		--dispatch error
		self:onError(gameId,{
			ret = -10,
			gameId = gameId,
			msg = '无法创建目录'
		});
		echoError("ResourceManager:CAN'T SET download PATH");
		return;
	end
	
	if (not checkDirOK(targetPath)) then
		--dispatch error
		self:onError(gameId,{
			ret = -10,
			gameId = gameId,
			msg = '无法创建目录'
		});
		echoError("ResourceManager:CAN'T SET download PATH");
		return;
	end
	echoInfo("ResourceManager:startBatchDownload-----------------");
	--cache the version descs
	if (self.downloadInfo==nil) then
		self.downloadInfo = {}
	end
	self.downloadInfo[gameId] = self.downloadInfo[gameId] or versionFiles;
	for name,info in pairs(versionFiles) do
		
		-- if (info['path'..ID]~=nil) then
		-- 	info.path = info['path'..ID];
		-- end
		-- if (info['v'..ID]~=nil) then
		-- 	info.v = info['v'..ID];
		-- end
		-- check version first
		local version = self.listener[gameId]:readSubPkgVer(gameId,name);
		if (version==info.v) then
			print("ResourceManager:---same package ".. name .." for "..gameId);
			if (tonumber(self.downloadInfo[gameId][name].type)==0) then
				-- if code is same version, record this
				self.downloadInfo[gameId][name].codeTarget = targetPath..self.downloadInfo[gameId][name].ext..'/'..name..'.zip';
			else
				self.downloadInfo[gameId][name].targetPath = targetPath..self.downloadInfo[gameId][name].ext..'/';
			end
			self.downloadInfo[gameId][name].downloadStatus = DOWNLOAD_STATUS_FINISH;
		else
			if (version==nil) then
				print("ResourceManager:---diff package ".. name .." as nil and new one is "..info.v);
			
			else
				print("ResourceManager:---diff package ".. name .." as "..version.." and new one is "..info.v);
			end
			--for rerun same batch loading, only restart the same one
			if (self.downloadInfo[gameId][name].downloadStatus ~= DOWNLOAD_STATUS_FINISH) then
				
				if (self.downloadInfo[gameId][name].isLazy==1) then
					-- for lazy ones 
					self.downloadInfo[gameId][name].targetPath = targetPath..self.downloadInfo[gameId][name].ext..'/';
					self:addLazyDownload(gameId.."_"..name,self.downloadInfo[gameId][name]);
					self.downloadInfo[gameId][name].downloadStatus = DOWNLOAD_STATUS_FINISH;

				else
					echoInfo("ResourceManager:---downloading ".. name .." for "..gameId);
					self.downloadInfo[gameId][name].downloadThread = DownloadThread.new(info.path,gameId,name,targetPath,self);
					self.downloadInfo[gameId][name].downloadThread:setDownloadHandler(handler(self,self.checkBatchFinish));
					self.downloadInfo[gameId][name].downloadThread:setDownloadPath(self.downloadPath);
					self.downloadInfo[gameId][name].downloadThread:setStatus(DOWNLOAD_STATUS_WAIT);
				end
			end	
		end
	end
end

function ResourceManager:startSingleDownload(url,gameId,name,targetPath,downloadPath)
	if (self.downloadInfo==nil) then
		self.downloadInfo = {}
	end
	if (self.downloadInfo.single==nil) then
		self.downloadInfo.single = {}
	end
	self.downloadInfo.single[name].downloadThread = DownloadThread.new(url,gameId,name,targetPath,self);
	self.downloadInfo.single[name].downloadThread:setDownloadPath(downloadPath);
	self.downloadInfo.single[name].downloadThread:setDownloadHandler(handler(self,self.onSingleDownloadFinish));
	self.downloadInfo.single[name].downloadThread:setStatus(DOWNLOAD_STATUS_WAIT);
	self.downloadInfo.single[name].downloadThread:start();
end

function ResourceManager:realStartDownload(gameId,name)
	echoInfo("ResourceManager:realStartDownload(%d,%s)", gameId,name);	
	self.downloadInfo[gameId][name].downloadThread:start();
end

function ResourceManager:getBatchDownloadSize(versionFiles)
	if (device.platform=="windows") then
		return 10000;
	end
	if (self.frameworkVersion<14061101) then
		return 0;
	end
	local totalSize = 0;
	local request = DownloadRequest:create();
	for name,info in pairs(versionFiles) do
		if (info.hasDiff) then
			local thisSize = request:getDownloadFileLenth(info.path);
			totalSize = totalSize + thisSize;
		end
	end
	echoInfo("getBatchDownloadSize total is %f",totalSize);
	return totalSize;
end

function ResourceManager:startBatchDownload(versionFiles,tag,gameId,listener)
	self:prepareBatchDownload(versionFiles, tag, gameId, listener);
	self:checkBatchFinish(gameId);
end

function ResourceManager:checkBatchFinish(gameId)
	local finished = true;
	if (self.downloadInfo[gameId]==nil) then
		return false;
	end
	for k,v in pairs(self.downloadInfo[gameId]) do
		if (v.downloadStatus == DOWNLOAD_STATUS_FAIL) then
			-- anyone has fail ,all fail
			return false;
		end
		if (v.downloadStatus == DOWNLOAD_STATUS_WAIT) then
			self:realStartDownload(gameId,k);
			return false;
		end
		if (v.downloadStatus ~= DOWNLOAD_STATUS_FINISH) then

			finished = false;
		end
	end
	if (finished) then
		-- do sub item write back, move file, unzip files
		self.listener[gameId]:onCheckBatchFinished(gameId,self.downloadInfo[gameId]);
		self.listener[gameId] = nil;
        self.downloadInfo[gameId] = nil;
	end
	return finished;
end

function ResourceManager:onError(gameId,err)
	if (self.listener[gameId]) then
		self.listener[gameId]:onBatchDownloadFinish(err);
		self.listener[gameId] = nil;
	end
end

function ResourceManager:addLazyDownload(tag,ele)
	echoInfo("addLazyDownload:::::for"..tag);
	local lazyDownloads = CCUserDefault:sharedUserDefault():getStringForKey("lazyDownloads");
	if (lazyDownloads == "") then
		lazyDownloads = "{}";
	end
	local lazyList = json.decode(lazyDownloads);
	lazyList[tag] = ele;
	CCUserDefault:sharedUserDefault():setStringForKey("lazyDownloads",json.encode(lazyList));
end

function ResourceManager:setLazyDownload(lazyList)
	CCUserDefault:sharedUserDefault():setStringForKey("lazyDownloads",json.encode(lazyList));
end


function ResourceManager:startLazyDownload()
	echoInfo("startLazyDownload");
	local lazyDownloads = CCUserDefault:sharedUserDefault():getStringForKey("lazyDownloads");
	if (lazyDownloads == "") then
		print "ResourceManager:NOTHING TO LazyDownload..."
		return
	end
	local lazyList = json.decode(lazyDownloads);
	for tag,info in pairs(lazyList) do
		echoVerb("------START LazyDownload For :"..tag);
		self:imgFileDown(info.path,true,function(fileName)
			if (not io.exists(fileName)) then
				gBaseLogic.lobbyLogic:onLazyDownloadFinish(-11,{
					ret = -11,
					tag = tag,
					info = info,
					msg = '资源文件加载失败，请检查网络或稍后重试'
				});
				echoError("ResourceManager:FILE DOWNLOAD FAIL");
				return;
			end
			echoInfo("ResourceManager:---finish download ".. tag);
			-- check file download correct
			if (not self:checkFile(fileName,info.v)) then
				--dispatch error
				gBaseLogic.lobbyLogic:onLazyDownloadFinish(-8,{
					ret = -8,
					tag = tag,
					info = info,
					msg = '资源文件无法对应'
				});
				echoError("ResourceManager:FILE DON'T MATCH!");
				removeFile(fileName);

				
				-- if file don't match, it will deleted and no more download anymore, for maybe old version lazy set, and not finished, and next time config changed, but old lazy will download and mismatch forever.
				lazyList[tag] = nil;
				self:setLazyDownload(lazyList);
				return;
			end
			
			if (not checkDirOK(info.targetPath)) then
				gBaseLogic.lobbyLogic:onLazyDownloadFinish(-10,{
						ret = -10,
						tag = tag,
						info = info,
						msg = '无法创建目录'
					});
				-- if can't create dir, this download failed forever
				lazyList[tag] = nil;
				self:setLazyDownload(lazyList);
				return;
			end
			-- unzip resources						
			echoInfo("ResourceManager:will unzip lazy"..fileName.." to "..info.targetPath);
			self.fileManager:uncompress(fileName, info.targetPath);
			-- removeFile(fileName);
			-- write back to user default
			lazyList[tag] = nil;
			self:setLazyDownload(lazyList);
			-- 成功，
			gBaseLogic.lobbyLogic:onLazyDownloadFinish(1,{
				ret = 1,
				tag = tag,
				info = info,
			});
			
		end)
	end
	self.isInLazyDownload = true;
end

function ResourceManager:fixRealImageExt(fileName,fileExtension) 
	if (self.fileManager.checkImageType==nil) then
		return fileName;
	end
	local typId =self.fileManager:checkImageType(fileName);
	local real_typ = EXT_TYP[typId];
    echoInfo("ResourceManager:fixRealImageExt %d %s %s %s",typId,fileName,real_typ,fileExtension)
    if (typId==0 or real_typ==fileExtension) then
    	return fileName;
    end
    local fileNamePrefix = fileName:sub(1,string.len(fileName)-4);
    local realName = fileNamePrefix..'.'..real_typ;
    echoInfo("ResourceManager:realName %s",realName)
    if (io.exists(realName)) then
    	return realName;
    else
    	self.fileManager:copyFile(fileName,realName);
    end
    return realName;

end

function ResourceManager:imgFileDown(img_url,useCache,calback,failCallBack)
	if img_url == '' or img_url==nil then return end 
	local fileExtension = getUrlExtension(img_url)

	local fileCacheName = (self.downloadPath)..(crypto.md5(img_url)).."."..fileExtension;

	if (io.exists(fileCacheName)) then
		if (fileExtension == "unknown") then
			fileCacheName = self:fixRealImageExt(fileCacheName,fileExtension);
		end
		if (useCache) then
			if (calback) then
	    		calback(fileCacheName)
		    end
			return;
		end
		removeFile(fileCacheName);
	end

	
	local request1 = network.createHTTPRequest(function(event) 
			if (event.name == "inprogress") then
	    		return
	    	end
			local ok = (event.name == "completed")  
		    if ok then
			    local request = event.request  
			    request:saveResponseData(fileCacheName)  ;
			    
			    if (calback) then
			    	if (fileExtension == "unknown") then
						fileCacheName = self:fixRealImageExt(fileCacheName,fileExtension);
					end
			    	calback(fileCacheName)
			    end
			    -- self:refreshNoticeImg(aid,k);
		 	else
		 		echoError("download fail for"..img_url);
		 		if (failCallBack) then
		 			failCallBack(img_url)
		 		end
		 	end
		end, img_url, "GET")  
	request1:setTimeout(60);
	request1:start()  
end

function ResourceManager:checkDlStatus(gameId)
	-- echoInfo("checkDlStatus for %d",gameId);

	if (self.downloadInfo[gameId]==nil) then
		echoInfo("self.downloadInfo[gameId]==nil");
		return;
	end
	--  {
 --     allFilesCount = 
 -- 7  (number)
 --     downloadNow = 
 -- 0  (number)
 --     downloadingNow = 
 -- images  (string)
 --     downloadingFileTotal = 
 -- 0  (number)
 --     downloadTotal = 
 -- 0  (number)
 --     finishedFilesCount = 
 -- 6  (number)
 --     downloadingFile = 
 -- unknown  (string)
 --     downloadingFileNow = 
 -- 0  (number)
 -- },
	local result = {};
	result.allFilesCount = 0;
	result.finishedFilesCount = 0;
	result.downloadingFile = "unknown";
	result.downloadTotal = 0;
	result.downloadNow = 0;
	result.downloadingFileTotal = 0;
	result.downloadingFileNow = 0;
	
	for k,v in pairs(self.downloadInfo[gameId]) do
		result.allFilesCount = result.allFilesCount+1;
		if (v.downloadStatus == DOWNLOAD_STATUS_BEGAN) then
			result.downloadingFile = k;
			v.downloadThread:checkProcess();
			result.downloadingFileTotal = v.downloadThread.dltotal;
			result.downloadingFileNow = v.downloadThread.dlnow;
			

		elseif  (v.downloadStatus == DOWNLOAD_STATUS_FINISH ) then
			result.finishedFilesCount = result.finishedFilesCount+1;
		end
		if (v.downloadThread) then
			if (v.downloadThread.dltotal~=nil and v.downloadThread.dltotal>0) then
				result.downloadNow = result.downloadNow + v.downloadThread.dlnow;
				result.downloadTotal = result.downloadTotal + v.downloadThread.dltotal;
			end
		end
	end
	if (result.downloadingFile == "unknown") then
		-- var_dump(self.downloadInfo[gameId]);
	end
	return result;
end

return ResourceManager;
