--
-- Author: Guo Jia
-- Date: 2014-10-22 11:40:46
--
local BaseClass = require("plugins.PluginExtend");
local ExtendFake = class("ExtendFake",BaseClass);

function ExtendFake:ctor()
	ExtendFake.super.ctor();
end

return ExtendFake;