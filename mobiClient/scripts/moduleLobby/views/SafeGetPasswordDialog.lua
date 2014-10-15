local popChildren = class("SafeGetPasswordDialog",izx.basePopup);
function popChildren:ctor(data,relateView)
    self.super.ctor(self,"SafeGetPasswordDialog",data,relateView);
end
function popChildren:onPressGetPasswordAffirm()
    print 'onPressGetPasswordAffirm'
    izx.baseAudio:playSound("audio_menu");
    local text = self.editbox:getText()
    if string.len(text) ~= self.data.cPhoneNumLength then
        self.editbox:setText('')
        izxMessageBox("请输入正确的手机号", "手机号有误")
    else
        self.relateView.ctrller:getbackPwd(text)
        self.relateView:showOperateProgress("progress","getpwd")
    end
end

function popChildren:onAssignVars()
    self.nodeEditboxPos = tolua.cast(self["nodeEditboxPos"],"CCNode")
    self.btnAffirm = tolua.cast(self["btnAffirm"],"CCControlButton")

    local editboxParam = {};
    editboxParam.strHolder = '请输入手机号';
    editboxParam.inputMode = kEditBoxInputModeNumeric;
    editboxParam.inputFlag = kEditBoxInputFlagInitialCapsAllCharacters;
    editboxParam.maxLen = self.data.cPhoneNumLength;

    local bgsprite = CCScale9Sprite:create("images/LieBiao/list_bg_shurujihuo.png")
    self.editbox = createEditBox(self.nodeEditboxPos, bgsprite, handler(self,self.editboxTextEventHandle),editboxParam);
    self.editbox:setFont("Helvetica", 28);
    self.editbox:setPlaceholderFontColor(ccc3(220,220,220))
end

function popChildren:editboxTextEventHandle(strEventName,pSender)

end

function popChildren:onClosePopBox()
    self.relateView.popChildren = nil;
    self.super.onClosePopBox(self);
end

return popChildren;