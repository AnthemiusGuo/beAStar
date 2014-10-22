local PluginProxy = class("PluginProxy");
function PluginProxy:ctor()
	self.pluginConfigs = {};
	self.pluginLists = {};
	self.plugins = {};
end
function PluginProxy:getInstance()
	echoInfo("PluginProxy:getInstance");
	return self;
end

function PluginProxy:initPlugin(typ,name,config)
	local ConfigTyps = {
		[kPluginAds] = "PluginAds";
		[kPluginAnalytics] = "PluginAnalytics";
		[kPluginIAP] = "PluginIAP";
		[kPluginSocial] = "PluginSocial";
		[kPluginSession] = "PluginSession";
		[kPluginExend] = "PluginExtend";
		[kPluginPush] = "PluginPush";
		[kPluginIAPSelector] = "PluginIAPSelector";
		[kPluginPlatform] = "PluginPlatform";
		[kPluginIAPSms] = "PluginIAPSms";
	};
	echoInfo("will init %d : %s ,%s",typ,ConfigTyps[typ],name);
	self.pluginConfigs[name] = config;
	if (self.pluginLists[typ]==nil) then
		self.pluginLists[typ] = {};
	end
	self.pluginLists[typ][name] = {name = name};

	if (device.platform=="windows" and config.runType ~= "lua") then
		config.runType = "unknown";
	end

	if (config.runType == "lua") then
		self.pluginLists[typ][name].instance = require("plugins.lua."..name).new();
	elseif  (config.runType == "android") then
		self.pluginLists[typ][name].instance = require("plugins.android."..ConfigTyps[typ]).new();
	elseif (config.runType == "ios") then
		self.pluginLists[typ][name].instance = require("plugins.ios."..ConfigTyps[typ]).new();
	elseif (config.runType == "unknown") then
		self.pluginLists[typ][name].instance = require("plugins.fake."..ConfigTyps[typ]).new();
	end
	if (config.default==1) then
		self.plugins[typ] = self.pluginLists[typ][name].instance;
	end
end

function PluginProxy:getSDKVersion(pluginName,pluginType)
	echoInfo("getSDKVersion:"..pluginName..":"..pluginType);
	return "getSDKVersion:"..pluginName..":"..pluginType
end

function PluginProxy:getPluginVersion(pluginName,pluginType)
	echoInfo("getPluginVersion:"..pluginName..":"..pluginType);
	return "getPluginVersion:"..pluginName..":"..pluginType
end

function PluginProxy:loadPlugin(pluginName)
	echoInfo("Load Plugin:"..pluginName);
	if (self.pluginConfigs[pluginName]==nil) then
		echoError("not exists this plugin!!==%s",pluginName);
		return false;
	end
	local info = self.pluginConfigs[pluginName];
	self.pluginLists[info.type][pluginName].instance:loadPlugin();
	return true;
end

function PluginProxy:logEvent(typ,eventName,params)
	var_dump(typ);
	var_dump(eventName);
	var_dump(params);
end

function PluginProxy:setPluginConfig(plistConfig)
	echoInfo("Load MB Plugin config");
end

function PluginProxy:setPackageName(packageName)
	self.packageName = packageName;
end

function PluginProxy:create_toolbar()

end

function PluginProxy:onExit()
	return;
end

function PluginProxy:getFrameworkVersion()
	return 14061101;
end

function PluginProxy:gb2utf8(inStr)
	return inStr;
end

function PluginProxy:switchPluginXRunEnv( ... )
	-- body
end

function PluginProxy:initHeadFace()
	
end 
function PluginProxy:getSimStatue()
	print("PluginProxy:getSimStatue():false")
	return false --false
end 
function PluginProxy:StartPushSDK()
	print("PluginProxy:StartPushSDK")
end 
function PluginProxy:paySMS(payInfo)
	
end

function PluginProxy:pay(payInfo,x)
	
end

function PluginProxy:logout()
end

function PluginProxy:login(pluginName)
	self.pluginLists[kPluginSession][pluginName].instance:sessionLogin();
end

function PluginProxy:getDeviceIMEI()
	if (self.plugins[kPluginPlatform]) then

		return self.plugins[kPluginPlatform]:getDeviceIMEI();
	end
	return "unknownIMEI";
end

function PluginProxy:getDeviceIMSI()
	if (self.plugins[kPluginPlatform]) then

		return self.plugins[kPluginPlatform]:getDeviceIMSI();
	end
	return "unknownIMSI";
end

function PluginProxy:getMacAddress()
	if (self.plugins[kPluginPlatform]) then

		return self.plugins[kPluginPlatform]:getMacAddress();
	end
	return "unknownMAC";
end

return PluginProxy;