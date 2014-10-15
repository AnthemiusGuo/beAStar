local NewDengLuLayer = class("NewDengLuLayer",izx.baseView)

function NewDengLuLayer:ctor(pageName,moduleName,initParam)
	print ("NewDengLuLayer:ctor")
    self.super.ctor(self,pageName,moduleName,initParam);
end


function NewDengLuLayer:onAssignVars()    
	self.rootNode = tolua.cast(self.rootNode,"CCNode");
    -- if nil ~= self["labelLoginTotalDays"] then
    --     self.labelLoginTotalDays = tolua.cast(self["labelLoginTotalDays"],"CCLabelTTF")
    -- end
    -- if nil ~= self["labelLoginMoney"] then
    --     self.labelLoginMoney = tolua.cast(self["labelLoginMoney"],"CCLabelTTF")
    -- end
    -- if nil ~= self["labelNextLoginMoney"] then
    --     self.labelNextLoginMoney = tolua.cast(self["labelNextLoginMoney"],"CCLabelTTF")
    -- end
    -- if nil ~= self["labelVipMoney"] then
    --     self.labelVipMoney = tolua.cast(self["labelVipMoney"],"CCLabelTTF")
    -- end
    -- if nil ~= self["labelVipMoneyKa"] then
    --     self.labelVipMoneyKa = tolua.cast(self["labelVipMoneyKa"],"CCLabelTTF")
    -- end

    if nil ~= self["holderPic1"] then
        self.holderPic1 = tolua.cast(self["holderPic1"],"CCNode")
    end
    if nil ~= self["holderPic2"] then
        self.holderPic2 = tolua.cast(self["holderPic2"],"CCNode")
    end
    print("================================spriteHuoDong")
    if nil ~= self["spriteHuoDong"] then
        print("======spriteHuoDong")
        self.spriteHuoDong = tolua.cast(self["spriteHuoDong"],"CCSprite")
    end
    if nil ~= self["spritePic4"] then
        print("======spritePic4")
        self.spritePic4 = tolua.cast(self["spritePic4"],"CCSprite")
    end

    if nil ~= self["Award1"] then
        self.Award1label = tolua.cast(self["Award1"],"CCLabelTTF")
    end
    if nil ~= self["Award2"] then
        self.Award2label = tolua.cast(self["Award2"],"CCLabelTTF")
    end

    if nil ~= self["btnAward"] then
        self.btnAward = tolua.cast(self["btnAward"],"CCControlButton")
    end
    if nil ~= self["ToBeVip"] then
        self.ToBeVip = tolua.cast(self["ToBeVip"],"CCControlButton")
    end
    -- if nil ~= self["ToBeVip"] then
    --     self.btnVip = tolua.cast(self["btnVip"],"CCControlButton")
    -- end
    if gBaseLogic.lobbyLogic.userData.ply_login_award2_.today_>0 then
        self.btnAward:setEnabled(true)
    else
        local tempString = CCString:create("已领取")
        self.btnAward:setTitleForState(tempString,CCControlStateNormal);
        self.btnAward:setEnabled(false)
    end

    if nil ~= self["labelContent"] then
        self.labelContent = tolua.cast(self["labelContent"],"CCLabelTTF")
    end
    if nil ~= self["labelTitle"] then
        self.labelTitle = tolua.cast(self["labelTitle"],"CCLabelTTF")
    end
       if nil ~= self["labelDate"] then
        self.labelDate = tolua.cast(self["labelDate"],"CCLabelTTF")
    end
end

function NewDengLuLayer:onPressAward()
    print ("NewDengLuLayer:onPressAward")
    izx.baseAudio:playSound("audio_menu");
    -- local tempString = CCString:create("已领取")
    -- self.btnAward:setTitleForState(tempString,CCControlStateNormal);
    self.logic:onSocketLoginAwardReq(); 
    --self.btnAward:setVisible(false);
    local tempString = CCString:create("已领取")
   
    self.btnAward:setTitleForState(tempString,CCControlStateNormal);
    self.btnAward:setEnabled(false)
    gBaseLogic.lobbyLogic.userData.ply_login_award2_.today_ = 0
    -- var_dump(ply_login_award2_.login_award_);
end

function NewDengLuLayer:onPressClose()
    print ("NewDengLuLayer:onPressClose")
    izx.baseAudio:playSound("audio_menu");
    gBaseLogic.sceneManager:removePopUp("NewDengLuLayer");
end

function NewDengLuLayer:OnPressToBeVip()
    print ("NewDengLuLayer:OnPressToBeVip")
    izx.baseAudio:playSound("audio_menu");
    -- local scene = display.getRunningScene()
    -- scene:removeChild(self.rootNode)
    self.ToBeVip:setVisible(false)
    self.logic:gotoVipShop(1); 
    --self:onPressBack();
end

function NewDengLuLayer:onPressGoToMiniGame()
   
    
    print ("NewDengLuLayer:onPressGoToMiniGame")
    izx.baseAudio:playSound("audio_menu");
    --self.logic:onSocketLoginAwardReq(); 
    if gBaseLogic.MBPluginManager.distributions.nominigame==true then        
        izxMessageBox("暂未开放，敬请期待！", "提示")
        return;
    end
    if gBaseLogic.currentState == gBaseLogic.stateInLobby then
        gBaseLogic.sceneManager.currentPage.view:showGameLists(2)
    else
        self.logic:EnterLobby();
        gBaseLogic.scheduler.performWithDelayGlobal(function()
            gBaseLogic.sceneManager.currentPage.view:showGameLists(2)
            end, 1)
    end
    --self:onPressBack();
    gBaseLogic.sceneManager:removePopUp("NewDengLuLayer");
end

function NewDengLuLayer:onPressBack()
    print ("NewDengLuLayer:onPressBack")
    izx.baseAudio:playSound("audio_menu");
    gBaseLogic.sceneManager:removePopUp("NewDengLuLayer");
    
end


-- function NewDengLuLayer:onPressOpenVip()
--     izx.baseAudio:playSound("audio_menu");
--     -- local scene = display.getRunningScene()
--     -- scene:removeChild(self.rootNode)
--     self.logic:gotoVipShop(1);
-- end
function NewDengLuLayer:onInitView()
    print ("NewDengLuLayer:onInitView")
    
end

function NewDengLuLayer:initBaseInfo()
     self.spriteHuoDong:addTouchEventListener(handler(self.spriteHuoDong, self.onTouch))
     --self.spritePic4:addTouchEventListener(handler(self.spritePic4, self.onTouch))

     self.spriteHuoDong:setTouchEnabled(true)
     --self.spritePic4:setTouchEnabled(true)

	local ply_login_award2_ = self.ctrller.data.ply_login_award2_;
    -- var_dump(ply_login_award2_.login_award_);
    local today_ = ply_login_award2_.today_
    local money_ = 0;
    print("NewDengLuLayer:initBaseInfo111");
    var_dump(self.ctrller.data.ply_login_award_)
    -- var_dump(ply_login_award2_.login_award_)
    if ply_login_award2_ then--add key,value
        if today_>#ply_login_award2_.login_award_ then
            today_ = #ply_login_award2_.login_award_
        end
        for k,v in pairs(ply_login_award2_.login_award_) do
            -- {login_days_:1,money_:1000}
            --self:createdaynode(v.login_days_,today_,v.money_)
            if (today_==v.login_days_) then
                money_ = v.money_
            end
        end
    end

    -- vip 部分
    if self.ctrller.data.ply_vip_.status_ == 1 then        
        self.ToBeVip:setEnabled(true);
    else
        self.ToBeVip:setEnabled(true);
        --self.Award2label:setEnabled(false)
        
    end
    self.Award1label:setString("今日登录奖励 "..money_.." 金币！")
    self.Award2label:setString("ViP可再获得 "..self.ctrller.data.ply_vip_.login_award_.." 金币！")
end

function NewDengLuLayer:createdaynode(day,today,money_)
end

--[{"aid":8646,"appid":449,"atime":1398150017,"content":"疯狂四月活动圆满结束，恭喜玩家“危机”获得千足金条大奖，活动获奖详细名单已经在微信公众号进行公布。","imgs":"http://img.cache.bdo.banding.com.cn/ance/春540x260.png","isLoginAnce":0,"pn":"com.izhangxin.ermj.ios.baihe","status":0,"timeStr":"","title":"获奖名单公布"},
function NewDengLuLayer:updateHuoDongInfo(data)
    echoInfo("updateHuoDongInfo!!!");
    var_dump(data);
    self.labelContent:setString(data.content)
    self.labelTitle:setString(data.title)
    self.labelDate:setString(os.date("%Y-%m-%d %H:%M:%S", data.atime))
end

function NewDengLuLayer:Waitingbg()
    local bgTexture = getCCTextureByName("images/TanChu/meiribizuo_di.png")
    self.spriteHuoDong:setTexture(bgTexture)
    self.spritePic4:setTexture(bgTexture)
    self.Award1label:setVisible(true)
    self.Award2label:setVisible(true)
end

function NewDengLuLayer:unWaitingAni(target,opt)
    echoInfo("THANKS TO unWaitingAni ME!!!");
    opt:removeFromParentAndCleanup(true);
    --izxMessageBox("请求服务器失败","网络错误");
    tolua.cast(target:getChildByTag(11),"CCLabelTTF"):setString("请求服务器失败,网络错误")
end

function NewDengLuLayer:loadingAni()
     gBaseLogic.sceneManager:waitingAni(self.holderPic1,self.unWaitingAni,100)
     gBaseLogic.sceneManager:waitingAni(self.holderPic2,self.unWaitingAni,100)
end

function NewDengLuLayer:updateInfo(msg)
    if nil == msg then 
        return 
    end
    self.enblieclick = true;
    var_dump(msg);

    izx.resourceManager:imgFileDown(msg[4].imageUrl,true,function(fileName) 
                if (self~=nil and self.spriteHuoDong~=nil) then
                    self.spriteHuoDong:setTexture(getCCTextureByName(fileName)) ;
                    self.spriteHuoDong:setTextureRect(CCRectMake(0,0,318,180));
                    self.spriteHuoDong:setPosition(ccp(-4,-29));
                    --self.holderPic1:removeChildByTag(100,true)
                    --self.lablecn1:setVisible(false)
                end
                    end)
    izx.resourceManager:imgFileDown(msg[1].imageUrl,true,function(fileName) 
                if (self~=nil and self.spritePic4~=nil) then
                    self.spritePic4:setTexture(getCCTextureByName(fileName)) ;
                    self.spritePic4:setTextureRect(CCRectMake(0,0,318,180));
                    -- self.holderPic2:removeChildByTag(100,true)
                    --self.lablecn1:setVisible(false)
                end
                    end)

end

function NewDengLuLayer:onTouch(event, x, y)
    if self.enblieclick == false then 
        return 
    end
    local id = self:getTag()
    CCUserDefault:sharedUserDefault():setStringForKey("meiribizuo",os.date("%x", os.time()))
    gBaseLogic.sceneManager:removePopUp("NewDengLuLayer");
    -- if 2== id then 
    --     --gBaseLogic.lobbyLogic:showNoticeScene()
    --     print ("Raul-id2")
    --     --gBaseLogic.sceneManager.currentPage.view:showGameLists(2) 
    --     return true
    -- end
    if 1== id then 
        print ("Raul-id1")
        gBaseLogic.lobbyLogic:showNoticeScene()
        return true
    end
    return true
end

function NewDengLuLayer:onAddToScene()
	self.rootNode:setPosition(ccp(display.cx,display.cy));
end

return NewDengLuLayer;