local NewJieSuanLayerCtrller = class("NewJieSuanLayerCtrller",izx.baseCtrller)

function NewJieSuanLayerCtrller:ctor(pageName,moduleName,initParam)
    -- self.data = {bType=1,cDouble=16,cCallScore=4,bShowCard=1,nBombCount=1,bSpring=0,bReverseSpring=0,bRobLord=2,cLord=1,vecUserResult={{nChairID=0,name='xiaohui1',nScore=12},{nChairID=1,name='xiaohui2',nScore=4},{nChairID=2,name='xiaohui3',nScore=3}}}
    -- self.data = self.logic.result;
    
    self.super.ctor(self,pageName,moduleName,initParam);
    
    self.data={hadColse = false}
end

function NewJieSuanLayerCtrller:onEnter()
    -- body
end 

function NewJieSuanLayerCtrller:notEnoughMoney()
    local msg = "游戏币不够，无法继续！请充值。"
    gBaseLogic:confirmBox({
        msg=msg,
        btnTitle={btnConfirm="充值",btnCancel="返回大厅"},
        callbackConfirm = function()
            print("self.logic.moneyNotEnoughcallbackConfirm")
            local money = self.logic.curSocketConfigList.min_money_;
            local  status = 2
            if self.logic.moneyNotEnough==1 then
                status=2
            elseif self.logic.dibaomoneyNotEnough==1 then
                status=4
            end
            gBaseLogic:onNeedMoney("gameenter", money, status)
            -- if self.logic.gameSocket~=nil and self.logic.gameSocket.isConnect == 1 then
            --     self.logic.is_chang_table = 3
            --     self.logic:onSocketJoinTable();
            --     gBaseLogic.sceneManager:removePopUp("JieSuanLayer");
            --     gBaseLogic.sceneManager.currentPage.ctrller:reInit()
            -- else
            --     self.logic:LeaveGameScene(-1)
            -- end
            
        end,
        callbackCancel = function()
            self.logic:LeaveGameScene(2)
            
        end})
    
end

function NewJieSuanLayerCtrller:run()
    NewJieSuanLayerCtrller.super.run(self);
    -- self.logic:addLogicEvent("moneyNotEnough",handler(self, self.notEnoughMoney),self)
    gBaseLogic.lobbyLogic:addLogicEvent("MSG_change_chongzhi_btn",handler(self, self.restchongzhi),self)

    --gBaseLogic.lobbyLogic:addLogicEvent("MSG_Socket_pt_lc_match_perpare_notf",handler(self, self.pt_lc_match_perpare_notf),self)

    --gBaseLogic.lobbyLogic:addLogicEvent("MSG_Socket_pt_lc_match_round_avoid_notf",handler(self, self.pt_lc_match_round_avoid_notf),self)

    print("NewJieSuanLayerCtrller")
    if self.logic.lostMoneyLimit ~=nil and self.logic.lostMoneyLimit == 1 and self.logic.isMatch==0 then
        local info = "今天已经输了400万游戏币咯！休息，休息一下，明天再来！"
        -- gBaseLogic:confirmBox(initParam)
         gBaseLogic:confirmBox({
            msg=info,
            buttonCount=1,
            callbackConfirm = function()
                self.logic:LeaveGameScene(-1)
                
            end})
        return
    end
    if self.logic.achieve_award_not~=nil and self.logic.isMatch==0 then
        print("11111");
        self.logic:showAchievefinishContent(self.logic.achieve_award_not);

    end
    -- if self.logic.daily_task_award_not~=nil then
    --     print("self.logic.daily_task_award_not")
    --     var_dump(self.logic.daily_task_award_not)
    --     local msg = self.logic.daily_task_award_not.desc_
    --     gBaseLogic:confirmBox({
    --         msg=msg,
    --         btnTitle={btnConfirm="领奖"},
    --         callbackConfirm = function()
    --             local socketMsg = {opcode = 'pt_cb_get_daily_task_award_req',index_=self.logic.daily_task_award_not.index_};
    --             gBaseLogic.gameLogic:sendGameSocket(socketMsg);
               
                
    --         end,
    --         buttonCount=1
    --     })
        
            
    -- end
    if  self.logic.dibaomoneyNotEnough==1 and self.logic.isMatch==0 then
        local money = self.logic.curSocketConfigList.min_money_;
        local  status = 2
        gBaseLogic:onNeedMoney("gameenter", money, status)
            
            
    else
        if gBaseLogic.is_robot == 0 and self.logic.isMatch==0 then
            local userMoney = gBaseLogic.lobbyLogic.userData.ply_lobby_data_.money_
            if userMoney < self.logic.curSocketConfigList.min_money_ then
                if userMoney<1000 then
                    gBaseLogic:onNeedMoney("gameenter", self.logic.curSocketConfigList.min_money_, 2)
                else
                    if self.logic.curSocketConfigList.level>1 then
                        local msg = "您的游戏币低于本场最低进入要求，您可以选择充值或前往%s"
                        local toLevel = 1
                        local isLaiZi = self.logic.curSocketConfigList.isLaiZi
                        if self.logic.curSocketConfigList.level==3 then
                        --     if isLaiZi==1 then
                        --         msg = "您的游戏币低于本场最低进入要求，您可以选择充值或前往癞子初级场"
                        --     else
                        --         msg = "您的游戏币低于本场最低进入要求，您可以选择充值或前往欢乐初级场"
                        --     end
                        -- else
                            for k,v in pairs(gBaseLogic.lobbyLogic.server_datas_) do
                                if v.isLaiZi == isLaiZi then
                                    if tonumber(v.level) == 2 then
                                        if v.min_money_>userMoney then
                                            toLevel = 1
                                        else
                                            toLevel = 2
                                        end
                                        break;
                                    end
                                end
                            end
                        end
                        local confignameList = {}
                        confignameList[1] = "初级场"
                        confignameList[2] = "中级场"
                       
                        local toname = string.format("前往%s",confignameList[toLevel])
                        msg = string.format(msg,confignameList[toLevel])
                        gBaseLogic:confirmBox({
                            msg=msg,
                            btnTitle={btnConfirm="充值",btnCancel=toname},
                            callbackConfirm = function()
                            print("gameenter"..self.logic.curSocketConfigList.min_money_)
                            gBaseLogic.scheduler.performWithDelayGlobal(function()
                                gBaseLogic:onNeedMoney("gameenter", self.logic.curSocketConfigList.min_money_, 2)
                                end, 0.2)
                                
                                -- local this_level = self.logic.curSocketConfigList.level - 1;
                                
                                
                            end,
                            callbackCancel = function()
                                -- local isLaiZi = self.logic.curSocketConfigList.isLaiZi
                                gBaseLogic.lobbyLogic:startGameByTypLevel2(isLaiZi,toLevel)
                                
                            end})
                    else
                        self.logic:LeaveGameScene(2)
                    end
                end
            end 
        end
    end
end
--[[
function NewJieSuanLayerCtrller:pt_lc_match_perpare_notf(event)
    print("NewJieSuanLayerCtrller:pt_lc_match_perpare_notf")
    local message = event.message 
    var_dump(message)
    print(self.data.hadColse)
    if self.data.hadColse == nil or self.data.hadColse == true then 
        return
    end
    print("000000000000000000000000")
    if message.newMatch == false then 
        if self.logic.gameSocket~=nil and self.logic.gameSocket.isConnect == 1 then
            if message.server_id_change == 0 then  
                print("11111111111111111111")
                if self.view.schedulerMatch ~= nil then 
                    scheduler.unscheduleGlobal(self.view.schedulerMatch)
                end
                gBaseLogic.sceneManager:removePopUp("NewJieSuanLayer");
            else 
                print("22222222222222222222222")
                self.logic:LeaveGameScene(-1)
                --gBaseLogic.sceneManager:removePopUp("NewJieSuanLayer");
                gBaseLogic.lobbyLogic:startMatchGame("moduleDdz",message.match_id_,0)

            end
        end 
    end
end 
--]]
--[[
function NewJieSuanLayerCtrller:pt_lc_match_round_avoid_notf(event)
    pring("NewJieSuanLayerCtrller:pt_lc_match_round_avoid_notf")
    var_dump(event,3)
    local message = event.message 
  
    if self.view.schedulerMatch ~= nil then 
        scheduler.unscheduleGlobal(self.view.schedulerMatch)
    end
    gBaseLogic.sceneManager:removePopUp("NewJieSuanLayer");
    gBaseLogic.lobbyLogic:showBiSaiFailScene({avoid =1})
end 
--]]

function NewJieSuanLayerCtrller:restchongzhi(event)
    local message = event.message
    print("restchongzhi"..message.code)
    if gBaseLogic.is_robot == 0 then
        
        -- if self.logic.dibaomoneyNotEnough==1 then
            
        --     if message.code==0 then
        --         self.logic.dibaomoneyNotEnough = 0
        --     else
        --         self.logic:showdibaomsg();
        --     end
        -- end
        
        if message.code==0 then
            self.logic.dibaomoneyNotEnough = 0
        else
            print(gBaseLogic.lobbyLogic.userData.ply_lobby_data_.money_,self.logic.curSocketConfigList.min_money_)
            if gBaseLogic.lobbyLogic.userData.ply_lobby_data_.money_ < self.logic.curSocketConfigList.min_money_ then
                if gBaseLogic.lobbyLogic.userData.ply_lobby_data_.money_<1000 then
                    local info = "很遗憾你已经破产了，去大厅领取免费金币吧！"
               
                    gBaseLogic.lobbyLogic.pochanTolobby = 1;
                     gBaseLogic:confirmBox({
                        msg=info,
                        buttonCount=1,
                        callbackConfirm = function()
                            self.logic:LeaveGameScene(-1)
                            
                        end})
                else
                    self.logic:LeaveGameScene(2)
                    -- if self.logic.curSocketConfigList.level>1 then
                    --     local msg = "您的游戏币低于本场次最低要求，请选择？"
                    --     gBaseLogic:confirmBox({
                    --         msg=msg,
                    --         btnTitle={btnConfirm="去低级场",btnCancel="返回大厅"},
                    --         callbackConfirm = function()
                    --             local this_level = self.logic.curSocketConfigList.level - 1;
                    --             local isLaiZi = self.logic.curSocketConfigList.isLaiZi
                    --             gBaseLogic.lobbyLogic:startGameByTypLevel2(isLaiZi,1)
                                
                    --         end,
                    --         callbackCancel = function()
                    --             self.logic:LeaveGameScene(2)
                                
                    --         end})
                    -- else
                        
                    -- end
                end
            end 
        end 
    end
end
function NewJieSuanLayerCtrller:onMsgData(event)
    
end

return NewJieSuanLayerCtrller;