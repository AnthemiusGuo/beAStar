local AchievefinishLayerCtrller = class("AchievefinishLayerCtrller",izx.baseCtrller)

function AchievefinishLayerCtrller:ctor(pageName,moduleName,initParam)
    self.data = {
 
    };
    
	self.super.ctor(self,pageName,moduleName,initParam);
end

function AchievefinishLayerCtrller:onEnter()
    -- body
end
  

function AchievefinishLayerCtrller:run()
	self.logic:addLogicEvent("MSG_SOCK_pt_bc_get_achieve_award_ack",handler(self, self.pt_bc_get_achieve_award_ack),self)
	AchievefinishLayerCtrller.super.run(self);
end
function AchievefinishLayerCtrller:pt_bc_get_achieve_award_ack(event)
	local award = event.message;
	print("onGetAchieveAward==")
	var_dump(event)
	gBaseLogic.sceneManager:removePopUp("AchievefinishLayer");
	if (award~=nil)then

		if(award.ret_ == 0) then
			local data = "";
	-- 			char ret_;		// 0领取成功 -1未知错误  -2任务未完成 -3奖励已经领取
	-- int param_1_;	// 游戏币
	-- int param_2_;	// 元宝
	-- int param_3_;	// 娱乐豆
			if(award.param_1_ > 0) then
				data = "游戏币:"..award.param_1_.."\n";
				-- self.logic.userData.ply_lobby_data_.money_ = self.logic.userData.ply_lobby_data_.money_+award.money_;
			end
			--礼物
			if(award.param_2_ > 0) then
				data = data.."元宝:"..award.param_2_.."\n";
				-- self.logic.userData.ply_lobby_data_.gift_ = self.logic.userData.ply_lobby_data_.gift_+award.gift_;
			end
			if(award.param_3_ > 0) then
				data = data.."娱乐豆:"..award.param_3_.."\n";
				-- self.logic.userData.ply_lobby_data_.gift_ = self.logic.userData.ply_lobby_data_.gift_+award.gift_;
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

 

return AchievefinishLayerCtrller;