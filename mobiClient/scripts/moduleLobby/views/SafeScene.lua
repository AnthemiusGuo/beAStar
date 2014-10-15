local SafeScene = class("SafeScene",izx.baseView)

SafeScene.constData = {
    cNodeInBarTag = 100,
    cNodeOutBarTag = 101,
    cNodeOutEditboxTag = 102,
    cNodeModifyEditbox1Tag = 103,
    cNodeModifyEditbox2Tag = 104,
    cNodeModifyEditbox3Tag = 105,

    cSaveMoenyUnit = 10000,
    cFontSize = 24,
    cPWDLength = 6,
    cPhoneNumLength = 11,

    cTouchPriorityMaskLayer = -100,
    cTouchPriorityBtn = -101,
    cTouchPriorityEditBox = -102,

    cOperateTimeout = 5,
    cOperateCheckProgress = 0,
    cOperateCheckResult = 1,

    cOperateGetPWDSuccess = -99,
    cOperateGetPWDErrorPhone = -98,
    cOperateGetPWDErrorMsg = -97,
    cOperateGetPWDErrorDefault = -96,
    cOperateGetPWDErrorParam = -95,

    cOperateSetPWDSuccess = -94,
    cOperateSetPWDErrorUnknown = -93,
    cOperateSetPWDErrorFormat = -92,

    cOperateResultErrorTimeout = -100,
}

SafeScene.tempData = {
    tProgressBarUnit = 0,
}

SafeScene.editboxParam = {
    posNode = {},
    strHolder = "",
    inputMode = 0,
    inputFlag = 0,
    maxLen = 6,
    sptBg = {},
    fcallback = function () end,
    tag = -1,
}


function SafeScene:ctor(pageName,moduleName,initParam)
	print ("SafeScene:ctor")
    
    self.super.ctor(self,pageName,moduleName,initParam);
end


function SafeScene:onAssignVars()
	--var_dump(self);
    self.vipInfo = self.ctrller.logic.userData.ply_vip_
    self.vipLevel = self.logic.vipData.vipLevel
	self.rootNode = tolua.cast(self.rootNode,"CCNode");

	if nil ~= self["inLayer"] then --存入界面
        self.inLayer = tolua.cast(self["inLayer"],"CCLayer")
    end
    if nil ~= self["outLayer"] then --取现界面
        self.outLayer = tolua.cast(self["outLayer"],"CCLayer")
    end
    if nil ~= self["recordLayer"] then --历史记录
        self.recordLayer = tolua.cast(self["recordLayer"],"CCLayer")
    end
    if nil ~= self["modifyLayer"] then --修改密码
        self.modifyLayer = tolua.cast(self["modifyLayer"],"CCLayer")
    end
    if nil ~= self["safeSlider"] then --左侧按钮滑动条
        self.safeSlider = tolua.cast(self["safeSlider"],"CCSprite")
    end
     if nil ~= self["inItem"] then --存入按钮
        self.inItem = tolua.cast(self["inItem"],"CCControl")
    end
    if nil ~= self["outItem"] then --取现按钮
        self.outItem = tolua.cast(self["outItem"],"CCControl")
    end
    if nil ~= self["recordItem"] then --历史记录按钮
        self.recordItem = tolua.cast(self["recordItem"],"CCControl")
    end
    if nil ~= self["modifyItem"] then --修改密码按钮
        self.modifyItem = tolua.cast(self["modifyItem"],"CCControl")
    end
    if nil ~= self["labelCurrentMoney"] then --当前金币
        self.labelCurrentMoney = tolua.cast(self["labelCurrentMoney"],"CCLabelTTF")
    end
    if nil ~= self["labelSafeMoney"] then --保险箱金币
        self.labelSafeMoney = tolua.cast(self["labelSafeMoney"],"CCLabelTTF")
    end
    
    if nil ~= self["recordItem"] then --历史记录按钮
        self.recordItem = tolua.cast(self["recordItem"],"CCControl")
    end
    if nil ~= self["labelVipTip"] then --vip提醒
        self.labelVipTip = tolua.cast(self["labelVipTip"],"CCLabelTTF")
    end
    if nil ~= self["btnVip"] then --开通按钮
        self.btnVip = tolua.cast(self["btnVip"],"CCControlButton")
    end
    if nil ~= self["btnOutSub"] then -- - 
        self.btnOutSub = tolua.cast(self["btnOutSub"],"CCControlButton")
    end
    if nil ~= self["btnOutAdd"] then -- +
        self.btnOutAdd = tolua.cast(self["btnOutAdd"],"CCControlButton")
    end

    if nil ~= self["btnSaveSub"] then -- - 
        self.btnSaveSub = tolua.cast(self["btnSaveSub"],"CCControlButton")
    end
    if nil ~= self["btnSaveAdd"] then -- +
        self.btnSaveAdd = tolua.cast(self["btnSaveAdd"],"CCControlButton")
    end

    if nil ~= self["btnSave"] then -- +
        print("self.btnSave:setEnabled(false)")
        self.btnSave = tolua.cast(self["btnSave"],"CCControlButton")
    end
    if nil ~= self["btnOut"] then -- +
        self.btnOut = tolua.cast(self["btnOut"],"CCControlButton")
    end
    self:onAssignVarsInLayer()
    self:onAssignVarsOutLayer()
    self:onAssignVarsRecordLayer()
    self:onAssignVarsModifyLayer()
end

function SafeScene:onAssignVarsInLayer()
    if nil ~= self["labelSaveMoney"] then -- 当前选中存入的金币
        self.labelSaveMoney = tolua.cast(self["labelSaveMoney"],"CCLabelTTF")
    end
    if nil ~= self["nodeInBarPos"] then -- save money progress bar positon
        self.nodeInBarPos = tolua.cast(self["nodeInBarPos"],"CCNode")
    end
end

function SafeScene:onAssignVarsOutLayer()
    if nil ~= self["labelRemoveMoney"] then -- remove money
        self.labelRemoveMoney = tolua.cast(self["labelRemoveMoney"],"CCLabelTTF")
    end
    if nil ~= self["nodeOutBarPos"] then -- remove money progress bar position
        self.nodeOutBarPos = tolua.cast(self["nodeOutBarPos"],"CCNode")
    end
    if nil ~= self["nodeOutEditboxPos"] then -- remove moeny pwd editbox position
        self.nodeOutEditboxPos = tolua.cast(self["nodeOutEditboxPos"],"CCNode")
    end
end

function SafeScene:onAssignVarsRecordLayer()
    if nil ~= self["nodeRecordTitlePos"] then -- record history title position
        self.nodeRecordTitlePos = tolua.cast(self["nodeRecordTitlePos"],"CCNode")
    end
    if nil ~= self["nodeRecordTablePos"] then -- record history table position
        self.nodeRecordTablePos = tolua.cast(self["nodeRecordTablePos"],"CCNode")
    end
end

function SafeScene:onAssignVarsModifyLayer()
    if nil ~= self["nodeModifyEditbox1Pos"] then -- modify editbox 1 position
        self.nodeModifyEditbox1Pos = tolua.cast(self["nodeModifyEditbox1Pos"],"CCNode")
    end
    if nil ~= self["nodeModifyEditbox2Pos"] then -- modify editbox 2 position
        self.nodeModifyEditbox2Pos = tolua.cast(self["nodeModifyEditbox2Pos"],"CCNode")
    end
    if nil ~= self["nodeModifyEditbox3Pos"] then -- modify editbox 3 position
        self.nodeModifyEditbox3Pos = tolua.cast(self["nodeModifyEditbox3Pos"],"CCNode")
    end
    if nil ~= self["labelModifyTip1"] then -- 
        self.labelModifyTip1 = tolua.cast(self["labelModifyTip1"],"CCLabelTTF")
    end
    if nil ~= self["labelModifyTip2"] then -- 
        self.labelModifyTip2 = tolua.cast(self["labelModifyTip2"],"CCLabelTTF")
    end
    if nil ~= self["labelModifyTip3"] then -- 
        self.labelModifyTip3 = tolua.cast(self["labelModifyTip3"],"CCLabelTTF")
    end
    if nil ~= self["sptModifyTip1"] then -- 
        self.sptModifyTip1 = tolua.cast(self["sptModifyTip1"],"CCSprite")
    end
    if nil ~= self["sptModifyTip2"] then -- 
        self.sptModifyTip2 = tolua.cast(self["sptModifyTip2"],"CCSprite")
    end
    if nil ~= self["sptModifyTip3"] then -- 
        self.sptModifyTip3 = tolua.cast(self["sptModifyTip3"],"CCSprite")
    end
end

function SafeScene:onPressBack() -- 返回
    print "onPressBack"
    izx.baseAudio:playSound("audio_menu");
    gBaseLogic.lobbyLogic:goBackToMain();
end

function SafeScene:onPressIn() --存入
    print "onPressIn"
    izx.baseAudio:playSound("audio_menu");
    if self.inLayer:isVisible() == false then
        --self.safeSlider:setPositionY(self.inItem:getPositionY())
        self:SliderMoveAction(self.safeSlider, nil, self.inItem:getPositionY(), 0.2)
        self.inLayer:setVisible(true)
        self.initlayer:setVisible(false)
        self.initlayer = self.inLayer
        self:resetInLayer()
    end
end

function SafeScene:onPressOut() --取现
    print "onPressOut"
    izx.baseAudio:playSound("audio_menu");
    if self.outLayer:isVisible() == false then
        --self.safeSlider:setPositionY(self.outItem:getPositionY())
        self:SliderMoveAction(self.safeSlider, nil, self.outItem:getPositionY(), 0.2)
        self.outLayer:setVisible(true)
        self.initlayer:setVisible(false)
        self.initlayer = self.outLayer
        self:resetOutLayer()
    end
end

function SafeScene:onPressRecord() --历史记录
    print "onPressRecord"
    izx.baseAudio:playSound("audio_menu");
    if self.recordLayer:isVisible() == false then
        --self.safeSlider:setPositionY(self.recordItem:getPositionY())
        self:SliderMoveAction(self.safeSlider, nil, self.recordItem:getPositionY(), 0.2)
        self.recordLayer:setVisible(true)
        self.initlayer:setVisible(false)
        self.initlayer = self.recordLayer
        self:resetRecordLayer()
        self:showOperateProgress("progress","his")
        self.ctrller.logic:onSocketSafeHistory()
    end
end

function SafeScene:onPressModify() --修改密码
    print "onPressModify"
    izx.baseAudio:playSound("audio_menu");
    if self.modifyLayer:isVisible() == false then
        self.safeSlider:setPositionY(self.modifyItem:getPositionY())
        self:SliderMoveAction(self.safeSlider, nil, self.modifyItem:getPositionY(), 0.2)
        self.modifyLayer:setVisible(true)
        self.initlayer:setVisible(false)
        self.initlayer = self.modifyLayer
        self:resetModifyLayer()
    end
end

function SafeScene:onPressSub() ---按钮
    print "onPressSub"
    izx.baseAudio:playSound("audio_menu");
    -- if (self.vipInfo.status_~=1) then
    --     izxMessageBox("请先开通vip", "你不是vip会员");
    --     return
    -- end
    
    if self.tempData.tProgressBarUnit > 0 then
        local pControl;
        if (self.initlayer == self.inLayer) then
            pControl = self.inSlider;
        else 
            pControl = self.outSlider;
        end
        local changeValue = math.modf(pControl:getValue()*self.tempData.tProgressBarUnit)
            changeValue = changeValue*self.constData.cSaveMoenyUnit
        if changeValue >= self.constData.cSaveMoenyUnit then
            changeValue = math.modf((changeValue - self.constData.cSaveMoenyUnit)/self.constData.cSaveMoenyUnit)
            pControl:setValue(changeValue)
        end
    else

    end
end

function SafeScene:onPressAdd() --+按钮
    print "onPressAdd"
    izx.baseAudio:playSound("audio_menu");
    -- if (self.vipInfo.status_~=1) then
    --     izxMessageBox("请先开通vip", "你不是vip会员");
    --     return
    -- end
    if self.tempData.tProgressBarUnit > 0 then
        local pControl;
        if (self.initlayer == self.inLayer) then
            pControl = self.inSlider;
        else 
            pControl = self.outSlider;
        end
        local changeValue = math.modf(pControl:getValue()*self.tempData.tProgressBarUnit)
            changeValue = changeValue*self.constData.cSaveMoenyUnit
        if changeValue < (self.initlayer == self.inLayer and self.ctrller.data.money_ or self.ctrller.data.amount_) then
            changeValue = math.modf((changeValue + self.constData.cSaveMoenyUnit)/self.constData.cSaveMoenyUnit)
            pControl:setValue(changeValue)
        end
    end
end

function SafeScene:onPressSave() -- 存款按钮
    print "onPressSave"
    izx.baseAudio:playSound("audio_menu");
    if (self.vipLevel==0) then
        --izxMessageBox("请先开通vip", "你不是vip会员");
         gBaseLogic.lobbyLogic:showYouXiTanChu({msg="保险箱能够防止帐号被盗后游戏币丢失，随时随地存取，还可查看历史记录，购买VIP！",type=4,needMoney=1}) 
        return
    end
    if 0 == self.ctrller.data.isBindMobile_ and self.vipLevel >= 1 then
        print("====self.ctrller.data.isBindMobile_="..self.ctrller.data.isBindMobile_..";self.ctrller.logic.userData.ply_vip_.status_="..self.ctrller.logic.userData.ply_vip_.status_);
        self:showBindDialog(true)
        return
    end
    if self.logic.isOnGameExit==1 then
        gBaseLogic.lobbyLogic:showYouXiTanChu({msg="您正在游戏中,无法存取游戏币!请游戏结束后再尝试。",type=1000})
        -- self:showOperateProgress("updateInLayer", -4)
        return;
    end
    local saveMoney = self.labelSaveMoney:getString()
    local saveMoneyNum = tonumber(saveMoney)
    if saveMoneyNum > 0 then
        self:showOperateProgress("progress","save")
        self.ctrller.logic:onSocketSafeSaveMoney(saveMoneyNum)
    end
end

function SafeScene:onPressVIP() --VIP按钮
    print "onPressVIP"
    izx.baseAudio:playSound("audio_menu");
    gBaseLogic.lobbyLogic:gotoVipShop()
end

function SafeScene:onPressRemove() --remove按钮
    print "onPressRemove"
    izx.baseAudio:playSound("audio_menu");
    -- if (self.vipInfo.status_~=1) then
    --     izxMessageBox("请先开通vip", "你不是vip会员");
    --     return
    -- end
    if 0 == self.ctrller.data.isBindMobile_ and self.vipLevel >= 1 then
        self:showBindDialog(true)
        return
    end

    local removeMoney = self.labelRemoveMoney:getString()
    local removeMoneyNum = tonumber(removeMoney)
    if removeMoneyNum > 0 then
        self:showOperateProgress("progress","remove")
        self.ctrller.logic:onSocketSafeRemoveMoney(removeMoneyNum, self.outEditbox:getText())
    end
end

function SafeScene:onPressGetPassword() --get password
    print "onPressGetPassword"
    izx.baseAudio:playSound("audio_menu");
    -- if (self.vipInfo.status_~=1) then
    --     izxMessageBox("您还未开通保险箱功能，请先开通vip", "你不是vip会员");
    --     return
    -- end
    if 0 == self.ctrller.data.isBindMobile_ and self.vipLevel >= 1 then
        self:showBindDialog(true)
        return
    end
    self:showGetPasswordDialog(true)
end

function SafeScene:onPressModifyAffirm() --modify password
    print "onPressModifyAffirm"
    izx.baseAudio:playSound("audio_menu");
    -- if (self.vipInfo.status_~=1) then
    --     izxMessageBox("您还未开通保险箱功能，请先开通vip", "你不是vip会员");
    --     return
    -- end
    if 0 == self.ctrller.data.isBindMobile_ and self.vipLevel >= 1 then
        self:showBindDialog(true)
        return
    end

    local text1 = self.modifyEditbox1:getText()
    local text2 = self.modifyEditbox2:getText()
    local text3 = self.modifyEditbox3:getText()

    local bAllNum1 = (string.len(text1) > 0 and string.match(text1,"%d%d%d%d%d%d") == text1)
    local bAllNum2 = (string.len(text2) > 0 and string.match(text2,"%d%d%d%d%d%d") == text2)
    local bAllNum3 = (string.len(text3) > 0 and string.match(text3,"%d%d%d%d%d%d") == text3)
    
    if string.len(text1) ~= self.constData.cPWDLength or not bAllNum1 then
        self.labelModifyTip1:setVisible(true)
    elseif string.len(text2) ~= self.constData.cPWDLength or not bAllNum2 then
        self.labelModifyTip2:setVisible(true)
    elseif text2 ~= text3 then
        self.labelModifyTip3:setVisible(true)
    else
        self.labelModifyTip1:setVisible(false)
        self.labelModifyTip2:setVisible(false)
        self.labelModifyTip3:setVisible(false)
        self.sptModifyTip1:setVisible(true)
        self.sptModifyTip2:setVisible(true)
        self.sptModifyTip3:setVisible(true)
        self:showOperateProgress("progress","modify")
        self.ctrller.logic:onSocketSafeModifyPassword(text1,text2)
    end
end

function SafeScene:onInitView()
	self:initBaseInfo();
end

function SafeScene:initBaseInfo()
    -- self.maskLayerColor:setVisible(false)
    -- self.maskLayerColor.scene = self
    -- self.maskLayerColor.bGetPWD = false
    -- self.maskLayerColor.bBind = false
    if (self.vipLevel>=1) then
        self.labelVipTip:setVisible(false)
        self.btnVip:setVisible(false)
    else
        self.labelVipTip:setVisible(true)
        self.btnVip:setVisible(true)
    end
    self.initlayer = self.inLayer;
    self:initInLayer()
    self:initOutLayer()
    self:initRecordLayer()
    self:initModifyLayer()
end

function SafeScene:initInLayer()
    print "SafeScene:initInLayer"

    local function valueChanged(strEventName,pSender)
            if nil == pSender  then
                return
            end
            local changeValue = math.modf(self.inSlider:getValue()*self.tempData.tProgressBarUnit)
            changeValue = changeValue*self.constData.cSaveMoenyUnit         
            self.labelSaveMoney:setString(changeValue)
            if (changeValue>0) then
                self.btnSaveSub:setEnabled(true);
                self.btnSave:setEnabled(true);
            else
                self.btnSaveSub:setEnabled(false);
                self.btnSave:setEnabled(false);
            end
            if (changeValue>self.ctrller.data.money_ - self.constData.cSaveMoenyUnit) then
                self.btnSaveAdd:setEnabled(false);
            else
                self.btnSaveAdd:setEnabled(true);
            end
    end
    --add save money progress bar
    local pSlider = CCControlSlider:create("images/TanChu/popup_pic_jindu1.png","images/TanChu/popup_pic_jindu2.png" ,"images/LieBiao/list_btn_huadong1.png")
    pSlider:setMinimumValue(0.0)
    pSlider:setMaximumValue(1.0)
    pSlider:setAnchorPoint(self.nodeInBarPos:getAnchorPoint())
    pSlider:setPosition(self.nodeInBarPos:getPosition())
    pSlider:addHandleOfControlEvent(valueChanged, CCControlEventValueChanged)
    pSlider:setTag(self.constData.cNodeInBarTag)
    self.inLayer:addChild(pSlider)
    pSlider:setEnabled(false)--set true when req is rsp
    self.inSlider = pSlider;
end

function SafeScene:initOutLayer()
    print "SafeScene:initOutLayer"
    local function valueChanged(strEventName,pSender)
            if nil == pSender  then
                return
            end
            local changeValue = math.modf(self.outSlider:getValue()*self.tempData.tProgressBarUnit)
            changeValue = changeValue*self.constData.cSaveMoenyUnit
            self.labelRemoveMoney:setString(changeValue)
            if (changeValue>0) then
                self.btnOutSub:setEnabled(true);
                self.btnOut:setEnabled(true);
            else
                self.btnOutSub:setEnabled(false);
                self.btnOut:setEnabled(false);
            end
            if (changeValue>self.ctrller.data.amount_ - self.constData.cSaveMoenyUnit) then
                self.btnOutAdd:setEnabled(false);
            else
                self.btnOutAdd:setEnabled(true);
            end
    end
    --add save money progress bar
    local pSlider = CCControlSlider:create("images/TanChu/popup_pic_jindu1.png","images/TanChu/popup_pic_jindu2.png" ,"images/LieBiao/list_btn_huadong1.png")
    pSlider:setMinimumValue(0.0)
    pSlider:setMaximumValue(1.0)
    pSlider:setAnchorPoint(self.nodeOutBarPos:getAnchorPoint())
    pSlider:setPosition(self.nodeOutBarPos:getPosition())
    pSlider:addHandleOfControlEvent(valueChanged, CCControlEventValueChanged)
    pSlider:setTag(self.constData.cNodeOutBarTag)
    self.outLayer:addChild(pSlider)
    pSlider:setEnabled(false)--set true when req is rsp
    self.outSlider = pSlider;
    --add editbox 
    local editboxParam = {};
    editboxParam.strHolder = '请输入密码';
    editboxParam.inputMode = kEditBoxInputModeNumeric;
    editboxParam.inputFlag = kEditBoxInputFlagPassword;
    editboxParam.maxLen = self.constData.cPWDLength;
    editboxParam.tag = self.constData.cNodeOutEditboxTag

    local bgsprite = CCScale9Sprite:create("images/LieBiao/list_bg_shurujihuo.png")
    self.outEditbox = createEditBox(self.nodeOutEditboxPos, bgsprite, function()
    end
        ,editboxParam);

end

function SafeScene:initRecordLayer()
    print "SafeScene:initRecordLayer"
    self.recordTableItemSize = {}
    self.recordTableItemSize.width = self.nodeRecordTitlePos:getContentSize().width
    self.recordTableItemSize.height = self.nodeRecordTitlePos:getContentSize().height
    self:resetTabelView()
end

function SafeScene:initModifyLayer()
    print "SafeScene:initModifyLayer"
    --modify layer
    local function modifyEditboxTextEventHandle(strEventName,pSender)
        if nil == pSender  then
                return
        end
        local editBox = tolua.cast(pSender, "CCEditBox")
        local tag = editBox:getTag()
        local text = editBox:getText() 
        --local bAllNum = ((string.len(text) > 0 and string.match(text,"%d%d%d%d%d%d") == text) and true or false)
        local bAllNum = (string.len(text) > 0 and string.match(text,"%d%d%d%d%d%d") == text) 
        print("modifyEditboxTextEventHandle:"..strEventName)
        if strEventName == "began" then
            if tag == self.constData.cNodeModifyEditbox1Tag then
                self.sptModifyTip1:setVisible(false)
                self.labelModifyTip1:setVisible(false)
            elseif tag == self.constData.cNodeModifyEditbox2Tag then
                self.sptModifyTip2:setVisible(false)
                self.sptModifyTip3:setVisible(false)
                self.labelModifyTip2:setVisible(false)
                self.labelModifyTip3:setVisible(false)
            elseif tag == self.constData.cNodeModifyEditbox3Tag then
                self.sptModifyTip3:setVisible(false)
                self.labelModifyTip3:setVisible(false)
            end
        elseif strEventName == "ended" then
            if tag == self.constData.cNodeModifyEditbox1Tag then
                if string.len(text) == self.constData.cPWDLength and bAllNum then
                    self.sptModifyTip1:setVisible(true)
                    self.modifyEditbox2:setEnabled(true)
                    --tolua.cast(self.modifyLayer:getChildByTag(self.constData.cNodeModifyEditbox2Tag), "CCEditBox"):setEnabled(true)                    
                else
                    self.labelModifyTip1:setVisible(true)
                end
            elseif tag == self.constData.cNodeModifyEditbox2Tag then
                if string.len(text) == self.constData.cPWDLength and bAllNum then
                    --tolua.cast(self.modifyLayer:getChildByTag(self.constData.cNodeModifyEditbox3Tag), "CCEditBox"):setEnabled(true)
                    self.sptModifyTip2:setVisible(true)
                    self.modifyEditbox3:setEnabled(true)
                else
                    self.labelModifyTip2:setVisible(true)
                end
            elseif tag == self.constData.cNodeModifyEditbox3Tag then
                --local text2 = tolua.cast(self.modifyLayer:getChildByTag(self.constData.cNodeModifyEditbox2Tag), "CCEditBox"):getText()
                local text2 = self.modifyEditbox2:getText()
                if string.len(text2) == self.constData.cPWDLength and string.match(text2,"%d%d%d%d%d%d") == text2 then
                    if text2 == text then
                        self.sptModifyTip3:setVisible(true)
                    else
                        self.labelModifyTip3:setVisible(true)
                    end
                else                 
                end
            end 
        elseif strEventName == "returnDone" then
        elseif strEventName == "changed" then
        end
    end
    --add editbox1
    local editboxParam = {};
    editboxParam.strHolder = '请输入原密码';
    editboxParam.inputMode = kEditBoxInputModeNumeric;
    editboxParam.inputFlag = kEditBoxInputFlagPassword;
    editboxParam.returnType = kKeyboardReturnTypeDone;
    editboxParam.maxLen = self.constData.cPWDLength;
    editboxParam.tag = self.constData.cNodeModifyEditbox1Tag

    local bgsprite = CCScale9Sprite:create("images/LieBiao/list_bg_shurujihuo.png")
    self.modifyEditbox1 = createEditBox(self.nodeModifyEditbox1Pos, bgsprite, modifyEditboxTextEventHandle,editboxParam);

    editboxParam.strHolder = '请输入新密码';
    editboxParam.tag = self.constData.cNodeModifyEditbox2Tag

    bgsprite = CCScale9Sprite:create("images/LieBiao/list_bg_shurujihuo.png")
    self.modifyEditbox2 = createEditBox(self.nodeModifyEditbox2Pos, bgsprite, modifyEditboxTextEventHandle,editboxParam);
    self.modifyEditbox2:setEnabled(false)

    editboxParam.strHolder = '请确认新密码';
    editboxParam.tag = self.constData.cNodeModifyEditbox3Tag

    bgsprite = CCScale9Sprite:create("images/LieBiao/list_bg_shurujihuo.png")
    self.modifyEditbox3 = createEditBox(self.nodeModifyEditbox3Pos, bgsprite, modifyEditboxTextEventHandle,editboxParam);
    self.modifyEditbox3:setEnabled(false)
    --show&hide tips
    self.labelModifyTip1:setVisible(false)
    self.labelModifyTip2:setVisible(false)
    self.labelModifyTip3:setVisible(false)
    self.sptModifyTip1:setVisible(false)
    self.sptModifyTip2:setVisible(false)
    self.sptModifyTip3:setVisible(false)  
    
end

function SafeScene:updateBaseView()
    print "SafeScene:updateBaseView"
    self.labelCurrentMoney:setString(self.ctrller.data.money_);
    self.logic.userData.ply_lobby_data_.money_ = self.ctrller.data.money_
    self.labelSafeMoney:setString(self.ctrller.data.amount_);

    --reset initlayer
    if self.initlayer == self.inLayer then
        self:resetInLayer()
    elseif self.initlayer == self.outLayer then
        self:resetOutLayer()
    end
end

function SafeScene:updateInLayer(ret)
    print "SafeScene:updateInLayer"
    print("ret = "..ret)

    self:showOperateProgress("updateInLayer", ret)
    if ret == 0 then
        self.ctrller.logic:onSocketSafeDataReq();
    end

end

function SafeScene:updateOutLayer(ret)
    print "SafeScene:updateOutLayer"
    print("ret = "..ret)
    
    self:showOperateProgress("updateOutLayer", ret)
    -- end
    if ret == 0 then
        self.ctrller.logic:onSocketSafeDataReq();
    end

end

function SafeScene:updateRecordLayer(ret)
    print "SafeScene:updateRecordLayer"
    print("ret = "..ret)
    if (#self.ctrller.data.history_ == 0) then
        self:showOperateProgress("updateRecordLayer", -1)
    else
        self:closePopBox();
    end
    if ret == 0 then
        self:resetRecordLayer()
    end
end
-- 0修改成功 -1未知错误 -2旧密码错误
function SafeScene:updateModifyLayer(ret)
    print "SafeScene:updateModifyLayer"
    print("ret = "..ret)

    self:showOperateProgress("updateModifyLayer", ret)
    if ret == 0 then
        self:resetModifyLayer()
    elseif ret == -2 then 
        self.modifyEditbox1:setText('')
        self.sptModifyTip1:setVisible(false)
        --self.labelModifyTip1:setVisible(false)
    else
        print("修改密码未知错误！！！")
    end
end

function SafeScene:resetInLayer()
    print "SafeScene:resetInLayer"
    if self.initlayer ~= self.inLayer then
        return
    end

    self.labelSaveMoney:setString('0'); 
    self.btnSaveSub:setEnabled(false);
    self.inSlider:setValue(0)

    if self.ctrller.data.money_ >= self.constData.cSaveMoenyUnit then
        self.tempData.tProgressBarUnit = math.modf(self.ctrller.data.money_/self.constData.cSaveMoenyUnit)
        self.inSlider:setMaximumValue(self.tempData.tProgressBarUnit)
        self.tempData.tProgressBarUnit = 1
        self.inSlider:setEnabled(true)
    else
        self.tempData.tProgressBarUnit = 0
        self.inSlider:setEnabled(false)
    end 
end

function SafeScene:resetOutLayer()
    print "SafeScene:resetOutLayer"
    if self.initlayer ~= self.outLayer then
        return
    end

    self.labelRemoveMoney:setString('0');
    self.btnOutSub:setEnabled(false);
    self.outEditbox:setText('');

    self.outSlider:setValue(0)

    if self.ctrller.data.amount_ >= self.constData.cSaveMoenyUnit then
        self.tempData.tProgressBarUnit = math.modf(self.ctrller.data.amount_/self.constData.cSaveMoenyUnit)
        self.outSlider:setMaximumValue(self.tempData.tProgressBarUnit)
        self.tempData.tProgressBarUnit = 1
        self.outSlider:setEnabled(true)
    else
        self.tempData.tProgressBarUnit = 0
        self.outSlider:setEnabled(false)
    end
end

function SafeScene:resetRecordLayer()
    print "SafeScene:resetRecordLayer"
    if self.initlayer ~= self.recordLayer then
        return
    end

    self:resetTabelView()
end

function SafeScene:resetModifyLayer()
    print "SafeScene:resetModifyLayer"
    if self.initlayer ~= self.modifyLayer then
        return
    end

    self.modifyEditbox1:setText('')
    self.modifyEditbox2:setText('')
    self.modifyEditbox3:setText('')
    self.modifyEditbox2:setEnabled(false)
    self.modifyEditbox3:setEnabled(false)

    self.labelModifyTip1:setVisible(false)
    self.labelModifyTip2:setVisible(false)
    self.labelModifyTip3:setVisible(false)

    self.sptModifyTip1:setVisible(false)
    self.sptModifyTip2:setVisible(false)
    self.sptModifyTip3:setVisible(false)
end

--table view start
function SafeScene.cellSizeForTable(table,idx)
    print("cellSizeForTable")
    return 70,740
end

function SafeScene.tableCellAtIndex(table, idx)
    print("tableCellAtIndex")
    local cell = table:dequeueCell()
    local label = nil
    if nil == cell then        
        cell = CCTableViewCell:new()
    else
        cell:removeAllChildrenWithCleanup(true);
    end 

    local itemInfo = table.history_[idx+1];
    local proxy = CCBProxy:create();
    local tempTable = {};

    local node = CCBuilderReaderLoad("interfaces/BaoXianXiangJilu.ccbi",proxy,tempTable);
    --var_dump(tempTable)
    tempTable.labelTime = tolua.cast(tempTable["labelTime"],"CCLabelTTF")
    tempTable.labelOperate = tolua.cast(tempTable["labelOperate"],"CCLabelTTF")
    tempTable.labelOperateMoney = tolua.cast(tempTable["labelOperateMoney"],"CCLabelTTF")
    tempTable.labelRemainMoney = tolua.cast(tempTable["labelRemainMoney"],"CCLabelTTF")

    tempTable.labelTime:setString(os.date("%Y-%m-%d %X", itemInfo.op_time_))
    tempTable.labelOperate:setString(itemInfo.type_ == 0 and '存入' or '取现')
    tempTable.labelOperateMoney:setString(itemInfo.amount_)
    tempTable.labelRemainMoney:setString(itemInfo.remaining_sum_)

    cell:addChild(node)
    return cell
end

function SafeScene.numberOfCellsInTableView(table)
    local data = table.history_
    return #data
end

function SafeScene:resetTabelView()
    if nil ~= self.tabView then
        self.tabView:removeFromParentAndCleanup(true)
        self.tabView = nil
    end
    if nil ~= self.ctrller.data.history_ and #self.ctrller.data.history_ > 0 then
        self.tabView = CCTableView:create(self.nodeRecordTablePos:getContentSize())
        self.tabView:setDirection(kCCScrollViewDirectionVertical)
        self.tabView:setVerticalFillOrder(kCCTableViewFillTopDown)
        self.nodeRecordTablePos:getParent():addChild(self.tabView)
        self.tabView:setPosition(self.nodeRecordTablePos:getPosition())
        self.tabView:registerScriptHandler(SafeScene.cellSizeForTable,CCTableView.kTableCellSizeForIndex)
        self.tabView:registerScriptHandler(SafeScene.tableCellAtIndex,CCTableView.kTableCellSizeAtIndex)
        self.tabView:registerScriptHandler(SafeScene.numberOfCellsInTableView,CCTableView.kNumberOfCellsInTableView)
        self.tabView.history_ = self.ctrller.data.history_
        self.tabView:reloadData()
    end

    return true
end
--table view end

--bind dialog  start
function SafeScene:showBindDialog(bShow)
    self.popChildren = require("moduleLobby.views.SafeBindDialog").new(self.constData,self);
    self:showPopBoxCCB("interfaces/BaoXianXiangMiMa.ccbi",self.popChildren,true);
end
--bind dialog end

--pop dialog 1 start
function SafeScene:showGetPasswordDialog(bShow)
    print 'showGetPasswordDialog'
    self.popChildren = require("moduleLobby.views.SafeGetPasswordDialog").new(self.constData,self);
    self:showPopBoxCCB("interfaces/BaoXianXiangTanKuang1.ccbi",self.popChildren,true);
end
--pop dialog 1 end

--pop dialog 2 start
function SafeScene:showOperateProgress(type, ret)
    self.constData.type = type;
    self.constData.ret = ret;
    print("====showOperateProgress,type="..type..";ret="..ret);
    self.popChildren = require("moduleLobby.views.SafeOperateProgress").new(self.constData,self);
    local pressToClose = false;
    if (type~="progress") then            
        pressToClose = true;
    end
    self:showPopBoxCCB("interfaces/BaoXianXiangTanKuang2.ccbi",self.popChildren,pressToClose);
end
--pop dialog 2 end

--block ui start
function SafeScene:timeout()
    self:showOperateProgress("timeout", self.constData.cOperateResultErrorTimeout)
end

return SafeScene;