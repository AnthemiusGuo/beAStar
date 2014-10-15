local BiSaiFailSceneCtrller = class("BiSaiFailSceneCtrller",izx.baseCtrller)

function BiSaiFailSceneCtrller:ctor(pageName,moduleName,initParam)
    self.data = {
        type = 0,
        index = 59,--59 复活券
        reliveNum=0,
        reliveCount = 0,
        canRelive = 0,
        matchID = 0,
        matchOrderID = 0,
        totoalRound = 0,
        curRond = 0,
        ply_items={},
        matchtyp=0,
        pre_match=0
    }; 
    if initParam.noti==1 then
    	self.data.type=0
    	
    	self.data.matchtyp=initParam.match_type_;
    	
    end
    if initParam.pre_match~=nil then
    	self.data.pre_match = initParam.pre_match
    end
    if initParam.match_id_~=nil then
    	self.data.matchID=initParam.match_id_;
    end
    if initParam.match_type_~=nil then
    	self.data.matchtyp=initParam.match_type_;
    end
    if initParam.match_order_id_~=nil then
    	self.data.matchOrderID=initParam.match_order_id_;
    end
    -- if initParam
    self.matchTitle = {
        [1]="images/BiSai/bisai_sanyuansai.png",
        [2]="images/BiSai/bisai_10yuansai.png",
        [3]="images/BiSai/bisai_50yuansai.png",
        [4]="images/BiSai/bisai_100yuansai.png",
        [5]="images/BiSai/bisai_300yuansai.png",
        [6]="images/BiSai/bisai_500yuansai.png",
    }
    self.matchTimeHandler = nil
    self.matchTime = 0

	BiSaiFailSceneCtrller.super.ctor(self,pageName,moduleName,initParam)
    print("BiSaiFailSceneCtrller:ctor")
    var_dump(initParam)
    if nil ~= initParam then 
        if initParam.nJifen ~= nil and initParam.nJifen <= 0 then 
            self.data.type = 1 
        elseif initParam.avoid ~= nil and initParam.avoid ~= 0 then 
            self.data.type = 2 
        end 
    end
end

 

function BiSaiFailSceneCtrller:run()
    print ("BiSaiFailSceneCtrller:run")
  
    self.logic:addLogicEvent("MSG_SOCK_pt_lc_match_reborn_ack",handler(self, self.pt_lc_match_reborn_ack),self)

    self.logic:addLogicEvent("MSG_SOCK_pt_lc_match_lost_notf",handler(self, self.pt_lc_match_lost_notf),self)

    self.logic:addLogicEvent("MSG_Socket_pt_lc_match_round_end_notf",handler(self, self.pt_lc_match_round_end_notf),self)

    -- self.logic:addLogicEvent("MSG_Socket_pt_lc_match_perpare_notf",handler(self, self.pt_lc_match_perpare_notf),self)

    self.logic:addLogicEvent("MSG_Socket_pt_lc_match_round_avoid_notf",handler(self, self.pt_lc_match_round_avoid_notf),self)

    self.logic:addLogicEvent("MSG_Socket_pt_lc_match_result_notf_notf",handler(self, self.pt_lc_match_result_notf_notf),self)

    self.logic:addLogicEvent("MSG_Socket_pt_lc_send_user_data_change_not",handler(self, self.pt_lc_send_user_data_change_not),self)

    self.logic:addLogicEvent("MSG_change_chongzhi_btn",handler(self, self.reliveCardPayResult),self)

     self.logic:addLogicEvent("MSG_SOCK_pt_lc_do_sign_match_ack",handler(self, self.pt_lc_do_sign_match_ack),self)

    BiSaiFailSceneCtrller.super.run(self);

    if gBaseLogic.lobbyLogic.userData ~= nil then 
        self.data.ply_items = gBaseLogic.lobbyLogic.userData.ply_items_;
        self.data.reliveNum = self:getItemNumber(self.data.index);
    end 
    if gBaseLogic.lobbyLogic.matchLost~=nil then
	    self:resetData(gBaseLogic.lobbyLogic.matchLost)
	end
    self.view:initBaseInfo();
end

function BiSaiFailSceneCtrller:resetData(data)
    if data ~= nil then 
        self.data.canRelive = data.can_relive_
        self.data.reliveCount = data.relive_count_
        self.data.matchID = data.match_id_
        self.data.matchtyp = data.match_type_
        self.data.matchOrderID = data.match_order_id_
        self.data.totoalRound = data.totoal_round_
        self.data.curRond = data.round_index_
    end
end 
function  BiSaiFailSceneCtrller:pt_lc_do_sign_match_ack(event)
    print("pt_lc_do_sign_match_ack")
    local message = event.message;

    if message.ret_ == 0 then
    	izxMessageBox("退赛成功","温馨提示")
    	gBaseLogic.lobbyLogic:goBackToMain();
        -- self.logic:sendReloadUserData()
    elseif message.ret_ == -5 then
    	izxMessageBox("本轮还没有结束，不能退出","温馨提示");
    else
    	gBaseLogic.lobbyLogic:goBackToMain();
    end
end
function BiSaiFailSceneCtrller:pt_cl_match_reborn_req()
    print("pt_cl_match_reborn_req")
    self.view:loadingAni()
    local socketMsg = { opcode = 'pt_cl_match_reborn_req',
                        ply_guid_=gBaseLogic.lobbyLogic.userData.ply_lobby_data_.ply_guid_,
                        match_id_=self.data.matchID,
                        match_order_id_= self.data.matchOrderID,
                        round_index_=self.data.curRond+1}
    gBaseLogic.lobbyLogic:sendLobbySocket(socketMsg);
    var_dump(socketMsg)
    --for test 
    --[[
    function testMatchReborn()
        local info = {
            ret_ = 0, --0：复活成功 -1:比赛不存在 -2：不能复活 -3：其他

            match_id_=1,
            match_order_id_=0,
            data_={ply_guid_=0,nick_name_="JL",current_score_=0,relive_count_=0,avoid_count_=0}

        }
        gBaseLogic.lobbyLogic:dispatchLogicEvent({
                    name = "MSG_SOCK_pt_lc_match_reborn_ack",
                    message = info
                });
    end 
    scheduler.performWithDelayGlobal(testMatchReborn, 0.2)
    --]]
end 

    -- int ret_;//0：复活成功 -1:比赛不存在 -2：不能复活 -3：其他
    -- int match_id_;
    -- int match_order_id_;
    -- MatchPlayerData data_;
function BiSaiFailSceneCtrller:pt_lc_match_reborn_ack(event)
    print("pt_lc_match_reborn_ack")
    local message = event.message;
    self.view:unWaitingAni()
    var_dump(message)
    if message.ret_ == 0 then
        izxMessageBox("恭喜您复活成功！", "温馨提示")
        self.data.type = 0
        self.view:initBaseInfo();
    else 
        if message.ret_ == -1 then 
            izxMessageBox("比赛不存在", "温馨提示")
        elseif message.ret_ == -2 then 
            izxMessageBox("不能复活", "温馨提示")
        elseif message.ret_ == -4 then 
            izxMessageBox("此轮已经开始，不能复活", "温馨提示")
        else
        	izxMessageBox("不能复活", "温馨提示")
        end
    end
end

    -- guid ply_guid_;
    -- char can_relive_;//0:不能复活 1:能复活
    -- int relive_count_;//复活次数
    -- int match_id_;
    -- int match_order_id_;
    -- int round_index_;//失败的轮数
    -- int totoal_round_;
    -- MatchPlayerData data_;//玩家本身的信息
function BiSaiFailSceneCtrller:pt_lc_match_lost_notf(event)
    print("BiSaiFailSceneCtrller:pt_lc_match_lost_notf")
    local message = event.message;
    --self.view:unWaitingAni()
    var_dump(message,3)
    self:resetData(gBaseLogic.lobbyLogic.matchLost)
    self.view:initBaseInfo();
end 

    -- int match_id_;
    -- int match_order_id_;
    -- int round_index_;
    -- int next_start_time_;//倒数秒数
function BiSaiFailSceneCtrller:pt_lc_match_round_end_notf(event)
    print("BiSaiFailSceneCtrller:pt_lc_match_round_end_notf")
    local message = event.message;
    -- var_dump(message)
    self.matchTime = message.next_start_time_;
    if gBaseLogic.lobbyLogic.matchLost==nil then
	    if self.matchTimeHandler == nil then
	        self.matchTimeHandler = scheduler.scheduleGlobal(function ()
	            self.matchTime = self.matchTime -1;
	            self.view.labelRank:setString("比赛马上要开始，请不要离开！倒计时"..os.date("%M:%S", self.matchTime));
	            end,1)
	    end
	end
    
end 

    -- int match_id_;
    -- int match_order_id_;
    -- ServerData2 data_;
-- function BiSaiFailSceneCtrller:pt_lc_match_perpare_notf(event)
--     print("BiSaiFailSceneCtrller:pt_lc_match_perpare_notf")
--     local message = event.message;
--     --self.view:unWaitingAni()
--     echoError("BiSaiFailSceneCtrller:::")
--     var_dump(message)
--     gBaseLogic.lobbyLogic:startMatchGame("moduleDdz",message.match_id_,0)
--         gBaseLogic.sceneManager:removePopUp("BiSaiFailScene");
--     -- if message.newMatch == false then 
--     --     if message.server_id_change == 0 then  
--     --         print("11111111111111111111111111")
--     --         --gBaseLogic.sceneManager.currentPage.view:closePopBox();
--     --         gBaseLogic.sceneManager:removePopUp("BiSaiFailScene");
--     --         gBaseLogic.gameLogic:showGameScene()
--     --     else 
--     --         print("22222222222222222222222222")
            
--     --         --gBaseLogic.gameLogic:LeaveGameScene(-1)
--     --         gBaseLogic.lobbyLogic:startMatchGame("moduleDdz",message.match_id_,0)
--     --         gBaseLogic.sceneManager:removePopUp("BiSaiFailScene");
--     --     end 
--     -- else 
--     --     print("33333333333333333333333333333")
        
--     --     --gBaseLogic.gameLogic:LeaveGameScene(-1)
        
--     -- end
-- end

    -- guid ply_guid_;
    -- int  match_id_;//比赛ID
    -- int  match_order_id_;//比赛场次ID
    -- int  round_index_;//跳过的轮数
    -- int  totoal_round_;//总共的轮数
function BiSaiFailSceneCtrller:pt_lc_match_round_avoid_notf(event)
    print("BiSaiFailSceneCtrller:pt_lc_match_round_avoid_notf")
    local message = event.message;
    --self.view:unWaitingAni()
    var_dump(message)
    self.data.type = 2
    self.view:initBaseInfo();
end

-- NET_PACKET(MatchPlayerRank)
-- {
--     int rank_index_;//排名 1～
--     guid ply_guid_;
-- };
--     int match_id_;
--     string match_name_;
--     int rank_index_;
--     vector<MatchPlayerRank> ply_vec_;
function BiSaiFailSceneCtrller:pt_lc_match_result_notf_notf(event)
    print("BiSaiFailSceneCtrller:pt_lc_match_result_notf_notf")
    local message = event.message;
    --self.view:unWaitingAni()
    var_dump(message)
    gBaseLogic.sceneManager:removePopUp("BiSaiFailScene");
    gBaseLogic.lobbyLogic:showBiSaiWinScene()
end


function BiSaiFailSceneCtrller:pt_lc_send_user_data_change_not(event)
    print("BiSaiFailSceneCtrller:pt_lc_send_user_data_change_not")
    self.data.ply_items = event.message.ply_items_
    self.data.reliveNum = self:getItemNumber(self.data.index) 
    self.view.labelReliveNum:setString(self.data.reliveNum)
end

function BiSaiFailSceneCtrller:reliveCardPayResult(event)
    print("reliveCardPayResult")
    if event.message.code == 0 then 
        self.data.ply_items = gBaseLogic.lobbyLogic.userData.ply_items_
        self.data.reliveNum = self:getItemNumber(self.data.index) 
        self.view.labelReliveNum:setString(self.data.reliveNum)
    else
        izxMessageBox("支付失败", "支付提示")
    end
end 

function BiSaiFailSceneCtrller:getItemNumber(index) 
    local num = 0
    for k,v in pairs(self.data.ply_items) do 
        print(index,v.index_,v.num_)
        if v.index_ == index then 
            num = v.num_ 
        end
    end 
    return num
end

function BiSaiFailSceneCtrller:getItemUrl(index) 
    local url = ""
    for k,v in pairs(self.data.ply_items) do 
        if v.index_ == index then 
            url = v.url_ 
        end
    end 
    return url
end

function BiSaiFailSceneCtrller:findPayItemData(idx)
    for k,v in pairs(self.data.payitemslist) do 
        for k1,v1 in pairs(v.content) do 
            if v1.idx == idx then 
                return k, v1.num
            end
        end
    end
    return 1,0
end

function BiSaiFailSceneCtrller:getReliveCardPayInfo()
    print("BiSaiFailSceneCtrller:getReliveCardPayInfo")
    self.data.payitemslist = gBaseLogic.lobbyLogic.paymentItemList;
    local idx,num = self:findPayItemData(self.data.index)
    if idx == 1 and num == 0 then 
        izxMessageBox("暂时没有该商品！","温馨提示");
    else
        local price = self.data.payitemslist[idx].price 
        print(idx,num, price)
        local info = {url = self:getItemUrl(self.data.index),count = num, money = price..".00"}
        var_dump(self.data.payitemslist[idx])
        self.view:showReliveCardPay(info, self.data.payitemslist[idx], display.cx, display.cy)
    end
end 

return BiSaiFailSceneCtrller;