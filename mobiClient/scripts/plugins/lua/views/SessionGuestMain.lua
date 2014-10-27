local popChildren = class("SessionGuestMain",izx.basePopup);
function popChildren:ctor(data,relateView)
    self.super.ctor(self,"SessionGuestMain",data,relateView);
end

function popChildren:onAssignVars()
    
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