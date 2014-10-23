local BaseClass = require("plugins.PluginSession");
local SessionGuest = class("SessionGuest",BaseClass);

function SessionGuest:ctor()
	SessionGuest.super.ctor();
end

function SessionGuest:getUuid()
	self.uuid = device.getOpenUDID();
	if (self.uuid=="") then
		local uuid = CCUserDefault:sharedUserDefault():getStringForKey("uuid4");
		if (uuid=="") then
			local uuid4= require("extensions.uuid4");
			uuid = uuid4.getUUID();
			CCUserDefault:sharedUserDefault():setStringForKey("uuid4",uuid);
		end
		self.uuid = uuid;
	end
end

function SessionGuest:onPressCancelLogin()

end

function SessionGuest:sessionLogin()
	echoInfo("SessionGuest:sessionLogin");
	gBaseLogic:blockUI({autoUnblock=false,msg=LOGIN_LOADING_TIPS1,hasCancel=false});
	self:getUuid();
	echoInfo("self:getUuid %s",self.uuid);
	
end

return SessionGuest;