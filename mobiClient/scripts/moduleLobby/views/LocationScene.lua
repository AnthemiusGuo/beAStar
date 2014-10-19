local LocationScene = class("LocationScene",izx.baseView)

function LocationScene:prepareVar()
	self.pageVar.location_img = 'images/Location/Locale_'..self.ctrller.data.locationInfo.imgId..'.png';
	self.pageVar.location_name = self.ctrller.data.locationInfo.locationName;
	self.pageVar.city_name = self.ctrller.data.locationInfo.cityName;
	self.pageVar.avatar_img = 'images/Avatar/'..self.ctrller.data.userInfo.avatarId..'.png';
	self.pageVar.uname = self.ctrller.data.userInfo.uname;
	self.pageVar.vip_level = self.ctrller.data.userInfo.vip_level;
	self.pageVar.level = self.ctrller.data.userInfo.level;
	self.pageVar.exp = self.ctrller.data.userInfo.exp;
	self.pageVar.exp_len = self.ctrller.data.userInfo.exp_len;
	self.pageVar.money = self.ctrller.data.userInfo.money;
	self.pageVar.voucher = self.ctrller.data.userInfo.voucher;
	self.pageVar.credits = self.ctrller.data.userInfo.credits;
	self.pageVar.money_show = self.ctrller.data.userInfo.money_show;
	self.pageVar.mood = self.ctrller.data.userInfo.mood;
	self.pageVar.energy = self.ctrller.data.userInfo.energy;
end

function LocationScene:onAssignVars()

end

function LocationScene:onPressPlayers(e)
    print("LocationScene:onPressPlayers");
    var_dump(e);
end

return LocationScene;
