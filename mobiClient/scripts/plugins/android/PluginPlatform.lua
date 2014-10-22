--
-- Author: Guo Jia
-- Date: 2014-10-22 11:40:46
--
local BaseClass = require("plugins.PluginPlatform");
local PlatformFake = class("PlatformFake",BaseClass);

function PlatformFake:ctor()
	PlatformFake.super.ctor();
end

return PlatformFake;