local MeiRiBiZuoLayer = class("MeiRiBiZuoLayer",izx.baseView)

function MeiRiBiZuoLayer:ctor(pageName,moduleName,initParam)
	print ("MeiRiBiZuoLayer:ctor")
    self.super.ctor(self,pageName,moduleName,initParam);
    self.enblieclick = false
end


function MeiRiBiZuoLayer:onAssignVars() 
    print("MeiRiBiZuoLayer:onAssignVars");
	self.rootNode = tolua.cast(self.rootNode,"CCNode");
    if nil ~= self["holderPic1"] then
        self.holderPic1 = tolua.cast(self["holderPic1"],"CCNode")
    end
    if nil ~= self["holderPic2"] then
        self.holderPic2 = tolua.cast(self["holderPic2"],"CCNode")
    end
    if nil ~= self["holderPic3"] then
        self.holderPic3 = tolua.cast(self["holderPic3"],"CCNode")
    end
    if nil ~= self["holderPic4"] then
        self.holderPic4 = tolua.cast(self["holderPic4"],"CCNode")
    end

    if nil ~= self["spritePic1"] then
        self.spritePic1 = tolua.cast(self["spritePic1"],"CCSprite")
    end
    if nil ~= self["spritePic2"] then
        self.spritePic2 = tolua.cast(self["spritePic2"],"CCSprite")
    end
    if nil ~= self["spritePic3"] then
        self.spritePic3 = tolua.cast(self["spritePic3"],"CCSprite")
    end
    if nil ~= self["spritePic4"] then
        self.spritePic4 = tolua.cast(self["spritePic4"],"CCSprite")
    end

    if nil ~= self["lablecn4"] then
        self.lablecn4 = tolua.cast(self["lablecn4"],"CCLabelTTF")
    end
    if nil ~= self["lablecn3"] then
        self.lablecn3 = tolua.cast(self["lablecn3"],"CCLabelTTF")
    end
    if nil ~= self["lablecn2"] then
        self.lablecn2 = tolua.cast(self["lablecn2"],"CCLabelTTF")
    end
    if nil ~= self["lablecn1"] then
        self.lablecn1 = tolua.cast(self["lablecn1"],"CCLabelTTF")
    end
    print("MeiRiBiZuoLayer:onAssignVars End");
end

function MeiRiBiZuoLayer:onPressBack()
    print ("MeiRiBiZuoLayer:onPressBack")
    izx.baseAudio:playSound("audio_menu");
    CCUserDefault:sharedUserDefault():setStringForKey("meiribizuo",os.date("%x", os.time()))
    gBaseLogic.sceneManager:removePopUp("MeiRiBiZuoLayer");
end

function MeiRiBiZuoLayer:onInitView()
    print ("MeiRiBiZuoLayer:onInitView")
    self:initBaseInfo()
end

function MeiRiBiZuoLayer:initBaseInfo()

    self.spritePic1:addTouchEventListener(handler(self.spritePic1, self.onTouch))
    self.spritePic2:addTouchEventListener(handler(self.spritePic2, self.onTouch))
    self.spritePic3:addTouchEventListener(handler(self.spritePic3, self.onTouch))
    self.spritePic4:addTouchEventListener(handler(self.spritePic4, self.onTouch))

    self.spritePic1:setTouchEnabled(true)
    self.spritePic2:setTouchEnabled(true)
    self.spritePic3:setTouchEnabled(true)
    self.spritePic4:setTouchEnabled(true)

end

function MeiRiBiZuoLayer:onTouch(event, x, y)
    if self.enblieclick == false then 
        return 
    end
    local id = self:getTag()
    CCUserDefault:sharedUserDefault():setStringForKey("meiribizuo",os.date("%x", os.time()))
    gBaseLogic.sceneManager:removePopUp("MeiRiBiZuoLayer");
    if 1== id then 
        --gBaseLogic.lobbyLogic:showNoticeScene()
        gBaseLogic.sceneManager.currentPage.view:showGameLists(2) --小游戏
        return true
    end
    if 2== id then 
        gBaseLogic.lobbyLogic:showTaskScene()
        return true
    end
    if 3== id then 
        gBaseLogic.lobbyLogic:showGoldExchangeScene()
        return true
    end
    if 4== id then 
        gBaseLogic.lobbyLogic:showNoticeScene()
        return true
    end
    return true
end

-- function MeiRiBiZuoLayer:waitingAni(target,pfunc,tag)
--     local ani = getAnimation("blockUI");
--     local frame =  tolua.cast(ani:getFrames():objectAtIndex(0),"CCAnimationFrame"):getSpriteFrame()
--     local m_playAni = CCSprite:createWithSpriteFrame(frame);
--     local action = CCRepeat:create(CCAnimate:create(ani),6);
--     local size = target:getContentSize()
--     local actionMoveDone = CCCallFuncN:create(function(opt) 
--                 if nil ~= pfunc then
--                     pfunc(nil,target,opt)
--                 else 
--                     opt:removeFromParentAndCleanup(true)
--                 end
--           end)
--     m_playAni:setTag(tag)
--     m_playAni:setPosition(size.width/2,size.height/2);
--     target:addChild(m_playAni);
--     m_playAni:runAction(transition.sequence({action,CCDelayTime:create(0.2),actionMoveDone}));

-- end

function MeiRiBiZuoLayer:unWaitingAni(target,opt)
    echoInfo("THANKS TO unWaitingAni ME!!!");
    opt:removeFromParentAndCleanup(true);
    --izxMessageBox("请求服务器失败","网络错误");
    tolua.cast(target:getChildByTag(11),"CCLabelTTF"):setString("请求服务器失败,网络错误")
end

function MeiRiBiZuoLayer:loadingAni()
    gBaseLogic.sceneManager:waitingAni(self.holderPic1,self.unWaitingAni,100)
    gBaseLogic.sceneManager:waitingAni(self.holderPic2,self.unWaitingAni,100)
    gBaseLogic.sceneManager:waitingAni(self.holderPic3,self.unWaitingAni,100)
    gBaseLogic.sceneManager:waitingAni(self.holderPic4,self.unWaitingAni,100)
end

function MeiRiBiZuoLayer:Waitingbg()
    local bgTexture = getCCTextureByName("images/TanChu/meiribizuo_di.png")
    self.spritePic1:setTexture(bgTexture)
    self.spritePic2:setTexture(bgTexture)
    self.spritePic3:setTexture(bgTexture)
    self.spritePic4:setTexture(bgTexture)
    self.lablecn1:setVisible(true)
    self.lablecn2:setVisible(true)
    self.lablecn3:setVisible(true)
    self.lablecn4:setVisible(true)
end

function MeiRiBiZuoLayer:updateInfo(msg)
    if nil == msg then 
        return 
    end
    self.enblieclick = true;
    var_dump(msg);

    izx.resourceManager:imgFileDown(msg[1].imageUrl,true,function(fileName) 
                if (self~=nil and self.spritePic1~=nil) then
                    self.spritePic1:setTexture(getCCTextureByName(fileName)) ;
                    self.spritePic1:setTextureRect(CCRectMake(0,0,318,180));
                    self.holderPic1:removeChildByTag(100,true)
                    self.lablecn1:setVisible(false)
                end
                    end)
    izx.resourceManager:imgFileDown(msg[2].imageUrl,true,function(fileName) 
                if (self~=nil and self.spritePic2~=nil) then
                    self.spritePic2:setTexture(getCCTextureByName(fileName))
                    self.spritePic2:setTextureRect(CCRectMake(0,0,318,180));
                    self.holderPic2:removeChildByTag(100,true)
                    self.lablecn2:setVisible(false)
                end
                    end)
    izx.resourceManager:imgFileDown(msg[3].imageUrl,true,function(fileName) 
                if (self~=nil and self.spritePic3~=nil) then
                    self.spritePic3:setTexture(getCCTextureByName(fileName)) 
                    self.spritePic3:setTextureRect(CCRectMake(0,0,318,180));
                    self.holderPic3:removeChildByTag(100,true)
                    self.lablecn3:setVisible(false)
                end
                    end)
    izx.resourceManager:imgFileDown(msg[4].imageUrl,true,function(fileName) 
                if (self~=nil and self.spritePic4~=nil) then
                    self.spritePic4:setTexture(getCCTextureByName(fileName)) 
                    self.spritePic4:setTextureRect(CCRectMake(0,0,318,180));
                    self.holderPic4:removeChildByTag(100,true)
                    self.lablecn4:setVisible(false)
                end
                    end)

end

function MeiRiBiZuoLayer:onAddToScene()
end

return MeiRiBiZuoLayer;