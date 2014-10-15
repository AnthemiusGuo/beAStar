local ShopSceneCtrller = class("ShopSceneCtrller",izx.baseCtrller)

function ShopSceneCtrller:ctor(pageName,moduleName,initParam)
    -- self.data = {
    -- 	itemlist = {},
    -- 	viplist = {},
    -- 	historylist = {}
    -- };
    self.payitemslist = {}
    self.payMid = 0
    self.payMidvip = 0
    self.payType=''
    self.payTypevip=''
    self.payTypelist = {}
    self.data = {};
    self.shopType = 0;
    self.maxMoney = ""
    if (initParam.type~=nil) then
    	self.shopType = initParam.type;
    end
    print("ShopSceneCtrller:ctor")
	ShopSceneCtrller.super.ctor(self,pageName,moduleName,initParam);

	self.payTypelist = gBaseLogic:getPayMidList()
	var_dump(self.payTypelist)
	--self.payTypelist = nil --for test
	if nil ~= self.payTypelist and #self.payTypelist > 0 then
		self.payMid = CCUserDefault:sharedUserDefault():getIntegerForKey("UserPayMid",self.payTypelist[1].mid)

		self.payType = CCUserDefault:sharedUserDefault():getStringForKey("UserPayType",self.payTypelist[1].payTyp)


		local tmpmid, tmptype = self:getNoSMSmid(self.payTypelist)
		self.payMidvip = CCUserDefault:sharedUserDefault():getIntegerForKey("UserPayMidVip",tmpmid)	

		self.payTypevip = CCUserDefault:sharedUserDefault():getStringForKey("UserPayTypeVip",tmptype)

		--print("---"..self.payTypelist[1].mid.."++++++"..self.payMid.."######"..self.payMidvip)
	end	
end

function ShopSceneCtrller:getNoSMSmid(t)
 	for k,v in pairs(t) do 
	    if v.payTyp ~= "SMS"  then 
	        return v.mid,v.payTyp
	    end
    end 
    for k,v in pairs(t) do 
	    return v.mid,v.payTyp
    end 
end
function ShopSceneCtrller:run()
	print("ShopSceneCtrller:run"..self.shopType)
	

	if (self.shopType==1) then
		self.view:onPressVip()
	else
		if ((gBaseLogic.lobbyLogic.paymentItemList)==nil) then
			print("-------------------no paymentItemList data----");
			gBaseLogic.lobbyLogic:requestHTTPPaymentItems(self.shopType)
		else
			self:onHTTPPaymentData();
		end

	end
	-- gBaseLogic.lobbyLogic:requestHTTPPaymentItems(0)
	--self:getMaxPayMoney()
	self.logic:addLogicEvent("MSG_HTTP_ShopData",handler(self, self.onHTTPPaymentData),self);
	self.logic:addLogicEvent("MSG_HTTP_ShopDataVip",handler(self, self.onHTTPVIPData),self);
	self.logic:addLogicEvent("MSG_Socket_pt_lc_send_vip_data_change_not",handler(self, self.onvipDataReload),self);
	
	ShopSceneCtrller.super.run(self);
 	
end
function ShopSceneCtrller:onvipDataReload(event)
	self.view:loadvippageInfo();
end
function ShopSceneCtrller:getMaxPayMoney(target)
	print("------------------------")

	if self.maxMoney == nil or self.maxMoney == "" then
		local tableRst = {pn = gBaseLogic.packageName,version = gBaseLogic.versionNum};
		--url = "http://t.statics.hiigame.com/get/consumelimit/tips?pn=com.izhangxin.scmj.android.anzhi&version=2.0.1"
		--gBaseLogic:HTTPGetdata(url,0,function(event)
		--HTTPPostRequest("http://t.statics.hiigame.com/get/consumelimit/tips", tableRst, function(event)
		HTTPPostRequest(URL.XIAOFEIXIANE, tableRst, function(event)
	        if (event ~= nil) then        	
	        	self.maxMoney = event.tips	
	        else
	        	self.maxMoney = "每日最高限额（2000）元"        
		    end	   
		    target:setString(self.maxMoney) 
	    end);
    else
    	target:setString(self.maxMoney)
    end

end

function ShopSceneCtrller:onEnter()
    -- body
end

function ShopSceneCtrller:checkPayType()
    self.payitemslist = nil
    self.payitemslist = {}
    print("ShopSceneCtrller:checkPayType"..self.payMid)
    var_dump(self.logic.paymentItemList)
    if self.shopType == 0 then 
    	print("self.shopType == 0")
	    if self.logic.paymentItemList~=nil then 
	    	echoInfo("self.payMid %d", self.payMid);
	    	if self.payMid == 0 then
    			self.payitemslist = self.logic.paymentItemList
    			return
    		end
    		local tmptype = self:selectPayType()
    		if tmptype=="Normal" then 
    			
		        for k,v in pairs(self.logic.paymentItemList) do
		         	if in_table(self.payMid,v.payidList) then
		         		table.insert(self.payitemslist,v)	         	
		         	end	         	
		        end
		    else
		    	for k,v in pairs(self.logic.payItemSMS) do
		    		if in_table(self.payMid,v.payidList) then
		         		table.insert(self.payitemslist,v)	         	
		         	end
		         		         	
		        end
		    end
	    end 
	elseif self.shopType == 1 then
		print("self.shopType == 1")
		echoInfo("self.payMidvip %d", self.payMidvip);
		if self.logic.VIPItemList~=nil then 
			if self.payMidvip == 0 then
    			self.payitemslist = self.logic.VIPItemList
    			return
    		end

	        for k,v in pairs(self.logic.VIPItemList) do
				if in_table(self.payMidvip,v.payidList) then
	         		table.insert(self.payitemslist,v)
	         	end 
	        end
	    end 
	end
	var_dump(self.logic.VIPItemList);
end

function ShopSceneCtrller:selectPayType()
	if self.payMid == 0 then 
		return "Normal"
	end
	if self.shopType == 0 then
		gBaseLogic:addLogDdefine("shopPay","payType",self.payType)
		for k,v in pairs(self.payTypelist) do
			if in_table(self.payMid,v) then 
				if v.payTyp == self.payType then 
			   		return v.payTyp
			   	end
			end	
		end
	elseif self.shopType == 1 then
		gBaseLogic:addLogDdefine("shopPay","vipPayType",self.payTypevip)
		for k,v in pairs(self.payTypelist) do
			if in_table(self.payMidvip,v) then
				if v.payTyp == self.payTypevip then 
			   		return v.payTyp
			   	end
			end	
		end
	end
end

function ShopSceneCtrller:onHTTPPaymentData()
	gBaseLogic:unblockUI();
	--self.data.itemlist = gBaseLogic.lobbyLogic.paymentItemList;
	self:checkPayType()
	--self.view.tabViewLayer:init(0,self.data.itemlist)
	self.view:initTableView(self.view.tabViewLayer,0,self.payitemslist)
end

function ShopSceneCtrller:onHTTPVIPData()
	print("ShopSceneCtrller:onHTTPVIPData");
	gBaseLogic:unblockUI();
	--self.data.viplist = gBaseLogic.lobbyLogic.VIPItemList;	
	-- print("====ShopSceneCtrller:onHTTPVIPData") 
	-- var_dump(self.data.viplist)
	-- print("====ShopSceneCtrller:onHTTPVIPData") 
	--self.view.tabViewLayer:init(1,self.data.viplist)	
	self:checkPayType()
	self.view:initTableView(self.view.tabViewLayer,1,self.payitemslist)
end

-- LobbyLogic.MSG_HTTP_ShopDataVip = "MSG_HTTP_ShopDataVip"
-- LobbyLogic.MSG_HTTP_ShopData = "MSG_HTTP_ShopData" --普通

function ShopSceneCtrller:requestHTTShopHistory()
	-- 商城充值记录
	gBaseLogic:blockUI();
	local url = string.gsub(URL.SHOP_HISTORY,"{pid}",self.logic.userData.ply_guid_ );
	url = string.gsub(url,"{packageName}",gBaseLogic.packageName);
	url = string.gsub(url,"{ticket}",self.logic.userData.ply_ticket_);
	--test
	-- local url = "http://mall.hiigame.com/vou/order/list&pid=".. self.userData.ply_guid_ .."&ticket="..self.userData.ticket .."&pn=" .. gBaseLogic.packageName --正式
	 
	--url = "http://t.mall.hiigame.com/vou/order/list?pid=1101134337163194&pn=com.izhangxin.ddz.lua.test"
	gBaseLogic:HTTPGetdata(url,0,function(event)
        -- 是否持久化
        -- 如果持久化，在这里改写data
        -- 
        gBaseLogic:unblockUI();
        if (event == nil) then
        else
	   
		   self.data.historylist =event.resultList
		   --self.view.tabViewLayer:init(2,self.data.historylist)
		   self.view:initTableView(self.view.tabViewLayer2,2,self.data.historylist)
		   print("==============================================")
		   var_dump(self.data.historylist)
	    end
	    
        end)    
	
end

function ShopSceneCtrller:sendPluginPayRequest(idx)
	gBaseLogic:blockUI({autoUnblock=false})
	local data;
	print("ShopSceneCtrller:sendPluginPayRequest");
	
	-- if (self.shopType==0) then
	-- 	--data = self.logic.paymentItemList[idx];
	-- elseif (self.shopType==1) then
	-- 	data = self.logic.VIPItemList[idx];
	-- end
	var_dump(self.payitemslist)
	data = self.payitemslist[idx]
	var_dump(data)
	
	if self.shopType == 0  then 
		gBaseLogic:addLogDdefine("shopPay","payMonery",data.price)
	else
		gBaseLogic:addLogDdefine("shopPay","vipPayMonery",data.price)
	end
	if data.content ~= nil then
		var_dump(data.content,4);
		for k,v in pairs(data.content) do
			if v.idx==0 then
				local puid = self.logic.userData.ply_guid_;
				CCUserDefault:sharedUserDefault():setStringForKey("payday"..puid,os.date("%x", os.time()))
				local needMoney = tonumber(v.num)
				CCUserDefault:sharedUserDefault():setIntegerForKey("paydayNeedMoney"..puid,needMoney)
			end
		end
	end 
	local tmptype = self:selectPayType()

	echoInfo("self:selectPayType %s", tmptype);
	gBaseLogic.lobbyLogic:pay(data,tmptype,3);
	-- if tmptype=="SMS" then
	-- 	gBaseLogic:unblockUI();
	-- 	gBaseLogic.lobbyLogic:onPayTips(3, "SMS", data, 0)
	-- else
	-- 	-- gBaseLogic.lobbyLogic:onPayTips(3, tmptype, data, 0)
		
	-- end

--buyLimit
--cusType
-- k_v.first = "goodsLeft";
--                 k_v.first = "goodsStatus";
--                 k_v.first = "originalMoney";
-- k_v.first = "units";
--                 k_v.first = "conIdx";
--                 k_v.first = "conNum";
--                 k_v.first = "isSmsQuickPay";
--
-- Chest(void)
--         {
--                 box_id = -1;
--                 buy_limit_ = -1;
--                 custype_ = 0;
--                 goods_left_ = -1;
--                 goods_status_ = 0;
--                 original_money_ = 0;
--                 sale_money_ = 0;
--                 con_idx_ = -2;
--                 con_num_ = -2;
--                 room_type_ = -1;
--                 dd_flag_ =0;
--                 sms_quickpay_ = 0;
--         }
end
 
return ShopSceneCtrller;