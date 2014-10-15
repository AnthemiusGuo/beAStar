--
-- Author: Guo Jia
-- Date: 2014-02-26 10:13:02
--
local LobbyGameLogic = {};

function LobbyGameLogic.extend(object)
	for k,v in pairs(LobbyGameLogic) do
		if type(v) == "function" then
			object[k] = v;
		end
	end
end

function LobbyGameLogic:startRobotGame() 
	if (gBaseLogic.gameLogic) then
		gBaseLogic.gameLogic = nil;
	end
	gBaseLogic.gameLogic = require("moduleDdz.logics.GameLogic").new();
	gBaseLogic.currentGame = "moduleDdz";
	gBaseLogic.currentState = gBaseLogic.stateInSingleGame;
	gBaseLogic.gameLogic.is_robot = 1;
	gBaseLogic.gameLogic:showGameScene();
	gBaseLogic:addLogDdefine("gameType","robot",1)
end

function LobbyGameLogic:findSockconfig(gameModule,type)
	-- local ddzSocketConfig = -1;
	-- local serverList = 
	-- local serverList = {}
	-- for k,v in pairs(self.server_datas_) do 
	-- 	if (v.ext_param_) then

	-- 		local param = split(v.ext_param_,'|')
	-- 		v.isLaiZi = 0;
	-- 		v.needMoney = 0;
	-- 		for k1,v1 in pairs(param) do
	-- 			local param1 = split(v1,":");
	-- 			if (string.gsub(param1[1], "^%s*(.-)%s*$", "%1")=="laizi") then
	-- 			 	v.isLaiZi = 1;
	-- 			end
	-- 			if (param1[1]=="tax") then
	-- 			 	v.needMoney = string.gsub(param1[2], "%D+","");
	-- 			end
	-- 		end
	-- 		table.insert(serverList,v);
	-- 	end
	-- end
	print("LobbyGameLogic:findSockconfig")
	var_dump(self.server_datas_)
	table.sort(self.server_datas_,function(a,b) 
		if a.min_money_>b.min_money_ then
			return true
		else
			return false;
		end 
		end)
	print("LobbyGameLogic:findSockconfig")
	var_dump(self.server_datas_)
	local isLaiZi = 0;
	if (type==1) then
		isLaiZi=1;	
	end
	-- self.userData.
	local userMoney = self.userData.ply_lobby_data_.money_;
	local needMoney = 0;
	local min_money_ = 0;
	local level = 0;
	local maxMoney = 0;
	local server_name_ = ""
	local ddzSocketConfig=-1;
	for k,v in pairs(self.server_datas_) do
		if isLaiZi == v.isLaiZi then 
			if v.min_money_<= userMoney then
				ddzSocketConfig = {socketIp = v.server_addr_,socketPort = v.server_port_}
				needMoney = v.needMoney;
				min_money_ = v.min_money_;
				level = v.level;
				maxMoney = v.maxMoney;
				server_name_ = v.server_name_;
				break
			end
		end

	end
	return {SocketConfig=ddzSocketConfig,server_name=server_name_,isLaiZi=isLaiZi,needMoney=needMoney,min_money_=min_money_,gameModule=gameModule,level=level,maxMoney=maxMoney}
	-- return SocketConfigList
end
-- type : -1,快速开始；0，普通场；1，癞子场； 2，娱乐场 ; -2,异常进入
function LobbyGameLogic:startGame(gameModule,type) 
	gBaseLogic:blockUI();
	if self.isOnGameExit==1 then
		gBaseLogic:unblockUI();
		self:gobackGameforonExitConfirm();	
		return;
	end
	local SocketConfigList = self:findSockconfig(gameModule,type);	
	if (SocketConfigList.SocketConfig==-1) then
		-- gBaseLogic:onNeedMoney("gameenter",SocketConfigList.min_money_);	
		self:startGameByTypLevel(0,1)	
		return;
	end
	self:realStartGame(SocketConfigList)
	
	--测试
	-- gBaseLogic.gameLogic:setIsLaiZi(1);
end

function LobbyGameLogic:realStartGame(SocketConfigList)
	-- if (gBaseLogic.gameLogic and gBaseLogic.currentGame ~= SocketConfigList.gameModule) then
	-- 	gBaseLogic.gameLogic = nil;
	-- end
	print("LobbyLogic:realStartGame===")
	var_dump(SocketConfigList,3)
	if (gBaseLogic.gameLogic) then
		if (gBaseLogic.gameLogic.resDir) then
			izx.resourceManager:removeSearchPath(gBaseLogic.gameLogic.resDir);
		end
		if (gBaseLogic.gameLogic.onGameExit) then
			gBaseLogic.gameLogic:onGameExit();
		end
		gBaseLogic.gameLogic = nil;
	end
	self:showFakeLoadingScene("moduleMainGame");
	if (gBaseLogic.gameLogic == nil or gBaseLogic.currentGame ~=SocketConfigList.gameModule) then
		print("====realStartGame==moduleMainGame")
		gBaseLogic.gameLogic = require(SocketConfigList.gameModule ..".logics.GameLogic").new();
		gBaseLogic.currentGame = SocketConfigList.gameModule;
	end
	gBaseLogic.currentState = gBaseLogic.stateInRealGame;
	gBaseLogic.gameLogic.curSocketConfigList = SocketConfigList;
	-- var_dump(SocketConfigList)
	if SocketConfigList.isLaiZi == 1 then 
		gBaseLogic:addLogDdefine("gameType","laizi",SocketConfigList.level)
	else 
		gBaseLogic:addLogDdefine("gameType","happy",SocketConfigList.level)
	end
end

function LobbyGameLogic:realStartMatchGame(SocketConfigList)
	if (gBaseLogic.gameLogic) then
		if (gBaseLogic.gameLogic.resDir) then
			izx.resourceManager:removeSearchPath(gBaseLogic.gameLogic.resDir);
		end
		if (gBaseLogic.gameLogic.onGameExit) then
			gBaseLogic.gameLogic:onGameExit();
		end
		gBaseLogic.gameLogic = nil;
	end
	self:showFakeLoadingScene("moduleMainGame");
	if (gBaseLogic.gameLogic == nil or gBaseLogic.currentGame ~=SocketConfigList.gameModule) then
		gBaseLogic.gameLogic = require(SocketConfigList.gameModule ..".logics.GameLogic").new();
		gBaseLogic.currentGame = SocketConfigList.gameModule;
	end
	gBaseLogic.currentState = gBaseLogic.stateInRealGame;
	
	gBaseLogic.gameLogic.curSocketConfigList = SocketConfigList;
	gBaseLogic.gameLogic.isMatch = 1;
	gBaseLogic.gameLogic.curMatchID = SocketConfigList.match_id;
	gBaseLogic.gameLogic.curMatchOrderID = SocketConfigList.match_order_id;
	gBaseLogic.gameLogic.curMatchScore = SocketConfigList.current_score;
	gBaseLogic.gameLogic.curMatchRound = SocketConfigList.round_index;
	gBaseLogic.gameLogic.curMatchTRound = SocketConfigList.totoal_round;
end 
function LobbyGameLogic:startMatchGames(matchInfo)
	local ddzSocketConfig = {socketIp = matchInfo.data_.server_addr_,socketPort = matchInfo.data_.server_port_}

	local SocketConfigList = {SocketConfig=ddzSocketConfig,server_name=matchInfo.data_.server_name_,isLaiZi=2,needMoney=0,min_money_=1,max_money_=1,gameModule="moduleDdz",level=0,match_order_id = matchInfo.match_order_id_,match_id = matchInfo.match_id_,current_score = matchInfo.current_score_,round_index = matchInfo.round_index_,totoal_round=matchInfo.totoal_round_}
	self:realStartMatchGame(SocketConfigList)
end
function LobbyGameLogic:startMatchGame(gameModule,matchid,type) 
	print("startMatchGame:",gameModule,matchid,type)
	--gBaseLogic:blockUI();
	if self.isMatchOnGameExit==1 then
		--gBaseLogic:unblockUI();
		--self:reEnterMatchGame();	
		--return;
	end

	local isLaiZi = 0;
	local ddzSocketConfig=-1;
	local SocketConfigList = -1
	if (type==1) then
		isLaiZi=1;	
	end 
	var_dump(self.matchData,3)
	for k,v in pairs(self.matchData) do
		if matchid == v.match_id_ then 
			ddzSocketConfig = {socketIp = v.data_.server_addr_,socketPort = v.data_.server_port_}

			SocketConfigList = {SocketConfig=ddzSocketConfig,server_name=v.data_.server_name_,isLaiZi=isLaiZi,needMoney=0,min_money_=1,max_money_=1,gameModule=gameModule,level=0,match_order_id = v.match_order_id_,match_id = v.match_id_,current_score = v.current_score_,round_index = v.round_index_,totoal_round=v.totoal_round_}
			break
		end
	end
	var_dump(SocketConfigList)
	if SocketConfigList == -1 then 
		izxMessageBox("进入比赛错误，不存在本场比赛。","温馨提示")
		return
	end

	self:realStartMatchGame(SocketConfigList)
	

end 

function LobbyGameLogic:reEnterMatchGame(game_id_,game_server_id_)
	print("reEnterMatchGame",game_id_,game_server_id_)

	gBaseLogic:unblockUI();		
	var_dump(self.server_datas_,3)	
	var_dump(self.rematchData)	
	for k,v in pairs(self.server_datas_) do 
		if v.game_id_ == game_id_ and v.server_id_==game_server_id_ then
			local ddzSocketConfig = {socketIp = v.server_addr_,socketPort = v.server_port_}
				
			local SocketConfigList = {SocketConfig=ddzSocketConfig,server_name=v.server_name_,isLaiZi=0,needMoney=0,min_money_=1,max_money_=1,gameModule="moduleDdz",level=0,isErrjoin=1,match_order_id = self.rematchData.match_order_id_,match_id = self.rematchData.match_id_,current_score = self.rematchData.current_score_,round_index = self.rematchData.round_index_,totoal_round=self.rematchData.totoal_round_}

			self:realStartMatchGame(SocketConfigList)  
			self.closeGameErr = 0;
			return;
		end
	end

	self:closeSocket();
	self.onReOpened = 1;
	self:goBackToMain(false);

	self:reqLogin();
end

function LobbyGameLogic:pt_lc_server_data_not2_handler(message)	 
		print("===============pt_lc_server_data_not2_handler:"..#message.server_datas_)

		self.server_datas_ = {};
		var_dump(message.server_datas_,3)
		for k,v in pairs(message.server_datas_) do
			if (v.ext_param_) then
				local param = split(v.ext_param_,'|')
				v.isLaiZi = 0;
				v.needMoney = 0;
				v.maxMoney = 0;
				v.level = 0;
				v.max_player_size=1000
				for k1,v1 in pairs(param) do
					local param1 = split(v1,":");
					if (string.gsub(param1[1], "^%s*(.-)%s*$", "%1")=="laizi") then
					 	v.isLaiZi = 1;
					end
					if (string.gsub(param1[1], "^%s*(.-)%s*$", "%1")=="race") then
					 	v.isLaiZi = 2;
					end
					if (string.gsub(param1[1], "^%s*(.-)%s*$", "%1")=="match") then
					 	v.isLaiZi = 2;
					end
					 
					if (param1[1]=="tax") then
					 	v.needMoney = string.gsub(param1[2], "%D+","");
					end
					v.needMoney = tonumber(v.needMoney)
					if (param1[1]=="max") then
					 	v.maxMoney = string.gsub(param1[2], "%D+","");
					end
					v.maxMoney = tonumber(v.maxMoney)
					if (param1[1]=="level") then
					 	v.level = string.gsub(param1[2], "%D+","");
					end
					v.level = tonumber(v.level)
					if (param1[1]=="max_player_size") then
					 	v.max_player_size = string.gsub(param1[2], "%D+","");
					 	print("max_player_size")
					 	print(v.max_player_size)
					end
					v.max_player_size = tonumber(v.max_player_size)
				end
				table.insert(self.server_datas_,v);
			end
		end
		-- table.sort(self.server_datas_,function(a,b) 
		-- if a.min_money_<b.min_money_ then
		-- 	return true
		-- else
		-- 	return false;
		-- end 
		var_dump(self.server_datas_,3)
		print("pt_lc_server_data_not2_handler,self.closeGameErr =",self.closeGameErr)
		-- end)
		--[[
		if (self.closeGameErr==2) then 
			if (gBaseLogic.currentState ~= gBaseLogic.stateInRealGame) then
				print("2222222")
				self:reEnterMatchGame(self.userData.ply_status_.game_id_,self.userData.ply_status_.game_server_id_ )
			else
				self.closeGameErr = 0;
			end
		end
		--]]
		if (self.closeGameErr==1) then
			
			gBaseLogic:unblockUI();
			if (gBaseLogic.currentState ~= gBaseLogic.stateInRealGame) then
				print("1111111")
				self:reEnterGame(self.userData.ply_status_.game_id_,self.userData.ply_status_.game_server_id_ )
			else
				self.closeGameErr = 0;
			end

			-- for k,v in pairs(self.server_datas_) do 
			-- 	if v.game_id_ == self.userData.ply_status_.game_id_ and v.server_id_==self.userData.ply_status_.game_server_id_ then
			-- 		local ddzSocketConfig = {socketIp = v.server_addr_,socketPort = v.server_port_}
			-- 		local isLaiZi = v.isLaiZi;
			-- 		local needMoney = v.needMoney;					
			-- 		local SocketConfigList = {SocketConfig=ddzSocketConfig,isLaiZi=isLaiZi,needMoney=needMoney,min_money_=v.min_money_,max_money_=v.maxMoney,gameModule="moduleDdz",isErrjoin=1,level=v.level}
			-- 		self:realStartGame(SocketConfigList) 
			-- 		self.closeGameErr = 0;
			-- 		break;
			-- 	end
			-- end
		end 

		-- var_dump(message,3)
		
		
end
function LobbyGameLogic:reEnterGame(game_id_,game_server_id_)

	-- if self.isMatch == 1 then 
	-- 	self:reEnterMatchGame(game_id_,game_server_id_)
	-- 	return;
	-- end
	print("LobbyGameLogic:reEnterGame");
	gBaseLogic:unblockUI();			
	for k,v in pairs(self.server_datas_) do 
		if v.game_id_ == game_id_ and v.server_id_==game_server_id_ then
			local ddzSocketConfig = {socketIp = v.server_addr_,socketPort = v.server_port_}
			local isLaiZi = v.isLaiZi;
			local needMoney = v.needMoney;					
			local SocketConfigList = {SocketConfig=ddzSocketConfig,isLaiZi=isLaiZi,needMoney=needMoney,min_money_=v.min_money_,max_money_=v.maxMoney,gameModule="moduleDdz",isErrjoin=1,level=v.level}
			self:realStartGame(SocketConfigList) 
			self.closeGameErr = 0;
			return;
		end
	end
	self:closeSocket();
	self.onReOpened = 1;
	self:goBackToMain(false);
	-- if self.lobbySocket ~= nil then

	-- 	self.lobbySocket:connect();
	-- end
	self:reqLogin();
end 

function LobbyGameLogic:startGameByTypLevel2(type,level)
	local min_money_list = {1000,10000,50000};
 	-- local cofigGamename = {[1]={"癞子初级场","中级场","高级场"}}
	print("startGameByTypLevel",type,k)		
	table.sort(self.server_datas_,function(a,b) 
		if b.online_player_num_>a.online_player_num_ then
			return true
		else
			return false;
		end 
		end)
	local userMoney = self.userData.ply_lobby_data_.money_;
	local flag = 0 ;
	for key,v in pairs(self.server_datas_) do 
		if v.isLaiZi == type then
			print("==========="..key)
			-- print(v.isLaiZi,v.level,level)	
			v.level = tonumber(v.level)		
			if tonumber(v.level) == tonumber(level) then
				flag = 1;
				print(v.maxMoney .."startGameByTypLevelserver_datas_"..level .."--"..userMoney)
				if (userMoney<v.min_money_ ) then
					-- local msg = "你的游戏币低于入场限制"
					-- 	local initParam = {msg=msg,needMoney=v.min_money_,type=2};
					-- 	self:showYouXiTanChu(initParam)
					self.gotoGameName = v.server_name_;
					print("startGameByTypLevel")
					print(self.gotoGameName)
					gBaseLogic:onNeedMoney("gameenter",v.min_money_,1);
					break;
				end
				-- if userMoney< v.min_money_  and  v.level == 1 and self.relief_times_ <= 0 then
				-- 	self.gotoGameName = v.server_name_;
				-- 	print("startGameByTypLevel")
				-- 	print(self.gotoGameName)
				-- 	gBaseLogic:onNeedMoney("gameenter",v.min_money_,1);
				-- 	break;

				-- end
				if level~=3 and v.maxMoney~=0 then
					if tonumber(v.maxMoney) < userMoney then
						local msg = "别在低倍率场欺负小农民啦，赶快去高倍率场劫富济贫吧！"
						local initParam = {msg=msg,gameType=type,type=1};
						self:showYouXiTanChu(initParam)
						break;
					end
				end
				local ddzSocketConfig = {socketIp = v.server_addr_,socketPort = v.server_port_}
				local isLaiZi = v.isLaiZi;
				local needMoney = v.needMoney;
				local SocketConfigList = {SocketConfig=ddzSocketConfig,server_name=v.server_name_,isLaiZi=isLaiZi,needMoney=needMoney,min_money_=v.min_money_,max_money_=v.maxMoney,gameModule="moduleDdz",level=v.level}
				self:realStartGame(SocketConfigList) 
				break;
			end
		end
	end
	if flag==0 then
		izxMessageBox("服务器配置出错", "服务器错误")
	end
end

function LobbyGameLogic:startGameByTypLevel(type,k)
	if self.isOnGameExit==1 then
		gBaseLogic:unblockUI();
		self:gobackGameforonExitConfirm();	
		return;
	end
	if 1 == type  then 
		gBaseLogic:showLaiZiTips(type,k,self)
		return
	end 
	self:startGameByTypLevel2(type,k)
end

function LobbyGameLogic:startGameByServerId(severId)
	for k,v in pairs(self.server_datas_) do 
		if  v.server_id_==severId then
			local ddzSocketConfig = {socketIp = v.server_addr_,socketPort = v.server_port_}
			local isLaiZi = v.isLaiZi;
			local needMoney = v.needMoney;	
			local SocketConfigList = {SocketConfig=ddzSocketConfig,server_name=v.server_name_,isLaiZi=isLaiZi,needMoney=needMoney,min_money_=v.min_money_,max_money_=v.maxMoney,gameModule="moduleZJH",level=v.level}
			self:realStartGame(SocketConfigList) 
			break;
		end
	end
end
function LobbyGameLogic:pt_cl_match_require_status_req(info)
	--  {
 --      name = "match_id_",
 --      type = "int",
 --      option = "required"
 --    },
 --    {
 --      name = "match_order_id_",
 --      type = "int",
 --      option = "required"
 --    },
 --    {
	-- 	name = 	"round_index_",
	-- 	type = 	"int",
	-- 	option = "required"
	-- }
	print ("LobbyLogic:pt_cl_match_require_status_req")
	local socketMsg = {
		opcode = 'pt_cl_match_require_status_req',
		match_id_ = info.match_id_,
		match_order_id_=info.match_order_id_,
		round_index_=info.round_index_
		};
	self:sendLobbySocket(socketMsg);
end
return LobbyGameLogic; 