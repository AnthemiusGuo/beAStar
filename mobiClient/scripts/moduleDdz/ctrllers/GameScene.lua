local GameSceneCtrller = class("GameSceneCtrller",izx.baseCtrller)

function GameSceneCtrller:ctor(pageName,moduleName,initParam)
	require("moduleDdz.logics.chatTable")
	print("GameSceneCtrller:ctor")
	self.clientTimerPos = -1;--游戏开始后计时器（闹钟）位置
	self.vernier_index = 1;--提示
	self.is_auto_ = false;
	self.useNoteCards = 0;--是否打开过记牌器面板
	self.noteCardsNum = 0; --记牌器数量
	self.nDouble = 1;
	self.is_robot = 0;
	self.is_laizi = 0
	self.robotMonery = 0
	self.giftStat = 0; --宝箱任务状态
    self.data = {
    	task_item_ = {},--任务
    	is_game_start_ = false,
	    --table_attrs_ = {},
	    other_ply_attrs_ = {},
	    self_ply_attrs_ = {},--self.logic.userData.ply_base_data_,
        players_ = {},
        nBaoValue = 0,
       --cChairID = 1,
        nowCardTyp = {m_nTypeBomb=0,m_nTypeNum=0,m_nTypeValue=0},--上个出牌人的出牌类型
		nowcChairID = 0,--上个出牌人的位置
	    nSerialID  = 1,--消息序列
		nGameMoney = 0,--底注
		nCardNum = 54,--牌的数量
		cLordCard = {},--地主牌
		cLord = -1,--地主位置
		cLaiziCard = {}, -- 癞子牌
		--phrasetable = {"大家好，很高兴见到各位~"},

		PLAYER_ME = 0,
		PLAYER_RIGHT = 1,
		PLAYER_LEFT = 2,		
		MAX_PLY_NUM = 3,

		SCORE_ZERO = 0,
		SCORE_ONE = 1,
		SCORE_TWO = 2,					
		SCORE_THREE = 3,	

		-- SCORE_CALL_NO_LORD = 0,
		-- SCORE_CALL_LORD = 1,	

	    NO_ROB_LORD = 0,	--不抢地主
		ROB_LORD = 1,		--抢地主		
	   
	    NO_SHOW_CARD = 0,	--不亮
		SHOW_CARD = 1,		--亮牌
		
		MAX_TIP_NUM = 4,
		MAX_SIGN_NUM = 4,	--电池信号显示
		USERNAME_LENGTH=6,	--昵称显示长度
		ANI_NUM=12,
		TIP_ZORDER = 1000,

	    QUIT_IN_GAME = 0,	            --游戏中不能退出
		ONLINE_AWARD_FAILURE = 1,		--在线时长奖励未到时间
		ONLINE_AWARD_SUCCESS = 2,		--在线时长奖励领取成功
		JOIN_TABLE_WAITING = 3,			--正在占座，请稍等3秒
		JOIN_TABLE_FAILURE = 4,			--抱歉，座位已被抢占，等待下局吧
		QUIT_NO_MONEY = 5,
		NO_TRUMPET_TIPS = 6,			--没有小喇叭
		NO_COUNTS_TIPS = 7,				--没有记牌器
		ADD_MONEY_MSG = 8,				--赠送游戏币消息
		NO_EXPRESSION_TIPS = 9,
		OperateFriendDoing = 10,		--操作请求已发出....
		OperateFriendAck = 11,

		kTipDDChargeEvent = 12,			--短贷充值提示;

		kTrumpetMaxCharWidth = 7,
		index = 58,
		ply_guid_ = "",	
		nickname_ = "",
    }
	self.super.ctor(self,pageName,moduleName,initParam);
	
end

function GameSceneCtrller:onEnter()
    -- body

end

function GameSceneCtrller:run()
	print("GameSceneCtrller:run",self.is_robot)
	gBaseLogic.lobbyLogic:addLogicEvent("MSG_userName_rst_send",handler(self, self.onUserNameUpdate),self)
	gBaseLogic.lobbyLogic:addLogicEvent("MSG_change_chongzhi_btn",handler(self, self.changChongzhiBtn),self)
	gBaseLogic.lobbyLogic:addLogicEvent("MSG_Socket_pt_lc_send_user_data_change_not",handler(self, self.onUserDataChangeNot),self)

	if (gBaseLogic.is_robot~=0) then
		GameSceneCtrller.super.run(self);
		self.logic:showWanFa() 
		self.logic:addLogicEvent("MSG_robotMonery_rst_send",handler(self, self.onRobotMonery),self) 
		gBaseLogic.lobbyLogic:addLogicEvent("MSG_SOCK_pt_lc_get_user_good_card_ack",handler(self, self.pt_lc_get_user_good_card_ack),self)
		return;
	end
	
	-- self:startGamesocket()
	
	-- print("=============ply_base_data_2");
	-- var_dump(self.logic.userData.ply_base_data_);
-- login
    -- self.logic:addLogicEvent(self.logic.MSG_Socket_LeaveTable,handler(self, self.pt_bc_leave_table_ack_rec),self)
    self.data.self_ply_attrs_ = self.logic.userData.ply_base_data_;
    
    
    -- self.logic:pt_cb_get_task_system_req()
    self.logic:addLogicEvent("MSG_SOCK_pt_bc_login_ack",handler(self, self.pt_bc_login_ack),self)
-- 进入房间

    self.logic:addLogicEvent(self.logic.MSG_Socket_JoinTable,handler(self, self.onMsgData),self)
 --准备结果通知
	self.logic:addLogicEvent(self.logic.MSG_Socket_TableReady,handler(self, self.pt_bc_ready_not_rec),self);
-- 其他人进入游戏消息
    self.logic:addLogicEvent(self.logic.MSG_Socket_OtherJoinTable,handler(self, self.onMsgOtherJoinTable),self)
    
--游戏开始
    self.logic:addLogicEvent(self.logic.MSG_Socket_GameStart,handler(self, self.onMsgGameStart),self)
--发牌
    self.logic:addLogicEvent(self.logic.MSG_Socket_RefreshCard,handler(self, self.onMsgRefreshCard),self)
--叫分
    self.logic:addLogicEvent(self.logic.MSG_Socket_CallScore,handler(self, self.onMsgCallScore),self)
    
--抢地主
	self.logic:addLogicEvent(self.logic.MSG_Socket_robLord,handler(self, self.onMsgRobLord),self);
--底注倍数 onMsgBombNot
	self.logic:addLogicEvent(self.logic.MSG_Socket_BombNot,handler(self, self.onMsgBombNot),self);
--show地主 地主牌	
	self.logic:addLogicEvent(self.logic.MSG_Socket_LordCard,handler(self, self.onMsgLordCard),self);

	
--通知玩家出牌
	self.logic:addLogicEvent(self.logic.MSG_Socket_PlayCard,handler(self, self.onMsgPlayCard),self);
--玩家出牌信息广播onMsgPlayCardNot
	self.logic:addLogicEvent(self.logic.MSG_Socket_PlayCardNot,handler(self, self.onMsgPlayCardNot),self);
--通用提醒 onMsgCommonNot
	self.logic:addLogicEvent(self.logic.MSG_Socket_CommonNot,handler(self, self.onMsgCommonNot),self);
--定时器
    self.logic:addLogicEvent(self.logic.MSG_Socket_ClienttimerNot,handler(self, self.onMsgClienttimerNot),self); 

--托管提醒
	self.logic:addLogicEvent("MSG_SOCK_pt_gc_auto_not",handler(self, self.pt_gc_auto_not_rec),self);

--比赛结果通知
	self.logic:addLogicEvent("MSG_SOCK_pt_gc_game_result_not1",handler(self, self.onMsgGameResult),self);
	-- self.logic:addLogicEvent("MSG_SOCK_pt_gc_game_result_not1",handler(self, self.onMsgGameResult),self);

--离开房间
	self.logic:addLogicEvent(self.logic.MSG_Socket_LeaveTable,handler(self, self.pt_bc_leave_table_ack_rec),self);
--qitaren离开房间
	
	self.logic:addLogicEvent("MSG_SOCK_pt_bc_ply_leave_not",handler(self, self.pt_bc_ply_leave_not_rec),self);

--异常退出后回到游戏 pt_gc_complete_data_not
	self.logic:addLogicEvent("MSG_SOCK_pt_gc_complete_data_not",handler(self, self.pt_gc_complete_data_not_rec),self);

	--laizi -- gc_laizi_not
	self.logic:addLogicEvent("MSG_SOCK_pt_gc_laizi_not",handler(self, self.onLaiziNot),self)

-- gc_task_not
	self.logic:addLogicEvent("MSG_SOCK_pt_gc_task_not",handler(self, self.pt_gc_task_not_rec),self)
-- pt_gc_task_complete_not
	self.logic:addLogicEvent("MSG_SOCK_pt_gc_task_complete_not",handler(self, self.pt_gc_task_complete_not_rec),self)
-- 广播	

	gBaseLogic.lobbyLogic:addLogicEvent("MSG_SOCK_pt_lc_trumpet_not",handler(self, self.pt_lc_trumpet_not_rec),self)

-- pt_cg_card_count_req
	self.logic:addLogicEvent("MSG_SOCK_pt_gc_card_count_ack",handler(self, self.pt_gc_card_count_ack_rec),self)
	self.logic:addLogicEvent("MSG_SOCK_pt_gc_card_count_ack1",handler(self, self.pt_gc_card_count_ack1_rec),self)
	
	self.logic:addLogicEvent("MSG_SOCK_pt_bc_chat_not",handler(self, self.onChatNot),self)
	self.logic:addLogicEvent("MSG_SOCK_pt_bc_send_prop_not",handler(self, self.onChatPayNot),self)
	--self.logic:addLogicEvent("MSG_SOCK_pt_lc_trumpet_not",handler(self, self.onTrumpetNot),self)

	-- self.logic:addLogicEvent("MSG_SOCK_pt_bc_get_online_award_ack",handler(self, self.pt_bc_get_online_award_ack_rec),self)
	-- self.logic:addLogicEvent("MSG_SOCK_pt_bc_get_task_award_ack",handler(self, self.pt_bc_get_task_award_ack),self)

	self.logic:addLogicEvent("MSG_SOCK_pt_bc_update_ply_data_not",handler(self, self.pt_bc_update_ply_data_not_rec),self)

	self.logic:addLogicEvent("MSG_SOCK_pt_gc_counts_not1",handler(self, self.pt_gc_counts_not1),self)
	self.logic:addLogicEvent("MSG_SOCK_pt_gc_counts_not",handler(self, self.pt_gc_counts_not),self)


	-- self.logic:addLogicEvent("MSG_SOCK_pt_bc_below_admission_limit_tip_not",handler(self, self.pt_bc_below_admission_limit_tip_not),self)

	gBaseLogic.lobbyLogic:addLogicEvent("MSG_dibao_send",handler(self, self.dibaoMsgTip),self)
	--局数任务刷新
	self.logic:addLogicEvent("RefreshTaskNum",handler(self, self.RefreshTaskNum),self)
	--解开锁屏事件
	gBaseLogic.lobbyLogic:addLogicEvent("msgEnterForeground",handler(self, self.msgEnterForeground),self)
	--切换充值奖励图标
	gBaseLogic.lobbyLogic:addLogicEvent("MSG_Socket_ChongZhiJiangLi",handler(self, self.changChongzhijiangli),self)
	
	self.logic:addLogicEvent("MSG_SOCK_pt_bc_item_update_not",handler(self, self.pt_bc_item_update_not),self)
	--chengjiu finish
	self.logic:addLogicEvent("MSG_SOCK_pt_bc_get_achieve_award_not",handler(self, self.pt_bc_get_achieve_award_not),self)
	
	self.logic:addLogicEvent("MSG_SOCK_pt_bc_get_daily_task_award_not",handler(self, self.pt_bc_get_daily_task_award_not),self)
	self.logic:addLogicEvent("MSG_SOCK_pt_bc_successive_victory_not",handler(self, self.pt_bc_successive_victory_not),self)
	

	-- self.logic:addLogicEvent("MSG_SOCK_pt_bc_get_daily_task_award_ack",handler(self, self.pt_bc_get_daily_task_award_ack),self)
	self.logic:addLogicEvent("MSG_SOCK_pt_bc_ready_ack",handler(self, self.pt_bc_ready_ack),self)

	-- if self.logic.tablePlayerAttr~=nil then
	-- 	self.logic:dispatchLogicEvent({
	-- 	        name = self.logic.MSG_Socket_JoinTable,
	-- 	        message = self.logic.tablePlayerAttr       

	-- 	    })
	-- 	self.logic.tablePlayerAttr = nil;		
	-- end
	-- if self.logic.pt_gc_complete_data_message ~=nil then
	-- 	print("self.logic.pt_gc_complete_data_message123")
	-- 	self.logic:dispatchLogicEvent({
	-- 	        name = "MSG_SOCK_pt_gc_complete_data_not",
	-- 	        message = self.logic.pt_gc_complete_data_message       

	-- 	    })
	-- 	self.logic.pt_gc_complete_data_message = nil;
	-- end
 
	self.logic:addLogicEvent("MSG_SOCK_pt_bc_rematch_notf",handler(self, self.pt_bc_rematch_notf),self)
	

    GameSceneCtrller.super.run(self);
end 



function GameSceneCtrller:pt_bc_ready_ack(event)
	print("pt_bc_ready_ack")
	gBaseLogic.lobbyLogic.isMatchOnGameExit = 0;
	gBaseLogic.lobbyLogic.isMatch = 1;
	self.logic.is_chang_table = 0;
	local message = event.message;
	local ret = message.ret_;
	var_dump(message)
	if ret==-2 then
		local money = self.logic.curSocketConfigList.min_money_;
        local  status = 2   
        self.logic.moneyNotEnough = 1;    
        gBaseLogic:onNeedMoney("gameenter", money, status)
        self.view:showReadyChange()
	end
end
-- function GameSceneCtrller:onMsgGameLogin(event)
-- 	local message = event.message;
-- 	print("=========================onMsgGameLogin")
-- 	 -- var_dump(message)
	
-- end

function GameSceneCtrller:onUserNameUpdate(event)
	--izxMessageBox(event.message.sessionInfo.nickname,event.message.msg)
	print("GameSceneCtrller:onUserNameUpdate")
    --dump(event)
 --    local Player = self:FindPlayerByPID(event.message.sessionInfo.ply_guid_);
	-- if nil ~= Player then
	-- 	Player:RefreshName(event.message.sessionInfo.nickname)
	-- end 
	gBaseLogic.lobbyLogic.haschangename = true -- is it need?
	self.data.players_[1]:RefreshName(event.message.sessionInfo.nickname)
	if nil ~= self.informationLayer then 
		self.informationLayer.view.nickname:setString(izx.UTF8.sub(event.message.sessionInfo.nickname));
	end
end

function GameSceneCtrller:removeAllEvent()
	GameSceneCtrller.super.removeAllEvent(self);
	if self.handlerPool ~=nil then
		for k,v in pairs(self.handlerPool) do
			gBaseLogic.lobbyLogic:removeEventListener(k, v)
			-- removeEventListener(eventName, key)
		end
	end
end

function GameSceneCtrller:pt_bc_login_ack(event)
	print("GameSceneCtrller:pt_bc_login_ack")
	gBaseLogic.lobbyLogic.isOnGameExit=0;
	local message = event.message;
	self.data.self_ply_attrs_ = self.logic.userData.ply_base_data_;
	self:GetMe():setUserData(self.data.self_ply_attrs_);
	-- var_dump(self.data.self_ply_attrs_);
end 

function GameSceneCtrller:reqMatchRankInfoData()
	print("GameSceneCtrller:reqMatchRankInfoData")
	--http://t.statics.hiigame.com/get/round/rank/info?matchid=1&matchorderid=0

    local tableRst = {matchid=self.logic.curMatchID,matchorderid = self.logic.curMatchOrderID};

    HTTPPostRequest(URL.MATCHRANKINFO, tableRst, function(event)
        var_dump(tableRst)
        if (event ~= nil) then
            var_dump(event,5)
   --          local x = {
			-- 	{rank = 1, nikename = "JL", score = 3000, round = 1},
			-- 	{rank = 2, nikename = "JL", score = 3000, round = 2},
			-- }
			local data = {}
			for k,v in pairs(event.roundrank) do
				if v.score>0 then
					table.insert(data,v);
				end
			end
			table.sort(data,function(a,b)
				if a.score>b.score then
					return true;
				else
					return false;
				end
				end)
            self.view:showMatchRank(data);

        end     
        end);
	
end

function GameSceneCtrller:reqRaceRoomInfoData(type)
    print("GameSceneCtrller:reqRaceRoomInfoData")

    local tableRst = {gameid=MAIN_GAME_ID,guid = gBaseLogic.lobbyLogic.userData.ply_guid_};

    HTTPPostRequest(URL.MATCHINFODATA, tableRst, function(event)
        var_dump(tableRst)
        if (event ~= nil) then
            var_dump(event,5)
            gBaseLogic.lobbyLogic.matchInfo = event
            --self.view:initBaseInfo(); 
            if type == 1 then 
            	self.view:onPressMatchReward()
            	self.view:setMatchTitle()
            end 
            if type == 2 then 
            	self.view:setMatchTitle()
            end
        end     
        end);
end 

function GameSceneCtrller:initRobotInfo(laizi)
    print("GameSceneCtrller:initRobotInfo....................") 
    self.is_laizi = laizi
    self.data.ply_guid_ = CCUserDefault:sharedUserDefault():getStringForKey("ply_guid_");	
	self.data.nickname_ = CCUserDefault:sharedUserDefault():getStringForKey("ply_nickname_")
    self:checkRobotMonery()
end

function GameSceneCtrller:initRobotInfo2()   
 	print("GameSceneCtrller:initRobotInfo2....................") 
    
    require("moduleDdz.logics.EnumTable")
    self.action = {
        [EVENT_ID.UPDATE_EVENT_ADD_USER]          = function (x) self:onMsgOtherJoinTable(x) end,
        --[EVENT_ID.UPDATE_EVENT_READY]             = function (x) self:OnMsgPlyReadyNot(x) end,
        [EVENT_ID.UPDATE_EVENT_READY]             = function (x) self:pt_bc_ready_not_rec(x) end,

        --[EVENT_ID.UPDATE_EVENT_REFRESH_CARD]      = function (x) self:OnPlyReadyReq(x) end,
        [EVENT_ID.UPDATE_EVENT_REFRESH_CARD]      = function (x) self:onMsgRefreshCard(x) end,
        [EVENT_ID.UPDATE_EVENT_GAME_START]        = function (x) self:onMsgGameStart(x) end,
        [EVENT_ID.UPDATE_EVENT_CALL_SCORE_REQ]    = function (x) self:onMsgCallScore(x) end,   
        [EVENT_ID.UPDATE_EVENT_PLAY_CARD]         = function (x) self:onMsgPlayCardNot(x) end,
        [EVENT_ID.UPDATE_EVENT_PLAY_CARD_REQ]     = function (x) self:onMsgPlayCard(x) end,
        [EVENT_ID.UPDATE_EVENT_LORD_CARD]         = function (x) self:onMsgLordCard(x) end,
        [EVENT_ID.UPDATE_EVENT_ROB_LORD_REQ]      = function (x) self:onMsgRobLord(x) end,
        [EVENT_ID.UPDATE_EVENT_SHOW_CARD_NOT]     = function (x) self:onMsgShowCardNot(x) end,
        [EVENT_ID.UPDATE_EVENT_RESULT]            = function (x) self:onMsgGameResult(x) end,
        [EVENT_ID.UPDATE_EVENT_BOMB]              = function (x) self:onMsgBombNot(x) end,
        [EVENT_ID.UPDATE_EVENT_UPDATE_MONEY]      = function (x) self:OnUpdateMoney(x) end,
        [EVENT_ID.UPDATE_EVENT_COMMON_OP]         = function (x) self:onMsgCommonNot(x) end,
        [EVENT_ID.UPDATE_EVENT_CHAT_NOT]          = function (x) self:onChatNot(x) end,
        [EVENT_ID.UPDATE_EVENT_CHANGE_TABLE]      = function (x) self:onMsgChangeTableResult(x) end,
        [EVENT_ID.UPDATE_EVENT_LAIZI]             = function (x) self:onLaiziNot(x) end,
    }
    function robotaicallback( dict )
    	--var_dump(dict)
        print("robotaicallback:".. dict["event_id"])
        --cclog("第一个参数：" .. dict["event_id"])
        local eventid = dict["event_id"]
        local event = {["message"] = dict}
        if nil ~= self.action[eventid] then
            self.action[eventid](event)
        else
            print("robotaicallback: no this function")
        end

    end

    self.data.self_ply_attrs_.ply_guid_ = 999
    self.data.self_ply_attrs_.chair_id_ = 0
    self.robotai = RobotAi:create()
    -- var_dump(self.robotai)
    self.robotai:setGameState(EVENT_ID["UPDATE_EVENT_ADD_USER"])
    self.robotai:setIsLaizi(self.is_laizi)
    self.robotai:setGameMoney(30)
    self.robotai:registerCallFuncLua(robotaicallback, 0)
    self.robotai:retain()
    self.view.rootNode:addChild(self.robotai)
end 

function GameSceneCtrller:destoryRobot()
	if self.robotai ~= nil then
		self.robotai:destory()
		self.robotai = nil
	end
	self.is_robot = 0
	self.robotMonery = 0
	self.is_laizi = 0
	gBaseLogic.is_robot = 0
end
function GameSceneCtrller:pt_cl_get_user_good_card_req(num)
    print("pt_cl_get_user_good_card_req")
    gBaseLogic:blockUI();
    local socketMsg = {opcode = 'pt_cl_get_user_good_card_req',
        num_ = num};
    gBaseLogic.lobbyLogic:sendLobbySocket(socketMsg);
    --[[
    --for test
    function testgetSigninAward()
        local info = {
            ret = 0,
            num_ = num - 1,
        }
        self.logic:dispatchLogicEvent({
                    name = "MSG_SOCK_pt_lc_get_user_good_card_ack",
                    message = info
                });
    end 
    scheduler.performWithDelayGlobal(testgetSigninAward, 0.2)
   --]]
end 

function GameSceneCtrller:pt_lc_get_user_good_card_ack(event)
    print("pt_lc_get_user_good_card_ack")
    local message = event.message;
    gBaseLogic:unblockUI();
    var_dump(event)
    if message.ret == 0 then 
    	CCUserDefault:sharedUserDefault():setIntegerForKey("better_seat"..self.data.ply_guid_,message.num_)
		self.robotai:setGameStateAndData(EVENT_ID["pt_cb_ready_req"],1)
		self.view:HidenOpBtn()

		local ply_items = gBaseLogic.lobbyLogic.userData.ply_items_
	    for k,v in pairs(ply_items) do 
	        if v.index_ == self.data.index then 
	            v.num_  =  message.num_ 
	        end
	    end

	elseif message.ret == -1 then 
		CCUserDefault:sharedUserDefault():setIntegerForKey("better_seat"..self.data.ply_guid_,0)
		self.view.labelBeeterSeat:setString(0)
		if (gBaseLogic.MBPluginManager.distributions.skipbuyitem) then
			izxMessageBox("您的好牌卡不足", "提示")
		else
			izxMessageBox("您的好牌卡不足，请购买！", "温馨提示")
		end
	else 
		CCUserDefault:sharedUserDefault():setIntegerForKey("better_seat"..self.data.ply_guid_,0)
		self.view.labelBeeterSeat:setString(0)
		izxMessageBox("您没有好牌卡！", "温馨提示")
    end
end 

function GameSceneCtrller:CheckBetterSeat()
	print("CheckBetterSeat")
	local betterSeat = CCUserDefault:sharedUserDefault():getIntegerForKey("better_seat"..self.data.ply_guid_,0)
	if 0 < betterSeat then 
		if (gBaseLogic.lobbyLogic.userHasLogined == false) then
			CCUserDefault:sharedUserDefault():setIntegerForKey("better_seat"..self.data.ply_guid_,betterSeat - 1)
			self.robotai:setGameStateAndData(EVENT_ID["pt_cb_ready_req"],1)
			self.view:HidenOpBtn()
		else 
			self:pt_cl_get_user_good_card_req(betterSeat)
		end
	else
		--local data = {price = 8, havePhone = 1, serino = "com.izhangxin.ddz.android.box2_2", boxid = 5315, content = {{num = 24, idx = 2, } }, icon = "http://iface.b0.upaiyun.com/a152d14a-67fc-4258-a428-9ece06879081.png!p300", spList = {}, desc = "8万游戏币,送记牌器x24、招财猫表情包", boxname = "初级宝箱", payidList = {}, } 
		if (gBaseLogic.MBPluginManager.distributions.skipbuyitem) then
			izxMessageBox("您的好牌卡不足", "提示")
		else
			if (gBaseLogic.lobbyLogic.userHasLogined == true) and (nil ~= gBaseLogic.lobbyLogic.paymentItemList) then
	   			local payItemList = gBaseLogic.lobbyLogic.paymentItemList
				local ply_items = gBaseLogic.lobbyLogic.userData.ply_items_
				local url = ""
			    for k,v in pairs(ply_items) do 
			        if v.index_ == self.data.index then 
			            url =  v.url_ 
			        end
			    end
				local hasinfo = 0
				for k,v in pairs(payItemList) do 
		        var_dump(v.content)
			        for k1,v1 in pairs(v.content) do 
			            if v1.idx == self.data.index then 
			            	--gBaseLogic.lobbyLogic:onPayTips(3, "SMS", payItemList[k], 0) 
			            	hasinfo = 1
			            	local info = {url = url,count = v1.num, money = payItemList[k].price..".00"}
			            	self.view:showHaoPaiKaPay(info, payItemList[k], display.cx, display.cy)
			                break
			            end
			        end
		    	end 
		    	if hasinfo <= 0 then 
		    		izxMessageBox("暂无该商品！", "提示")
		    	end
		    else
				izxMessageBox("请先登录！", "提示")
			end
		end
	end
	
end

function GameSceneCtrller:onUserDataChangeNot(event) 
	if self.is_robot~=0 then 
		-- local ply_items = gBaseLogic.lobbyLogic.userData.ply_items_
		-- local num = 0
	 --    for k,v in pairs(ply_items) do 
	 --        if v.index_ == self.data.index then 
	 --            num =  v.num_ 
	 --            break
	 --        end
	 --    end 
	    local num = self.userData.items_user[self.data.index].num_
	    if num > 0 then 
	    	CCUserDefault:sharedUserDefault():setIntegerForKey("better_seat"..self.data.ply_guid_,num)
	    	self.view.labelBeeterSeat:setString(num)
	    end
	else
		local Player = self.data.players_[1]
		Player:changeMoney(gBaseLogic.lobbyLogic.userData.ply_lobby_data_.money_,0)

	end
end

function GameSceneCtrller:changChongzhiBtn(event)
    print("changChongzhiBtn")
    var_dump(event)
    if self.view.btnChongZhiJiangLi ~= nil then 
    	self.view.btnChongZhiJiangLi:setEnabled(true) 
    end

    if gBaseLogic.is_robot ~= 0 then 

        if event.message.code ~= 0 then
            gBaseLogic.gameLogic:dispatchLogicEvent({
                    name = "MSG_robotMonery_rst_send",
                    message = "ERROR"
                });
        end
    else
        
        -- if self.logic.dibaomoneyNotEnough==1 then
            
        --     if message.code==0 then
        --         self.logic.dibaomoneyNotEnough = 0
        --     else
        --         self.logic:showdibaomsg();
        --     end
        -- end
            -- local info = "很遗憾你已经破产了，去大厅领取免费金币吧！"
            --  gBaseLogic:confirmBox({
            --     msg=info,
            --     buttonCount=1,
            --     callbackConfirm = function()
            --         self.logic:LeaveGameScene(-1)
                    
            --     end})
             
    end
end

function GameSceneCtrller:checkRobotMonery()
	local robotMonery = CCUserDefault:sharedUserDefault():getIntegerForKey("p_money_4",0)
	print("checkRobotMonery:"..robotMonery)
	--robotMonery = 0 --for test
	if 0 >= robotMonery then 
		local strtime = CCUserDefault:sharedUserDefault():getStringForKey("UserRobotTime")
    	local curtime = os.date("%x", os.time())
	    if curtime ~= strtime then 
	        CCUserDefault:sharedUserDefault():setStringForKey("UserRobotTime",curtime)
	        gBaseLogic.lobbyLogic:showYouXiTanChu({msg="欢迎来到单机对战模式，您的游戏币为0，我们赠送给您1000游戏币！祝您好运！",type=1004}) 
	    else 
	        gBaseLogic.lobbyLogic:showYouXiTanChu({msg="游戏币不足，您的游戏币为0，无法继续游戏，点击确认立即充值",type=2,needMoney=10000}) 

	    end 
	else 
		if not self.robotai then 
			print("================================")
			self:initRobotInfo2()
		else
			--self:reInit()
			-- local ply_guid_ = CCUserDefault:sharedUserDefault():getStringForKey("ply_guid_");
			-- local Player = self:FindPlayerByPID(ply_guid_);
			-- if nil ~= Player then
			-- 	Player:changeMoney(robotMonery)
			-- end
			--self.robotai:setGameStateAndData(EVENT_ID["cb_change_table_req"],0)	
			--self.robotai:setGameStateAndData(EVENT_ID["pt_cb_ready_req"],0)	
			--self.view:showReadyChange()	
		end
	end
end 

function GameSceneCtrller:onRobotMonery(event)
	print("onRobotMonery")
	if event.message == "OK" then 
		local robotMonery = CCUserDefault:sharedUserDefault():getIntegerForKey("p_money_4",0)
		local Player = self:FindPlayerByPID(self.data.ply_guid_);
		if nil ~= Player then
			Player:changeMoney(robotMonery)
		end
		-- gBaseLogic.gameLogic:dispatchLogicEvent({
  --                   name = "MSG_SOCK_pt_bc_update_ply_data_not",
  --                   message = {ply_guid_=self.data.self_ply_attrs_.ply_guid_,
  --               		amount_ = robotMonery}
  --               });

		if not self.robotai then 
			self:initRobotInfo2()
		else
			self.robotai:updatePlayerMsg()
			if self.data.is_game_start_ == false then
				--self:reInit()
				--self.robotai:setGameStateAndData(EVENT_ID["cb_change_table_req"],0)
				--self.view:showReadyChange()
			end
		end
	elseif event.message == "BEETERSEAT" then
		local betterSeat = CCUserDefault:sharedUserDefault():getIntegerForKey("better_seat"..self.data.ply_guid_,0)
		--显示新次数数字
		self.view.labelBeeterSeat:setString(betterSeat)

	elseif event.message == "COLSE" then 
		self.view:onPressExit()
	elseif event.message == "START" then 
		CCUserDefault:sharedUserDefault():setIntegerForKey("p_money_4",1000)
		if not self.robotai then 
			self:initRobotInfo2()
		else
			--self:reInit()
			self.robotai:updatePlayerMsg()
			--self.robotai:setGameStateAndData(EVENT_ID["cb_change_table_req"],0)
			self.view:showReadyChange()
		end
	elseif event.message == "ERROR" then 
		local robotMonery = CCUserDefault:sharedUserDefault():getIntegerForKey("p_money_4",0)
		if robotMonery > 0 then 
		else
			gBaseLogic.lobbyLogic:showYouXiTanChu({msg="游戏币为0，无法继续游戏，明天登录赠送1000游戏币！期待您再次回来！",type=1005})
		end
	end
end

function GameSceneCtrller:onLaiziNot(event)
	print("onLaiziNot")
	self.data.nBaoValue = event.message.card_value
	-- self:GetMe().cards_:SetBaoValue(self.data.nBaoValue)
	self.data.players_[1].cards_:SetBaoValue(self.data.nBaoValue);
	self.data.players_[2].cards_:SetBaoValue(self.data.nBaoValue);
	self.data.players_[3].cards_:SetBaoValue(self.data.nBaoValue);
	-- local disValue = self.data.nBaoValue;
	-- if (disValue==11) then
	-- 	disValue = "J";
	-- elseif disValue==12 then
	-- 	disValue = "Q";
	-- elseif disValue==13 then
	-- 	disValue = "K";
	-- elseif disValue==14 then
	-- 	disValue = "A";
	-- elseif disValue==15 then
	-- 	disValue = "2";
	-- end
	-- self.view.lableLazi:setString("癞子：");
	-- self.view.nLaizi:setString(disValue);
	self.data.cLaiziCard = {m_nValue = self.data.nBaoValue, m_nCard_Baovalue = -1, m_nColor = 0}
	-- print(self.logic.hasBaoValue,self.data.nBaoValue)
	-- message.vecCards = self:GetMe().cards_.m_cCards;

	self:GetMe():RefreshCard(self:GetMe().cards_.m_cCards,true)
	-- if self.logic.hasBaoValue==1 then
	-- 	self.view.nLaizi:setString(self.data.nBaoValue);
	-- end
	self.view:showLaiziCard()
end

--进入房间
function GameSceneCtrller:reInit()
	if self.is_robot ~= 0 then 
	    self.data.self_ply_attrs_.ply_guid_ = 999
        self.data.self_ply_attrs_.chair_id_ = 0 
        --self.view:showReadyChange()
    end
    print("GameSceneCtrller:reInit")
	self.data.is_game_start_ = false
	self.clientTimerPos = -1;
	self.vernier_index = 1;--提示
	self.is_auto_ = false;
	self.useNoteCards = 0;--是否打开过记牌器面板	
	self.nDouble = 1;
	self.logic.isErrorJoin = 0;
	if self.logic.isMatch==0 then
		self.view.nodetask:setVisible(false);
	end
	self.view.nodeNoteCards:setVisible(false)

    --self.data.other_ply_attrs_ = {}
    self.view.gameLayer:removeChildByTag(2);

   	--self.data.players_[1]:ReInit();
   	--self.data.players_[2]:ReInit();
   	--self.data.players_[3]:ReInit();
   	self.data.players_[1]:ReInitCard();
   	self.data.players_[2]:ReInitCard();
   	self.data.players_[3]:ReInitCard();
   	--self:OnRefreshPlayer()

   	self.view.nDouble:setString("1");
    self.view.nDizhu:setString("");		    
    -- if self.logic.hasBaoValue==0 then
    --     self.view.lableLazi:setString("");
    -- end
    -- self.view.nLaizi:setString("");
    self.view.cLordCardNode:setVisible(false)
    self.view.cLordCardNode:removeAllChildrenWithCleanup(true)
    self.view.nodeLaiZi:setVisible(false)
    self.view.nodeLaiZi:setScale(1.0)
    self.view.nodeLaiZi:setPosition(ccp(display.cx,display.cy))
    --self:GetMe().play_card_:removeAllChildrenWithCleanup(true);
    self:GetMe().cards_.m_cCards = {};
    self:GetMe().cards_:SetBaoValue(0);
    self.view.puKeLayer:removeAllChildrenWithCleanup(true);
    self.view:ManagementClick();
    self.data.nowCardTyp = {m_nTypeBomb=0,m_nTypeNum=0,m_nTypeValue=0}--上个出牌人的出牌类型
	self.data.nowcChairID = 0--上个出牌人的位置
	self.view:resetBtnPosition()
	--显示准备按钮
    --self.view:showReadyChange()
	if self.view.butLayerState == 0 then
        self.view:ChangeLayer() 
    end 

end

function GameSceneCtrller:reInitAll()
	print("GameSceneCtrller:reInitAll")
	if self.is_robot ~= 0 then 
	    self.data.self_ply_attrs_.ply_guid_ = 999
        self.data.self_ply_attrs_.chair_id_ = 0 
    end
    
	self.data.is_game_start_ = false
	self.clientTimerPos = -1;
	self.vernier_index = 1;--提示
	self.is_auto_ = false;
	self.useNoteCards = 0;--是否打开过记牌器面板	
	self.nDouble = 1;
	self.logic.isErrorJoin = 0;
	self.view.nodetask:setVisible(false);
	self.view.nodeNoteCards:setVisible(false)

    self.data.other_ply_attrs_ = {}
    self.view.gameLayer:removeChildByTag(2);

   	self.data.players_[1]:ReInit();
   	self.data.players_[2]:ReInit();
   	self.data.players_[3]:ReInit();

   	--self:OnRefreshPlayer()

   	self.view.nDouble:setString("1");
    self.view.nDizhu:setString("");		    
    -- if self.logic.hasBaoValue==0 then
    --     self.view.lableLazi:setString("");
    -- end
    -- self.view.nLaizi:setString("");
    self.view.cLordCardNode:setVisible(false)
    self.view.cLordCardNode:removeAllChildrenWithCleanup(true)
    self.view.nodeLaiZi:setVisible(false)
    self.view.nodeLaiZi:setScale(1.0)
    self.view.nodeLaiZi:setPosition(ccp(display.cx,display.cy))
    --self:GetMe().play_card_:removeAllChildrenWithCleanup(true);
    self:GetMe().cards_.m_cCards = {};
    self:GetMe().cards_:SetBaoValue(0);
    self.view.puKeLayer:removeAllChildrenWithCleanup(true);
    self.view:ManagementClick();
    self.data.nowCardTyp = {m_nTypeBomb=0,m_nTypeNum=0,m_nTypeValue=0}--上个出牌人的出牌类型
	self.data.nowcChairID = 0--上个出牌人的位置
	self.view:resetBtnPosition()
	--显示准备按钮
	-- self.view:showReadyChange()
	-- if self.view.butLayerState == 1 then
 --        self.view:ChangeLayer() 
 --    end 
end

function GameSceneCtrller:onMsgData(event)
	local message = event.message;
	print("=========================GameSceneCtrller:onMsgData")
	-- var_dump(message,4)
	if self.view.hasAddGame2 == 0 then 
		self.view:initBaseInfo2()
	end 
	if (message.ret_== 0) then	
		--初始化数据
		if self.logic.is_chang_table==2 then
			-- if (self.logic.hasBaoValue==0) then
		 --        self.lableLazi:setString("");
		 --    else
		 --        self.lableLazi:setString("癞子：");
		 --    end
		    -- self.view.nLaizi:setString("");
		    -- self.view.nMoney:setString(self.logic.needMoney);
		end
		for k,v in pairs(gBaseLogic.lobbyLogic.userData.ply_items_) do
	        if (v.index_==2) then
	        	self.noteCardsNum = v.num_
	            break;
	        end
	    end
	    self.view:initNoteCardsNum()
	    
		self.data.other_ply_attrs_ = message.table_attrs_.players_;
		if self.is_robot ~= 0 then 
			self.data.self_ply_attrs_.ply_guid_ = 999
		else
			for k,v in pairs(self.data.other_ply_attrs_) do
				local chairID = v.chair_id_;
				if (v.ply_guid_ == self.data.self_ply_attrs_.ply_guid_) then
					self.data.self_ply_attrs_ = v;
			    end
			end
		end
		var_dump(self.data.self_ply_attrs_)
		self:OnRefreshPlayer()
		-- var_dump(message.table_attrs_,3);
		-- for k,v in pairs(self.data.table_attrs_.players_) do
		-- 	if (v.ply_guid_ == gBaseLogic.lobbyLogic.userData.ply_guid_) then
		-- 		self.data.cChairID = v.chair_id_;
		-- 		break;
		-- 	end
		-- end
		-- self.data.cChairID = 1;
		-- print("==================self.data.cChairIDsssss:"..self.data.cChairID);
		if self.is_robot ~= 0 then 
			--self.robotai:setGameStateAndData(EVENT_ID["pt_cb_ready_req"],0)
		else
			self.logic:sendTableReady()
		end
		-- elseif (self.data.self_ply_attrs_.ready_~=1) then
		-- 	self.logic:sendTableReady()
		-- end
		self.view:ShowGameTip("正在寻找小伙伴一起玩耍……",true)
		if self.logic.isMatch==0 then
			if self.logic.hasreqbaoXiangRenWu == 0 then
				self.logic.roundTaskFinishNum = 0
			    self.logic:pt_cb_get_task_system_req()
			    self.logic:pt_cb_get_online_award_items_req()
			    self.logic:pt_cb_get_streak_task_req()
			end
			self.logic.hasreqbaoXiangRenWu = 1
		end
	end
end

function GameSceneCtrller:onMsgRefreshCard(event)
	print("=========================onMsgRefreshCard"..event.message.cChairID)
	local message = event.message;
	--print(message.cChairID)
	--var_dump(message.vecCards,3)
	-- var players_ = [{ply_guid_:'12324',nickname_:'xiaohui',gift_:12,money_:5000,score_:10,won_:20,lost_:50,dogfall_:5,table_id_:1,ready_:1},{ply_guid_:'32141',nickname_:'xiaohui2',gift_:12,money_:5000,score_:10,won_:11,lost_:55,dogfall_:5,table_id_:1,ready_:1},{ply_guid_:'422',nickname_:'xiaohui3',gift_:12,money_:5000,score_:10,won_:23,lost_:10,dogfall_:5,table_id_:1,ready_:1}];
	-- 	var table_attrs_ ={table_id_:1,name_:'xiaohui_roomtable',lock_:0,players_:players_};
	self.view:OnRefreshCard(message)
	-- if ( self.data.is_game_start_ == false) then
 --        self:set_is_game_start(true)
 --    end
end

--通知服务器发牌完成
function GameSceneCtrller:sendCardokAck()
-- 	NET_PACKET(pt_cg_send_card_ok_ack)
-- {
-- 	int nSerialID;						//消息序列
-- };
	print("=========================sendCardokAck")
	if self.is_robot ~= 0 then 
		self.robotai:setGameStateAndData(EVENT_ID["UPDATE_EVENT_GAME_START"],0)
	else	
		local loginMsg = {opcode = 'pt_cg_send_card_ok_ack',nSerialID=self.data.nSerialID};  
		self.logic:sendGameSocket(loginMsg); 
    end
end

function GameSceneCtrller:onMsgGameStart(event)
	local message = event.message;
		 
	self.data.nSerialID  = message.nSerialID;--消息序列
	self.data.nGameMoney = message.nGameMoney;--底注
	self.data.nCardNum = message.nCardNum;--牌的数量
	self.data.cLordCard = message.cLordCard;--地主牌 

	-- self.view.nDizhu:setString(message.nGameMoney);
	print(message.nGameMoney)
	self.view:GameStart(message.nGameMoney);
	print("===========================onMsgGameStart");
	self.view:hideGameTip()
end

function GameSceneCtrller:onMsgOtherJoinTable(event)
	print("===========================onMsgOtherJoinTable start");

	local message = event.message;
	-- var_dump(message,3) 
	self:OnUserJoin(message)
	-- table.insert(self.data.other_ply_attrs_,message.ply_data_)
	-- 更新游戏列表
	print("===========================onMsgOtherJoinTable end");
end


-- 叫分 nScore:1,2,3
function GameSceneCtrller:sendCallSoces(nScore)
	-- CreateTable
	-- local nScore = 3; 
	if self.is_robot ~= 0 then 
		self.robotai:setGameStateAndData(EVENT_ID["pt_cg_call_score_ack"],nScore)
	else
		local loginMsg = {opcode = 'pt_cg_call_score_ack',nScore = nScore,nSerialID=self.data.nSerialID};  
		-- var_dump(loginMsg)
		self.logic:sendGameSocket(loginMsg);
    end 
end

-- 叫分 nScore:1,2,3
function GameSceneCtrller:onMsgCallScore(event)
	-- nScore:2,nSerialID:1
	local message = event.message;
	print("GameSceneCtrller:onMsgCallScore:"..message.nScore);
	
	local nSerialID = message.nSerialID 
	self.data.nSerialID = message.nSerialID;
	-- 跳出叫分页面

	self.view:showCallScore(message.nScore)
end

--抢地主发信令
function GameSceneCtrller:sendRobLord(cRob)--0:不抢,1:抢地主
	print("=====pt_cg_rob_lord_ack")
	if self.is_robot ~= 0 then 
		self.robotai:setGameStateAndData(EVENT_ID["pt_cg_rob_lord_ack"],cRob)
	else

	local loginMsg = {opcode = 'pt_cg_rob_lord_ack',cRob = cRob,nSerialID=self.data.nSerialID}; 
	-- var_dump(loginMsg) 
	self.logic:sendGameSocket(loginMsg);
	
	end
	print("=====pt_cg_rob_lord_ack")
end
--抢地主信令
function GameSceneCtrller:onMsgRobLord(event)--pt_gc_rob_lord_req
	local message = event.message;
	local nSerialID = message.nSerialID --//消息序列
	local cDefaultLord = message.cDefaultLord --//默认地主座位号
	self.data.nSerialID = message.nSerialID
    self.view:showRobLord()
	-- 跳出抢地主页面
-- 	NET_PACKET(pt_gc_rob_lord_req)
-- {
-- 	char cDefaultLord;	//默认地主座位号
-- 	int nSerialID;		//消息序列
-- };
-- NET_PACKET(pt_cg_rob_lord_ack)
-- {
-- 	char cRob;			//0:不抢,1:抢地主
-- 	int nSerialID;		//消息序列
-- };
end

--显示地主的底牌
function GameSceneCtrller:onMsgLordCard(event)
	--onMsgLordCard cLord:'1',vecCards:vecCards
	local message = event.message;
	self.data.cLordCard = message.vecCards;
	self.data.cLord = message.cLord 
	--图像显示
	local nPos = self:S2C(message.cLord);
	for i=1,3 do
		if (nPos+1==i) then
			self.data.players_[i]:RefreshHeadIcon(1);
		else
			self.data.players_[i]:RefreshHeadIcon(0);
		end
	end
 
	self.view:showLordCardNot()
	-- cLordCard =  = {},--地主牌
	-- 	cLord = -1 --地主位置
end

-- 通知玩家出牌
function GameSceneCtrller:onMsgPlayCard(event)
	--onMsgLordCard cLord:'1',vecCards:vecCards
	local message = event.message;
	-- local cAuto = message.cAuto;  --//1:自动出牌,0:手动出牌
	-- local nSerialID = message.nSerialID;
	self.data.nSerialID = message.nSerialID;
	self.vernier_index = 1;
	self.view.hasUnselected = 0;
	-- char cAuto;							//1:自动出牌,0:手动出牌
	-- int nSerialID;						//消息序列
	if message.cAuto==1 then
		if self.is_auto_ == false then
			self.is_auto_ = true
			self.view:showManageBtn()
			self.view:releaseSelectedCard()
		end

	else
		if self.is_auto_ == true then
			self.view.gameLayer:removeChildByTag(2)
			self.is_auto_ = false ;
		end
	end
	print("GameSceneCtrller:onMsgPlayCard"..self.data.nowcChairID)
	print("myid"..self.data.self_ply_attrs_.chair_id_ .. "m_nTypeNum:"..self.data.nowCardTyp.m_nTypeNum)
	--var_dump(self.data.nowCardTyp)
	if (self.data.nowcChairID==-1 or self.data.nowcChairID==self.data.self_ply_attrs_.chair_id_ or self.data.nowCardTyp.m_nTypeNum==0) then
		self.view.oneButton:setEnabled(false);
		self:GetMe().cards_:TipsCom()
	else
		self.view.oneButton:setEnabled(true);
		self:GetMe().cards_:Tips(self.data.nowCardTyp);
		-- var_dump(self.data.nowCardTyp)
		-- var_dump(self:GetMe().cards_.m_vecTipsCards)
		if #self:GetMe().cards_.m_vecTipsCards==0 then
			if self.view.notRule:isVisible() == false then
					self.view.notRule:setTexture(getCCTextureByName("images/YouXi/game_pic_wupai.png"));
					self.view.notRule:setVisible(true)
					local _RunActionCallBack = function()
						print("12333====")
						self:sendNoCard();
					end
					local fade_seq = transition.sequence({CCFadeIn:create(0.25),
					CCDelayTime:create(3.0),
					CCFadeOut:create(0.25),
					CCHide:create(),
					CCCallFunc:create(_RunActionCallBack)});
					self.view.notRule:runAction(fade_seq);
				end
		end
	end
	if self.is_auto_ == false then
    	self.view:showPlayCardBtn()
    end
end

--玩家出牌
function GameSceneCtrller:sendPlayCard(vecCards)

	if self.is_robot ~= 0 then 
		local size = #vecCards
		print("GameSceneCtrller:sendPlayCard(vecCards):"..size)
		self.robotai:setGameStateAndCard(EVENT_ID["pt_cg_play_card_ack"], vecCards)

	else
		local cTimeOut = 0;	--//1:超时出牌,0:正常出牌
		--local vecCards = {};	--出的票array	
		-- print("GameSceneCtrller:sendPlayCard");
		--刷新记牌器
		print("GameSceneCtrller:sendPlayCard");
		self.view:refreshCardNote(vecCards)
		local loginMsg = {opcode = 'pt_cg_play_card_ack',cTimeOut = cTimeOut,vecCards = vecCards,nSerialID = self.data.nSerialID}; 
		var_dump(loginMsg,3);
		self.logic:sendGameSocket(loginMsg);
	
-- 	NET_PACKET(pt_cg_play_card_ack)
-- {
-- 	int nSerialID;						//消息序列
-- 	char cTimeOut;						//1:超时出牌,0:正常出牌
-- 	vector<CCard> vecCards;				//打出的牌
-- };
	end
	self.data.nowcChairID = -1;
end

--不出
function GameSceneCtrller:sendNoCard()
	if (self.data.nowcChairID==-1 or self.data.nowCardTyp.m_nTypeNum==0) then
		print ("no comparis")
		return
	else
		self:sendPlayCard({});
		self.view:releaseSelectedCard()
		self.view:HidenOpBtn()
		if self.view.notRule:isVisible() then
			transition.stopTarget(self.view.notRule)
			self.view.notRule:setVisible(false)
		end
	end
end	

-- function GameSceneCtrller:EraseCards(vecCards)
-- 	for k,v in pairs(vecCards) do
-- 		cardsNum = cardsNum+1;
-- 		for k1,v1 in pairs(self.data.vecCards) do
-- 			if (v1.m_nValue == v.m_nValue and v1.m_nColor == v.m_nColor) then
-- 				self.data.vecCards[k1] = nil;
-- 				break;
-- 			end
-- 		end
-- 	end
-- end

--玩家出牌信息广播onMsgPlayCardNot
function GameSceneCtrller:onMsgPlayCardNot(event)
	local message = event.message;
	-- local cChairID = message.cChairID;  --//位置
	-- local vecCards = message.vecCards;
	-- local cType = message.cType;
	--当前玩家出牌牌型
	print("======onMsgPlayCardNot:"..message.cType.m_nTypeNum)
	-- print(cChairID);
	
	if (message.cType ==nil or message.cType.m_nTypeNum ==nil or message.cType.m_nTypeNum==0) then
		print ("nocard");
		var_dump(message.vecCards,3);
	else 
		--var_dump(message);
		
		if (message.cChairID == self.data.self_ply_attrs_.chair_id_) then 
			self.data.nowcChairID = -1;
			-- if (self.is_auto_ == false) then
	  --           self.view:showManageBtn()
	  --           self.is_auto_ = true ;
	  --           self:pt_cg_auto_req_send(1)
	  --        end
		else
			self.data.nowCardTyp = message.cType;
			
			self.data.nowcChairID = message.cChairID;
		end
		-- print(self.data.nowcChairID .."--my:"..self.data.self_ply_attrs_.chair_id_ .."playercardId"..message.cChairID )

	end
	print("showcardhere==")
	print(self.data.nowcChairID .."--my:"..self.data.self_ply_attrs_.chair_id_ .."playercardId"..message.cChairID )
	var_dump(message.cType)
	var_dump(message.vecCards,3);
	-- var_dump(self.data.nowCardTyp)
	self:OnPlayCardNot(message)
	--刷新记牌器
	self.view:refreshCardNote(message.vecCards)
 end

 ----炸弹倍数
function GameSceneCtrller:onMsgBombNot(event)
	local message = event.message;
	local oldnDouble = self.nDouble
	local nDouble = message.nDouble;  --//倍数
	print("oldnDouble:"..oldnDouble)
	print("newnDouble:"..nDouble)
	local nper = nDouble/oldnDouble;
	self.nDouble = nDouble
	print("===============onMsgBombNot")

	self.view:showDouble(nDouble,nper)

end

--通用提醒 onMsgCommonNot
function GameSceneCtrller:onMsgCommonNot(event)
	local message = event.message;
	-- local cChairID = message.cChairID;  
	-- local nOp = message.nOp;  
	-- 	int nOp;	//消息类型	
			-- 	enum COMMON_OPCODE
			-- {
			-- 	CO_NEW = 0,								//开始新的一圈牌
			-- 	CO_CALL0,								//不叫
			-- 	CO_CALL1,								//叫1分
			-- 	CO_CALL2,								//叫2分
			-- 	CO_CALL3,								//叫3分
			-- 	CO_NOTCALLROB,							//不叫地主
			-- 	CO_CALLROB,								//叫地主
			-- 	CO_NOTROB,								//不抢地主
			-- 	CO_ROB,									//抢地主
			-- 	CO_GIVEUP,								//过牌
			-- 	CO_SHOWCARD,							//亮牌
			-- 	CO_TIMEOUT,								//超时	
			-- 	CO_READY,								//准备
			-- 	CO_NOLORD,								//本局没有地主，请求清理桌面，重新发牌
			-- 	CO_START,								//开始游戏
			-- 	CO_PUT,									//出牌
			-- 	CO_LORDCARD,							//地主底牌
			-- 	CO_END,									//游戏结束
			-- 	CO_VER,									//游戏版本信息
			-- 	CO_DATA,								//保存的玩家信息
			-- };					
	-- char cChairID;						//玩家坐位号
	print("===============onMsgCommonNot")
	self:OnCommonNot(message)
end

function GameSceneCtrller:onMsgClienttimerNot(event)
	local message = event.message;
	print("===============onMsgClienttimerNot",message.chairId, message.sPeriod/1000)
	self:ClientTimerNot(message.chairId, message.sPeriod/1000)
end

function GameSceneCtrller:onChatNot(event)
	print("onChatNot") 
	var_dump(event)
	local noti = event.message;
	local player = self:FindPlayerByPID(noti.ply_guid_);
	if (player == nil) then
		return;
	end
	local nPos = self:S2C(player:getPlyData().chair_id_);
	local chatType;
	local i,j = string.find(noti.message_,"<A┃┃")
	if i == 1 then
		chatType = player.data.CHAT_TYPE_ANI;
	end
	local i,j = string.find(noti.message_,"<B┃┃")
	if i == 1 then
		chatType = player.data.CHAT_TYPE_TXT;
	end
	local i,j = string.find(noti.message_,"<C┃┃")
	if i == 1 then
		chatType = player.data.CHAT_TYPE_INPUT;
	end
	local i,j = string.find(noti.message_,"<D┃┃")
	if i == 1 then
		chatType = player.data.CHAT_TYPE_PAY_ANI;
	end
	if (chatType==nil) then
		return
	end
	if (chatType == player.data.CHAT_TYPE_ANI or chatType == player.data.CHAT_TYPE_PAY_ANI) then
		if (gBaseLogic.hasDownloadBiaoqing == false) then
	        return;
	    end
	end

	player = self.data.players_[nPos+1]
	if (player) then
		player:onChatNot(chatType,noti.message_);
	end
end 
function GameSceneCtrller:onChatPayNot(event)
	print("onChatPayNot")
	if (chatType == player.data.CHAT_TYPE_ANI or chatType == player.data.CHAT_TYPE_PAY_ANI) then
		if (gBaseLogic.hasDownloadBiaoqing == false) then
	        return;
	    end
	end
	var_dump(event.message)
	local noti = event.message;
	local player = self:FindPlayerByPID(noti.src_ply_guid_);
	if (player == nil) then
		return;
	end
	if noti.index_ ~= self.logic.ITEM_EXPRESSION_PARCEL then 
		return
	end
	local nPos = self:S2C(player:getPlyData().chair_id_);

	player = self.data.players_[nPos+1]
	if (player) then
		player:OnChatPayNot(noti.amount_);
	end
end 
	
function GameSceneCtrller:CheckSelect()  --判断选中牌是否符合规则
	print ("===============GameSceneCtrller:CheckSelect+++++++++")
	
	--
	-- local op_card_type = {m_nTypeBomb=0,m_nTypeNum=2,m_nTypeValue=10};--上个玩家出牌类型
	-- int m_nTypeBomb;	// 0:不是炸弹 1:软炸弹 2:硬炸弹 
	-- int m_nTypeNum;		//牌的数量
	-- int m_nTypeValue;	//牌的值
	local mapTyp  = 0
	if self.data.nowcChairID==-1 or self.data.nowCardTyp.m_nTypeNum==0 or self.data.nowcChairID==self.data.self_ply_attrs_.chair_id_ then
		mapTyp = 0;
	else
		mapTyp = self.data.nowCardTyp.m_nTypeNum;
	end

	local cardCheck = self:GetMe():GetSelectedCard(mapTyp);
	-- print (cardCheck);
	-- print(self.data.nowcChairID,self.data.self_ply_attrs_.chair_id_);
	-- var_dump(self.data.nowCardTyp);
	if cardCheck==1 then
		if (self.data.nowcChairID==-1 or self.data.nowCardTyp.m_nTypeNum==0 or self.data.nowcChairID==self.data.self_ply_attrs_.chair_id_) then	
			self:PlayCard()
		else 
			if (self:GetMe().cards_:CompareCards(self.data.nowCardTyp)==1) then
				self:PlayCard()
			else				
				-- print("GameSceneCtrller:CheckSelect--------error")
				-- print("mychairid:".. self.data.self_ply_attrs_.chair_id_)
				-- print("nowcChairID:".. self.data.nowcChairID)
				-- var_dump (self:GetMe().cards_.m_cDiscardingType)
				-- var_dump(self.data.nowCardTyp);
				-- print("GameSceneCtrller:CheckSelect--------error")
				-- print ("CompareCards error");
				if self.view.notRule:isVisible() == false then
					self.view.notRule:setTexture(getCCTextureByName("images/YouXi/game_pic_chongxuan.png"));
					self.view.notRule:setVisible(true)
					local fade_seq = transition.sequence({CCFadeIn:create(0.25),
					CCDelayTime:create(1.0),
					CCFadeOut:create(0.25),
					CCHide:create()});
					self.view.notRule:runAction(fade_seq);
				end
			end
		end
	else
		print ("syc check card error");
		if self.view.notRule:isVisible() == false then
			self.view.notRule:setTexture(getCCTextureByName("images/YouXi/game_pic_chongxuan.png"));
			self.view.notRule:setVisible(true)
			local fade_seq = transition.sequence({CCFadeIn:create(0.25),
				CCDelayTime:create(1.0),
				CCFadeOut:create(0.25),
				CCHide:create()});
			self.view.notRule:runAction(fade_seq);
		end   
	end 
end

function GameSceneCtrller:PlayCard()
	-- print("GameSceneCtrller:PlayCard1")
	-- var_dump(self:GetMe().cards_.m_choose_cCards);
	local cards_ = self:GetMe():GetPlayCards();
	self:sendPlayCard(cards_.m_choose_cCards)	
	self.view:HidenOpBtn()
	gBaseLogic.audio:PlayAudioType(cards_.m_cDiscardingType);
	self:GetMe():PlaySelectCard()  --普通出牌动画
	if (cards_.m_cDiscardingType.m_nTypeBomb > 0) then
		if (cards_.m_cDiscardingType.m_nTypeValue == 16) then
			self.data.players_[1]:PlayAni(28); --ANI_HUOJIAN
		else
			self.data.players_[1]:PlayAni(26); --ANI_ZHADAN
		end
		--self:ChangeGameScore(game_score_*2);
		return;
	end
	if (cards_.m_cDiscardingType.m_nTypeNum >= 5 and cards_.m_cDiscardingType.m_nTypeNum <= 12) then
		self.data.players_[1]:PlayAni(27); --ANI_SHUNZI
	elseif (cards_.m_cDiscardingType.m_nTypeNum == 222 or cards_.m_cDiscardingType.m_nTypeNum == 2222 or cards_.m_cDiscardingType.m_nTypeNum == 22222 or cards_.m_cDiscardingType.m_nTypeNum == 222222 or cards_.m_cDiscardingType.m_nTypeNum == 2222222 or cards_.m_cDiscardingType.m_nTypeNum == 22222222 or cards_.m_cDiscardingType.m_nTypeNum == 222222222 or cards_.m_cDiscardingType.m_nTypeNum == 2000000000) then
		self.data.players_[1]:PlayAni(29); --ANI_LIANDUI
	elseif (cards_.m_cDiscardingType.m_nTypeNum == 33 or cards_.m_cDiscardingType.m_nTypeNum == 333 or cards_.m_cDiscardingType.m_nTypeNum == 3333 or cards_.m_cDiscardingType.m_nTypeNum == 33333 or cards_.m_cDiscardingType.m_nTypeNum == 333333 or cards_.m_cDiscardingType.m_nTypeNum == 33332222 or cards_.m_cDiscardingType.m_nTypeNum == 333222 or cards_.m_cDiscardingType.m_nTypeNum == 3322 or cards_.m_cDiscardingType.m_nTypeNum == 3311) then
		self.data.players_[1]:PlayAni(25); --ANI_FEIJI
	end
end

function GameSceneCtrller:callTips()
	-- local cCardsType = {m_nTypeBomb=0,m_nTypeNum=2,m_nTypeValue=4};
	-- var_dump(self:GetMe():GetPlayCards().m_vecTipsCards[self.vernier_index])
	print("================callTips")
	--print (self.vernier_index)
	--var_dump(self:GetMe():GetPlayCards().m_vecTipsCards)
	if (#self:GetMe():GetPlayCards().m_vecTipsCards == 0) then
		self:sendNoCard()
		gBaseLogic.audio:PlayAudio(25); --AUDIO_PASS
	else
	    if self.vernier_index < #self:GetMe():GetPlayCards().m_vecTipsCards+1 then
	    	local vernier_index = self.vernier_index;
			local vecCards = self:GetMe():GetPlayCards().m_vecTipsCards[vernier_index];
			-- var_dump(vecCards) 
			self.view:setSelectedCard(vecCards) ;
			self.vernier_index = self.vernier_index + 1;
			if (self.vernier_index >= #self:GetMe():GetPlayCards().m_vecTipsCards+1) then
				self.vernier_index = 1;
			end
			izx.baseAudio:playSound("audio_menu");--AUDIO_MENU
		end
	end
	print("================callTips")
	-- local m_vecTipsCards = self:GetMe().cards_.m_vecTipsCards;
	-- var_dump(m_vecTipsCards[self.vernier_index]);
	-- self.vernier_index  =  self.vernier_index + 1;
	-- if (self.vernier_index>#m_vecTipsCards) then
	-- 	self.vernier_index = 1;
	-- end
end

function GameSceneCtrller:S2C(cChairID)  --服务器坐标转换到客户端坐标
	-- print("===GameSceneCtrller:S2C")
	-- var_dump(self.data.players_[1],cChairID)
	-- var_dump(self.data.players_[1]:getPlyData())
	-- print("===GameSceneCtrller:S2C")

	-- var_dump(self.data.players_[1],cChairID);
	if (cChairID < 0) then
        return cChairID;
    end 
	local nPos = self.data.players_[1]:getPlyData().chair_id_;
	if (nPos == nil ) then 
		print("self.data.players_[1] data is nil")
		return cChairID 
	end

    if ((nPos + 1) % self.data.MAX_PLY_NUM == cChairID ) then
        return 1;
    elseif ((nPos + 2) % self.data.MAX_PLY_NUM == cChairID ) then
        return 2;
    elseif (nPos % self.data.MAX_PLY_NUM == cChairID) then
        return 0;
    end
    return cChairID;
end

function GameSceneCtrller:FindPlayerByChairID(chairId)
	local nPos = self:S2C(chairId);
	if (nPos >= 0 and nPos < self.data.MAX_PLY_NUM) then
		return self.data.players_[nPos+1];
	end
	return nil;
end

function GameSceneCtrller:FindPlayerByPID(ply_guid)
	for i=1,self.data.MAX_PLY_NUM do
		if (self.data.players_[i] and self.data.players_[i]:getPlyData().ply_guid_ == ply_guid) then
			return self.data.players_[i];
		end
	end
	return nil;
end

function GameSceneCtrller:ClientTimerNot(nChairID, nSecond)
	print("GameSceneCtrller:ClientTimerNot(%s, %s)",nChairID,nSecond)
	if (nChairID < 0) then
		return;
	end
	local nPos = self:S2C(nChairID);
	self.clientTimerPos = nPos;
	-- if nSecond>=18 and self.data.is_game_start_==true then
	-- 	nSecond = 18;
	-- end
	for i=0, self.data.MAX_PLY_NUM-1 do		
		if (i == nPos) then
			self.data.players_[i+1]:startClientTimer(nSecond);
		else
			self.data.players_[i+1]:startClientTimer(0);
		end
	end
end

function GameSceneCtrller:GetMe()
	return self.data.players_[1];
end
	
function GameSceneCtrller:player(chariId)
	--return players_[chariId];
end

function GameSceneCtrller:is_game_start()
	return self.data.is_game_start_;
end

function GameSceneCtrller:is_auto()
	return self.is_auto_;
end

function GameSceneCtrller:set_is_game_start(flag)
	self.data.is_game_start_ = flag;
	if self.data.is_game_start_ then 
		self.view:hideGameTip()
		print("GameSceneCtrller:set_is_game_start true");
		-- self.view.puKeLayer:registerScriptTouchHandler(function(event, x, y)
	 --        return self.view:onTouch(event, x, y)
	 --    end,false,0,false)    
	 --    self.view.puKeLayer:setTouchEnabled(true)

	 	--已經移到初始化遊戲界面了
	else
		-- if (gBaseLogic.MBPluginManager.frameworkVersion>=14081501) then
		-- 	self.view.puKeLayer:removeNodeEventListener();
		-- else
		--  	self.view.puKeLayer:unregisterScriptTouchHandler();
		-- end
	end
end

function GameSceneCtrller:set_discarding_type(card_type)
	self.discarding_type_ = card_type;
end

function GameSceneCtrller:discarding_type()
	return self.discarding_type_;
end

function GameSceneCtrller:set_tip_index(index)
    tip_index_ = index;	
end

function GameSceneCtrller:tip_index()
    return tip_index_;
end

function GameSceneCtrller:self_hand_card_size()
    return self_hand_card_size_;
end

function GameSceneCtrller:self_hand_card()
    return self_hand_card_;
end

function GameSceneCtrller:left_put_card()
    return left_put_card_;
end

function GameSceneCtrller:right_put_card()
    return right_put_card_;
end

function GameSceneCtrller:self_put_card()
    return self_put_card_;
end

function GameSceneCtrller:left_head_game_pos()
    return left_head_game_pos_;
end

function GameSceneCtrller:right_head_game_pos()
    return right_head_game_pos_;
end

function GameSceneCtrller:play_card_size()
    return play_card_size_;
end

function GameSceneCtrller:play_card_scale()
    return play_card_scale_;
end

function GameSceneCtrller:di_zhu()
    return di_zhu_;
end

function GameSceneCtrller:game_score()
    return game_score_;
end

function GameSceneCtrller:dizhu_chaird()
    return dizhu_chaird_;
end

function GameSceneCtrller:self_card_size()
    return self_card_size_;
end

function GameSceneCtrller:task_status()
    return task_tatus_;
end

function GameSceneCtrller:task_money_mission()
    return task_money_mission_;
end

function GameSceneCtrller:task_paper_mission()
    return task_paper_mission_;
end

function GameSceneCtrller:front_card_value()
    return front_card_value_;
end

function GameSceneCtrller:left_chat_ani_pos()
    return left_chat_ani_pos_;
end

function GameSceneCtrller:right_chat_ain_pos()
    return right_chat_ani_pos_;
end

function GameSceneCtrller:self_chat_ani_pos()
    return self_chat_ani_pos_;
end

function GameSceneCtrller:card_effect_pos()
    return card_effect_pos_;
end

function GameSceneCtrller:left_left_card_pos()
    return left_left_card_pos_;
end	

function GameSceneCtrller:right_left_card_pos()
    return right_left_card_pos_;
end	

function GameSceneCtrller:scale_dipai()
    return scale_dipai_;
end	

function GameSceneCtrller:right_game_left_card_pos()
    return right_game_left_card_pos_;
end	

function GameSceneCtrller:left_game_left_card_pos()
    return left_game_left_card_pos_;
end	

function GameSceneCtrller:game_left_card_pos()
    return game_left_card_pos_;
end	

function GameSceneCtrller:is_no_money_quit()
    return is_no_money_quit_;
end	

function GameSceneCtrller:laizi_card_size()
    return laizi_card_size_;
end	

function GameSceneCtrller:RefreshWinLost()

end 

function GameSceneCtrller:OnUserJoin(noti)
	print(noti.ply_data_.ply_guid_.."OnUserJoin"..self.data.self_ply_attrs_.ply_guid_)
	if self.view.hasAddGame2 == 0 then 
		self.view:initBaseInfo2()
	end 

	if (noti.ply_data_.ply_guid_ == self.data.self_ply_attrs_.ply_guid_) then
		if self.is_robot ~= 0 then	
			self.view:ShowGameTip("正在寻找小伙伴一起玩耍……",true)
			print("----------is user join , get puid");
			noti.ply_data_.ply_guid_ = self.data.ply_guid_;	
			noti.ply_data_.nickname_ = self.data.nickname_;
			--noti.ply_data_.param_2_ = CCUserDefault:sharedUserDefault():getStringForKey("ply_Level_")

			--noti.ply_data_.money_ = self.robotMonery
			--self.data.self_ply_attrs_ = noti.ply_data_
			-- print(self.event_id.UPDATE_EVENT_READY,opcodeDefine["pt_cb_ready_req"])
			--self.robotai:setGameStateAndData(EVENT_ID["pt_cb_ready_req"],0)
			self.view:showReadyChange()
			--GetMe()->setUserData(noti->ply_data_);
			--btn_ready_->setIsVisible(true);
			--btn_change_table_->setIsVisible(true);	
			--var_dump(noti.ply_data_)
		end 

		if (self:GetMe():getPlyData() == nil or self:GetMe():getPlyData().ply_guid_ ~= noti.ply_data_.ply_guid_) then
			self:GetMe():setUserData(noti.ply_data_);
			-- if(GameSession::GetInstancePtr()->is_race_sign()>0)
			-- {
				
			-- }
			-- else{
			-- 	btn_ready_->setIsVisible(true);
			-- 	btn_change_table_->setIsVisible(true);
			-- }
		end
	else
		-- print("===========================noti.ply_data_.chair_id_")
		-- var_dump(noti.ply_data_.chair_id_);
		var_dump(noti.ply_data_,4)
		--print("==========================="..noti.ply_data_.chair_id_)
		if noti.ply_data_.chair_id_==nil or noti.ply_data_.chair_id_==-1 then
			if (noti.ply_data_.chair_id_==-1) then
				print("otherjoin other in table")
			end
			
		else
			local nPos = self:S2C(noti.ply_data_.chair_id_);
			if (nPos < self.data.MAX_PLY_NUM and nPos >= 0) then
				self.data.players_[nPos+1]:setUserData(noti.ply_data_);
			end
		end
	end
end

function GameSceneCtrller:OnPlayCardNot(noti)
    local nPos = self:S2C(noti.cChairID);
    -- local cardsnum = 0;
    -- print(nPos);
    -- for k,v in pairs(noti.vecCards) do
    -- 	cardsnum = cardsnum + 1
    -- end
	if (#noti.vecCards > 0) then
	    self:GetMe():GetPlayCards().m_cDiscardingType = noti.cType ;
	    self:set_discarding_type(noti.cType)
	    gBaseLogic.audio:PlayAudio(16); --putcard
	end

	if (nPos == 0) then
		self.view:HidenOpBtn();
		self.set_discarding_type({m_nTypeBomb= 0,m_nTypeNum= 0,m_nTypeValue = 0});
		--is_operate_self_ = false;
	end
	gBaseLogic.audio:PlayAudioType(noti.cType);
	self.data.players_[nPos+1]:OnPlayCardNot(noti);

	--火箭和炸弹的动画处理。
	if (noti.cType.m_nTypeBomb>0) then
		if (noti.cType.m_nTypeValue == 16) then
			self.data.players_[nPos+1]:PlayAni(28); --ANI_HUOJIAN
		else
			self.data.players_[nPos+1]:PlayAni(26); --ANI_ZHADAN
		end
		return;
	end
	--牌型的处理。
	if (noti.cType.m_nTypeNum >= 5 and noti.cType.m_nTypeNum <= 12) then
		self.data.players_[nPos+1]:PlayAni(27); --ANI_SHUNZI
	elseif (noti.cType.m_nTypeNum == 222 or noti.cType.m_nTypeNum == 2222 or noti.cType.m_nTypeNum == 22222 or noti.cType.m_nTypeNum == 222222 or noti.cType.m_nTypeNum == 2222222 or noti.cType.m_nTypeNum == 22222222 or noti.cType.m_nTypeNum == 222222222 or noti.cType.m_nTypeNum == 2000000000) then
		self.data.players_[nPos+1]:PlayAni(29); --ANI_LIANDUI
	elseif (noti.cType.m_nTypeNum == 33 or noti.cType.m_nTypeNum == 333 or noti.cType.m_nTypeNum == 3333 or noti.cType.m_nTypeNum == 33333 or noti.cType.m_nTypeNum == 333333 or noti.cType.m_nTypeNum == 33332222 or noti.cType.m_nTypeNum == 333222 or noti.cType.m_nTypeNum == 3322 or noti.cType.m_nTypeNum == 3311) then
		self.data.players_[nPos+1]:PlayAni(25); --ANI_FEIJI
	end
end

function GameSceneCtrller:OnCommonNot(noti)
	print("OnCommonNot, op:"..noti.nOp)
	if noti.nOp == 0 then --开始新的一圈牌

	elseif noti.nOp == 13 then --本局没有地主，清理桌面
		if gBaseLogic.is_robot ~= 0 then
			--self:reInit()
        	--self.robotai:setGameStateAndData(EVENT_ID["cb_change_table_req"],0)
    	end
	elseif noti.nOp == 11 then --超时
        self.view:HidenOpBtn()
	else
		if (noti.cChairID ~=-1) then
		    local pPlayer = self:FindPlayerByChairID(noti.cChairID) ;
			if (pPlayer) then
				pPlayer:ShowTips(noti.nOp);
			end
		end
	end
end

function GameSceneCtrller:OnRefreshPlayer()
	print("GameSceneCtrller:OnRefreshPlayer")
	local room_ply = self.data.other_ply_attrs_;
	--  print("=============ply_base_data_3");
	-- var_dump(self.data.self_ply_attrs_)
	self:GetMe():setUserData(self.data.self_ply_attrs_);
	if (#room_ply > 1) then
        for k,v in pairs(room_ply) do
        	if v.ply_guid_ ~= self.data.self_ply_attrs_.ply_guid_ then         		
	    		local nPos = self:S2C(v.chair_id_);
				if (nPos>0 and nPos<self.data.MAX_PLY_NUM) then
					-- self.data.players_[nPos+1]:ReInit();
					self.data.players_[nPos+1]:setUserData(v);
					
					if (v.ready_==1) then
						self.data.players_[nPos+1]:ShowTips(12);
					end
				end
        	end
        end
	end
end	

function GameSceneCtrller:OnUpdateMoney(noti)  --更新玩家游戏币
   	local message = noti.message;
   	if message.ply_guid_ == 999 then
		local Player = self:FindPlayerByPID(self.data.ply_guid_);
		if (Player) then
			if (message.upt_type_==0) then
				Player:changeMoney(message.amount_)
			end
		end 
	else 
	--self:pt_bc_update_ply_data_not_rec(noti)
	end
end	

function GameSceneCtrller:OnAutoNot(noti)
    --自身
    local cChairID_d = self:S2C(noti.cChairID)
	if (cChairID_d==0) then
		-- if(GameSession::GetInstancePtr()->is_slider_player())
		-- 	return ;
		-- self.ctrller.is_auto = false
		if (noti.cAuto == 1) then
			if self.is_auto_ == false then 
				self.view:showManageBtn()
			end
			--GetMe()->EnableOpt(false);
			self.is_auto_ = true ;
			self.data.players_[1].alarm_num = 0
			self.view:releaseSelectedCard()
		else
			self.view.gameLayer:removeChildByTag(2)
			self.is_auto_ = false ;
			--GetMe()->EnableOpt(true);
		end
	else
		self.data.players_[cChairID_d+1]:RefreshHeadIcontuo(noti.cAuto);
		-- players_[S2C(noti->cChairID)]->set_is_auto(noti->cAuto);
		-- players_[S2C(noti->cChairID)]->RefreshHeadIcon();
	end
end	
	
function GameSceneCtrller:pt_cg_auto_req_send(cAuto)
	-- echoError("pt_cg_auto_req_send");
	-- print("pt_cg_auto_req_send=="..cAuto)
	if self.is_robot == 0 then 
   		local message = {opcode='pt_cg_auto_req',cAuto=cAuto};
   		self.logic:sendGameSocket(message);
   -- NET_PACKET(pt_cg_auto_req)
-- {
-- 	char cAuto;				//1:托管，0:取消托管
-- };
	end
end

function GameSceneCtrller:pt_gc_auto_not_rec(event)
	local message = event.message;
	-- local cChairID = message.cChairID;  --//倍数
	-- local cAuto = message.cAuto; 
	self:OnAutoNot(message)

	-- char cChairID;			//托管玩家座位号
	-- char cAuto;				//1:托管，0:取消托管
end

--离开房间
function GameSceneCtrller:pt_bc_leave_table_ack_rec(event)
	local message = event.message;
	print("pt_bc_leave_table_ack_rec"..message.ret_);
	if (message.ret_==-2) then
		self.view:ShowGameTip("游戏中不能退出")
		--print ("leave_table error") --//-2 游戏中不能退出
		--self = nil;
	else  
		self.logic.moneyNotEnough = 2;
		local title = '您被踢出房间';
		local info = '您被踢出房间';
		-- local function cback() 
				    
		--     self.logic.gameSocket:close();
		--     izx.baseAudio:stopMusic()
		-- end
		self.data.players_[2]:ReInit();
   		self.data.players_[3]:ReInit();
		if (message.ret_==-3) then
			info = '您的游戏币不足';
			self.logic.moneyNotEnough = 1;
			self.logic:dispatchEventToCache({
				name = "moneyNotEnough",
		        message = {}
		        }
			);
		elseif (message.ret_==-4) then
			self.data.players_[2]:ReInit();
   			self.data.players_[3]:ReInit();
			-- info = '你长时间不举手,已自动离开房间';
		
			-- gBaseLogic:confirmBox({
	  --           msg=info,
	  --           btnTitle={btnConfirm="继续游戏",btnCancel="返回大厅"},
	  --       	callbackConfirm = function()
	  --       		print("self.logic.moneyNotEnoughcallbackConfirm")
		 --            if self.logic.gameSocket~=nil and self.logic.gameSocket.isConnect == 1 then
			--             self.logic.is_chang_table = 3
			            
			--             gBaseLogic.sceneManager:removePopUp("NewJieSuanLayer");
			--             gBaseLogic.sceneManager:removePopUp("AchievefinishLayer");
			--             gBaseLogic.sceneManager.currentPage.view:closePopBox();
			--             gBaseLogic.sceneManager.currentPage.ctrller:reInitAll()
			--             self.logic:onSocketJoinTable();
			--         else
			--             self.logic:LeaveGameScene(-1)
			--         end
		            
		 --        end,
			-- 	callbackCancel = function()
		 --            self.logic:LeaveGameScene(2)
		            
		 --        end})
			 
			-- gBaseLogic.lobbyLogic:showYouXiTanChu(initParam)
		elseif (message.ret_==-5) then
			info = '你被'..message.ply_nickname_..'玩家踢出房间';
			gBaseLogic:confirmBox({
	            msg=info,
	            btnTitle={btnConfirm="继续游戏",btnCancel="返回大厅"},
	        	callbackConfirm = function()
	        		print("self.logic.moneyNotEnoughcallbackConfirm")
		            if self.logic.gameSocket~=nil and self.logic.gameSocket.isConnect == 1 then
			            self.logic.is_chang_table = 3
			            
			            gBaseLogic.sceneManager:removePopUp("NewJieSuanLayer");
			            gBaseLogic.sceneManager:removePopUp("AchievefinishLayer");
			            gBaseLogic.sceneManager.currentPage.view:closePopBox();
			            gBaseLogic.sceneManager.currentPage.ctrller:reInitAll()
			            self.logic:onSocketJoinTable();
			        else
			            self.logic:LeaveGameScene(-1)
			        end
		            
		        end,
				callbackCancel = function()
		            self.logic:LeaveGameScene(2)
		            
		        end})
			 
		else
			self.logic:LeaveGameScene(2);
		end
		print("leave table!!222222")
	    
		
	    
	end
 
	--         char	ret_;				//-2 游戏中不能退出 -3游戏币不足被踢出房间 -4长时间不举手被踢出房间 -4你被ply_nickname_玩家踢出房间
	-- string	ply_nickname_;		//踢人玩家昵称
end
--准备
function GameSceneCtrller:pt_bc_ready_not_rec(event)
	local message = event.message 
	for i=1,3 do
		-- print (i);
		-- var_dump(self.data.players_[i]:getPlyData())
		if self.data.players_[i]:getPlyData() ~= nil then
			if (self.data.players_[i]:getPlyData().ply_guid_ == message.ply_guid_) then
				-- self.data.players_[i]:is_ready();
				print("===============pt_bc_ready_not_rec")
				self.data.players_[i]:ShowTips(12);
				gBaseLogic.audio:PlayAudio(21); --AUDIO_START
			end 
	    end
	end
end

function GameSceneCtrller:pt_bc_ply_leave_not_rec(event)
	local message = event.message
	for i=1,3 do
		if (self.data.players_[i]:getPlyData().ply_guid_ == message.ply_guid_) then
			
			self.data.players_[i]:PlayerLeave();
		end
	end
	local table_attr = self.data.other_ply_attrs_
	self.data.other_ply_attrs_ = {};
	for k,v in pairs(self.data.other_ply_attrs_) do
		if v.ply_guid_ ~= message.ply_guid_ then
			table.insert(self.data.other_ply_attrs_,v);
		end
	end
end
--比赛结束结果下发
function GameSceneCtrller:onMsgGameResult(event)
	local message = event.message
-- 	bShowCard 
-- bRobLord 
-- cDouble 
-- nBombCount 
-- cCallScore 
-- bSpring 
-- bType 
-- bReverseSpring 
	gBaseLogic.lobbyLogic.isMatch = 0;
	self.clientTimerPos = -1
	self.logic.result.bType = message.bType;  --//0:异常结束,1:地主赢,2:农民赢
	self.logic.result.cDouble = message.cDouble;  --//总倍数
	self.logic.result.cCallScore = message.cCallScore;  --//叫分倍数
	self.logic.result.bShowCard = message.bShowCard;  --//地主是否亮牌打的,1:亮牌
	self.logic.result.nBombCount = message.nBombCount;  --//炸弹个数
	self.logic.result.bSpring = message.bSpring;  --//是否春天,1:春天
	self.logic.result.bReverseSpring = message.bReverseSpring;  --//是否反春天,1:反春天
	self.logic.result.bRobLord = message.bRobLord;  --//抢地主倍数
	self.logic.result.cLord = self.data.cLord;
	self.logic.result.nGameMoney = self.data.nGameMoney;
	self.logic.result.vecUserResult = {};

	print("onMsgGameResult++++++++++++")
	-- var_dump(message,3)
	-- var_dump(message.vecUserResult)
	local useresult = message.vecUserResult1 

	for k,stuser in pairs(useresult) do
		-- local stuser = v
		local pPlayer = self:FindPlayerByChairID(stuser.nChairID)
		local pPlayerData = pPlayer:getPlyData();
		-- var_dump(pPlayerData)
		local is_lord = 0
		if stuser.nChairID == self.data.cLord then
			is_lord = 1;
		end
		if stuser.nScore > 0 then
			pPlayerData.won_ = pPlayerData.won_ + 1 
		else 
			pPlayerData.lost_ = pPlayerData.lost_ + 1 
		end
		-- if (self:FindPlayerByChairID(stuser.nChairID).ndir_==0) then
		-- 	self.logic.result.getMoney = stuser.nScore;
	 --    end
	 	local nPos = self:S2C(stuser.nChairID)
		local stUserResult = {nChairID=nPos,name=pPlayerData.nickname_,nScore=stuser.nScore,is_lord=is_lord,headimage=pPlayer.headimage_,sex_=pPlayerData.sex_,nJifen = stuser.nJifen} 
		--table.insert(self.logic.result.vecUserResult,stUserResult);
		self.logic.result.vecUserResult[nPos+1] = stUserResult
	end
	-- var_dump(self.logic.result.vecUserResult);
	
	self.view:OnGameResult(message)
	--self.logic:showJieSuan()

	-- for i=1,self.data.MAX_PLY_NUM do
	-- 	self.data.players_[i].Clock:setVisible(false)
	-- 	self.data.players_[i].alarm_num = 0
	-- end
	self:set_is_game_start(false);
	self.view:ManagementClick();
	if self.is_robot == 0 and self.logic.isMatch==0 then 
		if self.logic.hasreqbaoXiangRenWu == 0 then
			self.logic.roundTaskFinishNum = 0
		    self.logic:pt_cb_get_task_system_req()
		    self.logic:pt_cb_get_online_award_items_req()
		    self.logic:pt_cb_get_streak_task_req()
		end
		self.logic.hasreqbaoXiangRenWu = 1
	end

end

function GameSceneCtrller:pt_gc_complete_data_not_rec(event)
	print("GameSceneCtrller:pt_gc_complete_data_not_rec")
	self.logic.pt_gc_complete_data_message = nil
	local message = event.message;
	-- self.view:GameStart(message.nGameMoney);
	self.view.nDizhu:setString(message.nGameMoney);
	self.view.nDouble:setString(message.nDouble);
	self.data.cLordCard = message.vecLordCards;
	self.data.cLord = message.cLord 

	--图像显示
	local nPos = self:S2C(message.cLord);
	for i=1,3 do
		if (nPos+1==i) then
			self.data.players_[i]:RefreshHeadIcon(1);
		else
			self.data.players_[i]:RefreshHeadIcon(0);
		end
	end
 
	self.view:showLordCardNot()

	self:set_is_game_start(true);
	-- vecCards = 
	-- cChairID
	for k,v in pairs(message.vecData) do
		local playerCards = {
		cChairID = v.cChairID,
		vecCards = v.vecHandCards
		};

		self.view:OnRefreshCard(playerCards)
		local messagePut = {
			cChairID = v.cChairID,
			vecCards = v.vecPutCards
		}
		-- cType = 
		-- self:OnPlayCardNot(messagePut)
		local nPos = self:S2C(messagePut.cChairID);
    -- local cardsnum = 0;
    -- print(nPos);
    -- for k,v in pairs(noti.vecCards) do
    -- 	cardsnum = cardsnum + 1
    -- end
    	
		if (#messagePut.vecCards > 0) then
			self:GetMe().cards_.m_choose_cCards = messagePut.vecCards;
			self:GetMe().cards_:CheckChoosing(0);
    		local cType = self:GetMe().cards_.m_cDiscardingType;
		    self:GetMe():GetPlayCards().m_cDiscardingType = cType ;
		    self:set_discarding_type(cType)
		end

		if (nPos == 0) then
			self.view:HidenOpBtn();
			self.set_discarding_type({m_nTypeBomb= 0,m_nTypeNum= 0,m_nTypeValue = 0});
		end
		-- gBaseLogic.audio:PlayAudioType(messagePut.cType);
		self.data.players_[nPos+1]:OnPlayCardNot(messagePut);
	end
	for k,v in pairs(gBaseLogic.lobbyLogic.userData.ply_items_) do
        if (v.index_==2) then
        	self.noteCardsNum = v.num_
            break;
        end
    end
    self.view:initNoteCardsNum()
	-- int nGameMoney;								//本局游戏底分
	-- int nDouble;								//倍数
	-- char cLord;									//地主
	-- vector<CCard> vecLordCards;					//地主的3张牌
	-- vector<stUserData> vecData;					//玩家数据
-- 	NET_PACKET(stUserData)
-- {
-- 	char cChairID;
-- 	vector<CCard> vecHandCards;
-- 	vector<CCard> vecPutCards;
-- };
end
function GameSceneCtrller:pt_gc_task_not_rec(event)
	-- task_item_
-- 	NET_PACKET(TaskItem)
-- {
-- 	int		task_id_;
-- 	string	task_desc_;
-- 	string  task_mission_;
-- 	int		task_money_type_;	//奖励类型
-- 	int		task_money_;		//奖励数量
-- 	int		task_rate_;
-- };
	-- local task_desc = PluginProxy:getInstance():gb2utf8(event.message.task_item_.task_desc_);
	-- local param1 = split(task_desc,":");
	-- if #param1>1 then
	-- 	task_desc = param1[2];
	-- end
	event.message.task_item_.task_desc_ =  PluginProxy:getInstance():gb2utf8(event.message.task_item_.task_desc_);
	event.message.task_item_.task_mission_ = PluginProxy:getInstance():gb2utf8(event.message.task_item_.task_mission_);
	self.data.task_item_ = event.message.task_item_

	print ("task====================")
	var_dump(self.data.task_item_,4)
	self.view:initTaskContent();
	-- local taskInfo = self.data.task_item_
	-- if taskInfo.task_money_type_~=1 then
	-- 	self.logic.result.getMoney = tonumber(self.data.task_item_.task_money_)
	-- else
	-- 	self.logic.result.getGift = tonumber(self.data.task_item_.task_money_)
	-- end
	-- var_dump(self.data.task_item_)
end

function GameSceneCtrller:pt_gc_task_complete_not_rec(event)
	-- int			chair_id_;				//任务完成通知	
	-- char		task_status_;			//0：未完成  1：完成
	print("GameSceneCtrller:pt_gc_task_complete_not_rec")
	var_dump(event.message,4)
	if event.message.chair_id_ == self.data.self_ply_attrs_.chair_id_ then
		self.logic.result.task_status_ = event.message.task_status_
		if self.logic.result.task_status_==1 then
			print("GameSceneCtrller:pt_gc_task_complete_not_rec"..self.data.task_item_.task_money_)
			local taskInfo = self.data.task_item_
			if taskInfo.task_money_type_~=1 then
				self.logic.result.getMoney = tonumber(self.data.task_item_.task_money_)
			else
				self.logic.result.getGift = tonumber(self.data.task_item_.task_money_)
			end
			print("GameSceneCtrller:pt_gc_task_complete_not_rec"..self.data.task_item_.task_money_)
		end

	end
end

function GameSceneCtrller:pt_gc_card_count_ack_rec(event)
	print ("======pt_gc_card_count_ack_rec")
	self.useNoteCards = 1
	local resCardsTabel = {};
	for i=1,17 do
		if (i>15) then
			resCardsTabel[i] = 1 
		elseif (i>=3) then
			resCardsTabel[i] = 4;
		else
			resCardsTabel[i] = 0;
		end
		
	end	 
	for k,v in pairs(event.message.m_vecPutCard) do
		local num = v.m_nValue;
		if v.m_nValue== 16 and v.m_nColor==1 then
			num = 17;
		end
		if (resCardsTabel[num]~=nil and resCardsTabel[num]~=0) then
			resCardsTabel[num] = resCardsTabel[num] -1;
		end
	end
	print("===========resCardsTabel")
	self.view:replaceCardNote(resCardsTabel);
end
-- 
function GameSceneCtrller:pt_lc_trumpet_not_rec(event)
    self.view.labelGonggao:setString(event.message.message_)	
end
function GameSceneCtrller:pt_gc_card_count_ack1_rec(event)
	print ("======pt_gc_card_count_ack1_rec")
end

-- function GameSceneCtrller:pt_bc_get_online_award_ack_rec(event)
-- 	local message = event.message;
-- 	if message.ret_==0 then
-- 		self.view:ShowGameTip("成功领取奖励"..message.money_ .. "金币，已经进行游戏"..math.floor(message.remain_/60).."分钟")
-- 	elseif message.ret_==1 then
-- 		self.view:ShowGameTip("还剩".. math.floor(message.remain_/60) .."分钟可领取奖励"..message.money_ .. "金币")
-- 	elseif message.ret_==2 then
-- 		self.view:ShowGameTip("任务结束")
-- 	elseif message.ret_==4 then
-- 		if message.remain_==0 and message.money_==0 then
-- 			self.view:ShowGameTip("任务结束")
-- 		else
-- 			self.view:ShowGameTip("还剩".. message.remain_.."秒可领取奖励"..message.money_ .. "金币")
-- 		end
-- 	end
-- end

-- --         char	ret_;				//0成功领取奖励  1时间未到 2任务结束 4查询结果
-- 	-- int		remain_;			//剩余时间(ret=0已经进行的时间)
-- 	-- int		money_;				//可以获得的奖励 
-- function GameSceneCtrller:pt_bc_get_task_award_ack(event)
-- 	print("pt_bc_get_round_award_ack")
-- 	var_dump(event.message);
-- 	self.logic:showBaoXiangRenWu()
-- end

function GameSceneCtrller:pt_bc_update_ply_data_not_rec(event)
	local message = event.message;
	local Player = self:FindPlayerByPID(message.ply_guid_);
	if (Player) then
		if (message.upt_type_==0) then
			Player:changeMoney(message.amount_,message.upt_reason_)
		end

	end

	-- guid	ply_guid_;
	-- char	upt_reason_;
	-- char	upt_type_; 0
	-- int  	variant_;
	-- int64	amount_;
end

-- function GameSceneCtrller:pt_bc_below_admission_limit_tip_not(event)
-- 	print("GameSceneCtrller:pt_bc_below_admission_limit_tip_not")
-- 	local message = event.message;
-- 	gBaseLogic:onNeedMoney("gameenter",message.money_);
-- 	self.diBaoMsg = message.message_
-- end
function GameSceneCtrller:dibaoMsgTip(event)
	print("GameSceneCtrller:dibaoMsgTip")
	if self.logic.diBaoMsg~="" then
		self:ShowGameTip(self.logic.diBaoMsg)
        -- local initParam = {msg=self.logic.diBaoMsg,type=1000};
        -- gBaseLogic.lobbyLogic:showYouXiTanChu(initParam) 
		self.logic.diBaoMsg = "";
	end
	-- self.logic.diBaoMsg = "";
end
function GameSceneCtrller:pt_gc_counts_not1(event)
	local message = event.message;
	print("GameSceneCtrller:pt_gc_counts_not1")
	if self.view.hasAddGame2 == 0 then 
		self.view:initBaseInfo2()
	end
	self.noteCardsNum = message.counts_num_
	self.data.self_ply_attrs_ = self.logic.userData.ply_base_data_;
    for k,v in pairs(gBaseLogic.lobbyLogic.userData.ply_items_) do
        if (v.index_==2) then
        	gBaseLogic.lobbyLogic.userData.ply_items_[k].num_ = message.counts_num_
            break;
        end
    end
    self.view:initNoteCardsNum()
	var_dump(message,4)
end
function GameSceneCtrller:pt_gc_counts_not(event)
	local message = event.message;
	print("GameSceneCtrller:pt_gc_counts_not")
	var_dump(message,4)
end

function GameSceneCtrller:RefreshTaskNum()
	print("GameSceneCtrller:RefreshTaskNum")
	gBaseLogic.scheduler.performWithDelayGlobal(function()
		self.view:initRoundTasknum();
		end, 1)
	
	self.logic.roundTaskNum = 1;
end

function GameSceneCtrller:msgEnterForeground(event)
	print("GameSceneCtrller:msgEnterForeground"..self.clientTimerPos)
	var_dump(self.data.players_);
	var_dump(event.message,4)
	if self.clientTimerPos~=-1 then
		if (self.data.players_[self.clientTimerPos+1]~=nil) then
			local message = event.message;
			local restime = 0
			if message.restime~=nil then
				restime = message.restime
			else
				restime = gBaseLogic.onbackGroundtime
			end
			print(restime .."aaaaa"..self.data.players_[self.clientTimerPos+1].alarm_num)
			-- if self.data.players_[self.clientTimerPos+1].alarm_num<restime*1000 then
			-- 	self.data.players_[self.clientTimerPos+1].alarm_num = 0;
			-- else
			-- 	self.data.players_[self.clientTimerPos+1].alarm_num =self.data.players_[self.clientTimerPos+1].alarm_num-restime*1000
			-- end
			self.data.players_[self.clientTimerPos+1]:resAlarmNum(restime)
			-- print("aaaaa"..self.data.players_[self.clientTimerPos+1].alarm_num)
		end
	end
end
function GameSceneCtrller:changChongzhijiangli(event)
	print("GameSceneCtrller:changChongzhijiangli")
    self.view:changeChongzhijiangliButton();
    local Player = self:FindPlayerByPID(self.data.self_ply_attrs_.ply_guid_);
	if nil ~= Player then
		print("changeChongzhijiangliButton=="..gBaseLogic.lobbyLogic.userData.ply_lobby_data_.money_);
		Player:changeMoney(gBaseLogic.lobbyLogic.userData.ply_lobby_data_.money_)
	end
    
end

function GameSceneCtrller:pt_bc_item_update_not(event)
    local message = event.message
    
    for k,v in pairs(gBaseLogic.lobbyLogic.userData.ply_items_) do
    	if message.index_==v.index_ then
    		gBaseLogic.lobbyLogic.userData.ply_items_[k].num_=message.num_
    		break;
    	end
    end

end
function GameSceneCtrller:pt_bc_get_achieve_award_not(event)
	print("pt_bc_get_achieve_award_not==")
	local message = event.message;
	-- self.logic:showAchievefinishContent(message);
	var_dump(message)
	self.logic.achieve_award_not = message
end
function GameSceneCtrller:pt_bc_get_daily_task_award_not(event)
	print("pt_bc_get_daily_task_award_not==")
	local message = event.message;
	-- self.logic:showAchievefinishContent(message);
	var_dump(message)
	self.logic.daily_task_award_not = message
end
function GameSceneCtrller:pt_bc_successive_victory_not(event)
	local message = event.message;
	-- self.logic:showAchievefinishContent(message);
	var_dump(message)
	print("pt_bc_successive_victory_not")
	self.logic.gameWinround = message.count_;
	-- if message.count_==1 or message.count_==3 or message.count_==5 then
	-- 	self.logic.daily_task_award_not = message
	-- else
	-- 	self.logic.daily_task_award_not = nil
	-- end
end
function GameSceneCtrller:pt_bc_get_daily_task_award_ack(event)
	local award = event.message;
	print("pt_bc_get_daily_task_award_ack==")
	var_dump(event)
	if (award~=nil)then
		if(award.ret_ == 0) then
			local data = "";
			
			if(award.money_ > 0) then
				data = "游戏币:"..award.money_.."\n";
			end
			--礼物
			if(award.gift_ > 0) then
				data = data.."元宝:"..award.gift_.."\n";
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

			
			data = "恭喜您获得如下礼品:\n"..data;
			izxMessageBox(data,"提示");
			
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
function GameSceneCtrller:pt_bc_rematch_notf(event)
	print("GameSceneCtrller:pt_bc_rematch_notf")
	local message = event.message;
	var_dump(message)
-- 	int match_id_;      // 
-- ||     NET_GET                | 834     int match_order_id_;    //
-- ||     NET_PUT                | 835     int param_;     //
-- ||     NET_GET                | 836     int current_score_;
-- ||     NET_PUT                | 837     int round_index_;
-- ||     NET_GET                | 838     int totoal_round_;
-- 	  int current_score_;
-- ||     NET_PUT                | 837     int round_index_;
	self.view.nodetask:setVisible(true);
	-- self.view.labelTaskContent:setString(message.param_);
    -- self.view.labelTaskAward:setString("第"..( message.round_index_+1).."轮")
	gBaseLogic.lobbyLogic.match_current_score = message.current_score_;
	-- local round_index_ = message.round_index_
	self.view.lableUsericonmoney:setString(gBaseLogic.lobbyLogic.match_current_score);

 
	gBaseLogic.gameLogic.curMatchID = message.match_id_;
	gBaseLogic.gameLogic.curMatchOrderID = message.match_order_id_;
	gBaseLogic.gameLogic.curMatchScore = message.current_score_;
	gBaseLogic.gameLogic.curMatchRound = message.round_index_;
	gBaseLogic.gameLogic.curMatchTRound = message.totoal_round_;
end
return GameSceneCtrller;
