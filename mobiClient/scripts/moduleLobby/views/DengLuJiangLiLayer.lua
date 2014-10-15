local DengLuJiangLiLayer = class("DengLuJiangLiLayer",izx.baseView)

function DengLuJiangLiLayer:ctor(pageName,moduleName,initParam)
	print ("DengLuJiangLiLayer:ctor")
    self.super.ctor(self,pageName,moduleName,initParam);
end


function DengLuJiangLiLayer:onAssignVars() 
    
	self.rootNode = tolua.cast(self.rootNode,"CCNode");
	-- if nil ~= self["holderAward7"] then
	-- 	holderAwardWeek = tolua.cast(self["holderAward7"],"CCNode")
 --    end
 --    if nil ~= self["holderAward14"] then
 --    	self.holderAward14 = tolua.cast(self["holderAward14"],"CCNode")
 --    end
    -- if nil ~= self["holderAwardDay1"] then
    -- 	holderAwardDay = tolua.cast(self["holderAwardDay1"],"CCNode")
    -- end 
    -- if nil ~= self["holderAwardDay2"] then
    --     holderAwardDay2 = tolua.cast(self["holderAwardDay2"],"CCNode")
    -- end 
    -- if nil ~= self["holderAwardDay3"] then
    --     holderAwardDay3 = tolua.cast(self["holderAwardDay3"],"CCNode")
    -- end 
    -- if nil ~= self["holderAwardDay4"] then
    --     holderAwardDay4 = tolua.cast(self["holderAwardDay4"],"CCNode")
    -- end
-- 连续登陆天数：labelLoginTotalDays
-- 连续登陆天数获得的金币数：labelLoginMoney
-- 明天登陆获得金币数：labelNextLoginMoney
-- 开通vip获得金币数：labelVipMoney
    if nil ~= self["labelLoginTotalDays"] then
        self.labelLoginTotalDays = tolua.cast(self["labelLoginTotalDays"],"CCLabelTTF")
    end
    if nil ~= self["labelLoginMoney"] then
        self.labelLoginMoney = tolua.cast(self["labelLoginMoney"],"CCLabelTTF")
    end
    if nil ~= self["labelNextLoginMoney"] then
        self.labelNextLoginMoney = tolua.cast(self["labelNextLoginMoney"],"CCLabelTTF")
    end
    if nil ~= self["labelVipMoney"] then
        self.labelVipMoney = tolua.cast(self["labelVipMoney"],"CCLabelTTF")
    end
    if nil ~= self["labelVipMoneyKa"] then
        self.labelVipMoneyKa = tolua.cast(self["labelVipMoneyKa"],"CCLabelTTF")
    end
    if nil ~= self["labelTitle"] then
        self.labelTitle = tolua.cast(self["labelTitle"],"CCLabelTTF")
    end
    if nil ~= self["btnVipTu"] then
        self.btnVipTu = tolua.cast(self["btnVipTu"],"CCControlButton")
    end
    if nil ~= self["btnVip"] then
        self.btnVip = tolua.cast(self["btnVip"],"CCControlButton")
    end
    if nil ~= self["btnConfirm"] then
        self.btnConfirm = tolua.cast(self["btnConfirm"],"CCControlButton")
    end 
end
function DengLuJiangLiLayer:onPressConfirm()
    print ("DengLuJiangLiLayer:onPressConfirm")
    izx.baseAudio:playSound("audio_menu");
    self.logic:onSocketLoginAwardReq(); 
    self:onPressBack();
end

function DengLuJiangLiLayer:onPressBack()
    print ("DengLuJiangLiLayer:onPressBack")
    izx.baseAudio:playSound("audio_menu");
    gBaseLogic.sceneManager:removePopUp("DengLuJiangLiLayer");
end

function DengLuJiangLiLayer:onPressClose()
    print ("DengLuJiangLiLayer:onPressClose")
    izx.baseAudio:playSound("audio_menu");
    gBaseLogic.sceneManager:removePopUp("DengLuJiangLiLayer");
end

function DengLuJiangLiLayer:onPressOpenVip()
    izx.baseAudio:playSound("audio_menu");
    -- local scene = display.getRunningScene()
    -- scene:removeChild(self.rootNode)
    self.logic:gotoVipShop(1);
end
function DengLuJiangLiLayer:onInitView()
    print ("DengLuJiangLiLayer:onInitView")
    
end

function DengLuJiangLiLayer:createdaynode(day,today,money_)
    -- -191.6,-64.8,61.2,186  y:56.4
    local login_award_cfg = {[1]={x=-239,y=79,title_1="第1天",title_2="第1天"},[2]={x=-78,y=79,title_1="第2天",title_2="第2天"},[3]={x=79,y=79,title_1="第3天",title_2="第3天"},[4]={x=236.8,y=79,title_1="第4天",title_2="第4天"},
        [5]={x=-236.8,y=-60,title_1="第5天",title_2="第5天"},[6]={x=-79,y=-60,title_1="第6天",title_2="第6天"},[7]={x=78,y=-60,title_1="第7天",title_2="第7天"}}
    local holderAwardDay = CCNode:create()
    self.rootNode:addChild(holderAwardDay);
    holderAwardDay:setPosition(cc.p(login_award_cfg[day].x,login_award_cfg[day].y));
    if (day <= today) then
        -- self.rootNode:addChild(holderAwardDay);
        -- holderAwardDay:setPosition(cc.p(-64.8,56.4));
        local sprite = display.newSprite("images/TanChu/popup_btn_pai1.png",0,0)
        holderAwardDay:addChild(sprite, 0)
        local label = CCLabelTTF:create(login_award_cfg[day].title_2, "", 22);
        label:setFontSize(22);
        label:setColor(ccc3(254,213,70));
        label:setPosition(cc.p(0.0,45));
        label:setAnchorPoint(cc.p(0.5,0.5));
        holderAwardDay:addChild(label);
        if day~= today then
            sprite = display.newSprite("images/TanChu/popup_pic_yilingqu.png",0,-7)
            holderAwardDay:addChild(sprite);
        end
        label_m = CCLabelTTF:create("+"..money_, "", 24.0);
        label_m:setColor(ccc3(140,16,30));
        label_m:setPosition(cc.p(0,-46.0));
        label_m:setAnchorPoint(cc.p(0.5,0.5));
        holderAwardDay:addChild(label_m);
    else
        local sprite = display.newSprite("images/TanChu/popup_btn_pai3.png",0,0)
        holderAwardDay:addChild(sprite, 0)
        local label = CCLabelTTF:create(login_award_cfg[day].title_1, "", 22.0);
        label:setColor(ccc3(178,178,178));
        label:setPosition(cc.p(0.0,45));
        label:setAnchorPoint(cc.p(0.5,0.5));
        holderAwardDay:addChild(label);
        label_m = CCLabelTTF:create("+"..money_, "", 24.0);
        label_m:setFontSize(24);
        label_m:setColor(ccc3(63,63,63));
        label_m:setPosition(cc.p(0,-46.0));
        label_m:setAnchorPoint(cc.p(0.5,0.5));
        holderAwardDay:addChild(label_m);
    end
    
    

end
function DengLuJiangLiLayer:initBaseInfo()
	local ply_login_award2_ = self.ctrller.data.ply_login_award2_;
    -- var_dump(ply_login_award2_.login_award_);
    local today_ = ply_login_award2_.today_
    local money_ = 0;
    print("DengLuJiangLiLayer:initBaseInfo");
    var_dump(ply_login_award2_.login_award_)
    if ply_login_award2_ then--add key,value
        for k,v in pairs(ply_login_award2_.login_award_) do
            -- {login_days_:1,money_:1000}
            self:createdaynode(v.login_days_,today_,v.money_)
            if (today_>=v.login_days_) then
                money_ = v.money_
            end
        end
    end
    -- self:createdaynode(5,1,1000)
    -- self:createdaynode(6,1,2000)
    -- self:createdaynode(7,1,3000)
    local has_get_week = 0;
    if today_ >= 14 then
        has_get_week = 2;
    elseif today_ >= 7 then
        has_get_week = 1;
    end

    -- self:createweeknode(1,has_get_week,8000);
    -- self:createweeknode(2,has_get_week,10000);

    
    print("getPoints====")
    
    -- self.labelLoginMoney:setAlignment(kCCTextAlignmentLeft)
    -- vip 部分
    if self.ctrller.data.ply_vip_.status_ == 1 then
        self.btnVipTu:setEnabled(true)
        self.labelVipMoney:setString(self.ctrller.data.ply_vip_.login_award_)
        self.labelTitle:setString("已连续登录 "..today_ .." 天，今日领 "..money_+self.ctrller.data.ply_vip_.login_award_ .." 游戏币！")
        self.btnVip:setEnabled(false);
    else
        self.btnVipTu:setEnabled(false)
        self.labelVipMoney:setString(self.ctrller.data.ply_vip_.login_award_)
        self.labelTitle:setString("已连续登录 "..today_ .." 天，今日领 "..money_ .." 游戏币！")
    end
    self.labelVipMoneyKa:setString(self.ctrller.data.ply_vip_.login_award_)
end
-- function DengLuJiangLiLayer:createweeknode(week, has_get_week, money_)
--     local holderAwardWeek = CCNode:create() -- -191.6,-64.8,61.2,186  y:56.4
--     -- 7: 81 -136 ,14: 184.6 -136
--     self.rootNode:addChild(holderAwardWeek);
--     local has_get = 0;
--     if (week==1) then
--         if (has_get_week~=0) then
--             has_get =1;
--         end
--         holderAwardWeek:setPosition(cc.p(81,-136));
--     else
--         if (has_get_week==2) then
--             has_get =1;
--         end
--         holderAwardWeek:setPosition(cc.p(184.6,-136));
--     end
--     if (has_get==1) then
--         sprite = display.newSprite("images/TanChu/popup_pic_yilingqu.png",0,-7)
--         holderAwardWeek:addChild(sprite);
--         sprite = display.newSprite("images/TanChu/popup_btn_pai21.png",0,0)
        
--     else
--         sprite = display.newSprite("images/TanChu/popup_btn_pai23.png",0,0)
--     end
--     holderAwardWeek:addChild(sprite, 0)
--     if (week==1) then
--         label = CCLabelTTF:create("第7天", "", 19.0);
--     else
--         label = CCLabelTTF:create("第14天", "", 19.0);
--     end
    
--     label:setFontSize(19);
--     label:setColor(ccc3(254,213,70));
--     label:setPosition(cc.p(0.0,38));
--     label:setAnchorPoint(cc.p(0.5,0.5)); 
--     label:setTag(-1);
--     holderAwardWeek:addChild(label);
    
--     label_m = CCLabelTTF:create("+" .. money_, "", 19.0);
--     -- label_m:setFontSize(19);
--     label_m:setColor(ccc3(172,15,31));
--     label_m:setPosition(cc.p(0,-32));
--     label_m:setAnchorPoint(cc.p(0.5,0.5));
--     label_m:setTag(-1);
--     holderAwardWeek:addChild(label_m);

-- end

function DengLuJiangLiLayer:onTouch(event, x, y)

end

function DengLuJiangLiLayer:onAddToScene()
	self.rootNode:setPosition(ccp(display.cx,display.cy));
end

return DengLuJiangLiLayer;