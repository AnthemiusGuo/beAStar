local AudioCtrller = class("AudioCtrller")

function AudioCtrller:ctor()
	self.SoundBack = nil;
  	izx.baseAudio.fEffectVal = CCUserDefault:sharedUserDefault():getFloatForKey("game_effect_value",1.0);
	izx.baseAudio.fMusicVal = CCUserDefault:sharedUserDefault():getFloatForKey("game_audio_value",1.0);
	izx.baseAudio._audio.setEffectsVolume(izx.baseAudio.fEffectVal);
	izx.baseAudio._audio.setBackgroundMusicVolume(izx.baseAudio.fMusicVal);
end

function AudioCtrller:PlayAudio(num)
	if izx.baseAudio.fEffectVal == 0.0 then
		return;
	end
	if num == 10 then --AUDIO_BOMB
		izx.baseAudio:playSound("audio_bomb");
	elseif num == 11 then --AUDIO_CLOCK
		izx.baseAudio:playSound("audio_clock");
	elseif num == 13 then --AUDIO_LOSE:
		izx.baseAudio:playSound("audio_lose");
	elseif num == 12 then --AUDIO_DROP_CARD:
		izx.baseAudio:playSound("audio_dropcard");
	elseif num == 14 then --AUDIO_MENU:
		izx.baseAudio:playSound("audio_menu");
	elseif num == 15 then --AUDIO_PLANE:
		izx.baseAudio:playSound("audio_plane");
	elseif num == 17 then --AUDIO_DANSHUN:
		izx.baseAudio:playSound("audio_shunzi");
	elseif num == 16 then --AUDIO_PUT_CARD:
		izx.baseAudio:playSound("audio_putcard");
	elseif num == 18 then --AUDIO_RELIEVES:
		izx.baseAudio:playSound("audio_relieves");
	elseif num == 19 then --AUDIO_ROCKET:
		izx.baseAudio:playSound("audio_rocket");
	elseif num == 20 then --AUDIO_SEND_CARD:
		izx.baseAudio:playSound("audio_sendcard");
	elseif num == 21 then --AUDIO_START:
		izx.baseAudio:playSound("audio_start");
	elseif num == 22 then --AUDIO_WIN:
		izx.baseAudio:playSound("audio_win");
	elseif num == 25 then --AUDIO_PASS:
		izx.baseAudio:playSound("audio_pass");
	elseif num == 24 then --AUDIO_CALL_NO_LORD:
		izx.baseAudio:playSound("audio_score0");
	elseif num == 23 then --AUDIO_CALL_LORD:
		izx.baseAudio:playSound("audio_call_lord");
	elseif num == 26 then --AUDIO_SCORE0:
		izx.baseAudio:playSound("audio_score0");
	elseif num == 27 then --AUDIO_SCORE1:
		izx.baseAudio:playSound("audio_score1");
	elseif num == 28 then --AUDIO_SCORE2:
		izx.baseAudio:playSound("audio_score2");
	elseif num == 29 then --AUDIO_SCORE3:
		izx.baseAudio:playSound("audio_score3");
	elseif num == 30 then --AUDIO_SHOW:
		izx.baseAudio:playSound("audio_show");
	elseif num == 31 then --AUDIO_ROB:
		izx.baseAudio:playSound("audio_rob");
	elseif num == 32 then --AUDIO_NO_ROB:
		izx.baseAudio:playSound("audio_no_rob");
	elseif num == 33 then --AUDIO_DUIDUISHUN:
		izx.baseAudio:playSound("audio_duiduishun");
	elseif num == 35 then --AUDIO_SHUNZI:
		izx.baseAudio:playSound("audio_danshun");
	elseif num == 34 then --AUDIO_FEIJI:
		izx.baseAudio:playSound("audio_feiji");
	elseif num == 9 then --AUDIO_CHAT_9:
		izx.baseAudio:playSound("audio_chat_9");
	elseif num == 8 then --AUDIO_CHAT_8:
		izx.baseAudio:playSound("audio_chat_8");
	elseif num == 7 then --AUDIO_CHAT_7:
		izx.baseAudio:playSound("audio_chat_7");
	elseif num == 6 then --AUDIO_CHAT_6:
		izx.baseAudio:playSound("audio_chat_6");
	elseif num == 5 then --AUDIO_CHAT_5:
		izx.baseAudio:playSound("audio_chat_5");
	elseif num == 4 then --AUDIO_CHAT_4:
		izx.baseAudio:playSound("audio_chat_4");
	elseif num == 3 then --AUDIO_CHAT_3:
		izx.baseAudio:playSound("audio_chat_3");
	elseif num == 2 then --AUDIO_CHAT_2:
		izx.baseAudio:playSound("audio_chat_2");
	elseif num == 1 then --AUDIO_CHAT_1:
		izx.baseAudio:playSound("audio_chat_1");
	elseif num == 0 then --AUDIO_CHAT_0:
		izx.baseAudio:playSound("audio_chat_0");
	elseif num == 36 then --AUDIO_LABA_BTN: --slotmachine start
		izx.baseAudio:playSound("laba_btn");
	elseif num == 37 then --AUDIO_LABA_SCROLL:
		self.SoundBack = izx.baseAudio:playSound("laba_scroll",true);
	elseif num == 38 then --AUDIO_LABA_WIN:
		izx.baseAudio:playSound("laba_win");
	elseif num == 39 then --AUDIO_LABA_MONEY_BTN:
		izx.baseAudio:playSound("laba_money_btn");
	elseif num == 40 then --AUDIO_LABA_DROP_COIN:
		izx.baseAudio:playSound("laba_drop");
	elseif num == 41 then --AUDIO_LABA_LOSE: --拉霸输
		izx.baseAudio:playSound("letou_lost");
		--slotmachine end
	elseif num == 42 then --AUDIO_CARDALARM: --警报
		izx.baseAudio:playSound("audio_alarm");
	end
end

function AudioCtrller:PlayAudioType(cardtype)
	if izx.baseAudio.fEffectVal == 0.0 then
		return;
	end
	if (cardtype.m_nTypeNum == 1) then
		if cardtype.m_nTypeValue == 3 then
			izx.baseAudio:playSound("audio_3");
		elseif cardtype.m_nTypeValue == 4 then
			izx.baseAudio:playSound("audio_4");
		elseif cardtype.m_nTypeValue == 5 then
			izx.baseAudio:playSound("audio_5");
		elseif cardtype.m_nTypeValue == 6 then
			izx.baseAudio:playSound("audio_6");
		elseif cardtype.m_nTypeValue == 7 then
			izx.baseAudio:playSound("audio_7");
		elseif cardtype.m_nTypeValue == 8 then
			izx.baseAudio:playSound("audio_8");
		elseif cardtype.m_nTypeValue == 9 then
			izx.baseAudio:playSound("audio_9");
		elseif cardtype.m_nTypeValue == 10 then
			izx.baseAudio:playSound("audio_10");
		elseif cardtype.m_nTypeValue == 11 then
			izx.baseAudio:playSound("audio_11");
		elseif cardtype.m_nTypeValue == 12 then
			izx.baseAudio:playSound("audio_12");
		elseif cardtype.m_nTypeValue == 13 then
			izx.baseAudio:playSound("audio_13");
		elseif cardtype.m_nTypeValue == 14 then
			izx.baseAudio:playSound("audio_14");	
		elseif cardtype.m_nTypeValue == 15 then
			izx.baseAudio:playSound("audio_15");
		elseif cardtype.m_nTypeValue == 16 then
			izx.baseAudio:playSound("audio_16");
		elseif cardtype.m_nTypeValue == 17 then
			izx.baseAudio:playSound("audio_17");
		end
	elseif (cardtype.m_nTypeNum == 2) then
		if cardtype.m_nTypeValue == 3 then
			izx.baseAudio:playSound("audio_2_3");
		elseif cardtype.m_nTypeValue == 4 then
			izx.baseAudio:playSound("audio_2_4");
		elseif cardtype.m_nTypeValue == 5 then
			izx.baseAudio:playSound("audio_2_5");
		elseif cardtype.m_nTypeValue == 6 then
			izx.baseAudio:playSound("audio_2_6");
		elseif cardtype.m_nTypeValue == 7 then
			izx.baseAudio:playSound("audio_2_7");
		elseif cardtype.m_nTypeValue == 8 then
			izx.baseAudio:playSound("audio_2_8");
		elseif cardtype.m_nTypeValue == 9 then
			izx.baseAudio:playSound("audio_2_9");
		elseif cardtype.m_nTypeValue == 10 then
			izx.baseAudio:playSound("audio_2_10");
		elseif cardtype.m_nTypeValue == 11 then
			izx.baseAudio:playSound("audio_2_11");
		elseif cardtype.m_nTypeValue == 12 then
			izx.baseAudio:playSound("audio_2_12");
		elseif cardtype.m_nTypeValue == 13 then
			izx.baseAudio:playSound("audio_2_13");
		elseif cardtype.m_nTypeValue == 14 then
			izx.baseAudio:playSound("audio_2_14");
		elseif cardtype.m_nTypeValue == 15 then
			izx.baseAudio:playSound("audio_2_15");
		end
	elseif (cardtype.m_nTypeNum == 3) then
		izx.baseAudio:playSound("audio_3_0");
	elseif (cardtype.m_nTypeNum == 31) then
		izx.baseAudio:playSound("audio_3_1");
	elseif (cardtype.m_nTypeNum == 4) then
		self:PlayBomb();
		izx.baseAudio:playSound("audio_bomb_0");
	elseif (cardtype.m_nTypeNum == 5) then
		self:PlayDanShun();
	elseif (cardtype.m_nTypeNum == 32) then
		izx.baseAudio:playSound("audio_3_2");
	elseif (cardtype.m_nTypeNum >= 6 and cardtype.m_nTypeNum <= 13) then
		self:PlayDanShun();
	elseif (cardtype.m_nTypeNum == 411 or cardtype.m_nTypeNum == 422) then
		izx.baseAudio:playSound("audio_4_2");
	elseif (cardtype.m_nTypeNum == 33 or cardtype.m_nTypeNum == 333 or cardtype.m_nTypeNum == 3333 or cardtype.m_nTypeNum == 33333 or cardtype.m_nTypeNum == 333333 or cardtype.m_nTypeNum == 33332222 or cardtype.m_nTypeNum == 333222 or cardtype.m_nTypeNum == 3322 or cardtype.m_nTypeNum == 3311) then
		self:PlaySanShun();
	end
end

function AudioCtrller:StopBackground()
	izx.baseAudio:stopMusic()
end

function AudioCtrller:PlayBackground()
	if gBaseLogic.gameLogic.gamePage ~= nil then
		if izx.baseAudio.fMusicVal == 0.0 then
			return;
	    end
		izx.baseAudio:playMusic("bg_music",true);
	end
end
function AudioCtrller:PlayBackground2()
	if gBaseLogic.gameLogic.gamePage ~= nil then
		if izx.baseAudio.fMusicVal == 0.0 then
			return;
	    end
		izx.baseAudio:playMusic("bg_music2",true);
	end
end

function AudioCtrller:PlayDanShun()
	if izx.baseAudio.fEffectVal == 0.0 then
		return;
	end
	izx.baseAudio:playSound("audio_danshun");
end

function AudioCtrller:PlaySanShun()
	if izx.baseAudio.fEffectVal == 0.0 then
		return;
	end
	izx.baseAudio:playSound("audio_plane_0");
end

function AudioCtrller:PlayBomb()
	if izx.baseAudio.fEffectVal == 0.0 then
		return;
	end
	izx.baseAudio:playSound("audio_bomb");
end
function AudioCtrller:PlayAudioStop()
	if self.SoundBack ~= nil then
		izx.baseAudio._audio.stopSound(self.SoundBack);
	end
end

return AudioCtrller;