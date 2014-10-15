local BaoXiangRenWuLayerCtrller = class("BaoXiangRenWuLayerCtrller",izx.baseCtrller)


function BaoXiangRenWuLayerCtrller:ctor(pageName,moduleName,initParam)
    -- self.data = {}    
    self.getAward = 0;
	self.super.ctor(self,pageName,moduleName,initParam);

end

function BaoXiangRenWuLayerCtrller:onEnter()
    -- body
end
function BaoXiangRenWuLayerCtrller:run()
	self.getAward = 0;
	print("BaoXiangRenWuLayerCtrller:run")
	var_dump(self.logic.baoXiangRenWu)
	print(self.logic.roundTaskFinishNum,self.logic.baoXiangRenWu.onlineitemfinish,self.logic.baoXiangRenWu.roundItemFinish,self.logic.baoXiangRenWu.streaktaskFinish)
	self.logic:onSocketGetOnlieAward();
	self.logic:addLogicEvent("MSG_SOCK_pt_bc_get_online_award_ack",handler(self, self.pt_bc_get_online_award_ack_rec),self)
	self.logic:addLogicEvent("MSG_SOCK_pt_bc_get_task_award_ack",handler(self, self.pt_bc_get_task_award_ack),self)

	self.logic:addLogicEvent("MSG_SOCK_pt_bc_get_daily_task_award_ack",handler(self, self.pt_bc_get_daily_task_award_ack),self)
	self.logic:addLogicEvent("MSG_SOCK_pt_bc_get_streak_task_ack",handler(self, self.pt_bc_get_streak_task_ack),self)
	gBaseLogic.lobbyLogic:addLogicEvent("msgEnterForeground",handler(self, self.msgEnterForeground),self)
	BaoXiangRenWuLayerCtrller.super.run(self);
	
end
function BaoXiangRenWuLayerCtrller:pt_bc_get_streak_task_ack(event)
	print("pt_bc_get_streak_task_ack")
	var_dump(event)
	self.view:initstreaktaskInfo()
end
function BaoXiangRenWuLayerCtrller:pt_bc_get_daily_task_award_ack(event)
	local award = event.message;
	print("BaoXiangRenWuLayerCtrller:pt_bc_get_daily_task_award_ack==")
	var_dump(event)
	self.view.btnAward3:setEnabled(true);
	if (award~=nil)then
		if(award.ret_ == 0) then
			self.view.labelTitle:setString("成功领取，继续下一个任务");
			self.logic:pt_cb_get_streak_task_req()
			
			
		elseif(award.ret_ == -1) then
			izxMessageBox("领取出错啦","提示");
		elseif(award.ret_ == -2) then
			izxMessageBox("任务未完成","提示");
		elseif(award.ret_ == -3) then
			izxMessageBox("奖励已领取","提示");
		else
			izxMessageBox("领取出错啦","提示");
		end
	else
		izxMessageBox("服务器异常\n请稍候再试","提示");
	end
end
function BaoXiangRenWuLayerCtrller:msgEnterForeground(event)
	if self.view.remain_time ~= 0 then
		if self.view.remain_time>0 then
			self.view.remain_time = self.view.remain_time-event.message.restime
			if self.view.remain_time<0 then
				self.view.remain_time = 0;
			end
		end
	end
end
function BaoXiangRenWuLayerCtrller:pt_bc_get_online_award_ack_rec(event)
	local message = event.message;
	print("pt_bc_get_online_award_ack_rec")
	if self.getAward==1 then
		if message.ret_==0 then
			local thiskey = 0
			for k,v in pairs(self.logic.baoXiangRenWu.onlineItems) do
				if message.money_ == v.money_award_ then
					thiskey = k+1
				end
			end
			local info = self.logic.baoXiangRenWu.onlineItems[thiskey]
			if info~=nil then
				self.logic.baoXiangRenWu.onlineInfo = {remain_=info.award_time_*60,money_=info.money_award_}
				self.view:initBaseInfo();
				self.view.labelTitle:setString("成功领取，继续下一个任务");
			else
				self.logic.baoXiangRenWu.onlineInfo = nil
				self.view:initBaseInfo();
			end
		else			
			self.view:onPressClose();
			izxMessageBox("请重试", "领取失败")
		end
	else
		self.view:initBaseInfo();
	end
	self.getAward = 0;
	-- if message.ret_==0 then
	-- 	self.view:ShowGameTip("成功领取奖励"..message.money_ .. "金币，已经进行游戏"..math.floor(message.remain_/60).."分钟")
	-- elseif message.ret_==1 then
	-- 	self.view:ShowGameTip("还剩".. math.floor(message.remain_/60) .."分钟可领取奖励"..message.money_ .. "金币")
	-- elseif message.ret_==2 then
	-- 	self.view:ShowGameTip("任务结束")
	-- elseif message.ret_==4 then
	-- 	if message.remain_==0 and message.money_==0 then
	-- 		self.view:ShowGameTip("任务结束")
	-- 	else
	-- 		self.view:ShowGameTip("还剩".. message.remain_.."秒可领取奖励"..message.money_ .. "金币")
	-- 	end
	-- end
end

--         char	ret_;				//0成功领取奖励  1时间未到 2任务结束 4查询结果
	-- int		remain_;			//剩余时间(ret=0已经进行的时间)
	-- int		money_;				//可以获得的奖励 
function BaoXiangRenWuLayerCtrller:pt_bc_get_task_award_ack(event)
	local message = event.message;
	print("BaoXiangRenWuLayerCtrller:pt_bc_get_task_award_ack")
	-- char	ret_;							// 0成功领取 1查询结果
	-- int		task_type_;						// 任务类型 [0]累计局数 [1]胜利局数
	-- int		last_task_index_;				// 最后领取任务的Index 0未领取
	-- int		cur_val_;						// 当前局数	或 当前赢的局数
	if message.ret_==0 then
		local thiskey = 0
		-- self.baoXiangRenWu.roundInfo = {task_type_=message.task_type_,last_task_index_=message.last_task_index_,cur_val_=message.cur_val_}
		for k,v in pairs(self.logic.baoXiangRenWu.roundItems) do
			if v.task_index_ == self.logic.baoXiangRenWu.roundInfo.last_task_index_ then
				thiskey = k+1
				break;
			end
		end
		local info = self.logic.baoXiangRenWu.roundItems[thiskey]
	-- 	int				task_type_;			// 任务类型 1累加 2胜利
	-- int				task_index_;		// 任务索引 
	-- int				award_round_;		// 奖励局数
	-- string			award_name_;		// 奖励名称
	-- vector<ItemAwardData>	items_;		// 道具信息
		print(thiskey)
		if info ~=nil then
			self.logic.baoXiangRenWu.roundInfo = {task_type_=info.task_type_,last_task_index_=info.task_index_,cur_val_=message.cur_val_}
			if info.award_round_<=message.cur_val_ then
				self.logic.roundTaskFinishNum = self.logic.roundTaskFinishNum+1;
				self.logic:dispatchLogicEvent({
				        name = "RefreshTaskNum",
				        message = {} 
				    })
			end
			self.view.labelTitle:setString("成功领取，继续下一个任务");
		else
			self.logic.baoXiangRenWu.roundInfo = nil;
			
		end
		self.view:initBaseInfo();
		self.logic:pt_cb_get_task_award_req(0,1,0);
	else
		if self.getAward==1 then
			self.view:onPressClose();
			izxMessageBox("请重试", "领取失败")
		end
	end
	self.getAward = 0;
	-- if()
end

return BaoXiangRenWuLayerCtrller;