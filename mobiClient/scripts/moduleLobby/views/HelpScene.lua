local HelpScene = class("HelpScene",izx.baseView)

function HelpScene:ctor(pageName,moduleName,initParam)
	print ("HelpScene:ctor")
    self.super.ctor(self,pageName,moduleName,initParam);
end

function HelpScene:onPressBack()
	print "onPressBack"
    izx.baseAudio:playSound("audio_menu");
    print("gBaseLogic.lobbyLogic.isloginpage:");
    var_dump(gBaseLogic.lobbyLogic.isloginpage);
	if gBaseLogic.lobbyLogic.isloginpage == true then
       gBaseLogic.lobbyLogic:showLoginScene()
       gBaseLogic.lobbyLogic:dispatchEvent({
	        name = "MSG_Socket_UserData",
	        message = {}
	    })       
	else
	   gBaseLogic.lobbyLogic:goBackToMain();
	end
end

function HelpScene:onPressIdea()
	print "onPressIdea"
    izx.baseAudio:playSound("audio_menu");
	if self.ideaLayer:isVisible() == false then
        self:SliderMoveAction(self.helpSlider, self.ideaItem:getPositionX(), nil, 0.2)
        self.ideaLayer:setVisible(true)
        self.initlayer:setVisible(false)
        self.initlayer = self.ideaLayer;
    end
end

function HelpScene:onPressVipShow()
	print "onPressVipShow"
    izx.baseAudio:playSound("audio_menu");
	if self.vipShowLayer:isVisible() == false then
        self:SliderMoveAction(self.helpSlider, self.vipItem:getPositionX(), nil, 0.2)
		self.vipShowLayer:setVisible(true)
	    self.initlayer:setVisible(false)
        self.initlayer = self.vipShowLayer;
	end
end

function HelpScene:onPressGameHelp()
	print "onPressGameHelp"
    izx.baseAudio:playSound("audio_menu");
	if self.gameHelpLayer:isVisible() == false then
        self:SliderMoveAction(self.helpSlider, self.gameHelpItem:getPositionX(), nil, 0.2)
		self.gameHelpLayer:setVisible(true)
        self.initlayer:setVisible(false)
        self.initlayer = self.gameHelpLayer;
	end
end

function HelpScene:onPressToVip()
    print "onPressToVip"
    if self.logic.userHasLogined == false then
        izxMessageBox("您还没有登录，请登录游戏", "提示")
        return
    end
    izx.baseAudio:playSound("audio_menu");
    local scene = display.getRunningScene()
    scene:removeChild(self.rootNode)
    self.logic:gotoVipShop(1);
end

function HelpScene:onAssignVars()
	--var_dump(self);
	self.rootNode = tolua.cast(self.rootNode,"CCNode");

	if nil ~= self["gameHelpLayer"] then
		self.gameHelpLayer = tolua.cast(self["gameHelpLayer"],"CCScrollView")
    end
    if nil ~= self["vipShowLayer"] then
    	self.vipShowLayer = tolua.cast(self["vipShowLayer"],"CCScrollView")
    end
    if nil ~= self["ideaLayer"] then
    	self.ideaLayer = tolua.cast(self["ideaLayer"],"CCLayer")
    end
    if nil ~= self["helpSlider"] then
    	self.helpSlider = tolua.cast(self["helpSlider"],"CCSprite")
    end
     if nil ~= self["ideaItem"] then
    	self.ideaItem = tolua.cast(self["ideaItem"],"CCControl")
    end
     if nil ~= self["btnSub"] then
        self.btnSub = tolua.cast(self["btnSub"],"CCControl")
    end
    
    if nil ~= self["vipItem"] then
    	self.vipItem = tolua.cast(self["vipItem"],"CCControl")
        if(gBaseLogic.MBPluginManager.distributions.iosenv==true)then
            local myVersion = gBaseLogic.MBPluginManager:getVersionInfo();
            if(gBaseLogic.lobbyLogic.ver_code ~= 0)then
                if(gBaseLogic.lobbyLogic.ver_code == myVersion.version_code)then
                    if(gBaseLogic.lobbyLogic.vip ~= 0)then
                        self.vipItem:setVisible(false)
                    end
                end
            end
        else
            self.vipItem:setVisible(true)
        end
    end
    if nil ~= self["gameHelpItem"] then
    	self.gameHelpItem = tolua.cast(self["gameHelpItem"],"CCControl")
    end
    if nil ~= self["inputbox"] then
    	self.inputbox = tolua.cast(self["inputbox"],"CCNode")
    end
    if nil ~= self["nodeVip"] then
        print("nodeVip")
        self.nodeVip = tolua.cast(self["nodeVip"],"CCNode")
    end
    if nil ~= self["labelQQ"] then
        print("labelQQ")
        self.labelQQ = tolua.cast(self["labelQQ"],"CCLabelTTF")
    end
    if nil ~= self["userfeedback"] then
        self.userfeedback = tolua.cast(self["userfeedback"],"CCLabelTTF")
    end

end

function HelpScene:onInitView()
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

    local editbox = CCScale9Sprite:create("images/LieBiao/list_bg_shuruyijian.png");
    local EditBox = CCEditBox:create(editbox:getContentSize(),editbox)

    EditBox:setFont("Helvetica", 26);
    EditBox:setPlaceholderFontColor(ccc3(0,0,0))
    EditBox:setFontColor(ccc3(0,0,0))
    EditBox:setPlaceHolder("最多输入140字")
    --EditBox:setMaxLength(2)
    EditBox:setReturnType(kKeyboardReturnTypeDone)
    --Handler
    EditBox:registerScriptEditBoxHandler(editBoxTextEventHandle)
    self.inputbox:addChild(EditBox)
    self.editBox = EditBox;
    if self.logic.userHasLogined == true then
        cc.ui.UIPushButton.new("images/LieBiao/list_btn_da1.png", {scale9 = true})
                :setButtonSize(205, 75)
                :setButtonLabel("normal", ui.newTTFLabel({
                    text = "开通Vip",
                    size = 36
                }))
                :setButtonLabel("pressed", ui.newTTFLabel({
                    text = "开通Vip",
                    size = 36,
                    color = ccc3(255, 255, 255)
                }))
                :setButtonLabel("disabled", ui.newTTFLabel({
                    text = "开通Vip",
                    size = 36,
                    color = ccc3(0, 0, 0)
                }))
                :onButtonClicked(function(event)
                    print(111);
                    self:onPressToVip();
                end)
                :addTo(self.nodeVip)
        -- self.btnSub:setVisible(true);
    else
        -- self.btnSub:setVisible(false);
    end

    self.labelQQ:setString("QQ: "..self.logic.helpDesk)
	self:initBaseInfo();
end

function HelpScene:initBaseInfo()
	--print "HelpScene:initBaseInfo"
	--self.labelAnounceContent:setString(self.ctrller.data.content);
	self.initlayer = self.gameHelpLayer;
	local container = self.gameHelpLayer:getContainer()
	container:setPositionY(-(container:getContentSize().height-self.gameHelpLayer:getViewSize().height))
	container = self.vipShowLayer:getContainer()
	container:setPositionY(-(container:getContentSize().height-self.vipShowLayer:getViewSize().height))

    
end
function HelpScene:onPressSubmit()
    print("HelpScene:onPressSubmit")
    if self.logic.userHasLogined == false then
        izxMessageBox("您还没有登录，请登录游戏后再提交", "意见无法提交")
        return
    end
    local msg = trim(self.editBox:getText());
    if izx.UTF8.length(msg)>140 then
        izxMessageBox("输入文字大于140字，请修改后再提交", "意见提交失败")
        return
    end
    if izx.UTF8.length(msg)<10 then
        izxMessageBox("输入文字小于10字，请修改后再提交", "意见无法提交")
        return
    end
    gBaseLogic:blockUI();

    self.ctrller:sendFeedback(msg);
    print(msg);
end

function HelpScene:showFeedbackMsg()
    local msg = trim(self.editBox:getText())
    local txt = self.userfeedback:getString()
    print("===========")
    if izx.UTF8.length(txt) == 0 then
        self.userfeedback:setString("您的意见：\n".."    "..msg)
    else
        self.userfeedback:setString(txt.."\n".."    "..msg) 
    end
end

return HelpScene;