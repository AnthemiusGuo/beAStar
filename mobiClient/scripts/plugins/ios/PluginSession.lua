local BaseClass = require("plugins.PluginSession");
local SessionFake = class("SessionFake",BaseClass);

function SessionFake:ctor()
	SessionFake.super.ctor();
end

return SessionFake;