local GoldExchangeSceneCtrller = class("GoldExchangeSceneCtrller",izx.baseCtrller)

function GoldExchangeSceneCtrller:ctor(pageName,moduleName,initParam)
    self.data = {
    	propsData = {};
    	rechargeCardDataList = {};
    	rechargeCardTypeNum = 0;
    	rechargeCardListIdx = 0;
    	num = 0;
    	rechargeRecordDataList = {};
    	userData = {};
    	recordTypeNum = 0; 
    };

	self.super.ctor(self,pageName,moduleName,initParam);
end

function GoldExchangeSceneCtrller:onEnter()
    -- body
end

function GoldExchangeSceneCtrller:run()

	print "GoldExchangeSceneCtrller:run"
	self.data.userData = self.logic.userData;
	GoldExchangeSceneCtrller.super.run(self);

end

function GoldExchangeSceneCtrller:getData(type)
	
	print "GoldExchangeSceneCtrller:getData"
	--props
	if(type == 0) then

		print "onGetPropsData"
		local url = "http://www.baidu.com/";
		if(#(url) ~= 0) then
			print("Check the url :"..url);
			gBaseLogic:HTTPGetdata(url, 0, function(event)
        	self:onGetPropsData(event)
        	end)
		end
	--rechargeableCard
	elseif (type == 1) then
		-- self.data.rechargeCardDataList = {
		-- {desc="所需元宝1000个",price="10",sn="移动10元卡",gid="372",
		-- 	logo="http://img.cache.bdo.banding.com.cn/goodslogo/yidongshenzhouxing310.png",
		-- 	left = 0
		-- 	}
		-- }
		-- self.view.tabViewLayer:init(1,self.data.rechargeCardDataList);
		 
		print "onGetRechargeCardData"

 		local url = string.gsub(URL.GOLDEXC_RECHCARD_TYPE,"{packageName}",gBaseLogic.packageName);
 		--local url = "http://m.payment.hiigame.com:18000/new/gateway/vou/goods/types?pn=com.izhangxin.ddz.lua.test";
		print("Check the url :"..url);
		gBaseLogic:blockUI();
		gBaseLogic:HTTPGetdata(url, 0, function(event)
        	self:onGetRechargeCardData(event)
        end)
		
	--rechargingRecords
	elseif(type == 2) then
		print "onGetRechargeRecordData"
		local url = string.gsub(URL.GOLDEXC_EXCRECORD,"{pid}",self.data.userData.ply_guid_);
		url = string.gsub(url,"{ticket}",self.data.userData.ply_ticket_);
		url = string.gsub(url,"{packageName}",gBaseLogic.packageName);
		--0.游戏币 1.实物
		url = string.gsub(url,"{type}","0");
		print("Check the url :"..url);
		gBaseLogic:blockUI();
		
		gBaseLogic:HTTPGetdata(url, 0, function(event)
        	self:onGetRechargeRecordData(event)
        end)
        url = string.gsub(url,"type=0","type=1");
        print("Check the url :"..url);
        
        gBaseLogic:HTTPGetdata(url, 0, function(event)
        	self:onGetRechargeRecordData(event)
        end)
	end
end

function GoldExchangeSceneCtrller:onGetPropsData(event)

	print "GoldExchangeSceneCtrller:onGetPropsData"
	gBaseLogic:unblockUI();
	var_dump(event);

	-- --模拟数据
	--    self.data.propsData = {
	--    	{desc="所需元宝数为2",sn= "2万游戏币",}
	--    }
	--    var_dump(self.data.propsData);
	self.view.tabViewLayer:init(0,self.data.propsData);
end


function GoldExchangeSceneCtrller:onGetRechargeCardData(event)

	print "GoldExchangeSceneCtrller:onGetRechargeCardData"
	if (event==nil) then
		return;
	end
	var_dump(event.list)
	gBaseLogic:unblockUI();
	self.data.rechargeCardTypeNum = #event.list;

	for i,v in pairs(event.list) do
		print("i = "..i);
		local url = string.gsub(URL.GOLDEXC_RECHCARD_LIST,"{type}",v.type);
		print("Check the url :"..url);
		gBaseLogic:HTTPGetdata(url, 0, function(event)

			for k,v in pairs(event.list) do	
	 			table.insert(self.data.rechargeCardDataList,v)
	 		end
	 		self.data.num = self.data.num + 1;
	 	
			if (self.data.num == self.data.rechargeCardTypeNum) then

				gBaseLogic:unblockUI();
				var_dump(self.data.rechargeCardDataList)
				self.view.tabViewLayer:init(1,self.data.rechargeCardDataList);
			end
        end)
	end

end

function GoldExchangeSceneCtrller:exchargingGift(type,idx)

	print("GoldExchangeSceneCtrller:exchargingGift");
	print("type : "..type..",idx : "..idx);
	--0.道具 1.充值卡
	
	if(type == 0) then

	elseif(type == 1) then
		self.data.rechargeCardListIdx = idx;
		local rechargeCardData = self.data.rechargeCardDataList[self.data.rechargeCardListIdx];

 		--local url = string.gsub(URL.GOLDEXC_EXCGIFT,"{packageName}",gBaseLogic.packageName);

 		local url = string.gsub(URL.GOLDEXC_EXCGIFT,"{gid}",rechargeCardData.gid);
 		url = string.gsub(url,"{pid}",self.data.userData.ply_guid_);
 		url = string.gsub(url,"{ticket}",self.data.userData.ply_ticket_);
 		url = string.gsub(url,"{packageName}",gBaseLogic.packageName);
 		url = string.gsub(url,"{gameid}",MAIN_GAME_ID);
 		print("Check the url :"..url);
		gBaseLogic:HTTPGetdata(url, 0, function(event)
			if event==nil then
				izxMessageBox("网络错误请重试","提示");
			else
        		self:onGetExchargingGiftData(event)
        	end
        end)
	end
end

function GoldExchangeSceneCtrller:onGetExchargingGiftData(event)

	print "GoldExchangeSceneCtrller:onGetExchargingGiftData";
	var_dump(event);
	gBaseLogic:unblockUI();
	if (event.ret == 0) then
		izxMessageBox("兑换成功","提示");
		
	else
		local msg = "您的元宝不够或者没有话费卡了"		
		local ret = event.ret
		if ret==-2 then
			msg = "不存在该ID的实物 或者实物剩余数为0 请联系客服"
		elseif ret==-3 then
			msg = "您的元宝不够,游戏中完成任务可获得元宝"
		elseif ret==-4 then	
			msg = "兑换失败,请重试"
		end		
		local initParam = {msg=msg,type=1000};
		self.logic:showYouXiTanChu(initParam)
	end

end

function GoldExchangeSceneCtrller:onGetRechargeRecordData(event)

	print("GoldExchangeSceneCtrller:onGetRechargeRecordData");
	gBaseLogic:unblockUI();
	for k,v in pairs(event.resultList) do	
 		table.insert(self.data.rechargeRecordDataList,v)
 	end
 	self.data.recordTypeNum = self.data.recordTypeNum + 1;
	if (self.data.recordTypeNum == 2) then
		gBaseLogic:unblockUI();
		var_dump(self.data.rechargeRecordDataList)
		self.view.tabViewLayer:init(2,self.data.rechargeRecordDataList);
		self.data.recordTypeNum = 0;
	end
end


return GoldExchangeSceneCtrller;