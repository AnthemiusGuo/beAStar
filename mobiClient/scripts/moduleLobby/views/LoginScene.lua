local LoginScene = class("LoginScene",izx.baseView)

function LoginScene:ctor(pageName,moduleName,initParam)
	print ("LoginScene:ctor")
	self.reload = 0;
	if initParam.reload~=nil then
		self.reload = initParam.reload
	end
    LoginScene.super.ctor(self,pageName,moduleName,initParam);
    self.canEnterLobby = false;
end

function LoginScene:onPressShowNotice()
	-- local baseLogic = require("izxFW.BaseLogic").getInstance();
	print "onPressShowNotice"
	izx.baseAudio:playSound("audio_menu");
	-- self.btnGonggao:setVisible(false)
	gBaseLogic.lobbyLogic:showGaoGaoLayer();
end

function LoginScene:onPressQuickBegin()
	print "onPressQuickBegin"
	izx.baseAudio:playSound("audio_menu");
	-- self.logic:startGameSocket(-1);
	if (self.logic.userHasLogined) then
		self.logic:startGame("moduleDdz",-1);
	else
		self:onPressChooseLoginType();
	end

end

function LoginScene:onPressConsoleGame()
	print "onPressConsoleGame"	
	izx.baseAudio:playSound("audio_menu");
	gBaseLogic.is_robot = 1
	gBaseLogic.lobbyLogic:startRobotGame()
end

function LoginScene:onPressShowSetup()
	print "onPressShowSetup"
	izx.baseAudio:playSound("audio_menu");
	gBaseLogic.lobbyLogic:showSetupLayer();
end

function LoginScene:onPressShowHelp()
	print "onPressShowHelp"
	izx.baseAudio:playSound("audio_menu");
	gBaseLogic.lobbyLogic:showHelpScene();
end

function LoginScene:onPressEnterLobby()
	print "onPressEnterLobby"
	izx.baseAudio:playSound("audio_menu");
	if (self.logic.userHasLogined) then
		gBaseLogic.lobbyLogic.isloginpage = false
		gBaseLogic.lobbyLogic:EnterLobby();
	else
		self:onPressChooseLoginType();
	end
	
	
end

function LoginScene:onPressChooseLoginType()
	
	print "onPressChooseLoginType"
	izx.baseAudio:playSound("audio_menu");
    gBaseLogic.lobbyLogic:showLoginTypeLayer();
end

function LoginScene:onPressQQ()
	print "onPressQQ"
	izx.baseAudio:playSound("audio_menu");
end


function LoginScene:onAssignVars()
	-- var_dump(self.ccbDelegate);
	self.rootNode = tolua.cast(self.rootNode,"CCNode");

	if nil ~= self["labelVersionNum"] then
		self.labelVersionNum = tolua.cast(self["labelVersionNum"],"CCLabelTTF")
    end
    if nil ~= self["labelHelpDesk"] then
		self.labelHelpDesk = tolua.cast(self["labelHelpDesk"],"CCLabelTTF")
    end
	if nil ~= self["labelUserMoney"] then
		self.labelUserMoney = tolua.cast(self["labelUserMoney"],"CCLabelTTF")
    end
    if nil ~= self["labelUserName"] then
		self.labelUserName = tolua.cast(self["labelUserName"],"CCLabelTTF")
    end
    if nil ~= self["btnEnterLobby"] then
		self.btnEnterLobby = tolua.cast(self["btnEnterLobby"],"CCControlButton")
    end
    if nil ~= self["btnQuickBegin"] then
		self.btnQuickBegin = tolua.cast(self["btnQuickBegin"],"CCControlButton")
    end
    if nil ~= self["btnGonggao"] then
		self.btnGonggao = tolua.cast(self["btnGonggao"],"CCControlButton")
    end
    if nil ~= self["spriteUserVip"] then
		self.spriteUserVip = tolua.cast(self["spriteUserVip"],"CCSprite")
    end
    if nil ~= self["spriteUserAvatar"] then
		self.spriteUserAvatar = tolua.cast(self["spriteUserAvatar"],"CCSprite")
    end   

    if (not gBaseLogic.MBPluginManager.distributions['showloginchoose']) then
        -- hide switch
        self.btnChooseLoginType:setVisible(false);
    end

    if nil ~= self["spriteLogo"] then
		self.spriteLogo = tolua.cast(self["spriteLogo"],"CCSprite")
		gBaseLogic.MBPluginManager:replacelogo("logodenglu",self.spriteLogo)
		-- self.labelStringMsg:setString(gBaseLogic.MBPluginManager:replaceText(t_string))
    end       
    self.labelVersionNum:setString('版本: ' .. self.ctrller.data.versionNum);

end
function LoginScene:onRemovePage()
end 

function LoginScene:onInitView()
	gBaseLogic.is_robot = 0
	self:initBaseInfo();
	self:initUserInfo();
	self:setDisabled();
	if (izx.resourceManager:getNetState() == false) then

		print("===============11111")
		self.logic:onNoNet()
	else
		if self.reload==1 then
			gBaseLogic.scheduler.performWithDelayGlobal(function()
	            self:onPressChooseLoginType()
	        end, 0.5)
		end
		fDuration = 4
		local action1 = CCRotateBy:create(fDuration/3,-15);
		local action2 = CCRotateBy:create(fDuration/3,15);
		local action3 = CCRotateBy:create(fDuration/3,15);
		local action4 = CCRotateBy:create(fDuration/3,-15);
		self.btnGonggao:runAction(CCRepeatForever:create(transition.sequence({action1,action2,action3,action4})));

	end
end

function LoginScene:initBaseInfo()	
	self.labelVersionNum:setString('版本: ' .. self.ctrller.data.versionNum);
	self.labelHelpDesk:setString('客服QQ: ' .. self.logic.helpDesk);
end

function LoginScene:initUserInfo()
	-- body
	self.labelUserName:setString(izx.UTF8.sub(self.ctrller.data.user.userName,1,7));
	self.labelUserMoney:setString(self.ctrller.data.user.userMoney);
	self:showVipIcon(self.spriteUserVip, self.ctrller.data.user.vipLevel, self.ctrller.data.user.vipStatus) 
	if self.ctrller.data.user.avatar=="" then
		self.spriteUserAvatar:setTexture(getCCTextureByName("images/DaTing/lobby_pic_touxiang75.png"))
	else
		izx.resourceManager:imgFileDown(self.ctrller.data.user.avatar,true,function(fileName) 
            self.spriteUserAvatar:setTexture(getCCTextureByName(fileName))
    	end);
	end
    --self.labelUserMoney:setString(numberChange(self.ctrller.data.user.userMoney));
end

function LoginScene:setDisabled()
	-- self.canEnterLobby = false;
	-- self.btnEnterLobby:setEnabled(false);
	-- self.btnQuickBegin:setEnabled(false);
end

function LoginScene:setEnabled()
	-- self.canEnterLobby = true;
	-- self.btnEnterLobby:setEnabled(true);
	-- self.btnQuickBegin:setEnabled(true);
end

return LoginScene;
