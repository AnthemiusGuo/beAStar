-- DEFAULT.URL.MINIGAME_CONFIG = "http://127.0.0.1/index.php";
C_VERSION = 1393516800

FileManager = class("FileManager");
function FileManager:uncompress(zipFileName,targetPath)
	print("FileManager:uncompress("..zipFileName..","..targetPath..")");
end
function FileManager:MD5File(zipFileName)
	print("FileManager:MD5File()");
	return "WTF"
end
function FileManager:copyFile(src,target)
	local data = readFile(src)
	io.writefile(target, data);
	data= nil;
end

function FileManager:addSearchPath(src)
	CCFileUtils:sharedFileUtils():addSearchPath(src);
end

function FileManager:removeSearchPath(path)

	return
end

function FileManager:checkImageType(path)
	return 0
end

UpgradeManager = class("UpgradeManager");
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler");
function UpgradeManager:init(pluginModule,url,RESOURCE_PATH)
	return self;
end
function UpgradeManager:new(pluginModule,url,RESOURCE_PATH)
	return self;
end
function UpgradeManager:registerScriptHandler(callback)
	if callback then callback("{\"e\":\"success\"}") end
end
function UpgradeManager:checkUpgrade()
    return 0
end
function UpgradeManager:startDownload()
    
end
function UpgradeManager:deleteVersion()
    
end

PluginProxy = class("PluginProxy");
function PluginProxy:ctor()
	
end
function PluginProxy:getInstance()
	echoInfo("PluginProxy:getInstance");
	return self;
end

function PluginProxy:getSDKVersion(pluginName,pluginType)
	echoInfo("getSDKVersion:"..pluginName..":"..pluginType);
	return pluginName..":"..pluginType
end

function PluginProxy:getPluginVersion(pluginName,pluginType)
	echoInfo("getPluginVersion:"..pluginName..":"..pluginType);
	return pluginName..":"..pluginType
end

function PluginProxy:loadPlugin(pluginName)
	echoInfo("Load MB Plugin:"..pluginName);
	return PluginProtocol.new(pluginName);
end

function PluginProxy:setPluginConfig(plistConfig)
	echoInfo("Load MB Plugin config");
end

function PluginProxy:setPackageName(packageName)
	self.packageName = packageName;
end

function PluginProxy:gb2utf8(inStr)
	return inStr;
end

function PluginProxy:switchPluginXRunEnv( ... )
	-- body
end

function PluginProxy:getFrameworkVersion()
	return 14081500;
	-- return 14090401-- 14081500,14081501;
end

function PluginProxy:logEvent(typ,eventName,params)
	print(typ,eventName);
	var_dump(params);
end
function PluginProxy:getVersionName()
	print("getVersionName")
	return "3.0.3"
end

function PluginProxy:getVersionCode()
	print("getVersionCode")
	return 18
end

function PluginProxy:initHeadFace()
	function headFaceRst()	
		local headImageRst = {
			PlatformResultCode = 0,
			msg = "成功",
			url = gBaseLogic.DownloadPath.."zhaocaimao.png"
		};
		-- local headImageRst = {
		-- 	PlatformResultCode = 2,
		-- 	msg = "成功",
		-- 	url = gBaseLogic.lobbyLogic.face
		-- }; 
		-- local headImageRst = {
		-- 	PlatformResultCode = 1,
		-- 	msg = "成功",
		-- 	url = gBaseLogic.lobbyLogic.face
		-- };

		gBaseLogic:onHeadImageResult(headImageRst);
	end
	scheduler.performWithDelayGlobal(headFaceRst, 1)
end 
function PluginProxy:getSimStatue()
	print("PluginProxy:getSimStatue():false")
	return true --false --false
end 
function PluginProxy:getSimType()
	print("PluginProxy:getSimType():false")
	return "1" --false --false
end
function PluginProxy:StartPushSDK()
	print("PluginProxy:StartPushSDK")
end 
function PluginProxy:paySMS(payInfo)
		payInfo = tolua.cast(payInfo, "CCDictionary");
		local boxid = payInfo:objectForKey("boxId");
		boxid = tolua.cast(boxid, "CCString");
		local realBoxId = boxid:getCString();
		print("PluginProxy:paySMS",realBoxId)

	function payRsts()
		-- body

		local payResult = {
			PayResultCode = 0,
			msg = "zhifu成功",
			payInfo = {

        		boxid =  tonumber(realBoxId),
				RSA_ALIPAY_PUBLIC ="MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDdj8hFu/dP1fgz/xVOU+eqnwuInO2km8alkb0Y 6w1j8EDFKnEihewGCrLZR82ueXJ356UJwwadjEg/ZEaVsqN4G9/IkHvjDmJqBWD9T2uO4Gp8Yo/l EiH+Gkm1rsnWzotJ33IOZJvQ1IehK0hPrdvCoDbk1BWvL9fkspY4UeTdtwIDAQAB",
				sign = "Puz5ANXfI2CT3kWTUUr0ZuFxDV3bKnNmAD8oAFOqoOoQKfKkJ0iipFVUyLS34R6+8QvPvdV4VEKATVyQZkujrNXg0A/VqoEyXlHiTzqooZlJ7abqaAU7y6dn8KF0cjiPi9WaNhB7UQDK1gxwY+mglSFLDgYOWTF4tE5AcXRGdg4=",
				result_tip2 = "",
				ret = 0,
				orderInfo = 'partner="2088901165876504"&seller="2088901165876504"&out_trade_no="201401061803849315"&subject="快速支付测试=￥2元"&body="内含2w游戏币"&total_fee="2.0"&notify_url="http://t.mall.hiigame.com/alipay/notify/default"';
				result_tip1 = "支付成功",
				order = "201401061803849315"
			}
		};

		gBaseLogic:onPayResult(payResult);
	end
    scheduler.performWithDelayGlobal(payRsts, 1)
end

function PluginProxy:pay(payInfo,x)
		payInfo = tolua.cast(payInfo, "CCDictionary");
		local boxid = payInfo:objectForKey("boxId");
		boxid = tolua.cast(boxid, "CCString");
		local realBoxId = boxid:getCString();
		print("PluginProxy:pay",realBoxId)
	function payRsts()
		-- body
		
		local payResult = {
			PayResultCode = 0,
			msg = "zhifu成功",
			payInfo = {
        		boxid =  tonumber(realBoxId),
				RSA_ALIPAY_PUBLIC ="MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDdj8hFu/dP1fgz/xVOU+eqnwuInO2km8alkb0Y 6w1j8EDFKnEihewGCrLZR82ueXJ356UJwwadjEg/ZEaVsqN4G9/IkHvjDmJqBWD9T2uO4Gp8Yo/l EiH+Gkm1rsnWzotJ33IOZJvQ1IehK0hPrdvCoDbk1BWvL9fkspY4UeTdtwIDAQAB",
				sign = "Puz5ANXfI2CT3kWTUUr0ZuFxDV3bKnNmAD8oAFOqoOoQKfKkJ0iipFVUyLS34R6+8QvPvdV4VEKATVyQZkujrNXg0A/VqoEyXlHiTzqooZlJ7abqaAU7y6dn8KF0cjiPi9WaNhB7UQDK1gxwY+mglSFLDgYOWTF4tE5AcXRGdg4=",
				result_tip2 = "",
				ret = 0,
				orderInfo = 'partner="2088901165876504"&seller="2088901165876504"&out_trade_no="201401061803849315"&subject="快速支付测试=￥2元"&body="内含2w游戏币"&total_fee="2.0"&notify_url="http://t.mall.hiigame.com/alipay/notify/default"';
				result_tip1 = "支付成功",
				order = "201401061803849315"
			}
		};
		-- local payResult = {
		-- 	PayResultCode = 2,

		-- 	msg = "你对该宝箱的购买已经到达每日限制，请选择其它商品购买！",
		-- 	payInfo = {
  --       		boxid =  270,
		-- 		RSA_ALIPAY_PUBLIC ="MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDdj8hFu/dP1fgz/xVOU+eqnwuInO2km8alkb0Y 6w1j8EDFKnEihewGCrLZR82ueXJ356UJwwadjEg/ZEaVsqN4G9/IkHvjDmJqBWD9T2uO4Gp8Yo/l EiH+Gkm1rsnWzotJ33IOZJvQ1IehK0hPrdvCoDbk1BWvL9fkspY4UeTdtwIDAQAB",
		-- 		sign = "Puz5ANXfI2CT3kWTUUr0ZuFxDV3bKnNmAD8oAFOqoOoQKfKkJ0iipFVUyLS34R6+8QvPvdV4VEKATVyQZkujrNXg0A/VqoEyXlHiTzqooZlJ7abqaAU7y6dn8KF0cjiPi9WaNhB7UQDK1gxwY+mglSFLDgYOWTF4tE5AcXRGdg4=",
		-- 		result_tip2 = "",
		-- 		ret = -9,
		-- 		orderInfo = 'partner="2088901165876504"&seller="2088901165876504"&out_trade_no="201401061803849315"&subject="快速支付测试=￥2元"&body="内含2w游戏币"&total_fee="2.0"&notify_url="http://t.mall.hiigame.com/alipay/notify/default"';
		-- 		result_tip1 = "支付成功",
		-- 		order = "201401061803849315"
		-- 	}
		-- };
		gBaseLogic:onPayResult(payResult);
	end
    scheduler.performWithDelayGlobal(payRsts, 1)
	
end

function PluginProxy:logout()
end

function PluginProxy:login(sessionType)
	-- local sessionRst = {
	-- 	SessionResultCode = 0,
	-- 	msg = "登录成功",
	-- 	sessionInfo = {
	-- 		pid = "1103134337925138",
	-- 		nickname = "test01",
	-- 		ticket = "41fbbb4111fb21ba5e7bca8977484d54"
	-- 	}
	-- }; 

	function logined()
		-- body
	
		local sessionRst = {
			SessionResultCode = 0,
			msg = "登录成功",
			sessionInfo = {
				pid = "1101134337162591",
				nickname = "JL",
				ticket = "e45efd25fce07e6035fb86f1325d3814",
				ip = "s3.casino.hiigame.net",
				--ip = "192.168.30.158",
				port = "7200",
				--face = "http://img.cache.bdo.banding.com.cn/faces/default.png"
			},
			-- sessionInfo = {
			-- 	pid = "1103134337925745",
			-- 	nickname = "sadafff",
			-- 	ticket = "c64c37e2004b007330690fbe6a22f510",
			-- 	ip = "s3.casino.hiigame.net",
			-- 	port = "7200",
			-- 	face = "http://img.cache.bdo.banding.com.cn/faces/default.png"
			-- },
			-- sessionInfo = {
			-- 	pid = "1101133836943856",
			-- 	nickname = "goon003",
			-- 	ticket = "f3321bef984009b3b7d79f0642179e8b",
			-- 	ip = "s3.casino.hiigame.net",
			-- 	port = "7200",
			-- 	face = "http://img.cache.bdo.banding.com.cn/faces/default.png"
			-- },

			-- sessionInfo = {
			-- 	pid = "1101133836943856",
			-- 	nickname = "goon003",
			-- 	ticket = "f3321bef984009b3b7d79f0642179e8b",
			-- 	--ip = "s3.casino.hiigame.net",
			-- 	ip = "192.168.30.158",
			-- 	port = "7200",
			-- 	face = "http://img.cache.bdo.banding.com.cn/faces/default.png"
			-- },


			sessionInfo = {
				pid = "1513134338485551",
				nickname = "Guo Jia",
				ticket = "f5d427f50276ed6f95aac51224ac951d",
				ip = "s3.casino.hiigame.net",
				port = "7201",
				face = "http://qzapp.qlogo.cn/qzapp/100289601/E0871AD9945967BBE987647C9DA9CDA4/100"
			},
			-- sessionInfo = {
			-- 	pid = "1501134337144068",
			-- 	nickname = "testtest",
			-- 	ticket = "w5345345345",
			-- 	ip = "s3.casino.hiigame.net",
			-- 	port = "7200",
			-- 	face = "http://img.cache.bdo.banding.com.cn/faces/default.png"
			-- }
			-- sessionInfo = {
			-- 	pid = "1101134337163194",
			-- 	nickname = "test22",
			-- 	ticket = "f3321bef984009b3b7d79f0642179e8b",
			-- 	ip = "s3.casino.hiigame.net",
			-- 	port = "7200",
			-- 	face = "http://img.cache.bdo.banding.com.cn/faces/default.png"
			-- }
			-- sessionInfo = {
			-- 	pid = "1113134339110250",
			-- 	nickname = "GT-N7100",
			-- 	ticket = "d8022ccb24df42249902e418e83838dc",
			-- 	port = "7200",
			-- 	face = "http://img.cache.bdo.banding.com.cn/faces/default.png"
			-- }

			-- sessionInfo = {
			-- 	pid = "1103134337925157",
			-- 	nickname = "GT-N7100",
			-- 	ticket = "8aa0371a0f406cabc48ef9a0d213d692",
			-- 	port = "7200",
			-- 	face = "http://img.cache.bdo.banding.com.cn/faces/default.png"
			-- }
		};

		gBaseLogic:onSessionResult(sessionRst);
	end
    
    scheduler.performWithDelayGlobal(logined, 2)
end

PluginProtocol = class("PluginProtocol");
function PluginProtocol:ctor(pluginName)
	self.pluginName = pluginName;
end

function PluginProtocol:setDebugMode(debug)
	self.debug = debug;
end

function PluginProtocol:setDebugMode()
	
end
function PluginProxy:getMilliseconds()
	return 1;
	
end

function PluginProxy:getDeviceIMEI()
	return "1111"
end

function PluginProxy:getDeviceIMSI()
	return "1111"
end

function PluginProxy:getMacAddress()
	return "1111"
end

CONFIG_USE_SOUND = false;
