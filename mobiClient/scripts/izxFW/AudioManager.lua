require("config")
require("framework.init")
require("framework.shortcodes")

local AudioManager = class("AudioManager");
local GAME_EFFECT_VALUE = "game_effect_value";
local GAME_AUDIO_VALUE = "game_audio_value";
-- local _configOpenBGM;
-- local _configOpenSound;
function AudioManager:ctor()
    self.isBGMOpen = true;
	self.isSoundOpen = true;

  	self.fEffectVal = CCUserDefault:sharedUserDefault():getFloatForKey(GAME_EFFECT_VALUE,1.0);
	self.fMusicVal = CCUserDefault:sharedUserDefault():getFloatForKey(GAME_AUDIO_VALUE,1.0);
	self._audio = require("framework.audio");
	self.playbackHandle = {};
	self.audioHasLoad = {};
end

function AudioManager:init()
	if (CONFIG_USE_SOUND~=true) then
		return
	end
	--加载声音文件
	print("=====================AudioManager:init")
	self._audio.setEffectsVolume(self.fEffectVal);
	self._audio.setBackgroundMusicVolume(self.fMusicVal);
	self.audiotable = audio_sounds_table
	if (self.audiotable) then
		-- if self.audiotable.music ~= nil then
		-- 	local musictable = {}
		-- 	for k,v in pairs(self.audiotable.music) do
		-- 		if self.audioHasLoad[k]==nil then
		-- 			self.audioHasLoad[k] = 1
		-- 			self._audio.preloadMusic(v)
		-- 		end			
		-- 	end
		-- end
		-- if self.audiotable.sound ~= nil then
		-- 	for k,v in pairs(self.audiotable.sound) do 
		-- 		if self.audioHasLoad[k]==nil then
		-- 			self.audioHasLoad[k] = 1
		-- 			self._audio.preloadEffect(v);
		-- 		end 
		-- 	end
		-- end
	end
end

function AudioManager:SetEffectValue(value)
	self.fEffectVal = value;
	CCUserDefault:sharedUserDefault():setFloatForKey(GAME_EFFECT_VALUE,value);
	CCUserDefault:sharedUserDefault():flush();
	self._audio.setEffectsVolume(value);
	if (value<0.1) then
		self.isSoundOpen = false;
	end
end

function AudioManager:SetAudioValue(value)
	if value == 0.0 then
		self._audio.pauseMusic()
	elseif self.fMusicVal == 0.0 then
		self._audio.resumeMusic()
	end
	self.fMusicVal = value;
	CCUserDefault:sharedUserDefault():setFloatForKey(GAME_AUDIO_VALUE,value);
	self._audio.setBackgroundMusicVolume(value);
	CCUserDefault:sharedUserDefault():flush();
	if (value<0.1) then
		self.isBMGOpen = false;
	end
end

function AudioManager:playSound(sName,isLoop)
	if (CONFIG_USE_SOUND~=true) then
		return
	end
	if (self.isSoundOpen ==false) then
		return
	end
	-- if (gBaseLogic.isInBackground) then
	-- 	return
	-- end
	local path = self.audiotable.sound[sName];
	if path ~= nil then
		local realPath = CCFileUtils:sharedFileUtils():fullPathForFilename(path);
		if (realPath==nil or io.exists(realPath)==false) then
			return 0;
		end

		if isLoop then
			isLoop = true;
		else
			isLoop = false;
		end
		if (isLoop) then


			self.playbackHandle[sName] = self._audio.playSound(path,isLoop);
			return self.playbackHandle[sName];
		else 
			return self._audio.playSound(path,isLoop);
		end
	end
    return -1
end

function AudioManager:stopLoop(sName)
	print("WIll stop sound effect for:"..sName)
	if (self.playbackHandle[sName]) then
		print("the sound handler for "..sName)
		var_dump(self.playbackHandle[sName]);
		for i=1,20 do
			self._audio.stopSound(self.playbackHandle[sName]);
		end
	end
end

function AudioManager:stopAllSounds()
	for i=1,20 do
		self._audio.stopAllSounds();
	end
end

function AudioManager:playMusic(sName, bLoop)
	if (CONFIG_USE_SOUND~=true) then
		return
	end
	if (self.isBMGOpen == false) then
		return
	end
	local path = self.audiotable.music[sName]
	if path ~= nil then 
		self._audio.playBackgroundMusic(path, bLoop);
	end
end

function AudioManager:stopMusic()
	for i=1,10 do
		self._audio.stopBackgroundMusic();
	end
end

return AudioManager