local ChongZhiShangPinLayerCtrller = class("ChongZhiShangPinLayerCtrller",izx.baseCtrller)

function ChongZhiShangPinLayerCtrller:ctor(pageName,moduleName,initParam)
    -- self.data = {
    -- };
    self.curAwardId = 0
    self.curAwardStatus = 1;
	ChongZhiShangPinLayerCtrller.super.ctor(self,pageName,moduleName,initParam);
	
end

function ChongZhiShangPinLayerCtrller:run()
	ChongZhiShangPinLayerCtrller.super.run(self);
end
function ChongZhiShangPinLayerCtrller:onEnter()
    -- body
end
function ChongZhiShangPinLayerCtrller:getChongZhiShangPinAward()
	-- DEFAULT.URL.CHONGZHIShangPin_AWARD = "http://statics.hiigame.com/get/pay/award.do?pn={packageName}&uid={pid}&awardid={awardid}&money={money}&gameid={gameid}"
	-- local url = string.gsub(URL.CHONGZHIShangPin_AWARD,"{pid}",self.userData.ply_guid_);
	-- url = string.gsub(url,"{packageName}",gBaseLogic.packageName);
	-- print("LobbyLogic:getChongZhiShangPinData")
	-- print (url)
	if (self.curAwardStatus==0) then
		izxMessageBox("不能重复领取", "已经领取过该奖励")
		return
	end
	
	local listSrc = {'pid','packageName','awardid','gameid','money'}
	-- ply_guid_ = self.userData.ply_guid_,
	-- 					ply_nickname_ = self.userData.ply_nickname_,
	-- 					ply_ticket_ = self.userData.ply_ticket_,
	-- 					game_id_ = gBaseLogic.GAME_ID,
	-- 					version_ = CASINO_VERSION_DEFAULT,
	
	local tableRst = {
					pid = self.logic.userData.ply_guid_,
					packageName = gBaseLogic.packageName,
					awardid = self.curAwardId,
					gameid = MAIN_GAME_ID,
					money = self.logic.payInitList.payMoney

			};
	local url = supplant(URL.CDKAWARD,listSrc,tableRst)
	gBaseLogic:HTTPGetdata(url, 0, function(event)
		var_dump(event)
    	if (event~=nil) then
		
		end
        end)
end
return ChongZhiShangPinLayerCtrller;