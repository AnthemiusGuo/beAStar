local BaoXiangRenWuLayer = class("BaoXiangRenWuLayer",izx.baseView)

function BaoXiangRenWuLayer:ctor(pageName,moduleName,initParam)
    print ("BaoXiangRenWuLayer:ctor")
    self.super.ctor(self,pageName,moduleName,initParam);
    self.remain_time = 0;
end

function BaoXiangRenWuLayer:onAddToScene()
    self.rootNode:setPosition(cc.p(display.cx,display.cy));
end

function BaoXiangRenWuLayer:onAssignVars()
    self.rootNode = tolua.cast(self.rootNode,"CCNode");
    if nil ~= self["labelTitle"] then
        self.labelTitle = tolua.cast(self["labelTitle"],"CCLabelTTF")
    end
   
    if nil ~= self["labelContent1"] then
        self.labelContent1 = tolua.cast(self["labelContent1"],"CCLabelTTF")
    end
    if nil ~= self["labelContent2"] then
        self.labelContent2 = tolua.cast(self["labelContent2"],"CCLabelTTF")
    end
    if nil ~= self["labelContent3"] then
        self.labelContent3 = tolua.cast(self["labelContent3"],"CCLabelTTF")
    end

    if nil ~= self["nodeContent1"] then
        self.nodeContent1 = tolua.cast(self["nodeContent1"],"CCNode")
    end
    if nil ~= self["nodeContent2"] then
        self.nodeContent2 = tolua.cast(self["nodeContent2"],"CCNode")
    end
    if nil ~= self["nodeContent3"] then
        self.nodeContent3 = tolua.cast(self["nodeContent3"],"CCNode")
    end

    if nil ~= self["taskName1"] then
        self.taskName1 = tolua.cast(self["taskName1"],"CCLabelTTF")
    end
    if nil ~= self["taskName2"] then
        self.taskName2 = tolua.cast(self["taskName2"],"CCLabelTTF")
    end
    if nil ~= self["taskName3"] then
        self.taskName3 = tolua.cast(self["taskName3"],"CCLabelTTF")
    end
    if nil ~= self["taskDesc1"] then
        self.taskDesc1 = tolua.cast(self["taskDesc1"],"CCLabelTTF")
    end
    if nil ~= self["taskDesc2"] then
        self.taskDesc2 = tolua.cast(self["taskDesc2"],"CCLabelTTF")
    end
    if nil ~= self["taskDesc3"] then
        self.taskDesc3 = tolua.cast(self["taskDesc3"],"CCLabelTTF")
    end

    if nil ~= self["btnAward1"] then
        self.btnAward1 = tolua.cast(self["btnAward1"],"CCLabelTTF")
    end
    if nil ~= self["btnAward2"] then
        self.btnAward2 = tolua.cast(self["btnAward2"],"CCLabelTTF")
    end 
     if nil ~= self["btnAward3"] then
        self.btnAward3 = tolua.cast(self["btnAward3"],"CCLabelTTF")
    end 
    if nil ~= self["nodeTask1"] then
        self.nodeTask1 = tolua.cast(self["nodeTask1"],"CCNode")
    end 
    if nil ~= self["nodeTask2"] then
        self.nodeTask2 = tolua.cast(self["nodeTask2"],"CCNode")
    end 
    if nil ~= self["nodeTask3"] then
        self.nodeTask3 = tolua.cast(self["nodeTask3"],"CCNode")
    end
end

function BaoXiangRenWuLayer:onPressBack()
    print ("BaoXiangRenWuLayer:onPressBack")
    self:onPressClose();
end

function BaoXiangRenWuLayer:onPressClose()
    print ("BaoXiangRenWuLayer:onPressClose")
    if self.scheduler~=nil then
        self.scheduler.unscheduleGlobal(self.serTimeHandler)
        self.scheduler = nil 
        self.serTimeHandler = nil;
    end
    gBaseLogic.sceneManager:removePopUp("BaoXiangRenWuLayer");
end

function BaoXiangRenWuLayer:onPressAward1()
    print ("BaoXiangRenWuLayer:onPressAward1")
    -- self:onPressClose();
    self.ctrller.getAward = 1;
    self.logic:onSocketGetOnlieAward(1)
end

function BaoXiangRenWuLayer:onPressAward2()
    print ("BaoXiangRenWuLayer:onPressAward2")
    self.ctrller.getAward = 1;
    local task_type_ = self.logic.baoXiangRenWu.roundInfo.task_type_
    local last_task_index_ = self.logic.baoXiangRenWu.roundInfo.last_task_index_
    if last_task_index_==0 then
        task_type_ = self.logic.baoXiangRenWu.roundItems[1].task_type_
        last_task_index_ = self.logic.baoXiangRenWu.roundItems[1].task_index_    
    end
    self.logic:pt_cb_get_task_award_req(1,task_type_,last_task_index_)
    -- gBaseLogic.sceneManager:removePopUp("BaoXiangRenWuLayer");
end
function BaoXiangRenWuLayer:onPressAward3()
    -- if self.logic.baoXiangRenWu.streaktaskinfo.ret_==1 then
        self.btnAward3:setEnabled(false)
        local socketMsg = {opcode = 'pt_cb_get_daily_task_award_req',index_=self.logic.baoXiangRenWu.streaktaskinfo.index_};
        gBaseLogic.gameLogic:sendGameSocket(socketMsg);
    -- end
end

function BaoXiangRenWuLayer:onInitView()
    self:initBaseInfo();
end
function BaoXiangRenWuLayer:initRoundInfo()
     -- self.logic.baoXiangRenWu = {
    --  giftStat=0,
    --  roundItems = {},
    --  onlineInfo = {},
    --  roundInfo = {}

    -- }
    local roundItems = self.logic.baoXiangRenWu.roundItems
    
    local roundInfo = self.logic.baoXiangRenWu.roundInfo
    if roundInfo~=nil and roundInfo.task_type_~=nil then
        self.nodeTask2:setVisible(true)
        -- [0]累计局数 [1]胜利局数
        -- task_type_=message.task_type_,last_task_index_=message.last_task_index_,cur_val_=message.cur_val_
        local itemInfo = {};
        if roundInfo.last_task_index_==0 then
            itemInfo = roundItems[1];
        else
            for k,v in pairs(roundItems) do 
                if v.task_index_==roundInfo.last_task_index_ then
                    itemInfo = v;
                end
            end
        end        
        --     int             task_type_;         // 任务类型 1累加 2胜利
        -- int             task_index_;        // 任务索引 
        -- int             award_round_;       // 奖励局数
        -- string          award_name_;        // 奖励名称
        -- vector<ItemAwardData>   items_;     // 道具信息
        if roundInfo.cur_val_>=itemInfo.award_round_ then
            self.nodeContent2:setVisible(false)
            self.btnAward2:setVisible(true)
        else 
            self.nodeContent2:setVisible(true)
            self.labelContent2:setString(roundInfo.cur_val_ .. "/" .. itemInfo.award_round_)
            self.btnAward2:setVisible(false)
        end
-- int     index_;             // 道具索引
--     int     number_;
        self.taskName2:setString(itemInfo.award_name_)
    
        local namet = "拉霸币"
        for k,v in pairs(gBaseLogic.lobbyLogic.userData.ply_items_) do 
            if itemInfo.items_[1].index_ == v.index_ then
                namet = v.name_;
            end
        end
        self.taskDesc2:setString(itemInfo.items_[1].number_ ..namet);
    else
        self.nodeTask2:removeAllChildrenWithCleanup(true)
        local text2 = CCLabelTTF:create("今日局数任务已全部完成","Helvetica", 24)
        self.nodeTask2:addChild(text2)
    end
end
function BaoXiangRenWuLayer:initstreaktaskInfo()
     -- self.logic.baoXiangRenWu = {
    --  giftStat=0,
    --  roundItems = {},
    --  onlineInfo = {},
    --  roundInfo = {}

    -- }
    print("BaoXiangRenWuLayer:initstreaktaskInfo")
    local roundInfo = self.logic.baoXiangRenWu.streaktaskinfo
    var_dump(roundInfo)
    if roundInfo~=nil and roundInfo.ret_~=nil and (roundInfo.ret_==0 or roundInfo.ret_==1) then
        self.nodeTask3:setVisible(true)
        if roundInfo.speed_>=roundInfo.amount_ then
            self.nodeContent3:setVisible(false)
            self.btnAward3:setVisible(true)
        else 
            self.nodeContent3:setVisible(true)
            self.labelContent3:setString(roundInfo.speed_ .. "/" .. roundInfo.amount_)
            self.btnAward3:setVisible(false)
        end

        self.taskName3:setString(roundInfo.name_)
    
        
        self.taskDesc3:setString(roundInfo.desc_.."游戏币");
    else
        self.nodeTask3:removeAllChildrenWithCleanup(true)
        local text3 = CCLabelTTF:create("今日连胜任务已全部完成","Helvetica", 24)
        self.nodeTask3:addChild(text3)
    end
end
function BaoXiangRenWuLayer:initOnlineInfo()

    local onlineInfo = self.logic.baoXiangRenWu.onlineInfo
    local onlineItems =self.logic.baoXiangRenWu.onlineItems
    if onlineInfo~=nil and onlineInfo.remain_~=nil and onlineInfo.money_~=0 then
        self.nodeTask1:setVisible(true)
        -- {remain_=message.remain_,money_=message.money_}
        self.remain_time = onlineInfo.remain_;
        if self.remain_time==0 then
            self.nodeContent1:setVisible(false)
            self.btnAward1:setVisible(true)
        else 
            self.nodeContent1:setVisible(true)
            print("BaoXiangRenWuLayer:initBaseInfo"..onlineInfo.remain_)
            local remainS = self.remain_time%60;
            if remainS<10 then 
                remainS = "0"..remainS
            end
            self.labelContent1:setString(math.floor(self.remain_time/60)..":"..remainS)
            -- self.labelContent1:setString(os.date("%M:%S",onlineInfo.remain_))
            self.btnAward1:setVisible(false)
            
            local OnTimer = function(dt)
                self.remain_time = self.remain_time-1;
                if self.remain_time~=0 then
                    local remainS = self.remain_time%60;
                    if remainS<10 then 
                        remainS = "0"..remainS
                    end
                    self.labelContent1:setString(math.floor(self.remain_time/60)..":"..remainS)
                    -- self.labelContent1:setString(os.date("%M:%S",onlineInfo.remain_))
                else
                    self.remain_time = 0;
                    self.logic.baoXiangRenWu.onlineInfo.remain_=0;
                    self.scheduler.unscheduleGlobal(self.serTimeHandler)
                    self.scheduler = nil 
                    self.serTimeHandler = nil;
                    self:initBaseInfo();

                end
            end
            if self.scheduler==nil then
                self.scheduler = require("framework.scheduler");
                self.serTimeHandler = self.scheduler.scheduleGlobal(OnTimer, 1, false)
            end
        end
        print("self.scheduler.scheduleGlobal"..onlineInfo.money_)
        var_dump(onlineItems)
        for k,v in pairs(onlineItems) do
            if v.money_award_==onlineInfo.money_ then
                self.taskName1:setString("在线"..v.award_time_.."分钟")
                break;
            end
        end
        self.taskDesc1:setString(onlineInfo.money_ .."游戏币");
    else
        -- self.nodeTask1:setVisible(false)
         self.nodeTask1:removeAllChildrenWithCleanup(true)
        local text1 = CCLabelTTF:create("今日连胜任务已全部完成","Helvetica", 24)
        self.nodeTask1:addChild(text1)
    end
end
function BaoXiangRenWuLayer:initBaseInfo()
    self:initOnlineInfo()
    self:initRoundInfo()
    self:initstreaktaskInfo()



end

return BaoXiangRenWuLayer;