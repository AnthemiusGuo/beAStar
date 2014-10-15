local MiniGameList = class("MiniGameList",izx.baseView)

function MiniGameList:ctor(pageName,moduleName,initParam)
	print ("MiniGameList:ctor")
    self.super.ctor(self,pageName,moduleName,initParam);
end

function MiniGameList:onAssignVars()
	self.bgPanel = display.newSprite("images/YuLeTing/Yuleting_tanchu.png", display.cx, display.bottom+91);
	-- 设置处理函数
	self.rootNode:addChild(self.bgPanel);

	self.listHolder = display.newNode();
	self.listHolder:setPosition(0, display.bottom+92);

	
	self.rootNode:addChild(self.listHolder);
end

function MiniGameList:onInitView()
	self:initBaseInfo();
end

function MiniGameList:initBaseInfo()
	local i = 0;
	if (self.logic.miniGameCfg == nil) then
		return
	end
	for k,v in pairs(self.logic.miniGameCfg) do
		local gameId = k;
		
		local thisButton = cc.ui.UIPushButton.new({
            normal = "images/YuLeTing/icon_"..v.gameModule.."_1.png",
            pressed = "images/YuLeTing/icon_"..v.gameModule.."_2.png",
            disabled = "images/YuLeTing/icon_"..v.gameModule.."_2.png"
        }, {scale9 = false})
        :onButtonClicked(function(event)
                self:onPressStartMiniGame(gameId);
            end)
        :align(display.BOTTOM_LEFT,  i*180+50, -85)
        :addTo(self.listHolder);
        i = i+1;
	end
end

function MiniGameList:closeList()
	gBaseLogic.sceneManager:removePopUp("MiniGameList");
end

function MiniGameList:onPressStartMiniGame(gameId)
	izx.baseAudio:playSound("audio_menu");
	local userMoney = self.logic.userData.ply_lobby_data_.money_;
	local needMoney = self.logic.miniGameCfg[gameId].initparam.min_money_;
	-- if (userMoney<needMoney) then
	-- 	gBaseLogic:onNeedMoney("miniGameEnter",needMoney);		
	-- 	return;
	-- end
	gBaseLogic.currentState = gBaseLogic.stateInMiniGame;
	self:closeList();
	gBaseLogic.lobbyLogic:showLoadingScene("miniGame",gameId);
end

return MiniGameList;