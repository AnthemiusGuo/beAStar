function __G__TRACKBACK__(errorMessage)
    print("----------------------------------------")
    print("LUA ERROR: " .. tostring(errorMessage) .. "\n")
    print(debug.traceback("", 2))
    print("----------------------------------------")
end
require("config")
require("version_control")  --add by lxy
require("framework.init")
require("framework.shortcodes")

require("gap")
require("izxFW.init")
-- if true then
-- 	print(get00ofday())
-- 	return
-- end
URL = getURL();

for k,v in pairs(RES_LOAD_PRE_PATH) do
	CCFileUtils:sharedFileUtils():addSearchPath(v);
end

gBaseLogic = require("izxFW.BaseLogic").new();
gBaseLogic:init();
gBaseLogic:setVersion(SHOW_VERSION);


gBaseLogic:setSocketConfig(SOCKET_CONFIGS[PLUGIN_ENV]);
	
gBaseLogic:run()