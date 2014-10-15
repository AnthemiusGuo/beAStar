local LoadingScene = class("LoadingScene",izx.baseView)

function LoadingScene:ctor(pageName,moduleName,initParam)
	print ("LoadingScene:ctor")
	self.closeLodingScene = 0
    self.super.ctor(self,pageName,moduleName,initParam);
end


function LoadingScene:onPressBack()
	izx.baseAudio:playSound("audio_menu");
	if (gBaseLogic.gameLogic and gBaseLogic.gameLogic.gameSocket) then
		gBaseLogic.gameLogic.gameSocket:close();
	end
    gBaseLogic.lobbyLogic:goBackToMain();
end

function LoadingScene:onAssignVars()
	--var_dump(self);
	self.rootNode = tolua.cast(self.rootNode,"CCNode");
	if nil ~= self["labelHint"] then
		self.labelHint = tolua.cast(self["labelHint"],"CCLabelTTF")
    end
    if nil ~= self["btnCancel"] then
		self.btnCancel = tolua.cast(self["btnCancel"],"CCControlButton")
    end
    if nil ~= self["btnCancelText"] then
		self.btnCancelText = tolua.cast(self["btnCancelText"],"CCSprite")
    end
  --   if nil ~= self["dian2"] then
  --   	print("====dian2")
		-- self.dian2 = tolua.cast(self["dian2"],"CCSprite")
  --   end
  --   if nil ~= self["dian3"] then
  --   	print("====dian3")
		-- self.dian3 = tolua.cast(self["dian3"],"CCSprite")
  --   end
    if nil ~= self["spriteLogo"] then
    	print("=============spriteLogo")
		self.spriteLogo = tolua.cast(self["spriteLogo"],"CCSprite")
		gBaseLogic.MBPluginManager:replacelogo("logoloading",self.spriteLogo)
		-- self.labelStringMsg:setString(gBaseLogic.MBPluginManager:replaceText(t_string))
    end 
 --    self.dian1:setVisible(false)
	-- self.dian2:setVisible(false)
	-- self.dian3:setVisible(false)

    self.btnCancel:setVisible(false);
    self.btnCancelText:setVisible(false);
    self.state = "init";

    self.loadingBarBg = display.newSprite("images/Common/loading_bg.png", 184, display.height*0.05+20);
    self.loadingBarBar = display.newSprite("images/Common/loading_bar.png", 188, display.height*0.05+24);
    self.loadingBarBg:setScaleX(1);
    self.loadingBarBar:setScaleX(0);
    self.loadingBarBg:setAnchorPoint(ccp(0,0));
    self.loadingBarBar:setAnchorPoint(ccp(0,0));

    self.rootNode:addChild(self.loadingBarBg );
    self.rootNode:addChild(self.loadingBarBar );

end

function LoadingScene:onInitView()
	self:initBaseInfo();

end
function LoadingScene:onRemovePage()
	self.closeLodingScene = 1
   
end
function LoadingScene:initBaseInfo()
	local numD = 0  
	print("LoadingScene:initBaseInfo")
	local function loadingDian()
		print(self.state);
		if (self.state=="downloading") then
			local packageNames = {interfaces="主界面",interfacesGame="游戏界面",sounds="音效",soundsGame="游戏音效",images="美术资源",imagesGame="游戏美术资源",script="游戏逻辑",unknown="其他资源"};

			local processInfo =	izx.resourceManager:checkDlStatus(self.ctrller.gameId);
			if (processInfo==nil) then
				echoInfo("no onProgress info for %d", self.ctrller.gameId);
			else
				echoInfo("LoadingScene:onProgress %d/%d %d/%d %d/%d for %s", processInfo.finishedFilesCount,processInfo.allFilesCount,processInfo.downloadNow,processInfo.downloadTotal,
				processInfo.downloadingFileNow,
				processInfo.downloadingFileTotal,processInfo.downloadingFile);

				local name = packageNames[processInfo.downloadingFile];
			-- local percentInfo = processInfo.info[processInfo.nowdl];
			-- local percent = 0 ;
			-- if (percentInfo.total>0) then
			-- 	percent = percentInfo.now / percentInfo.total * 100;
			-- end
				self:showLoadingPercent(processInfo.downloadingFileNow,processInfo.downloadingFileTotal);
				-- self:showLabelHint(string.format("正在下载最新%s 文件进度 %d/%d， 当前文件进度 %s/%s , 总下载进度 %s/%s",
				-- 	name,
				-- 	processInfo.finishedFilesCount,processInfo.allFilesCount,
				-- 	formatSize(processInfo.downloadingFileNow),formatSize(processInfo.downloadingFileTotal),
				-- 	formatSize(processInfo.downloadNow),formatSize(processInfo.downloadTotal)));
				self:showLabelHint(string.format("正在下载最新%s",
					name));
			end
		end		
		-- remove diandiandian animation from 307 ddz, guojia
		-- if self.closeLodingScene == 0 then
		-- 	if numD%3==0 then
		-- 		self.dian2:setVisible(false)
		-- 		self.dian3:setVisible(false)
		-- 	elseif numD%3==1 then
		-- 		self.dian2:setVisible(true)
		-- 		self.dian3:setVisible(false)
		-- 	elseif numD%3==2 then
		-- 		self.dian2:setVisible(true)
		-- 		self.dian3:setVisible(true)
			
		-- 	end
		-- end
		gBaseLogic.scheduler.performWithDelayGlobal(function()
			numD = numD+1;
			if (self.closeLodingScene == 0) then
				loadingDian()
			end
		end, 0.1)
	end
	loadingDian()
	
end

function LoadingScene:showLoadingPercent(done,need)
	local length = 0;
	if (need > 0) then
		length = done/need;
	end
	
	if (length==0 or need==0) then
		self.loadingBarBar:stopAllActions();
		self.loadingBarBar:setScaleX(0);
		return;
	end
	if (self.loadingBarBar:numberOfRunningActions()>0) then
		return;
	end
	echoInfo("length will be :%d",length*100);
	local actions = {};
	actions[#actions + 1] = CCEaseExponentialOut:create(CCScaleTo:create(0.5,length,1));
	self.loadingBarBar:stopAllActions();
	self.loadingBarBar:runAction(transition.sequence(actions));
end

function LoadingScene:showLabelHint(content)
	self.labelHint:setString(content);
end

return LoadingScene;