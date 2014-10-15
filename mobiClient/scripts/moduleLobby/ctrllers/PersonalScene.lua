local PersonalSceneCtrller = class("PersonalSceneCtrller",izx.baseCtrller)

function PersonalSceneCtrller:ctor(pageName,moduleName,initParam)
	print "PersonalSceneCtrller:ctor()"

--     enum ITEM_INDEX{
--     ITEM_TRUMPET            = 1,    //小喇叭
--     ITEM_CARD_RECORD        = 2,    //记牌器
--     ITEM_MATCH_TICKET       = 3,    //比赛卷
--     ITEM_KICK_OUT           = 4,    //踢人道具
--     ITEM_EXPRESSION_PARCEL  = 5,    //招财猫表情包
--     ITEM_RED_WINE           = 6,    //红酒
--     ITEM_EGG                = 8,    //鸡蛋
--     ITEM_FLOWER             = 9,    //鲜花
--     ITEM_LABA_COIN          = 50,//拉霸币

-- };
    self.data = {
        [0]={user = "每局游戏消耗",      get = "游戏胜利"}, --游戏币0
        [1]={user = "全服聊天",          get = "商店购买"}, --小喇叭1
        [2]={user = "查看牌桌上已出牌数",get = "商店礼包赠送"}, --记牌器2
        [3]={user = "参加比赛",          get = "商店购买"}, --参赛券3
        [4]={user = "踢走牌桌上的玩家",  get = "商店礼包赠送"}, --踢人卡4
        [5]={user = "游戏中聊天使用",    get = "商店礼包赠送"}, --招财喵表情5
        [6]={user = "赠送礼物",          get = "充值赠送"}, --红酒6
        [7]={user = "VIP",               get = "充值赠送"}, --VIP7
        [8]={user = "赠送礼物",          get = "充值赠送"}, --鸡蛋8
        [9]={user = "赠送礼物",          get = "充值赠送"}, --鲜花9
        [50]={user = "小游戏消耗货币",    get = "首充礼包赠送"}, --拉霸币50
        [51]={user = "游戏中刷新任务内容",get = "商店礼包赠送"}, --刷任务51
        [52]={user = "游戏中刷新宝牌",    get = "商店礼包赠送"}, --刷宝牌52
        [53]={user = "胜局积分中忽略败局记录",    get = "商店礼包赠送"}, --连胜卡53
        [54]={user = "创建擂台消耗道具",    get = "活动赠送"}, --比武卡
        [55]={user = "猜水果专用",    get = "任务,活动,充值"}, --水果卷55
        [56]={user = "话费充值",    get = "任务,活动,充值"}, --话费券
        
        [57]={user = "补签每日签到",    get = "签到界面购买"}, --补签卡
        [58]={user = "在单机游戏中获得好牌",    get = "单机游戏购买"}, --好牌卡
        [80]={user = "兑换礼物",          get = "牌桌任务领取"}, --元宝80


    };
    self.initlayer = nil;
    self.nikename = nil
    self.mailMsg = nil
    --self.userData = self.logic.userData
    self.super.ctor(self,pageName,moduleName,initParam);

end


function PersonalSceneCtrller:onEnter()
    -- body
    print "PersonalSceneCtrller:onEnter()"

end

function PersonalSceneCtrller:run()
    -- body
    print "PersonalSceneCtrller:run()"
    --self.userData = self.logic.userData
    --self.haschangename = self.logic.haschangename
    --need get msg pt_cl_send_friend_msg_req
    --pt_lc_send_friend_msg_not
--     NET_PACKET(FriendMsg){
--     guid    rcv_ply_guid_;      
--     guid    snd_ply_guid_;              //1000为系统发送
--     string  snd_nickname_;              //WEB端发送时，0为发送给所有人，否则将指定用户ID填入
--     string  message_;
--     int     type_;                      //0普通消息 1加好友请求 2邀请游戏请求 3同意加好友 4拒绝加好友 5删好友通知 6系统消息
--     int     time_;
--    }; 
    self.logic:addLogicEvent("MSG_SOCK_pt_lc_send_friend_msg_not",handler(self, self.onMailMsgData),self) 
    self.logic:addLogicEvent("MSG_headImage_rst_send",handler(self, self.onHeadImageData),self) 
    self.logic:addLogicEvent("MSG_Socket_pt_lc_send_user_data_change_not",handler(self, self.pt_lc_send_user_data_change_not_rec),self)

    self.logic:addLogicEvent("MSG_userName_rst_send",handler(self, self.onUserNameUpdate),self)

    --var_dump(self.mailMsg)
    if false ==  self.logic.haschangename then
        self:getCharacterNameChange()
    end 

    -- if nil == self.mailMsg then
    --     self.logic:pt_cl_get_unread_msg_req_send()
    -- end  

end

function PersonalSceneCtrller:onUserNameUpdate(event)
    print("PersonalSceneCtrller:onUserNameUpdate")
    --dump(event)
    self.nikename = event.message.sessionInfo.nickname
    self.view:updateNickName({ret=0})
end

function PersonalSceneCtrller:getCharacterNameChange()
    --local url = string.gsub(URL.NAMECHANGE,"{pid}",self.logic.userData.ply_guid_); --test
    --url="http://statics.hiigame.com/get/modify/count.do?uid=1113134339110250"
    --gBaseLogic:HTTPGetdata(url, 0, function(event)
    --    self:OnGetCharacterNameChange(event)
    --    end)
    local pdata = {
                    uid = self.logic.userData.ply_guid_,
            }
    HTTPPostRequest(URL.NAMECHANGE,pdata,function(event)
        self:OnGetCharacterNameChange(event)
        end)
end 

function PersonalSceneCtrller:setCharacterNameCommit()
    print("PersonalSceneCtrller:setCharacterNameCommit")
    --DEFAULT.URL.NAMECOMMIT = "http://t.payment.hiigame.com:18000/user/detail/upt?pid={pid}&ticket={ticket}&nickname={nickname}&face="
    local pdata = {
                    pid = self.logic.userData.ply_guid_,
                    ticket = self.logic.userData.ply_ticket_,
                    nickname = self.nikename,
            };

    HTTPPostRequest(URL.NAMECOMMIT,pdata,function(event)
        self:onUpdateNickNameAck(event)
        end)
   
end


function PersonalSceneCtrller:onMailMsgData(event)
    print("=====================PersonalSceneCtrller:onMailMsgData")
    --var_dump(event.message)
    self.mailMsg = event.message.content_
    print("=====================PersonalSceneCtrller:onMailMsgData")
    if self.mailMsg ~= nil then
        local newmsgList = {};
        for k,v in pairs(self.mailMsg) do
            newmsgList[v.snd_ply_guid_ .."_"..v.time_] = 1;            
        end
        local newMsg = json.encode(newmsgList);
        CCUserDefault:sharedUserDefault():setStringForKey("mailMsg"..self.logic.userData.ply_guid_,newMsg)
    end
    self.view:initMailInfo() 
    self.logic.hasNewMsg = 0;
end

function PersonalSceneCtrller:onHeadImageData(event)
    print("=====================PersonalSceneCtrller:onHeadImageData")
    if event ~= nil then 
        CCUserDefault:sharedUserDefault():setStringForKey(self.logic.userData.ply_guid_.."_faceUrl",event.message.url)
        self.view:updataHeadInfo(event.message) 
    end
end

function PersonalSceneCtrller:onUpdateNickNameAck(event)
    print("=====================PersonalSceneCtrller:onUpdateNickNameAck")
    if nil == event then 
        print("Update NickName Ack error")
        return
    end
    self.view:updateNickName(event)
end
function PersonalSceneCtrller:pt_lc_send_user_data_change_not_rec()
    self.view.ply_lobby_data_ = self.logic.userData.ply_lobby_data_
    self.view.ply_items_ = nil
    self.view.ply_items_ = {}
    self.view:userChange();
    if gBaseLogic.gameItems~=nil then
         for k,v in pairs(self.logic.userData.ply_items_) do
            if v.index_==80 then
                v.num_= self.logic.userData.ply_lobby_data_.gift_
            elseif v.index_==0 then
                v.num_= self.logic.userData.ply_lobby_data_.money_
            end

            if gBaseLogic.gameItems[v.index_]==1 and v.num_>0 then
                table.insert(self.view.ply_items_,v)
            end
        end
    else
        self.view.ply_items_ = self.logic.userData.ply_items_
    end
    if self.view.proertyLayer:isVisible() == true then
        
        self.view:initTableView(self.proertyLayer, 0,self.view.ply_items_);    
    end
end
function PersonalSceneCtrller:OnGetCharacterNameChange(event)
    print("=====================PersonalSceneCtrller:OnGetCharacterNameChange")
    local count = 0 
    if event == nil then 
        count = 1 
    else 
        count = event.count 
    end
    -- count = 0 
    self.view:updateNameChange(count)
end

return PersonalSceneCtrller;
