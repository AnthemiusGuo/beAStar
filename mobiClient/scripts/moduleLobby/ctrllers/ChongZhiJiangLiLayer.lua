local ChongZhiJiangLiLayerCtrller = class("ChongZhiJiangLiLayerCtrller",izx.baseCtrller)

function ChongZhiJiangLiLayerCtrller:ctor(pageName,moduleName,initParam)
    -- self.data = {
    -- };
    self.curAwardId = 0
    self.curAwardStatus = 1;
	ChongZhiJiangLiLayerCtrller.super.ctor(self,pageName,moduleName,initParam);
	
end

function ChongZhiJiangLiLayerCtrller:run()
	ChongZhiJiangLiLayerCtrller.super.run(self);
end
function ChongZhiJiangLiLayerCtrller:onEnter()
    -- body
end
function ChongZhiJiangLiLayerCtrller:getChongZhiJiangLiAward()
	-- DEFAULT.URL.CHONGZHIJIANGLI_AWARD = "http://statics.hiigame.com/get/pay/award.do?pn={packageName}&uid={pid}&awardid={awardid}&money={money}&gameid={gameid}"
	-- local url = string.gsub(URL.CHONGZHIJIANGLI_AWARD,"{pid}",self.userData.ply_guid_);
	-- url = string.gsub(url,"{packageName}",gBaseLogic.packageName);
	print("ChongZhiJiangLiLayerCtrller:getChongZhiJiangLiAward")
	-- print (url)
	if (self.curAwardStatus~=1) then
		gBaseLogic:unblockUI()
		izxMessageBox("不能重复领取", "已经领取过该奖励")
		return
	end
	
	local listSrc = {'pid','packageName','awardid','gameid','money'}
	
	local tableRst = {
					pid = self.logic.userData.ply_guid_,
					packageName = gBaseLogic.packageName,
					awardid = self.curAwardId,
					gameid = MAIN_GAME_ID,
					money = self.logic.getPayNum

			};
	local url = supplant(URL.CHONGZHIJIANGLI_AWARD,listSrc,tableRst)
	print(url)
	gBaseLogic:HTTPGetdata(url, 0, function(event)
		gBaseLogic:unblockUI();
		var_dump(event)
    	if (event~=nil) then
    		if (event.ret>=0) then
    			-- "awardMoney":10,"awardId":20,"awardStatus":1,"awardReval":10,"awardMx":[{"itemNum":20000,"itemIndex":0,"itemName":"游戏币x"},
    			-- local awardMx = {};
    			for k,v in pairs(self.logic.payInitList.items) do
    				if v.awardId == self.curAwardId then
    					v.awardStatus = 2;
    					self.logic.payInitList.items[k].awardStatus =2;
    					
    				end
    			end

    			-- for k2,info in pairs(self.logic.userData.ply_items_) do
    			-- 	if awardMx[info.index_] ~= nil and awardMx[info.index_]>0 then
    			-- 		self.logic.userData.ply_items_[k2].num_ = self.logic.userData.ply_items_[k2].num_+awardMx[info.index_]
    			-- 	end 
    			-- end
    			
    			local hasGetPayNum = self.logic.getPayNum
    			self.logic.getPayNum = 0;
    			for k,v in pairs(self.logic.payInitList.items) do
					if v.awardStatus==1 then
						self.logic.getPayNum = v.awardMoney;
						
						break;
					end
				end
				self.logic:dispatchLogicEvent({
			        name = "MSG_Socket_ChongZhiJiangLi",
			        message = self.logic.payInitList
			    })
    			self.view:initgetAward(hasGetPayNum)
    		else
    			izxMessageBox("领取奖励失败","操作错误")
    			self.logic:getChongZhiJiangLiData();
    			self.view:onPressClose()
    		end
		
		else
			izxMessageBox("网络出错或操作错误，请稍后重试！","领取奖励失败")
		end
        end)
end
return ChongZhiJiangLiLayerCtrller;