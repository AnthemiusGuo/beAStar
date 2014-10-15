local UpdaterSceneCode = class("UpdaterSceneCode",izx.baseView)

function UpdaterSceneCode:ctor(pageName,moduleName,initParam)
	print ("UpdaterSceneCode:ctor")
	self.closeLodingScene = 0
    self.super.ctor(self,pageName,moduleName,initParam);
end

function UpdaterSceneCode:onAssignVars()
	require("moduleLobby.logics.PicConfig");
	self.logoFileName = gBaseLogic.MBPluginManager:getLogoFile("logoloading");
	self.tipsNow = "加载中";
	self.oldTipsNow = self.tipsNow;
	self.onUpdateCounter = 0;
	local rootNode = tolua.cast(self.rootNode,"CCLayer");
	rootNode:addKeypadEventListener(function(event)
        if event == "back" then self.logic:exit() end
    end)
    local bgLayer = display.newLayer();
    local bgSprite;
    local loadingBgScprite;
    local loadingSprite;
    local logoSprite;

	if (MAIN_GAME_ID==13) then

		bgSprite = display.newSprite("images/DengLu/login_bg.jpg",display.cx, display.cy)
		
		loadingBgScprite = display.newSprite("images/DengLu/login_bg6.png",display.cx, display.height*0.25);
		-- loadingSprite = display.newSprite("images/DengLu/login_pic_jiazai.png",display.cx-50, display.height*0.25);

		logoSprite = display.newSprite(self.logoFileName,display.cx, display.height*0.55);
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
		logoSprite = display.newSprite(self.logoFileName,display.cx, display.height*0.6);
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
		
    self.tips = ui.newTTFLabel({
        text = self.tipsNow,
        size = 20,
        x = display.cx,
        y = display.bottom+20,
        align = ui.TEXT_ALIGN_CENTER
    });
    self.tips:enableStroke(ccc3(0,0,0), 1, true);

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


    

    bgLayer:addChild(bgSprite);
    bgLayer:addChild(logoSprite);
    bgLayer:addChild(loadingBgScprite);
    -- bgLayer:addChild(loadingSprite);
    -- bgLayer:addChild(self.dian1);
    -- bgLayer:addChild(self.dian2);
    -- bgLayer:addChild(self.dian3);

    bgLayer:addChild(self.tips);

    if (self.loadingBarBg~=nil) then
    	bgLayer:addChild(self.loadingBarBg );
		bgLayer:addChild(self.loadingBarBar );
	end

	for k,v in pairs(self.anis) do
    	bgLayer:addChild(v);
    end

    self.rootNode:addChild(bgLayer);
    self:showHideLoadingBar("hide");


end

function UpdaterSceneCode:onInitView()
	self:initBaseInfo();

end
function UpdaterSceneCode:onRemovePage()
	if (self.loadingSchedule) then
		scheduler.unscheduleGlobal(self.loadingSchedule);
		self.loadingSchedule = nil;
	end
	for k,v in pairs(self.anis) do
		v = tolua.cast(v,"CCNode");
		if (v~= nil ) then
			v:stopAllActions();
		end
	end
	
	self.closeLodingScene = 1
   
end
function UpdaterSceneCode:initBaseInfo()
	
	
end
function UpdaterSceneCode:showAniLoading()
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

function UpdaterSceneCode:setLoadingPercent(percent)
	local rect = CCRect(0, 0, 497*percent, 22) 
	self.loadingBarBar:setClippingRegion(rect);
end

function UpdaterSceneCode:setLoadingPercentText(text)
	if (self.loadingPercentText == nil) then
		local px,py = self.loadingBarBar:getPosition();

		self.loadingPercentText = ui.newTTFLabel({
	        text = "",
	        size = 24,
	        x = display.cx,
	        y = py+10,
	        align = ui.TEXT_ALIGN_CENTER
	    });
	    self.loadingPercentText:setAnchorPoint(ccp(0.5,0.5));
		self.rootNode:addChild(self.loadingPercentText);
		self.loadingPercentText:enableStroke(ccc3(0,0,0), 1, true);
	end;
	self.loadingPercentText:setString(text);
end

function UpdaterSceneCode:showLoadingPercent(done,need)
	local length = 0;
	if (need > 0) then
		length = done/need;
	end
	
	if (length==0 or need==0) then
		self:setLoadingPercent(0);
		return;
	end
	echoInfo("length will be :%d",length*100);
	self:setLoadingPercent(length);
end

function UpdaterSceneCode:onInitView()
    -- self.loginTypNum
    self.loadingSchedule = scheduler.scheduleGlobal(handler(self,self.onUpdate),  0.5);	
    self:showAniLoading();

end

function UpdaterSceneCode:setTips(msg)
	self.tipsNow = msg;
end

function UpdaterSceneCode:onUpdate()
	if (self.updateCounter == nil) then
		self.updateCounter = 0;
	end
	self.updateCounter = self.updateCounter+1;
	-- 0.5秒一次时钟,5秒走一次
	if (self.updateCounter>2) then
		self:showAniLoading();
		self.updateCounter = 0;
	end

	if (self.state=="downloading") then
		local packageNames = {interfaces="主界面",interfacesGame="游戏界面",sounds="音效",soundsGame="游戏音效",images="美术资源",imagesGame="游戏美术资源",script="游戏逻辑",unknown="其他资源"};
		local processInfo =	self.logic.updateManager:checkDownloadStatus();

		local name = packageNames[processInfo.downloadingFile];
		self:showLoadingPercent(processInfo.downloadNow,processInfo.downloadTotal);
		self:setLoadingPercentText(formatSizeK(processInfo.downloadNow,false).."/"..formatSizeK(processInfo.downloadTotal,true));
		self.tipsNow = string.format("正在下载最新%s",name);
	end
	if (self.tipsNow ~= self.oldTipsNow) then
		self.oldTipsNow = self.tipsNow;
		self.tips:setString(self.tipsNow);		
	end
	
	self.onUpdateCounter = self.onUpdateCounter+1;	
end


function UpdaterSceneCode:removeLoadingPercentText()
	if (self.loadingPercentText) then
		self.loadingPercentText:removeFromParentAndCleanup(true);
		self.loadingPercentText = nil;
	end
end

function UpdaterSceneCode:showLabelHint(content)
	self.labelHint:setString(content);
end

function UpdaterSceneCode:showTips()
	local count = #LOADING_TIPS;
	local index = os.time() % count +1;
	self.labelHint:setString(LOADING_TIPS[index]);
end

function UpdaterSceneCode:showRetryCancel(btnList)
	echoInfo("showRetryCancel");
	var_dump(btnList);
	if (self.btnList ==nil) then
		self.btnList = {};
	end
	for k,v in pairs(self.btnList) do
		v:removeFromParentAndCleanup(true);
	end
	self.btnList = {};
	
	local imgs1 = {
		normal = "images/TanChu/popup_btn_huang1.png",
		pressed = "images/TanChu/popup_btn_huang2.png",
		disabled = "images/TanChu/popup_btn_huang2.png"
	}
	local imgs2 = {
		normal = "images/TanChu/popup_btn_lan1.png",
		pressed = "images/TanChu/popup_btn_lan2.png",
		disabled = "images/TanChu/popup_btn_lan2.png"
	}
	if (MAIN_GAME_ID==13) then
		imgs1 = {
			normal = "images/TongYong/list_btn_huang1.png",
			pressed = "images/TongYong/list_btn_huang2.png",
			disabled = "images/TongYong/list_btn_huang2.png"
		};
		imgs2 = {
			normal = "images/TongYong/list_btn_lan1.png",
			pressed = "images/TongYong/list_btn_lan2.png",
			disabled = "images/TongYong/list_btn_lan2.png"
		}
	end
	local counter = #btnList;
	local btnText = {btnRetry = "重试",btnCancel = "取消",btnSingle = "单机游戏",btnUpdate = "升级",btnUpdateCancel="暂不升级",btnUpdateLua = "升级",btnUpdateCancelLua="暂不升级",btnClose="关闭"};
	local btnColor = {btnRetry = imgs1,btnCancel = imgs2,btnSingle = imgs2,btnUpdate = imgs1,btnUpdateCancel=imgs2,btnUpdateLua = imgs1,btnUpdateCancelLua=imgs2,btnClose=imgs2};
	local heightRatio = 0.14;
	if (MAIN_GAME_ID==13) then
		heightRatio = 0.125
	end
	
	for k,v in pairs(btnList) do
		echoInfo("show btn for %s as %s", v,btnText[v]);

		self.btnList[v] = cc.ui.UIPushButton.new(
		btnColor[v]
    	, {scale9 = true})
        :setButtonSize(120, 60)
        :setButtonLabel(ui.newTTFLabel({
			text = btnText[v],
            size = 24
        }))
        :onButtonClicked(function(event)
			echoInfo("pressed onPress%s",v);
            self["onPress"..v](self);
        end);
		self.btnList[v]:setVisible(true);
		self.btnList[v]:setPositionX(display.cx+(k-1)*200-(counter-1)*100);
		self.btnList[v]:setPositionY(display.height*heightRatio);

		self.rootNode:addChild(self.btnList[v]);
	end
end
function UpdaterSceneCode:onPressbtnUpdateLua()
	echoInfo("UpdaterSceneCode:onPressbtnUpdateLua");
	self:showRetryCancel({});
	self:showHideLoadingBar("show");
	scheduler.performWithDelayGlobal(function() self.updateManager:startDownloadLua(); end, 0.1)
	
end

-- function UpdaterSceneCode:onPressbtnUpdateCancelLua()
-- 	echoInfo("UpdaterSceneCode:onPressbtnUpdateCancelLua");
-- 	self:showRetryCancel({});
-- 	scheduler.performWithDelayGlobal(function() self.updateManager:runNextState();
-- 	self:runMain("pre"); end, 0.1)
	
-- end

function UpdaterSceneCode:onPressbtnUpdate()
	echoInfo("UpdaterSceneCode:onPressbtnUpdate");
	if (device.platform=="ios") then
		CCNative:openURL(self.updateInfo.download_url);	
	elseif (device.platform=="android") then
		self:showRetryCancel({});
		self:showHideLoadingBar("show");
		scheduler.performWithDelayGlobal(function() self.updateManager:startDownloadMain(self.updateInfo.download_url); end, 0.1)
	end
end

function UpdaterSceneCode:onPressbtnUpdateCancel()
	echoInfo("UpdaterSceneCode:onPressbtnUpdateCancel");

	self:showRetryCancel({});
	scheduler.performWithDelayGlobal(function() self.updateManager:runNextState(); end, 0.1)
end

function UpdaterSceneCode:onPressbtnRetry()
	echoInfo("UpdaterSceneCode:onPressbtnRetry");
	
	self.onDealFail = false;
	
	self:showRetryCancel({});
	scheduler.performWithDelayGlobal(function() self.updateManager:runSameState(); end, 0.1)
end

function UpdaterSceneCode:onPressbtnCancel()
	self.onDealFail = false;
	echoInfo("UpdaterSceneCode:onPressbtnCancel")
	self:runMain("pre");
end

function UpdaterSceneCode:onPressbtnClose()
	self.onDealFail = false;
	echoInfo("UpdaterSceneCode:onPressbtnClose")
	self:exit()
end

function UpdaterSceneCode:onPressbtnSingle()
	self.onDealFail = false;
	self:showRetryCancel({});
	echoInfo("UpdaterSceneCode:onPressbtnSingle");
	if (self.updateManager.mainGameCfg.code==nil or self.updateManager.mainGameCfg.code=="") then
		self:runMain("pre",false);
	else
		if (io.exists(self.updateManager.mainGameCfg.code)) then
			self:runMain("download",false);
		else
			self:runMain("pre",false);
		end
	end
end


function UpdaterSceneCode:showHideLoadingBar(showHide)
	local heightDiff = 20;
	if (showHide=="hide") then
		heightDiff = 0;
		self.loadingBarBg:setVisible(false);
		self.loadingBarBar:setVisible(false);
		
	else
		self.loadingBarBg:setVisible(true);
		self.loadingBarBar:setVisible(true);
	end

	for k,v in pairs(self.anis) do
		v:stopAllActions();
    	v:setPositionY(display.height*0.3+heightDiff);
    end



end

return UpdaterSceneCode;