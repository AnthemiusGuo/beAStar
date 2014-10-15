local ActivationCodeScene = class("ActivationCodeScene",izx.baseView)

function ActivationCodeScene:ctor(pageName,moduleName,initParam)
	print ("ActivationCodeScene:ctor")
    self.super.ctor(self,pageName,moduleName,initParam);
end

function ActivationCodeScene:onAssignVars()
	--var_dump(self);
	self.rootNode = tolua.cast(self.rootNode,"CCNode");

    if nil ~= self["inputBox"] then
    	self.inputBox = tolua.cast(self["inputBox"],"CCNode")
    end 
    if nil ~= self["labelStringMsg"] then
        self.labelStringMsg = tolua.cast(self["labelStringMsg"],"CCLabelTTF")
    end 
    print("t_string = trim(self.labelStringMsg:getString());")
    if (gBaseLogic.MBPluginManager.distributions['showjihuomatips']) then
        print("t_string = trim(self.labelStringMsg:getString())1")
        --您可以通过在新浪微博 @掌心游 获得激活码获取途径:您可以通过在新浪微博 @掌心游 获得激活码获取途径
        local t_string = trim(self.labelStringMsg:getString());
        print(t_string)
        print(gBaseLogic.MBPluginManager:replaceText(t_string))
        self.labelStringMsg:setString(gBaseLogic.MBPluginManager:replaceText(t_string))
    else
        self.labelStringMsg:setVisible(false);
        self.labelStringTitle:setVisible(false);
    end
    
end

function ActivationCodeScene:onPressBack()
    print "onPressBack"
    izx.baseAudio:playSound("audio_menu");
    self.logic:goBackToMain();
end

function ActivationCodeScene:onPressCdkGet()
    print "onPressCdkGet"


    izx.baseAudio:playSound("audio_menu");
    local cdk = self.inputBox:getChildByTag(2):getText();


    if (cdk==">>*>>sro") then
    --   切正式环境
        gBaseLogic:switchEnv(ENV_OFFICIAL);
    elseif (cdk==">>*>>srt") then
        gBaseLogic:switchEnv(ENV_TEST );
    --切测试环境
    elseif (cdk==">>*>>srm") then
        gBaseLogic:switchEnv(ENV_MIRROR );
    --todoelseif
    --切镜像环境)
    elseif (cdk==">>*>>ver") then
        gBaseLogic:showVersion(self);
    elseif (cdk==">>*>>upt") then
        CCUserDefault:sharedUserDefault():setIntegerForKey("testUpgradeNew",ENV_TEST+1);
        CCDirector:sharedDirector():endToLua(); 
    elseif (cdk==">>*>>upm") then
        CCUserDefault:sharedUserDefault():setIntegerForKey("testUpgradeNew",ENV_MIRROR+1); 
        CCDirector:sharedDirector():endToLua();
    elseif (cdk==">>*>>upo") then
        CCUserDefault:sharedUserDefault():setIntegerForKey("testUpgradeNew",ENV_OFFICIAL+1); 
        CCDirector:sharedDirector():endToLua();
    elseif (cdk==">>*>>log") then
        CCUserDefault:sharedUserDefault():setBoolForKey("superLog",true); 
        CCDirector:sharedDirector():endToLua();
    elseif (cdk==">>*>>nol") then
        CCUserDefault:sharedUserDefault():setBoolForKey("superLog",false); 
        CCDirector:sharedDirector():endToLua();
    else
        self.ctrller:getAward(cdk);
    end
    -- print(cdk);
    -- gBaseLogic.lobbyLogic:removePage("activationCodeScene",true);
end

function ActivationCodeScene:onInitView()
    --创建输入框
    local function editBoxTextEventHandle(strEventName,pSender)
        local edit = tolua.cast(pSender,"CCEditBox")
        local strFmt
        if strEventName == "began" then
            strFmt = string.format("editBox %p DidBegin !", edit)
            print(strFmt)
        elseif strEventName == "ended" then
            strFmt = string.format("editBox %p DidEnd !", edit)
            print(strFmt)
        elseif strEventName == "return" then
            strFmt = string.format("editBox %p was returned !",edit)
            print(strFmt)
        elseif strEventName == "changed" then
            strFmt = string.format("editBox %p TextChanged, text: %s ", edit, edit:getText())
            print(strFmt)
        end
    end

    local editbox = CCScale9Sprite:create("images/LieBiao/list_bg_shurujihuo.png");
    local EditBox = CCEditBox:create(editbox:getContentSize(),editbox)
    --[[local targetPlatform = CCApplication:sharedApplication():getTargetPlatform()
    if kTargetIphone == targetPlatform or kTargetIpad == targetPlatform then
       EditBox:setFontName("Paint Boy")
    else
        EditBox:setFontName("fonts/Paint Boy.ttf")
    end--]]
    EditBox:setFontSize(30)
    EditBox:setPlaceholderFontColor(ccc3(0,0,0))
    EditBox:setFontColor(ccc3(0,0,0))
    EditBox:setPlaceHolder("点击输入激活码")
    EditBox:setMaxLength(8)
    EditBox:setReturnType(kKeyboardReturnTypeDone)
    --Handler
    EditBox:registerScriptEditBoxHandler(editBoxTextEventHandle)
    EditBox:setTag(2)
    self.inputBox:addChild(EditBox)

	self:initBaseInfo();
end

function ActivationCodeScene:initBaseInfo()

end

return ActivationCodeScene;
