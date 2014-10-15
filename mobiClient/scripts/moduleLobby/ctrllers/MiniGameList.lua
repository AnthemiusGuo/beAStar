local MiniGameListCtrller = class("MiniGameListCtrller",izx.baseCtrller)

function MiniGameListCtrller:ctor(pageName,moduleName,initParam)
    
	MiniGameListCtrller.super.ctor(self,pageName,moduleName,initParam);
end

function MiniGameListCtrller:run()
    print ("MiniGameListCtrller:run")
    self.logic.miniGameCfg = self.logic.miniGameCfg or {};
    gBaseLogic:getMiniGameListHTTPConfig();
    self.logic:addLogicEvent("MSG_SOCK_pt_lc_get_miniGame_ack",handler(self, self.pt_lc_get_miniGame_ack_handler),self);
end


function MiniGameListCtrller:pt_lc_get_miniGame_ack_handler(message)
    print("pt_lc_get_miniGame_ack_handler")
    gBaseLogic:unblockUI();

    local SocketConfig = -1;
    local initparam = {};

    for k,v in pairs(message.message.server_datas_) do
        if (configGameModule[v.game_id_]) then
            self.logic.miniGameCfg[v.game_id_].SocketConfig = {socketIp = v.server_addr_,socketPort = v.server_port_};
            self.logic.miniGameCfg[v.game_id_].initparam = {min_money_=v.min_money_,base_bet_=v.base_bet_};
        else
            
        end
    end
    self.view:initBaseInfo();
end

function MiniGameListCtrller:onEnter()
    -- body
end

return MiniGameListCtrller;