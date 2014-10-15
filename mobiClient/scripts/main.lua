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


-- gBaseLogic:setSocketConfig({socketType = "WebSockets",
--  							lobbySocketConfig = {socketIp = "127.0.0.1",socketPort = "3000"},
--  							ddzSocketConfig = {socketIp = "127.0.0.1",socketPort = "4400"}
--  							});

gBaseLogic:setSocketConfig(SOCKET_CONFIGS[PLUGIN_ENV]);
	
-- gBaseLogic:setSocketConfig({socketType = "LuaSockets",
--  							lobbySocketConfig = {socketIp = "115.238.229.242",socketPort = "7200"} 
--  							});

-- gBaseLogic:setSocketConfig({socketType = "LuaSockets",
--  							lobbySocketConfig = {socketIp = "115.238.229.242",socketPort = "7200"},
--  							ddzSocketConfig = {socketIp = "101.64.237.108",socketPort = "7305"}
--  							});
-- gBaseLogic:setSocketConfig({socketType = "LuaSockets",
-- 							lobbySocketConfig = {socketIp = "127.0.0.1",socketPort = "7200"},
-- 							ddzSocketConfig = {socketIp = "115.238.229.242",socketPort = "7309"}
-- 							});
-- gBaseLogic:setTestUser({
-- 	ply_guid_ = "1103134337925147",
-- 	ply_nickname_ = "hui222",
-- 	ply_ticket_ = "9be29f091fb4053d7d844e71f830966e"
-- });
gBaseLogic:run()