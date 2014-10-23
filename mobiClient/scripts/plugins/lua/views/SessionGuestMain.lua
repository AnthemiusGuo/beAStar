local popChildren = class("SessionGuestMain",izx.basePopup);
function popChildren:ctor(data,relateView)
    self.super.ctor(self,"MessageRstBox",data,relateView);
end

function popChildren:onAssignVars()
    self.labelPopContent = tolua.cast(self["labelPopContent"],"CCLabelTTF")
    self.labelPopTitle = tolua.cast(self["labelPopTitle"],"CCLabelTTF")


    self.labelPopTitle:setString(self.data.title)
    self.labelPopContent:setString(self.data.content)
end

function popChildren:onPressBtnOK()
    self:closePopBox();
end

function popChildren:onClosePopBox()
	izx.baseAudio:playSound("audio_menu");
	if (self.relateView) then
    	self.relateView.popChildren = nil;
	end
    self.super.onClosePopBox(self);
end

return popChildren;