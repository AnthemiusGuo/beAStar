local TaskSceneCtrller = class("TaskSceneCtrller",izx.baseCtrller)

function TaskSceneCtrller:ctor(pageName,moduleName,initParam)
    self.data = {
	    dayTaskList = {};
	    dayTaskidx = nil;
	    newTaskList = {};
	    newTaskidx = nil;
	    achieveList = {};
	    achieveidx = nil;
	    userData = nil;
    };

	self.super.ctor(self,pageName,moduleName,initParam);
end

function TaskSceneCtrller:onEnter()
    -- body
end
function TaskSceneCtrller:run()

	self.data.userData = self.logic.userData
	print("TaskSceneCtrller:run")
 
	self.logic:addLogicEvent("MSG_SOCK_pt_lc_get_daily_task_list_ack",handler(self, self.onGetDayTaskData),self)
	self.logic:addLogicEvent("MSG_SOCK_pt_lc_get_daily_task_award_ack",handler(self, self.onGetDayTaskAward),self)
	self.logic:addLogicEvent("MSG_SOCK_pt_lc_get_achieve_list_ack",handler(self, self.onGetAchieveData),self)
	self.logic:addLogicEvent("MSG_SOCK_pt_lc_get_achieve_award_ack",handler(self, self.onGetAchieveAward),self)
	TaskSceneCtrller.super.run(self);
	self:getData(0)
 
end

function TaskSceneCtrller:getData(type)
	--dayTask
	if(type == 0) then
		self.logic:reqTaskListReq();
 
	--newTask
	elseif (type == 1) then

		local url = string.gsub(URL.NEWTASK,"{pid}",self.data.userData.ply_guid_);
		url = string.gsub(url,"{ticket}",self.data.userData.ply_ticket_);
		print("Check the url :"..url);
		gBaseLogic:HTTPGetdata(url, 0, function(event)
        	self:onGetNewTaskData(event)
        end)
		
	--achieve
 
	elseif(type == 2) then
		print("===============Chengjiu Request")
		self.logic:reqAchieveListReq();
	end
	
end
------------------------------------------------------------
-- NET_PACKET(AchieveData)
-- {
-- 	int		index_;
-- 	int		value_;
-- 	int		max_;
-- 	int		status_;		//0还没有领取奖励 1已经领取奖励
-- 	int		money_award_;	//游戏币奖励
-- 	int		gift_award_;	//礼券奖励
-- 	int		prop_1_award_;	//道具一: 记牌器
-- 	int		prop_2_award_;	//道具二: 小喇叭
-- 	int		prop_3_award_;	//道具三: 参赛券
-- 	int		prop_4_award_;	//道具四：预留
-- 	int		prop_5_award_;	//道具五：预留
-- 	string	name_;
-- 	string	desc_;
function TaskSceneCtrller:onGetDayTaskData(event)
	print("=====================TaskSceneCtrller:onGetDayTaskData")
	gBaseLogic:unblockUI()

	self.data.dayTaskList = event.message.items_;
	--var_dump(self.data.dayTaskList,3)
	--self.view.tabViewLayer:init(0,self.data.dayTaskList)
	self.view:initTableView(self.view.tabViewLayer,0,self.data.dayTaskList)
	-- var_dump(event.message)
	-- self.view:initBaseInfo();
end

function TaskSceneCtrller:getDayTaskAward(idx)

	self.data.dayTaskidx = idx;
	local taskInfo = self.data.dayTaskList[self.data.dayTaskidx]
	print("TaskSceneCtrller:getDayTaskAward")
	self.logic:reqTaskAwardReq(taskInfo.index_);

end

function TaskSceneCtrller:onGetDayTaskAward(event)

	gBaseLogic:unblockUI()
	local award = event.message;
	print("onGetDayTaskAward==")
	var_dump(event)
	if (award~=nil)then
		if(award.ret_ == 0) then
			local data = "";
			--1.MessageBox
			--游戏币
			if(award.money_ > 0) then
				data = "游戏币:"..award.money_.."\n";
				self.logic.userData.ply_lobby_data_.money_ = self.logic.userData.ply_lobby_data_.money_+award.money_;
			end
			--礼物
			if(award.gift_ > 0) then
				data = data.."元宝:"..award.gift_.."\n";
				self.logic.userData.ply_lobby_data_.gift_ = self.logic.userData.ply_lobby_data_.gift_+award.gift_;
			end
			--道具1:记牌器;道具2:小喇叭;道具3:参赛券;道具4:预留;道具5:预留
			if(award.prop_1_~=nil and award.prop_1_ > 0) then
				data = data.."记牌器:"..award.prop_1_.."\n";
			end
			if (award.prop_2_~=nil and award.prop_2_ > 0) then
				data = data.."小喇叭:"..award.prop_2_.."\n";
			end
			if(award.prop_3_~=nil and award.prop_3_ > 0) then
				data = data.."参赛券:"..award.prop_3_.."\n";
			end

			for k,v in pairs(self.logic.userData.ply_items_) do
				if v.index_==1 and award.prop_2_ > 0 then
					self.logic.userData.ply_items_[k].num_ = self.logic.userData.ply_items_[k].num_+award.prop_2_
				elseif v.index_==2 and award.prop_1_ > 0 then
					self.logic.userData.ply_items_[k].num_ = self.logic.userData.ply_items_[k].num_+award.prop_1_
				elseif v.index_==3 and award.prop_3_ > 0 then
					self.logic.userData.ply_items_[k].num_ = self.logic.userData.ply_items_[k].num_+award.prop_3_
				elseif v.index_==80 and award.gift_ > 0 then
					self.logic.userData.ply_items_[k].num_ = self.logic.userData.ply_items_[k].num_+award.gift_
				elseif v.index_==0 and award.money_ > 0 then
					self.logic.userData.ply_items_[k].num_ = self.logic.userData.ply_items_[k].num_+award.money_
				end
			end
			data = "恭喜您获得如下礼品:\n"..data;
			izxMessageBox(data,"提示");
			--2.fix the daylist data
			self.data.dayTaskList[self.data.dayTaskidx].status_ = 1;
			--self.view.tabViewLayer:init(0,self.data.dayTaskList) 
			self.view:initTableView(self.view.tabViewLayer,0,self.data.dayTaskList)
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
	print "TaskSceneCtrller:onGetDayTaskAward"

end

------------------------------------------------------------
---------NewTask
function TaskSceneCtrller:onGetNewTaskData(event)
	print("=====================TaskSceneCtrller:onGetNewTaskData")
	print(event);
	gBaseLogic:unblockUI()
	--var_dump(event.list)
	self.data.newTaskList = event.list;
	--self.view.tabViewLayer:init(1,self.data.newTaskList)
	self.view:initTableView(self.view.tabViewLayer,1,self.data.newTaskList)
end
--http://m.payment.hiigame.com:18000/task/draw/award?pid=1101133836943856&ticket=f3321bef984009b3b7d79f0642179e8b&taskid=0 
function TaskSceneCtrller:getNewTaskAward(idx)

		print "TaskSceneCtrller:getNewTaskAward"
		self.data.newTaskidx = idx;
		local url = string.gsub(URL.NEWTASKAWARD,"{pid}",self.data.userData.ply_guid_);
		url = string.gsub(url,"{ticket}",self.data.userData.ply_ticket_);
		url = string.gsub(url,"{taskid}",self.data.newTaskList[self.data.newTaskidx].taskid)--self.data.newTaskidx);
		print("Check the url :"..url);
		gBaseLogic:HTTPGetdata(url, 0, function(event)
        	self:onGetNewTaskAward(event)
        end)

end
--{"ret":-2,"mt":0,"num":0,"msg":"未完成该任务"}
--{"ret":-1,"mt":0,"num":0,"msg":""}
function TaskSceneCtrller:onGetNewTaskAward(event)

	gBaseLogic:unblockUI()
	local award = event;
	if (award~=nil)then
		if(award.ret == 0) then
			local data = "";
			--1.MessageBox
			--奖励数量
			if(award.num ~= 0) then
				local index_ = -1;
				if(award.mt == 0) then
					data = "游戏币:"..award.num.."\n";
					index_ = 0
					self.logic.userData.ply_lobby_data_.money_ = self.logic.userData.ply_lobby_data_.money_+award.num;
				elseif(award.mt == 1) then
					data = "元宝:"..award.num.."\n";
					index_ = 80
					self.logic.userData.ply_lobby_data_.gift_ = self.logic.userData.ply_lobby_data_.gift_+award.num;
				elseif(award.mt == 2) then
					data = "小喇叭:"..award.num.."\n";
					index_ = 1
				elseif(award.mt == 3) then
					data = "记牌器:"..award.num.."\n";
					index_ = 2
				elseif(award.mt == 4) then
					data = "参赛券:"..award.num.."\n";
					index_ = 3
				elseif(award.mt == 5) then
					data = "踢人卡:"..award.num.."\n";
				end
				-- 1,1,小喇叭,http://img.cache.bdo.banding.com.cn/shop/prop_trumpet_logo.png
-- 2,2,记牌器,http://img.cache.bdo.banding.com.cn/shop/jipaiqi.png
-- 3,3,参赛券,http://img.cache.bdo.banding.com.cn/shop/bisaiquan.png
 
-- 5,5,招财猫表情包,http://img.cache.bdo.banding.com.cn/shop/zhaocaimao.png
-- 9,50,拉霸币,http://img.cache.bdo.banding.com.cn/shop/lababi.png
-- 13,80,元宝,http://img.cache.bdo.banding.com.cn/shop/yuanbao.png
				if index_~=-1 then
					for k,v in pairs(self.logic.userData.ply_items_) do
						if v.index_==index_ and award.num > 0 then
							self.logic.userData.ply_items_[k].num_ = self.logic.userData.ply_items_[k].num_+award.num
							break;			
						end
					end
				end
				data = "恭喜您获得如下礼品:\n"..data;
				izxMessageBox(data,"提示");
			end
			--2.fix the newTaskList data
			self.data.newTaskList[self.data.newTaskidx].taskstatus = 0;
			--self.view.tabViewLayer:init(1,self.data.newTaskList)
			self.view:initTableView(self.view.tabViewLayer,1,self.data.newTaskList)

		elseif(award.ret == -1) then
			izxMessageBox("领取出错啦","提示");
		elseif(award.ret == -2) then
			izxMessageBox("任务未完成","提示");
		elseif(award.ret == -3) then
			izxMessageBox("奖励已领取","提示");
		else
			izxMessageBox("领取出错啦","提示");
		end
	else
		izxMessageBox("服务器异常\n请稍候再试","提示");
	end
	print "TaskSceneCtrller:onGetNewTaskAward"
end

------------------------------------------------------------
-- pt_lc_get_achieve_award_ack 
--     message:   {opcode:"pt_lc_get_achieve_award_ack",res_:'0', money_:300,
			-- gift_:12,prop_1_:3,prop_2_:5,prop_3_:6,prop_4_:7,prop_5_:7}
function TaskSceneCtrller:onGetAchieveData(event)

	gBaseLogic:unblockUI()
	print("=====================TaskSceneCtrller:onGetAchieveData")
	self.data.achieveList = event.message.items_;
	var_dump(self.data.achieveList)
	--self.view.tabViewLayer:init(2,self.data.achieveList)
	self.view:initTableView(self.view.tabViewLayer,2,self.data.achieveList)
	-- var_dump(event.message)
	-- self.view:initBaseInfo();
end

function TaskSceneCtrller:getAchieveAward(idx)

	self.data.achieveidx = idx;
	local achieveListInfo = self.data.achieveList[self.data.achieveidx]
	print("TaskSceneCtrller:getAchieveAward")
	self.logic:reqAchieveAwardReq(achieveListInfo.index_);

end

function TaskSceneCtrller:onGetAchieveAward(event)

	gBaseLogic:unblockUI()
	local award = event.message;
	print("onGetAchieveAward==")
	var_dump(event)
	if (award~=nil)then

		if(award.ret_ == 0) then
			local data = nil;
			--1.MessageBox
			--游戏币
			
			if(award.money_ > 0) then
				data = "游戏币:"..award.money_.."\n";
				self.logic.userData.ply_lobby_data_.money_ = self.logic.userData.ply_lobby_data_.money_+award.money_;
			end
			--礼物
			if(award.gift_ > 0) then
				data = data.."元宝:"..award.gift_.."\n";
				self.logic.userData.ply_lobby_data_.gift_ = self.logic.userData.ply_lobby_data_.gift_+award.gift_;
			end
			-- if(award.prop_1_ > 0) then
			-- 	data = data.."记牌器:"..award.gift_.."\n";
			-- end
			-- if(award.prop_2_ > 0) then
			-- 	data = data.."小喇叭:"..award.gift_.."\n";
			-- end
			-- if(award.prop_3_ > 0) then
			-- 	data = data.."参赛券:"..award.gift_.."\n";
			-- end

			data = "恭喜您获得如下礼品:\n"..data;
			izxMessageBox(data,"提示");
			--2.fix the achievelist data
			self.data.achieveList[self.data.achieveidx].status_ = 1;
			--self.view.tabViewLayer:init(2,self.data.achieveList)
			self.view:initTableView(self.view.tabViewLayer,2,self.data.achieveList)
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
	--print "TaskSceneCtrller:onGetAchieveAward"
end

return TaskSceneCtrller;