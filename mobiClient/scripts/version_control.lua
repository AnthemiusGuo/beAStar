--
-- Author: Guo Jia
-- Date: 2014-03-04 12:04:42
--

PRE_INSTALLED_VERSION = {
	images = "7e4d382edfc54ea80f7d7bb6480db7fc",
	interfaces = "536e7b4e780950dc766cf3615c6bf33b",
	sounds = "20ef64c97fa95bd7c3243dff09bd0638",
	interfacesGame = "86d44336ecdd6e403a9638537fdcce26",
	imagesGame = "edc43855eaf8ab64b9e5761342361e11",
	script = "5c9f2059fa3e49db88696c49cbfdf363",
	-- soundsGame = "24ba9200da1385b12eb3525095e88623"
}

-- 20ef64c97fa95bd7c3243dff09bd0638  /data/Codes/ddz_lua/proj.android/../proj.web_upgrade//moduleDdz/moduleDdz_base_snd.zip
-- 24ba9200da1385b12eb3525095e88623  /data/Codes/ddz_lua/proj.android/../proj.web_upgrade//moduleDdz/moduleDdz_game_snd.zip
-- 536e7b4e780950dc766cf3615c6bf33b  /data/Codes/ddz_lua/proj.android/../proj.web_upgrade//moduleDdz/moduleDdz_base_if.zip
-- 86d44336ecdd6e403a9638537fdcce26  /data/Codes/ddz_lua/proj.android/../proj.web_upgrade//moduleDdz/moduleDdz_game_if.zip
-- 7e4d382edfc54ea80f7d7bb6480db7fc  /data/Codes/ddz_lua/proj.android/../proj.web_upgrade//moduleDdz/moduleDdz_base_img.zip
-- edc43855eaf8ab64b9e5761342361e11  /data/Codes/ddz_lua/proj.android/../proj.web_upgrade//moduleDdz/moduleDdz_game_img.zip
-- 92f0a1d9f204b8226167eb4421d6d2c6  /data/Codes/ddz_lua/proj.android/../proj.web_upgrade//moduleDdz/moduleDdz_script.zip

   

function preLoadMiniGame()
	if (device.platform=="ios") then
		PRE_INSTALLED_MINIGAME = {
			[100] = 
				{
					version = "1.0.1.4",	
					code = "preinstalled",
					resDir = "res/moduleLabaRes"	
				},
			[101] = 
				{
					version = "1.0.1.9",	
					code = "preinstalled",
					resDir = "res/moduleYaoRes"	
				},
			[102] = 
				{
					version = "1.0.1.1",	
					code = "preinstalled",
					resDir = "res/moduleCaiQuanRes"	
				},
			[103] = 
				{
					version = "1.0.0.13",	
					code = "preinstalled",
					resDir = "res/moduleBlackJackRes"			
				},
			[104] = 
				{
					version = "1.0.0.7",	
					code = "preinstalled",
					resDir = "res/moduleDeZhouRes"			
				},
			[105] = 
				{
					version = "1.0.0.3",	
					code = "preinstalled",
					resDir = "res/moduleFruitRes"			
				},
		}
	end
end
