local GameLogic = class("GameLogic",izx.baseGameLogic);

-- 游戏部分
GameLogic.MSG_Socket_JoinTable = "MSG_Socket_JoinTable";--进房间
GameLogic.MSG_Socket_CreateTable = "MSG_Socket_CreateTable";--创建房间
GameLogic.MSG_Socket_GetTableList = "MSG_Socket_GetTableList";--房间列表
GameLogic.MSG_Socket_TableReady = "MSG_Socket_TableReady";--准备
GameLogic.MSG_Socket_LeaveTable = "MSG_Socket_LeaveTable";-- 自己离开房间


GameLogic.MSG_Socket_GiveGift = "MSG_Socket_GiveGift";--赠送
GameLogic.MSG_Socket_GiveGiftNot = "MSG_Socket_GiveGiftNot";
GameLogic.MSG_Socket_RefreshCard = "MSG_Socket_RefreshCard";
GameLogic.MSG_Socket_GameStart = "MSG_Socket_GameStart";
GameLogic.MSG_Socket_OtherJoinTable = "MSG_Socket_OtherJoinTable"
GameLogic.MSG_Socket_CallScore = "MSG_Socket_CallScore" --叫分
GameLogic.MSG_Socket_robLord = "MSG_Socket_robLord" --抢地主
GameLogic.MSG_Socket_LordCard = "MSG_Socket_LordCard" --地主牌
GameLogic.MSG_Socket_PlayCard = "MSG_Socket_PlayCard" --通知玩家出牌
GameLogic.MSG_Socket_PlayCardNot = "MSG_Socket_PlayCardNot";--玩家出牌信息广播
GameLogic.MSG_Socket_BombNot = "MSG_Socket_BombNot";--炸弹倍数
GameLogic.MSG_Socket_CommonNot = "MSG_Socket_CommonNot" --通用通知（叫分）
GameLogic.MSG_Socket_ClienttimerNot = "MSG_Socket_ClienttimerNot" --定时器



function GameLogic:ctor()
	self.isMatch = 0 --比赛状态 0 普通，1比赛
	self.playInTable = 0;--用户是否在房间
	self.inGamepage = 0;
	self.curSocketConfigList = nil;
	self.userData = {};
	self.guangBaoList = {}	
	self.tablePlayerAttr = nil;
	self.pt_gc_complete_data_message = nil
	-- self.taskData = {};
	self.inGamepage = 0;
	self.is_chang_table = 0;
	self.hasBaoValue = 0 ;
	self.needMoney = 0;
	self.eventCache = {};
	self.isErrorJoin = 0;--errorjoin
	self.roundTaskFinishNum = 0;--完成宝箱任务个数
	self.roundTaskNum = 1;--计时器自增 没60秒刷新一次在线奖励任务
	self.diBaoMsg = "" --
	self.dibaomoneyNotEnough = 0 --是否有低保
	self.moneyNotEnough = 0 --钱不够
	self.reconnect = 0; --是否断线重连
	self.lostMoneyLimit = 0; --是否达到输赢限制
	self.result = {bType=1,cDouble=16,cCallScore=4,bShowCard=1,nBombCount=1,bSpring=0,bReverseSpring=0,bRobLord=2,cLord=1,nGameMoney=2,getGift=0,getMoney=0,task_status_=0,vecUserResult={{nChairID=0,name='xiaohui1',nScore=12},{nChairID=1,name='xiaohui2',nScore=4},{nChairID=2,name='xiaohui3',nScore=3}}}
-- self.baoXiangRenWu.roundItems = message.round_items_
-- 		self:pt_cb_get_task_award_req(0)
-- 	else
-- 		self.baoXiangRenWu.giftStat = self.baoXiangRenWu.giftStat+1;
	self.hasreqbaoXiangRenWu = 0;
	self.baoXiangRenWu = {
		giftStat=0,
		hasGetOnlineItems = 0,
		hasGetRoundItems = 0,
		roundItemFinish = 0,
		onlineitemfinish = 0,
		streaktaskFinish = 0,
		roundItems = {},
		onlineItems = {},
		onlineInfo = {},
		roundInfo = {},
		streaktaskinfo={};

	}

	self.LotteryDraw = {curTimes = 0, MaxTimes = -1, curGames = 0, reqGames = -1, needHistory = true, history= {}};
	self.ITEM_TRUMPET = 1
    self.ITEM_EXPRESSION_PARCEL = 5
	require("framework.api.EventProtocol").extend(self)
	require("moduleDdz.logics.PicConfig");
	require("moduleDdz.logics.AudioConfig");
	gBaseLogic.audio = require("moduleDdz.logics.Audio").new();    
end

function GameLogic:onGameExit()
	if self.gameSocket ~= nil then
		self.gameSocket:close();
	end
	izx.baseAudio:stopMusic()
    -- izx.baseAudio:stopMusic()
    izx.baseAudio:stopAllSounds()
	-- izx.resourceManager:removeSearchPath("res/moduleDDZRes/")
end

function GameLogic:startGamesocket()
	local SocketConfigList = self.curSocketConfigList	
	
	self:dispatchLogicEvent({
        name = "MSG_MAINGAME_LOADING",
        message = {msg="正在登录游戏服务器"
    	}
    });    
	if SocketConfigList.isLaiZi~=nil then
		self:setIsLaiZi(SocketConfigList.isLaiZi)
	end
	if SocketConfigList.needMoney~=nil then
		self:setNeedMoney(SocketConfigList.needMoney)
	end
	if SocketConfigList.isErrjoin~=nil and SocketConfigList.isErrjoin==1 then
		print("gBaseLogic.gameLogic:setIsErrJoin")
		self:setIsErrJoin(1);
	end
	self:startSocket(SocketConfigList.SocketConfig);
end

function GameLogic:startSocket(ddzSocketConfig)
	self.gameSocket = nil;
	self.gameSocket = require("izxFW.SocketWrapper").new(self,
		gBaseLogic.socketConfig.socketType,
		ddzSocketConfig,
		'ddz');
	require("moduleDdz.logics.packetDefine");
	self.gameSocket:connect();
	-- local scene = display.getRunningScene();
	-- gBaseLogic:blockUI()
end

function GameLogic:onConnectFailure()
	gBaseLogic:unblockUI();
	print("GameLogic:onConnectFailure")
	if (izx.resourceManager:getNetState() == false) then
		print("sdasdsss")
		gBaseLogic.lobbyLogic:reShowLoginScene();
		return;
	else
		gBaseLogic.lobbyLogic:dispatchEventToCache({
			name = "MSG_GAME_SOCKET_ERR",
	        message = {title="连接失败",info="服务器连接出错"}
	        }
		);
	
		gBaseLogic.lobbyLogic:goBackToMain(true);
	end	
end
function GameLogic:onSocketClose()
	if (izx.resourceManager.netState == false) then
		self.is_chang_table = 0;
		self.gamePage = nil
		gBaseLogic.lobbyLogic:reShowLoginScene();
		return;
	else
		print("GameLogic:onSocketClose"..gBaseLogic.lobbyLogic.otherplayin)
		if gBaseLogic.lobbyLogic.otherplayin==0 then

			gBaseLogic.lobbyLogic:dispatchEventToCache({
				name = "MSG_GAME_SOCKET_ERR",
		        message = {title="连接失败",info="服务器连接出错"}
		        }
			);
			self.is_chang_table = 0;
			self.gamePage = nil
			gBaseLogic.lobbyLogic:goBackToMain(true);
		end
	end
end

function GameLogic:onSocketMessage(message)
	print ("收到消息" .. message.opcode);
	if (self[message.opcode .. "_handler"]~=nil) then
		self[message.opcode .. "_handler"](self,message);
		return;
	else
		echoInfo("直接抛出消息，不管了[%s]",message.opcode)
		
		self:dispatchLogicEvent({
	        name = "MSG_SOCK_"..message.opcode,
	        message = message
	    })
	end
end
function GameLogic:pt_bc_award_type_not_handler(message)
	print("GameLogic:pt_bc_award_type_not_handler")
	var_dump(message);
end
function GameLogic:pt_bc_message_not_handler(message)
	print("GameLogic:pt_bc_message_not_handler")
	var_dump(message)
	if (message.type_==1) then
		gBaseLogic.lobbyLogic.otherplayin = 1
		gBaseLogic.lobbyLogic:onKickNet("您的帐号已在其他地方登录");
	elseif (message.type_==0) then
		-- izxMessageBox(message.message_,"服务器消息");
		
		self.diBaoMsg = message.message_
		self.dibaomoneyNotEnough = 1;
		-- self:showdibaomsg();
		-- gBaseLogic:confirmBox({
		--         msg=message.message_,
		--         btnTitle={btnConfirm="确定",btnCancel="充值"},
		--         callbackCancel = function()
		--             print("self.logic.moneyNotEnoughcallbackConfirm")
		--             local money = self.curSocketConfigList.min_money_;
		            
		--             gBaseLogic:onNeedMoney("gameenter", money, 4)
		            
		--         end,
		--         callbackConfirm = function()
		            
		            
		--         end})
	end
		
end 

function GameLogic:pt_bc_player_join_match_ack_handler(message)
	print("GameLogic:pt_bc_player_join_match_ack_handler",message.ret_ )
	if message.ret_ == 0 then 
		self:onSocketJoinTable();
	else 
		local info = '比赛服务器连接出错'
		local title = '进入比赛房间出错'
		if message.ret_==-2 then
			info = "您已经被轮空，请耐心等待下一轮开始！"
		end
		gBaseLogic.lobbyLogic:dispatchEventToCache({
				name = "MSG_GAME_SOCKET_ERR",
		        message = {title=title,info=info}
		        }
			);
		self:LeaveGameScene(-1);
	end
end 

function GameLogic:pt_bc_login_ack_handler(message)
	
	if self.loginTimeTickScheduler then 
        scheduler.unscheduleGlobal(self.loginTimeTickScheduler) 
    end

	print("GameLogic:pt_bc_login_ack_handler")
	gBaseLogic:logEventLabelDuration("gameTime","login",1)
	self.userData.ply_base_data_ = message.ply_base_data_;
	-- print("=============ply_base_data_1");
	var_dump(self.userData.ply_base_data_ )
	self.userData.ply_status_ = message.ply_status_;
	 print("GameLogic:pt_bc_login_ack_handler==="..message.ret_ ..self.isErrorJoin) 
	 -- //0成功 -1服务器忙 -2玩家在其它服务器还有未结束的游戏,请客户端根据ply_status_重连原服务器 -3验证失败 -4游戏币不足 1进入比赛场(未报名) 2进行比赛场(已经报名)
    if message.ret_ == 0 or message.ret_ == 1 or message.ret_ == 2 then --字符0还是数字
    	if (message.ret_ == 0 and self.isErrorJoin==0) then   
    		print(1111112) 
    		if self.isMatch == 1 then 
    			self:onSocketJoinMatch()
    		else		
	    		self:onSocketJoinTable();
	    	end

	    end
	    print(2222223)
	    self.isErrorJoin = 0;
	    
	    -- self:dispatchLogicEvent({
	    --     name = "MSG_SOCK_pt_bc_login_ack",
	    --     message = message
	    -- })
	    

	else
		if (message.ret_==-2) then
			self.gameSocket:close();
			print("-2玩家在其它服务器还有未结束的游戏,isMatch:",self.isMatch)
			if self.isMatch == 1 then 
				gBaseLogic.lobbyLogic:reEnterMatchGame(message.ply_status_.game_id_,message.ply_status_.game_server_id_)
			else
				gBaseLogic.lobbyLogic:reEnterGame(message.ply_status_.game_id_,message.ply_status_.game_server_id_ )
			end
		else
		-- self:onSocketJoinTable();
		-- local loginMsg = {opcode = 'pt_cg_complete_data_req'};
	
		-- self:sendGameSocket(loginMsg);
			self.gameSocket:close();
			local info = '服务器连接出错';
			local title = '进入房间出错';
			local rst = message.ret_
			if (rst==-1) then
				info = "服务器忙"
			elseif rst==-3 then
				info = "验证失败"
			elseif rst==-4 then
				info = "游戏币不足"			
			end
			gBaseLogic.lobbyLogic:dispatchEventToCache({
				name = "MSG_GAME_SOCKET_ERR",
		        message = {title=title,info=info}
		        }
			);
			self:LeaveGameScene(-1);
		
		end
		print("GameLogic:pt_bc_login_ack_handler" ..message.ret_ )
	end
end

function GameLogic:addLogicEvent(eventName,handler,target)
	target.handlerPool = target.handlerPool or {};
	target.handlerPool[eventName] = self:addEventListener(eventName,handler);
end

function GameLogic:showdibaomsg()
	print("GameLogic:showdibaomsg")
	print(self.dibaomoneyNotEnough)
	print(self.diBaoMsg)
	if self.dibaomoneyNotEnough==1 then
		if self.diBaoMsg ~= "" then
			gBaseLogic:confirmBox({
		        msg=self.diBaoMsg,
		        btnTitle={btnConfirm="确定",btnCancel="充值"},
		        callbackCancel = function()
		            print("self.logic.moneyNotEnoughcallbackConfirm")
		            local money = self.curSocketConfigList.min_money_;
		            
		            gBaseLogic:onNeedMoney("gameenter", money, 4)
		            
		        end,
		        callbackConfirm = function()
		            
		            
		        end})
		end
		
	end
	self.dibaomoneyNotEnough=0
	-- self.moneyNotEnough = 0
end 

function GameLogic:pt_bc_player_join_match_ack_handler(message)
	print("pt_bc_player_join_match_ack_handler",message.ret_)
	gBaseLogic:unblockUI();
	if message.ret_==0 then
		self:onSocketJoinTable()
		--self:showGameScene()
	end
end 
function GameLogic:pt_bc_rematch_notf_handler(message)
	self.curMatchID = message.match_id_;
	self.curMatchOrderID = message.match_order_id_;
	self.curMatchScore = message.current_score_;
	self.curMatchRound = message.round_index_;
	self.curMatchTRound = message.totoal_round_;
	gBaseLogic.lobbyLogic.match_current_score = message.current_score_;
	self.matchName = message.param_
	self:dispatchLogicEvent({
		        name = "MSG_SOCK_pt_bc_rematch_notf",
		        message = message        

		    })
end 

function GameLogic:pt_bc_join_table_ack_handler(message)
	print ("=========================pt_bc_join_table_ack_handler"..self.is_chang_table .. "message.ret_:"..message.ret_);
	print(self.moneyNotEnough)
	print(self.diBaoMsg)
	gBaseLogic:unblockUI();
	if ( message.ret_==0 ) then
		self.playInTable = 1;
		if self.is_chang_table==0 and self.inGamepage == 0 then
			self:showGameScene();
			
		else
			if self.is_chang_table==2 then
				--gBaseLogic.sceneManager.currentPage.ctrller:run()
			end
			if self.reconnect==1 then
				-- gBaseLogic.sceneManager.currentPage.view:onPressManagement()
				self.reconnect = 0;
			end
			
		end
		
		
		self:dispatchLogicEvent({
		        name = GameLogic.MSG_Socket_JoinTable,
		        message = message        

		    })
		-- self.baoXiangRenWu.giftStat = 10000
		
		
	else 
		self.gameSocket:close();
		local info = '服务器连接出错';
		local title = '进入房间出错';
		local rst = message.ret_
		if (rst==-2) then
			info = "服务器满"
		elseif rst==-3 then
			info = "游戏币不足"
		elseif rst==-4 then
			info = "加入密码错误"
		elseif rst==-5 then
			info = "房间满"
		elseif rst==-6 then
			info = "比赛场需要先报名"
		elseif rst==-7 then
			info = "比赛场比赛时间未到或结束"
		elseif rst==-8 then
			info = "比赛局数已经完成"
		elseif rst==-9 then
			info = "Vip才允许进入私人房间"
		elseif rst==-10 then
			local need_money_ = self.curSocketConfigList.max_money_
			info = "温馨提示，您的游戏币大于".. need_money_ .."万，请进入高分场游戏"
		elseif rst==-11 then
			info = "今天已经输了400万游戏币咯！休息，休息一下，明天再来！"
		end
		gBaseLogic.lobbyLogic:dispatchEventToCache({
			name = "MSG_GAME_SOCKET_NOLOGIN",
	        message = {title=title,info=info}
	        }
		);
		self:LeaveGameScene(-1);
	end
end
function GameLogic:pt_bc_common_message_not_handler(message)
	print("pt_bc_common_message_not_handler")
	var_dump(message)
	if message.type_==-99 then
		self.lostMoneyLimit = 1
		-- local info = "今天已经输了400万游戏币咯！休息，休息一下，明天再来！"
		-- -- gBaseLogic:confirmBox(initParam)
		--  gBaseLogic:confirmBox({
  --           msg=info,
  --           buttonCount=1,
  --   		callbackConfirm = function()
	 --            self.logic:LeaveGameScene(-1)
	            
	 --        end})
	end
end
--异常进入
function GameLogic:pt_gc_complete_data_not_handler(message)
	-- if (self.gamePage~=nil) then
	-- 	print("pt_gc_complete_data_not_handler1")
	-- 	self:dispatchLogicEvent({
	--         name = "MSG_SOCK_pt_gc_complete_data_not",
	--         message = message 
	--     })
	-- else
		print("pt_gc_complete_data_not_handler2")
		-- self.pt_gc_complete_data_message = message;
		self:dispatchLogicEvent({
	        name = "MSG_SOCK_pt_gc_complete_data_not",
	        message = message 
	    })
	    if self.isMatch==0 then
		    if self.hasreqbaoXiangRenWu == 0 then
				self.roundTaskFinishNum = 0
			    self:pt_cb_get_task_system_req()
			    self:pt_cb_get_online_award_items_req()
			    self:pt_cb_get_streak_task_req()
			end
			self.hasreqbaoXiangRenWu = 1
		end
	-- end
end
function GameLogic:pt_bc_create_table_ack_handler(message)--创建房间
	self.playInTable = 1;
		self:dispatchLogicEvent({
	        name = GameLogic.MSG_Socket_CreateTable,
	        message = message
	        -- tableattr
	--         int		table_id_;
	-- string	name_;				//房间名称
	-- char	lock_;				//1需要密码 0不需要密码
	-- vector<PlyBaseData>	players_;
	        -- message.ret_;	//-2服务器满 -3游戏币不足 -4低于10W不能建房间 
	        -- message.tableattr 房间所有玩家信息

	    })
end
function GameLogic:pt_bc_leave_table_ack_handler(message)--离开房间
		--
		self.playInTable = 0;
		self:dispatchLogicEvent({
	        name = GameLogic.MSG_Socket_LeaveTable,
	        message = message	        

	    })
	    -- self:onSocketJoinTable();
end
function GameLogic:pt_bc_get_table_list_ack_handler(message)--房间列表
		self:dispatchLogicEvent({
	        name = GameLogic.MSG_Socket_GetTableList,
	        message = message	    

	    })	
end
function GameLogic:pt_bc_ready_not_handler(message)--准备
		self:dispatchLogicEvent({
	        name = GameLogic.MSG_Socket_TableReady,
	        message = message	    

	    })	   
end
-- function GameLogic:pt_bc_ready_ack_handler(message)--准备
-- 		self:dispatchLogicEvent({
-- 	        name = GameLogic.MSG_Socket_TableReady,
-- 	        message = message	    

-- 	    })	   
-- end
-- function GameLogic:pt_bc_get_online_award_ack_handler(message)--在线礼包
-- 		self:dispatchLogicEvent({
-- 	        name = GameLogic.MSG_Socket_GetOnlieAward,
-- 	        message = message	   
-- 	--         char	ret_;				//0成功领取奖励  1时间未到 2任务结束 4查询结果
-- 	-- int		remain_;			//剩余时间(ret=0已经进行的时间)
-- 	-- int		money_;				//可以获得的奖励 

-- 	    })	  
-- end
function GameLogic:pt_bc_give_gift_ack_handler(message)--赠送
		self:dispatchLogicEvent({
	        name = GameLogic.MSG_Socket_GiveGift,
	        message = message	   
	-- char	ret_;				//0成功 -2玩家已经离开 -3赠送数量越出限制 -4游戏币已经锁定 -5等待开始状态才可以赠送 -6低于10W不能赠送
	-- int		balance_;			//自己的余额

	    })	
end
function GameLogic:pt_bc_give_gift_not_handler(message)--赠送
		self:dispatchLogicEvent({
	        name = GameLogic.MSG_Socket_GiveGiftNot,
	        message = message	   
	-- guid	src_ply_guid_;
	-- guid	dst_ply_guid_;
	-- int		amount_;

	    })	
end
function GameLogic:pt_gc_refresh_card_not_handler(message)--发牌
		-- var_dump(message,3);
		self:dispatchLogicEvent({
	        name = GameLogic.MSG_Socket_RefreshCard,
	        message = message
	    })	
end
function GameLogic:pt_gc_game_start_not_handler(message)--开始游戏
	-- 	int nGameMoney;		
	-- int nCardNum;		//牌的数量
	-- int nLordPos;		//地主牌的位置
	-- CCard cLordCard;	//地主牌 
	-- int nSerialID;		
		-- var_dump(message,3);
		-- self.userData.nSerialID  = message.nSerialID;--消息序列
		-- self.userData.nGameMoney = message.nGameMoney;--底注
		-- self.userData.nCardNum = message.nCardNum;--牌的数量
		-- self.userData.cLordCard = message.cLordCard;--地主牌 
		self:dispatchLogicEvent({
	        name = GameLogic.MSG_Socket_GameStart,
	        message = message
	    })
	    self.hasreqbaoXiangRenWu = 0
	    -- self.roundTaskFinishNum = 0
	    -- self:pt_cb_get_task_system_req()
	    -- self:pt_cb_get_online_award_items_req()
	    -- self:pt_cb_get_streak_task_req()
	    self.achieve_award_not = nil;
	    self.daily_task_award_not = nil;
	    self.gameWinround = 0

end
function GameLogic:pt_gc_call_score_req_handler(message)--开始叫分
		print ("GameLogic:pt_gc_call_score_req_handler");
		self:dispatchLogicEvent({
	        name = GameLogic.MSG_Socket_CallScore,
	        message = message
	    })
-- 	    NET_PACKET(pt_cg_call_score_ack)
-- {
-- 	int nScore;			//0:不叫,1:1分,2:2分,3:3分
-- 	int nSerialID;		//消息序列
-- };
end
function GameLogic:pt_gc_rob_lord_req_handler(message)--通知抢地主
	self:dispatchLogicEvent({
        name = GameLogic.MSG_Socket_robLord,
        message = message
    })
end

function GameLogic:pt_bc_ply_join_not_handler(message)--收到他人加入游戏状态
	
		self:dispatchLogicEvent({
	        name = GameLogic.MSG_Socket_OtherJoinTable,
	        message = message
	    })	

-- NET_PACKET(PlyBaseData)
-- {
-- 	guid		ply_guid_;
-- 	string		nickname_;
-- 	int			sex_;			//0男 1女
-- 	int			gift_;
-- 	int64		money_;
-- 	int			score_;
-- 	int			won_;
-- 	int			lost_;
-- 	int			dogfall_;
-- 	int			table_id_;	
-- 	int			param_1_;		//扩展属性1 用于保存用于注册时间
-- 	int			param_2_;		//扩展属性2
-- 	char		chair_id_;		//table_id_ != -1 && chair_id_ == -1为旁观状态
-- 	char		ready_;			//1已经举手, 0没有举手
-- 	VipData		ply_vip_;		//vip数据
-- };
end
function GameLogic:pt_gc_lord_card_not_handler(message)--显示地主地主牌
		 
		self:dispatchLogicEvent({
	        name = GameLogic.MSG_Socket_LordCard,
	        message = message
	    })	
end
function GameLogic:pt_gc_play_card_req_handler(message)--通知玩家出牌	
		self:dispatchLogicEvent({
	        name = GameLogic.MSG_Socket_PlayCard,
	        message = message
	    })	
end
function GameLogic:pt_gc_play_card_not_handler(message)--玩家出牌通知	
		self:dispatchLogicEvent({
	        name = GameLogic.MSG_Socket_PlayCardNot,
	        message = message
	    })
end
function GameLogic:pt_gc_bomb_not_handler(message)--倍数	
		self:dispatchLogicEvent({
	        name = GameLogic.MSG_Socket_BombNot,
	        message = message
	    })		
end
function GameLogic:pt_gc_common_not_handler(message)--底注倍数	 
		self:dispatchLogicEvent({
	        name = GameLogic.MSG_Socket_CommonNot,
	        message = message
	        -- 		NET_PACKET(pt_gc_common_not)
				-- {
				-- 	int nOp;							//消息类型
				-- 	char cChairID;						//玩家坐位号
				-- };
	    })	
end

-- 计时器
function GameLogic:pt_gc_clienttimer_not_handler(message)--倍数	
		self:dispatchLogicEvent({
	        name = GameLogic.MSG_Socket_ClienttimerNot,
	        message = message
	    })		
end

function GameLogic:showGameScene()
	print("++++++++++++++++++GameLogic:showGameScene=============") 
	-- gBaseLogic.lobbyLogic:removePage("lobbyScene",false);
	-- gBaseLogic.lobbyLogic:removePage("loginScene",false);
	-- gBaseLogic.lobbyLogic:removePage("GameScene",false);
	self.inGamepage = 1;
	self.gamePage = izx.basePage.new(self,"GameScene","moduleDdz",{
			pageType = izx.basePage.PAGE_TYP_CCB,
			ccbFileName = "interfaces/YouXi.ccbi",
			ccbController = "gameControll",
			slideIn = "left"
		}
	);
	self.inGamepage = 1;
	self.gamePage:enterScene();
	-- gBaseLogic.gameLogic.gamePage = self.gamePage
	gBaseLogic:logEventLabelDuration("gameTime","ready",0)
end

function GameLogic:LeaveGameScene(num)
	-- echoError("111");
	print("GameLogic:LeaveGameScene")
	if (self.gamePage ~= nil) then
		self.is_chang_table = 0;
		self.gamePage = nil
	end
	print(num)
	if (gBaseLogic.currentState == gBaseLogic.stateInRealGame) then
		gBaseLogic.lobbyLogic:goBackToMain(true)	
		-- if ()
		print("GameLogic:LeaveGameScene11")
		if (num~=-1) then 
			--gBaseLogic.lobbyLogic.userData.ply_lobby_data_.param_2_ = 8 -- for test
			local puid = gBaseLogic.lobbyLogic.userData.ply_guid_;
			if gBaseLogic.lobbyLogic.userData.ply_lobby_data_.param_2_ >= 8 then 

				
				if (CCUserDefault:sharedUserDefault():getStringForKey("Xin"..puid .."_4")~=tostring(os.date("%x", os.time()))) then 
					gBaseLogic.lobbyLogic.showXinShouTiShi = 4; 					
					return
				end
			end
			local restMoney = gBaseLogic.lobbyLogic.userData.ply_lobby_data_.money_;
			local typNum = 1;
			if restMoney >= 150000 then
				typNum = 2
			elseif restMoney>=80000 then
				typNum = 3			
			end
			if CCUserDefault:sharedUserDefault():getStringForKey("Xin"..puid .."_"..typNum)==tostring(os.date("%x", os.time())) then
				print("doherr")
				typNum = 1;
			end
			gBaseLogic.lobbyLogic.showXinShouTiShi = typNum;
			print(
					gBaseLogic.lobbyLogic.showXinShouTiShi)
		end
		print("gBaseLogic.lobbyLogic.showXinShouTiShi")
		-- gBaseLogic.lobbyLogic:showXinShouTiShiLayer(num)
	elseif (gBaseLogic.currentState == gBaseLogic.stateInSingleGame) then print("GameLogic:LeaveGameScene1122")
	-- 	self.userData = nil;
	-- self.userData = {};
	-- self.userHasLogined = false

		if gBaseLogic.lobbyLogic.userHasLogined==true and gBaseLogic.lobbyLogic.userData~=nil then
			gBaseLogic.lobbyLogic.gametoback = 1;
			gBaseLogic.lobbyLogic:showLoginScene()
		else
			gBaseLogic.lobbyLogic:reShowLoginScene(false)
		end
	end
	 
end


function GameLogic:showSetupLayer()
	self.SetupLayer = izx.basePage.new(self,"SetupLayer","moduleLobby",{
			pageType = izx.basePage.PAGE_TYP_CCB,
			ccbFileName = "interfaces/SheZhi.ccbi",
			ccbController = "sheZhicontroll"
		}
	);
	self.SetupLayer:addToScene({block=false,isBlockTouch=true,clickMaskToClose=true,slideIn="bottom"});
end

function GameLogic:showInformation(player)
	if self.isMatch==1 then
		return;
	end
	self.informationLayer = izx.basePage.new(self,"InformationLayer","moduleDdz",{
			pageType = izx.basePage.PAGE_TYP_CCB,
			ccbFileName = "interfaces/WanJiaXinXi.ccbi",
			ccbController = "xinXiControll",
			initParam = player
		}                    
	);
	self.informationLayer:addToScene({block=false,isBlockTouch=true,clickMaskToClose=true,slideIn="no"});
end

function GameLogic:showChat()
	self.ChatLayer = izx.basePage.new(self,"ChatLayer","moduleDdz",{
			pageType = izx.basePage.PAGE_TYP_CCB,
			ccbFileName = "interfaces/LiaoTian.ccbi",
			ccbController = "chatControll",
			targetX = display.cx,
			targetY = display.cy
		}
	);
	self.ChatLayer:addToScene({block=false,isBlockTouch=true,clickMaskToClose=true});
end

function GameLogic:showJieSuan()
	self.JieSuanLayer = izx.basePage.new(self,"JieSuanLayer","moduleDdz",{
			pageType = izx.basePage.PAGE_TYP_CCB,
			ccbFileName = "interfaces/JieSuan.ccbi",
			ccbController = "JieSuanControll",
			targetX = display.cx,
			targetY = display.cy
		}
	);
	self.JieSuanLayer:addToScene({clickMaskToClose=false});
end

function GameLogic:showNewJieSuan()
	--cleanup

	self.NewJieSuanLayer = izx.basePage.new(self,"NewJieSuanLayer","moduleDdz",{
			pageType = izx.basePage.PAGE_TYP_CCB,
			ccbFileName = "interfaces/JieSuanShengLi.ccbi",
			ccbController = "JieSuan",
			targetX = display.cx,
			targetY = display.cy
		}
	);
	self.NewJieSuanLayer:addToScene({clickMaskToClose=false});
end

function GameLogic:showWanFa()
	self.WanFaLayer = izx.basePage.new(self,"WanFaLayer","moduleDdz",{
			pageType = izx.basePage.PAGE_TYP_CCB,
			ccbFileName = "interfaces/XuanZeWanFa.ccbi",
			ccbController = "WanFaControll",
			targetX = display.cx,
			targetY = display.cy
		}
	);
	self.WanFaLayer:addToScene({clickMaskToClose = false});
end
function GameLogic:showBaoXiangRenWu()
	-- if self.baoXiangRenWu.onlineInfo~=nil or self.baoXiangRenWu.roundInfo ~= nil then
		self.BaoXiangRenWuLayer = izx.basePage.new(self,"BaoXiangRenWuLayer","moduleDdz",{
				pageType = izx.basePage.PAGE_TYP_CCB,
				ccbFileName = "interfaces/BaoXiangRenWu.ccbi",
				ccbController = "BaoXiangRenWu",
				targetX = display.cx,
				targetY = display.cy
			}
		);
		self.BaoXiangRenWuLayer:addToScene({});
		-- self.baoXiangRenWu.giftStat = 10000;
	-- end
end

function GameLogic:onSocketOpen()	 
	-- GameLogin
	izx.baseAudio:init();
	local loginMsg = {opcode = 'pt_cb_login_req',
						ply_guid_ = gBaseLogic.lobbyLogic.userData.ply_guid_,
						ply_nickname_ = gBaseLogic.lobbyLogic.userData.ply_nickname_,
						ply_ticket_ = gBaseLogic.lobbyLogic.userData.ply_ticket_,
						game_id_ = MAIN_GAME_ID,
						version_ = CASINO_VERSION_DEFAULT,
						ext_param_ = ''
                    };
    
	self:sendGameSocket(loginMsg);
	-- self.socketResendCounter = 0;
	-- local _loginTimeTick = function ()
 --    	self:sendLobbySocket(socketMsg);
 --    	self.loginTimeTickScheduler = scheduler.performWithDelayGlobal(_loginTimeTick, 0.5)
 --    end
 --    self.loginTimeTickScheduler = scheduler.performWithDelayGlobal(_loginTimeTick, 0.5)
end

function GameLogic:onSocketTempClose()
	if gBaseLogic.is_robot~=0 then
		return;
	end
	echoInfo("服务器断开，正在为您重连服务器，请稍候");
	print("GameLogic:onTempClose1111")
	gBaseLogic:blockUI({autoUnblock=false,msg="游戏服务器断开，正在为您重连服务器，请稍候"})

end

function GameLogic:onSocketReOpen()
	print("GameLogic:onSocketReOpen")
	if gBaseLogic.is_robot~=0 then
		return;
	end
	self.isErrorJoin = 1;
	self.is_chang_table = 1;
	self.reconnect = 1;
	gBaseLogic:unblockUI()
	-- gBaseLogic.sceneManager.currentPage.ctrller:reInit()
	self:onSocketOpen();
end

function GameLogic:onSocketJoinTable()	 
	print("onSocketJoinTable")
	-- JoinTable
	-- gBaseLogic:blockUI()
	local loginMsg = {opcode = 'pt_cb_join_table_req',
						table_id_ = -1,-- -1 自动找桌
						password_ = ''						
						};
	self:sendGameSocket(loginMsg);
end 

function GameLogic:onSocketJoinMatch()	
	print("onSocketJoinMatch")
	local SocketConfigList = self.curSocketConfigList	
	if self.curSocketConfigList.match_id~=nil then
		local loginMsg = {opcode = 'pt_cb_player_join_match_req',
							match_id_ = SocketConfigList.match_id,-- 
							match_order_id_ = SocketConfigList.match_order_id,					
							};
		var_dump(loginMsg)
		self:sendGameSocket(loginMsg);
	end

	--for test
	--self:pt_bc_player_join_match_ack_handler({ret_= 0})
end

function GameLogic:changeTable()	 
	-- JoinTable
	-- gBaseLogic:blockUI()
	self.is_chang_table = 1;
	if self.playInTable==0 then
		self.is_chang_table = 2;
		self:onSocketJoinTable()
		return
	end
	local loginMsg = {opcode = 'pt_cb_change_table_req' 	
						};
	self:sendGameSocket(loginMsg);
	var_dump(loginMsg)
end

function GameLogic:onSocketCreateTable()	 
	-- CreateTable
	local loginMsg = {opcode = 'pt_cb_create_table_req',
						name_ = '房间1',
						password_ = '',
						base_score_ = 10 --进入限制（积分）						
						};
	-- 					string	name_;
	-- string	password_;
	-- int		base_score_;
	self:sendGameSocket(loginMsg);
end
function GameLogic:onSocketGetTableList()	 
	-- CreateTable
	local loginMsg = {opcode = 'pt_cb_get_table_list_req'};
	 
	self:sendGameSocket(loginMsg);
end

function GameLogic:sendTableReady()	 
	-- CreateTable
	print ("GameLogic:sendTableReady");
	self.achieve_award_not = nil;
    self.daily_task_award_not = nil;
	if self.playInTable==0 then
		self.is_chang_table = 2;
		self:onSocketJoinTable()
		return
	end
	local loginMsg = {opcode = 'pt_cb_ready_req'};
	 
	self:sendGameSocket(loginMsg);
end

-- 在线礼包
function GameLogic:pt_cb_get_online_award_items_req()
	if self.baoXiangRenWu.hasGetOnlineItems == 1 then--有配置文件
		self:onSocketGetOnlieAward();
	else
		local loginMsg = {opcode = 'pt_cb_get_online_award_items_req'};
		print("pt_cb_get_online_award_items_req")
		self:sendGameSocket(loginMsg);
	end
end
function GameLogic:pt_bc_get_online_award_items_ack_handler(message)
	print("pt_bc_get_online_award_items_ack_handler")
	var_dump(message)
	
	if message.ret_==0 then
		self.baoXiangRenWu.hasGetOnlineItems = 1
		if #message.items_>0 then
			table.sort(message.items_,function(a,b)
				if b.award_time_>a.award_time_ then
					return true
				else
					return false;
				end 
				end)
			self.baoXiangRenWu.onlineItems = message.items_
			self:onSocketGetOnlieAward(0)
		else
			-- self.baoXiangRenWu.giftStat = self.baoXiangRenWu.giftStat+1;
			self.baoXiangRenWu.roundInfo = nil;
		end
		var_dump(self.baoXiangRenWu.onlineItems)
	else
		-- self.baoXiangRenWu.giftStat = self.baoXiangRenWu.giftStat+1;
		self.baoXiangRenWu.onlineInfo = nil;
		
	end
	-- if self.baoXiangRenWu.giftStat == 2 then		
	-- 	self:showBaoXiangRenWu();
	-- end
	-- 	char	ret_;		// -1失败 0成功
	-- vector<OnlineAwardItems>	items_;

end
function GameLogic:onSocketGetOnlieAward(typ)	 
	-- CreateTable

	if (typ==nil) then
		typ = 0;
	end
	local loginMsg = {opcode = 'pt_cb_get_online_award_req',type_ = typ};--type_：0查询 1领取
	print("pt_cb_get_online_award_req"..typ)
	self:sendGameSocket(loginMsg);
end 
--局数奖励
function GameLogic:pt_cb_get_task_award_req(typ,task_type_,last_task_index_)	 
	-- CreateTable

	
	-- char	type_;							// 0查询 1领取
	-- int		task_type_;						// 任务类型
	-- int		last_task_index_;	
	print("GameLogic:pt_cb_get_task_award_req")
	local loginMsg = {opcode = 'pt_cb_get_task_award_req',type_ = typ,task_type_=task_type_,last_task_index_=last_task_index_};--type_：0查询 1领取
	 var_dump(loginMsg)
	self:sendGameSocket(loginMsg);
end 
function GameLogic:pt_cb_get_task_system_req()	 
	-- CreateTable 
	if self.baoXiangRenWu.hasGetRoundItems == 1 then--有配置文件
		self:pt_cb_get_task_award_req(0,1,0);
	else
		local loginMsg = {opcode = 'pt_cb_get_task_system_req'};
		self:sendGameSocket(loginMsg);
	end
	
end 
--baoxiangrenwu
function GameLogic:pt_bc_get_task_system_ack_handler(message)	 
	-- CreateTable 
	print("GameLogic:pt_bc_get_task_system_ack_handler");
	var_dump(message,3)
	if message.ret_==0 then
		self.baoXiangRenWu.hasGetRoundItems = 1
		if #message.round_items_>0 then
			table.sort(message.round_items_,function(a,b)
				if b.award_round_>a.award_round_ then
					return true
				else
					return false;
				end 
				end)
			self.baoXiangRenWu.roundItems = message.round_items_
			local taskInfo = message.round_items_[1]
			self:pt_cb_get_task_award_req(0,taskInfo.task_type_,taskInfo.task_index_)
		else
			-- self.baoXiangRenWu.giftStat = self.baoXiangRenWu.giftStat+1;
			self.baoXiangRenWu.roundInfo = nil;
		end
	else
		-- self.baoXiangRenWu.giftStat = self.baoXiangRenWu.giftStat+1;
		self.baoXiangRenWu.roundInfo = nil;
		
	end
	-- if self.baoXiangRenWu.giftStat == 2 then		
	-- 	self:showBaoXiangRenWu();
	-- end
	-- int				task_type_;			// 任务类型 1累加 2胜利
	-- int				task_index_;		// 任务索引 
	-- int				award_round_;		// 奖励局数
	-- string			award_name_;		// 奖励名称
	-- vector<ItemAwardData>	items_;		// 道具信息
end 
function GameLogic:pt_bc_get_online_award_ack_handler(message)
	-- giftStat=0,
	-- 	roundItems = {},
	-- 	onlineInfo = {},
	-- 	roundInfo = {}
	print("GameLogic:pt_bc_get_online_award_ack_handler"..message.ret_)
	var_dump(message)
	-- self.baoXiangRenWu.giftStat = self.baoXiangRenWu.giftStat+1;
	if (message.ret_==4) then
		
		if message.money_==0 and message.remain_==0 then
			self.baoXiangRenWu.onlineInfo = nil;
		else
			self.baoXiangRenWu.onlineInfo = {remain_=message.remain_,money_=message.money_}

		end
		if (message.remain_==0 and message.money_~=0) then
			-- print("==Roundtaskfinish2:"..self.roundTaskFinishNum)
			
			self.baoXiangRenWu.onlineitemfinish = 1
			self.roundTaskFinishNum = self.baoXiangRenWu.onlineitemfinish+self.baoXiangRenWu.roundItemFinish+self.baoXiangRenWu.streaktaskFinish
		-- onlineitemfinish = 0,
			self:dispatchLogicEvent({
			        name = "RefreshTaskNum",
			        message = {} 
			    })
		end
		-- if self.baoXiangRenWu.giftStat == 2 then
		-- 	self:showBaoXiangRenWu();
		-- end
	else
	-- char	ret_;				//0成功领取奖励  1时间未到 2任务结束 4查询结果
	-- int		remain_;			//剩余时间(ret=0已经进行的时间)
	-- int		money_;				//可以获得的奖励
		if (message.money_==0 and message.remain_==0) or message.ret_==2  then
			self.baoXiangRenWu.onlineInfo = nil;
		else
			self.baoXiangRenWu.onlineInfo = {remain_=message.remain_,money_=message.money_}
		end
		if message.ret_~=0 then
			if message.money_~=0 and message.remain_==0 then
				print("==Roundtaskfinish2:"..self.roundTaskFinishNum)
				self.baoXiangRenWu.onlineitemfinish = 1
				self.roundTaskFinishNum = self.baoXiangRenWu.onlineitemfinish+self.baoXiangRenWu.roundItemFinish+self.baoXiangRenWu.streaktaskFinish
 				self:dispatchLogicEvent({
			        name = "RefreshTaskNum",
			        message = {} 
			    })

			end
		else
			-- print("==Roundtaskaward2:"..self.roundTaskFinishNum)
			self.baoXiangRenWu.onlineitemfinish = 0
			self.roundTaskFinishNum = self.baoXiangRenWu.onlineitemfinish+self.baoXiangRenWu.roundItemFinish+self.baoXiangRenWu.streaktaskFinish
			self:dispatchLogicEvent({
			        name = "RefreshTaskNum",
			        message = {} 
			    })
		end
		-- if self.baoXiangRenWu.giftStat == 2 and message.ret_~=0 then
		-- 	self:showBaoXiangRenWu();
		-- end
		
	end
	self:dispatchLogicEvent({
        name = "MSG_SOCK_pt_bc_get_online_award_ack",
        message = message 
    })
	-- print("pt_bc_get_online_award_ack_handler"..self.baoXiangRenWu.giftStat)
end
function GameLogic:pt_bc_get_task_award_ack_handler(message)
	-- char	ret_;							// 0成功领取 1查询结果
	-- int		task_type_;						// 任务类型 [0]累计局数 [1]胜利局数
	-- int		last_task_index_;				// 最后领取任务的Index 0未领取
	-- int		cur_val_;						// 当前局数	或 当前赢的局数
	print("GameLogic:pt_bc_get_task_award_ack_handler")
	var_dump(message)
	if message.ret_==1 then
		--当前抽奖次数
		self:refreshChoujiang(message)
	    
		local last_task_index_ = -1;
		local task_type_ = -1;
		local needRound = 10000;
		if message.last_task_index_==0 then
			last_task_index_ = self.baoXiangRenWu.roundItems[1].task_index_
			task_type_ = self.baoXiangRenWu.roundItems[1].task_type_
			needRound = self.baoXiangRenWu.roundItems[1].award_round_
		else
			local curK = -1;
			for k,v in pairs(self.baoXiangRenWu.roundItems) do
				if v.task_index_==message.last_task_index_ then
					curK= k+1;
					break;
				end
			end
			var_dump(self.baoXiangRenWu.roundItems[curK]);
			if self.baoXiangRenWu.roundItems[curK]~=nil then
				last_task_index_ = self.baoXiangRenWu.roundItems[curK].task_index_
				task_type_ = self.baoXiangRenWu.roundItems[curK].task_type_
				needRound = self.baoXiangRenWu.roundItems[curK].award_round_
				print("roundsss"..self.baoXiangRenWu.roundItems[curK].award_round_ ..":"..message.cur_val_)
				
			end
		end
		if needRound<=message.cur_val_ then
			-- print("==Roundtaskfinish:"..self.roundTaskFinishNum)
			-- self.roundTaskFinishNum = self.roundTaskFinishNum+1;
			self.baoXiangRenWu.roundItemFinish = 1
			self.roundTaskFinishNum = self.baoXiangRenWu.onlineitemfinish+self.baoXiangRenWu.roundItemFinish+self.baoXiangRenWu.streaktaskFinish
			self:dispatchLogicEvent({
			        name = "RefreshTaskNum",
			        message = {} 
			    })
		end
		if last_task_index_==-1 then
			self.baoXiangRenWu.roundInfo = nil
		else
			self.baoXiangRenWu.roundInfo = {task_type_=task_type_,last_task_index_=last_task_index_,cur_val_=message.cur_val_}
		end
		print("========self.baoXiangRenWu.roundItems")
		var_dump(self.baoXiangRenWu.roundItems[1])
		var_dump(self.baoXiangRenWu.roundInfo)
		-- self.baoXiangRenWu.giftStat = self.baoXiangRenWu.giftStat+1;
		-- if self.baoXiangRenWu.giftStat == 2 then
		-- 	self:showBaoXiangRenWu();
		-- end		
	elseif message.ret_==0 then
		print("==Roundtaskaward:"..self.roundTaskFinishNum)
		self.baoXiangRenWu.roundItemFinish = 0
			self.roundTaskFinishNum = self.baoXiangRenWu.onlineitemfinish+self.baoXiangRenWu.roundItemFinish+self.baoXiangRenWu.streaktaskFinish;
		-- self.roundTaskFinishNum = self.roundTaskFinishNum-1;		
		self:dispatchLogicEvent({
		        name = "RefreshTaskNum",
		        message = {} 
		    })
	end
	self:dispatchLogicEvent({
        name = "MSG_SOCK_pt_bc_get_task_award_ack",
        message = message 
    })
	-- print("pt_bc_get_task_award_ack_handler"..self.baoXiangRenWu.giftStat)
end
function GameLogic:refreshChoujiang(message)
	print("GameLogic:refreshChoujiang")
	var_dump(message)
	self.LotteryDraw.curTimes = message.last_task_index_;
    --当天最大抽奖次数
    self.LotteryDraw.MaxTimes = message.luck_draw_times_;
    --单场次已完成局数
    self.LotteryDraw.curGames = message.cur_val_;
    --单场次抽奖次数限制
    self.LotteryDraw.reqGames = message.config_round_;
    --抽奖次数判断
    var_dump(self.LotteryDraw)
    
    gBaseLogic.sceneManager.currentPage.view:setBaoXiangSprite();
end
-- 赠送道具
function GameLogic:onSocketGiveGift()	 
	-- CreateTable
	local dst_ply_guid_ = '122344';
	local amount_ = 5000;
	local loginMsg = {opcode = 'pt_cb_give_gift_req',dst_ply_guid_ = dst_ply_guid_,amount_=amount_}; 
	 
	self:sendGameSocket(loginMsg);
end

--zhudong离开房间
function GameLogic:send_pt_cb_leave_table_req()	 
	if self.playInTable==0 and self.gameSocket~=nil and self.gameSocket.isConnect == 1 then
        local loginMsg = {opcode = 'pt_cb_leave_table_req'}; 
		print("pt_cb_leave_table_req");
		self:sendGameSocket(loginMsg);
    else
        self:LeaveGameScene(-1)
    end
	
end

function GameLogic:setIsLaiZi(hasBaoValue)
	print("GameLogic:setIsLaiZi")
	echoError("GameLogic:setIsLaiZi", hasBaoValue)
	if hasBaoValue==2 then
		self.isMatch=1;
	else
		self.hasBaoValue = hasBaoValue;
	end
	print("GameLogic:setIsLaiZi"..self.hasBaoValue)
end

function GameLogic:setNeedMoney(needMoney)
	print("GameLogic:needMoney")
	self.needMoney = needMoney;
	print("GameLogic:needMoneyDesc"..self.needMoney)
end

function GameLogic:pt_cg_card_count_req_send()
	local loginMsg = {opcode = 'pt_cg_card_count_req'}; 	 
	self:sendGameSocket(loginMsg);
end

function GameLogic:SendChatReq(msg)
	if (msg == nil ) then
		return;
	end
	local chatMsg = {opcode = 'pt_cb_chat_req',
						type_ = 0,
						message_ = msg						
						};
	self:sendGameSocket(chatMsg);
end 

function GameLogic:SendChatPayReq(msg)
	if (msg == nil ) then
		return;
	end
	local chatMsg = {opcode = 'pt_cb_send_prop_req',
						dst_ply_guid_ = 0,
						index_ = self.ITEM_EXPRESSION_PARCEL,
						amount_ = msg						
						};
	self:sendGameSocket(chatMsg);
end 

function GameLogic:SendTrumpetReq(msg)
	if (msg == nil ) then
		return;
	end
	local chatMsg = {opcode = 'pt_cl_trumpet_req',
						type_ = 0,
						message_ = msg						
						};
	self:sendGameSocket(chatMsg);
end

function GameLogic:setIsErrJoin(flag)
	self.isErrorJoin = flag
end

function GameLogic:gotogaojiChang(cback)
	print("GameLogic:gotogaojiChang")
	var_dump(self.curSocketConfigList)
	if self.curSocketConfigList.level < 3 then
		local userMoney = gBaseLogic.lobbyLogic.userData.ply_lobby_data_.money_;
		local thisLevel = self.curSocketConfigList.level+1
		for k,v in pairs(gBaseLogic.lobbyLogic.server_datas_) do
			if v.isLaiZi == self.curSocketConfigList.isLaiZi then
				if tonumber(v.level) == tonumber(thisLevel) then
					gBaseLogic.lobbyLogic.gotoGameName = v.server_name_;
					if (userMoney<v.min_money_) then
						print("1223")
						gBaseLogic:onNeedMoney("gameenter",v.min_money_,1);
						
						break;
					end
					local flag = 0;
					if thisLevel~=3 and v.maxMoney~=0 then
						if tonumber(v.maxMoney) < userMoney then
							thisLevel = thisLevel+1
							flag = 1;
						end
					end
					if flag == 0 then
						local ddzSocketConfig = {socketIp = v.server_addr_,socketPort = v.server_port_}
						local isLaiZi = v.isLaiZi;
						local needMoney = v.needMoney;					
						local SocketConfigList = {SocketConfig=ddzSocketConfig,isLaiZi=isLaiZi,needMoney=needMoney,min_money_=v.min_money_,max_money_=v.maxMoney,gameModule="moduleDdz",isErrjoin=0,level=v.level}						
						self.gameSocket:close();
						self.gameSocket = nil;

						gBaseLogic.lobbyLogic:realStartGame(SocketConfigList)
						-- self:startGamesocket();
						break
					end
				end
			end
		end
	else
		print("GameLogic:gotogaojiChang12121")
		local miniGameInfo = izx.miniGameManager:getMiniGame(100);
		if (miniGameInfo==nil) then
			izxMessageBox("暂未开放","提示");
			return;
		end
		self.gameSocket:close();
		self.gameSocket = nil;
		gBaseLogic.lobbyLogic:startMiniGame(100)
	end
	-- self.curSocketConfigList.isLaiZi =
end

function GameLogic:showAchievefinishContent(message)
	self.AchievefinishLayer = izx.basePage.new(self,"AchievefinishLayer","moduleDdz",{
			pageType = izx.basePage.PAGE_TYP_CCB,
			ccbFileName = "interfaces/ChengJiuWanCheng.ccbi",
			ccbController = "ChengjiuWancheng",
			targetX = display.cx,
			targetY = display.cy,
			initParam = {message=message}
		} 
	);
	self.AchievefinishLayer:addToScene({clickMaskToClose=false});
end

function GameLogic:judgeExitGame()
	print("judgeExitGame")
	if self.gamePage~=nil then
		self.gamePage.view:onPressExit()
	end
end

function GameLogic:pt_cb_get_streak_task_req()
	print("GameLogic:pt_cb_get_streak_task_req")
	local chatMsg = {opcode = 'pt_cb_get_streak_task_req',
											
						};
	self:sendGameSocket(chatMsg);
end
function GameLogic:pt_bc_get_streak_task_ack_handler(message)
	-- izxMessageBox("pt_bc_get_streak_task_ack_handler", "notic");

	print("pt_bc_get_streak_task_ack_handler")
	var_dump(message)
	self.baoXiangRenWu.streaktaskFinish = 0
	if message.ret_ ==1 or (message.ret_==0 and message.speed_>=message.amount_) then
		self.baoXiangRenWu.streaktaskFinish = 1
	end
	self.roundTaskFinishNum = self.baoXiangRenWu.onlineitemfinish+self.baoXiangRenWu.roundItemFinish+self.baoXiangRenWu.streaktaskFinish;
	self.baoXiangRenWu.streaktaskinfo = {ret_=message.ret_,index_=message.index_,name_=message.name_,desc_=message.desc_,speed_=message.speed_,amount_=message.amount_}
	
	self:dispatchLogicEvent({
	        name = "RefreshTaskNum",
	        message = {} 
	    })
	self:dispatchLogicEvent({
        name = "MSG_SOCK_pt_bc_get_streak_task_ack",
        message = message 
    })
	
end
function GameLogic:sendGameSocket(socketMsg)
	if self.gameSocket==nil then
		self:onSocketClose();
	else
		self.gameSocket:send(socketMsg);
	end
end

function GameLogic:showLotteryDraw()
	self.LotteryDrawWuLayer = nil
  self.LotteryDrawWuLayer = izx.basePage.new(self,"LotteryDraw","moduleDdz",{
    pageType = izx.basePage.PAGE_TYP_CCB,
    ccbFileName = "interfaces/BaoXiangFanPaiJiangLi.ccbi",
    ccbController = "LotteryDraw",
    targetX = 0,
    targetY = display.cy / 2,
    slideIn="no"
  }
  );
  self.LotteryDrawWuLayer:addToScene({isBlockTouch = false, clickMaskToClose = false});


  
end
function GameLogic:SendTaskNumReq(rType,tType,taskInd)
	print("pt_cb_get_task_award_req")
	local msg = {
		opcode = 'pt_cb_get_task_award_req',
		type_ = rType,  --0 查询 1 领取
		task_type_ = tType, --1 对战任务 2 胜利任务		
		last_task_index_ = taskInd,
	};
	self:sendGameSocket(msg);
end
return GameLogic;
