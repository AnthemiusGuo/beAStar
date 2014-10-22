
-- 0 - disable debug info, 1 - less debug info, 2 - verbose debug info
LOAD_DEPRECATED_API = true               -- 在框架初始化时载入过时的 API 定义
USE_DEPRECATED_EVENT_ARGUMENTS = true    -- 使用过时的事件回调参数
DISABLE_DEPRECATED_WARNING = false -- true: 不显示过时 API 警告，false: 要显示警告
 
DEBUG = 0
SOCKET_DEBUG = true
DEBUG_FPS = false
DEBUG_MEM = false

-- design resolution
CONFIG_SCREEN_WIDTH  = 1136
CONFIG_SCREEN_HEIGHT = 640

-- auto scale mode
CONFIG_SCREEN_AUTOSCALE = "FIXED_WIDTH"


-- DDZ
MAIN_GAME_ID = 10
CASINO_VERSION_DEFAULT = 1409673601
--1406217601

SHOW_VERSION = "3.0.9.5"
VERSION = "3.0.9.5"
LUA_VERSION = "36845"
-- LUA_VERSION = "36266"
-- LUA_VERSION = "35899"
-- LUA_VERSION = "34943"

HELP_QQ = "800061676"
-- id,Index,道具名称,道具URL
-- 0,0,游戏币,http://img.cache.bdo.banding.com.cn/shop/youxibi.png
-- 1,1,小喇叭,http://img.cache.bdo.banding.com.cn/shop/prop_trumpet_logo.png
-- 2,2,记牌器,http://img.cache.bdo.banding.com.cn/shop/jipaiqi.png
-- 3,3,参赛券,http://img.cache.bdo.banding.com.cn/shop/bisaiquan.png
 
-- 5,5,招财猫表情包,http://img.cache.bdo.banding.com.cn/shop/zhaocaimao.png
 
 
-- 9,50,拉霸币,http://img.cache.bdo.banding.com.cn/shop/lababi.png
 
-- 13,80,元宝,http://img.cache.bdo.banding.com.cn/shop/yuanbao.png
CONFIG_GAME_USE_ITEMS = {[0]=1,[1]=1,[2]=1,[3]=1,[5]=1,[50]=1,[80]=1,[54]=1,[55]=1,[56]=1,[57]=1,[58]=1,[59]=1}


MINIGAME_IN_DEVELOP = false;

-- ALL HTTP REQUEST URL
DEFAULT = {};
DEFAULT.URL = {};
-- Resource DIR
RESOURCE_PATH = "/game/"
C_RESOURCE_PATH = "/c_res/"
 
RES_LOAD_PRE_PATH = {"res/baseRes/"}

ENV_OFFICIAL = 0;
ENV_TEST = 1;
ENV_MIRROR = 2;

PLUGIN_ENV = ENV_TEST --ENV_TEST--ENV_OFFICIAL--ENV_MIRROR; 

CONFIG_USE_SOUND = true;

DEFAULT.URL.DEFAULT_FACE = "http://img.cache.bdo.banding.com.cn/faces/default.png"
SOCKET_CONFIGS = {
	[ENV_TEST]={socketType = "LuaSockets",	 							lobbySocketConfig = {socketIp = "s3.casino.hiigame.net",socketPort = "7201"} },
	-- [ENV_TEST]={socketType = "LuaSockets",	lobbySocketConfig = {socketIp = "192.168.30.158",socketPort = "7200"}},
	[ENV_MIRROR]={socketType = "LuaSockets",
	 							lobbySocketConfig = {socketIp = "test.casino.hiigame.net",socketPort = "7200"} 
	 							},
	[ENV_OFFICIAL]={socketType = "LuaSockets",
	 							lobbySocketConfig = {socketIp = "s1.casino.hiigame.net",socketPort = "7200"} 
	 							}
}

function getURL()
-- 	web登录接口 payment.hiigame.com:18000
-- web支付站点 mall.hiigame.com
--  web前台站点 statics.hiigame.com
	local prevUrl = {}
	if (PLUGIN_ENV ==ENV_TEST) then
		--todo
		prevUrl.static = "http://127.0.0.1/beAStar/webServer/wwwroot/";
		prevUrl.pay = "http://t.mall.hiigame.com/";
		prevUrl.web = "http://t.statics.hiigame.com/";
		prevUrl.activity = "http://activity.izhangxin.com/";
		-- http://activity.izhangxin.com
	elseif (PLUGIN_ENV ==ENV_MIRROR) then
		prevUrl.login1 = "http://m.payment.hiigame.com/";
		prevUrl.login2 = "http://m.payment.hiigame.com:18000/";
		prevUrl.pay = "http://m.mall.hiigame.com/";
		prevUrl.web = "http://m.statics.hiigame.com/";
		prevUrl.activity = "http://activity.izhangxin.com/";
	else
		prevUrl.login1 = "http://payment.hiigame.com/";
		prevUrl.login2 = "http://payment.hiigame.com:18000/";
		prevUrl.pay = "http://mall.hiigame.com/";
		prevUrl.web = "http://statics.hiigame.com/";
		prevUrl.activity = "http://activity.izhangxin.com/";


	end
	
	DEFAULT.URL.GET_EXCHANGE_PERSONAL_INFO =prevUrl.web.."get/user/identify";
	
	
	return DEFAULT.URL;
end

LOADING_TIPS = {
	"每天登录可以领取游戏币哦！",
	"游戏中可以点击宝箱领取在线时长奖励！",
	"获得元宝后可以进入商店兑换实物奖品哦！",
	"游戏中可以点击宝箱领取在线时长奖励！",
	"中级场以上元宝奖励翻倍！",
	"完成游戏任务获得元宝，元宝可在商店兑换奖品！"
}

kPluginAds = 1;
kPluginAnalytics = 2;
kPluginIAP = 3;
kPluginSocial = 4;
kPluginSession = 5;
kPluginExend = 6;
kPluginPush = 7;
kPluginIAPSelector = 8;
kPluginPlatform = 9;
kPluginIAPSms = 10;

SKIP_PLUGIN = false;
SKIP_UPGRADE = false;

LOGIN_LOADING_TIPS = "一大波农民正在逼近,请稍候";
LOGIN_LOADING_TIPS0 = "正在获取服务器信息……";
LOGIN_LOADING_TIPS1 = "正在发送账号信息……";
LOGIN_LOADING_TIPS2 = "正在连接服务器……";
LOGIN_LOADING_TIPS3 = "正在验证账号……";
LOGIN_LOADING_TIPS4 = "正在登录游戏……";

LOGIN_LOADING_TIPS0 = "正在连接……";
LOGIN_LOADING_TIPS1 = "正在连接……";
LOGIN_LOADING_TIPS2 = "正在连接……";
LOGIN_LOADING_TIPS3 = "正在登录……";
LOGIN_LOADING_TIPS4 = "正在登录……";
