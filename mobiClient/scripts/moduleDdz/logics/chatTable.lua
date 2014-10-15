phrasetable = phrasetable or {};
facetable = facetable or {}
paytable = paytable or {};
anipaytable = anipaytable or {};
phrasetable = {
	[1]="大家好，很高兴见到各位",                 --name="chat_0">
	[2]="能交个朋友吗，能告诉怎么联系吗",         --name="chat_1">
	[3]="你的牌打得忒好了呀",                     --name="chat_2">
	[4]="和你合作真是太愉快了",                   --name="chat_3">
	[5]="不管是小牌还是杂牌，到了我手里都是好牌", --name="chat_4">
	[6]="别想了，快把牌拆了，随便出一张吧",       --name="chat_5">
	[7]="喂，快点出呀，别总是磨磨蹭蹭",           --name="chat_6">
	[8]="我的天哪，我一张牌也没出，不会吧",       --name="chat_7">
	[9]="有没有搞错，这牌也太烂了吧",             --name="chat_8">
	[10]="哎，怎么会是这样啊",                     --name="chat_9">
}
 
facetable = {
	"a1_1_win.png",
	"a1_2_xiao.png",
	"a1_3_ku.png",
	"a1_4_bisheng.png",
	"a1_5_ai.png",
	"a1_6_tiaoxin.png",
	"a1_7_chifan.png",
	"a1_8_bishi.png",
	"a1_9_waiting.png",
	"a1_10_zhuangkuang.png",
	"a1_11_yun.png",
	"a1_12_ice.png",
	"a1_13_guzhang.png",
	"a1_14_han.png",
	"a1_15_fa.png",
	"a1_16_shuai.png",
	"a1_17_dahan.png",
	"a1_18_fire.png",
}
paytable={
	"ani_pay_1_0.png",
	"ani_pay_2_0.png",
	"ani_pay_3_0.png",
	"ani_pay_4_0.png",
	"ani_pay_5_0.png",
	"ani_pay_6_0.png",
}

anipaytable= {
	["ani_pay_1"] = {
						["fileType"]=".png",
						["index"]=0,
						["nTotal"]=9,
						--["sRect"] = CCRectMake(0,0,0,0),
						["nDuration"]=100,
					},
	["ani_pay_2"] = {
						["fileType"]=".png",
						["index"]=0,
						["nTotal"]=8,
						--["sRect"] = CCRectMake(0,0,0,0),
						["nDuration"]=100,
					},
	["ani_pay_3"] = {
						["fileType"]=".png",
						["index"]=0,
						["nTotal"]=3,
						--["sRect"] = CCRectMake(0,0,0,0),
						["nDuration"]=100,
					},
	["ani_pay_4"] = {
						["fileType"]=".png",
						["index"]=0,
						["nTotal"]=5,
						--["sRect"] = CCRectMake(0,0,0,0),
						["nDuration"]=100,
					},
	["ani_pay_5"] = {
						["fileType"]=".png",
						["index"]=0,
						["nTotal"]=4,
						--["sRect"] = CCRectMake(0,0,0,0),
						["nDuration"]=100,
					},
	["ani_pay_6"] = {
						["fileType"]=".png",
						["index"]=0,
						["nTotal"]=3,
						--["sRect"] = CCRectMake(0,0,0,0),
						["nDuration"]=100,
					},
}