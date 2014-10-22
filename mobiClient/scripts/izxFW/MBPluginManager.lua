local MBPluginManager = class("MBPluginManager")

function MBPluginManager:ctor()
	self.m_bPlatformLogined = false;
    require("framework.api.EventProtocol").extend(self);
    if (SKIP_PLUGIN) then
        self.pluginProxy = require("plugin_gap").new();
        self.frameworkVersion = 0;
    else
        self.pluginProxy = require("izxFW.PluginProxy").new();
        self.frameworkVersion = self:getFrameworkVersion();
    end

    
    self.hasSocial = false;
    self.pluginProxy:switchPluginXRunEnv(PLUGIN_ENV);
    self.m_strOnlineConfig = nil;
end

function MBPluginManager:getFrameworkVersion()
    self.frameworkVersion = self.pluginProxy:getFrameworkVersion();
    return self.frameworkVersion;

end

function MBPluginManager:getDeviceInfo()
    
    if device.platform=="ios" then
        return {imei = "",
        imsi = "",
        mac = ""
        };
    else
        return {
        imei = self.pluginProxy:getDeviceIMEI(),
        imsi = self.pluginProxy:getDeviceIMSI(),
        mac = self.pluginProxy:getMacAddress()
        }
    end

end

function MBPluginManager:getConfigParams(configName,param_key,defaultValue)
    print("MBPluginManager:getConfigParams 0"..param_key)
    if(self.distributions.onlineConfig == true) then
        if(self.m_strOnlineConfig == nil or self.m_strOnlineConfig == -1) then
            return defaultValue
        end
        if(self.m_strOnlineConfig[param_key] == nil) then
            return defaultValue
        end
        local value = self.m_strOnlineConfig[param_key];
        if(tonumber(value) == 1) then
            return true;
        else
            return false;
        end
        --return self.pluginProxy:getConfigParams(configName,param_key,defaultValue)
    else
        return defaultValue
    end
end
function MBPluginManager:getConfigStringParams(configName,param_key,defaultValue)
    if(self.distributions.onlineConfig == true) then
        return self.pluginProxy:getConfigStringParams(configName,param_key,defaultValue)
    else
        return defaultValue
    end
end

function MBPluginManager:purgeMBPluginManager()
	if (self.s_pPurchase) then
		self.s_pPurchase = nil;
	end
	--PluginManager:end();
end
function MBPluginManager:getDeviceIMEI()
    if device.platform=="ios" then
        return "";
    else
        return self.pluginProxy:getDeviceIMEI();
    end
end

function MBPluginManager:getMacAddress()
    return self.pluginProxy:getMacAddress();
end
function MBPluginManager:unloadPlugins()
end
function  MBPluginManager:startSession()

    -- if(analytics_) then
    --     analytics_:startSession("");
    -- end
end
function  MBPluginManager:stopSession()

	-- if(analytics_) then
	-- 	analytics_:stopSession();
	-- end
end

function MBPluginManager:loadConfigPlist()
    self.distributions = require("distribution");


    local distConfigPath=CCFileUtils:sharedFileUtils():fullPathForFilename("config.plist");
    local distConfigDic=CCDictionary:createWithContentsOfFile(distConfigPath)

    local disConfig = distConfigDic:objectForKey("config")

    disConfig = tolua.cast(disConfig,"CCDictionary");
    local allKeys = disConfig:allKeys()
    local count = allKeys:count()
    self.distributions['textstr'] = {};
    self.distributions['trumpetFilterWords'] = {};
    self.distributions['serverFliterWords'] = {};
    for i=1,count do
        local key = tolua.cast(allKeys:objectAtIndex(i-1), "CCString"):getCString();
        local value = disConfig:objectForKey(key);
        value = tolua.cast(value, "CCString")
        self.distributions[key] = value:getCString();
        
        print("key = "..key)
        if (key=="replace_text") then
            print("self.distributions===="..key)
            print(self.distributions[key])
            if self.distributions[key]~="" then
                local v = split(self.distributions[key],"|")
                for k,info in pairs(v) do
                    local v2 = split(info,":")
                    if v2[2]~=nil then
                        v2[1] = tostring(v2[1])
                        self.distributions['textstr'][v2[1]] = v2[2];
                    end

                end
            end
        elseif (key=="trumpet_fliter_words") then
            if self.distributions[key]~="" then
                local v = split(self.distributions[key],"|")
                for k,info in pairs(v) do
                    table.insert(self.distributions['trumpetFilterWords'], info)
                end
            end
            print "self.distributions[trumpetFilterWords] = "
            var_dump(self.distributions['trumpetFilterWords'])
        elseif (key=="server_fliter_words") then
            if self.distributions[key]~="" then
                local v = split(self.distributions[key],"|")
                for k,info in pairs(v) do
                    table.insert(self.distributions['serverFliterWords'], info)
                end
            end
            print "self.distributions[serverFliterWords] = "
            var_dump(self.distributions['serverFliterWords'])
        else
            if (tonumber(self.distributions[key])==1) then
                self.distributions[key] = true;
            elseif (tonumber(self.distributions[key])==0) then
                self.distributions[key] = false;
            end
        end
    end

end

function MBPluginManager:loadPluginsConfig()
    self:loadConfigPlist();
    self.IAPSmsType = "";
    self.IAPType = "";
    self.allIAPSmsType = {};
    self.allIApTyp = {};
	local plistName = "plugins.plist";
    if PLUGIN_ENV == ENV_TEST then
        plistName = "plugins.t.plist"
    elseif PLUGIN_ENV == ENV_MIRROR then
        plistName = "plugins.m.plist"
    end
    print(plistName)
    local plistPath=CCFileUtils:sharedFileUtils():fullPathForFilename(plistName)
    echoInfo("will load plugins from %s", plistPath);
    if (io.exists(plistPath)~=true) then
        echoInfo("%s not exists", plistName);
        plistName = "plugins.plist";
        plistPath=CCFileUtils:sharedFileUtils():fullPathForFilename(plistName)
    end

    local plugin_plist_table = trans_plist_to_lua_table(plistPath);

    self.packetName = plugin_plist_table.game[1].PacketName;

    self.pluginConfigs = {};
    self.allLoginTyp = {};
    self.loginTypNum = 0;

    for k,v in pairs(plugin_plist_table.plugins) do
        v.type = tonumber(v.type);
        if (v.runType==nil) then
            if device.platform=="ios" then
                v.runType="ios"
            elseif device.platform=="android" then
                v.runType="android"
            else
                v.runType="unknown"
            end
        end
        self.pluginConfigs[v.name] = v;
        if (v.type==kPluginIAP) then

        elseif (v.type==kPluginIAPSms) then
            --todo

        elseif (v.type==kPluginSession ) then
            self.allLoginTyp[v.name] = v;
            self.loginTypNum = self.loginTypNum+1;
        end
        self.pluginProxy:initPlugin(v.type,v.name,v);
    end

end

function MBPluginManager:loadPluginsConfigOld()
    self:loadConfigPlist();
    self.IAPSmsType = "";
    self.IAPType = "";
    self.allIAPSmsType = {};
    self.allIApTyp = {};
	local plistName = "plugins.plist";
    if PLUGIN_ENV == ENV_TEST then
        plistName = "plugins.t.plist"
    elseif PLUGIN_ENV == ENV_MIRROR then
        plistName = "plugins.m.plist"
    end
    print(plistName)
    local plistPath=CCFileUtils:sharedFileUtils():fullPathForFilename(plistName)
    echoInfo("will load plugins from %s", plistPath);
    if (io.exists(plistPath)~=true) then
        echoInfo("%s not exists", plistName);
        plistName = "plugins.plist";
        plistPath=CCFileUtils:sharedFileUtils():fullPathForFilename(plistName)
    end
    local plistDic=CCDictionary:createWithContentsOfFile(plistPath)
    tolua.cast(plistDic, "CCDictionary")

    self.packetName = plugin_plist_table.game[1].PacketName;

    self.pluginConfigs = {};
    self.allLoginTyp = {};
    self.loginTypNum = 0;
    
    gameConfig = tolua.cast(plistDic:objectForKey("plugins"),"CCArray");

    for i=1,gameConfig:count() do
    	local configItem = gameConfig:objectAtIndex(i-1);
    	tolua.cast(configItem, "CCDictionary")
    	
    	local pluginName = tolua.cast(configItem:objectForKey("name"), "CCString"):getCString();
    	self.pluginConfigs[pluginName] = {};

	    local allKeys = configItem:allKeys()
    	local count = allKeys:count()

    	for j=0, count-1 do
        	local key = tolua.cast(allKeys:objectAtIndex(j), "CCString"):getCString();

    	self.pluginConfigs[pluginName][key] = tolua.cast(configItem:objectForKey(key), "CCString"):getCString();
            
            if (key == "type") then

                -- record what IAP im using
                if (self.pluginConfigs[pluginName][key]==kPluginIAP.."") then
                    local mid;
                    if (configItem:objectForKey("mid")==nil) then
                        mid = nil;
                    else
                        mid = tolua.cast(configItem:objectForKey("mid"), "CCString"):getCString();
                    end
                    self.IAPType = pluginName;
                    if mid~=nil then
                        mid = tonumber(mid)
                        self.allIApTyp[mid] = pluginName
                        if mid==CCUserDefault:sharedUserDefault():getIntegerForKey("UserPayType") then
                            self.IAPType = pluginName;
                        end
                    end
                elseif (self.pluginConfigs[pluginName][key]==kPluginIAPSms.."") then
                    self.IAPSmsType = pluginName;
                    local mid;
                    if (configItem:objectForKey("mid")==nil) then
                        mid = nil;
                    else
                        mid = tolua.cast(configItem:objectForKey("mid"), "CCString"):getCString();
                    end
                    
                    if mid~=nil then
                        mid = tonumber(mid)
                        local simTyp = tolua.cast(configItem:objectForKey("SmsTyp"), "CCString"):getCString();
                        simTyp = tonumber(simTyp)
                        -- local 
                        local thisflag = 0
                        if simTyp==0 then
                            thisflag = 1
                        elseif simTyp==1 and self.distributions.yidong_sms then
                            thisflag = 1
                        elseif simTyp==2 and self.distributions.liantong_sms then
                            thisflag = 1
                        elseif simTyp==3 and self.distributions.dianxin_sms then
                            thisflag = 1
                        elseif simTyp==-1 then
                            thisflag = 1
                        end

                        if thisflag==1 then
                            local needConfirm = 0
                            if configItem:objectForKey("needConfirm")~=nil then
                                needConfirm = tolua.cast(configItem:objectForKey("needConfirm"), "CCString"):getCString();
                                needConfirm = tonumber(needConfirm)
                            end
                            local info = {mid=mid,pluginName=pluginName,simTyp=simTyp,needConfirm=needConfirm}
                            table.insert(self.allIAPSmsType,info)
                            -- self.allIAPSmsType[mid] = 
                            self.IAPSmsType = pluginName;
                            self.IAPSmsNeedConfirm = needConfirm
                        end
                        
                    end
                elseif (self.pluginConfigs[pluginName][key]==kPluginSession.."" ) then
                    self.allLoginTyp[pluginName] = self.pluginConfigs[pluginName];
                    self.loginTypNum = self.loginTypNum+1;
                end                
            end
    	end
    end
    print("self.allIAPSmsTypeloginTypNum")
    var_dump(self.allIAPSmsType)
    var_dump(self.allIApTyp)
    
    self.pluginProxy:setPluginConfig(plistDic); 
end

function MBPluginManager:replaceText(t)
    print("MBPluginManager:replaceText"..t)
    var_dump(self.distributions['textstr'])
    if self.distributions['textstr']~=nil then
        for k,v in pairs(self.distributions['textstr']) do
            t = string.gsub(t, k, v)
        end
    end
    -- if self.distributions['textstr'][t] ~= nil then
    --     return self.distributions['textstr'][t];
    -- end
    return t;
end

function MBPluginManager:getLogoFile(k)
    if self.distributions[k]~=nil then
        
        local filename = CCFileUtils:sharedFileUtils():fullPathForFilename(self.distributions[k])
        if io.exists(filename)==true then
            return filename;
        end
    end
    return "images/DengLu/login_logo.png";
end

function MBPluginManager:replacelogo(k,node)
    print("MBPluginManager:replacelogo"..k)    
    if self.distributions[k]~=nil then
        print(self.distributions[k])
        print(CCFileUtils:sharedFileUtils():fullPathForFilename(self.distributions[k]))
        local filename = CCFileUtils:sharedFileUtils():fullPathForFilename(self.distributions[k])
        if io.exists(filename)==true then
            node:setTexture(getCCTextureByName(filename))
            return true;
        end
    end
    return false;
    -- if self.distributions['textstr'][t] ~= nil then
    --     return self.distributions['textstr'][t];
    -- end
end

function MBPluginManager:loadSessionPlugins()
    echoInfo("loadSessionPlugins");
    self.pluginProxy:switchPluginXRunEnv(PLUGIN_ENV);
    -- init MB plugins
    self.pluginProxy:setPackageName(self.packetName);
    for key, plugin_config in pairs(self.pluginConfigs) do  
        
        if (tonumber(plugin_config.type)==kPluginSession) then
            echoInfo("Will load :%s as %d",key,tonumber(plugin_config.type));
            plugin_protocol = self.pluginProxy:loadPlugin(key,plugin_config.type);
        end
    end 
    self.pluginProxy:switchPluginXRunEnv(PLUGIN_ENV);

end

function MBPluginManager:loadPlatformPlugins()
	echoInfo("loadPlatformPlugins");
    self.pluginProxy:switchPluginXRunEnv(PLUGIN_ENV);
    -- init MB plugins
	echoInfo("setPackageName %s",self.packetName);
    self.pluginProxy:setPackageName(self.packetName);
    for key, plugin_config in pairs(self.pluginConfigs) do  
        
        if (tonumber(plugin_config.type)==kPluginPlatform) then
			echoInfo("Will load :%s as %d",key,tonumber(plugin_config.type));
            plugin_protocol = self.pluginProxy:loadPlugin(key,plugin_config.type);
        end
    end 
    self.pluginProxy:switchPluginXRunEnv(PLUGIN_ENV);

end

function MBPluginManager:loadAnalysePlugins()
    echoInfo("loadAnalysePlugins");
    self.pluginProxy:switchPluginXRunEnv(PLUGIN_ENV);
    -- init MB plugins
    for key, plugin_config in pairs(self.pluginConfigs) do  
        
        if (tonumber(plugin_config.type)==kPluginAnalytics) then
            echoInfo("Will load :%s as %d",key,tonumber(plugin_config.type));
            plugin_protocol = self.pluginProxy:loadPlugin(key,plugin_config.type);
        end
    end 
    self.pluginProxy:switchPluginXRunEnv(PLUGIN_ENV);
end

function MBPluginManager:loadPlugins()
    self.hasSocial = false;
    self.pluginProxy:switchPluginXRunEnv(PLUGIN_ENV);
	-- init MB plugins
	self.pluginProxy:setPackageName(gBaseLogic.packageName);
	for key, plugin_config in pairs(self.pluginConfigs) do  
		echoInfo("Will load :"..key);
		if (tonumber(plugin_config.default) == 1 or tonumber(plugin_config.type)==kPluginSession) then
	    	plugin_protocol = self.pluginProxy:loadPlugin(key,plugin_config.type);
	    end
        if (tonumber(plugin_config.type)==kPluginSocial) then
            
            self.hasSocial = true;            
        end
	end 
    self.pluginProxy:switchPluginXRunEnv(PLUGIN_ENV);
end

function MBPluginManager:sessionLogout()
    self.m_bPlatformLogined = false
    self.pluginProxy:logout();

end

function MBPluginManager:sessionLogin(sessionType)
    if(self.m_bPlatformLogined == true) then
        self:sessionLogout()
    end
    gBaseLogic:prepareRelogin();
    self.sessionType = sessionType;
    gBaseLogic.onLogining = false;
    if (self.distributions.logoutwhenlogin) then
	    self.pluginProxy:logout_login(sessionType);
    else
        self.pluginProxy:login(sessionType);
    end
end

function MBPluginManager:pay(payInfo)
    if (self.distributions.banedpay) then
        gBaseLogic:unblockUI();
        izxMessageBox("支付尚未开放","支付说明");
        return;
    end
    if (self.IAPType == "") then
        -- 不支持直接支付的时候用短代
        self:paySMS(payInfo);
        return;
    end
    self.pluginProxy:loadPlugin(self.IAPType,kPluginIAP);

    local dicPayInfo = CCDictionary:create();

    for key, value in pairs(payInfo) do
        cValue = CCString:create(value);
        dicPayInfo:setObject(cValue,key);
    end
            
    self.pluginProxy:pay(dicPayInfo);
end

function MBPluginManager:paySMS(payInfo)
    if (self.distributions.banedpay) then
        gBaseLogic:unblockUI();
        izxMessageBox("支付尚未开放","支付说明");
        return;
    end
    -- self.IAPSmsType = payInfo.IAPSmsType
    if (self.s_pPurchaseSms== nil) then
        self.s_pPurchaseSms = self.pluginProxy:loadPlugin(self.IAPSmsType,kPluginIAPSms);
    end
    var_dump(s_pPurchase);
    print("MBPluginManager:paySMS")
    var_dump(payInfo);

    local dicPayInfo = CCDictionary:create();

    for key, value in pairs(payInfo) do
        cValue = CCString:create(value.."");
        dicPayInfo:setObject(cValue,key);
    end
            
    self.pluginProxy:paySMS(dicPayInfo);
end 
function MBPluginManager:initHeadFace()
    print("MBPluginManager:initHeadFace")
           
    self.pluginProxy:initHeadFace()
end 

function MBPluginManager:getSimStatue()
    local state  = self.pluginProxy:getSimStatue()
    echoInfo("MBPluginManager:getSimStatue")
    var_dump(state);

    return state;
end

function MBPluginManager:getSimType()
    local state  = self.pluginProxy:getSimType()
    echoInfo("MBPluginManager:getSimType")
    var_dump(state);

    return state;
end

function MBPluginManager:getVersionInfo()
    local versionInfo = {};
    versionInfo.version_name = self.pluginProxy:getVersionName();
    versionInfo.version_code = tonumber(self.pluginProxy:getVersionCode());

    return versionInfo;
end

function MBPluginManager:StartPushSDK()
    print("MBPluginManager:StartPushSDK")
    self.pluginProxy:StartPushSDK()
end

function MBPluginManager:confirmExit()
    echoInfo("MBPluginManager:confirmExit!!!!!!!!!");
    self.pluginProxy:onExit();
end

function MBPluginManager:createToolbar()
    echoInfo("MBPluginManager:createToolbar!!!!!!!!!");
    var_dump(self.distributions.toolbar);
    if (self.distributions.toolbar) then
        self.pluginProxy:createToolbar();
    end
end
-- * 跳转到tag对应的功能
-- * tag值:
-- * 1.个人中心入口
-- * 2.社区入口
-- * 3.用户反馈入口
-- * 4.论坛入口
-- * 5.工具条
-- * 6.退出页
-- * 7.奖励宝
      
function MBPluginManager:jumpToExtend(tag)
    echoInfo("MBPluginManager:jumpToExtend!!!!!!!!!");
    var_dump(self.distributions.jumpToExtend);
    if (self.distributions.jumpToExtend) then
        print("MBPluginManager:jumpToExtend")
        self.pluginProxy:jumpToExtend(tag);
    end
end
function MBPluginManager:showPingCoo(tag)
    echoInfo("MBPluginManager:showPingCoo!!!!!!!!!");
    var_dump(self.distributions.showPingCoo);
    if (self.distributions.showPingCoo) then
        print("MBPluginManager:showPingCoo")
        self.pluginProxy:showPingCoo(tag);
    end
end

function MBPluginManager:enterSocial()
    self.pluginProxy:enterSocial();
end

function MBPluginManager:share(shareImage,shareContent,shareType)
    echoInfo("MBPluginManager:share!!!!!!!!!");
    var_dump(shareImage);
    var_dump(shareContent);
    if (self.frameworkVersion<14042901) then
        self.pluginProxy:share(shareImage,shareContent);
    else
        if (shareType==nil) then
            shareType = 0
        else
            shareType = tonumber(shareType);
        end
        self.pluginProxy:share(shareImage,shareContent,shareType);
    end
    
end

function MBPluginManager:copyToClipboard(text)
    print("MBPluginManager:copyToClipboard",text)
    self.pluginProxy:copyToClipboard(text);
end
-- TAG_LOG_EVENT_ID = 0,
-- TAG_LOG_EVENT_ID_KV,1
-- TAG_LOG_EVENT_ID_DURATION,2
-- TAG_LOG_EVENT_LABEL_DURATION,3
-- TAG_LOG_EVENT_BEGIN,4
-- TAG_LOG_EVENT_END,5
-- TAG_LOG_EVENT_LABEL_BEGIN,6
-- TAG_LOG_EVENT_LABEL_END 7

-- gBaseLogic.MBPluginManager:logEvent("login");
--     gBaseLogic.MBPluginManager:logEventKV("login2",{name=self.lobbyLogic.userData.ply_nickname_});
--     gBaseLogic.MBPluginManager:logEventDuration("login3",12)
--     gBaseLogic.MBPluginManager:logEventLabelDuration("login4",self.packageName,14)
--     gBaseLogic.MBPluginManager:logEventBegin("login5")
    
--     gBaseLogic.MBPluginManager:logEventLabelBegin("login6",self.packageName)
-- gBaseLogic.MBPluginManager:logEventEnd("login5")
--             gBaseLogic.MBPluginManager:logEventLabelEnd("login6",self.packageName)

function MBPluginManager:logEvent(eventName)
    self:logEventC(0,eventName,"");
end
function MBPluginManager:logEventKV(eventName,param)
    self:logEventC(1,eventName,json.encode(param));
end
function MBPluginManager:logEventDuration(eventName,duration)
    self:logEventC(2,eventName,tostring(duration));
end
function MBPluginManager:logEventLabelDuration(eventName,label,duration)
    self:logEventC(3,eventName,json.encode({duration=tonumber(duration),label=label}));
end
function MBPluginManager:logEventBegin(eventName)
    self:logEventC(4,eventName,"");
end
function MBPluginManager:logEventEnd(eventName)
    self:logEventC(5,eventName,"");
end
function MBPluginManager:logEventLabelBegin(eventName,label)
    self:logEventC(6,eventName,label);
end
function MBPluginManager:logEventLabelEnd(eventName,label)
    self:logEventC(7,eventName,label);
end

function MBPluginManager:logEventLabelDurationMyBegin(eventName)
    local now = self.pluginProxy:getMilliseconds();
    echoInfo("............now is %d..............", now);
    if (self.allTimers==nil) then
        self.allTimers = {};
    end
    if (self.allTimers[eventName]==nil) then
        self.allTimers[eventName] = {};
    end
    self.allTimers[eventName].main = now;
end
function MBPluginManager:logEventLabelDurationMyEnd(eventName,label)
    if (self.allTimers==nil) then
        self.allTimers = {};
        return;
    end
    if (self.allTimers[eventName]==nil) then
        return;
    end
    if (self.allTimers[eventName].main==nil) then
        return;
    end
    local now = self.pluginProxy:getMilliseconds();
    local timeEscaped = now - self.allTimers[eventName].main;
    self:logEventLabelDuration(eventName,label,timeEscaped);
end
function MBPluginManager:logEventMyBegin(eventName)
    local now = self.pluginProxy:getMilliseconds();
    echoInfo("............now is %d..............", now);
    if (self.allTimers==nil) then
        self.allTimers = {};
    end
    if (self.allTimers[eventName]==nil) then
        self.allTimers[eventName] = {};
    end
    self.allTimers[eventName].main = now;
end
function MBPluginManager:logEventMyEnd(eventName)
    if (self.allTimers==nil) then
        self.allTimers = {};
        return;
    end
    if (self.allTimers[eventName]==nil) then
        return;
    end
    if (self.allTimers[eventName].main==nil) then
        return;
    end
    local now = self.pluginProxy:getMilliseconds();
    local timeEscaped = now - self.allTimers[eventName].main;
    local param = {
        __ct__ = timeEscaped
    };
    self:logEventC(1,eventName,json.encode(param));
end

function MBPluginManager:logEventLabelMyBegin(eventName,label)
    local now = self.pluginProxy:getMilliseconds();
    echoInfo("............now is %d..............", now);
    if (self.allTimers==nil) then
        self.allTimers = {};
    end
    if (self.allTimers[eventName]==nil) then
        self.allTimers[eventName] = {};
    end

    self.allTimers[eventName][label] = now;
end
function MBPluginManager:logEventLabelMyEnd(eventName,label)
    if (self.allTimers==nil) then
        self.allTimers = {};
        return;
    end
    if (self.allTimers[eventName]==nil) then
        return;
    end
    if (self.allTimers[eventName][label]==nil) then
        return;
    end
    local now = self.pluginProxy:getMilliseconds();
    local timeEscaped = now - self.allTimers[eventName][label];
    local param = {
        __ct__ = timeEscaped
    };
    self:logEventC(1,eventName.."_"..label,json.encode(param));
end

-- event format: {$eventName = {$labelName1=$time1,$labelName2=$time2},$eventName2={...}}
function MBPluginManager:logEventDurationTable(events)
    for eventName,v in pairs(events) do
        for label,timeEscaped in pairs(v) do
            local param = {
                __ct__ = timeEscaped
            };
            self:logEventC(1,eventName.."_"..label,json.encode(param));
        end
    end
end

function MBPluginManager:logEventC(typ,eventName,params)

    if (self.frameworkVersion<14042901) then
        echoInfo("Don't support this function now");
        return;
    end
    if (self.pluginProxy==nil) then
        echoError("pluginProxy is nil now, please use manual method to log");
        return;
    end
    self.pluginProxy:logEvent(typ,eventName,params);
end

return MBPluginManager	
