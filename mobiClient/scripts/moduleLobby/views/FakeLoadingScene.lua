local FakeLoadingScene = class("FakeLoadingScene",izx.baseView)

function FakeLoadingScene:ctor(pageName,moduleName,initParam)
	print ("FakeLoadingScene:ctor")
	self.closeLodingScene = 0
    self.super.ctor(self,pageName,moduleName,initParam);
end




function FakeLoadingScene:onPressBack()
	izx.baseAudio:playSound("audio_menu");
	if (gBaseLogic.gameLogic and gBaseLogic.gameLogic.gameSocket) then
		gBaseLogic.gameLogic.gameSocket:close();
	end
    gBaseLogic.lobbyLogic:goBackToMain();
end

function FakeLoadingScene:onAssignVars()
	--var_dump(self);
	self.rootNode = tolua.cast(self.rootNode,"CCNode");
	if nil ~= self["labelHint"] then
		self.labelHint = tolua.cast(self["labelHint"],"CCLabelTTF")
    end
    if nil ~= self["btnCancel"] then
		self.btnCancel = tolua.cast(self["btnCancel"],"CCControlButton")
    end
    if nil ~= self["btnCancelText"] then
		self.btnCancelText = tolua.cast(self["btnCancelText"],"CCSprite")
    end
  --   if nil ~= self["dian2"] then
  --   	print("====dian2")
		-- self.dian2 = tolua.cast(self["dian2"],"CCSprite")
  --   end
  --   if nil ~= self["dian3"] then
  --   	print("====dian3")
		-- self.dian3 = tolua.cast(self["dian3"],"CCSprite")
  --   end
    if nil ~= self["spriteLogo"] then
		self.spriteLogo = tolua.cast(self["spriteLogo"],"CCSprite")
		gBaseLogic.MBPluginManager:replacelogo("logoloading",self.spriteLogo)
		-- self.labelStringMsg:setString(gBaseLogic.MBPluginManager:replaceText(t_string))
    end 
    self.btnCancel:setVisible(false);
    self.btnCancelText:setVisible(false);
    self:showTips();
end

function FakeLoadingScene:showTips()
	local count = #LOADING_TIPS;
	local index = os.time() % count +1;
	self.labelHint:setString(LOADING_TIPS[index]);
end

function FakeLoadingScene:onInitView()
	self:initBaseInfo();
end

function FakeLoadingScene:onRemovePage()
	self.closeLodingScene = 1
   
end
function FakeLoadingScene:initBaseInfo()
	local numD = 0  
	print("LoadingScene:initBaseInfo")
	-- local function loadingDian()		
	-- 	if self.closeLodingScene == 0 then
	-- 		if numD%3==0 then
	-- 			self.dian2:setVisible(false)
	-- 			self.dian3:setVisible(false)
	-- 		elseif numD%3==1 then
	-- 			self.dian2:setVisible(true)
	-- 			self.dian3:setVisible(false)
	-- 		elseif numD%3==2 then
	-- 			self.dian2:setVisible(true)
	-- 			self.dian3:setVisible(true)
			
	-- 		end
	-- 	end
	-- 	gBaseLogic.scheduler.performWithDelayGlobal(function()
	-- 		numD = numD+1;
	-- 		if (self.closeLodingScene == 0) then
	-- 			loadingDian()
	-- 		end
	-- 	end, 0.2)
	-- end
	-- loadingDian()
	
end

function FakeLoadingScene:showLabelHint(content)
	self.labelHint:setString(content);
end

return FakeLoadingScene;