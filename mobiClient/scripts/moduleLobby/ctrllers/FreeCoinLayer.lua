local FreeCoinLayerCtrller = class("FreeCoinLayerCtrller",izx.baseCtrller)

function FreeCoinLayerCtrller:ctor(pageName,moduleName,initParam)
    self.super.ctor(self,pageName,moduleName,initParam);
    self.data = {
        minMoney = 1000,
        cont = {
        --{"破产救助","您今天的救助已领完，升级成VIP2可每天多领一次哦！","成为VIP","popup_pic_rili.png"},
        {1,"破产救助","只有当你破产的时候才能领取救助哦！","领取","popup_pic_pochan.png"},
            {2,"签到有礼","每日签到领取金币奖励，记得每天来签到哦！","去签到","popup_pic_rili.png"},
            {3,"房间任务","每天游戏一定局数或时间，都能获得金币奖励","去打牌","popup_pic_renwu1.png"},
            {4,"成就奖励","您还有未完成的成就哦，快去看看！","去看看","popup_pic_baoxiang2.png"},
            {5,"休闲小游戏","打牌累了，去小游戏放松下。还能赢取大量金币哦！","去看看","xinshoutishi_labaji.png"}
        },
        state = gBaseLogic.lobbyLogic.userData.ply_login_award2_.today_
    }
    local i = 0;
    if gBaseLogic.MBPluginManager.distributions.checkapple then
        table.remove(self.data.cont,2-i)
        i = i+1
    end
    if gBaseLogic.MBPluginManager.distributions.nominigame then
        table.remove(self.data.cont,5-i)
        i = i+1
    end

    -- if gBaseLogic.lobbyLogic.relief_times_ack_handler==nil then
        gBaseLogic.lobbyLogic:pt_cl_get_relief_times_req()
    -- end
end

function FreeCoinLayerCtrller:onEnter()
    -- body
end

function FreeCoinLayerCtrller:run()
	FreeCoinLayerCtrller.super.run(self);
    if self.logic.userData.ply_lobby_data_.money_<1000 then
        self.logic:sendReloadUserData()
    end
    self.logic:addLogicEvent("MSG_SOCK_pt_lc_get_relief_ack",handler(self, self.onMsgReliefAck),self)
    self.logic:addLogicEvent("MSG_Socket_pt_lc_send_user_data_change_not",handler(self, self.pt_lc_send_user_data_change_not),self)
    self.logic:addLogicEvent("MSG_Socket_pt_lc_get_relief_times_ack",handler(self, self.pt_lc_get_relief_times_ack),self)
    
end

function FreeCoinLayerCtrller:pt_cl_get_relief_times_req()
  local loginMsg = {opcode = 'pt_cl_get_relief_times_req'};
  --self.view:loadingAni()
  gBaseLogic.lobbyLogic:sendLobbySocket(loginMsg);
end

function FreeCoinLayerCtrller:pt_lc_get_relief_times_ack(event)
    --self.view:unWaitingAni()
    self.view:initBaseInfo()
end
--ret_;/0:成功 -1:没有到时间 -2:领完了 -3:未知
function FreeCoinLayerCtrller:onMsgReliefAck(event)
    self.view:unWaitingAni()
    if event.message.ret_ == 0 then 
        gBaseLogic.lobbyLogic.relief_times_ = gBaseLogic.lobbyLogic.relief_times_ - 1
        print("FreeCoinLayerCtrller:onMsgReliefAck"..gBaseLogic.lobbyLogic.relief_times_)
        self.view:initBaseInfo()
        gBaseLogic.lobbyLogic:sendReloadUserData()
    else 
        if event.message.ret_ == -1 then 
            izxMessageBox("没有到时间", "提示") 
        elseif event.message.ret_ == -2 then 
            izxMessageBox("领完了", "提示") 
        else 
            izxMessageBox("未知", "提示") 
        end
    end 
end
function FreeCoinLayerCtrller:pt_lc_send_user_data_change_not(event)
    self.view:initBaseInfo()
end

return FreeCoinLayerCtrller;
