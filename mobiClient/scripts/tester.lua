--
-- Author: Guo Jia
-- Date: 2014-04-23 13:55:06
--
function __G__TRACKBACK__(errorMessage)
    print("----------------------------------------")
    print("LUA ERROR: " .. tostring(errorMessage) .. "\n")
    print(debug.traceback("", 2))
    print("----------------------------------------")
end


require("config")

require("framework.init")
require("framework.shortcodes")
require("gap")
require("izxFW.init")
URL = getURL();
params = {};
url = "igame.b0.upaiyun.com/readme/aaaa.htm";

HTTPPostRequest(url, params, function(event)
    	if (event==nil) then
    		var_dump(event)
    		return;
    	end
 	end
 );
