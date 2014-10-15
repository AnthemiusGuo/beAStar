local SceneManager = class("SceneManager")

function SceneManager:ctor() 
    self.currentPage = nil;
    self.lastPage = nil;
    self.inTransition = false;
    self.currentPop = nil;
    self.popUps = {};
end

function SceneManager:addToScene(currentPop,opt)
    
    default_opt = {
        block = false,
        isBlockTouch = true,
        clickMaskToClose = true,
        slideIn = "popup",
        isAddToView = false,
    };
    if (opt == nil) then
        opt = {}
    end
    genParam(opt,default_opt);
    
    local scene;

    if opt.isAddToView then --加到根节点
        scene = self.currentPage.view.rootNode;
    else --加到场景
        scene = self.currentPage.scene;
    end

    local layer = tolua.cast(currentPop.view.rootNode,"CCNode");
    
    

    local targetPageName = self.currentPage.pageName;
    currentPop.targetPageName = targetPageName;
    self.currentPop = currentPop;
    self.popUps[currentPop.pageName] = currentPop;

    if (opt.isBlockTouch==true) then
        currentPop.isBlockTouch = true;
        currentPop.view.maskLayerColor = display.newScale9Sprite("images/bg.png", display.cx,display.cy, CCSizeMake(display.width, display.height));
        
        
        -- 设置处理函数
        function clickMask(event, x, y, prevX, prevY)
            echoInfo(event..":MASK!");
            if (event=="began") then
                return true;
            end
            
            if ((event=="ended") and opt.clickMaskToClose) then
                echoInfo("click MASK to close");
                if (currentPop.view.onPressBack) then
                    currentPop.view:onPressBack();
                else
                    self:removePopUp(currentPop.pageName);
                end
            end 
            return true;
        end
        -- 设置处理函数
        function clickSprite(event, x, y, prevX, prevY) 
            echoInfo(event..":clickSprite!");           
            return true;
        end
        currentPop.view.maskLayerColor:setTouchEnabled(true);
        currentPop.view.maskLayerColor:addTouchEventListener(clickMask);
        layer:setTouchEnabled(true);
        layer:addTouchEventListener(clickSprite);
        scene:addChild(currentPop.view.maskLayerColor);
    end
    scene:addChild(layer);

    local size = layer:getContentSize();
    opt.slideIn = "none";
    print("opt.slideIn:"..opt.slideIn.."=======")
    

    if (opt.slideIn == "popup") then
        layer:setPosition(currentPop.targetX,currentPop.targetY);
        layer:setScale(0.1);
        actions = {};
        actions[#actions + 1] = CCEaseExponentialOut:create(CCScaleTo:create(0.1, 1));
        actions[#actions + 1] = CCCallFunc:create(handler(currentPop.view,currentPop.view.onAddToScene));
        layer:runAction(transition.sequence(actions));
        local fadein = CCFadeIn:create(0.1);  
        layer:runAction(fadein);

    elseif  (opt.slideIn == "bottom") then
        layer:setPositionX(currentPop.targetX);
        layer:setPositionY(0-display.height + size.height);

        actions = {};
        actions[#actions + 1] = CCEaseExponentialOut:create(CCMoveTo:create(0.1, ccp(currentPop.targetX, currentPop.targetY)));
        actions[#actions + 1] = CCCallFunc:create(handler(currentPop.view,currentPop.view.onAddToScene));
        layer:runAction(transition.sequence(actions));
    elseif  (opt.slideIn == "left") then
        
        layer:setPositionY(currentPop.targetY);
        layer:setPositionX(display.width + size.width);

        actions = {};
        actions[#actions + 1] = CCEaseExponentialOut:create(CCMoveTo:create(0.1, ccp(currentPop.targetX, currentPop.targetY)));
        actions[#actions + 1] = CCCallFunc:create(handler(currentPop.view,currentPop.view.onAddToScene));
        layer:runAction(transition.sequence(actions));
    elseif  (opt.slideIn == "right") then
        
        layer:setPositionY(currentPop.targetY);
        layer:setPositionX(0- size.width);

        actions = {};
        actions[#actions + 1] = CCEaseExponentialOut:create(CCMoveTo:create(0.4, ccp(currentPop.targetX, currentPop.targetY)));
        actions[#actions + 1] = CCCallFunc:create(handler(currentPop.view,currentPop.view.onAddToScene));
        layer:runAction(transition.sequence(actions));
    elseif  (opt.slideIn == "up") then
        
        layer:setPositionX(currentPop.targetX);
        layer:setPositionY(display.height + size.height);

        actions = {};
        actions[#actions + 1] = CCEaseExponentialOut:create(CCMoveTo:create(0.4, ccp(currentPop.targetX, currentPop.targetY)));
        actions[#actions + 1] = CCCallFunc:create(handler(currentPop.view,currentPop.view.onAddToScene));
        layer:runAction(transition.sequence(actions));
    else
        layer:setPosition(currentPop.targetX,currentPop.targetY);
        layer:runAction(CCCallFunc:create(handler(currentPop.view,currentPop.view.onAddToScene)));
    end
    
    if opt.block == true then
        self:blockUI()
    end
end

function SceneManager:removePopUps()
    local dismissPageName = self.currentPage.pageName;
    for popupName,v in pairs(self.popUps) do
        if (dismissPageName~=v.targetPageName) then
            self.popUps[popupName]:removePage();
            self.popUps[popupName] = nil;
        end
    end
end

function SceneManager:removePopUp(popupName)
    print("-------SceneManager:removePopUp----------");
    if (self.popUps[popupName]) then
        self.popUps[popupName]:removePage();
        if (self.currentPop and self.currentPop.pageName == popupName) then
            self.currentPop = nil;
        end
        self.popUps[popupName] = nil;

        for key, value in pairs(self.popUps) do  
            self.currentPop = value;
            break;
        end 
    else
        var_dump(popupName);
        var_dump(self.popUps,1);
        print("don't have this ");
    end
end

function SceneManager:enterScene(currentPage,block)
    self.oldPage = self.currentPage;
    self.currentPage = currentPage;

    local sharedDirector = CCDirector:sharedDirector();
    if sharedDirector:getRunningScene() then
        sharedDirector:setDepthTest(false);
        -- local trans;
        -- if (currentPage.slideIn == "left") then
        --     trans = CCTransitionSlideInR:create(0.3, currentPage.scene);
        -- else
        --     trans = CCTransitionSlideInL:create(0.3, currentPage.scene);
        -- end 
        
        -- sharedDirector:replaceScene(trans);
        sharedDirector:replaceScene(currentPage.scene);
        self.currentPage.block = block;
        self.inTransition = true;
        -- for transition page, run after transition finish
        print("for transition page, run after transition finish")
    else
        print("sharedDirector:runWithScene")
        sharedDirector:runWithScene(currentPage.scene);
        if (block) then
            self:blockUI();
        end
        self.inTransition = false;
        -- for first show page, run now! don't need run here,it has event:transition finish runned 
        --currentPage:run();
    end

end

function SceneManager:unblockUI()
    echoInfo("THANKS TO UNBlock ME!!!");
    if self.blockUILayer then
        local blockUILayer = tolua.cast(self.blockUILayer,"CCLayerColor");
        if (blockUILayer) then

          blockUILayer:unregisterScriptTouchHandler()
          blockUILayer:removeFromParentAndCleanup(true);
        end
        self.blockUILayer = nil;
    else 
        if (self.inBlockUI) then
            echoError("WTF!!!!!!!!!WHERE IS THE BLOCKUI?");
        else
            echoInfo("Who do me the favor to have unblock this?");
        end
    end
    self.inBlockUI = false;
end

function SceneManager:onBlockMaskTouch(event,x,y)
    print("onBlockMaskTouch")
    return true
end

function SceneManager:blockUI(opt)
     --scene,autoUnblock
    -- echoError("SceneManager:blockUI")
    -- var_dump(opt)
    echoInfo("Who Block ME!!!");
    -- echoError("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")
    if (opt==nil) then
        opt = {scene = self.currentPage.scene};
    end
    if (opt.scene == nil) then
        echoInfo("blockUI:scene:nil");
        opt.scene = self.currentPage.scene;
    end
    if (opt.scene == nil) then
        echoInfo("Don't get running Scene!!!!!!");
        return;
    end
    local scene = CCDirector:sharedDirector():getRunningScene();
    if (self.inBlockUI) then
        echoInfo("---In Block UI already!");
        self:unblockUI();
    end
    self.inBlockUI = true;



    local blockUILayer;
    if (opt.hasCancel) then
        blockUILayer = display.newScale9Sprite("images/bg.png", display.cx,display.cy, CCSizeMake(display.width, display.height));
    else
        blockUILayer = display.newColorLayer(ccc4(0,0,0,130));
    end
     

    blockUILayer:setTag(1000)
    scene:addChild(blockUILayer);
    blockUILayer:registerScriptTouchHandler(function(event, x, y)
                                                    return self:onBlockMaskTouch(event, x, y)
                                                end, false,-100,true)
    blockUILayer:setTouchEnabled(true);
    local bgSprite;
    if (opt.hasCancel) then
		  if (MAIN_GAME_ID==13) then
				bgSprite = display.newScale9Sprite("images/DengLu/dengludi.png", display.cx,display.cy, CCSizeMake(515, 403));
	        
		  else
			 	bgSprite = display.newScale9Sprite("images/Common/popup_bg_loading.png", display.cx,display.cy, CCSizeMake(353, 209));
		  end
        blockUILayer:addChild(bgSprite);
    end

    local ani;
    if (opt.hasCancel) then
        ani = getAnimation("blockUI");
    else 
        ani = getAnimation("newLoading");
    end
    local frame =  tolua.cast(ani:getFrames():objectAtIndex(0),"CCAnimationFrame"):getSpriteFrame()
    local m_playAni = CCSprite:createWithSpriteFrame(frame);
    m_playAni:setPosition(display.cx,display.cy+30);
    blockUILayer:addChild(m_playAni);
    local msg = "请稍候..."
    if opt.msg~=nil and type(opt.msg) == "string" then
        msg = opt.msg      
        
    end
    local label = CCLabelTTF:create(msg, "", 28);
    label:setFontSize(28);
    label:setColor(ccc3(254,254,254));
    label:setPosition(display.cx,display.cy-55);
    label:setAnchorPoint(cc.p(0.5,0.5));
    label:setDimensions(CCSize(380, 100));
    label:setHorizontalAlignment(kCCTextAlignmentCenter)
    label:setVerticalAlignment(kCCVerticalTextAlignmentCenter)
    blockUILayer:addChild(label);

    if (MAIN_GAME_ID==13) then
		if (opt.hasCancel) then
		    m_playAni:setPosition(display.cx+15,display.cy-15);
		    label:setPosition(display.cx+12,display.cy-20);
		else
		    m_playAni:setPosition(display.cx,display.cy+40);
		    label:setPosition(display.cx,display.cy-50);
		end
     end

    if (opt.autoUnblock==nil or opt.autoUnblock) then
        print("autoUnblock onBlockUIFail")
        local action = CCRepeat:create(CCAnimate:create(ani),6);
        local actionMoveDone = CCCallFuncN:create(onBlockUIFail);
        m_playAni:runAction(transition.sequence({action,CCDelayTime:create(0.2),actionMoveDone}));

    else
        local action = CCRepeatForever:create(CCAnimate:create(ani));
        m_playAni:runAction(action);
    end
    if (opt.hasCancel) then
	     local imgButton = {
                        normal = "images/Common/popup_btn_guanbi.png",
                        pressed = "images/Common/popup_btn_guanbi.png",
                        disabled = "images/Common/popup_btn_guanbi.png",
                    };
		 if (MAIN_GAME_ID==13) then
				imgButton = {
                        normal = "images/TongYong/popup_btn_guanbi1.png",
                        pressed = "images/TongYong/popup_btn_guanbi2.png",
                        disabled = "images/TongYong/popup_btn_guanbi2.png",
                    }
		 end
        local thisuiButton = cc.ui.UIPushButton.new(imgButton , {scale9 = false})
                    -- :setButtonSize(90, 90)
                    -- :setButtonLabel(ui.newTTFLabel({
                    --     text = "取消",
                    --     size = 22
                    -- }))
                    :onButtonClicked(function(event)  
                            if (opt.callback) then
                                opt.callback();
                            end           
                        end)
                    :addTo(bgSprite);
        local bgSpriteSize = bgSprite:getContentSize();
		  if (MAIN_GAME_ID==13) then
	        	thisuiButton:setPosition(bgSpriteSize.width-10,bgSpriteSize.height-90);
         else
				thisuiButton:setPosition(bgSpriteSize.width-28,bgSpriteSize.height-24);
		  end
    end
    
    self.blockUILayer = blockUILayer;
end

--风火轮动画，任意区域中心显示，target:父对象,pfunc：回调函数，动画后的处理,tag：动画的标示id，用于获取动画
function SceneManager:waitingAni(target,pfunc,tag,view)
    local ani = getAnimation("blockUI");
    local frame =  tolua.cast(ani:getFrames():objectAtIndex(0),"CCAnimationFrame"):getSpriteFrame()
    local m_playAni = CCSprite:createWithSpriteFrame(frame);
    local action = CCRepeat:create(CCAnimate:create(ani),6);
    local size = target:getContentSize()
    local actionMoveDone = CCCallFuncN:create(function(opt) 
                if nil ~= pfunc then
                    pfunc(view,target,opt)
                else 
                    opt:removeFromParentAndCleanup(true)
                end
          end)
    m_playAni:setTag(tag)
    m_playAni:setPosition(size.width/2,size.height/2);
    target:addChild(m_playAni);
    m_playAni:runAction(transition.sequence({action,CCDelayTime:create(0.2),actionMoveDone}));

end

return SceneManager;