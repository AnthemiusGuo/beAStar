local BasePopup = class("BasePopup")

function BasePopup:ctor(popupName,data,relateView)
	print(popupName,data,relateView)
	self.popupName = popupName;
	self.data = data;
	self.relateView = relateView;
	self.pageVar = {};
end

function BasePopup:onInitView()
	-- body
end

function BasePopup:onAssignVars()
	-- body
end

function BasePopup:onClosePopBox()
	self.popupName = nil;
	self.data = nil;
	self.relateView = nil;
end

return BasePopup;