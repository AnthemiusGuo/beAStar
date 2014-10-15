local PromotionCtrller = class("PromotionCtrller",izx.baseCtrller)

function PromotionCtrller:ctor(pageName,moduleName,initParam)
	self.super.ctor(self,pageName,moduleName,initParam);
	self.partnerdata = {};
	self.recorddata = {};
	self.canaward = false;
	self.isPromoteOK = false
	self.isBind = -1
end 

function PromotionCtrller:run()
	self.logic:addLogicEvent("MSG_ifBinding_send",handler(self, self.ifBinding),self) 
end 

function PromotionCtrller:getPromote()
	--local listSrc = {'pid','sign'}
	local sb = "uid="..self.logic.userData.ply_guid_ .."&key=".."969e8232b375";
	local sign = crypto.md5(sb)
	local tableRst = {uid = self.logic.userData.ply_guid_,sign = sign};
	--local url = supplant(URL.GETPROMOTE,listSrc,tableRst);

	--"http://t.statics.hiigame.com/get/promotion/code?uid={uid}&sign={sign}";
	--url = "http://t.statics.hiigame.com/get/promotion/code?uid=1101133834027384&sign=fe1d59bd89ba760eeae0af5cf3660de4"
	--gBaseLogic:HTTPGetdata(url,0,function(event)
	HTTPPostRequest(URL.GETPROMOTE, tableRst, function(event)
        if (event ~= nil) then
	        if (event.ret == 0) then
	        	--获取推广码成功
	        	self.isPromoteOK = true 
	        	self.view.btnGotoPromote:setEnabled(gBaseLogic.MBPluginManager.hasSocial)
	        	--self.view:initBaseInfo(event.code);
	        	self.view.promoteLable:setString(event.code)
	        else 
	        	if event.msg ~= nil then
	        		self.view.promoteLable:setString(event.msg)
	        		izxMessageBox(event.msg, "提示") 
	        	else  
	        		if event.ret == -2 then 
	        			self.view.promoteLable:setString("用户Uid不存在")
	        		elseif event.ret == -3 then
	        			self.view.promoteLable:setString("签名错误")
	        	    end
	        	end
	        end
	    end	    
        end);
end

function PromotionCtrller:promotebinding(code)
	--local listSrc = {'uid','code'}
	local tableRst = {uid = self.logic.userData.ply_guid_,code = code};
	--local url = supplant(URL.PROMOTEBINDING,listSrc,tableRst);
	--"http://t.statics.hiigame.com/bind/promotion/code.do?uid={uid}&code={code}";
	HTTPPostRequest(URL.PROMOTEBINDING, tableRst, function(event)
	--gBaseLogic:HTTPGetdata(url,0,function(event)
        if (event ~= nil) then
        	if event.ret == 0 then
        		-- self.view.tipPop = require("moduleLobby.views.TipDialog").new({type=2,msg=event.msg},self.view);
        		-- self.view:showPopBoxCCB("interfaces/TanChu.ccbi",self.view.tipPop,true);
        		gBaseLogic.lobbyLogic:showYouXiTanChu({msg=event.msg,type=1003}) 
        		--izxMessageBox(event.msg, "提示")
        	else
	        	izxMessageBox("推广码有误，请重新输入", "提示")
	        end
	    else
	    	izxMessageBox("推广码有误，请重新输入", "提示")
	    end	    
        end);
end

function PromotionCtrller:getPromotePartner()
	--local listSrc = {'uid'}
	local tableRst = {uid = self.logic.userData.ply_guid_};
	--local url = supplant(URL.GETPROMOTEPARTNER,listSrc,tableRst);
	--"http://t.statics.hiigame.com/get/bound/friend/info.do?uid={uid}";
	HTTPPostRequest(URL.GETPROMOTEPARTNER, tableRst, function(event)
	--gBaseLogic:HTTPGetdata(url,0,function(event)
		var_dump(event)
        if (event ~= nil) then
        	self.partnerdata = event.friends;
        	self.view:refreshPartner(event.status,event.lwMoney);
        end	    
        end);
end

function PromotionCtrller:getPromoteRecord()
	--local listSrc = {'uid'}
	local tableRst = {uid = self.logic.userData.ply_guid_};
	--local url = supplant(URL.GETPROMOTERECORD,listSrc,tableRst);
	--"http://t.statics.hiigame.com/get/promotion/record?uid={uid}";
	HTTPPostRequest(URL.GETPROMOTERECORD, tableRst, function(event)
	--gBaseLogic:HTTPGetdata(url,0,function(event)
		var_dump(event)
        if (event ~= nil) then
        	self.recorddata = event.records;
        	self.view:refreshRecord();
        end	  
        end);
end

function PromotionCtrller:getPromoteaward()
	--local listSrc = {'uid', 'gameid'}
	local tableRst = {uid = self.logic.userData.ply_guid_, gameid = MAIN_GAME_ID};
	--local url = supplant(URL.GETPROMOTEAWARD,listSrc,tableRst);
	--"http://t.statics.hiigame.com/get/promotion/award?uid={uid}&gameid={gameid}";
	HTTPPostRequest(URL.GETPROMOTEAWARD, tableRst, function(event)
	--gBaseLogic:HTTPGetdata(url,0,function(event)
		var_dump(event)
        if (event ~= nil) then
        	if event.msg ~= nil then
        		self.view:refreshPartner(1,0);
	       		izxMessageBox(event.msg, "提示")
	       	end
	    end	    
        end);
end

function PromotionCtrller:ifBinding()
	--local listSrc = {'uid'}
	local tableRst = {uid = self.logic.userData.ply_guid_};
	--local url = supplant(URL.IFBINDING,listSrc,tableRst);
	--"http://t.statics.hiigame.com/is/promotion/bind?uid={uid}";
	gBaseLogic:blockUI();
	HTTPPostRequest(URL.IFBINDING, tableRst, function(event)
	--gBaseLogic:HTTPGetdata(url,0,function(event)
        if (event ~= nil) then
        	gBaseLogic:unblockUI();
        	self.isBind = event.isBind;
        	--event.isBind = 0 -- for test
        	--event.binder = "Test" -- for test
	        if (event.isBind == 1) then
	        	--已绑定
				self.view.bindingNode:setVisible(false);
        		self.view.gameBeginNode:setVisible(true);
        		self.view.textLable:setString("你是"..event.binder.."的游戏伙伴，快去游戏吧！")
        	else
        		self.view.bindingNode:setVisible(true);
	        end
	    end	    
        end);
end

return PromotionCtrller;