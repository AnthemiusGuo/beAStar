local popChildren = class("SafeBindDialog",izx.basePopup);
function popChildren:ctor(data,relateView)
    self.super.ctor(self,"SafeBindDialog",data,relateView);
end
function popChildren:onPressBindAffirm(asc,sender)
    local text1 = self.editbox1:getText()
    local text2 = self.editbox2:getText()
    local text3 = self.editbox3:getText()

    local bAllNum1 = ((string.len(text1) > 0 and string.match(text1,"%d%d%d%d%d%d") == text1) and true or false)
    local bAllNum2 = ((string.len(text2) > 0 and string.match(text2,"%d%d%d%d%d%d") == text2) and true or false)
    local bAllNum3 = ((string.len(text3) > 0 and string.match(text3,"%d%d%d%d%d%d%d%d%d%d%d") == text3) and true or false)

    if string.len(text1) ~= self.data.cPWDLength or not bAllNum1 then
        self.labelBindTip1:setVisible(true)
    elseif text2 ~= text1 then
        self.labelBindTip2:setVisible(true)
    elseif string.len(text3) ~= self.data.cPhoneNumLength or not bAllNum3 then
        self.labelBindTip3:setVisible(true)
    else
        self.relateView.logic:reqSocketSafeSetPassWord(text1, text3)
        self.relateView:showOperateProgress("progress","bind")
    end
end

function popChildren:onAssignVars()
    self.nodeBindEditbox1Pos = tolua.cast(self["nodeBindEditbox1Pos"],"CCNode")
    self.nodeBindEditbox2Pos = tolua.cast(self["nodeBindEditbox2Pos"],"CCNode")
    self.nodeBindEditbox3Pos = tolua.cast(self["nodeBindEditbox3Pos"],"CCNode")
    self.btnAffirm = tolua.cast(self["btnAffirm"],"CCControlButton")

    self.sptBindTip1 = tolua.cast(self["sptBindTip1"],"CCSprite")
    self.sptBindTip2 = tolua.cast(self["sptBindTip2"],"CCSprite")
    self.sptBindTip3 = tolua.cast(self["sptBindTip3"],"CCSprite")
    self.labelBindTip1 = tolua.cast(self["labelBindTip1"],"CCLabelTTF")
    self.labelBindTip2 = tolua.cast(self["labelBindTip2"],"CCLabelTTF")
    self.labelBindTip3 = tolua.cast(self["labelBindTip3"],"CCLabelTTF")

    self.sptBindTip1:setVisible(false)
    self.sptBindTip2:setVisible(false)
    self.sptBindTip3:setVisible(false)
    self.labelBindTip1:setVisible(false)
    self.labelBindTip2:setVisible(false)
    self.labelBindTip3:setVisible(false)

    local editboxParam = {};
    editboxParam.strHolder = '请输入新密码';
    editboxParam.inputMode = kEditBoxInputModeNumeric;
    editboxParam.inputFlag = kEditBoxInputFlagPassword;
    editboxParam.maxLen = self.data.cPWDLength;
    editboxParam.tag = self.data.cNodeModifyEditbox1Tag;

    local bgsprite = CCScale9Sprite:create("images/LieBiao/list_bg_shurujihuo.png")
    self.editbox1 = createEditBox(self.nodeBindEditbox1Pos, bgsprite, handler(self,self.bindEditboxTextEventHandle),editboxParam);
    self.editbox1:setFont("Helvetica", 28);
    self.editbox1:setPlaceholderFontColor(ccc3(220,220,220))

    editboxParam.strHolder = '请确认密码';
    editboxParam.inputMode = kEditBoxInputModeNumeric;
    editboxParam.inputFlag = kEditBoxInputFlagPassword;
    editboxParam.maxLen = self.data.cPWDLength;
    editboxParam.tag = self.data.cNodeModifyEditbox2Tag;

    bgsprite = CCScale9Sprite:create("images/LieBiao/list_bg_shurujihuo.png")
    self.editbox2 = createEditBox(self.nodeBindEditbox2Pos, bgsprite, handler(self,self.bindEditboxTextEventHandle),editboxParam);
    self.editbox2:setFont("Helvetica", 28);
    self.editbox2:setPlaceholderFontColor(ccc3(220,220,220))

    editboxParam.strHolder = '请输入手机号';
    editboxParam.inputMode = kEditBoxInputModeNumeric;
    editboxParam.inputFlag = kEditBoxInputFlagInitialCapsAllCharacters;
    editboxParam.maxLen = self.data.cPhoneNumLength;
    editboxParam.tag = self.data.cNodeModifyEditbox3Tag;

    bgsprite = CCScale9Sprite:create("images/LieBiao/list_bg_shurujihuo.png")
    self.editbox3 = createEditBox(self.nodeBindEditbox3Pos, bgsprite, handler(self,self.bindEditboxTextEventHandle),editboxParam);
    self.editbox3:setFont("Helvetica", 28);
    self.editbox3:setPlaceholderFontColor(ccc3(220,220,220))
    
end

function popChildren:bindEditboxTextEventHandle(strEventName,pSender)

    local editBox = tolua.cast(pSender, "CCEditBox")
    local tag = editBox:getTag()
    local text = editBox:getText()
    local formatText = (editBox:getTag() == self.data.cNodeModifyEditbox3Tag and "%d%d%d%d%d%d%d%d%d%d%d" or "%d%d%d%d%d%d")
    local bAllNum = ((string.len(text) > 0 and string.match(text,formatText) == text) and true or false)

    if strEventName == "began" then
        if tag == self.data.cNodeModifyEditbox1Tag then
            self.sptBindTip1:setVisible(false)
            self.labelBindTip1:setVisible(false)
        elseif tag == self.data.cNodeModifyEditbox2Tag then
            self.sptBindTip2:setVisible(false)
            self.sptBindTip3:setVisible(false)
            self.labelBindTip2:setVisible(false)
            self.labelBindTip3:setVisible(false)
        elseif tag == self.data.cNodeModifyEditbox3Tag then
            self.sptBindTip3:setVisible(false)
            self.labelBindTip3:setVisible(false)
        end
    elseif strEventName == "ended" then
    elseif strEventName == "return" then
        if tag == self.data.cNodeModifyEditbox1Tag then
            if string.len(text) == self.data.cPWDLength and bAllNum then
                self.sptBindTip1:setVisible(true)
            else
                self.labelBindTip1:setVisible(true)
            end
        elseif tag == self.data.cNodeModifyEditbox2Tag then
            local editbox2 = tolua.cast(child:getChildByTag(self.data.cNodeModifyEditbox1Tag), "CCEditBox")
            local text2 = editbox2:getText()
            if string.len(text2) == self.data.cPWDLength and bAllNum then
                if text == text2 then
                    self.sptBindTip2:setVisible(true)
                else
                    self.labelBindTip2:setVisible(true)
                end
            end
        elseif tag == self.data.cNodeModifyEditbox3Tag then
            if string.len(text) == self.data.cPhoneNumLength and bAllNum then
                self.sptBindTip3:setVisible(true)
            else 
                self.labelBindTip3:setVisible(true)                
            end
        end
    elseif strEventName == "changed" then
    end
end

function popChildren:onClosePopBox()
    izx.baseAudio:playSound("audio_menu");
    self.relateView.popChildren = nil;
    self.super.onClosePopBox(self);
end

return popChildren;