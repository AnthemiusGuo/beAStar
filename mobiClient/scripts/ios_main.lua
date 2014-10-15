
function __G__TRACKBACK__(errorMessage)
    print("----------------------------------------")
    print("LUA ERROR: " .. tostring(errorMessage) .. "\n")
    print(debug.traceback("", 2))
    print("----------------------------------------")
    if (superLogFile~=nil) then
    	echoLogFile("LUA ERROR: " .. tostring(errorMessage) .. "\n");
    	echoLogFile(debug.traceback("", 2));
    end
end
package.loaded["config"] = nil
package.loaded["izxFW.BaseFunctions"] = nil
package.loaded["izxFW.MBPluginManager"] = nil
package.loaded["izxFW.init"] = nil

require("config")

require("framework.init")
require("framework.shortcodes")
echoInfo("require init!!! start");
require("izxFW.init")
echoInfo("require init!!! end");

LAST_PLUGIN_ENV = CCUserDefault:sharedUserDefault():getIntegerForKey("LAST_PLUGIN_ENV");
echoInfo("LAST_PLUGIN_ENV:%d",LAST_PLUGIN_ENV);

superLog = CCUserDefault:sharedUserDefault():getBoolForKey("superLog");
echoInfo("superLog:%d",LAST_PLUGIN_ENV);

if (LAST_PLUGIN_ENV~=nil and LAST_PLUGIN_ENV>=10) then
	-- because in android not exist is 0 !!!!!!!!!!!
	PLUGIN_ENV = LAST_PLUGIN_ENV-10;
end

if (superLog==true) then
	-- device.writablePath = "/storage/extSdCard/data/";
	checkDirOK(device.writablePath..'/log/');
	superLogFile = device.writablePath..'/log/'..os.time()..".log";
	echoInfo("debug file will write to %s", superLogFile);
end

URL = getURL();

gBaseLogic = require("izxFW.BaseLogic").new();
gBaseLogic:init();
echoInfo("require gBaseLogic!!! end");
-- com.izhangxin.zjh.android.anzhi
gBaseLogic:setVersion(VERSION);

-- gBaseLogic:setSocketConfig({socketType = "LuaSockets",
--  							lobbySocketConfig = {socketIp = "s1.casino.hiigame.net",socketPort = "7200"}
 
--  							});
-- gBaseLogic:setSocketConfig(SOCKET_CONFIGS[PLUGIN_ENV]);

echoInfo("gBaseLogic setSocketConfig!!! end");
function onSessionResult(jsonMsg)
	echoInfo("C 2 LUA triggered!!!onSessionResult");
	-- jsonMsg = tolua.cast(jsonMsg,"CCString");
	-- local myMsg = jsonMsg:getCString();
	-- echoInfo("onSessionResult"..myMsg);
	local sessionRst = json.decode(jsonMsg);
	-- -- local sessionRst = {
	-- -- 	SessionResultCode = 0,
	-- -- 	msg = "登录成功",
	-- -- 	sessionInfo = {
	-- -- 		pid = "1103134337925138",
	-- -- 		nickname = "test01",
	-- -- 		ticket = "41fbbb4111fb21ba5e7bca8977484d54"
	-- -- 	}
	-- -- };
	--var_dump(sessionRst,4);
	print("================")
	if PLUGIN_ENV == ENV_TEST then
		print("PLUGIN_ENV == ENV_TEST")
		sessionRst.sessionInfo.port = 7201
	end
	local SocketConfig = {socketType = "LuaSockets",
 							lobbySocketConfig = {socketIp = sessionRst.sessionInfo.ip,socketPort = sessionRst.sessionInfo.port} 
 							}
	gBaseLogic:setSocketConfig(SocketConfig);
	scheduler.performWithDelayGlobal(function()
		gBaseLogic:onSessionResult(sessionRst);
	end, 0.001);
	
	return 1;
end

function onPayResult(jsonMsg)
	echoInfo("C 2 LUA triggered!!!onPayResult");
	local payRst = json.decode(jsonMsg);
	scheduler.performWithDelayGlobal(function()
		gBaseLogic:onPayResult(payRst);
	end, 0.5);
	
	return 1;
end

function onHeadImageResult(jsonMsg)
	echoInfo("C 2 LUA triggered!!!onHeadImageResult");
	local headImageRst = json.decode(jsonMsg);

	gBaseLogic:onHeadImageResult(headImageRst);
	return 1;
end


-- gBaseLogic:setTestUser({
-- 	ply_guid_ = "1103134337925138",
-- 	ply_nickname_ = "test01",
-- 	ply_ticket_ = "41fbbb4111fb21ba5e7bca8977484d54"
-- });
echoInfo("gBaseLogic run!!! begin");

gBaseLogic:run(updaterSuccOrFail);