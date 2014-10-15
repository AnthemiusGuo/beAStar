local QianDaoLayer = class("QianDaoLayer",izx.baseView)

function QianDaoLayer:ctor(pageName,moduleName,initParam)
	print ("QianDaoLayer:ctor")
    self.initTab  = initParam.type;
    self.ccbState = 0 
    self.scheduler = nil
    self.super.ctor(self,pageName,moduleName,initParam);
end


function QianDaoLayer:onAssignVars()    
	self.rootNode = tolua.cast(self.rootNode,"CCNode");

    if nil ~= self["labelMonth"] then
        self.labelMonth = tolua.cast(self["labelMonth"],"CCLabelTTF")
    end
    if nil ~= self["labelDay"] then
        self.labelDay = tolua.cast(self["labelDay"],"CCLabelTTF")
    end

    if nil ~= self["labelVipMoney"] then
        self.labelVipMoney = tolua.cast(self["labelVipMoney"],"CCLabelTTF")
    end 
    if nil ~= self["labelKeBuQian"] then
        self.labelKeBuQian = tolua.cast(self["labelKeBuQian"],"CCLabelTTF")
    end 
    if nil ~= self["labelBuQianKa"] then
        self.labelBuQianKa = tolua.cast(self["labelBuQianKa"],"CCLabelTTF")
    end 
    if nil ~= self["labelAward1"] then
        self.labelAward1 = tolua.cast(self["labelAward1"],"CCLabelTTF")
    end 
    if nil ~= self["labelAward2"] then
        self.labelAward2 = tolua.cast(self["labelAward2"],"CCLabelTTF")
    end 
    if nil ~= self["labelAward3"] then
        self.labelAward3 = tolua.cast(self["labelAward3"],"CCLabelTTF")
    end 
    if nil ~= self["labelAward4"] then
        self.labelAward4 = tolua.cast(self["labelAward4"],"CCLabelTTF")
    end 
    if nil ~= self["labelJinDu"] then
        self.labelJinDu = tolua.cast(self["labelJinDu"],"CCLabelTTF")
    end 
    if nil ~= self["labelRiLiDay"] then
        self.labelJinDu = tolua.cast(self["labelJinDu"],"CCLabelTTF")
    end 
    if nil ~= self["labelMoney"] then
        self.labelMoney = tolua.cast(self["labelMoney"],"CCLabelTTF")
    end 
    if nil ~= self["labelCount"] then
        self.labelCount = tolua.cast(self["labelCount"],"CCLabelTTF")
    end 
    if nil ~= self["labelGift"] then
        self.labelGift = tolua.cast(self["labelGift"],"CCLabelTTF")
    end 
    if nil ~= self["labelDou"] then
        self.labelDou = tolua.cast(self["labelDou"],"CCLabelTTF")
    end 
    if nil ~= self["nodeDayDongHua"] then
        self.nodeDayDongHua = tolua.cast(self["nodeDayDongHua"],"CCNode")
    end
    if nil ~= self["nodeRiLiDay"] then
        self.nodeRiLiDay = tolua.cast(self["nodeRiLiDay"],"CCNode")
    end
    if nil ~= self["nodeRiLiDay2"] then
        self.nodeRiLiDay2 = tolua.cast(self["nodeRiLiDay2"],"CCNode")
    end
    if nil ~= self["nodeRiLiDay3"] then
        self.nodeRiLiDay3 = tolua.cast(self["nodeRiLiDay3"],"CCNode")
    end 
    if nil ~= self["ccbJiangLiInfo"] then
        self.ccbJiangLiInfo = tolua.cast(self["ccbJiangLiInfo"],"CCNode")
    end 
    -- if nil ~= self["nodeTab1"] then
    --     self.nodeTab1 = tolua.cast(self["nodeTab1"],"CCNode")
    -- end 
    -- if nil ~= self["nodeTab2"] then
    --     self.nodeTab2 = tolua.cast(self["nodeTab2"],"CCNode")
    -- end 
    
    if nil ~= self["spriteBaoXiang1"] then
        self.spriteBaoXiang1 = tolua.cast(self["spriteBaoXiang1"],"CCSprite")
    end 
    if nil ~= self["spriteBaoXiang2"] then
        self.spriteBaoXiang2 = tolua.cast(self["spriteBaoXiang2"],"CCSprite")
    end 
        if nil ~= self["spriteBaoXiang3"] then
        self.spriteBaoXiang3 = tolua.cast(self["spriteBaoXiang3"],"CCSprite")
    end 
        if nil ~= self["spriteBaoXiang4"] then
        self.spriteBaoXiang4 = tolua.cast(self["spriteBaoXiang4"],"CCSprite")
    end 

    if nil ~= self["spriteYiLingQu1"] then
        self.spriteYiLingQu1 = tolua.cast(self["spriteYiLingQu1"],"CCSprite")
    end
    if nil ~= self["spriteYiLingQu2"] then
        self.spriteYiLingQu2 = tolua.cast(self["spriteYiLingQu2"],"CCSprite")
    end 
    if nil ~= self["spriteYiLingQu3"] then
        self.spriteYiLingQu3 = tolua.cast(self["spriteYiLingQu3"],"CCSprite")
    end 
    if nil ~= self["spriteYiLingQu4"] then
        self.spriteYiLingQu4 = tolua.cast(self["spriteYiLingQu4"],"CCSprite")
    end 
    if nil ~= self["spriteJinDu"] then
        self.spriteJinDu = tolua.cast(self["spriteJinDu"],"CCSprite")
    end 

    if nil ~= self["btnQianDao"] then
        self.btnQianDao = tolua.cast(self["btnQianDao"],"CCControlButton")
    end
    
    -- if gBaseLogic.lobbyLogic.userData.ply_login_award2_.today_>0 then
    --     self.btnAward:setEnabled(true)
    -- else
    --     local tempString = CCString:create("已领取")
    --     self.btnAward:setTitleForState(tempString,CCControlStateNormal);
    --     self.btnAward:setEnabled(false)
    -- end
    if (gBaseLogic.MBPluginManager.distributions.skipbuyitem) then
    	self.btnBuyItem:setVisible(false);
    end

end

function QianDaoLayer:hideTab(tab)
    if tab == 1 then 
        self.nodeTab1:setVisible(false)
        self.btnTab1:setHighlighted(true)
        self.labelTab1:setColor(ccc3(255,255,255))
    elseif tab == 2 then 
        self.nodeTab2:setVisible(false)
        self.btnTab2:setHighlighted(true)
        self.labelTab2:setColor(ccc3(255,255,255))
    end
end 

function QianDaoLayer:showTab(tab)
    if tab == 1 then 
        self.nodeTab1:setVisible(true)
        self.btnTab1:setHighlighted(false)
        self.labelTab1:setColor(ccc3(250,116,123))
    elseif tab == 2 then 
        self.nodeTab2:setVisible(true)
        self.btnTab2:setHighlighted(false)
        self.labelTab2:setColor(ccc3(250,116,123))
    end
end 

function QianDaoLayer:onPressQianDaoTab()
    print ("QianDaoLayer:onPressQianDaoTab")
    izx.baseAudio:playSound("audio_menu");
    if self.initTab ~= 1 then 
        self:hideTab(self.initTab)
        self.initTab = 1
        self:showTab(self.initTab)
    end
end

function QianDaoLayer:onPressHuoDongTab()
    print ("QianDaoLayer:onPressHuoDongTab")
    izx.baseAudio:playSound("audio_menu");
    if self.initTab ~= 2 then 
        self:hideTab(self.initTab)
        self.initTab = 2
        self:showTab(self.initTab)
        self:updateHuoDongInfo(self.ctrller.data.anceInfo)
    end
end 

function QianDaoLayer:onPressBack()
    self:onPressClose();
end

function QianDaoLayer:onPressClose()
    print ("QianDaoLayer:onPressClose")
    izx.baseAudio:playSound("audio_menu");
    gBaseLogic.sceneManager:removePopUp("QianDaoLayer");
end

function QianDaoLayer:onPressKaPay()
    print("QianDaoLayer:OnPressKaPay")
    izx.baseAudio:playSound("audio_menu");
   
    self.ctrller:getQianDaoKaPayInfo()

end

function QianDaoLayer:onPressVipPay()
    print ("QianDaoLayer:onPressVipPay")
    izx.baseAudio:playSound("audio_menu");
    self.logic:gotoVipShop(1); 
    gBaseLogic.sceneManager:removePopUp("QianDaoLayer");
end

function QianDaoLayer:onPressQianDao()
    print ("QianDaoLayer:onPressQianDao")
    izx.baseAudio:playSound("audio_menu");
    print(self.ctrller.data.curday,self.ctrller:getQianDaoState(self.ctrller.data.curday))
    if self.ctrller:getQianDaoState(self.ctrller.data.curday) == 2 then
        local buqian = self.ctrller:getReSigninDay()
        print("getReSigninDay:"..buqian)
        if buqian > 0 then  
            self.ctrller:pt_cl_set_user_signin_days_req(buqian)
        end
    else 
        self.ctrller:pt_cl_set_user_signin_days_req(self.ctrller.data.curday) 
    end 

    --gBaseLogic.sceneManager:removePopUp("QianDaoLayer");
    
end

function QianDaoLayer:onPressLianXu(idx)
    local signin_award = self.ctrller.data.signin_award[idx]
    local today = self.ctrller.data.today
    --local today = self.ctrller:getMaxContinuedSigninDays()
    local sprite = self["spriteYiLingQu"..idx]
    if sprite:isVisible() == false and today == self.ctrller.data.totalDay then 
        self.ccbJiangLiInfo:setVisible(false)
        --self.ctrller:pt_cl_get_user_signin_award_req(self.ctrller.data.awarddays[idx])
        self.ctrller:pt_cl_get_user_signin_award_req(self.ctrller.data.signin_award[idx].days_)
        return
    end

    if sprite:isVisible() == false and today >= self.ctrller.data.awarddays[idx] and idx ~= 4 then 
        self.ccbJiangLiInfo:setVisible(false)
        self.ctrller:pt_cl_get_user_signin_award_req(self.ctrller.data.awarddays[idx])
    else
        if self.ccbJiangLiInfo:isVisible() == true then 
            if self.ccbState == idx then
                self.ccbJiangLiInfo:setVisible(false)
            else 
                self.ccbState = idx
                self.ccbJiangLiInfo:setPositionX(sprite:getPositionX())
                self.labelMoney:setString(signin_award.money_) 
                self.labelCount:setString(signin_award.count_) 
                self.labelGift:setString(signin_award.gift_) 
                self.labelDou:setString(signin_award.index_)
                if signin_award.gift_ <= 0 then
                    self.labelGift:setVisible(false)
                    self.labelGift1:setVisible(false)
                else 
                    self.labelGift:setVisible(true)
                    self.labelGift1:setVisible(true)
                end                
            end
        else 
            self.ccbState = idx
            self.ccbJiangLiInfo:setVisible(true)
            self.ccbJiangLiInfo:setPositionX(sprite:getPositionX())
            self.labelMoney:setString(signin_award.money_) 
            self.labelCount:setString(signin_award.count_) 
            self.labelGift:setString(signin_award.gift_) 
            self.labelDou:setString(signin_award.index_)
            if signin_award.gift_ <= 0 then
                self.labelGift:setVisible(false)
                self.labelGift1:setVisible(false)
            else 
                self.labelGift:setVisible(true)
                self.labelGift1:setVisible(true)
            end
        end 
    end
end 

function QianDaoLayer:onPressLianXuFive()
    print ("QianDaoLayer:onPressLianXuFive")
    izx.baseAudio:playSound("audio_menu");
    self:onPressLianXu(1)
end 

function QianDaoLayer:onPressLianXuTen()
    print ("QianDaoLayer:onPressLianXuTen")
    izx.baseAudio:playSound("audio_menu");
    self:onPressLianXu(2)
end 

function QianDaoLayer:onPressLianXuFifteen()
    print ("QianDaoLayer:onPressLianXuFifteen")
    izx.baseAudio:playSound("audio_menu");
    self:onPressLianXu(3)
end 

function QianDaoLayer:onPressLianXuMonth()
    print ("QianDaoLayer:onPressLianXuMonth")
    izx.baseAudio:playSound("audio_menu");
    self:onPressLianXu(4)
end

function QianDaoLayer:initTabState()
    if self.initTab == 1 then 
        self:hideTab(2)
        self:showTab(1)
    elseif self.initTab == 2 then
        self:hideTab(1)
        self:showTab(2)
        self:updateHuoDongInfo(self.ctrller.data.anceInfo)
    end
end

function QianDaoLayer:onInitView()
    print("QianDaoLayer:onInitView",self.initTab)
    
    self:initTabState()
    --self:initBaseInfo()
    self.labelVipMoney:setString("普通用户签到获得1千游戏币VIP最多额外获得1万") 
end

function QianDaoLayer:initBaseInfo()
    print("QianDaoLayer:initBaseInfo")
    
    self.labelMonth:setString(self.ctrller.data.curmonth)
    --self.labelVipMoney:setString(self.ctrller.data.ply_vip.login_award_) 

    self:initDaily()
    self:initLianXuDays()
    self:changeQianDaoBtnState()
    self:changeYiLingQuState()
    self:changeLianXuState()
    self:changeGiftBoxState()
end 

function QianDaoLayer:initLianXuDays()
    local awarddays = self.ctrller.data.awarddays
    local num = #awarddays
    if num > 0 then
        self.labelAward1:setString("连续"..awarddays[1].."天")
        self.labelAward2:setString("连续"..awarddays[2].."天")
        self.labelAward3:setString("连续"..awarddays[3].."天")
        --self.labelAward4:setString("连续"..awarddays[4].."天")
        self.labelAward4:setString("满月")
        --self.labelAward1:enableStroke(ccc3(0,0,0), 1, true);
        --self.labelAward2:enableStroke(ccc3(0,0,0), 1, true);
        --self.labelAward3:enableStroke(ccc3(0,0,0), 1, true);
        --self.labelAward4:enableStroke(ccc3(0,0,0), 1, true);
        self.labelAward1:enableShadow(CCSizeMake(1, 1), 1, 0.5, true)
        self.labelAward2:enableShadow(CCSizeMake(1, 1), 1, 0.5, true)
        self.labelAward3:enableShadow(CCSizeMake(1, 1), 1, 0.5, true)
        self.labelAward4:enableShadow(CCSizeMake(1, 1), 1, 0.5, true)
    end 

end 
function QianDaoLayer:changeGiftBoxState()
    if #self.ctrller.data.signin_days == 0 then 
        return 
    end

    local awarddays = self.ctrller.data.awarddays
    local today = self.ctrller.data.today
    local totalDay = self.ctrller.data.totalDay
    local curday = self.ctrller.data.curday
    print("changeGiftBoxState,today:",today,"curday:",curday)
    for k,v in pairs(awarddays) do 
        if v > today then 
            local day = v
            if self.ctrller:getQianDaoState(curday) == 2 then
                day = curday + v - today 
            else 
                day = curday -1 + v - today
            end
            if day <= totalDay then 
                self:showGiftBox(self.nodeRiLi,day,v)
            end
        end
    end
end 

function QianDaoLayer:changeQianDaoBtnState()
    if #self.ctrller.data.signin_days == 0 then 
        return 
    end
    if self.ctrller:getQianDaoState(self.ctrller.data.curday) == 1 then 
        self.btnQianDao:setTitleForState(CCString:create("签到"),CCControlStateNormal);
        self.btnQianDao:setEnabled(true)
    else 
        self.btnQianDao:setTitleForState(CCString:create("补签"),CCControlStateNormal);
        self.btnQianDao:setEnabled(true)
        if self.ctrller.data.buqianka <= 0 or self.ctrller.data.kebuqian <= 0 then 
            self.btnQianDao:setEnabled(false)
        end 
    end  
end   

function QianDaoLayer:changeLianXuState()
    if #self.ctrller.data.awarddays == 0 then 
        return 
    end
    local today = self.ctrller.data.today
    self.labelDay:setString(today)

    self.spriteJinDu:setScaleX(self.ctrller:getJinDuScale())
    self.labelJinDu:setString(today.."/"..self.ctrller.data.totalDay)

    self.labelKeBuQian:setString(self.ctrller.data.kebuqian) 
    self.labelBuQianKa:setString(self.ctrller.data.buqianka)

    if self.ctrller.data.today >= self.ctrller.data.awarddays[1] then 
        self.spriteBaoXiang1:setVisible(true) 
    end 
    if self.ctrller.data.today >= self.ctrller.data.awarddays[2] then 
        self.spriteBaoXiang2:setVisible(true)
    end 
    if self.ctrller.data.today >= self.ctrller.data.awarddays[3] then 
        self.spriteBaoXiang3:setVisible(true)
    end 
    
    --if self.ctrller.data.today >= self.ctrller.data.totalDay then 
    if self.ctrller.data.today >= self.ctrller.data.awarddays[4] then 
        self.spriteBaoXiang4:setVisible(true)
    end
end 

function QianDaoLayer:changeYiLingQuState()
    local signin_award = self.ctrller.data.signin_award
    for k,v in pairs(signin_award) do 
        if self.ctrller:getAwardState(v.days_) == 0 then 
            self["spriteYiLingQu"..k]:setVisible(false)
        else 
            self["spriteYiLingQu"..k]:setVisible(true) 
        end  
    end
end 

function QianDaoLayer:createDaily(target,state,day,x,y)
    if target:getChildByTag(day) ~= nil then 
        return 
    end 

    local nodeDay = CCLabelTTF:create(day, "Helvetica", 24)
    nodeDay:setPosition(ccp(x,y))
    nodeDay:setTag(day)
    target:addChild(nodeDay) 

    if state == true then 
        nodeDay:setColor(ccc3(255,255,255))--ccc3(255,186,189)
    else 
        nodeDay:setColor(ccc3(255,186,189))
    end 
    
end 

function QianDaoLayer:createQianDaoDay(target,state,day,x,y)
    if target:getChildByTag(day+100) ~= nil then 
        return 
    end 

function onTouch(target,event,x,y)
    print("+++++++++++++++++++onTouch:"..target:getTag()-100)
    if (event=="began") then 
            echoInfo(event..":Icon!");
            return true;
        end
        if (event=="ended") then
            echoInfo(event..":Icon!");
            --gBaseLogic.lobbyLogic.FreeCoinLayer.view:onPressBtn(target) 
            self.ctrller:pt_cl_set_user_signin_days_req(target:getTag()-100)         
            return true;
        end

        return true;
end

    local qianDaoIcon = nil
 
    if state == 2 then 
        local ani = getAnimation("ani_qiandao","donghua");
        if nil == ani then return end 
        local frame =  tolua.cast(ani:getFrames():objectAtIndex(3),"CCAnimationFrame"):getSpriteFrame()
        qianDaoIcon = CCSprite:createWithSpriteFrame(frame)
    else 
        if day == self.ctrller.data.curday then 
            return
        end 
        qianDaoIcon =  CCSprite:create("images/TanChu/popup_pic_buqian.png")
        qianDaoIcon:setTouchEnabled(true);
        qianDaoIcon:addTouchEventListener(handler(qianDaoIcon, onTouch)) 

        target:getChildByTag(day):setVisible(false)
    end 
    qianDaoIcon:setPosition(ccp(x,y))
    qianDaoIcon:setTag(day+100)
    target:addChild(qianDaoIcon) 
end 


function QianDaoLayer:initDaily()
    local totalDay = self.ctrller.data.totalDay
    local startWeek = self.ctrller.data.startWeek 
    local today = self.ctrller.data.curday
    local startx,starty = self.nodeRiLiDay:getPosition()
    local dX = self.nodeRiLiDay2:getPositionX() - startx
    local dY = starty - self.nodeRiLiDay3:getPositionY() - self.ctrller:checkDayRow()
    local canDaoState = #self.ctrller.data.signin_days
    print(string.format("D:%d,W:%d,sx:%d,sy:%d,dx:%d,dy:%d",totalDay,startWeek,startx,starty,dX,dY))
    startWeek = startWeek-1
    local rowx = startx + dX*startWeek

    for i=1,totalDay do
        --print(i,startWeek,rowx,starty)
        self:createDaily(self.nodeRiLi,i<=today,i,rowx,starty)
        if canDaoState > 0 and i<=today then
            self:createQianDaoDay(self.nodeRiLi,self.ctrller:getQianDaoState(i),i,rowx,starty)
        end
        startWeek = startWeek + 1
        rowx = rowx + dX
        if startWeek >= 7 then 
            startWeek = 0
            starty = starty - dY
            rowx = startx
        end
    end
end

function QianDaoLayer:showGiftBox(target,day,today)
    print("showGiftBox",day,today) 
    local giftboxIcon = target:getChildByTag(today+1000)
    if giftboxIcon == nil then 
        
        giftboxIcon =  CCSprite:create("images/TanChu/popup_pic_qiandaolihe.png")
        giftboxIcon:setScale(0.8)
        giftboxIcon:setTag(today+1000)
        target:addChild(giftboxIcon) 
    end   
    local child = target:getChildByTag(day)
    local x,y = child:getPosition()
    giftboxIcon:setPosition(ccp(x,y))
end 

function QianDaoLayer:showQianDaoAni(target,day)
    print("showQianDaoAni") 

    local child = target:getChildByTag(day+100)
    if child ~= nil then 
        child:removeFromParentAndCleanup(true)
    end 

    local ani = getAnimation("ani_qiandao","donghua");
    if nil == ani then return end 

    local frame =  tolua.cast(ani:getFrames():objectAtIndex(0),"CCAnimationFrame"):getSpriteFrame()
    local sprite = CCSprite:createWithSpriteFrame(frame)
    local child = target:getChildByTag(day)
    local x,y = child:getPosition()
    child:setVisible(true)
    sprite:setPosition(ccp(x,y))
    sprite:setTag(day + 100)
    target:addChild(sprite)
    sprite:runAction(CCAnimate:create(ani))  
end

function QianDaoLayer:showLingQuAni(days)
    print("showLingQuAni")
    local idx = 1

    for k,v in pairs(self.ctrller.data.signin_award) do 
        if v.days_ == days then 
            idx = k 
            break
        end
    end

    local sprite = self["spriteYiLingQu"..idx]
    sprite:setVisible(true)
    sprite:setScale(2.0)
    local fade_seq = transition.sequence({CCFadeIn:create(0.2),CCScaleTo:create(0.5,1.0)}); 

    sprite:runAction(fade_seq); 
end


function QianDaoLayer:showQianDaoTips(typ,cn,x,y)
    local popBoxTips = {};
   
    function popBoxTips:onAssignVars()
        self.lableuser = tolua.cast(self["lableuser"],"CCLabelTTF");
        self.lableget = tolua.cast(self["lableget"],"CCLabelTTF");
        self.lablename = tolua.cast(self["lablename"],"CCLabelTTF");       
        print(cn.index_)
        if nil ~= cn then 
            local data = gBaseLogic.sceneManager.currentPage.view.ctrller.data
            if not data[cn.index_] then 
                self.lableuser:setString("未知")
                self.lableget:setString("未知")  
                self.lablename:setString(cn.name_)          
            else
                self.lableuser:setString(data[cn.index_].user)
                self.lableget:setString(data[cn.index_].get)
                self.lablename:setString(cn.name_)
            end
        end
    end
    
    gBaseLogic.sceneManager.currentPage.view:showPopBoxCCB("interfaces/QianDaoTanChu.ccbi",popBoxTips,true,1)
    gBaseLogic.sceneManager.currentPage.view.nodePopBox:setPosition(x,y);

end 

function QianDaoLayer:showBuQianKaPay(info,data,x,y)
    local popBoxTips = {};
   
    function popBoxTips:onAssignVars()
        --self.labelTitle = tolua.cast(self["labelTitle"],"CCLabelTTF");
        self.labelMoney = tolua.cast(self["labelMoney"],"CCLabelTTF");
        self.labelCount = tolua.cast(self["labelCount"],"CCLabelTTF")      
        if nil ~= info then 
            print("showBuQianKaPay",info.url)
            izx.resourceManager:imgFileDown(info.url,true,function(fileName) 
                    self.spriteBuQianKa:setTexture(getCCTextureByName(fileName))
            end);
            --self.labelTitle:setString("未知")
            self.labelMoney:setString("¥"..info.money)  
            self.labelCount:setString("补签卡（"..info.count.."张）")          
        end
    end

    function popBoxTips:onPressClose()
        gBaseLogic.sceneManager.currentPage.view:closePopBox();
    end 

    function popBoxTips:onPressConfirm()
        local tmptype = "SMS" --"Normal"
        gBaseLogic:addLogDdefine("shopPay","payType",info.money)
        --if tmptype=="SMS" then
            --gBaseLogic.lobbyLogic:onPayTips(3, tmptype, data, 0)
        --else
            gBaseLogic.lobbyLogic:pay(data,tmptype,3);
        --end 
        gBaseLogic.sceneManager.currentPage.view:closePopBox();
        gBaseLogic:blockUI({autoUnblock=false})
        --for test 
        --[[
        local x = gBaseLogic.lobbyLogic.QianDaoLayer.ctrller.data.index
        local ply_items = gBaseLogic.lobbyLogic.userData.ply_items_
        gBaseLogic.lobbyLogic.QianDaoLayer.ctrller:setItemNumber(ply_items,x,5)
        gBaseLogic.lobbyLogic:dispatchLogicEvent({
            name = "MSG_SOCK_pt_lc_send_user_data_change_not",
            message = {ply_items_ = ply_items}
        })
        --]]
    end 
    gBaseLogic.sceneManager.currentPage.view:showPopBoxCCB("interfaces/QianDaoKa.ccbi",popBoxTips,true,1)
    gBaseLogic.sceneManager.currentPage.view.nodePopBox:setPosition(x,y);

end


--[{"aid":8646,"appid":449,"atime":1398150017,"content":"疯狂四月活动圆满结束，恭喜玩家“危机”获得千足金条大奖，活动获奖详细名单已经在微信公众号进行公布。","imgs":"http://img.cache.bdo.banding.com.cn/ance/春540x260.png","isLoginAnce":0,"pn":"com.izhangxin.ermj.ios.baihe","status":0,"timeStr":"","title":"获奖名单公布"},
function QianDaoLayer:updateHuoDongInfo(data)
    echoInfo("updateHuoDongInfo!!!");
    if data ~= nil and #data > 0 then 
        var_dump(data);
        self.labelContent:setString(data.content)
        self.labelTitle:setString(data.title)
        self.labelDate:setString(os.date("%Y-%m-%d", data.atime))
    else 
        self.labelContent:setString("暂无活动内容")
        self.labelTitle:setString("温馨提示")
        self.labelDate:setString(os.date("%Y-%m-%d", os.time()))
    end
end
function QianDaoLayer:enableAllButton()
    self.btnQianDao:setEnabled(true)
    self.btnAward1:setEnabled(true)
    self.btnAward2:setEnabled(true)
    self.btnAward3:setEnabled(true)
    self.btnAward4:setEnabled(true)
end 

function QianDaoLayer:unWaitingAni(target,opt)
    --echoInfo("THANKS TO unWaitingAni ME!!!");
    --opt:removeFromParentAndCleanup(true);

    scheduler.unscheduleGlobal(self.scheduler)
    self.scheduler = nil
    gBaseLogic:unblockUI();

end

function QianDaoLayer:loadingAni()
     --gBaseLogic.sceneManager:waitingAni(self.rootNode,self.unWaitingAni,100)
     gBaseLogic:blockUI();
     self.scheduler = scheduler.performWithDelayGlobal(handler(self, self.unWaitingAni), 5.0)
end

function QianDaoLayer:onAddToScene()
	self.rootNode:setPosition(ccp(display.cx,display.cy));
end

return QianDaoLayer;