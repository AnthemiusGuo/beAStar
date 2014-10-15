--
-- Author: Guo Jia
-- Date: 2014-03-13 11:26:59
--
local distribution_default = {
	yidong_sms=false,
	dianxin_sms=false,
	liantong_sms=false,
	quickpay=false,
	quickpay_tips=true,
	replace_text="",
	share=false,
	thirdplatformexitpage=false,
	thirdplatformquickpay=false,
	usercenter=false,
	visitlogin=false,
	toolbar=false,
	showloginchoose=true,
	switchuser=true,
	showloginfaildialog=true,
	logoutwhenlogin=false,
	showjihuomatips=true,
	banedpay=false,
	usetestenv=false,
	skipupgrade=false,
	logoutwhenswitch=true,
	iosenv=false,
	gamename="掌心斗地主",
	promotionaddress="http://www.izhangxin.com",
	channel="",--91豆,"",
	searchpath="",--anzhi/
	sessionType="",--SessionAnzhi
	yaoyaoleneedmoney="80000",

	trumpet_fliter_words="麻将|炸金花|赢三张",
	--以下兼容在线参数
	nominigame=false,
	nojihuoma=false,
	novip=false,
	nopromotion=false,
	noexitgame=false,
	nominigamedownload=false,
	nogonggao=false,
	nosafe=false,
	noguidhelp=false,
	noevaluate=false,
	forceuseDirectSMS = false,
	
	noactivity=false,
	checkapple=false,
	hasnewminegame = false,


	logoloading="thirdparty/login_logo.png",
	logodenglu="thirdparty/login_logo.png",
	logodating="thirdparty/lobby_pic_logo.png",
	mopudonghua=false,
	useydmm=false,
	sdkUpgradeDelay=false,
	removeLogin=false,
	jumpToExtend = false,--更多游戏
	showPingCoo = false,--奖励宝
	noLuaVersionName = false,
	refreshConfig = false,-- 炸金华用的，其他游戏没用，

	jihuomaMsg = "", --激活码来源提示语句
	showVersionMsg = "",--強制指定显示版本号 如：3.0.7

	skipbuyitem = false,
	startdata = false,

};

return distribution_default;