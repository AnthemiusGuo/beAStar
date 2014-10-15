--[[------------------------------[[--
	Author : Sun
--]]------------------------------]]--
----------------------------------------------------------------------------------------------------
local AwardExchangeSceneController = class("AwardExchangeSceneController", izx.baseCtrller);
----------------------------------------------------------------------------------------------------
function AwardExchangeSceneController:ctor(pageName, moduleName, initParam)

	self.super.ctor(self, pageName, moduleName, initParam);
end

function AwardExchangeSceneController:run()

end
----------------------------------------------------------------------------------------------------
function AwardExchangeSceneController:getTicketExchangeData(idx)

	gBaseLogic:blockUI(nil, false);
	print("getTicketExchangeData")
	local paramNameList = {"pn", "gameid", "index"};
	local paramDataTable = 
	{
		pn = gBaseLogic.packageName, 
		gameid = MAIN_GAME_ID, 
		index = idx
	};
	local url = supplant(URL.GET_ITEM_LIST, paramNameList, paramDataTable);
	print(url)
	gBaseLogic:HTTPGetdata(url, 0, function(event)

		var_dump(event,3);

		gBaseLogic:unblockUI();

		if self ~= nil and event ~= nil and event.item ~= nil then

			event.item.view = self.view;

			self.view:initTableView(0, event.item);
		end
	end);
end

function AwardExchangeSceneController:exchangeAward(code)

	gBaseLogic:blockUI(nil, false);

	local params = "uid="..self.logic.userData.ply_guid_.."&gameid="..MAIN_GAME_ID.."&giftkey="..code.."asdf1234ghjk5678";
	local sign = crypto.md5(params);
	local paramNameList = {"pid", "ticket", "cdk", "gameid", "sign"};
	local paramDataTable = 
	{
		pid = self.logic.userData.ply_guid_, 
		ticket = self.logic.userData.ply_ticket_, 
		cdk = code, 
		gameid = MAIN_GAME_ID, 
		sign = sign
	};
	local url = supplant(URL.CDKAWARD, paramNameList, paramDataTable);

	gBaseLogic:HTTPGetdata(url, 0, function(event)

		var_dump(event, 3);

		gBaseLogic:unblockUI();

		if self ~= nil and event ~= nil and event.ret then

			izxMessageBox(event.msg, "兑换成功");
		else
			izxMessageBox(event.msg, "兑换失败");
		end
	end);
end

function AwardExchangeSceneController:getExchangeRecordData()

	gBaseLogic:blockUI(nil, false);

	local params = "uid="..self.logic.userData.ply_guid_.."&pn="..gBaseLogic.packageName.."&key=asdf1234ghjk";
	local sign = crypto.md5(params);
	local paramNameList = {"pn", "uid", "ticket"};
	local paramDataTable = 
	{
		pn = gBaseLogic.packageName, 
		uid = self.logic.userData.ply_guid_, 
		ticket = sign
	};
	local url = supplant(URL.GET_ITEM_EXCHANGE_RECORD_LIST, paramNameList, paramDataTable);

	gBaseLogic:HTTPGetdata(url, 0, function(event)

		var_dump(event, 3);

		gBaseLogic:unblockUI();

		if self ~= nil and event ~= nil and event.item ~= nil then

			self.view:initTableView(1, event.item);
		end
	end);
end

function AwardExchangeSceneController:exchargingTicket(gid, item)
	print("exchargingTicket")
	local params = "uid="..self.logic.userData.ply_guid_.."&pn="..gBaseLogic.packageName.."&key=asdf1234ghjk"
	local sign = crypto.md5(params);
	local paramNameList = {"pn", "gameid", "gid", "uid", "ticket"};
	local paramDataTable = 
	{
		pn = gBaseLogic.packageName, 
		gameid = MAIN_GAME_ID, 
		gid = gid, 
		uid = self.logic.userData.ply_guid_, 
		ticket = sign
	};
	local url = supplant(URL.EXCHANGE_ITEM, paramNameList, paramDataTable);

	gBaseLogic:HTTPGetdata(url, 0, function(event)
		var_dump(event, 3);
		gBaseLogic:unblockUI();
		if event ~= nil then
			izxMessageBox(event.msg, "信息");

			if event.ret == 0 then
				gBaseLogic.sceneManager.currentPage.view.numTicketsText:setString(event.gift);
				gBaseLogic.sceneManager.currentPage.view.huafeiquan = event.gift
				item["numberText0"]:setString("剩余："..event.left.."张");
				-- 后台会下发pt_lc_send_user_data_change_not事件通告
				-- for i = 1, #gBaseLogic.lobbyLogic.userData.ply_items_ do
				-- 	local itemData = gBaseLogic.lobbyLogic.userData.ply_items_[i];
				-- 	if itemData.index_ == 56 then
				-- 		gBaseLogic.lobbyLogic.userData.ply_items_[i].num_ = event.gift
				-- 		break;
				-- 	end		 
				-- end
			else
				local msg = "您没有话费卡了。"		
				local ret = event.ret
				if ret==-2 then
					msg = "签名错误或者请求过于频繁。"
				elseif ret==-3 then
					msg = "此商品不存在。"
				elseif ret==-4 then	
					msg = "不满足兑换条件。"
				elseif ret==-5 then	
					msg = "扣除道具失败。"
				end		
				local initParam = {msg=msg,type=1000};
				self.logic:showYouXiTanChu(initParam)
			end
		end
	end);
end 

function AwardExchangeSceneController:exchargingGift(gid, item)
	print("exchargingGift")
	local params = "uid="..self.logic.userData.ply_guid_.."&pn="..gBaseLogic.packageName.."&key=asdf1234ghjk"
	local sign = crypto.md5(params);

	local url = string.gsub(URL.EXCHANGE_ITEM,"{gid}",gid);
	url = string.gsub(url,"{uid}",self.logic.userData.ply_guid_);
	url = string.gsub(url,"{ticket}",sign);
	url = string.gsub(url,"{pn}",gBaseLogic.packageName);
	url = string.gsub(url,"{gameid}",MAIN_GAME_ID);
	print("Check the url :"..url);
	gBaseLogic:HTTPGetdata(url, 0, function(event)
		gBaseLogic:unblockUI();
		if event==nil then
			izxMessageBox("网络错误请重试","提示");
		else
			if (event.ret == 0) then
				item["numberText0"]:setString("剩余："..event.left.."张")
			end
    		self:onGetExchargingGiftData(event)
    	end
    end)
end

function AwardExchangeSceneController:onGetExchargingGiftData(event)

	print "AwardExchangeSceneController:onGetExchargingGiftData";
	var_dump(event);
	
	if event.ret == 0 then
		-- 后台会下发pt_lc_send_user_data_change_not事件通告
		--gBaseLogic.lobbyLogic.userData.ply_lobby_data_.gift_ = event.gift
		self.view.numTicketsText2:setString(event.gift);
		izxMessageBox("兑换成功，请到兑换记录中查看发货进度。","提示");
	else
		local msg = "您的元宝不够了。"		
		local ret = event.ret
		if ret==-2 then
			msg = "签名错误或者请求过于频繁。"
		elseif ret==-3 then
			msg = "此商品不存在。"
		elseif ret==-4 then	
			msg = "不满足兑换条件。"
		elseif ret==-5 then	
			msg = "扣除道具失败。"
		end		
		local initParam = {msg=msg,type=1000};
		self.logic:showYouXiTanChu(initParam)
	end

end
----------------------------------------------------------------------------------------------------
return AwardExchangeSceneController;
----------------------------------------------------------------------------------------------------