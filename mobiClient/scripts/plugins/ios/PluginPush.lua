--
-- Author: Guo Jia
-- Date: 2014-10-22 11:40:46
--
local BaseClass = require("plugins.PluginPush");
local PushFake = class("PushFake",BaseClass);

function PushFake:ctor()
	PushFake.super.ctor();
end

return PushFake;