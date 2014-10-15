local LoadingSceneCode = class("LoadingSceneCode",izx.baseView)

function LoadingSceneCode:ctor(pageName,moduleName,initParam)
	print ("LoadingSceneCode:ctor")
	self.closeLodingScene = 0
    self.super.ctor(self,pageName,moduleName,initParam);
end


function LoadingSceneCode:onPressBack()
	izx.baseAudio:playSound("audio_menu");
	if (gBaseLogic.gameLogic and gBaseLogic.gameLogic.gameSocket) then
		gBaseLogic.gameLogic.gameSocket:close();
	end
    gBaseLogic.lobbyLogic:goBackToMain();
end

function LoadingSceneCode:onAssignVars()
	local logoFileName = gBaseLogic.MBPluginManager:getLogoFile("logoloading");

	-- self.tipsNow = "加载中";
	-- self.oldTipsNow = self.tipsNow;

	
    local bgLayer = display.newLayer();
    local bgSprite;
    local loadingBgScprite;
    local loadingSprite;
    local logoSprite;

	if (MAIN_GAME_ID==13) then

		bgSprite = display.newSprite("images/DengLu/login_bg.jpg",display.cx, display.cy)
		
		loadingBgScprite = display.newSprite("images/DengLu/login_bg6.png",display.cx, display.height*0.25);
		loadingSprite = display.newSprite("images/DengLu/login_pic_jiazai.png",display.cx-50, display.height*0.25);

		logoSprite = display.newSprite(logoFileName,display.cx, display.height*0.55);
		logoSprite:setScale(0.65);
		logoSprite:setAnchorPoint(ccp(0.5,0.0));
		logoSprite:setPositionY(loadingBgScprite:getPositionY() + loadingBgScprite:getContentSize().height/2 + 5);
	elseif (MAIN_GAME_ID==10) then
		--local bgSprite = display.newSprite("images/DengLu/login_bg.jpg",display.cx, display.cy)
		bgSprite = display.newScale9Sprite("images/DengLu/login_bg.jpg", display.cx,display.cy, CCSizeMake(display.width, display.height))
		bgSprite:setInsetLeft(2)
		bgSprite:setInsetRight(2)
		bgSprite:setInsetTop(2)
		bgSprite:setInsetBottom(2) 
		logoSprite = display.newSprite(logoFileName,display.cx, display.height*0.6);
		logoSprite:setScale(0.65);
		loadingBgScprite = display.newSprite("images/DengLu/login_bg3.png",display.cx, display.height*0.3);
		-- loadingSprite = display.newSprite("images/DengLu/login_pic_jiazai.png",display.cx, display.height*0.3+20);

	 	self.loadingBarBg = display.newSprite("images/Common/loading_bg.png", 320, display.height*0.3-39);
	 	local ani = getAnimation("loading_bar_ani");
        local frame =  tolua.cast(ani:getFrames():objectAtIndex(0),"CCAnimationFrame"):getSpriteFrame()
        local m_playAni = CCSprite:createWithSpriteFrame(frame);
        local action = CCRepeatForever:create(transition.sequence({CCAnimate:create(ani)}));
        m_playAni:runAction(action)--CCDelayTime:create(10)
        -- self.beginAnimation:setScale(1.4);
        m_playAni:setAnchorPoint(ccp(0,0));

        local rect = CCRect(0, 0, 497, 22) 
    	self.loadingBarBar = display.newClippingRegionNode(rect)
    	self.loadingBarBar:setPosition(320, display.height*0.3-35)
    	self.loadingBarBar:addChild(m_playAni);

    	local ani2 = getAnimation("loading_bg_ani");
        local frame2 =  tolua.cast(ani2:getFrames():objectAtIndex(0),"CCAnimationFrame"):getSpriteFrame()
        local m_playAni2 = CCSprite:createWithSpriteFrame(frame2);
        local action2 = CCRepeatForever:create(transition.sequence({CCAnimate:create(ani2)}));
        m_playAni2:runAction(action2)--CCDelayTime:create(10)
        -- self.beginAnimation:setScale(1.4);
        m_playAni2:setAnchorPoint(ccp(0,0));
        m_playAni2:setPosition(0,2);
        self.loadingBarBg:addChild(m_playAni2);

	    self.loadingBarBg:setScaleX(1);
	    self.loadingBarBg:setAnchorPoint(ccp(0,0));
	    self.loadingBarBar:setAnchorPoint(ccp(0,0));
	    

	else 
		-- 其他游戏自己实现
	end
		
	local heightDiff = 20;
	self.anis = {};
	self.anis[1] = display.newSprite("images/DengLu/popup_pic_loadzi1.png",display.cx-140, display.height*0.3+heightDiff);
	self.anis[2] = display.newSprite("images/DengLu/popup_pic_loadzi2.png",display.cx-80, display.height*0.3+heightDiff);
	self.anis[3] = display.newSprite("images/DengLu/popup_pic_loadzi3.png",display.cx-20, display.height*0.3+heightDiff);
	self.anis[4] = display.newSprite("images/DengLu/popup_pic_loadzi4.png",display.cx+40, display.height*0.3+heightDiff);
	self.anis[5] = display.newSprite("images/DengLu/popup_pic_loadzi5.png",display.cx+100, display.height*0.3+heightDiff);
	self.anis[6] = display.newSprite("images/DengLu/login_pic_jiazai2.png",display.cx+160, display.height*0.3+heightDiff);
	self.anis[7] = display.newSprite("images/DengLu/login_pic_jiazai2.png",display.cx+180, display.height*0.3+heightDiff);
	self.anis[8] = display.newSprite("images/DengLu/login_pic_jiazai2.png",display.cx+200, display.height*0.3+heightDiff);


	local counter = 1;
	local heightRatio = 0.14;
	if (MAIN_GAME_ID==13) then
		heightRatio = 0.125
	end
	local imgs1 = {
		normal = "images/TanChu/popup_btn_huang1.png",
		pressed = "images/TanChu/popup_btn_huang2.png",
		disabled = "images/TanChu/popup_btn_huang2.png"
	}

	if (MAIN_GAME_ID==13) then
		imgs1 = {
			normal = "images/TongYong/list_btn_huang1.png",
			pressed = "images/TongYong/list_btn_huang2.png",
			disabled = "images/TongYong/list_btn_huang2.png"
		};
	end

	self.btnCancel = cc.ui.UIPushButton.new(
	imgs1
	, {scale9 = true})
    :setButtonSize(120, 60)
    :setButtonLabel(ui.newTTFLabel({
		text = '取消',
        size = 24
    }))
    :onButtonClicked(function(event)
		self:onPressBack();
    end);
	self.btnCancel:setVisible(true);
	self.btnCancel:setPositionX(display.cx);
	self.btnCancel:setPositionY(display.height*heightRatio);

    self.labelHint = ui.newTTFLabel({
        text = self.tipsNow,
        size = 20,
        x = display.cx,
        y = display.bottom+20,
        align = ui.TEXT_ALIGN_CENTER
    });
    

    bgLayer:addChild(bgSprite);
    bgLayer:addChild(logoSprite);
    bgLayer:addChild(loadingBgScprite);
    -- bgLayer:addChild(loadingSprite);
    bgLayer:addChild(self.btnCancel);

    bgLayer:addChild(self.labelHint);
    for k,v in pairs(self.anis) do
    	bgLayer:addChild(v);
    end

    if (self.loadingBarBg~=nil) then
    	bgLayer:addChild(self.loadingBarBg );
		bgLayer:addChild(self.loadingBarBar );
	end
	
    -- 设置处理函数
    self.rootNode:addChild(bgLayer);
    self:showTips();
    self:setLoadingPercent(0);

end

function LoadingSceneCode:onInitView()
	self:initBaseInfo();

end
function LoadingSceneCode:onRemovePage()
	if (self.loadingSchedule) then
		scheduler.unscheduleGlobal(self.loadingSchedule);
	end
	self.closeLodingScene = 1
	for k,v in pairs(self.anis) do
		v:stopAllActions();
	end
   
end
function LoadingSceneCode:initBaseInfo()
	
	
end
function LoadingSceneCode:showAniLoading()
	-- for k,v in pairs(self.anis) do
	-- 	local delay = (k-1)*0.4;
	-- 	actions = {};
	-- 	local px,py = v:getPosition();
	-- 	actions[#actions + 1] = CCDelayTime:create(delay);
	--     actions[#actions + 1] = CCEaseExponentialOut:create(CCMoveTo:create(0.15, ccp(px,py+20)));
	    
	--     actions[#actions + 1] = CCEaseExponentialOut:create(CCMoveTo:create(0.15, ccp(px,py)));

	--     v:runAction(transition.sequence(actions));
	-- end
	for k,v in pairs(self.anis) do
		local delay = (k-1)*0.1;
		actions = {};
		local px,py = v:getPosition();
		actions[#actions + 1] = CCDelayTime:create(delay);
	    actions[#actions + 1] = CCEaseExponentialOut:create(CCMoveTo:create(0.15, ccp(px,py+20)));
	    
	    actions[#actions + 1] = CCEaseExponentialOut:create(CCMoveTo:create(0.15, ccp(px,py)));
	    actions[#actions + 1] = CCDelayTime:create(0.5);

	    v:runAction(transition.sequence(actions));
	end
	
end

function LoadingSceneCode:showLoadingPercent(done,need)
	local length = 0;
	if (need > 0) then
		length = done/need;
	end
	self:setLoadingPercent(length);

end

function LoadingSceneCode:setLoadingPercent(percent)
	local rect = CCRect(0, 0, 497*percent, 22) 
	self.loadingBarBar:setClippingRegion(rect);
end

function LoadingSceneCode:onInitView()
    -- self.loginTypNum
    self.loadingSchedule = scheduler.scheduleGlobal(handler(self,self.onUpdate),  0.5);	
    self:showAniLoading();

end

function LoadingSceneCode:onUpdate(dt)

	if (self.updateCounter == nil) then
		self.updateCounter = 0;
	end
	echoInfo("updateCounter:%d",self.updateCounter);
	self.updateCounter = self.updateCounter+1;
	-- 0.5秒一次时钟,5秒走一次
	if (self.updateCounter>2) then
		self:showAniLoading();
		self.updateCounter = 0;
	end

	if (self.state=="downloading") then
		local packageNames = {interfaces="主界面",interfacesGame="游戏界面",sounds="音效",soundsGame="游戏音效",images="美术资源",imagesGame="游戏美术资源",script="游戏逻辑",unknown="其他资源"};

		local processInfo =	izx.resourceManager:checkDlStatus(self.ctrller.gameId);
		if (self.ctrller.allDownloadSize) then
			processInfo.downloadTotal = self.ctrller.allDownloadSize;
		end
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
			self:showLoadingPercent(processInfo.downloadNow,processInfo.downloadTotal);
			self:setLoadingPercentText(formatSizeK(processInfo.downloadNow,false).."/"..formatSizeK(processInfo.downloadTotal,true));
			-- self:showLabelHint(string.format("正在下载最新%s 文件进度 %d/%d， 当前文件进度 %s/%s , 总下载进度 %s/%s",
			-- 	name,
			-- 	processInfo.finishedFilesCount,processInfo.allFilesCount,
			-- 	formatSize(processInfo.downloadingFileNow),formatSize(processInfo.downloadingFileTotal),
			-- 	formatSize(processInfo.downloadNow),formatSize(processInfo.downloadTotal)));
			self:showLabelHint(string.format("正在下载最新%s",
				name));
		end
	end

end

function LoadingSceneCode:setLoadingPercentText(text)
	if (self.loadingPercentText == nil) then
		local px,py = self.loadingBarBar:getPosition();

		self.loadingPercentText = ui.newTTFLabel({
	        text = "",
	        size = 24,
	        x = px+497,
	        y = py+10,
	        align = ui.TEXT_ALIGN_RIGHT
	    });
	    self.loadingPercentText:setAnchorPoint(ccp(1,0.5));
		self.rootNode:addChild(self.loadingPercentText);

	end;
	self.loadingPercentText:setString(text);
end

function LoadingSceneCode:removeLoadingPercentText()
	if (self.loadingPercentText) then
		self.loadingPercentText:removeFromParentAndCleanup(true);
		self.loadingPercentText = nil;
	end
end

function LoadingSceneCode:showLabelHint(content)
	self.labelHint:setString(content);
end

function LoadingSceneCode:showTips()
	local count = #LOADING_TIPS;
	local index = os.time() % count +1;
	self.labelHint:setString(LOADING_TIPS[index]);
end
 

return LoadingSceneCode;