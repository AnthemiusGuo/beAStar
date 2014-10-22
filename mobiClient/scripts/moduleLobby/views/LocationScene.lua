local LocationScene = class("LocationScene",izx.baseView)

function LocationScene:prepareVar()
	self.pageVar.location_img = 'images/Location/Locale_'..gBaseLogic.lobbyLogic.locationData.imgId..'.png';
	self.pageVar.location_name = gBaseLogic.lobbyLogic.locationData.locationName;
	self.pageVar.city_name = gBaseLogic.lobbyLogic.locationData.cityName;
	self.pageVar.avatar_img = 'images/Avatar/'..gBaseLogic.lobbyLogic.userData.avatarId..'.png';
	self.pageVar.uname = gBaseLogic.lobbyLogic.userData.uname;
	self.pageVar.vip_level = gBaseLogic.lobbyLogic.userData.vip_level;
	self.pageVar.level = gBaseLogic.lobbyLogic.userData.level;
	self.pageVar.exp = gBaseLogic.lobbyLogic.userData.exp;
	self.pageVar.exp_len = gBaseLogic.lobbyLogic.userData.exp_len;
	self.pageVar.money = gBaseLogic.lobbyLogic.userData.money;
	self.pageVar.voucher = gBaseLogic.lobbyLogic.userData.voucher;
	self.pageVar.credits = gBaseLogic.lobbyLogic.userData.credits;
	self.pageVar.money_show = gBaseLogic.lobbyLogic.userData.money_show;
	self.pageVar.mood = gBaseLogic.lobbyLogic.userData.mood;
	self.pageVar.energy = gBaseLogic.lobbyLogic.userData.energy;
end

function LocationScene:resetPage()
	self:prepareVar();
	
end

function LocationScene:onAssignVars()

end

function LocationScene:onPressPlayers(e)
    print("LocationScene:onPressPlayers");
    var_dump(e);
end

return LocationScene;
