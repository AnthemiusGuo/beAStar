local JieSuanLayerCtrller = class("JieSuanLayerCtrller",izx.baseCtrller)

function JieSuanLayerCtrller:ctor(pageName,moduleName,initParam)
    -- self.data = {bType=1,cDouble=16,cCallScore=4,bShowCard=1,nBombCount=1,bSpring=0,bReverseSpring=0,bRobLord=2,cLord=1,vecUserResult={{nChairID=0,name='xiaohui1',nScore=12},{nChairID=1,name='xiaohui2',nScore=4},{nChairID=2,name='xiaohui3',nScore=3}}}
    -- self.data = self.logic.result;
    
	self.super.ctor(self,pageName,moduleName,initParam);

	

end

function JieSuanLayerCtrller:onEnter()
    -- body
end
function JieSuanLayerCtrller:notEnoughMoney()

    -- self.logic:LeaveGameScene(2);       
    -- self.logic.gameSocket:close();
    -- izx.baseAudio:stopMusic()
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
    -- local initParam = {msg=msg,type=2,needMoney=self.logic.curSocketConfigList.min_money_};
    -- gBaseLogic.lobbyLogic:dispatchEventToCache({
    --     name = "MSG_GAME_SOCKET_KICK",
    --     message = {title="游戏提醒",info=msg,initParam=initParam}
    --     }
    -- );
    
end
function JieSuanLayerCtrller:run()
	JieSuanLayerCtrller.super.run(self);
	-- self.logic:addLogicEvent("moneyNotEnough",handler(self, self.notEnoughMoney),self)
    if self.logic.moneyNotEnough==1 or self.logic.moneyNotEnough==3 then
        local money = self.logic.curSocketConfigList.min_money_;
            local  status = 2
            if self.logic.moneyNotEnough==1 then
                status=2
            elseif self.logic.dibaomoneyNotEnough==1 then
                status=4
            end
            gBaseLogic:onNeedMoney("gameenter", money, status)
    end
end

function JieSuanLayerCtrller:onMsgData(event)
	
end

return JieSuanLayerCtrller;