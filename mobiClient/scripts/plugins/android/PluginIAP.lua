--
-- Author: Guo Jia
-- Date: 2014-10-22 11:40:46
--
local BaseClass = require("plugins.PluginIAP");
local IAPFake = class("IAPFake",BaseClass);

function IAPFake:ctor()
	IAPFake.super.ctor();
end

return IAPFake;