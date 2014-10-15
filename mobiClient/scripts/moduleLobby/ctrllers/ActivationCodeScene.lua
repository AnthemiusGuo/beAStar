local ActivationCodeSceneCtrller = class("ActivationCodeSceneCtrller",izx.baseCtrller)

function ActivationCodeSceneCtrller:ctor(pageName,moduleName,initParam)
    self.data = {
    };

	self.super.ctor(self,pageName,moduleName,initParam);
end

function ActivationCodeSceneCtrller:onEnter()
    -- body
    
    
end

function ActivationCodeSceneCtrller:getAward(cdk)
	local listSrc = {'pid','ticket','cdk','gameid','sign'}
	-- ply_guid_ = self.userData.ply_guid_,
	-- 					ply_nickname_ = self.userData.ply_nickname_,
	-- 					ply_ticket_ = self.userData.ply_ticket_,
	-- 					game_id_ = gBaseLogic.GAME_ID,
	-- 					version_ = CASINO_VERSION_DEFAULT,
	local sb = "uid="..self.logic.userData.ply_guid_ .."&gameid="..MAIN_GAME_ID .."&giftkey="..cdk .."asdf1234ghjk5678";
	local sign = crypto.md5(sb)
	print("ActivationCodeSceneCtrller:getAward")
	local tableRst = {
					pid = self.logic.userData.ply_guid_,
					ticket = self.logic.userData.ply_ticket_,
					cdk = cdk,
					gameid = MAIN_GAME_ID,
					sign = sign

			};
	local url = supplant(URL.CDKAWARD,listSrc,tableRst)
	print("#####"..url)
	gBaseLogic:HTTPGetdata(url,0,function(event)
			var_dump(event)
	        if (event ~= nil) then
		        if (event.ret) then
		        	izxMessageBox(event.msg, "兑换成功")
		        else
		        	--izxMessageBox(event.msg, "兑换失败")
		        	izxMessageBox("无效的激活码", "兑换失败")
		        end
		    else
	        	--izxMessageBox(event.msg, "兑换失败")
	        	izxMessageBox("无效的激活码", "兑换失败")
		    end
        end);
end

return ActivationCodeSceneCtrller;