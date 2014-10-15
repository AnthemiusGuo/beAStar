local DengLuJiangLiLayerCtrller = class("DengLuJiangLiLayerCtrller",izx.baseCtrller)

function DengLuJiangLiLayerCtrller:ctor(pageName,moduleName,initParam)
	-- self.lobbyLogic = require("moduleLobby.logics.LobbyLogic").new();
    self.data = {
        ply_login_award2_ = '',
        ply_vip_ = ''
      
 
    };
    

	DengLuJiangLiLayerCtrller.super.ctor(self,pageName,moduleName,initParam);
end

function DengLuJiangLiLayerCtrller:run()
	-- var_dump(gBaseLogic.lobbyLogic.userData.ply_login_award2_)
	
	-- var_dump(gBaseLogic.lobbyLogic.userData.ply_login_award2_);
	self.data.ply_login_award2_ = gBaseLogic.lobbyLogic.userData.ply_login_award2_;
    self.data.ply_vip_ = gBaseLogic.lobbyLogic.userData.ply_vip_;
	-- self.logic:requestHTTDengLuJiangLi();
	-- -- self.requestHTTDengLuJiangLi()
	-- self.logic:addLogicEvent(self.logic.MSG_HTTP_DengLuJiangLi,handler(self, self.onMsgData),self)
 	self.view:initBaseInfo();
	DengLuJiangLiLayerCtrller.super.run(self);
end

function DengLuJiangLiLayerCtrller:onMsgData(event)
	-- print("DengLuJiangLiLayerCtrller:onMsgData")
	self.data.content = event.message;
	self.view:initBaseInfo();
end
 
return DengLuJiangLiLayerCtrller;