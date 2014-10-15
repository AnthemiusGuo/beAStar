local MeiRiBiZuoLayerCtrller = class("MeiRiBiZuoLayerCtrller",izx.baseCtrller)

function MeiRiBiZuoLayerCtrller:ctor(pageName,moduleName,initParam)
	-- self.lobbyLogic = require("moduleLobby.logics.LobbyLogic").new();
    self.data = {

    };
    self.taskMsg = nil

	MeiRiBiZuoLayerCtrller.super.ctor(self,pageName,moduleName,initParam);
end

function MeiRiBiZuoLayerCtrller:run()
	
 	self.view:initBaseInfo();
	MeiRiBiZuoLayerCtrller.super.run(self);
	self:getEverydayTask();
end

function MeiRiBiZuoLayerCtrller:onMsgData(event)
	
	self.view:initBaseInfo();
end

function MeiRiBiZuoLayerCtrller:getEverydayTask()
    local url = URL.DAYTASK
    echoInfo("get EverydayTask: "..url);
    self.view:Waitingbg()
    self.view:loadingAni()
    HTTPPostRequest(url, nil, function(event)
        self:onUpdateDayTask(event)
        end)
end

function MeiRiBiZuoLayerCtrller:onUpdateDayTask(event)	
	self.taskMsg = event
	--var_dump(self.taskMsg)
	self.view:updateInfo(self.taskMsg)
end

return MeiRiBiZuoLayerCtrller;