local QianDaoLayerCtrller = class("QianDaoLayerCtrller",izx.baseCtrller)
function QianDaoLayerCtrller:ctor(pageName,moduleName,initParam)
    -- {
--     sec = 49  (number)
--     min = 9  (number)
--     day = 18  (number)
--     isdst = false  (boolean)
--     wday = 4  (number)
--     yday = 169  (number)
--     year = 2014  (number)
--     month = 6  (number)
--     hour = 10  (number)
-- }
    self.data = {
        signin_days = {},--{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        signin_award = {},
        ply_vip = {login_award_ = 0},
        today = 0,
        buqianka = 0,
        kebuqian = 0,
        index = 57,
        curyear  = 2014,      --当前年份
        curmonth = 8,     --当前月份
        curday   = 8,       --当前日期
        cruweek  = 1,      --当前星期
        totalDay = 31,
        startWeek = 6,
        anceInfo = {},
        ply_items = {},
        payitemslist = {},
        awarddays = {},
        jinduScale = {0.14,0.38,0.66,1.00},
    };
    local thisTime = os.time();
    self:initTimeInfo(thisTime)
	QianDaoLayerCtrller.super.ctor(self,pageName,moduleName,initParam);
end
function QianDaoLayerCtrller:initTimeInfo(t)
    print("QianDaoLayerCtrller:initTimeInfo")
    local tmptoday = os.date("*t",t)
    print("t:"..t);
    var_dump(tmptoday)
    print("os.time:"..os.time())
    local totalDay, startWeek = self:getDayAndWeek(tmptoday["year"],tmptoday["month"],1)
    self.data.curyear  = tmptoday["year"];     --当前年份
    self.data.curmonth = tmptoday["month"];    --当前月份
    self.data.curday   = tmptoday["day"];      --当前日期
    self.data.cruweek  = tmptoday["wday"];     --当前星期
    print(self.data.curyear,self.data.curmonth,self.data.curday,self.data.cruweek)
    self.data.totalDay = totalDay;
    self.data.startWeek= startWeek;
    var_dump(tmptoday)
end 

function QianDaoLayerCtrller:run()
    print("QianDaoLayerCtrller:run")
--gBaseLogic.lobbyLogic.pong_now
    self.logic:addLogicEvent("MSG_SOCK_pt_lc_get_user_signin_days_ack",handler(self, self.pt_lc_get_user_signin_days_ack),self)

    self.logic:addLogicEvent("MSG_SOCK_pt_lc_set_user_signin_days_ack",handler(self, self.pt_lc_set_user_signin_days_ack),self)

    self.logic:addLogicEvent("MSG_SOCK_pt_lc_get_user_signin_award_ack",handler(self, self.pt_lc_get_user_signin_award_ack),self)

    self.logic:addLogicEvent("MSG_Socket_pt_lc_send_user_data_change_not",handler(self, self.pt_lc_send_user_data_change_not),self)

    self.logic:addLogicEvent("MSG_change_chongzhi_btn",handler(self, self.buQianKaPayResult),self)

    self.data.ply_vip = gBaseLogic.lobbyLogic.userData.ply_vip_;
    self.data.anceInfo = gBaseLogic.lobbyLogic.userData.anceInfo_;

    if gBaseLogic.gameItems~=nil then
         for k,v in pairs(gBaseLogic.lobbyLogic.userData.ply_items_) do
            if gBaseLogic.gameItems[v.index_]==1 then
                table.insert(self.data.ply_items,v)
            end
        end
    else
        self.data.ply_items = gBaseLogic.lobbyLogic.userData.ply_items_
    end
    self.data.payitemslist = gBaseLogic.lobbyLogic.paymentItemList
    self:resetData(gBaseLogic.lobbyLogic.userData.signin_info)

	QianDaoLayerCtrller.super.run(self);
    --var_dump(gBaseLogic.lobbyLogic.userData.signin_info)
    --var_dump(self.data.ply_items)
    if gBaseLogic.lobbyLogic.userData.signin_info == nil or self.data.curday == 1 then 
        self:pt_cl_get_user_signin_days_req() 
        --self.logic.requestHTTGongGao(false)
        self:requestHTTGongGao()
    else 
        self.view:enableAllButton()
        --self.view:initBaseInfo();
    end 
    self.view:initBaseInfo();       
end 

function QianDaoLayerCtrller:resetData(signin_info)
    if signin_info ~= nil then 
        self.data.signin_days = signin_info.signin_days_
        self.data.signin_award = signin_info.signin_award_.signin_award_
        self.data.today =  self:getContinuedSigninDays() --signin_info.signin_award_.today_
        self.data.kebuqian = self:getUnSigninDays()
        self.data.buqianka = self:getItemNumber(self.data.index) --signin_info.buqianka_ 
        self:getAwardDays()
        print("resetData",self.data.buqianka)
    end 
end


function QianDaoLayerCtrller:buQianKaPayResult(event)
    print("buQianKaPayResult")
    if event.message.code == 0 then 
        self.data.ply_items = gBaseLogic.lobbyLogic.userData.ply_items_
        self.data.buqianka = self:getItemNumber(self.data.index) 
        self.view.labelBuQianKa:setString(self.data.buqianka)
        self.view:changeQianDaoBtnState()
    else
        izxMessageBox("支付失败", "支付提示")
    end
end 

function QianDaoLayerCtrller:pt_lc_send_user_data_change_not(event)
    print("QianDaoLayerCtrller:pt_lc_send_user_data_change_not")
    self.data.ply_items = event.message.ply_items_
    self.data.buqianka = self:getItemNumber(self.data.index) 
    self.view.labelBuQianKa:setString(self.data.buqianka)
    self.view:changeQianDaoBtnState()
end
--{"exitmsg":{},"sharemsg":{},"sharereward":{"left":2},"ance":{"pageCount":1,"pageNow":4,"pageSize":1,"resultList":[{"aid":11054,"appid":479,"atime":1402911553,"content":"“世界杯-百万闯关”活动开启,免费竞猜,猜中最高奖4888元,更有机会赢百万大奖,详情见游戏活动版块或登陆www.izhangxin.com/wcup/","imgs":"http://img.cache.bdo.banding.com.cn/ance/夏540x260.png","isLoginAnce":0,"pn":"com.hiigame.ddz.android.qh360","status":0,"timeStr":"","title":"百万闯关"}],"rowCount":1},"contactus":{"pno":"4009208068","qq":"800061676"}}

function QianDaoLayerCtrller:requestHTTGongGao()
    -- 强推公告 todo
    print("QianDaoLayerCtrller:requestHTTGongGao")
    if (MAIN_GAME_ID~=13) then
        gBaseLogic:blockUI({autoUnblock=false,msg=LOGIN_LOADING_TIPS0,hasCancel=true,callback=handler(gBaseLogic,gBaseLogic.onPressCancelLogin)});
    end
    
    local url = string.gsub(URL.GONGGAO,"{pid}",0);  
    url = string.gsub(url,"{packageName}",gBaseLogic.packageName);
    url = string.gsub(url,"{gameid}",MAIN_GAME_ID);
    -- print(url);
    gBaseLogic:HTTPGetdata(url,0,function(event)
        print("QianDaoLayerCtrller:requestHTTGongGao result")
        if event~=nil and event.ance~=nil then
            if (event.ance.resultList ~=nil and event.ance.resultList[1]~=nil) then 
                local anceresul= event.ance.resultList[1]

                
                gBaseLogic.lobbyLogic.userData.anceInfo_ = anceresul

                if (CCUserDefault:sharedUserDefault():getIntegerForKey("gongGaoAid") ~= anceresul.aid) then
                    self.logic.hasqiangtuigonggao = 1;
                    --self.view:updateHuoDongInfo(anceresul)
                    CCUserDefault:sharedUserDefault():setIntegerForKey("gongGaoAid",anceresul.aid)
                end
                if self ~= nil then 
                    self.data.anceInfo = anceresul
                    self.view:updateHuoDongInfo(anceresul)
                end 
            end
        end
        end)    
end


function QianDaoLayerCtrller:pt_cl_get_user_signin_days_req()
    print("pt_cl_get_user_signin_days_req")
    self.view:loadingAni()
    local socketMsg = {opcode = 'pt_cl_get_user_signin_days_req',}
    gBaseLogic.lobbyLogic:sendLobbySocket(socketMsg);

    --for test
    --[[
    function testUserSigninDays()
        local info = {
            ret = 0,
            signin_info_ = {
                signin_days_ = {2,2,2,2,2,2,1,1,2,2,2,2,2,2,2,2,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
                buqianka_ = 5,
                signin_award_ = {today_ = 0, signin_award_ ={
                {days_=5,money_=10000,gift_=10,count_=100,state_=0,index_=5, name_ = "招财猫表情礼包"},
                {days_=10,money_=20000,gift_=20,count_=200,state_=0,index_=5, name_ = "招财猫表情礼包"},
                {days_=15,money_=30000,gift_=30,count_=300,state_=0,index_=5, name_ = "招财猫表情礼包"},
                {days_=30,money_=60000,gift_=60,count_=600,state_=0,index_=5, name_ = "招财猫表情礼包"}
                }}
            }
        }
        gBaseLogic.lobbyLogic:dispatchLogicEvent({
                    name = "MSG_SOCK_pt_lc_get_user_signin_days_ack",
                    message = info
                });
    end 
    scheduler.performWithDelayGlobal(testUserSigninDays, 0.1)
    --]]
end

function QianDaoLayerCtrller:pt_lc_get_user_signin_days_ack(event)
    print("pt_lc_get_user_signin_days_ack")
    local message = event.message;
    var_dump(message.signin_info_,4)
    
    self.view:unWaitingAni()
    if message.ret == 0 then
        self.view:enableAllButton()
        gBaseLogic.lobbyLogic.userData.signin_info = message.signin_info_
        if message.signin_info_.buqianka_==nil or message.signin_info_.buqianka_<0 or message.signin_info_.buqianka_<CASINO_VERSION_DEFAULT then
        	
        else
        	self:initTimeInfo(message.signin_info_.buqianka_)
        end
        self:resetData(message.signin_info_)
        self.view:initBaseInfo(); 

        if self:getQianDaoState(self.data.curday) == 2 then 
            local curtime = os.date("%x", os.time())
            CCUserDefault:sharedUserDefault():setStringForKey(gBaseLogic.ply_guid_.."QianDaoTime",curtime)
        end 
    end
end 

function QianDaoLayerCtrller:getAwardDays()
    local num = #self.data.signin_award
    for k,v in pairs(self.data.signin_award) do 
        print(k,v.days_)
        self.data.awarddays[k] = v.days_
        if k == num then 
            self.data.awarddays[k] = self.data.totalDay
        end
    end 
end

--{ {  param_2_ = 0 , num_ = 0,name_ = "游戏币" ,param_1_ = 0 ,       opcode = -18287 , url_ = "http://img.cache.bdo.banding.com.cn/shop/youxibi.png",index_ = 57 ,game_id_ = 0 , },}
function QianDaoLayerCtrller:getItemUrl(index) 
    local url = ""
    for k,v in pairs(self.data.ply_items) do 
        if v.index_ == index then 
            url = v.url_ 
            return url
        end
    end 
    return url
end
function QianDaoLayerCtrller:getItemNumber(index) 
    local num = 0
    for k,v in pairs(self.data.ply_items) do 
        --print(index,v.index_,v.num_)
        if v.index_ == index then 
            print("getItemNumber:",index,v.index_,v.num_)
            num = v.num_ 
            return num
        end
    end 
    return num
end

function QianDaoLayerCtrller:setItemNumber(ply_items, index,num) 
    for k,v in pairs(ply_items) do 
        if v.index_ == index then 
            v.num_  = num
            break
        end
    end
end
function QianDaoLayerCtrller:getUnSigninDays()
    local num = 0
    for k,v in pairs(self.data.signin_days) do 
        if v == 1  and k < self.data.curday then 
            num = num + 1
        end
    end
    return num
end 

function QianDaoLayerCtrller:getReSigninDay()
    local day = 0
    for k,v in pairs(self.data.signin_days) do 
        if v == 1  and k < self.data.curday then 
            day = k
        end
    end
    print("getReSigninDay:",day)
    return day
end 
function QianDaoLayerCtrller:getMaxContinuedSigninDays()
    local num = 0
    local max = 0
    for k,v in pairs(self.data.signin_days) do 
        if k <= self.data.curday then 
            if v == 2 then 
                num = num + 1
            elseif k ~= self.data.curday then 
                if max < num then 
                    max = num 
                end 
                num = 0
            end
        end
    end
    return max
end

function QianDaoLayerCtrller:getContinuedSigninDays()
    local num = 0
    for k,v in pairs(self.data.signin_days) do 
        if k <= self.data.curday then 
            if v == 2 then 
                num = num + 1
            elseif k ~= self.data.curday then 
                num = 0
            end
        end
    end
    return num
end 

function QianDaoLayerCtrller:getQianDaoState(day)
    if #self.data.signin_days == 0 then 
        return 0
    end
    return self.data.signin_days[day]
end

function QianDaoLayerCtrller:setQianDaoState(day,state)
    print("setQianDaoState:",day,state)
    self.data.signin_days[day] = state
end

function QianDaoLayerCtrller:getAwardState(day)
    print("getAwardState:",day)
    if #self.data.signin_award == 0 then 
        return 0
    end 
    for k,v in pairs(self.data.signin_award) do 
        if v.days_ == day then 
            print(day,v.days_, v.state_)
            return v.state_
        end
    end
    
end

function QianDaoLayerCtrller:setAwardState(day,state)
    for k,v in pairs(self.data.signin_award) do 
        if v.days_ == day then 
            v.state_ = state
            return
        end
    end
    
end

function QianDaoLayerCtrller:getAwardInfo(day)
    if #self.data.signin_award == 0 then 
        return {}
    end 
    for k,v in pairs(self.data.signin_award) do 
        if v.days_ == day then 
            return v
        end
    end
    return {}
end 
function QianDaoLayerCtrller:checkDayRow()
    local x = 0
    if self.data.startWeek == 6 and self.data.totalDay == 31 then 
        x = 7
    elseif  self.data.startWeek == 7 and self.data.totalDay >= 30 then
        x = 7
    elseif self.data.startWeek == 1 and self.data.totalDay == 28 then 
        x = -10
    end
    return x
end 
function QianDaoLayerCtrller:pt_cl_set_user_signin_days_req(sday)
    print("pt_cl_set_user_signin_days_req",sday)
    self.view:loadingAni()
    local socketMsg = {opcode = 'pt_cl_set_user_signin_days_req',
        day = sday};
    gBaseLogic.lobbyLogic:sendLobbySocket(socketMsg);

    --for test
    --[[
    function testSetSigninDays()
        local tday = self.data.today
        local money = 0
        local ret = 0
        if sday == self.data.curday then 
            tday = tday + 1
            money = 1000
        else 
            if self.data.buqianka <= 0 then 
                ret = -2
            else 
                self:setQianDaoState(sday, 2)
                tday = self:getContinuedSigninDays()
                self:setQianDaoState(sday, 1) 
            end
        end 

        local info = {
            ret = ret,
            day = sday,
            totalday = tday,
            money_ = money
        }
        self.logic:dispatchLogicEvent({
                    name = "MSG_SOCK_pt_lc_set_user_signin_days_ack",
                    message = info
                });
    end 
    scheduler.performWithDelayGlobal(testSetSigninDays, 0.2)
    --]]
end

function QianDaoLayerCtrller:pt_lc_set_user_signin_days_ack(event)
    print("pt_lc_set_user_signin_days_ack")
    local message = event.message;
    self.view:unWaitingAni()
    var_dump(message)
    if message.ret == 0 then
        self.data.today = message.totalday
        
        if message.day == self.data.curday then 
            gBaseLogic:coin_drop(); 
            local curtime = os.date("%x", os.time())
            print(gBaseLogic.ply_guid_.."QianDaoTime")
            CCUserDefault:sharedUserDefault():setStringForKey(gBaseLogic.ply_guid_.."QianDaoTime",curtime)
        else 
            self.data.kebuqian = self.data.kebuqian -1
            self.data.buqianka = self.data.buqianka - 1  
        end 

        self:setQianDaoState(message.day, 2)
        --self.data.today = self:getContinuedSigninDays()
        self.view:showQianDaoAni(self.view.nodeRiLi,message.day)
        self.view:changeQianDaoBtnState()
        self.view:changeLianXuState()
        self.view:changeGiftBoxState()
        self:updataPlyLobbyData(message,0)--已经包含vip奖励
    elseif message.ret == -1 then 
        self.view:changeQianDaoBtnState()
        izxMessageBox("已经签到了!","提示");
    elseif message.ret == -2 then 
        self.data.buqianka = 0
        self.view:changeQianDaoBtnState()
        izxMessageBox("补签卡不足!","提示");
    end
end

function QianDaoLayerCtrller:pt_cl_get_user_signin_award_req(days)
    print("pt_cl_get_user_signin_award_req",days)
    self.view:loadingAni()
    local socketMsg = {opcode = 'pt_cl_get_user_signin_award_req',
        day = days};
    gBaseLogic.lobbyLogic:sendLobbySocket(socketMsg);

    --for test
    --[[
    function testgetSigninAward()
        local info = {
            ret = 0,
            day = days,
        }
        self.logic:dispatchLogicEvent({
                    name = "MSG_SOCK_pt_lc_get_user_signin_award_ack",
                    message = info
                });
    end 
    scheduler.performWithDelayGlobal(testgetSigninAward, 0.2)
    --]]
end 

function QianDaoLayerCtrller:pt_lc_get_user_signin_award_ack(event)
    print("pt_lc_set_user_signin_days_ack:",event.message.ret)
    local message = event.message;
    self.view:unWaitingAni()
    if message.ret == 0 then 
        self:setAwardState(message.day, 1)
        self.view:showLingQuAni(message.day)
        --self.view:changeYiLingQuState()
        self:updataPlyLobbyData(self:getAwardInfo(message.day),1)
    end
end 

function QianDaoLayerCtrller:updataPlyLobbyData(award, type) 
    --  gBaseLogic.lobbyLogic.userData.signin_info = 
    --  {  signin_days_ = self.data.signin_days,
    --     buqianka_ = self.data.buqianka,
    --     signin_award_.signin_award_ = self.data.signin_award,
    --     signin_award_.today_ = self.data.today_
    -- }
    print("updataPlyLobbyData",type)
    

    if type == 1 then --领取奖励
        --[[
        if award.gift_ > 0 then
            self.logic.userData.ply_lobby_data_.gift_ = self.logic.userData.ply_lobby_data_.gift_+award.gift_;
        end 
        if award.count_ > 0 then
            self:setItemNumber(gBaseLogic.lobbyLogic.userData.ply_items_,56,award.count_);
        end 

        if award.index_ > 0 then
            self:setItemNumber(gBaseLogic.lobbyLogic.userData.ply_items_,50,award.index_);
        end 
        --]]
        gBaseLogic.lobbyLogic.userData.signin_info.signin_award_.signin_award_ = self.data.signin_award 

    elseif type == 0 then  --签到
        if award.money_ > 0 then
            self.logic.userData.ply_lobby_data_.money_ = self.logic.userData.ply_lobby_data_.money_+award.money_;
            self.logic:dispatchLogicEvent({
            name = "MSG_change_user_money",
            message = {ret=0}
        });
        end 
        if gBaseLogic.lobbyLogic.userData.signin_info == nil then 
            gBaseLogic.lobbyLogic.userData.signin_info = {}
        end
        gBaseLogic.lobbyLogic.userData.signin_info.signin_days_ = self.data.signin_days
        gBaseLogic.lobbyLogic.userData.signin_info.signin_award_.today_ = self.data.today
        --gBaseLogic.lobbyLogic.userData.signin_info.buqianka_ = self.data.buqianka 
        self:setItemNumber(gBaseLogic.lobbyLogic.userData.ply_items_,self.data.index,self.data.buqianka)

    end
end 

function QianDaoLayerCtrller:findPayItemData(idx)
    for k,v in pairs(self.data.payitemslist) do 
        --var_dump(v.content)
        for k1,v1 in pairs(v.content) do 
            if v1.idx == idx then 
                return k, v1.num
            end
        end
    end
    return 1,0
end

function QianDaoLayerCtrller:getQianDaoKaPayInfo()
    print("QianDaoLayerCtrller:getQianDaoKaPayInfo")
    self.data.payitemslist = gBaseLogic.lobbyLogic.paymentItemList;
    local idx,num = self:findPayItemData(self.data.index)
    if idx == 1 and num == 0 then 
        izxMessageBox("暂时没有该商品！","温馨提示");
    else
        local price = self.data.payitemslist[idx].price 
        print(idx,num, price)
        local info = {url = self:getItemUrl(self.data.index),count = num, money = price..".00"}
        var_dump(self.data.payitemslist[idx])
        self.view:showBuQianKaPay(info, self.data.payitemslist[idx], display.cx, display.cy)
    end
end 

function QianDaoLayerCtrller:getAwardMoney(day) 
    if self.data.ply_login_award2_ == nil then 
        return 0
    end 

    local award_t = self.data.ply_login_award2_.login_award_
    local today = self.data.ply_login_award2_.today_
    local money = 0;

    if today > #award_t then
        today = #award_t
    end
    for k,v in pairs(award_t) do
        if (today == v.login_days_) then
            money = v.money_ 
            break
        end
    end
    return money
end 

function QianDaoLayerCtrller:getJinDuScale()
    local today = self.data.today 
    local awarddays = self.data.awarddays
    local jinduScale = self.data.jinduScale
    local scalex = 0

    if #awarddays > 0 then 
        if today <= awarddays[1] then 
            scalex = today*jinduScale[1]/awarddays[1]
        
        elseif today <= awarddays[2] then 
            scalex = (today-awarddays[1])*(jinduScale[2] -jinduScale[1])/(awarddays[2] - awarddays[1]) +jinduScale[1]
        elseif today <= awarddays[3] then 
            scalex = (today-awarddays[2])*(jinduScale[3] -jinduScale[2])/(awarddays[3] - awarddays[2]) +jinduScale[2]
        elseif today <= awarddays[4] then 
            scalex = (today-awarddays[3])*(jinduScale[4] -jinduScale[3])/(awarddays[4] - awarddays[3]) +jinduScale[3]
        end  
    end

    print("getJinDuScale:",scalex)
    return scalex
end

--获取指定年月的天数和该天的星期
function QianDaoLayerCtrller:getDayAndWeek(year, month, day)       
    local bigmonth = "(1)(3)(5)(7)(8)(10)(12)"
    local strmonth = "(" .. month .. ")"
    local week = os.date("*t", os.time{year = year, month = month, day = day})["wday"]
    if month == 2 then
        if (year % 4 == 0) and (year % 400 == 0 or year % 100 ~= 0) then
            return 29, week
        else
            return 28, week
        end
    elseif string.find(bigmonth, strmonth) ~= nil then
        return 31, week
    else
        return 30, week
    end
end

return QianDaoLayerCtrller;