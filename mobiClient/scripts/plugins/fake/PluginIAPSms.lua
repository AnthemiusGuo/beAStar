--
-- Author: Guo Jia
-- Date: 2014-10-22 11:40:46
--
local BaseClass = require("plugins.PluginIAPSms");
local IAPSmsFake = class("IAPSmsFake",BaseClass);

function IAPSmsFake:ctor()
	IAPSmsFake.super.ctor();
end

return IAPSmsFake;