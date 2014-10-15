
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
 
RES_LOAD_PRE_PATH = {"res/baseRes/","res/moduleDDZRes/"}

ENV_OFFICIAL = 0;
ENV_TEST = 1;
ENV_MIRROR = 2;

PLUGIN_ENV = ENV_OFFICIAL --ENV_TEST--ENV_OFFICIAL--ENV_MIRROR; 

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
	if (PLUGIN_ENV ==ENV_TEST) then
		DEFAULT.URL.Feedback = "http://t.payment.hiigame.com/new/gateway/feedback";
		DEFAULT.URL.FeedbackList = "http://t.payment.hiigame.com/new/gateway/feedback/list";
		DEFAULT.URL.GONGGAO = "http://t.payment.hiigame.com/new/gateway/game/tips?gameid={gameid}&pn={packageName}&count=5&pid={pid}&pagenow=4&pagesize=1&gametype=0";
		DEFAULT.URL.CHECK_PACAKGE_VERSION = "http://127.0.0.1/DDZ/{moduleName}Version";
		DEFAULT.URL.SHOPITEMS = "http://t.mall.hiigame.com/shop/box/list"
		DEFAULT.URL.SHOP_HISTORY = "http://t.mall.hiigame.com/vou/order/list?pid={pid}&ticket={ticket}&pn={packageName}";

		DEFAULT.URL.CDKAWARD = "http://t.statics.hiigame.com/gift/key/activation?uid={pid}&ticket={ticket}&giftkey={cdk}&gameid={gameid}&sign={sign}";
		DEFAULT.URL.USERBATCH = "http://t.payment.hiigame.com/new/gateway/user/batch?uids={uids}"
		DEFAULT.URL.NAMECHANGE = "http://t.statics.hiigame.com/get/modify/count.do"
		DEFAULT.URL.NAMECOMMIT = "http://t.payment.hiigame.com:18000/user/detail/upt"
		DEFAULT.URL.NEWTASK = "http://t.payment.hiigame.com:18000/task/novice/list?pid={pid}&ticket={ticket}"
		DEFAULT.URL.NEWTASKAWARD = "http://t.payment.hiigame.com:18000/task/draw/award?pid={pid}&ticket={ticket}&taskid={taskid}"
		DEFAULT.URL.GOLDEXC_RECHCARD_TYPE = "http://t.payment.hiigame.com:18000/new/gateway/vou/goods/types?pn={packageName}"
		DEFAULT.URL.GOLDEXC_RECHCARD_LIST = "http://t.payment.hiigame.com:18000/new/gateway/vou/goods/list?type={type}"
		DEFAULT.URL.GOLDEXC_EXCGIFT = "http://t.payment.hiigame.com:18000/new/gateway/vou/goods/newcharge?gid={gid}&pid={pid}&ticket={ticket}&pn={packageName}&gameid={gameid}&name=123&address=123&phone=123&code=123"
		DEFAULT.URL.GOLDEXC_EXCRECORD = "http://t.payment.hiigame.com:18000/query/pay/order/list?pid={pid}&ticket={ticket}&pn={packageName}&type={type}"
		DEFAULT.URL.MINIGAME_CONFIG = "http://t.statics.hiigame.com/get/smallgame/showlist";
		DEFAULT.URL.MAINGAME_VERSION_CTL = "http://t.statics.hiigame.com/get/game/config";

		DEFAULT.URL.DAYTASK = "http://t.statics.hiigame.com/load/panel/image.do"
		DEFAULT.URL.CHONGZHIJIANGLI_INIT = "http://t.statics.hiigame.com/load/pay/award.do?pn={packageName}&uid={pid}&rm=0"
		DEFAULT.URL.CHONGZHIJIANGLI_AWARD = "http://t.statics.hiigame.com/get/pay/award.do?pn={packageName}&uid={pid}&awardid={awardid}&money={money}&gameid={gameid}"
		DEFAULT.URL.HUODONG = "http://t.izhangxin.com:9090/load/activity/list.do?uid={uid}&gameid={gameid}&sign={sign}"
		-- http://activity.izhangxin.com/load/activity/listuid={uid}&gameid={gameid}&sign={sign}
		-- http://t.izhangxin.com:9090//load/game/activity?channel={channel}&gameid={gameid}&uid={uid}&sign={sign}&time={time}";

		DEFAULT.URL.ISHUODONG = "http://igame.b0.upaiyun.com/readme/aaaa.htm"

		DEFAULT.URL.GETPROMOTE = "http://t.statics.hiigame.com/get/promotion/code";
		DEFAULT.URL.PROMOTEBINDING = "http://t.statics.hiigame.com/bind/promotion/code.do";
		DEFAULT.URL.GETPROMOTEPARTNER = "http://t.statics.hiigame.com/get/bound/friend/info.do";
		DEFAULT.URL.GETPROMOTERECORD = "http://t.statics.hiigame.com/get/promotion/record";
		DEFAULT.URL.GETPROMOTEAWARD = "http://t.statics.hiigame.com/get/promotion/award";
		DEFAULT.URL.IFBINDING = "http://t.statics.hiigame.com/is/promotion/bind";
		DEFAULT.URL.GETALLHEADIMAGE = "http://t.statics.hiigame.com/get/face/all"
		DEFAULT.URL.SETALLHEADIMAGE = "http://t.statics.hiigame.com/get/face/url"

		DEFAULT.URL.SAFTGETPWD ="http://t.statics.hiigame.com/get/casino/safepassword?pid={pid}&phoneno={phoneno}&ticket={ticket}&signMsg={signMsg}"

		DEFAULT.URL.XIAOFEIXIANE = "http://t.statics.hiigame.com/get/consumelimit/tips"

		DEFAULT.URL.GETFUNCTIONSTATUS = "http://t.statics.hiigame.com/get/online/param?paramname={pName}"
		DEFAULT.URL.DoubleChest = "http://t.statics.hiigame.com/get/first/pay/box"
		DEFAULT.URL.TOTALUPDATE = "http://t.statics.hiigame.com/version/update"
		DEFAULT.URL.APP_UPDATE_INIT_ALL = "http://t.statics.hiigame.com/get/loading/params"
		DEFAULT.URL.GET_ITEM_LIST = "http://t.statics.hiigame.com/get/goods/list?pn={pn}&gameid={gameid}&index={index}";
		DEFAULT.URL.EXCHANGE_ITEM = "http://t.statics.hiigame.com/vou/goods/charge?pn={pn}&gameid={gameid}&gid={gid}&uid={uid}&ticket={ticket}";
		DEFAULT.URL.GET_ITEM_EXCHANGE_RECORD_LIST = "http://t.statics.hiigame.com/get/charge/list?pn={pn}&uid={uid}&ticket={ticket}";
		DEFAULT.URL.GETEVALUATE = "http://t.payment.hiigame.com:18000/new/gateway/evaluate?pid={pid}&ticket={ticket}&mac={mac}&pn={packageName}";
 		DEFAULT.URL.MATCHINFODATA = "http://t.statics.hiigame.com/get/match/player"
 		DEFAULT.URL.MATCHRANKINFO = "http://t.statics.hiigame.com/get/round/rank/info"
		DEFAULT.URL.MATCHGETAWARDE = "http://t.statics.hiigame.com/get/player/bonus"
		DEFAULT.URL.AWARDEVALUATE = "http://t.payment.hiigame.com:18000/new/gateway/eva/gm?pid={pid}&order={order}";
		
 

	elseif (PLUGIN_ENV ==ENV_MIRROR) then
		DEFAULT.URL.Feedback = "http://m.payment.hiigame.com/new/gateway/feedback"
		DEFAULT.URL.FeedbackList = "http://m.payment.hiigame.com/new/gateway/feedback/list";
		DEFAULT.URL.GONGGAO = "http://m.payment.hiigame.com/new/gateway/game/tips?gameid={gameid}&pn={packageName}&count=5&pid={pid}&pagenow=4&pagesize=1&gametype=0";
		DEFAULT.URL.CHECK_PACAKGE_VERSION = "http://127.0.0.1/DDZ/{moduleName}Version";
		DEFAULT.URL.SHOPITEMS = "http://m.mall.hiigame.com/shop/box/list"
		DEFAULT.URL.SHOP_HISTORY = "http://m.mall.hiigame.com/vou/order/list?pid={pid}&ticket={ticket}&pn={packageName}";
		DEFAULT.URL.CDKAWARD = "http://m.statics.hiigame.com/gift/key/activation?uid={pid}&ticket={ticket}&giftkey={cdk}&gameid={gameid}&sign={sign}";
		DEFAULT.URL.USERBATCH = "http://m.payment.hiigame.com/new/gateway/user/batch?uids={uids}"
		DEFAULT.URL.NAMECHANGE = "http://m.statics.hiigame.com/get/modify/count.do"
		DEFAULT.URL.NAMECOMMIT = "http://m.payment.hiigame.com:18000/user/detail/upt"
		DEFAULT.URL.NEWTASK = "http://m.payment.hiigame.com:18000/task/novice/list?pid={pid}&ticket={ticket}"
		DEFAULT.URL.NEWTASKAWARD = "http://m.payment.hiigame.com:18000/task/draw/award?pid={pid}&ticket={ticket}&taskid={taskid}"
		DEFAULT.URL.GOLDEXC_RECHCARD_TYPE = "http://m.payment.hiigame.com:18000/new/gateway/vou/goods/types?pn={packageName}"
		DEFAULT.URL.GOLDEXC_RECHCARD_LIST = "http://m.payment.hiigame.com:18000/new/gateway/vou/goods/list?type={type}"
		DEFAULT.URL.GOLDEXC_EXCGIFT = "http://m.payment.hiigame.com:18000/new/gateway/vou/goods/newcharge?gid={gid}&pid={pid}&ticket={ticket}&pn={packageName}&gameid={gameid}&name=123&address=123&phone=123&code=123"
		DEFAULT.URL.GOLDEXC_EXCRECORD = "http://m.payment.hiigame.com:18000/query/pay/order/list?pid={pid}&ticket={ticket}&pn={packageName}&type={type}"
		DEFAULT.URL.MINIGAME_CONFIG = "http://m.statics.hiigame.com/get/smallgame/showlist";
		DEFAULT.URL.MAINGAME_VERSION_CTL = "http://m.statics.hiigame.com/get/game/config";
		DEFAULT.URL.DAYTASK = "http://m.statics.hiigame.com/load/panel/image.do"
		DEFAULT.URL.CHONGZHIJIANGLI_INIT = "http://m.statics.hiigame.com/load/pay/award.do?pn={packageName}&uid={pid}&rm=0"
		DEFAULT.URL.CHONGZHIJIANGLI_AWARD = "http://m.statics.hiigame.com/get/pay/award.do?pn={packageName}&uid={pid}&awardid={awardid}&money={money}&gameid={gameid}";
		DEFAULT.URL.HUODONG = "http://activity.izhangxin.com/load/activity/list?uid={uid}&gameid={gameid}&sign={sign}";
		DEFAULT.URL.ISHUODONG = "http://igame.b0.upaiyun.com/readme/aaaa.htm"
		DEFAULT.URL.GETPROMOTE = "http://m.statics.hiigame.com/get/promotion/code";
		DEFAULT.URL.PROMOTEBINDING = "http://m.statics.hiigame.com/bind/promotion/code.do";
		DEFAULT.URL.GETPROMOTEPARTNER = "http://m.statics.hiigame.com/get/bound/friend/info.do";
		DEFAULT.URL.GETPROMOTERECORD = "http://m.statics.hiigame.com/get/promotion/record";
		DEFAULT.URL.GETPROMOTEAWARD = "http://m.statics.hiigame.com/get/promotion/award";
		DEFAULT.URL.IFBINDING = "http://m.statics.hiigame.com/is/promotion/bind";
		DEFAULT.URL.GETALLHEADIMAGE = "http://m.statics.hiigame.com/get/face/all"
		DEFAULT.URL.SETALLHEADIMAGE = "http://m.statics.hiigame.com/get/face/url"

		DEFAULT.URL.SAFTGETPWD ="http://m.statics.hiigame.com/get/casino/safepassword?pid={pid}&phoneno={phoneno}&ticket={ticket}&signMsg={signMsg}"

		DEFAULT.URL.XIAOFEIXIANE = "http://m.statics.hiigame.com/get/consumelimit/tips"
		DEFAULT.URL.GETFUNCTIONSTATUS = "http://m.statics.hiigame.com/get/online/param?paramname={pName}"
		DEFAULT.URL.DoubleChest = "http://m.statics.hiigame.com/get/first/pay/box"
		DEFAULT.URL.TOTALUPDATE = "http://m.statics.hiigame.com/version/update"
		DEFAULT.URL.APP_UPDATE_INIT_ALL = "http://m.statics.hiigame.com/get/loading/params"
		DEFAULT.URL.GET_ITEM_LIST = "http://m.statics.hiigame.com/get/goods/list?pn={pn}&gameid={gameid}&index={index}";
		DEFAULT.URL.EXCHANGE_ITEM = "http://m.statics.hiigame.com/vou/goods/charge?pn={pn}&gameid={gameid}&gid={gid}&uid={uid}&ticket={ticket}";
		DEFAULT.URL.GET_ITEM_EXCHANGE_RECORD_LIST = "http://m.statics.hiigame.com/get/charge/list?pn={pn}&uid={uid}&ticket={ticket}";
		DEFAULT.URL.GETEVALUATE = "http://m.payment.hiigame.com:18000/new/gateway/evaluate?pid={pid}&ticket={ticket}&mac={mac}&pn={packageName}";
		DEFAULT.URL.MATCHINFODATA = "http://m.statics.hiigame.com/get/match/player"
		DEFAULT.URL.MATCHRANKINFO = "http://m.statics.hiigame.com/get/round/rank/info"
		DEFAULT.URL.MATCHGETAWARDE = "http://m.statics.hiigame.com/get/player/bonus"
		DEFAULT.URL.AWARDEVALUATE = "http://m.payment.hiigame.com:18000/new/gateway/eva/gm?pid={pid}&order={order}";

	else
		DEFAULT.URL.Feedback = "http://login.tencent.izhangxin.com/new/gateway/feedback";
		DEFAULT.URL.FeedbackList = "http://login.tencent.izhangxin.com/new/gateway/feedback/list";
		DEFAULT.URL.GONGGAO = "http://login.tencent.izhangxin.com/new/gateway/game/tips?gameid={gameid}&pn={packageName}&count=5&pid={pid}&pagenow=4&pagesize=1&gametype=0";
		DEFAULT.URL.CHECK_PACAKGE_VERSION = "http://127.0.0.1/DDZ/{moduleName}Version";
		DEFAULT.URL.SHOPITEMS = "http://mall.tencent.izhangxin.com/shop/box/list"
		DEFAULT.URL.SHOP_HISTORY = "http://mall.tencent.izhangxin.com/vou/order/list?pid={pid}&ticket={ticket}&pn={packageName}";
		-- DEFAULT.URL.CDKAWARD = "http://statics.tencent.izhangxin.com/gift/key/activation?uid={pid}&giftkey={cdk}&gameid={gameid}&sign={sign}";
		DEFAULT.URL.CDKAWARD = "http://statics.tencent.izhangxin.com/gift/key/activation?uid={pid}&ticket={ticket}&giftkey={cdk}&gameid={gameid}&sign={sign}";
		DEFAULT.URL.USERBATCH = "http://login.tencent.izhangxin.com/new/gateway/user/batch?uids={uids}"
		DEFAULT.URL.NAMECHANGE = "http://statics.tencent.izhangxin.com/get/modify/count.do"
		DEFAULT.URL.NAMECOMMIT = "http://login.tencent.izhangxin.com/user/detail/upt"
		DEFAULT.URL.NEWTASK = "http://login.tencent.izhangxin.com/task/novice/list?pid={pid}&ticket={ticket}"
		DEFAULT.URL.NEWTASKAWARD = "http://login.tencent.izhangxin.com/task/draw/award?pid={pid}&ticket={ticket}&taskid={taskid}"
		DEFAULT.URL.GOLDEXC_RECHCARD_TYPE = "http://login.tencent.izhangxin.com/new/gateway/vou/goods/types?pn={packageName}"
		DEFAULT.URL.GOLDEXC_RECHCARD_LIST = "http://login.tencent.izhangxin.com/new/gateway/vou/goods/list?type={type}"
		DEFAULT.URL.GOLDEXC_EXCGIFT = "http://login.tencent.izhangxin.com/new/gateway/vou/goods/newcharge?gid={gid}&pid={pid}&ticket={ticket}&pn={packageName}&gameid={gameid}&name=123&address=123&phone=123&code=123"
		DEFAULT.URL.GOLDEXC_EXCRECORD = "http://login.tencent.izhangxin.com/query/pay/order/list?pid={pid}&ticket={ticket}&pn={packageName}&type={type}"
		DEFAULT.URL.DAYTASK = "http://statics.tencent.izhangxin.com/load/panel/image.do"	
		DEFAULT.URL.MINIGAME_CONFIG = "http://statics.tencent.izhangxin.com/get/smallgame/showlist";
		DEFAULT.URL.MAINGAME_VERSION_CTL = "http://statics.tencent.izhangxin.com/get/game/config";

		DEFAULT.URL.CHONGZHIJIANGLI_INIT = "http://statics.tencent.izhangxin.com/load/pay/award.do?pn={packageName}&uid={pid}&rm=0"
		DEFAULT.URL.CHONGZHIJIANGLI_AWARD = "http://statics.tencent.izhangxin.com/get/pay/award.do?pn={packageName}&uid={pid}&awardid={awardid}&money={money}&gameid={gameid}"
		DEFAULT.URL.HUODONG = "http://activity.izhangxin.com/load/activity/list?uid={uid}&gameid={gameid}&sign={sign}";
		DEFAULT.URL.ISHUODONG = "http://igame.b0.upaiyun.com/readme/aaaa.htm"
		DEFAULT.URL.GETPROMOTE = "http://statics.tencent.izhangxin.com/get/promotion/code";
		DEFAULT.URL.PROMOTEBINDING = "http://statics.tencent.izhangxin.com/bind/promotion/code.do";
		DEFAULT.URL.GETPROMOTEPARTNER = "http://statics.tencent.izhangxin.com/get/bound/friend/info.do";
		DEFAULT.URL.GETPROMOTERECORD = "http://statics.tencent.izhangxin.com/get/promotion/record";
		DEFAULT.URL.GETPROMOTEAWARD = "http://statics.tencent.izhangxin.com/get/promotion/award";
		DEFAULT.URL.IFBINDING = "http://statics.tencent.izhangxin.com/is/promotion/bind";
		DEFAULT.URL.GETALLHEADIMAGE = "http://statics.tencent.izhangxin.com/get/face/all"
		DEFAULT.URL.SETALLHEADIMAGE = "http://statics.tencent.izhangxin.com/get/face/url"

		DEFAULT.URL.SAFTGETPWD ="http://statics.tencent.izhangxin.com/get/casino/safepassword?pid={pid}&phoneno={phoneno}&ticket={ticket}&signMsg={signMsg}"

		DEFAULT.URL.XIAOFEIXIANE = "http://statics.tencent.izhangxin.com/get/consumelimit/tips"
		DEFAULT.URL.GETFUNCTIONSTATUS = "http://statics.tencent.izhangxin.com/get/online/param?paramname={pName}"
		DEFAULT.URL.DoubleChest = "http://statics.tencent.izhangxin.com/get/first/pay/box"
		DEFAULT.URL.TOTALUPDATE = "http://statics.tencent.izhangxin.com/version/update"
		DEFAULT.URL.APP_UPDATE_INIT_ALL = "http://statics.tencent.izhangxin.com/get/loading/params"
		DEFAULT.URL.GET_ITEM_LIST = "http://statics.tencent.izhangxin.com/get/goods/list?pn={pn}&gameid={gameid}&index={index}";
		DEFAULT.URL.EXCHANGE_ITEM = "http://statics.tencent.izhangxin.com/vou/goods/charge?pn={pn}&gameid={gameid}&gid={gid}&uid={uid}&ticket={ticket}";
		DEFAULT.URL.GET_ITEM_EXCHANGE_RECORD_LIST = "http://statics.tencent.izhangxin.com/get/charge/list?pn={pn}&uid={uid}&ticket={ticket}";
		DEFAULT.URL.GETEVALUATE = "http://login.tencent.izhangxin.com/new/gateway/evaluate?pid={pid}&ticket={ticket}&mac={mac}&pn={packageName}";
		DEFAULT.URL.MATCHINFODATA = "http://statics.tencent.izhangxin.com/get/match/player"
		DEFAULT.URL.MATCHRANKINFO = "http://statics.tencent.izhangxin.com/get/round/rank/info"
		DEFAULT.URL.MATCHGETAWARDE = "http://statics.tencent.izhangxin.com/get/player/bonus"
		DEFAULT.URL.AWARDEVALUATE = "http://login.tencent.izhangxin.com/new/gateway/eva/gm?pid={pid}&order={order}";

	end
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
