local LotteryDrawCtrller = class("LotteryDraw", izx.baseCtrller)

  function LotteryDrawCtrller:ctor(pageName,moduleName,initParam)
    self.super.ctor(self,pageName,moduleName,initParam);
    
  end
  function LotteryDrawCtrller:refreshluckDataList(flag)
  		if gBaseLogic.gameLogic.luck_data_list==nil or flag then
	    	self:pt_cb_get_luck_data_list_req()
	    else
	    	for i=1,#gBaseLogic.gameLogic.luck_data_list do
				self.view:showAward(i,gBaseLogic.gameLogic.luck_data_list[i]);
			end
	    end
  end
  function LotteryDrawCtrller:onEnter()
    print("LotteryDrawCtrller:onEnter");

  end
  
  function LotteryDrawCtrller:run()
    print("LotteryDrawCtrller:run");
    self:refreshluckDataList()
    -- self.logic:addLogicEvent("MSG_SOCK_pt_bc_get_task_award_ack", handler(self, self.pt_bc_get_task_award_ack), self);
    self.logic:addLogicEvent("MSG_SOCK_pt_bc_get_luck_draw_ack", handler(self, self.pt_bc_get_luck_draw_ack), self);
    self.logic:addLogicEvent("MSG_SOCK_pt_bc_get_luck_data_list_ack", handler(self, self.pt_bc_get_luck_data_list_ack), self);
    self.logic:addLogicEvent("MSG_SOCK_pt_bc_get_luck_draw_record_ack", handler(self, self.pt_bc_get_luck_draw_record_ack), self);
    self.logic:addLogicEvent("MSG_SOCK_update_lotteryDraw_round", handler(self, self.update_lotteryDraw_round), self);
    
    if self.logic.LotteryDraw.needHistory then
      self:sendHistroyReq();
    end
  end
-- function LotteryDrawCtrller:pt_bc_get_task_award_ack(event)--当前抽奖次数
--     local message = event.message;
--     if(message.ret_ == 1)then
--           self.logic.LotteryDraw.curTimes = message.last_task_index_;
--           --当天最大抽奖次数
--           self.logic.LotteryDraw.MaxTimes = message.luck_draw_times_;
--           --单场次已完成局数
--           self.logic.LotteryDraw.curGames = message.cur_val_;
--           --单场次抽奖次数限制
--           self.logic.LotteryDraw.reqGames = message.config_round_;
--           --抽奖次数判断
--           if self.logic.LotteryDraw.curTimes < self.logic.LotteryDraw.MaxTimes then
--             --抽奖局数判断
--             if self.logic.LotteryDraw.reqGames ~= 0 then
--               if self.logic.LotteryDraw.curGames >= self.logic.LotteryDraw.reqGames then
--                 --self.logic.gamePage.view:playTaskNumAni()
--                   self.logic.gamePage.view:updateLotteryDraw(self.logic.LotteryDraw.reqGames,self.logic.LotteryDraw.reqGames)
--               else
--                   self.logic.gamePage.view:updateLotteryDraw(self.logic.LotteryDraw.curGames,self.logic.LotteryDraw.reqGames)
--               end
--             else
--                 self.logic.gamePage.view:updateLotteryDraw(0,0)
--             end
--           else
--               self.logic.gamePage.view:updateLotteryDraw("明日再来")
--           end
--       end
-- end
  function LotteryDrawCtrller:sendAwardReq()
    print("pt_cb_get_luck_draw_req")
    local socketMsg = {opcode = 'pt_cb_get_luck_draw_req'};
    self.logic:sendGameSocket(socketMsg);
  end
function LotteryDrawCtrller:pt_cb_get_luck_data_list_req()
    print("pt_cb_get_luck_data_list_req")
    local socketMsg = {opcode = 'pt_cb_get_luck_data_list_req'};
    self.logic:sendGameSocket(socketMsg);
end
  function LotteryDrawCtrller:pt_bc_get_luck_draw_ack(event)
    print("=======================pt_bc_get_luck_draw_ack===================")
    if nil == event or nil == event.message then
      return;
    end
    local message = event.message;
    var_dump(message,4);
    
    if message.ret_ == -2 then
      self.view:onPressBack();
      gBaseLogic.sceneManager.currentPage.view:ShowGameTip("未达到要求的游戏局数!");
      self.logic:SendTaskNumReq(0, 1, 0);
      return;
    end
    if message.ret_ == -1 then
      izxMessageBox("no items", "提示")
    end
    --self.logic.LotteryDraw.needHistory = true;
    self.logic.LotteryDraw.curTimes = self.logic.LotteryDraw.curTimes + 1; 
    self.logic.LotteryDraw.curGames = 0 
    self.view:getAwardResult(event.message.items_);
    self.logic.luck_data_list=nil
    self.logic:SendTaskNumReq(0, 1, 0);
    if self.logic.gamePage ~= nil then
      self.logic.gamePage.view:stopRunAcion()
    end
  end
  
  function LotteryDrawCtrller:sendHistroyReq()
    local socketMsg = {opcode = 'pt_cb_get_luck_draw_record_req'};
    self.logic:sendGameSocket(socketMsg);
  end
  
  function LotteryDrawCtrller:pt_bc_get_luck_draw_record_ack(event)
    print("============================pt_bc_get_luck_draw_record_ack============================");
    if nil == event or nil == event.message then
      return;
    end
    
    local message = event.message;
    var_dump(message);
    
    if message.ret_ == 0 then
      self.logic.LotteryDraw.needHistory = false;
      self.logic.LotteryDraw.history.item = message.index_;
      self.logic.LotteryDraw.history.num = message.num_;
      self.view:showHistory();
    end 
    
  end
function LotteryDrawCtrller:pt_bc_get_luck_data_list_ack(event)
	print("LotteryDrawCtrller:pt_bc_get_luck_data_list_ack")
	local message=event.message
	var_dump(message.items_,4)
	self.logic.luck_data_list = message.items_
	if message.items_~=nil then
		if #message.items_==4 then
			for i=1,#message.items_ do
				self.view:showAward(i,message.items_[i]);
			end
		end
	end
end
function LotteryDrawCtrller:update_lotteryDraw_round()
	self.view:setDrawStatus();
end

return LotteryDrawCtrller;