local PokerKingSceneCtrller = class("PokerKingSceneCtrller",izx.baseCtrller)

function PokerKingSceneCtrller:ctor(pageName,moduleName,initParam)
    self.data = {
    };
    self.initlayer = nil;
    
	self.super.ctor(self,pageName,moduleName,initParam);
end

function PokerKingSceneCtrller:onEnter()
    -- body
end

function PokerKingSceneCtrller:run()
	print("PokerKingSceneCtrller:run");
	self.logic:onSocketGetRankList(0);
    self.logic:addLogicEvent("MSG_SOCK_pt_lc_get_rank_list_ack",handler(self, self.onMsgData),self);
 	PokerKingSceneCtrller.super.run(self);
end

function PokerKingSceneCtrller:onMsgData(event)
	print("PokerKingSceneCtrller:onMsgData");
	gBaseLogic:unblockUI()
	-- self.data.amount_ = event.message.amount_;
	-- self.data.money_ = event.message.money_;
	-- self.data.isBindMobile_ = event.message.isBindMobile_;
	print ("=========================================");
	var_dump (event.message.rank_list_);
	print ("=========================================");
end

return PokerKingSceneCtrller;