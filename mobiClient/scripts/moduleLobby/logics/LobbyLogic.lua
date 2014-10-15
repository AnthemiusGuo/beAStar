local LobbyLogic = class("LobbyLogic");
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler");
LobbyLogic.MSG_HTTP_HelpDesk = "MSG_HTTP_HelpDesk";
LobbyLogic.MSG_HTTP_GongGaoCommon = "MSG_HTTP_GongGaoCommon";
-- self:getChongZhiJiangLiData()
--MSG_SOCK_pt_lc_get_daily_task_award_ack
--[[message:   {opcode:"pt_lc_get_daily_task_award_ack",res_:'0', money_:300,
			 gift_:12,prop_1_:3,prop_2_:5,prop_3_:6,prop_4_:7,prop_5_:7}]]--

-- pt_lc_get_achieve_list_ack
-- pt_lc_get_achieve_award_ack 
--     message:   {opcode:"pt_lc_get_achieve_award_ack",res_:'0', money_:300,
			-- gift_:12,prop_1_:3,prop_2_:5,prop_3_:6,prop_4_:7,prop_5_:7}
-- pt_lc_get_safe_data_ack --保险箱数据
-- pt_lc_set_password_safe_ack -- 保险箱设置密码
-- pt_lc_store_safe_amount_ack -- 保险箱存钱
-- pt_lc_remove_safe_amount_ack -- 保险箱取钱
-- pt_lc_modify_password_safe_ack --保险箱修改密码
-- pt_lc_get_safe_history_ack

-- LobbyLogic.MSG_HTTP_ShopHistory = "MSG_HTTP_ShopHistory"; --商城充值记录


function LobbyLogic:ctor()
	self.match_current_score = 0;
	self.lobbyErr = 0;--lobby服务器是否出错
	self.showXinShouTiShi = nil --是否出新手提示
	self.curSocketConfigList = nil
	self.helpDesk = HELP_QQ;
	self.userData = {};
	self.chatData = {};
	self.mailData = {};
	self.achieveListData = {};
	self.eventCache = {};
	self.server_datas_ = {};
 	self.server_status_ = {};

 	self.gotoGameName = "";
 	self.paymentItemList = nil;
    self.VIPItemList = nil;
    self.payVIPItemList = nil;
    self.payItemNormal = {};
    self.payItemSMS = {};
    self.payItemProp = {};
    self.payItemNormalCounter = 0;
    self.payItemSMSCounter = 0;
    self.guangBaoList = {} --广播记录
 	self.hasNewMsg = 0;
 	self.closeGameErr = 0;

 	self.gongGaoContent = "暂无公告";
	self.gongGaotitle = "公告";
	self.hasqiangtuigonggao = 0;

	self.haschangename = false

	self.payInitList = nil;
	self.getPayNum = 10;
	self.gametomove = 0
	self.distrank = 0;
	self.lowMoney = false;
	self.lowMoneyMsg = "";
	self.gameType = -1;
	self.relief_times_ = 0;

	self.pochanTolobby = 0;
	self.gametoback = 0;
	self.winRoundInfo = {
		score = 0,
		winNum = 0,
		maxScore = 0,
		maxWinNum = 0
	}
	self.selfTips = {
		isTips = false,
		userMoney = 0,
		needMoney = 0,
		boxInfo = {},
		status = 0,
	}
	self.vipData = {vipLevel=0,vipRate=0,nextVipneedMoney=1
    }
	self.isShow = false;
	self.otherplayin = 0 -- 1:抢帐号 2：大厅断网
	self.isOnGameExit = 0 -- 1:主动退出游戏
	
	self.needSessionLogout = 0 --切换帐号时是否需要loginout
	--双倍宝箱数据
	self.doubleChestids = {}
	require("framework.api.EventProtocol").extend(self)
	require("moduleLobby.logics.PicConfig");
	require('moduleLobby.logics.LobbyGameLogic').extend(self);
	require("moduleLobby.logics.AudioConfig");
	izx.baseAudio:init();
	-- self.taskData = {};

	--appstore check
	self.vip = 0;
	self.jihuoma = 0;
	self.ver_codes = 0;
	self.exitgame = 0;
	self.minigamedownload = 0;
	self.promotion = 0;
	self.gonggao = 0;
	self.safe = 0;
	self.minigame = 0;
	self.guidhelp = 0;
	--match 
	self.isMatch = 0;
	self.isMatchOnGameExit = 0;
	-- self.curMatchID = 0;
	-- self.curMatchOrderID =0;
	-- self.curMatchScore = 0;
	-- self.curMatchRound = 0;
	-- self.curMatchTRound = 0;
end



function LobbyLogic:dispatchLogicEvent(event)
	-- var_dump(event)
	if (gBaseLogic.sceneManager.inTransition) then
		print("LobbyLogic:dispatchLogicEvent cache")
		table.insert(self.eventCache, event);
	else
		print("LobbyLogic:dispatchLogicEvent dis")
		-- var_dump(self.listeners_,4);
		self:dispatchEvent(event)
	end
end

function LobbyLogic:dispatchEventToCache(event)
	table.insert(self.eventCache, event);
end

function LobbyLogic:dispatchCachedEvent()
	for k,event in pairs(self.eventCache) do
		self:dispatchEvent(event);
	end
	self.eventCache = {};
end

function LobbyLogic:addLogicEvent(eventName,handler,target)
	target.handlerPool = target.handlerPool or {};
	target.handlerPool[eventName] = self:addEventListener(eventName,handler);
end

function LobbyLogic:removePage(pageName,needEnterLobby)
	if (needEnterLobby) then
	    self:EnterLobby();
	end 
end

function LobbyLogic:startLobbySocket(lobbySocketConfig)
	print("lobbySocket:connect");
	gBaseLogic.MBPluginManager:logEventLabelMyBegin("LOGIN_STEP_DURA","connectLobby");
	 
	self.lobbySocket = self.lobbySocket or require("izxFW.SocketWrapper").new(self,
		gBaseLogic.socketConfig.socketType,
		lobbySocketConfig,
		'lobby');
	self.lobbySocket:connect();
end

function LobbyLogic:closeSocket()
	if (self.lobbySocket) then
		self.lobbySocket:close();
		self.lobbySocket = nil;
	end
end

function LobbyLogic:resetUserInfo()
	print("LobbyLogic:resetUserInfo")
	self.userData = nil;
	self.userData = {};
	self.userData.ply_nickname_ = '';
	self.haschangename = false
	self.userHasLogined = false;
	self.face = ""
	self.userData.ply_vip_ = {}
	self.userData.ply_vip_.level_ = 0
	self.userData.ply_vip_.status_ = 0 
	self:dispatchLogicEvent({
        name = "MSG_Socket_UserData",
        message = {}
    })
    if (self.loginScene and self.loginScene.view) then
        self.loginScene.view:setDisabled();
    end
end


function LobbyLogic:destroyListen()
	local scene = display.getRunningScene()
  	scene:removeChild(self.rootNode)
end

function LobbyLogic:reShowLoginScene(block,msg)
	gBaseLogic:unblockUI();
	if (gBaseLogic.gameLogic) then
		if (gBaseLogic.gameLogic.resDir) then
			izx.resourceManager:removeSearchPath(gBaseLogic.gameLogic.resDir);
		end
		if (gBaseLogic.gameLogic.onGameExit) then
			gBaseLogic.gameLogic:onGameExit();
		end
		gBaseLogic.gameLogic = nil;
	end
	self.userData = nil;
	self.userData = {};
	self.userHasLogined = false
	local initParam = {};
	-- if changeUser==nil then
	-- 	initParam={}
	-- else
	-- 	initParam = {reload=1}
	-- end
	initParam = {reload=1,showMsg=msg}

	gBaseLogic.onLogining = false;
	gBaseLogic.currentState = gBaseLogic.stateInLobby;
	self:EnterLobby(initParam)
end

function LobbyLogic:reShowLoginSceneOld(block,cback,changeUser)
	if (gBaseLogic.gameLogic) then
		if (gBaseLogic.gameLogic.resDir) then
			izx.resourceManager:removeSearchPath(gBaseLogic.gameLogic.resDir);
		end
		if (gBaseLogic.gameLogic.onGameExit) then
			gBaseLogic.gameLogic:onGameExit();
		end
		gBaseLogic.gameLogic = nil;
	end
	self.userData = nil;
	self.userData = {};
	self.userHasLogined = false
	local initParam = {};
	if changeUser==nil then
		initParam={}
	else
		initParam = {reload=1}
	end
	self.loginScene = izx.basePage.new(self,"LoginScene","moduleLobby",{
			pageType = izx.basePage.PAGE_TYP_CCB,
			ccbFileName = "interfaces/DengLu.ccbi",
			ccbController = "sceneLogin",
			slideIn = "right",
			initParam = initParam,
			cback = cback
		}
	);

	self.loginScene:enterScene(block);
	gBaseLogic.onLogining = false;
	gBaseLogic.currentState = gBaseLogic.stateLogin;
	
end

function LobbyLogic:goBackToMain(withLoading)
	
	if (gBaseLogic.gameLogic) then
		if (gBaseLogic.gameLogic.resDir) then
			izx.resourceManager:removeSearchPath(gBaseLogic.gameLogic.resDir);
		end
		if (gBaseLogic.gameLogic.onGameExit) then
			gBaseLogic.gameLogic:onGameExit();
		end
		gBaseLogic.gameLogic = nil;
		self.gametoback = 1;
	end
	if (withLoading) then
		self:showFakeLoadingScene("moduleLobby");
	else
		self:EnterLobby()
	end
end

function LobbyLogic:goBackToMainOld(withLoading)
	if (gBaseLogic.gameLogic) then
		if (gBaseLogic.gameLogic.resDir) then
			izx.resourceManager:removeSearchPath(gBaseLogic.gameLogic.resDir);
		end
		if (gBaseLogic.gameLogic.onGameExit) then
			gBaseLogic.gameLogic:onGameExit();
		end
		gBaseLogic.gameLogic = nil;
	end
	if (withLoading) then
		self:showFakeLoadingScene("moduleLobby");
	else
		if (gBaseLogic.currentState==gBaseLogic.stateLogin) then
			self:showLoginScene()
		else
			self:EnterLobby()
		end
	end
end

function LobbyLogic:showPromotionScene(initParam)
	self.promotionScene = nil
	self.promotionScene = izx.basePage.new(self,"PromotionScene","moduleLobby",{
			pageType = izx.basePage.PAGE_TYP_CCB,
			ccbFileName = "interfaces/Tuiguang.ccbi",
			ccbController = "promoteControll",
			initParam = initParam
		}
	);
	self.promotionScene:enterScene();
	--self.promotionScene.ctrller:getPromote();
end

function LobbyLogic:onUserNameUpdate(event)	
	print("LobbyLogic:onUserNameUpdate")
	var_dump(event.message.sessionInfo,4)

	if gBaseLogic.lobbyLogic.userData.ply_lobby_data_ then 
		gBaseLogic.lobbyLogic.userData.ply_lobby_data_.nickname_ = event.message.sessionInfo.nickname
	end

	if(self.loginScene ~= nil and self.loginScene.view ~= nil)then
		self.loginScene.view.labelUserName:setString(izx.UTF8.sub(event.message.sessionInfo.nickname,1,7));
	end

	if(self.lobbyScene ~= nil and self.lobbyScene.view ~= nil)then
		self.lobbyScene.view.labelNickName:setString(izx.UTF8.sub(event.message.sessionInfo.nickname,1,7))
	end

	if(self.personalScene ~= nil and self.personalScene.view ~= nil)then
		self.personalScene.view.txt_person_name:setString(izx.UTF8.sub(event.message.sessionInfo.nickname,1,7))
	end

	if(gBaseLogic.gameLogic.gamePage ~= nil and gBaseLogic.gameLogic.gamePage.view ~= nil)then

		gBaseLogic.gameLogic.nickname = event.message.sessionInfo.nickname;

		if(gBaseLogic.gameLogic.gamePage.view.GameReadyLayer ~= nil and gBaseLogic.gameLogic.gamePage.view.GameReadyLayer.view ~= nil and gBaseLogic.gameLogic.gamePage.ctrller.gameStatus == gBaseLogic.gameLogic.gamePage.ctrller.STATUS_READY)then
			gBaseLogic.gameLogic.gamePage.view.GameReadyLayer.view.player1_content1_nickName1:setString(izx.UTF8.sub(event.message.sessionInfo.nickname,1,7));
		else
			gBaseLogic.gameLogic.gamePage.view.selfNickName:setString(izx.UTF8.sub(event.message.sessionInfo.nickname,1,10));
			print("gBaseLogic.gameLogic.nickname:",gBaseLogic.gameLogic.nickname)
		end
	end
end

function LobbyLogic:showWaterHole(initParam)
  self.waterHole = nil
  self.waterHole = izx.basePage.new(self,"WaterHole","moduleLobby",{
      pageType = izx.basePage.PAGE_TYP_CCB,
      ccbFileName = "interfaces/WaterHole.ccbi",
      ccbController = "WaterHoleCtrller",
      initParam=initParam
    }
  );
  self.waterHole:addToScene({isBlockTouch = false, clickMaskToClose = false,});
end 

function LobbyLogic:showLoginScene(block,initParam)	
	var_dump(initParam)
	self:EnterLobby(initParam);
end

function LobbyLogic:showLoginSceneOld(block,initParam)	
	self.loginScene = izx.basePage.new(self,"LoginScene","moduleLobby",{
			pageType = izx.basePage.PAGE_TYP_CCB,
			ccbFileName = "interfaces/DengLu.ccbi",
			ccbController = "sceneLogin",			
			slideIn = "right",
			initParam = initParam
		}
	);
	self.loginScene:enterScene(block);
	gBaseLogic.onLogining = false;
	gBaseLogic.currentState = gBaseLogic.stateLogin;

	
end

function LobbyLogic:showFakeLoadingScene(moduleName)
	local slideIn = "";
	-- local cback = nil;
	if (moduleName=="moduleLobby") then
		slideIn = "right"
	else 
		slideIn = "left"
		print(moduleName)

		if (moduleName=="moduleMainGame") then
			print("gamessdsssss");
		end
	end
	-- local LoadingScene = izx.basePage.new(self,"FakeLoadingScene","moduleLobby",{
	-- 		pageType = izx.basePage.PAGE_TYP_CCB,
	-- 		ccbFileName = "interfaces/Loading.ccbi",
	-- 		ccbController = "sceneLoading",
	-- 		initParam = {moduleName=moduleName},
	-- 		slideIn = slideIn
	-- 	}
	-- );
	-- Guojia 20140616 改ccb改煩了,改用純代碼
	local LoadingScene = izx.basePage.new(self,"FakeLoadingSceneCode","moduleLobby",{
			pageType = izx.basePage.PAGE_TYP_CODE,
			isCodeScene = true,
			initParam = {moduleName=moduleName},
			slideIn = slideIn
		}
	);
	LoadingScene:enterScene(false);
end
function LobbyLogic:showLoadingScene(moduleName,miniGameId)
	-- Guojia 20140616 改ccb改煩了,改用純代碼
	-- local LoadingScene = izx.basePage.new(self,"LoadingScene","moduleLobby",{
	-- 		pageType = izx.basePage.PAGE_TYP_CCB,
	-- 		ccbFileName = "interfaces/Loading.ccbi",
	-- 		ccbController = "sceneLoading",
	-- 		initParam = {moduleName=moduleName,gameId=miniGameId},
	-- 		slideIn = "left"
	-- 	}
	-- );

	local LoadingScene = izx.basePage.new(self,"LoadingSceneCode","moduleLobby",{
			pageType = izx.basePage.PAGE_TYP_CODE,
			isCodeScene = true,
			initParam = {moduleName=moduleName,gameId=miniGameId},
			slideIn = "left"
		}
	);
	LoadingScene:enterScene(false);
end

function LobbyLogic:showGaoGaoLayer()
	local opt={
			pageType = izx.basePage.PAGE_TYP_CCB,
			ccbFileName = "interfaces/DengLuGongGao.ccbi",
			ccbController = "panelAnouncement"
		};
	if (MAIN_GAME_ID==11) then
		opt.targetY = (display.height - 486)/2 - 70;
	end
	self.GongGaoLayer = izx.basePage.new(self,"GongGaoLayer","moduleLobby",opt);
	self.GongGaoLayer:addToScene({slideIn="up"});
end

function LobbyLogic:showSetupLayer()
	local opt={
			pageType = izx.basePage.PAGE_TYP_CCB,
			ccbFileName = "interfaces/SheZhi.ccbi",
			ccbController = "sheZhicontroll"
		};
	if (MAIN_GAME_ID==11) then
		opt.targetY = display.height/2 - 320
	end
	self.SetupLayer = izx.basePage.new(self,"SetupLayer","moduleLobby",opt);
	self.SetupLayer:addToScene({slideIn="bottom"});
end

function LobbyLogic:showFreeCoinLayer() 
	local opt={
				pageType = izx.basePage.PAGE_TYP_CODE,
				targetX = display.cx,
				targetY = display.cy
		}
	self.FreeCoinLayer = izx.basePage.new(self,"FreeCoinLayer","moduleLobby",opt);
	self.FreeCoinLayer:addToScene({slideIn="bottom",isAddToView = false})
end

function LobbyLogic:showLoginTypeLayer() --根据不同的渠道对应的tag值取ccb
	self.DengLuXuanZeLayer = izx.basePage.new(self,"DengLuXuanZeLayer","moduleLobby",{
			pageType = izx.basePage.PAGE_TYP_CCB,
			ccbFileName = "interfaces/DengLuXuanZe.ccbi",
			ccbController = "DengLuXuanZe",
			targetX = display.cx,
			targetY = display.cy,
		}
	);
	self.DengLuXuanZeLayer:addToScene({});
	-- self.LoginTypeLayer = izx.basePage.new(self,"LoginTypeLayerCode","moduleLobby",{
	-- 		pageType = izx.basePage.PAGE_TYP_CODE
	-- 	}
	-- );

	-- -- self.LoginTypeLayer = izx.basePage.new(self,"LoginTypeLayer","moduleLobby",{
	-- -- 		pageType = izx.basePage.PAGE_TYP_CCB,
	-- -- 		ccbFileName = "interfaces/DengLuAnNiu.ccbi",
	-- -- 		ccbController = "loginPattern"
	-- -- 	}
	-- -- );
	-- self.LoginTypeLayer:addToScene({slideIn="bottom",isAddToView = true})
end


function LobbyLogic:showPayTyperLayer(idx)	
	self.payTypeLayer = izx.basePage.new(self,"PayTyperLayer","moduleLobby",{
			pageType = izx.basePage.PAGE_TYP_CCB,
			ccbFileName = "interfaces/zhifuxuanzekuang.ccbi",
			ccbController = "payController",
			initParam = {goodsIdx = idx}
		}
	);
	self.payTypeLayer:addToScene({})
end
function LobbyLogic:closeLoginTypeLayer()
	gBaseLogic.sceneManager:removePopUp("DengLuXuanZeLayer");
end

function LobbyLogic:showDengLuJiangLiLayer()
	if (MAIN_GAME_ID==10) then
		self:showDengLuPopLayer();
		return;
	end
	local opt = {
			pageType = izx.basePage.PAGE_TYP_CCB,
			ccbFileName = "interfaces/DengLuJiangLi.ccbi",
			ccbController = "loginReward",
			targetX = display.cx,
			targetY = display.cy-50,
		};
	if (MAIN_GAME_ID==11) then
		opt.targetY = display.cy
	end
	self.DengLuJiangLiLayer = izx.basePage.new(self,"DengLuJiangLiLayer","moduleLobby",opt);
	self.DengLuJiangLiLayer:addToScene({});
end

function LobbyLogic:showNewDengLuLayer()
	self.NewDengLuLayer = izx.basePage.new(self,"NewDengLuLayer","moduleLobby",{
			pageType = izx.basePage.PAGE_TYP_CCB,
			ccbFileName = "interfaces/MeiRiBiZuo1.ccbi",
			ccbController = "MeiRIBiZuo",
			targetX = display.cx,
			targetY = display.cy
		}
	);
	self.NewDengLuLayer:addToScene({});
end 

function LobbyLogic:showQianDaoLayer(id)
	self:showQianDaoLayerNew(id);
	 
		-- self.QianDaoLayer = izx.basePage.new(self,"QianDaoLayer","moduleLobby",{
		-- 		pageType = izx.basePage.PAGE_TYP_CCB,
		-- 		ccbFileName = "interfaces/QianDao.ccbi",
		-- 		ccbController = "QianDao",
		-- 		targetX = display.cx,
		-- 		targetY = display.cy,
		-- 		initParam = {type = id},
		-- 	}
		-- );
		-- self.QianDaoLayer:addToScene({});
end

function LobbyLogic:showQianDaoLayerNew(id)
	self.QianDaoLayerNew = izx.basePage.new(self,"QianDaoLayerNew","moduleLobby",{
			pageType = izx.basePage.PAGE_TYP_CCB,
			ccbFileName = "interfaces/HuoDongTanChu.ccbi",
			ccbController = "QianDao",
			targetX = display.cx,
			targetY = display.cy,
			initParam = {type = id},
		}
	);
	self.QianDaoLayerNew:addToScene({});
end

function LobbyLogic:showDengLuPopLayer() 
	--self:showMeiRiBiZuoLayer()
	--self:showDengLuJiangLiLayer()
	--self:showNewDengLuLayer()
	self:showQianDaoLayer(1)
end


function LobbyLogic:showYouXiTanChu(initParam,ccbName)
	self.YouXiTanChuLayer = nil;
	if gBaseLogic.sceneManager.popUps["YouXiTanChuLayer"]~=nil then
		gBaseLogic.sceneManager.popUps["YouXiTanChuLayer"].view:onPressBack()
    end
	self.YouXiTanChuLayer = izx.basePage.new(self,"YouXiTanChuLayer","moduleLobby",{
			pageType = izx.basePage.PAGE_TYP_CCB,
			ccbFileName = (ccbName == nil and "interfaces/YouXiTanChu.ccbi" or ccbName),
			ccbController = "YouXiTanChu",
			initParam = initParam,
			targetX = display.cx,
			targetY = display.cy
		}
	);
	self.YouXiTanChuLayer:addToScene({});
end

-- function LobbyLogic:showConfirmBox(initParam)
-- 	self.ConfirmBoxLayer = izx.basePage.new(self,"ConfirmBoxLayer","moduleLobby",{
-- 			pageType = izx.basePage.PAGE_TYP_CCB,
-- 			ccbFileName = "interfaces/ConfirmBox.ccbi",
-- 			ccbController = "YouXiTanChu",
-- 			initParam = initParam,
-- 			targetX = display.cx,
-- 			targetY = display.cy
-- 		}
-- 	);
-- 	self.ConfirmBoxLayer:addToScene({});
-- end

function LobbyLogic:showTouXiangGengXin(initParam)
	self.TouXiangGengXinLayer = izx.basePage.new(self,"TouXiangGengXinLayer","moduleLobby",{
			pageType = izx.basePage.PAGE_TYP_CCB,
			ccbFileName = "interfaces/TouXiangGengXin.ccbi",
			ccbController = "TouXiangGengXin",
			initParam = initParam,
			targetX = display.cx,
			targetY = display.cy
		}
	);
	self.TouXiangGengXinLayer:addToScene({});
end

--新手提示
function LobbyLogic:showXinShouTiShiLayer(num)
	
	if (MAIN_GAME_ID==11 and num==1) then 
		return 
	end
	self.XinShouTiShiLayer = izx.basePage.new(self,"XinShouTiShiLayer","moduleLobby",{
			pageType = izx.basePage.PAGE_TYP_CCB,
			ccbFileName = "interfaces/XinShouTiShi"..num..".ccbi",
			ccbController = "XinShouTiShi",
			targetX = display.cx,
			targetY = display.cy,
			initParam = {num=num}
		}
	);
	self.XinShouTiShiLayer:addToScene({});
end

--充值奖励任务
function LobbyLogic:showChongZhiJiangLiLayer()
		self.ChongZhiJiangLiLayer = izx.basePage.new(self,"ChongZhiJiangLiLayer","moduleLobby",{
				pageType = izx.basePage.PAGE_TYP_CCB,
				ccbFileName = "interfaces/ChongZhiJiangLi.ccbi",
				ccbController = "ChongZhiJiangLi",
				targetX = display.cx,
				targetY = display.cy,

			}
		);
		self.ChongZhiJiangLiLayer:addToScene({});
end
function LobbyLogic:showChongZhiShangPin(initParam)
	self.ChongZhiShangPinLayer = izx.basePage.new(self,"ChongZhiShangPinLayer","moduleLobby",{
			pageType = izx.basePage.PAGE_TYP_CCB,
			ccbFileName = "interfaces/ChongZhiShangPin.ccbi",
			ccbController = "ChongZhiShangPin",
			targetX = display.cx,
			targetY = display.cy,
			initParam = initParam
		}
	);
	self.ChongZhiShangPinLayer:addToScene({});
end
function LobbyLogic:showMeiRiBiZuoLayer()
	self.MeiRiBiZuoLayer = izx.basePage.new(self,"MeiRiBiZuoLayer","moduleLobby",{
			pageType = izx.basePage.PAGE_TYP_CCB,
			ccbFileName = "interfaces/MeiRiBiZuo.ccbi",
			ccbController = "MeiRiBiZuo",
			targetX = display.cx,
			targetY = display.cy,
			
		}
	);
	self.MeiRiBiZuoLayer:addToScene({});
end
function LobbyLogic:showTaskScene()
	
	self.taskScene = nil
	self.taskScene = izx.basePage.new(self,"TaskScene","moduleLobby",{
			pageType = izx.basePage.PAGE_TYP_CCB,
			ccbFileName = "interfaces/RenWu.ccbi",
			ccbController = "taskControll"
		}
	);
	self.taskScene:enterScene(true);
end
function LobbyLogic:showBiSaiChang()
	self.BiSaiChangScene = nil
	self.BiSaiChangScene = izx.basePage.new(self,"BiSaiChangScene","moduleLobby",{
			pageType = izx.basePage.PAGE_TYP_CCB,
			ccbFileName = "interfaces/BiSaiChang.ccbi",
			ccbController = "biSaiChangControll"
		}
	);
	self.BiSaiChangScene:enterScene(false);
end

function LobbyLogic:showBiSaiWinScene()
	self.BiSaiWinScene = izx.basePage.new(self,"BiSaiWinScene","moduleLobby",{
			pageType = izx.basePage.PAGE_TYP_CCB,
			ccbFileName = "interfaces/BiSaiChangShengLi.ccbi",
			ccbController = "biSaiWinControll"
		}
	);
	self.BiSaiWinScene:enterScene(false);
end

function LobbyLogic:showBiSaiFailScene(initParam)
	if (gBaseLogic.gameLogic) then
		if (gBaseLogic.gameLogic.resDir) then
			izx.resourceManager:removeSearchPath(gBaseLogic.gameLogic.resDir);
		end
		if (gBaseLogic.gameLogic.onGameExit) then
			gBaseLogic.gameLogic:onGameExit();
		end
		gBaseLogic.gameLogic = nil;
	end
	if self.needShowMatchResult then
		self.needShowMatchResult = nil;
		self:showBiSaiWinScene()
	else
		self.BiSaiFailScene = izx.basePage.new(self,"BiSaiFailScene","moduleLobby",{
				pageType = izx.basePage.PAGE_TYP_CCB,
				ccbFileName = "interfaces/BiSaiChangShu.ccbi",
				ccbController = "biSaiFailControll",
				initParam = initParam
			}
		);
		self.BiSaiFailScene:enterScene(false);
	end
	gBaseLogic.currentState = gBaseLogic.stateInLobby;
	--BiSaiFailScene:addToScene({clickMaskToClose=false});
end

function LobbyLogic:showHelpScene()
	local NewHelpScene = izx.basePage.new(self,"NewHelpScene","moduleLobby",{
			pageType = izx.basePage.PAGE_TYP_CCB,
			ccbFileName = "interfaces/WebView.ccbi",
			ccbController = "webViewControll"
		}
	);
	NewHelpScene:enterScene(false);
end

function LobbyLogic:showHelpScene2()
	
	self.HelpScene = izx.basePage.new(self,"HelpScene","moduleLobby",{
			pageType = izx.basePage.PAGE_TYP_CCB,
			ccbFileName = "interfaces/BangZhu.ccbi",
			ccbController = "bangZhucontroll"
		}
	);
	self.HelpScene:enterScene(false);
end

function LobbyLogic:EnterLobby(initParam)
	self.lobbyScene = nil
	if (initParam ==nil) then
		initParam = {};
	end
	self.lobbyScene = izx.basePage.new(self,"LobbyScene","moduleLobby",{
			pageType = izx.basePage.PAGE_TYP_CCB,
			ccbFileName = "interfaces/DaTing.ccbi",
			ccbController = "daTingControll",
			slideIn = "right",
			initParam = initParam
		}
	);
	local block = false;
	if initParam~=nil and initParam.isFirstRun then
		block = true
	end
	
	self.lobbyScene:enterScene(block);
	gBaseLogic.currentState = gBaseLogic.stateInLobby;

	-- self:checkEvaluate()
	

end
function LobbyLogic:checkEvaluate()
	if (device.platform=="ios" and gBaseLogic.MBPluginManager.distributions.noevaluate==false) then
		local fTime = CCUserDefault:sharedUserDefault():getIntegerForKey("evaluate_time",-1);
		local fzeit = CCUserDefault:sharedUserDefault():getStringForKey("evaluate_zeit",-1);
		local currTime = get00ofday()
		fTime = tonumber(fTime)
		fzeit = tonumber(fzeit)
		currTime = tonumber(currTime)
		if(fTime == -1 ) then
			print("fTime:",fTime)
			self:reqGetEvaluate();
			
		elseif fTime == 2 then
			--不需提醒
			local fDuration = currTime - fzeit;
			if fDuration>=7*86400 then
				self:reqGetEvaluate();			
			end
		elseif fTime==1 then
			--以后再说 
			local fDuration = currTime - fzeit;
			print("fDuration:",fDuration);
			if(fDuration >= 86400)then
				self:reqGetEvaluate();
	        end
		elseif fTime == 3 then
			--现在去评
			local fDuration = currTime - fzeit;
			if fDuration>=30*86400 then
				self:reqGetEvaluate();			
			end
		end
	end
end
-- function LobbyLogic:checkEvaluate()
-- 	if (device.platform=="ios" and gBaseLogic.MBPluginManager.distributions.noevaluate==false) then
-- 		local fTime = CCUserDefault:sharedUserDefault():getIntegerForKey("evaluate_time",-1);
-- 		local fzeit = CCUserDefault:sharedUserDefault():getFloatForKey("evaluate_zeit",-1);
-- 		local currTime = get00ofday()
-- 		fTime = tonumber(fTime)
-- 		fzeit = tonumber(fzeit)
-- 		currTime = tonumber(currTime)
-- 		--fTime==3 已经评价而且获得奖励

-- 		if fTime~=3 then
-- 			local order = CCUserDefault:sharedUserDefault():getFloatForKey("evaluate_order")
-- 			if order~="" then
-- 				local url = string.gsub(URL.AWARDEVALUATE,"{pid}",self.userData.ply_guid_);
				
-- 				url = string.gsub(url,"{order}",order);
				
-- 				print("url:",url)
-- 				gBaseLogic:HTTPGetdata(url,0,function(event)
-- 					--可以评分
-- 					print("URL.AWARDEVALUATE")
-- 					var_dump(event)
-- 					if event.ret == 0 then
-- 						izxMessageBox("感谢您的评分支持，送您一些游戏币", "t提示")
-- 						-- if event.url ~= nil then
-- 						-- 	local evaluateUrl = event.url;
-- 						-- 	CCUserDefault:sharedUserDefault():setFloatForKey("evaluate_order",event.order)
-- 						-- 	self:setEvaluateTime(1)
-- 			   --      	end
-- 			   			self:setEvaluateTime(3);
-- 					else
-- 						self:checkEvaluateto()
-- 					end
-- 				end)
-- 			else
-- 				self:checkEvaluateto()
-- 			end
-- 		end
-- 		-- if(fTime == -1 ) then
-- 		-- 	print("fTime:",fTime)
-- 		-- 	self:reqGetEvaluate();
			
-- 		-- elseif fTime == 2 then
-- 		-- 	--不需提醒
-- 		-- 	local fDuration = currTime - fzeit;
-- 		-- 	if fDuration>=7*86400 then
-- 		-- 		self:reqGetEvaluate();			
-- 		-- 	end
-- 		-- elseif fTime==1 then
-- 		-- 	--以后再说 
-- 		-- 	local fDuration = currTime - fzeit;
-- 		-- 	print("fDuration:",fDuration);
-- 		-- 	if(fDuration >= 86400)then
-- 		-- 		self:reqGetEvaluate();
-- 	 --        end
-- 		-- end
-- 	end
-- end
-- --请求评分奖励
-- function LobbyLogic:reqGetEvaluate()
-- 	--获取mac

-- 	local url = string.gsub(URL.AWARDEVALUATE,"{pid}",self.userData.ply_guid_);
-- 	local order = CCUserDefault:sharedUserDefault():getFloatForKey("evaluate_order")
-- 	if order~="" then
-- 		url = string.gsub(url,"{order}",order);
		
-- 		print("url:",url)
-- 		gBaseLogic:HTTPGetdata(url,0,function(event)
-- 			--可以评分
-- 			if event.ret == 0 then
-- 				if event.url ~= nil then
-- 					local evaluateUrl = event.url;
-- 					CCUserDefault:sharedUserDefault():setFloatForKey("evaluate_order",event.order)
-- 					self:setEvaluateTime(1)
-- 	        	end
-- 			else
-- 			end
-- 		end)
-- 	end
-- end


--请求 评分 功能
function LobbyLogic:reqGetEvaluate()
	--获取mac

	local mac = gBaseLogic.MBPluginManager:getMacAddress();
	if mac ~= nil then
		local url = string.gsub(URL.GETEVALUATE,"{pid}",self.userData.ply_guid_);
		url = string.gsub(url,"{ticket}",self.userData.ply_ticket_);
		url = string.gsub(url,"{mac}",mac);
		url = string.gsub(url,"{packageName}",gBaseLogic.packageName);
		print("url:",url)
		gBaseLogic:HTTPGetdata(url,0,function(event)
			--可以评分

			if event.ret == 0 then
				if event.url ~= nil then
					print("LobbyLogic:reqGetEvaluate")
					local evaluateUrl = event.url;
					print("order:"..event.order)
					-- CCUserDefault:sharedUserDefault():setStringForKey("evaluate_order",tostring(event.order))
					-- self:setEvaluateTime(1)
					print(evaluateUrl)
					
					self:showPingJia({evaluateUrl=evaluateUrl})	
	        	end
			end
		end)
	end
end
function LobbyLogic:setEvaluateTime(times)
	CCUserDefault:sharedUserDefault():setIntegerForKey("evaluate_time",times);
	CCUserDefault:sharedUserDefault():setStringForKey("evaluate_zeit",get00ofday());
end
function LobbyLogic:showPingJia(initParam)
	self.pingjiaLayer = izx.basePage.new(self,"pingjiaLayer","moduleLobby",{
			pageType = izx.basePage.PAGE_TYP_CCB,
			ccbFileName = "interfaces/PingJia.ccbi",
			ccbController = "pingjia",
			targetX = display.cx,
			targetY = display.cy,
			initParam=initParam
		}
	);
	self.pingjiaLayer:addToScene({clickMaskToClose=false});
end
function LobbyLogic:showSafeScene()
	self.safeScene = nil
	self.safeScene = izx.basePage.new(self,"SafeScene","moduleLobby",{
			pageType = izx.basePage.PAGE_TYP_CCB,
			ccbFileName = "interfaces/BaoXianXiang.ccbi",
			ccbController = "safeControll"
		}
	);
	self.safeScene:enterScene();
end

function LobbyLogic:showShopScene()
	
	self.shopScene = nil
	self.shopScene = izx.basePage.new(self,"ShopScene","moduleLobby",{
			pageType = izx.basePage.PAGE_TYP_CCB,
			ccbFileName = "interfaces/ShangDianNew.ccbi",
			ccbController = "shopControll"
		}
	);
	self.shopScene:enterScene(true);
end
function LobbyLogic:showPaiHangBangScene()
	self.paiHangBangScene = nil
	self.paiHangBangScene = izx.basePage.new(self,"PaiHangBangScene","moduleLobby",{
			pageType = izx.basePage.PAGE_TYP_CCB,
			ccbFileName = "interfaces/PaiHangBang2.ccbi",
			ccbController = "paiHangBangControll"
		}
	);
	self.paiHangBangScene:enterScene(true);
end
--from:1 从登录奖励进入
function LobbyLogic:gotoVipShop(from)

	self.shopScene = nil
	self.shopScene = izx.basePage.new(self,"ShopScene","moduleLobby",{
			pageType = izx.basePage.PAGE_TYP_CCB,
			ccbFileName = "interfaces/ShangDianNew.ccbi",
			ccbController = "shopControll",
			initParam = {type=1}
		}
	);
	self.shopScene:enterScene(false);
end

function LobbyLogic:showGoldExchangeScene()
	
	self.goldExchangeScene = nil
	self.goldExchangeScene = izx.basePage.new(self,"GoldExchangeScene","moduleLobby",{
			pageType = izx.basePage.PAGE_TYP_CCB,
			ccbFileName = "interfaces/DuiHuan.ccbi",
			ccbController = "exChangeControll"
		}
	);
	self.goldExchangeScene:enterScene(true);
end
              
function LobbyLogic:showPromotionScene()
	self.promotionScene = nil
	self.promotionScene = izx.basePage.new(self,"PromotionScene","moduleLobby",{
			pageType = izx.basePage.PAGE_TYP_CCB,
			ccbFileName = "interfaces/Tuiguang.ccbi",
			ccbController = "promoteControll"
		}
	);
	self.promotionScene:enterScene();
	self.promotionScene.ctrller:getPromote();
end

function LobbyLogic:showActivationCodeScene()
	
	self.activationCodeScene = nil
	self.activationCodeScene = izx.basePage.new(self,"ActivationCodeScene","moduleLobby",{
			pageType = izx.basePage.PAGE_TYP_CCB,
			ccbFileName = "interfaces/JiHuoMa.ccbi",
			ccbController = "activityCodeControll"
		}
	);
	self.activationCodeScene:enterScene();
end

function LobbyLogic:showAwardExchangeScene()

	self.awardExchangeScene = nil;
	self.awardExchangeScene = izx.basePage.new(self, "AwardExchangeScene", "moduleLobby", 
		{
			pageType = izx.basePage.PAGE_TYP_CCB, 
			ccbFileName = "interfaces/AwardExchangeScene.ccbi", 
			ccbController = "AwardExchangeSceneController"
		}
	);
	self.awardExchangeScene:enterScene();
end

function LobbyLogic:showPokerKingScene()
	
	self.pokerKingScene = nil
	self.pokerKingScene = izx.basePage.new(self,"PokerKingScene","moduleLobby",{
			pageType = izx.basePage.PAGE_TYP_CCB,
			ccbFileName = "interfaces/PaiHangBang.ccbi",
			ccbController = "pokerKingControll"
		}
	)
	self.pokerKingScene:enterScene(true);
end

function LobbyLogic:showNoticeScene()
	
	--self.noticeScene = nil
	--self.noticeScene = izx.basePage.new(self,"NoticeScene","moduleLobby",{
	--		pageType = izx.basePage.PAGE_TYP_CCB,
	--		ccbFileName = "interfaces/GongGao.ccbi",
	--		ccbController = "noticeControll"
	--	}
	--);
	--self.noticeScene:enterScene(true);

	self.noticeScene = nil
	if (MAIN_GAME_ID==13) then
		self.noticeScene = izx.basePage.new(self,"HuoDongScene","moduleLobby",{
				pageType = izx.basePage.PAGE_TYP_CCB,
				ccbFileName = "interfaces/HuoDong.ccbi",
				ccbController = "huodongControll"
			}
		);
	else
		self.noticeScene = izx.basePage.new(self,"HuoDongScene","moduleLobby",{
			pageType = izx.basePage.PAGE_TYP_CCB,
			ccbFileName = "interfaces/WebView.ccbi",
			ccbController = "webViewControll"
		}
	);
	end
	self.noticeScene:enterScene(false);

end

function LobbyLogic:showTaskScene()
	
	self.taskScene = nil
	self.taskScene = izx.basePage.new(self,"TaskScene","moduleLobby",{
			pageType = izx.basePage.PAGE_TYP_CCB,
			ccbFileName = "interfaces/RenWu.ccbi",
			ccbController = "taskControll"
		}
	);
	self.taskScene:enterScene(true);
end

function LobbyLogic:showMiniGameList()
	self.miniGameList = nil
	self.miniGameList = izx.basePage.new(self,"MiniGameList","moduleLobby",{
			pageType = izx.basePage.PAGE_TYP_CODE
		}
	);
	self.miniGameList:addToScene({block=true});
end

function LobbyLogic:showGameList(type)
	self.gamePageList = nil
	self.gamePageList = izx.basePage.new(self,"GamePageList","moduleLobby",{
			pageType = izx.basePage.PAGE_TYP_CODE,
			initParam = {type=type},
			
		}
	);
	local block = false;
	if type==2 then
		block=true
	end
	self.gamePageList:addToScene({block=block,targetX=display.cx,
			targetY=display.cy,
			slideIn = "left"});
	
end

-- function LobbyLogic:getCharacterNameChangeHTTP()
--     local url = string.gsub(URL.NAMECHANGE,"{pid}",self.userData.ply_guid_); --test
--     echoInfo("checking nikename is change: "..url);
--     --"http://statics.hiigame.com/get/modify/count.do"
--     --"uid=1113134339110250"
--     gBaseLogic:HTTPGetdata(url, 0, function(event)
-- 	    	if event.count then 
-- 	        self.haschangename = true
-- 	        else
-- 	        self.haschangename = false	
-- 	    	end
--         end)
-- end 

function LobbyLogic:analyseOnlineParam(event)
	local myVersion = gBaseLogic.MBPluginManager:getVersionInfo();
    var_dump(myVersion)
    self.ver_codes = 0
	if(event.ver_codes ~= nil)then
		self.ver_codes = event.ver_codes
	end
	if event.qq ~= nil then
		self.helpDesk = event.qq
	end
	print("gBaseLogic.MBPluginManager.distributions.hasnewminegameanalyseOnlineParam")
	var_dump(event)
	if(event.hasnewminegame~=nil and event.hasnewminegame==1)then
		print("1213")
		gBaseLogic.MBPluginManager.distributions.hasnewminegame = true;
	end
	if (event.forceuseDirectSMS~=nil and event.forceuseDirectSMS==1)then
		gBaseLogic.MBPluginManager.distributions.forceuseDirectSMS = true
	end
	if tonumber(self.ver_codes)==0 then
		return;
	end
	if(tonumber(self.ver_codes) <= tonumber(myVersion.version_code)) then
    	if(event.jihuoma ~= nil and event.jihuoma==1)then
    		self.jihuoma = event.jihuoma
    		gBaseLogic.MBPluginManager.distributions.nojihuoma=true;
    	end
    	if(event.vip ~= nil and event.vip==1)then
    		self.vip = event.vip
    		gBaseLogic.MBPluginManager.distributions.novip=true;
    	end
    	if(event.promotion ~= nil and event.promotion==1)then
    		self.promotion = event.promotion
    		gBaseLogic.MBPluginManager.distributions.nopromotion=true;
    	end
    	if(event.exitgame ~= nil and event.exitgame==1)then
			self.exitgame = event.exitgame;
			gBaseLogic.MBPluginManager.distributions.noexitgame=true;
		end
		if(event.activity ~= nil and event.activity==1)then
			self.activity = event.activity;
			gBaseLogic.MBPluginManager.distributions.noactivity=true;
		end
		if(event.minigamedownload ~= nil and event.minigamedownload==1)then
			self.minigamedownload = event.minigamedownload;
			gBaseLogic.MBPluginManager.distributions.nominigamedownload=true;
		end
		if(event.gonggao ~= nil and event.gonggao==1)then
			self.gonggao = event.gonggao;
			gBaseLogic.MBPluginManager.distributions.nogonggao=true;
		end
		if(event.safe~=nil and event.safe==1)then
			gBaseLogic.MBPluginManager.distributions.nosafe=true;
			self.safe = event.safe;
		end
		if(event.minigame~=nil and event.minigame==1)then
			gBaseLogic.MBPluginManager.distributions.nominigame=true;
		end
		if(event.guidhelp~=nil and event.guidhelp==1)then
			self.guidhelp = event.guidhelp;
			gBaseLogic.MBPluginManager.distributions.noguidhelp=true;
		end
		if(event.evaluate~=nil and event.evaluate==1)then
			self.evaluate = event.evaluate;
			gBaseLogic.MBPluginManager.distributions.noevaluate=true;
		end
		if(event.checkapple~=nil and event.checkapple==1)then
			self.checkapple = event.checkapple;
			gBaseLogic.MBPluginManager.distributions.checkapple=true;
		end
		
		--强制支付方式 1;yymm 2:wow 3  电信
		if(event.forceusesimtyp~=nil and event.forceusesimtyp>=1 and event.forceusesimtyp<=3)then
			gBaseLogic.MBPluginManager.distributions.forceusesimtyp = event.forceusesimtyp;
		end
		if(event.skipupgrade~=nil and event.skipupgrade==1)then
			gBaseLogic.MBPluginManager.distributions.skipupgrade = true;
		end

		if(event.nojumpToExtend~=nil and event.nojumpToExtend==1)then
			gBaseLogic.MBPluginManager.distributions.jumpToExtend = false;
		end
		if(event.noshowPingCoo~=nil and event.noshowPingCoo==1)then
			gBaseLogic.MBPluginManager.distributions.showPingCoo = false;
		end
		if(event.disablematch~=nil and event.disablematch==1)then
			gBaseLogic.MBPluginManager.distributions.disablematch = true;
		end
	end
end

function LobbyLogic:getFunctionStatus()
	if (ONLINE_PARAM~=nil) then
		self:analyseOnlineParam(ONLINE_PARAM);
		gBaseLogic:LoadpayList();
		gBaseLogic.lobbyLogic:showLoginScene(false,{isFirstRun=true});
	else
	    local url = string.gsub(URL.GETFUNCTIONSTATUS,"{pName}",gBaseLogic.packageName ..".config2");--"com.izhangxin.zjh.ios.as.config2"
	    echoInfo("checking url is: "..url);
	    --"http://statics.hiigame.com/get/modify/count.do"
	    --"uid=1113134339110250"
	    
	    gBaseLogic:HTTPGetdata(url, 0, function(event)
	    		var_dump(event)

		        if (event ~= nil and event ~= -1) then
		        	self:analyseOnlineParam(event);		        	
			    end
			    gBaseLogic:LoadpayList();
				gBaseLogic.lobbyLogic:showLoginScene(false,{isFirstRun=true});

	        end)
	end
end

function LobbyLogic:getCharacterNameChangeHTTP()
    local url = string.gsub(URL.NAMECHANGE,"{pid}",self.userData.ply_guid_); --test
    echoInfo("checking nikename is change: "..url);
    --"http://statics.hiigame.com/get/modify/count.do"
    --"uid=1113134339110250"
    gBaseLogic:HTTPGetdata(url, 0, function(event)
	    	if event.count then 
	        self.haschangename = true
	        else
	        self.haschangename = false	
	    	end
        end)
end 

function LobbyLogic:showPersonalInformationScene(initParam)
	
	self.personalScene = nil
	self.personalScene = izx.basePage.new(self,"PersonalScene","moduleLobby",{
			pageType = izx.basePage.PAGE_TYP_CCB,
			ccbFileName = "interfaces/GeRenXinXi.ccbi",
			ccbController = "informationControll",
			initParam = initParam
		}
	);
	self.personalScene:enterScene(false);
	if (MAIN_GAME_ID==13) then
		self:requestHTTPAchieve(self.userData.ply_guid_,1);
	end
end


function LobbyLogic:onCheckGameModules(msg)
	
    local event = json.decode(msg);
    if (event.e == 'progress') then
    	self:dispatchLogicEvent({
	        name = "MSG_PLUGIN_ASSET_PROGRESS",
	        message = {plugin=self.upgradingPluginModule,
	        			package = event.p,
	        			progress = event.data
	    	}
	    })
    elseif (event.e == "success") then
    	self:dispatchLogicEvent({
	        name = "MSG_PLUGIN_ASSET_SUCCESS",
	        message = {plugin=self.upgradingPluginModule,
	        			typ="DOWNLOAD"
	    	}
	    })
    elseif (event.e == "error") then
    	if (event.type == "errorNoNewVersion") then
    		self:dispatchLogicEvent({
		        name = "MSG_PLUGIN_ASSET_SUCCESS",
		        message = {plugin=self.upgradingPluginModule,
		        			typ="NO_NEW_VERSION"
		    	}
		    })
		else
			self:dispatchLogicEvent({
	        name = "MSG_PLUGIN_ASSET_ERROR",
	        message = {plugin=self.upgradingPluginModule,
	        			typ=event.type
	    	}
	    })
    	end
    end
end


function LobbyLogic:onSocketOpen()
	gBaseLogic.MBPluginManager:logEventLabelMyEnd("LOGIN_STEP_DURA","connectLobby");
	self:reqLogin();
end

function LobbyLogic:onSocketClose()
	self.lobbySocket = nil;
	self.otherplayin = 2;
	self:onKickNet("网络断开，请检查网络");
end

function LobbyLogic:onConnectFailure()
	self.lobbySocket = nil;
	self:onKickNet("网络连接失败，请检查网络");
end

function LobbyLogic:reqLogin()	
	print("LobbyLogic:reqLogin")
	gBaseLogic.MBPluginManager:logEventLabelMyBegin("LOGIN_STEP_DURA","socketLobbyLogin");
	gBaseLogic.MBPluginManager:logEventEnd("loginDuration");
	gBaseLogic:blockUI({autoUnblock=false,msg=LOGIN_LOADING_TIPS3,hasCancel=true,callback=handler(gBaseLogic,gBaseLogic.onPressCancelLogin)});
	 gBaseLogic.inGamelist = -1;
	local socketMsg = {opcode = 'pt_cl_verify_ticket_req',
						ply_guid_ = tonumber(self.userData.ply_guid_),
						ply_nickname_ = self.userData.ply_nickname_,
						ply_ticket_ = self.userData.ply_ticket_,
						game_id_ = MAIN_GAME_ID,
						version_ = CASINO_VERSION_DEFAULT,
						ext_param_ = '',
						sex_ = self.userData.ply_sex,
						packet_name_ = gBaseLogic.packageName,

	};
	if self.lobbySocket==nil then
		self:closeSocket();
        gBaseLogic:unblockUI();
        self:onNoNet(2,"登录失败，请检查网络");
        gBaseLogic.onLogining = false;
        return
	end
	self:sendLobbySocket(socketMsg);
	-- self.lobbyResendCounter = 0;
	-- local _loginTimeTick = function ()
	-- 	self.lobbyResendCounter = self.lobbyResendCounter+1;
	-- 	if (self.lobbyResendCounter>5) then
	--         self:closeSocket();
	--         gBaseLogic:unblockUI();
	--         self:onNoNet(2,"登录失败，请检查网络");
	--         gBaseLogic.onLogining = false;
	--     else
	--     	self:sendLobbySocket(socketMsg);
	--     	self.loginTimeTickScheduler = scheduler.performWithDelayGlobal(_loginTimeTick, 2)
	--     end
 --    end
 --    self.loginTimeTickScheduler = scheduler.performWithDelayGlobal(_loginTimeTick, 2)

end

function LobbyLogic:onSocketMessage(message)
	if self.loginTimeTickScheduler then 
        scheduler.unscheduleGlobal(self.loginTimeTickScheduler) 
    end
	print ("lobby get Messgage::" .. message.opcode);	
	-- var_dump(message);
	if (self[message.opcode .. "_handler"]~=nil) then
		print("11111");
		self[message.opcode .. "_handler"](self,message);
		return;
	else
		--echoError("------------------ 没有处理函数的消息: [%s] !!!!!!!!!!!!!!!!",message.opcode);
		print("11112");
		self:dispatchLogicEvent({
	        name = "MSG_SOCK_"..message.opcode,
	        message = message
	    })
	end
end
-- function LobbyLogic:pt_lc_get_user_already_login_days_ack_handler(message)
-- 	print("pt_lc_get_user_already_login_days_ack_handler")
-- 	var_dump(message)
-- 	self:dispatchLogicEvent({
-- 	        name = "MSG_SOCK_"..message.opcode,
-- 	        message = message
-- 	    })
-- 	print("MSG_SOCK_"..message.opcode)
-- end
function LobbyLogic:pt_lc_item_config_not_handler(message)
	print("LobbyLogic:pt_lc_item_config_not_handler")
	var_dump(message.item_list_)
	if message.item_list_~=nil then
		gBaseLogic.gameItems = nil 
		gBaseLogic.gameItems = {};
		for k,v in pairs(message.item_list_) do
			gBaseLogic.gameItems[v] = 1;
		end
	end
end
function LobbyLogic:pt_lc_send_friend_msg_not_handler(message)
	-- table.insert(self.guangBaoList,message.message_);
	print("=pt_lc_send_friend_msg_not_handler")
	var_dump(message,4)
	-- self.mailMsg = message.content_
	print("=pt_lc_send_friend_msg_not_handler")
	-- CCUserDefault:sharedUserDefault():setStringForKey("mailMsg","")
	local oldContent =CCUserDefault:sharedUserDefault():getStringForKey("mailMsg"..self.userData.ply_guid_)
	print("=pt_lc_:::"..oldContent)
	local oldmsgList = {}
	if (oldContent==nil or oldContent=="") then
		oldmsgList = {}	 	
	 else
	 	oldmsgList = json.decode(oldContent)
	 end
	if message.content_ ~= nil then
 		for k,v in pairs(message.content_) do
 			if oldmsgList[v.snd_ply_guid_ .."_"..v.time_]==nil then
 				self.hasNewMsg = 1; 				
 			end
 			if message.content_[k].message_~=nil then
				message.content_[k].message_ = gBaseLogic.MBPluginManager:replaceText(v.message_)
			end
 		end 		 
 	end
	
	self:dispatchLogicEvent({
	        name = "MSG_SOCK_"..message.opcode,
	        message = message
	    })
end

function LobbyLogic:pt_lc_trumpet_not_handler(message)

	print(" pt_lc_trumpet_not  message = "..message.message_)
	-- var_dump(gBaseLogic.MBPluginManager.distributions.trumpetFilterWords)
	if gBaseLogic.MBPluginManager.distributions.nogonggao then
		return
	end
	for k,v in pairs(gBaseLogic.MBPluginManager.distributions.trumpetFilterWords) do
		local m = string.find(message.message_,v)
		
		if m ~= nil then
			print("trumpet fliter")
			return 
		end
	end

    local i,j = string.find(message.message_,"<C")
    if i == 1 then
    	echoInfo("chat <C┃┃   :::: j:"..j..",other:"..string.sub(message.message_,7));
        message.message_ = string.sub(message.message_,7);
        message.message_ = "【"..message.ply_nickname_.."】："..message.message_
    end
    i,j = string.find(message.message_,"<D")
    if i == 1 then
    	echoInfo("chat <D┃┃   :::: j:"..j..",other:"..string.sub(message.message_,7));
        message.message_ = string.sub(message.message_,7);
        message.message_ = "【"..message.ply_nickname_.."】："..message.message_
    end
    i,j = string.find(message.message_,"<E")
    if i == 1 then
    	echoInfo("chat <E┃┃   :::: j:"..j..",other:"..string.sub(message.message_,7));
        message.message_ = string.sub(message.message_,7);
        message.message_ = "【"..message.ply_nickname_.."】："..message.message_
    end

	message.message_ = gBaseLogic.MBPluginManager:replaceText(message.message_)

	if i ~= 1 then
		--if 0 == message.ply_guid_ then
		if 0 == message.ply_nickname_ then
	        message.message_  = ("【系统】:" .. message.message_)
	    else
	        message.message_  = ("【" .. message.ply_nickname_ .. "】:" .. message.message_)
	    end
	end
	if message.message_=="" then
		return;
	end
	table.insert(self.guangBaoList,message.message_);
	if (#self.guangBaoList > 50) then
		table.remove(self.guangBaoList,1)
	end
	self:dispatchLogicEvent({
	        name = "MSG_SOCK_"..message.opcode,
	        message = message
	    })
end
--vip change
function LobbyLogic:pt_lc_send_vip_data_change_not_handler(message)
	print("LobbyLogic:pt_lc_send_vip_data_change_not")
	var_dump(message)
	self.vipData.vipLevel = message.vipLevel
	self.vipData.vipRate = message.vipRate
	self.vipData.nextVipneedMoney = message.nextVipneedMoney
	self.vipData.param_ = message.param_
	self:dispatchLogicEvent({
        name = "MSG_Socket_"..message.opcode,
        message = message
    })
    -- izxMessageBox("pt_lc_send_vip_data_change_not", "notic")
end
function LobbyLogic:pt_lc_send_user_data_change_not_handler(message)
	print("LobbyLogic:pt_lc_send_user_data_change_not_handler")
	var_dump(message)
	local oldMoney = self.userData.ply_lobby_data_.money_;
	local olddueDays = self.userData.ply_vip_.remain_due_days_
	self.userData.ply_lobby_data_ = message.ply_lobby_data_;
	self.userData.ply_nickname_ = message.ply_lobby_data_.nickname_;
	self.userData.ply_items_ = message.ply_items_;
	self.userData.items_user = {}
	for k,v in pairs(message.ply_items_) do
		self.userData.items_user[v.index_] = v;
	end
	self.userData.ply_vip_ = message.ply_vip_;
	if self.userData.ply_lobby_data_.money_-oldMoney>=40000 or self.userData.ply_vip_.remain_due_days_>olddueDays then
		-- self:getChongZhiJiangLiData()
		self:reqDoublechestData()
	end
	self:onUpdataRobortData(message)
	--var_dump(self.userData.ply_items_);
	self:dispatchLogicEvent({
	        name = "MSG_Socket_"..message.opcode,
	        message = message
	    })
	
end 

function LobbyLogic:onUpdataRobortData(message) 
	--if self.is_robot~=0 then 
		local num = self.userData.items_user[58].num_
	    if num > 0 then 
	    	CCUserDefault:sharedUserDefault():setIntegerForKey("better_seat"..self.userData.ply_guid_,num)
	    end

	--end
end 

function LobbyLogic:showMatchTips(ms,newMatch)
	print("showMatchTips")
	gBaseLogic:unblockUI();
 	-- self:dispatchLogicEvent({
	 --        name = "MSG_Socket_pt_lc_match_perpare_notf",
	 --        message = ms
	 --    })
	--游戏中并且不是另一场比赛
	print(gBaseLogic.currentState)
	local config_matchTitle = {
        [1]="3元话费赛",
        [2]="10元话费赛",
        [3]="50元话费赛",
        [4]="100元话费赛",
        [5]="300元话费赛",
        [6]="500元话费赛",
    }
	if (gBaseLogic.currentState ~= gBaseLogic.stateInLobby and gBaseLogic.gameLogic~=nil) then 
		-- if gBaseLogic.gameLogic~=nil and gBaseLogic.gameModule=="modlueDdz" then
		-- end
		print("LobbyLogic:showMatchTips1")
		self.hasNewMatch = 1;
		self.newMatchInfo = ms;

		izxMessageBox("您有一场"..config_matchTitle[ms.match_type_].."即将开始，返回大厅立即进入比赛！", "提示")
	else 
		print("LobbyLogic:showMatchTips2")
		gBaseLogic:confirmBox({
        msg="您有一场"..config_matchTitle[ms.match_type_].."即将开始，准备进入比赛界面。",
        title = "通知信息",
        btnTitle={btnConfirm="确定"},
        buttonCount = 1,
        --closeWhenClick = true,
        callbackConfirm = function()
            print("stateInRealGame not:",self.BiSaiChangScene)
            --if self.BiSaiChangScene ~= nil then 
       --      	self:dispatchLogicEvent({
			    --     name = "MSG_Socket_pt_lc_match_perpare_notf",
			    --     message = self.matchData
			    -- })
            --end 
            if self.tmphander1 ~= nil then 
                scheduler.unscheduleGlobal(self.tmphander1)
            end
        	gBaseLogic.sceneManager.currentPage.view:closePopBox();
        	gBaseLogic.lobbyLogic:startMatchGame("moduleDdz",ms.match_id_,0)
        end})
        self.tmphander1 = scheduler.performWithDelayGlobal(function ()
    		gBaseLogic.sceneManager.currentPage.view:closePopBox();
        	gBaseLogic.lobbyLogic:startMatchGame("moduleDdz",ms.match_id_,0)
    		end, 2.0)
        
	end
	
end 

    -- int match_id_;
    -- int match_order_id_;
    -- int param_；
-- function LobbyLogic:pt_bc_rematch_notf_handler(message) 
-- 	print("pt_bc_rematch_notf_handler,closeGameErr:",closeGameErr)
-- 	self.closeGameErr=2
-- 	self.rematchData = nil 
-- 	self.rematchData = message
-- 	if (gBaseLogic.currentState ~= gBaseLogic.stateInRealGame) then
-- 		self:reEnterMatchGame(self.userData.ply_status_.game_id_,self.userData.ply_status_.game_server_id_ )

-- 	end
-- end 

    -- int match_id_;
    -- int match_order_id_;
    -- ServerData2 data_;
function LobbyLogic:pt_lc_match_perpare_notf_handler(message)
	print("pt_lc_match_perpare_notf_handler11",message.match_id_,message.match_order_id_)
	local newMatch = true

	self.match_current_score = message.current_score_
	message.server_id_change = 1;
	if self.matchData ~= nil then 
		for k,v in pairs(self.matchData) do
			if v.match_id_ == message.match_id_ then 
				if v.data_.server_id_ == message.data_.server_id_ then 
					message.server_id_change = 0;
			    end 
			    table.remove(self.matchData,k)
			    newMatch = false
			end
		end 
		--newMatch = true
	else 
		self.matchData = {}
	end
	message.newMatch = newMatch
    table.insert(self.matchData,message)
    
	self:showMatchTips(message,newMatch)
	self.matchLost = nil
end 

function LobbyLogic:pt_lc_match_round_avoid_notf_handler(message) 
	print("pt_lc_match_round_avoid_notf_handler")
	var_dump(message)

	self:dispatchLogicEvent({
	        name = "MSG_Socket_pt_lc_match_round_avoid_notf",
	        message = message
	    })
end 

function LobbyLogic:pt_lc_match_round_end_notf_handler(message)
	print("pt_lc_match_round_end_notf_handler")
	var_dump(message,3)
	-- if self.matchLost == nil then	 
 --    	self.matchLost = message
 --    end
    self:dispatchLogicEvent({
	        name = "MSG_Socket_pt_lc_match_round_end_notf",
	        message = message
	    })
end

function LobbyLogic:pt_lc_match_lost_notf_handler(message)
	print("pt_lc_match_lost_notf_handler")
	var_dump(message,3)
	self.matchLost = nil
	self.matchLost = {}
    self.matchLost = message

    --self:showBiSaiFailScene()

    self:dispatchLogicEvent({
	        name = "MSG_Socket_pt_lc_match_lost_notf",
	        message = self.matchLost
	    })
end 

function LobbyLogic:pt_lc_match_result_notf_handler(message)
	print("pt_lc_match_result_notf_handler",message.match_id_)
	var_dump(message,3)
	for k,v in pairs(self.matchData) do 
        if v.matchid == message.match_id_ then 
            table.remove(self.matchData,k)
            break
        end
    end 
    self.matchResult = nil
    self.matchResult = {}
    self.matchResult = message

    if gBaseLogic.currentState == gBaseLogic.stateInLobby then 
    	self:showBiSaiWinScene()
    else
    	self.needShowMatchResult=true;
    	-- self:dispatchLogicEvent({
	    --     name = "MSG_Socket_pt_lc_match_result_notf_notf",
	    --     message = self.matchResult
	    -- })
	end
end 
function LobbyLogic:pt_lc_match_unfinished_notf_handler(message)
	local matchInfo = message.match_info_
	self.matchInfoNot = message.match_info_
	local initParam={noti=1,typ=0,match_id_=matchInfo.match_id_,match_type_=matchInfo.match_type_,match_order_id_=matchInfo.match_order_id_}
	self:showBiSaiFailScene(initParam);
end

function LobbyLogic:pt_lc_verity_ticket_ack_handler(message)

	if(gBaseLogic.MBPluginManager.distributions.sessionType~="")then
		if(self.loginScene ~= nil)then
			self.loginScene.view:setLoginStatus(1);
		end
	end

	gBaseLogic.onLogining = false;
	print("pt_lc_verity_ticket_ack_handler"..self.userData.ply_nickname_)
	gBaseLogic.MBPluginManager:logEventLabelMyEnd("LOGIN_STEP_DURA","socketLobbyLogin");

	var_dump(message.ply_vip_,3);
	gBaseLogic:unblockUI();
	if message.ret_ == 0 then
		self:requestHTTPPaymentItems(0);
		-- self:requestHTTPPaymentItems(1);
		-- 成功登录 
		-- var_dump(message.ply_items_);
		self.lobbyErr = 0;
		self.otherplayin = 0;
		self.isOnGameExit = 0
		self.userData.ply_lobby_data_ = message.ply_lobby_data_;
		self.userData.ply_nickname_ = message.ply_lobby_data_.nickname_;
		self.userData.ply_status_ = message.ply_status_;
 
		self.userData.ply_items_ = message.ply_items_;
	-- 	int	index_;
	-- int num_;
	-- int game_id_;				//Game ID
	-- int param_1_;				//??չ??1
	-- int param_2_;				//??չ??2
	-- string name_;				//???????
	-- string url_;				//?????ƬURL
		self.userData.items_user = {}
		for k,v in pairs(message.ply_items_) do
			self.userData.items_user[v.index_] = v;
		end
		self.userData.ply_login_award2_ = message.ply_login_award2_;
		self.userData.ply_vip_ = message.ply_vip_;

		self.userHasLogined = true;
		--gBaseLogic.onLogining = true;
		-- local ply_login_award2_ = self.ctrller.data.ply_login_award2_;
    -- var_dump(ply_login_award2_.login_award_);
    print("ticket======")
    	--var_dump(self.userData.ply_items_,4);
    	local plyStatus = message.ply_status_.ply_status_;
    	if plyStatus==2 or plyStatus==3 or plyStatus==5 then
    		self.closeGameErr = 1;
    		gBaseLogic:blockUI();
    		return;
    		-- self:startGameByError(message.ply_status_);
    	end
    	-- for match
    	-- if plyStatus==2 or plyStatus==3 or plyStatus==5 then
    	-- 	self.closeGameErr = 2;
    	-- 	gBaseLogic:blockUI();
    	-- 	return;
    	-- end
		if (MAIN_GAME_ID==10) then
			if (self.onReOpened==0) then
				if gBaseLogic.MBPluginManager.distributions.checkapple then
				else
					local strtime = CCUserDefault:sharedUserDefault():getStringForKey(gBaseLogic.ply_guid_.."QianDaoTime","")
					local curtime = os.date("%x", os.time())
	    			if curtime ~= strtime then 
						gBaseLogic.lobbyLogic:showDengLuJiangLiLayer();
					end

					self:checkEvaluate()
				end
		 	end

			-- if (self.hasqiangtuigonggao==1 and self.onReOpened==0) then
			-- 	gBaseLogic.lobbyLogic:showGaoGaoLayer();
		 -- 	end
			-- if self.userData.ply_login_award2_.today_>0 and self.hasqiangtuigonggao==0 and self.onReOpened==0 then
			-- 	gBaseLogic.lobbyLogic:showDengLuJiangLiLayer();
		 -- 	end
		elseif (MAIN_GAME_ID==11) then
			if self.userData.ply_login_award2_.today_>0 and self.hasqiangtuigonggao==0 then
				gBaseLogic.lobbyLogic:showDengLuJiangLiLayer();
		 	end
		elseif (MAIN_GAME_ID==13) then
			if self.hasqiangtuigonggao==0 then
				if self.userData.ply_login_award2_.today_>0 then 
					gBaseLogic.lobbyLogic:showDengLuJiangLiLayer();
				else
					if gBaseLogic.lobbyLogic.loginScene then
					    gBaseLogic.lobbyLogic.loginScene.view:popNewbieGuide()
					end
			 	end
			 end
			 self:pt_cl_get_win_round_score_req(self.userData.ply_lobby_data_.ply_guid_);
		    self.achieveListData = nil;
		    self.achieveListData = {};
		    if #self.achieveListData == 0 then
	            self:reqAchieveListReq()
	        end
		end
	 	--self:requestHTTGongGao();
		self:dispatchLogicEvent({
	        name = "MSG_Socket_UserData",
	        message = message
	    })

	    self:pt_cl_get_unread_msg_req_send();
	   
		izx.miniGameManager:init();	    
	    -- self:getCharacterNameChangeHTTP()
	    -- self:getChongZhiJiangLiData();
	    self:reqDoublechestData()
	    
	    -- 领取登陆奖励
        -- self:pt_cl_get_relief_times_req()
	    
	else
		izxMessageBox("连接服务器出错", "提示");
	end
end

function LobbyLogic:getChongZhiJiangLiData()
	local url = string.gsub(URL.CHONGZHIJIANGLI_INIT,"{pid}",self.userData.ply_guid_);
	url = string.gsub(url,"{packageName}",gBaseLogic.packageName);
	print("LobbyLogic:getChongZhiJiangLiData")
	print (url)
	gBaseLogic:HTTPGetdata(url, 0, function(event)
		print("LobbyLogic:getChongZhiJiangLiData1")
		--var_dump(event);
    	if (event~=nil) then
			self.payInitList = event[1];
			local items = event[1].items
			--var_dump(self.payInitList )
			if items and #items ~= 0 then
				table.sort(items,function(a,b) 
					if a.awardMoney<b.awardMoney then
						return true
					else
						return false;
					end 
				end)
			end
			self.payInitList.items = nil;
			self.payInitList.items = items;
			print("getChongZhiJiangLiData")
			self.getPayNum = 0
			if items ~= nil then
				for k,v in pairs(items) do
					if v.awardStatus==1 then
						self.getPayNum = v.awardMoney;					
						break;
					end
				end
				self:dispatchLogicEvent({
				    name = "MSG_Socket_ChongZhiJiangLi",
				    message = self.payInitList
				})
			end
		end
        end)
	
end

function LobbyLogic:onLazyDownloadFinish(ret,msg)
	echoInfo("LobbyLogic:onLazyDownloadFinish %d", ret);
	var_dump(msg);
	if (ret==1) then
		if (msg.tag==MAIN_GAME_ID.."_biaoqing") then
			-- 表情下载
			echoInfo("LobbyLogic:onLazyDownloadFinish _biaoqing");
			gBaseLogic.hasDownloadBiaoqing = true;
			CCUserDefault:sharedUserDefault():setStringForKey("hasDownloadBiaoqing",LUA_VERSION);
		else

		end
	end
	self:dispatchLogicEvent({
		name = "MSG_RES_LAZY_DOWNLOAD",
		message = msg;
	});

end


function LobbyLogic:pt_lc_get_miniGame_ack_handler(message)
    print("pt_lc_get_miniGame_ack_handler")
    --var_dump(message,4)
    izx.miniGameManager:onSockConfig(message);

end

function LobbyLogic:pt_lc_server_data_not_handler(message)	 
		self.server_datas_ = message.server_datas_;
		print("===============pt_lc_server_data_not_handler")
		-- var_dump(self.server_datas_,3)
		print("===============pt_lc_server_data_not_handler")
		
end
 

function LobbyLogic:pt_lc_server_status_not_handler(message)
	print("LobbyLogic:pt_lc_server_status_not_handler")
	self.server_status_ = message.server_status_; 
	local this_server_status = {}

	for k,v in pairs(self.server_status_) do
		this_server_status["s"..v.server_id_] = v.online_num_
	end
	if self.server_datas_~=nil and #self.server_datas_~=0 then
		for k,v in pairs(self.server_datas_) do
			self.server_datas_[k].online_player_num_ = this_server_status["s"..v.server_id_]
			if self.server_datas_[k].online_player_num_>self.server_datas_[k].max_player_size-10 then
				local socketMsg = {opcode = 'pt_cl_server_data_req',
						};
				self:sendLobbySocket(socketMsg)
				break;
			end
		end
	end
	-- online_player_num_
	-- local socketMsg = {opcode = 'pt_cl_server_data_req',
	-- 					};
	-- self:sendLobbySocket(socketMsg)
	var_dump(self.server_status_,4)
end
 

function LobbyLogic:pt_bc_message_not_handler(message)
	gBaseLogic:unblockUI();
	print("LobbyLogic:pt_bc_message_not_handler")
	var_dump(message)
	if (message.type_==1) then
		self:closeSocket();
		self:onKickNet("您的帐号已在其他地方登录");
	elseif (message.type_==0) then
		izxMessageBox(message.message_,"服务器消息");
	end
		
end

function LobbyLogic:requestHTTPHelpDesk()
	local url = "http://payment.hiigame.com:18000/contact/service"
	gBaseLogic:HTTPGetdata(url,0,function(event)
		-- var_dump(event);
        -- 是否持久化
        -- 如果持久化，在这里改写data
        if (event==nil) then
        	-- 出错处理
        	return 
        end

        -- self.userData = event.qq 
        -- {"pno":"4009208068","qq":"800061676"}    
        self.helpDesk = event.qq;
        self.pno = event.pno;
        -- var_dump(self.listeners_);
        self:dispatchLogicEvent({
	        name = "MSG_HTTP_HelpDesk",
	        message = event.qq
	    })
	    
        end)    
	
end


function LobbyLogic:requestHTTPPaymentItems(type)
	--[[是否持久化
        -- 如果持久化，在这里改写data
        -- event:  {"sl":[{"boxid":562,"boxname":"VIP日卡 = ￥1 (VIP福利详参帮助)","content":[{"num":1,"idx":7},{"num":10000,"idx":0}],"desc":"内含1天VIP时间，附赠1W游戏币","havePhone":0,"icon":"http://iface.b0.upaiyun.com/8a59543e-cdca-460d-8f92-af797efc154a.png!p300","pmList":[{"mname":"安智支付","bsid":363,"mid":3,"micon":"http://statis.bdo.izhangxin.com/pm/anzhi.jpg","serialno":"com.izhangxin.zjh.android.anzhi.vip1"}],"price":1,"serino":"com.izhangxin.zjh.android.anzhi.vip1","spList":[]},{"boxid":1051,"boxname":"VIP月卡 = ￥30","content":[{"num":35,"idx":7}],"desc":"内含30天VIP会员时间（加赠5天会员）","havePhone":0,"icon":"http://iface.b0.upaiyun.com/892cef2e-c8a9-4638-bb00-e3aec8582786.png!p300","pmList":[{"mname":"安智支付","bsid":872,"mid":3,"micon":"http://statis.bdo.izhangxin.com/pm/anzhi.jpg","serialno":"com.izhangxin.zjh.android.anzhi.vip2"}],"price":30,"serino":"com.izhangxin.zjh.android.anzhi.vip2","spList":[]}]}
    ]]--
	-- 商城列表
	local url = URL.SHOPITEMS;
	local params = {
					boxtype = type,
					pn = gBaseLogic.packageName,
					version = LUA_VERSION,
					imsi = gBaseLogic.deviceInfo.imsi,
					imei = gBaseLogic.deviceInfo.imei,
					uid = self.userData.ply_guid_
					};
	-- "isDx":1,"isLt":1,"isYd":1,
	-- local mb = self.MBPluginManager;	
	-- self.payMidUse = nil;
	-- self.payMidUse = {};
	-- print(mb:getSimType())
	-- gBaseLogic.MBPluginManager.distributions.quickpay = false;
	-- local forceusesimtyp = gBaseLogic.MBPluginManager.distributions.forceusesimtyp
	-- -- forceusesimtyp = 1
	-- if forceusesimtyp~=nil then
	-- 	forceusesimtyp = tonumber(forceusesimtyp)
	-- end
	local typSms = gBaseLogic.MBPluginManager:getSimType();
	local forceusesimtyp = gBaseLogic.MBPluginManager.distributions.forceusesimtyp
	if forceusesimtyp~=nil then
		forceusesimtyp = tonumber(forceusesimtyp)
		if forceusesimtyp~=0 then
			typSms = forceusesimtyp
		end
	end
	typSms = tonumber(typSms)
	if typSms==nil or typSms=="" then
		typSms = 0;
	end
	HTTPPostRequest(url, params,function(event)
		print("checking Shop Data from: 11111")
		var_dump(params)
		print(url);
        if (event ~= nil) then
	        if (type==0) then
	        	local forceusesimtyp = gBaseLogic.MBPluginManager.distributions.forceusesimtyp
				if forceusesimtyp~=nil then
					forceusesimtyp = tonumber(forceusesimtyp)
				end
				self.paymentItemList = nil
				self.paymentItemList = {}
	        	if forceusesimtyp~=nil and forceusesimtyp>=1 and forceusesimtyp<=3 then

					local payMidUse = gBaseLogic:getPayMidList();
		    		if payMidUse ~= nil then
			    		for k,v in pairs(event.sl) do
			    			if v.pmList ~= nil then
			    				for i,j in pairs(v.pmList) do
			    					if j.mid == payMidUse[1].mid then
			    						table.insert(self.paymentItemList,v);
			    						break;
			    					end
			    				end
			    			end
			    		end
			    	else
			    		self.paymentItemList = event.sl
			    	end
			    else
			    	self.paymentItemList = event.sl;
				end
		    	self.payItemProp = {}
		    	self:dispatchLogicEvent({name="MSG_HTTP_ShopData"})
		    	local i;	  
		    	for i=1,#self.paymentItemList do
		    		self.paymentItemList[i].payidList = {}
		    		for k,v in pairs(self.paymentItemList[i].pmList) do
		    			table.insert(self.paymentItemList[i].payidList,v.mid)
		    		end
	    			local hasMoneyInPackage = 0;
	    			table.sort(self.paymentItemList[i].content,function(a,b)
		    				if a.idx<b.idx then
		    					return true;
		    				else
		    				 	return false;
		    				 end 
	    				end)
	    			for j=1,#(self.paymentItemList[i].content) do
	    				if (self.paymentItemList[i].content[j].idx==0) then
	    					hasMoneyInPackage = self.paymentItemList[i].content[j].num;
	    				end
						if (MAIN_GAME_ID==13) then
							if (self.paymentItemList[i].havePhone == 1) then
								if (self.paymentItemList[i].content[j].idx==51) then
									self.payItemProp[51] = self.payItemProp[51] or {}
									table.insert(self.payItemProp[51], self.paymentItemList[i])
								end
								if (self.paymentItemList[i].content[j].idx==52) then
									self.payItemProp[52] = self.payItemProp[52] or {}
									table.insert(self.payItemProp[52], self.paymentItemList[i])
								end
								if (self.paymentItemList[i].content[j].idx==53) then
									self.payItemProp[53] = self.payItemProp[53] or {}
									table.insert(self.payItemProp[53], self.paymentItemList[i])
								end
							end
						end
	    			end
	    			print("inhasMoneyInPackage"..i)
	    			print(hasMoneyInPackage)
	    			if (hasMoneyInPackage>0) then
	    				local thisInfo = self.paymentItemList[i]
	    				-- "isDx":1,"isLt":1,"isYd":1
	    				local smsFlag = false
	    				if typSms==1 and thisInfo.isYd==1 then
	    					smsFlag = true
	    				elseif typSms==2 and thisInfo.isLt==1 then
	    					smsFlag = true
	    				elseif typSms==3 and thisInfo.isDx==1 then
	    					smsFlag = true
	    				end

	    				if (self.paymentItemList[i].havePhone == 1 and smsFlag) then
	    					local payMidUse = gBaseLogic:getPayMidList();
	    					local thismid = 0
	    					for k,v in pairs(payMidUse) do
	    						if v.payTyp=="SMS" then
	    							thismid = v.mid
	    						end
	    					end
	    					thismid = tonumber(thismid)
	    					if thismid~=0 and in_table(thismid, self.paymentItemList[i].payidList) then
		    					self.payItemSMS[hasMoneyInPackage] = self.paymentItemList[i];
		    					self.payItemSMSCounter = self.payItemSMSCounter + 1;
		    				end
	    				end
	    				self.payItemNormal[hasMoneyInPackage] = self.paymentItemList[i];
	    				self.payItemNormalCounter = self.payItemSMSCounter + 1;
	    			end
	    	  	end
	    	  	local sortFunc = function(a, b)
				    if a.price > b.price then
				    	return false
				    elseif a.price == b.price then
				    	return true
				    else
				    	return true
				    end
				end

	    	  	for k,v in pairs(self.payItemProp) do
	    	  		for s,t in ipairs(v) do
	    	  			t.index = s
	    	  		end
	    	  		table.sort(v, sortFunc)
	    	  	end 
	    	  	print("MSG_HTTP_ShopDatapayItemNormal")
	    	  	var_dump(self.payItemNormal)
				self:dispatchLogicEvent({name="MSG_HTTP_ShopData"})   	  	
		    else
		    	-- var_dump(event)
		    	print("getVipData===")
		    	self.VIPItemList =event.sl	
		    	self.payVIPItemList = {};
		    	for k,v in pairs(self.VIPItemList) do
		    		self.VIPItemList[k].payidList = {}
		    		for k1,v1 in pairs(v.pmList) do
		    			table.insert(self.VIPItemList[k].payidList,v1.mid)
		    		end
		    		self.payVIPItemList[v.price] = v;
		    	end
		    	self:dispatchLogicEvent({name="MSG_HTTP_ShopDataVip"})	    
		    end
	    end	    
        end);

end
--add by lxy
function LobbyLogic:requestHTTPAchieve(pid, type)--self.userData.ply_guid_
	local listSrc = {'pid','sign','gameid'}
	local sb =  pid.."234sdfy724dsdfdrssa";
	local sign = crypto.md5(sb)
	local tableRst = {pid = pid, sign = sign, gameid = MAIN_GAME_ID};
	local url = supplant(URL.GETACHIEVE,listSrc,tableRst);
 
	print("#####"..url)
	gBaseLogic:HTTPGetdata(url,0,function(event)
        if (event ~= nil) then
	        if event.achieveList ~= nil then
	        	if type == 1 then
	        		self.personalScene.view:showPersonalAchieve(event.achieveList); --gBaseLogic.lobbyLogic.achieveListData
	        	else 
	        		gBaseLogic.gameLogic.gamePage.view:showAchieve(event.achieveList,type);
	        	end
	        end
	    end	    
        end);
end

--add by wxf start
function LobbyLogic:getPayInfoForProp(propIndex)
	-- body
	local ret =  false
	local payMoney = 0
	if self.payItemProp[propIndex] ~= nil and #self.payItemProp[propIndex] > 0 and gBaseLogic.MBPluginManager:getSimStatue()  then
		payMoney = self.payItemProp[propIndex][1].price * 10000
		ret = true
	end

	return ret,payMoney
end

function LobbyLogic:payForProp(propIndex)
	-- body

	if self.payItemProp[propIndex] ~= nil and #self.payItemProp[propIndex] > 0 then
		if self.payItemProp[propIndex][1].havePhone == 1 and  gBaseLogic.MBPluginManager:getSimStatue() then
	        gBaseLogic.lobbyLogic:pay(self.payItemProp[propIndex][1],"SMS",3);
		else
			--gBaseLogic.lobbyLogic:pay(self.payItemProp[propIndex][1],"Normal",3);
		end
	end
end
--add by wxf end
function LobbyLogic:quickPay(needGameMoney, status)
	if self.userData==nil or self.userData.ply_lobby_data_==nil or self.userData.ply_lobby_data_.money_==nil then

		if gBaseLogic.is_robot == 0 then 
			local initParam={msg="请先登录！",type=1000};
			self:showYouXiTanChu(initParam);
		else
			local initParam={msg="请先登录！",type=1005};
			self:showYouXiTanChu(initParam);
    	end
		return
	end

	if status==nil then
		status = 0
	end
	local minPackage = 99999999999999;
	local kmine = 0;
	print("LobbyLogic:quickPay")
	var_dump(self.payItemSMS,4);
	-- if (self.payItemSMSCounter>0 and  gBaseLogic.MBPluginManager:getSimStatue() and gBaseLogic.MBPluginManager.distributions.quickpay) then 
	if (self.payItemSMSCounter>0 and  gBaseLogic.MBPluginManager.distributions.quickpay) then 
		for k,v in pairs(self.payItemSMS) do			
			if (kmine<k) then
				kmine = k;
			end
			if (k>=needGameMoney) then
				if (k<minPackage) then
					minPackage = k;
				end
			end
		end
		if (self.payItemSMS[minPackage]==nil) then
			minPackage = kmine;
		end
		print("====get package to pay to get"..minPackage);
		self:onPayTips(status, "SMS", self.payItemSMS[minPackage],needGameMoney)
		-- gBaseLogic.lobbyLogic:pay(self.payItemSMS[minPackage],"SMS", status);
		-- print("gBaseLogic.MBPluginManager.IAPSmsNeedConfirm"..gBaseLogic.MBPluginManager.IAPSmsNeedConfirm)
		-- if gBaseLogic.MBPluginManager.IAPSmsNeedConfirm~=nil and
		-- 	gBaseLogic.MBPluginManager.IAPSmsNeedConfirm==1 then
		-- 	local info = '真不敢相信，彻底破产了！快速补充金币（首冲有双倍奖励哦）#2元=2W金币#';
		-- 	gBaseLogic:confirmBox({
	 --            msg=info,
	 --        	callbackConfirm = function()
		--             callbackfunction()		            
		--         end,
		-- 		callbackCancel = function()
		            
		--         end})
		-- else
		-- 	callbackfunction();
		-- end
		
		return;
		
	end
	if (self.payItemNormalCounter>0) then
		for k,v in pairs(self.payItemNormal) do
			if (kmine==0) then
				kmine = k;
			end
			if (k>needGameMoney) then
				if (k<minPackage) then
					minPackage = k;
				end
			end
		end
		if (self.payItemNormal[minPackage]==nil) then
			minPackage = kmine;
		end

		if (self.payItemNormal[minPackage]~=nil) then
			print("====get package to pay to get"..minPackage);
			--判断是否调用自己的充值提醒框
			-- if (self.selfTips.isTips == true)then
			-- 	gBaseLogic:unblockUI();
			-- 	self.selfTips.boxInfo = self.payItemNormal[minPackage];
			-- 	self.selfTips.status = status;
			-- 	self:ChargeTips();
			-- else
		 --        gBaseLogic.lobbyLogic:pay(self.payItemNormal[minPackage],"Normal",status);
			-- end
			gBaseLogic:unblockUI();
			self:onPayTips(status, "Normal", self.payItemNormal[minPackage],needGameMoney)
			return;
		else
			gBaseLogic:unblockUI();
		end
	end

	izxMessageBox("游戏币不足,请至商城充值.", "游戏币不足！")
	-- body
end
function LobbyLogic:VipPay(needPrice,status)
	if self.payVIPItemList ~= nil then
		if (self.payVIPItemList[needPrice]~=nil) then
			-- if self.payVIPItemList[needPrice].
			self:pay(self.payVIPItemList[needPrice],'Normal',status)
			-- self:onPayTips(3, "Normal", self.payVIPItemList[needPrice],0)
		else
			for k,v in pairs(self.payVIPItemList) do
				-- self:onPayTips(3, "Normal", v,0)
				self:pay(v,'Normal',status);
				break
			end
		end
	end
end
function LobbyLogic:pay(data,payTyp,status)
	var_dump({"gBaseLogic.MBPluginManager.IAPSmsType",gBaseLogic.MBPluginManager.IAPSmsType});
	gBaseLogic.MBPluginManager:logEventLabelDurationMyBegin("payDuration");
	if status==nil or status ==0 then
		status = 1
	end
	print("pay type:",payTyp,"status:",status)
	chest = {};
	chest.boxId = data.boxid;
	chest.goodsLogo = data.icon;
	chest.goodsName = data.boxname;
	chest.desc  = data.desc;
	chest.serialno = data.serino;
	chest.saleMoney = data.price;
	--chest.sms_quickpay_ = status;
	chest.isSmsQuickPay = status;
	if data.pmList~=nil then	 
		for k1,v1 in pairs(data.pmList) do
			chest['mid_'..v1.mid] = v1.serialno
		end
	end 
	chest.havePhone = data.havePhone;
	gBaseLogic.inPayBox = 1;
	gBaseLogic.isshuangbeipay = 0;
	if in_table(data.boxid,self.doubleChestids) then
        gBaseLogic.isshuangbeipay = 1;
    end
	-- echoInfo("gBaseLogic.MBPluginManager.IAPSmsNeedConfirm = "..gBaseLogic.MBPluginManager.IAPSmsNeedConfirm);
	if (payTyp=='SMS' and gBaseLogic.MBPluginManager.distributions.quickpay) and tonumber(data.havePhone)==1 and in_table(gBaseLogic.MBPluginManager.IAPSmsUseMid, data.payidList) then				 
		-- if gBaseLogic.MBPluginManager.IAPSmsNeedConfirm==nil or
		-- 	gBaseLogic.MBPluginManager.IAPSmsNeedConfirm==1 then
		-- 	local info = '是否购买 "'..data.boxname..'"';
		-- 	gBaseLogic:unblockUI()				
		-- 	gBaseLogic:confirmBox({
	 --            msg=info,
	 --        	callbackConfirm = function()
	 --        		gBaseLogic:blockUI({autoUnblock=false})
		--             gBaseLogic.MBPluginManager:paySMS(chest);		            
		--         end,
		-- 		callbackCancel = function()
		            
		--         end})
		-- else
			
		-- end
		scheduler.performWithDelayGlobal(function()
	    	gBaseLogic.MBPluginManager:paySMS(chest);
	    end, 0.5);
	else
		chest.isSmsQuickPay = 0;
	    scheduler.performWithDelayGlobal(function()
	    	gBaseLogic.MBPluginManager:pay(chest);
	    end, 0.5);
	end
end

function LobbyLogic:onSocketgetData()
	-- change page
	local socketMsg = {opcode = 'cl_login_',
						uname = 'xxx',
						upwd = 'yyy'};
	self:sendLobbySocket(socketMsg);
 

end

-- 小游戏列表
function LobbyLogic:reqMiniGameSend()
	-- change page
	print ("LobbyLogic:onSocketminiGamesend")
	local socketMsg = {opcode = 'pt_cl_get_miniGame_req',
						ply_guid_ = self.userData.ply_guid_,--guid 
						game_id_ = MAIN_GAME_ID,
						version_ = CASINO_VERSION_DEFAULT,
						};
	self:sendLobbySocket(socketMsg);
end 

--登录奖励
function LobbyLogic:onSocketLoginAwardReq()
	-- change page
	print ("LobbyLogic:onSocketLoginAwardReq")
	local socketMsg = {opcode = 'pt_cl_get_continuous_game_award_req'};
	self:sendLobbySocket(socketMsg);
end 

--请求低保
function LobbyLogic:sendReliefReq()
	-- change page
	print ("LobbyLogic:sendReliefReq")
	local socketMsg = {opcode = 'pt_cl_get_relief_req'};
	self:sendLobbySocket(socketMsg);
end 


--日常任务list
function LobbyLogic:reqTaskListReq()
	-- change page
	print ("LobbyLogic:reqTaskListReq")
	local socketMsg = {opcode = 'pt_cl_get_daily_task_list_req'};
	self:sendLobbySocket(socketMsg);
	var_dump(self.lobbySocket)
end
--日常任务奖励
function LobbyLogic:reqTaskAwardReq(task_id)
	-- change page
	print ("LobbyLogic:reqTaskAwardReq")
	local socketMsg = {opcode = 'pt_cl_get_daily_task_award_req',index_ = task_id};
	self:sendLobbySocket(socketMsg);
end

--成就list
function LobbyLogic:reqAchieveListReq()
	-- change page
	print ("LobbyLogic:onSocketAchieveListReq")
	local socketMsg = {opcode = 'pt_cl_get_achieve_list_req'};
	self:sendLobbySocket(socketMsg);
end
--成就奖励
function LobbyLogic:reqAchieveAwardReq(achieve_id)
	-- change page
	print ("LobbyLogic:reqAchieveAwardReq")
	local socketMsg = {opcode = 'pt_cl_get_achieve_award_req',index_ = achieve_id};
	self:sendLobbySocket(socketMsg);
end

function LobbyLogic:onSocketSafeDataReq()
	-- change page
	print ("LobbyLogic:onSocketSafeDataReq")
	local socketMsg = {opcode = 'pt_cl_get_safe_data_req',
						ply_guid_ = self.userData.ply_guid_
					};
	-- var_dump(socketMsg);
	self:sendLobbySocket(socketMsg);
end

--保险箱设置密码
function LobbyLogic:reqSocketSafeSetPassWord(pwd, phoneNum)
	-- change page
	print ("LobbyLogic:onSocketSafeSetPassWord")
	 
	local socketMsg = {opcode = 'pt_cl_set_password_safe_req',
						ply_guid_ = self.userData.ply_guid_,
						password_ = pwd,
						mobile_ = phoneNum
						};
	self:sendLobbySocket(socketMsg);
end

--保险箱存钱
function LobbyLogic:onSocketSafeSaveMoney(saveMoney)
	-- change page
	print ("LobbyLogic:onSocketSafeSaveMoney")
	 
	local socketMsg = {opcode = 'pt_cl_store_safe_amount_req',
						ply_guid_ = self.userData.ply_guid_,
						amount_ = saveMoney --存钱数量
						};
	self:sendLobbySocket(socketMsg);
end
--保险箱取钱
function LobbyLogic:onSocketSafeRemoveMoney(removeMoney, pwd)
	-- change page
	print ("LobbyLogic:onSocketSafeRemoveMoney")
	 
	local socketMsg = {opcode = 'pt_cl_remove_safe_amount_req',
						ply_guid_ = self.userData.ply_guid_,
						amount_ = removeMoney, --取钱数量
						password_ = pwd--保险箱密码
						};
	self:sendLobbySocket(socketMsg);
end
--保险箱修改密码
function LobbyLogic:onSocketSafeModifyPassword(oldPwd, newPwd)
	-- change page
	print ("LobbyLogic:onSocketSafeModifyPassword")
	 
	local socketMsg = {opcode = 'pt_cl_modify_password_safe_req',
						ply_guid_ = self.userData.ply_guid_,
						old_password_ = oldPwd, --保险箱原始密码
						new_password_ = newPwd--保险箱新密码
						};
	self:sendLobbySocket(socketMsg);
end
function LobbyLogic:onSocketSafeHistory()
	-- change page
	print ("LobbyLogic:onSocketSafeHistory")
	 
	local socketMsg = {opcode = 'pt_cl_get_safe_history_req',
						ply_guid_ = self.userData.ply_guid_			
						};
	self:sendLobbySocket(socketMsg);
end
-- 
function LobbyLogic:onSocketGetRankList(type)	 
	-- 排行榜
	-- {
	-- 	"name"		:	"opcode",
	-- 	"type"		:	"short",
	-- 	"option"	:	"required"
	-- },
	-- {
	-- 	"name"		:	"type_",
	-- 	"type"		:	"char",
	-- 	"option"	:	"required"
	-- },
	-- {
	-- 	"name"		:	"latitude_",
	-- 	"type"		:	"float",
	-- 	"option"	:	"required"
	-- },
	-- {
	-- 	"name"		:	"longitude_",
	-- 	"type"		:	"float",
	-- 	"option"	:	"required"
	-- }
 --获取排行榜type_:0财富排行 1战绩排行 2距离排行榜 3比赛冠军榜 4胜率排行 5前日输赢 6前日战绩 7拉霸热度 8拉霸豹子
	local socketMsg = {opcode = 'pt_cl_get_rank_list_req',type_ = type, latitude_=-1,longitude_=-1};
	 
	self:sendLobbySocket(socketMsg);
end


function LobbyLogic:pt_cl_get_unread_msg_req_send(message)
	-- table.insert(self.guangBaoList,message.message_);
	print("=pt_cl_get_unread_msg_req")
	print("=pt_cl_get_unread_msg_req")
	local socketMsg = {opcode = 'pt_cl_get_unread_msg_req',
						snd_guid_ = '1000',-- self.userData.ply_guid_	
						timestamp_ = 0,					
						};
	self:sendLobbySocket(socketMsg);
end

function LobbyLogic:pt_pong_handler(msg)
	print("LobbyLogic:pt_pong_handler")
	var_dump(msg)
	self.pong_now = msg.now_
	-- echoInfo("pt_pong_handler");
	-- if (self.lastNotifyTime==nil) then
	-- 	self.lastNotifyTime = 0;
	-- end
	-- local diffTime = os.time() - msg.now_;
	-- if (diffTime>=1) then
	-- 	if (os.time() - self.lastNotifyTime>30) then
	-- 		self.lastNotifyTime = os.time();
	-- 		gBaseLogic:showTopTips("weak network"..diffTime);
	-- 	end
	-- end
end

--请求等级
function LobbyLogic:reqPlayerLeveltReq()
	print ("LobbyLogic:reqPlayerLeveltReq")
	local socketMsg = {opcode = 'pt_cl_get_player_level_req'};
	self:sendLobbySocket(socketMsg);
end
function LobbyLogic:reqDoublechestData()
	--双倍宝箱数据self.doubleChestids
	print("LobbyLogic:reqDoublechestData")
-- 请求地址 定义为 t.statics.hiigame.com/get/first/pay/box?gameid=&uid=&pn=&token=
-- 其中token 为验签字符串 加密规则 MD5.toMD5("uid=10000&key=232b969e8375")
	local token = "uid="..self.userData.ply_guid_ .."&key=".."232b969e8375";
	local token = crypto.md5(token)
	local tableRst = {gameid=MAIN_GAME_ID,pn=gBaseLogic.packageName,uid = self.userData.ply_guid_,token = token};
	--local url = supplant(URL.GETPROMOTE,listSrc,tableRst);

	--"http://t.statics.hiigame.com/get/promotion/code?uid={uid}&sign={sign}";
	--url = "http://t.statics.hiigame.com/get/promotion/code?uid=1101133834027384&sign=fe1d59bd89ba760eeae0af5cf3660de4"
	--gBaseLogic:HTTPGetdata(url,0,function(event)
	HTTPPostRequest(URL.DoubleChest, tableRst, function(event)
		print(URL.DoubleChest)
		var_dump(tableRst)
        if (event ~= nil) then
        	var_dump(event)
        	self.doubleChestids = event.boxid
	        if (event.ret == 0) then

	        	--
	        	-- self.isPromoteOK = true 
	        	-- self.view.btnGotoPromote:setEnabled(gBaseLogic.MBPluginManager.hasSocial)
	        	-- self.view:initBaseInfo(event.code);
	        else 
	        	-- if event.msg ~= nil then
	        	-- 	self.view.promoteLable:setString(event.msg)
	        	-- 	izxMessageBox(event.msg, "提示") 
	        	-- else  
	        	-- 	if event.ret == -2 then 
	        	-- 		self.view.promoteLable:setString("用户Uid不存在")
	        	-- 	elseif event.ret == -3 then
	        	-- 		self.view.promoteLable:setString("签名错误")
	        	--     end
	        	-- end
	        end
	    end	    
        end);
end
function LobbyLogic:requestHTTGongGao(checkLogin)
	-- 强推公告 todo
	print("LobbyLogic:requestHTTGongGao")
	gBaseLogic.MBPluginManager:logEventLabelMyBegin("LOGIN_STEP_DURA","requestHTTGongGao");
	if (MAIN_GAME_ID~=13) then
		gBaseLogic:blockUI({autoUnblock=false,msg=LOGIN_LOADING_TIPS0,hasCancel=true,callback=handler(gBaseLogic,gBaseLogic.onPressCancelLogin)});
	end
	
	local url = string.gsub(URL.GONGGAO,"{pid}",0);  
	url = string.gsub(url,"{packageName}",gBaseLogic.packageName);
	url = string.gsub(url,"{gameid}",MAIN_GAME_ID);
	-- print(url);
	gBaseLogic:HTTPGetdata(url,0,function(event)
		-- gBaseLogic:unblockUI();
        -- 是否持久化
        print("LobbyLogic:requestHTTGongGao=======")
		gBaseLogic.MBPluginManager:logEventLabelMyEnd("LOGIN_STEP_DURA","requestHTTGongGao");
			if (MAIN_GAME_ID~=13) then
				if checkLogin==1 then
					gBaseLogic:checkLogin(); 
				end
			end
        -- CCUserDefault:sharedUserDefault():setStringForKey("ply_guid_", userInfo.ply_guid_)
        if event~=nil and event.ance~=nil then
	        if (event.ance.resultList ~=nil and event.ance.resultList[1]~=nil) then
	        	local anceInfo = event.ance.resultList[1]
		        self.gongGaoContent = anceInfo.content;
		        self.gongGaotitle = anceInfo.title;
		        -- print("requestHTTGongGao"..CCUserDefault:sharedUserDefault():getStringForKey("gongGaoAid"))
		        -- print(anceInfo.aid);
		        -- CCUserDefault:sharedUserDefault():setIntegerForKey("gongGaoAid",0);
		        if (CCUserDefault:sharedUserDefault():getIntegerForKey("gongGaoAid") ~= anceInfo.aid) then
		        	self.hasqiangtuigonggao = 1;
					if (MAIN_GAME_ID==13) then
		        		self:showGaoGaoLayer()
					end
		        	CCUserDefault:sharedUserDefault():setIntegerForKey("gongGaoAid",anceInfo.aid)
		        end
		    end
		end
        -- var_dump(event.ance.resultList)
        
        
	    
        end)    
	
 
end

function LobbyLogic:onKickNet(msg)
	echoInfo("LobbyLogic:onKickNet %s",msg);
	var_dump(gBaseLogic.currentState)
	self.userHasLogined = false
	if (gBaseLogic.currentState == gBaseLogic.stateLogin) then
		self.userData = nil;
		self.userData = {};
		if gBaseLogic.sceneManager.currentPage.ctrller.resetData ~= nil then
			gBaseLogic.sceneManager.currentPage.ctrller:resetData();
		end
		self:onNoNet(2,msg)
	elseif (gBaseLogic.currentState ~= gBaseLogic.stateLogin) then
		if (gBaseLogic.currentState == stateInRealGame or gBaseLogic.currentState == stateInMiniGame ) then
			self.gameSocket.close();
		end
		print("=====")
		self:reShowLoginScene(false,msg);	
	end

end

-- typ=0 没网络，typ=1，socket断，typ=2, 被踢下线，msg=nil或空用默认的话，typ=3 ,update fail
function LobbyLogic:onNoNet(typ,msg)
	gBaseLogic:unblockUI();
	self:resetUserInfo();
	if (msg==nil) then
		msg = '登录失败，请尝试重新登录或进入单机游戏';
	end
	gBaseLogic:confirmBox({
        msg=msg,
        btnTitle={btnConfirm="单机游戏",btnCancel="登录"},
        callbackConfirm = function()
            echoInfo("Into Robot game!!!");
			gBaseLogic.is_robot = 1
			gBaseLogic.lobbyLogic:startRobotGame() 
        end,
        callbackCancel = function()
            gBaseLogic.lobbyLogic:showLoginTypeLayer();
        end});
end

function LobbyLogic:gobackGameforonExitConfirm()
	local function callback()
		print("进入游戏！")
		-- self.pt_cl_get_ply_status_req
		local socketMsg = {opcode = 'pt_cl_get_ply_status_req',
						players_ = {self.userData.ply_guid_} 	
						};
		gBaseLogic.lobbyLogic:sendLobbySocket(socketMsg);
	end
	local initParam = {msg="您上局游戏还没有结束，快回去虐他们！",cback=callback,type=1000};
	self:showYouXiTanChu(initParam)
end
function LobbyLogic:pt_lc_get_ply_status_ack_handler(message)
	print("pt_lc_get_ply_status_ack_handler")
	local player_lists = message.players_;
	var_dump(message,4);
	-- 	guid	ply_guid_;
	-- string	ply_nickname_;
	-- char	ply_status_;		//0离线 1登录中 2游戏房间 3游戏桌子中 5游戏开始 6登录服务器
	-- int		sex_;				//0男 1女
	-- int		game_id_;
	-- int		game_server_id_;
	-- int		table_id_;
	if self.isOnGameExit==1 then
		print(self.userData.ply_lobby_data_.ply_guid_);
		for k,v in pairs(player_lists) do
			print(v.ply_guid_)
			print(v.ply_status_)
			if v.ply_guid_ == self.userData.ply_lobby_data_.ply_guid_ then 
				print("2222222222222222222222")
				if v.ply_status_==2 or v.ply_status_==3 or v.ply_status_==5 then
					self.isOnGameExit=0;
					self:reEnterGame(v.game_id_,v.game_server_id_ )
				else
					self.isOnGameExit=0;
				end
			end
		end
		
	end
end
-- NET_PACKET(pt_lc_get_ply_status_ack)
-- {
-- 	vector<PlayerStatus>	players_;
-- };

function LobbyLogic:sendReloadUserData()
	local socketMsg = {opcode = 'pt_cl_reload_user_data_req'};
	self:sendLobbySocket(socketMsg);
	--var_dump(socketMsg)
end 

function LobbyLogic:pt_lc_user_data_broadcast_msg_not_handler(message)
	local msg = message.message_;
	if message.ply_guid_==self.userData.ply_lobby_data_.ply_guid_ then
		self.isOnGameExit = 0
		self:sendReloadUserData()
		local initParam = {msg=msg,type=1000}
		self:showYouXiTanChu(initParam)
		self:dispatchLogicEvent({
	        name = "MSG_GAME_FINISH",
	        message = message
	    })
		-- self.logic:addLogicEvent("MSG_MAINGAME_LOADING",handler(self, self.onMainGameLoading),self)
	end
end
function LobbyLogic:pt_lc_reload_user_data_ack_handler(message)
	print("pt_lc_reload_user_data_ack_handler");
	var_dump(message)
	self.userData.ply_lobby_data_.money_ = message.money_;
	self.userData.ply_lobby_data_.gift_ = message.gift_;
	self.userData.ply_lobby_data_.param_2_ = message.level_;
	for k,v in pairs(self.userData.ply_items_) do		
		if v.index_==80 and message.gift_ > 0 then
			self.userData.ply_items_[k].num_ = message.gift_
		elseif v.index_==0 and message.money_ > 0 then
			self.userData.ply_items_[k].num_ = message.money_
		end
	end
	self:dispatchLogicEvent({
        name = "MSG_Socket_pt_lc_send_user_data_change_not",
        message = self.userData
    })
end
function LobbyLogic:pt_lc_get_continuous_game_award_ack_handler(message)
	print("pt_lc_get_continuous_game_award_ack_handler")
    if (message.ret_==0) then            
        if (message.money_>0) then
            print(message.money_)
            self.userData.ply_lobby_data_.money_ = message.money_;
            -- self.data.user.userMoney = event.message.money_; --?userMoney is string?
            -- self.view:initUserInfo();
            gBaseLogic:coin_drop();            
            self:dispatchLogicEvent({
		        name = "MSG_Socket_pt_lc_send_user_data_change_not",
		        message = self.userData
		    })
		    self:sendReloadUserData()
        end
        
    end
	
end
function LobbyLogic:startMiniGame(gameId)
	if self.isOnGameExit==1 then
		gBaseLogic:unblockUI();
		self:gobackGameforonExitConfirm();		
		return;
	end
	local userMoney = self.userData.ply_lobby_data_.money_;
	local miniGameInfo = izx.miniGameManager:getMiniGame(gameId);
	if (miniGameInfo==nil) then
		izxMessageBox( "暂未开放","提示");
		return;
	end
	if (miniGameInfo.initparam==nil) then
		print("请检查服务器配置")
		izxMessageBox("正在获得游戏配置，请稍后重试", "请稍候");
		self:reqMiniGameSend();
	else
		if gameId == 103 then
		    local needMoney = miniGameInfo.initparam.min_money_;
		    if (userMoney<needMoney) then
		     	gBaseLogic:onNeedMoney("miniGameEnter",needMoney);      
		     	return;
		    end
		end
	    gBaseLogic:addLogDdefine("gameType","mini",gameId)
	    gBaseLogic:logEventLabelDuration("gameTime","login",0)
	    self:showLoadingScene("miniGame",gameId);
	    gBaseLogic.currentState = gBaseLogic.stateInMiniGame;
	end
end

function LobbyLogic:onSocketTempClose()
	echoInfo("服务器断开，正在为您重连服务器，请稍候");
	print("LobbyLogic:onTempClose1111")
	gBaseLogic:blockUI({autoUnblock=false,msg="服务器断开，正在为您重连服务器，请稍候!"})
	-- gBaseLogic.sceneManager.currentPage.view:ShowGameTip("服务器断开，正在为您重连服务器，请稍候")

end

function LobbyLogic:onSocketReOpen()
	print("LobbyLogic:onSocketReOpen")
	gBaseLogic:unblockUI()
	self:onSocketOpen();
end

function LobbyLogic:SendTrumpetReq(message)
  local socketMsg = {opcode = 'pt_cl_trumpet_req',
            type_ = 0, 
            message_ = message,         
            };
  self:sendLobbySocket(socketMsg);
end

function LobbyLogic:pt_cl_get_win_round_score_req(ply_guid)
	print ("LobbyLogic:pt_cl_get_win_round_score_req")
	local socketMsg = {
		opcode = 'pt_cl_get_win_round_score_req',
		ply_guid_ = ply_guid
		};
	self:sendLobbySocket(socketMsg);
end


function LobbyLogic:pt_lc_get_win_round_score_ack_handler(message)
    -- body
    print("LobbyLogic:pt_lc_get_win_round_score_ack_handler")
    --var_dump(message)
    print("self.userData.ply_lobby_data_.ply_guid_ = "..self.userData.ply_lobby_data_.ply_guid_)
    if tonumber(message.ret_) == 0 and message.ply_guid_ == self.userData.ply_lobby_data_.ply_guid_ then
	    self.winRoundInfo.score = message.score_
	    self.winRoundInfo.winNum = message.num_
	    self.winRoundInfo.maxScore = message.max_score_
	    self.winRoundInfo.maxWinNum = message.max_num_
	end
end


function LobbyLogic:pt_lc_get_achieve_list_ack_handler(message)
    -- body
    print("LobbyLogic:pt_lc_get_achieve_list_ack_handler")
    local items = message.items_
    print("items")
    --var_dump(items)
    for i,v in ipairs(items) do
        if(v.index_ >= 100 and v.index_<= 120)then
        	self.achieveListData[v.index_-99] = v;
            --table.insert(self.achieveListData,v)
        end
    end
    -- if #self.achieveListData > 0 then
    --     local sortFunc = function(a, b)
    --         if a.index_ > b.index_ then
    --             return false
    --         else
    --             return true
    --         end
    --     end
    --     table.sort(self.achieveListData, sortFunc);
    -- end
    print("self.achieveListData")
    var_dump(self.achieveListData)
    --var_dump(self.achieveListData)
    self:dispatchLogicEvent({
	        name = "MSG_SOCK_"..message.opcode,
	        message = message
	    })
end

--游戏币不足弹框
function LobbyLogic:ChargeTips()
	print "LobbyLogic:ChargeTips"

	local popBoxExit = {};
	function popBoxExit:onPressCancel()
		print("popBoxExit:onPressCancel")
		gBaseLogic.sceneManager.currentPage.view:closePopBox();
		gBaseLogic.lobbyLogic.isTips = false;
		print("gBaseLogic.lobbyLogic.lowMoney:",gBaseLogic.lobbyLogic.lowMoney)
		print("gBaseLogic.lobbyLogic.lowMoneyMsg:",gBaseLogic.lobbyLogic.lowMoneyMsg);
		if(gBaseLogic.lobbyLogic.lowMoney == true)then
			gBaseLogic.lobbyLogic.lowMoney = false;
		    local initParam = {}
		    if(gBaseLogic.lobbyLogic.lowMoneyMsg ~= "")then
		    	initParam = {msg=gBaseLogic.lobbyLogic.lowMoneyMsg,type=1000};
		    else
		    	initParam = {msg="系统赠送您1000游戏币",type=1000};
		    end
		    gBaseLogic.lobbyLogic:showYouXiTanChu(initParam)
		    gBaseLogic.lobbyLogic.lowMoneyMsg = ""
		end
	end
	function popBoxExit:onPressConfirm()
        gBaseLogic.lobbyLogic:pay(gBaseLogic.lobbyLogic.selfTips.boxInfo,"Normal",gBaseLogic.lobbyLogic.selfTips.status);
		gBaseLogic.lobbyLogic.isTips = false;
		gBaseLogic.sceneManager.currentPage.view:closePopBox();
		gBaseLogic:blockUI();
	end
	function popBoxExit:onTouches(event,x,y)
		
	end
	function popBoxExit:onAssignVars()
		self.labelTips = tolua.cast(self["labelTips"],"CCLabelTTF");
		self.labelTipsBg = tolua.cast(self["labelTipsBg"],"CCLabelTTF");
		gBaseLogic.lobbyLogic.isShow = false;
		local gameInfo = ""
		--主动充值
		local coinNum = 0

		for k,v in pairs(gBaseLogic.lobbyLogic.selfTips.boxInfo.content) do
			if v.idx == 0 then
				coinNum = v.num
				break;
			end
		end

		if(gBaseLogic.lobbyLogic.selfTips.status == 3)then
			if(gBaseLogic.MBPluginManager.distributions.channel ~= "")then
				gameInfo = "您将购买"..coinNum.."游戏币（等同于"..gBaseLogic.lobbyLogic.selfTips.boxInfo.price.."个"..gBaseLogic.MBPluginManager.distributions.channel.."），客服：4009208068。确认购买？"
			else
				gameInfo = "您将购买"..coinNum.."游戏币（等同于"..gBaseLogic.lobbyLogic.selfTips.boxInfo.price.."元人民币），客服：4009208068。确认购买？"
			end
		elseif(gBaseLogic.lobbyLogic.selfTips.status == 5)then
			if(gBaseLogic.MBPluginManager.distributions.channel ~= "")then
				gameInfo = "您有未购买成功的记录,"..coinNum.."游戏币（等同于"..gBaseLogic.lobbyLogic.selfTips.boxInfo.price.."个"..gBaseLogic.MBPluginManager.distributions.channel.."），客服：4009208068。是否购买？"
			else
				gameInfo = "您有未购买成功的记录,"..coinNum.."游戏币（等同于"..gBaseLogic.lobbyLogic.selfTips.boxInfo.price.."元人民币），客服：4009208068。是否购买？"
			end
		else
			if(gBaseLogic.MBPluginManager.distributions.channel ~= "")then
				gameInfo = "您的游戏币余额为"..gBaseLogic.lobbyLogic.selfTips.userMoney..",进入本游戏至少需要"..gBaseLogic.lobbyLogic.selfTips.needMoney.."游戏币,您的游戏币不足!您是否需要购买"..coinNum.."游戏币(等同于"..gBaseLogic.lobbyLogic.selfTips.boxInfo.price.."个"..gBaseLogic.MBPluginManager.distributions.channel.."),客服:4009208068。确认购买?"
			else
				gameInfo = "您的游戏币余额为"..gBaseLogic.lobbyLogic.selfTips.userMoney..",进入本游戏至少需要"..gBaseLogic.lobbyLogic.selfTips.needMoney.."游戏币,您的游戏币不足!您是否需要购买"..coinNum.."游戏币(等同于"..gBaseLogic.lobbyLogic.selfTips.boxInfo.price.."元人民币),客服:4009208068。确认购买?"
			end

		--local gameInfo = "您的游戏币余额为"..gBaseLogic.lobbyLogic.userData.ply_lobby_data_.money_..",进入本游戏至少需要"..gBaseLogic.lobbyLogic.selfTips.needMoney.."游戏币,您的游戏币不足!您是否需要购买"..gBaseLogic.lobbyLogic.selfTips.boxInfo.content[1].num.."游戏币(等同于"..gBaseLogic.lobbyLogic.selfTips.boxInfo.price.."元人民币),客服:4009208068。确认购买?"
		end
		self.labelTips:setString(gameInfo)
		self.labelTipsBg:setString(gameInfo)
		if nil ~= self["btnConfirm"] then
			self.btnConfirm = tolua.cast(self["btnConfirm"],"CCControlButton")
			self.btnConfirm:addTouchEventListener(function(event,x,y)
				print("btnConfirm====event:"..event);
				return true;
			end,false,-1,false);
	    end
		if nil ~= self["BtnCancel"] then
			self.BtnCancel = tolua.cast(self["BtnCancel"],"CCControlButton");
			self.BtnCancel:addTouchEventListener(function(event,x,y)
				print("btnConfirm====event:"..event);
				return true;
			end,false,-1,false);
	    end
	    
	end
	
	gBaseLogic.sceneManager.currentPage.view:showPopBoxCCB("interfaces/ChongZhiTanChu.ccbi",popBoxExit,true,0,9999);

end

function LobbyLogic:showNewbieGuide(type)
	print "LobbyLogic:showNewbieGuide"
	-- body
	self.newbieGuideScene = izx.basePage.new(self,"NewbieGuideScene","moduleLobby",{
			pageType = izx.basePage.PAGE_TYP_CODE,
			slideIn = "left",
            isCodeScene = true,
            initParam = {
            	enterType = type
            }
		}
	);
	gBaseLogic.currentState = gBaseLogic.stateInNewbieGuide;
	self.newbieGuideScene:enterScene();
end

function LobbyLogic:onPayTips(typ,payTyp,data,needGameMoney)
	print "LobbyLogic:onPayTips"
	print(typ,payTyp)
	print(needGameMoney)
	gBaseLogic:unblockUI()


	local popBoxExit = {};
	function popBoxExit:onPressChongZhi()  
		if (payTyp~=3) then
			gBaseLogic:addLogDdefine("quickPay","payMonery",needGameMoney)
		end      
		gBaseLogic.sceneManager.currentPage.view:closePopBox();
		if gBaseLogic.lobbyLogic.userHasLogined == false then 
        	gBaseLogic.lobbyLogic:showLoginTypeLayer()
        else
        	gBaseLogic:blockUI({autoUnblock=false})
        	gBaseLogic.lobbyLogic:pay(data,payTyp,typ);
    	end
	end
	function popBoxExit:onPressClose()        
	    gBaseLogic.sceneManager.currentPage.view:closePopBox();
	    gBaseLogic.lobbyLogic:dispatchLogicEvent({
	        name = "MSG_change_chongzhi_btn",
	        message = {code=-1,msg="支付取消！"}
	    });
	    print("MSG_change_chongzhi_btn")
	    if gBaseLogic.gameLogic~=nil then
			if gBaseLogic.gameLogic.moneyNotEnough == 1 then
				gBaseLogic.gameLogic:LeaveGameScene(-1)
			end
		end
	end
	function popBoxExit:onClosePopBox()
		-- gBaseLogic.lobbyLogic:dispatchLogicEvent({
	 --        name = "MSG_change_chongzhi_btn",
	 --        message = {code=-1,msg="支付取消！"}
	 --    });
	 --    print("MSG_change_chongzhi_btn")
	end
	function popBoxExit:onTouches(event,x,y)
		
	end
	function popBoxExit:onAssignVars()
		self.labelMoney = tolua.cast(self["labelMoney"],"CCLabelTTF");
		self.labelItems = tolua.cast(self["labelItems"],"CCLabelTTF");
		self.labelGotoGame = tolua.cast(self["labelGotoGame"],"CCLabelTTF");
		local num = 3;
		if typ==nil or typ<1 or typ>3 then
			num = 3
		else
			num = typ
		end
		for i=1,3 do 
			if i==num then
				self["node"..i]:setVisible(true)
			else
				self["node"..i]:setVisible(false)
			end
		end
		if typ==1 then
			if (gBaseLogic.lobbyLogic.gotoGameName==nil or gBaseLogic.lobbyLogic.gotoGameName=="") then
				gBaseLogic.lobbyLogic.gotoGameName = "本游戏";
			end
			print(gBaseLogic.lobbyLogic.gotoGameName)
			self.labelGotoGame:setString("您还差 "..needGameMoney .." 金币才能进入"..gBaseLogic.lobbyLogic.gotoGameName);
		end
		local needMoney = 0;
		for k,v in pairs(data.content) do
			if v.idx==0 then
				needMoney = v.num 
				break;
			end
		end
		if needMoney~=0 then

			self.labelMoney:setString(data.price.."元＝"..needMoney.."游戏币")
		else
			local sss = split(data.desc, ",");
			self.labelMoney:setString(data.price.."元＝"..sss[1])
		end
		
        
		
		if nil ~= self["onPressClose"] then
			self.onPressClose = tolua.cast(self["onPressClose"],"CCControlButton")
			self.onPressClose:addTouchEventListener(function(event,x,y)
				print("btnConfirm====event:"..event);
				return true;
			end,false,-1,false);
			
	    end

		if nil ~= self["btnChongzhi"] then
			self.btnChongzhi = tolua.cast(self["btnChongzhi"],"CCControlButton");
			self.btnChongzhi:addTouchEventListener(function(event,x,y)
				print("btnConfirm====event:"..event);
				return true;
			end,false,-1,false);
			
	    end
	    print("1111=============")
	    -- 8元=16万游戏币+记牌器X24+招财猫表情包
	    local send_money = needMoney

        
        local isshuangbei = 1;
	    if in_table(data.boxid,gBaseLogic.lobbyLogic.doubleChestids) then
	    	local shuangbei = display.newSprite("images/TanChu/shuangbei.png", 0, 0)
	    	self.nodeshuangbei:addChild(shuangbei)
	    	send_money = send_money*2;

            isshuangbei = 2;
        end
        local this_desc = data.price.."元="..math.floor(send_money/10000).."万游戏币"
        local this_desc_array = {}
        if data.content~=nil then
            for k,v in pairs(data.content) do
                if v.idx~=0 then      
                	if gBaseLogic.lobbyLogic.userHasLogined == false then 
                		break
    				end            
                    if gBaseLogic.lobbyLogic.userData.items_user[v.idx]~=nil then
                        if v.idx==5 then
                        	table.insert(this_desc_array,"招财猫表情包")
                        elseif v.idx==2 then
                        	table.insert(this_desc_array,gBaseLogic.lobbyLogic.userData.items_user[v.idx].name_..(v.num*isshuangbei).."个");
                        else
                            table.insert(this_desc_array,gBaseLogic.lobbyLogic.userData.items_user[v.idx].name_..v.num.."个");
                        end
                    end
                end
            end
        end
 		-- label:setDimensions(CCSize(380, 100));
       
    	if send_money ~= 0 then
    		if #this_desc_array>0   then
    			this_desc = this_desc.."+".. table.concat(this_desc_array, "+")
    		else
    			this_desc = this_desc
    		end
    	else
    		 if #this_desc_array>0   then
    			this_desc = data.price.."元="..table.concat(this_desc_array, "+")
    		else
    			this_desc = data.price.."元="..data.desc
    		end

    	end
       
          
        if isshuangbei==2 then
        	this_desc = this_desc.."\n（限购一次）"
        end
        self.labelItems:setDimensions(CCSize(560, 85))
        self.labelItems:setString(this_desc)
	end
	
	gBaseLogic.sceneManager.currentPage.view:showPopBoxCCB("interfaces/PoChan.ccbi",popBoxExit,false,0,9999);
end

function LobbyLogic:pt_cl_get_relief_times_req()
  local loginMsg = {opcode = 'pt_cl_get_relief_times_req'};
  self:sendLobbySocket(loginMsg);
end
function LobbyLogic:pt_lc_get_relief_times_ack_handler(message)
	print("LobbyLogic:pt_lc_get_relief_times_ack_handler")
	var_dump(message)
	self.relief_times_ = message.times_
	self:dispatchLogicEvent({
	        name = "MSG_Socket_pt_lc_get_relief_times_ack",
	        message = message
	    })
	
end
function LobbyLogic:sendLobbySocket(socketMsg)
	if self.lobbySocket==nil then
		gBaseLogic:reqLogin()
	else
		self.lobbySocket:send(socketMsg)
	end
end

return LobbyLogic; 
