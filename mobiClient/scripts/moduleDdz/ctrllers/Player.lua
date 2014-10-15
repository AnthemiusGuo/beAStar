local Player = class("Player")

function Player:ctor(gamescene)
  self.gamescene = gamescene;
  self.alarm_num = 0;
  self.data = {
    DIR_ME = 0,
	DIR_RIGHT = 1,
	DIR_LEFT = 2,

	CHAT_TYPE_ANI = 3,			--聊天动画			
	CHAT_TYPE_TXT = 4,			--聊天预置语句
	CHAT_TYPE_INPUT = 5,		--聊天输入文字
	CHAT_TYPE_PAY_ANI = 6,

	ANI_FIRE = 0,				--发火
	ANI_WIN = 1,				--胜利
	ANI_XIAO = 2,				--大笑
	ANI_KU = 3,					--哭
	ANI_BISHENG = 4,			--必胜
	ANI_AI = 5,					--爱心
	ANI_TIAOXIN = 6,			--挑衅
	ANI_CHIFAN = 7,				--吃饭
	ANI_BISHI = 8,				--鄙视
	ANI_WAITING = 9,			--等待
	ANI_ZHUAKUANG = 10,			--抓狂
	ANI_YUN = 11,				--晕
	ANI_ICE = 12,				--冻住
	ANI_GUZHANG = 13,			--鼓掌
	ANI_HAN = 14,				--汗
	ANI_FA = 15,				--发钱
	ANI_SHUAI = 16,				--衰
	ANI_DAHAN = 17,				--大汉
	ANI_MAX_FREE = 18,			--免费表情
	ANI_PAY_CAT_0 = 19,			--收费表情-富可敌国
	ANI_PAY_CAT_1 = 20,			--收费表情-财大气租
	ANI_PAY_CAT_2 = 21,			--收费表情-春风得意
	ANI_PAY_CAT_3 = 22,			--收费表情-天下无敌
	ANI_PAY_CAT_4 = 23,			--收费表情-佛光普照
	ANI_MAX_PAY = 24,

	ANI_FEIJI = 25,				--飞机
	ANI_ZHADAN = 26,			--炸弹
	ANI_SHUNZI = 27,			--顺子
	ANI_HUOJIAN = 28,			--火箭
	ANI_LIANDUI = 29,			--连队
  };
  self.headimage_ = ""
  self.cards_ = require("moduleDdz.ctrllers.PlayCard").new();
  self.player_attr_ ={}
end

function Player:Init(nDir)  --初始化
	self.ndir_ = nDir;
	self.is_play_ani_ = false;
end

function Player:InitTip()
	
end

function Player:onEnterTransitionDidFinish()
	self.Clock:setVisible(false)
	self.is_show_card_ = false;
	self.play_card_ = display.newNode()
	self.gamescene.gameLayer:addChild(self.play_card_,2)

    self.ClockNumber = CCLabelAtlas:create("", "images/YouXi/game_pic_shuzi.png", 20, 27, 48);
    self.ClockNumber:setPosition(ccp(self.Clock:getContentSize().width/2-18,self.Clock:getContentSize().height/2-15))
    self.Clock:addChild(self.ClockNumber)

    local scale = CCDirector:sharedDirector():getWinSize().height/640
    local px, py = self.Clock:getPosition()
    --self.play_card_:setVisible(true);
	--self.is_show_card_ = false;
	if (self.ndir_ == 0) then
		self.play_card_:setPosition(ccp(display.cx,200))
		self.ani_chat_pos_ = ccp(px-200,py)
		self.txt_chat_pos_ = ccp(display.cx,py+80)
	else
		local cardleftnum = CCLabelAtlas:create("", "images/YouXi/game_pic_shuzi2.png", 23, 25, 48);
	    self.cardback:addChild(cardleftnum)
	    cardleftnum:setTag(1)
		if (self.ndir_ == 1) then
			cardleftnum:setPositionX(-60)
			-- self.play_hand_card_ = display.newNode()
			-- self.gamescene.gameLayer:addChild(self.play_hand_card_)
			-- self.play_hand_card_:setPosition(ccp(800,400));
			self.play_card_:setPosition(ccp(px, py));
			self.ani_chat_pos_ = ccp(px-100,py)
			self.txt_chat_pos_ = ccp(display.cx,py)
			-- self.right_left_card_ = display.newNode()
   --          self.right_left_card_:setPosition(ccp(px, py))
   --          self.gamescene.gameLayer:addChild(self.right_left_card_,3)
		elseif (self.ndir_ == 2) then
			cardleftnum:setPositionX(40)
			-- self.play_hand_card_ = display.newNode()
			-- self.gamescene.gameLayer:addChild(self.play_hand_card_)
			-- self.play_hand_card_:setPosition(ccp(200,400));
			self.play_card_:setPosition(ccp(px, py));
			self.ani_chat_pos_ = ccp(px+100,py)
			self.txt_chat_pos_ = ccp(display.cx,py)
			-- self.left_left_card_ = display.newNode()
			-- self.left_left_card_:setPosition(ccp(px, py))
			-- self.gamescene.gameLayer:addChild(self.left_left_card_,3)
		end
	end
	--ClockNumber
end
function Player:ReInitCard() 
	self.Clock:setVisible(false)
	self.alarm_num = 0;

	self.is_show_card_ = false;

	if (self.cardback~=nil) then
		self.cardback:setVisible(false)
	end
	self.meTip:setVisible(false)
	self.play_card_:removeAllChildrenWithCleanup(true);

	self.cards_.m_cCards = {}
	self.cards_.m_nBaoValue = 0;
	if nil ~= self.cardAlarm then
		self.cardAlarm:removeFromParentAndCleanup(true)
		self.cardAlarm =nil
	end 
	self.spriteimg:setVisible(false)
	-- if self.headimage_ == "" then 
	-- 	self.spriteHeadImg:setTexture(getCCTextureByName("images/DaTing/lobby_pic_touxiang75.png"))
	-- else
	-- 	self:RefreshUserHeadIcon(self.headimage_)	
	-- end
end

function Player:ReInitPlayerInfo()
	-- self.spriteimg:getParent():setVisible(false);
	self.spriteimg:setVisible(false);
	self.spriteHeadImg:setVisible(false)
	-- self.spriteHeadImg:setTexture(getCCTextureByName("images/DaTing/lobby_pic_touxiang75.png"))
	self.labelPlayername:setVisible(false);

	-- if (self.ndir_ == 1) then
	-- 	-- self.right_left_card_:removeAllChildrenWithCleanup(true);
	-- 	self.cardback:setVisible(false)
	-- elseif (self.ndir_ == 2) then
	-- 	-- self.left_left_card_:removeAllChildrenWithCleanup(true);
	-- 	self.cardback:setVisible(false)
	-- end
	self.player_attr_ = {};
	self.headimage_ = ""
end 

function Player:ReInit()  --清理桌面数据
	print("Player:ReInit"..self.ndir_)
	self:ReInitPlayerInfo()
	self:ReInitCard()
end

function Player:UpdateOperator()  --刷新玩家操作
	
end

function Player:ShowTips(nOp)  --显示玩家操作提示
	local fade_in = CCShow:create();
	local fade_out = CCHide:create();
	local fade_in_action = transition.sequence({fade_in,CCDelayTime:create(3.0),fade_out, CCCallFuncN:create(self.RemoveNode)})
	
	if (nOp == 12) then
		if (self.ndir_ == self.data.DIR_ME) then
			self:startClientTimer(0);
		end
		-- is_ready_ = true;
		if self.meTip:isVisible()==false then
			self.meTip:setTexture(getCCTextureByName("images/YouXi/game_pic_zhunbei.png"))
			self.meTip:setVisible(true)
			self.meTip:setScale(0.1);
			self.meTip:runAction(CCScaleTo:create(0.3, 1, 1))
		end
		return;
	end
	if nOp == 9 then --过牌
		self.meTip:setTexture(getCCTextureByName("images/YouXi/game_pic_buchu.png"))
	elseif nOp == 8 then --抢地主
		self.meTip:setTexture(getCCTextureByName("images/YouXi/game_pic_qiangdizhu.png"))
		gBaseLogic.audio:PlayAudio(31); --AUDIO_ROB
	elseif nOp == 7 then --不抢地主
		self.meTip:setTexture(getCCTextureByName("images/YouXi/game_pic_buqiang.png"))
		gBaseLogic.audio:PlayAudio(32); --AUDIO_NO_ROB
	elseif nOp == 5 then --不叫地主
		self.meTip:setTexture(getCCTextureByName("images/YouXi/game_pic_bujiao.png"))
		gBaseLogic.audio:PlayAudio(26); --AUDIO_SCORE0
	elseif nOp == 6 or nOp == 2 or nOp == 3 or nOp == 4 then --叫地主
		--self.meTip:setTexture(getCCTextureByName("images/YouXi/game_btn_jiaodizhu.png")) --疑问
		self.meTip:setTexture(getCCTextureByName("images/YouXi/game_pic_3fen.png")) --疑问D		
		gBaseLogic.audio:PlayAudio(23); --AUDIO_CALL_LORD
	elseif nOp == 1 then --不叫
		self.meTip:setTexture(getCCTextureByName("images/YouXi/game_pic_bujiao.png"))
		gBaseLogic.audio:PlayAudio(24); --AUDIO_CALL_NO_LORD
	--[[
	elseif nOp == 2 then --1分
		self.meTip:setTexture(getCCTextureByName("images/YouXi/game_pic_1fen.png"))
		gBaseLogic.audio:PlayAudio(27); --AUDIO_SCORE1
	elseif nOp == 3 then --2分
		self.meTip:setTexture(getCCTextureByName("images/YouXi/game_pic_2fen.png"))
		gBaseLogic.audio:PlayAudio(28); --AUDIO_SCORE2
	elseif nOp == 4 then --3分
		self.meTip:setTexture(getCCTextureByName("images/YouXi/game_pic_3fen.png"))
		gBaseLogic.audio:PlayAudio(29); --AUDIO_SCORE3
	--]]
	else
		self.meTip:setVisible(false)
		return;
	-- elseif nOp == 10 then --亮牌
	-- 	self.meTip:setTexture(setTexture(getCCTextureByName("images/YouXi/game_btn_buchu.png")))
	end

	self.meTip:setVisible(true)
	self.meTip:runAction(fade_in_action)
	--is_ready_ = false;
end
function Player:resAlarmNum(reNum)
	print(self.ndir_ .. "Player:resAlarmNum:"..self.alarm_num)
	self.alarm_num = self.alarm_num - reNum*1000;
	print(self.alarm_num)
end
function Player:onTimer(dt)
	self.alarm_num = self.alarm_num - dt*1000;
	-- print(self.ndir_ .."Player:onTimer"..self.alarm_num)
	local cur_alarm_num = self.alarm_num
	if (math.round(cur_alarm_num/1000) > 0) then
		-- if (self.alarm_num == 4) then
		-- 	CCActionInterval* seq = (CCActionInterval*)CCSequence::actions(
		-- 		CCScaleTo::actionWithDuration(0.15f, 0.8f, 1.0f),
		-- 		CCScaleTo::actionWithDuration(0.15f, 1.0f, 1.0f),
		-- 		NULL);
		-- 	sprite_clock_bg_->runAction(CCRepeat::actionWithAction(seq, 17));
		-- end
		local alarmnum;
		if math.round(cur_alarm_num/1000) < 10 then
			alarmnum = "0" .. math.round(cur_alarm_num/1000)
			if math.round(cur_alarm_num/1000) < 5 then
				gBaseLogic.audio:PlayAudio(11); --AUDIO_CLOCK
			end
		else
			alarmnum = math.round(cur_alarm_num/1000) .. ""
		end
		self.ClockNumber:setString(alarmnum)
	elseif math.round(cur_alarm_num/1000) <= 0 then
	    self.Clock:setVisible(false)
	    self.alarm_num = 0
	    if self.ndir_ == 0 and self.gamescene.ctrller.clientTimerPos==0 then
	    	print("self.gamescene.ctrller.clientTimerPos"..self.ndir_)
	    	print("1self.gamescene.ctrller.clientTimerPos"..self.gamescene.ctrller.clientTimerPos)
	    	self.gamescene.ctrller:sendNoCard()
	    end
	end
end

function Player:startClientTimer(nSecond)
	if (nSecond > 0) then
		if nSecond>=18 and #self.cards_.m_cCards==20 then
			nSecond = 20;
		end
		local ClockNumberstr = nSecond
		if nSecond < 10 then
			ClockNumberstr = "0" .. nSecond
		end
		self.meTip:setVisible(false)
		self.Clock:setVisible(true);
		self.ClockNumber:setString(ClockNumberstr .. "")
		self.alarm_num = nSecond*1000;
	else
		self.Clock:setVisible(false);
		self.alarm_num = 0;
	end
end
function Player:showCardAlarm()
	if nil ~= self.cardAlarm then 
		return
	end 
    local ani = getAnimation("game_ani_alarm","donghua");
    if nil == ani then return end 

    local frame =  tolua.cast(ani:getFrames():objectAtIndex(0),"CCAnimationFrame"):getSpriteFrame()
    self.cardAlarm = CCSprite:createWithSpriteFrame(frame)
    local x,y = self.Clock:getPosition()
    if (self.ndir_ == 1) then --右边
    	x = x + 80
    else 
    	x = x - 80
    end 
    y = y + 50
    self.cardAlarm:setPosition(ccp(x,y))
    self.gamescene.rootNode:addChild(self.cardAlarm)
    self.cardAlarm:runAction(CCRepeatForever:create(CCAnimate:create(ani)))
    gBaseLogic.audio:PlayAudio(42); --AUDIO_CARDALARM
end

function Player:getHeadImage()
    local url = string.gsub(URL.USERBATCH,"{uids}",tostring64(self.player_attr_.ply_guid_))
    --url = "http://t.payment.hiigame.com/new/gateway/user/batch?uids=1101133836943856"
    echoInfo("get user head image: "..url);

    gBaseLogic:HTTPGetdata(url, 0, function(event)
    	if event~=nil then 
        	self:onGetHeadImage(event)
        end
        end)
end 
--{"list":[{"account":"goon003","address":"","age":0,"code":"","desc":"","face":"http://img.cache.izhangxin.com/faces/default.png","isforbid":0,"nickname":"goon003","phone":"","plat":11,"realname":"","sex":0,"status":0,"uid":"1101133836943856"}]}
function Player:onGetHeadImage(event)
	print("Player:onGetHeadImage(event)")
	self.spriteHeadImg:setVisible(true)
	self.headimage_ = event.list[1].face
	self:RefreshUserHeadIcon(self.headimage_)	
end 

function Player:RefreshHeadIcon(Lorn)  --更换玩家头像为农民地主头像
	self.spriteimg:setVisible(true)
	if (Lorn==1) then
		local imgfile = "images/YouXi/game_pic_dizhu.png"
		if self.player_attr_.sex_~=nil and self.player_attr_.sex_==0 then
			imgfile = "images/YouXi/game_pic_dizhu1.png"
		end
		self.spriteimg:setTexture(getCCTextureByName(imgfile));	
	else
		local imgfile = "images/YouXi/game_pic_nongmin.png"
		if self.player_attr_.sex_~=nil and self.player_attr_.sex_==0 then
			imgfile = "images/YouXi/game_pic_nongmin1.png"
		end
		self.spriteimg:setTexture(getCCTextureByName(imgfile));	
	end
end 

function Player:RefreshUserHeadIcon(url) --gBaseLogic.lobbyLogic.face
	print("RefreshUserHeadIcon:"..url)
	--Lorn = "http://img.cache.bdo.banding.com.cn/faces/default.png" 
	self.spriteHeadImg:setVisible(true)
	if isLocalFile(url) == false then 
		izx.resourceManager:imgFileDown(url,true,function(fileName) 
				if self~=nil and self.spriteHeadImg~=nil then
		            self.spriteHeadImg:setTexture(getCCTextureByName(fileName))
		        end
		    end);
	else 
		self.spriteHeadImg:setTexture(getCCTextureByName(url))
	end
end

-- NET_PACKET(VipData)
-- {
-- 	int		level_;					// VIP等级
-- 	int		nex_level_total_days_;	// 升至下级总共需要的天数		5,15,35...
-- 	int		auto_upgrade_day_;		// 自动升级天数					5,10,20...
-- 	int		login_award_;			// VIP登录奖励
-- 	int		friend_count_;			// 好友个数
-- 	int		next_level_due_days_;	// 升至下一级还剩的天数			nex_level_total_days-existing_day
-- 	int		remain_due_days_;		// 剩余到期天数					DB: due_date
-- 	int		status_;				// VIP当前状态					0无效 1有效
-- };
function Player:RefreshVip()  --更换玩家Vip 
	print("Player:RefreshVip..............")
	var_dump(self.player_attr_.ply_vip_)
	print("RefreshVip:"..self.player_attr_.ply_vip_.level_..":"..self.player_attr_.ply_vip_.status_) 
	-- self.gamescene:showVipIcon(self.spriteVip, self.player_attr_.ply_vip_.level_, self.player_attr_.ply_vip_.status_)


----new vip
	local vipLevel = self.player_attr_.ply_vip_.level_
	local filename = "images/DaTing/lobby_pic_touxiangkuang1.png";
	if vipLevel<6 then
		filename = "images/DaTing/lobby_pic_touxiangkuang.png";
	elseif vipLevel==6 then
		filename = "images/DaTing/lobby_pic_touxiangkuang1.png";
	elseif vipLevel<=8 then
		filename = "images/DaTing/lobby_pic_touxiangkuang2.png";
	else
		filename = "images/DaTing/lobby_pic_touxiangkuang3.png";
	end
	local pBackgroundButton = CCScale9Sprite:create(filename)		
	self.btntouKuang:setBackgroundSpriteForState(pBackgroundButton,CCControlStateNormal)
	local pBackgroundButton1 = CCScale9Sprite:create(filename)
	self.btntouKuang:setBackgroundSpriteForState(pBackgroundButton1,CCControlStateHighlighted)
	local pBackgroundButton2 = CCScale9Sprite:create(filename)
	self.btntouKuang:setBackgroundSpriteForState(pBackgroundButton2,CCControlStateDisabled)
	if vipLevel>0 then
		-- self.labelPlayername:setColor(ccc3(255,234,0))
		if vipLevel>10 then
			vipLevel=10
		end
		self.spriteVip:setVisible(true)
		self.spriteVip:setTexture(getCCTextureByName("images/VIP/viplbl"..vipLevel..".png"))
		if vipLevel>2 then
			self.labelPlayername:setColor(ccc3(255,234,0))
		else
			self.labelPlayername:setColor(ccc3(255,255,255))
		end
	else
		self.spriteVip:setVisible(false)
		self.labelPlayername:setColor(ccc3(255,255,255))
	end 

	if gBaseLogic.MBPluginManager.distributions.checkapple or gBaseLogic.MBPluginManager.distributions.novip then
		self.spriteVip:setVisible(false)
	end
end 

function Player:RefreshHeadIcontuo(auto) -- auto 1托管 0：取消托管
	--托管icon显示取消
	if auto == 1 then
		--显示托管
		print ("dis auto")
		self.alarm_num = 0
	else
	end
end
-- NET_PACKET(PlyBaseData)
-- {
-- 	guid		ply_guid_;
-- 	string		nickname_;
-- 	int			sex_;			//0男 1女
-- 	int			gift_;
-- 	int64		money_;
-- 	int			score_;
-- 	int			won_;
-- 	int			lost_;
-- 	int			dogfall_;
-- 	int			table_id_;	
-- 	int			param_1_;		//扩展属性1 用于保存用于注册时间
-- 	int			param_2_;		//扩展属性2
-- 	char		chair_id_;		//table_id_ != -1 && chair_id_ == -1为旁观状态
-- 	char		ready_;			//1已经举手, 0没有举手
-- 	VipData		ply_vip_;		//vip数据
-- };
function Player:getPlyData()  --玩家信息
	return self.player_attr_;
end

function Player:setUserData(data)  --设置玩家信息	
	self.player_attr_ = data ;
	self:PlayerJoin();
end

function Player:RefreshName(name)
	self.player_attr_.nickname_ = name
	if self.ndir_ == 0 then
		self.labelPlayername:setString(izx.UTF8.sub(name)); 
		if gBaseLogic.is_robot == 0 then 
			gBaseLogic.lobbyLogic.userData.ply_lobby_data_.nickname_ = name
		end
	end
end

function Player:changeMoney(money,upt_reason_)
	-- echoError("PlayerchangeMoney"..self.ndir_)
	print(money)
	self.player_attr_.money_ = money
	if self.ndir_ == 0 then
		--self.lableUsericonmoney:setString(numberChange(self.player_attr_.money_));
		self.lableUsericonmoney:setString(self.player_attr_.money_);
		if gBaseLogic.is_robot == 0 then 
			if (gBaseLogic.lobbyLogic.userData.ply_lobby_data_~=nil) then
				gBaseLogic.lobbyLogic.userData.ply_lobby_data_.money_ = money
			end
		end
	end
end

function Player:RefreshCard(vecCards)  --刷新玩家牌
	
	if (self.ndir_ == 0) then
		-- if #vecCards == 1 and self.gamescene.ctrller.is_auto_ == false then --self.ctrller.is_auto_
		-- 	if gBaseLogic.is_robot == 0 then 
		-- 		self.gamescene.ctrller.is_auto_ = true
		-- 		self.gamescene.ctrller:pt_cg_auto_req_send(1)
		-- 	end
		-- end
		return;
	end 

	self.cards_.m_cCards = vecCards;
	--self.play_hand_card_:removeAllChildrenWithCleanup(true);
	if (#self.cards_.m_cCards > 0) then
		self.cardback:setVisible(true)	
		local leftnum = tolua.cast(self.cardback:getChildByTag(1),"CCLabelAtlas")
		if leftnum ~= nil then
			leftnum:setString(#self.cards_.m_cCards .."")
		end

		if (#self.cards_.m_cCards <=2) then 
			self:showCardAlarm()
		end
		-- self.sprite_card_left_:setVisible(true);
		-- sprintf(buff,"%d",vecCards.size());
		-- remain_card_num_->setString(buff);
		-- remain_card_num_->setIsVisible(true);
		-- if (is_show_card_) then --亮牌
		-- 	-- self.cards_:CleanUp();
		-- 	-- pgame_->RefreshShowCard(cards_->m_cCards);
		-- else
		-- 	cardsnum = 0
		-- 	for k,v in pairs(vecCards) do
		-- 		local sprite = CCSprite:create("images/YouXi/game_pic_paibei.png");
		-- 		self.play_hand_card_:addChild(sprite);
		-- 		sprite:setPosition(ccp(10,cardsnum*(10)));
		-- 		cardsnum = cardsnum + 1
		-- 	end
		-- end
	else
		-- self.cardback:removeAllChildrenWithCleanup(true)
		self.cardback:setVisible(true)	
		local leftnum = tolua.cast(self.cardback:getChildByTag(1),"CCLabelAtlas")
		if leftnum ~= nil then
			leftnum:setString("0");
		end	
		-- self.sprite_card_left_:setIsVisible(false);
		-- remain_card_num_->setIsVisible(false);
		-- sprite_show_card_tip_->setIsVisible(false);
	end
end

function Player:PlayerJoin()  --新玩家加入
	print("+++++++++++++++Player:PlayerJoin");
	self.spriteimg:getParent():setVisible(true);
	-- self.spriteimg:setTextrue();
	self.spriteimg:setVisible(false);
	 
	self.spriteHeadImg:setVisible(true)
	if self.gamescene.logic.isMatch ~= 1 then
		self.labelPlayername:setVisible(true);	
		self.labelPlayername:setString(izx.UTF8.sub(self.player_attr_.nickname_));
	end
	print (self.ndir_)
	if self.ndir_ == 0 then
		print(self.player_attr_.money_);
		--self.lableUsericonmoney:setString(numberChange(self.player_attr_.money_)); 
		print("Player:PlayerJoin"..self.gamescene.logic.isMatch)
		if self.gamescene.logic.isMatch == 0 then 
			self.lableUsericonmoney:setString(self.player_attr_.money_);
		else 
			self.lableUsericonmoney:setString(gBaseLogic.lobbyLogic.match_current_score);
			self.labelPlayername:setString(izx.UTF8.sub(self.player_attr_.nickname_));
		end 
		self.gamescene.ctrller.data.players_[2].spriteimg:getParent():setVisible(true);
		self.gamescene.ctrller.data.players_[3].spriteimg:getParent():setVisible(true);
	end 

	if gBaseLogic.is_robot == 0 then 	
		if self.ndir_ == 0 then
			self.headimage_ = gBaseLogic.lobbyLogic.face
			self:RefreshUserHeadIcon(self.headimage_)
		else 
			print(self.headimage_)
			if self.headimage_ == "" then 
				self:getHeadImage() 
			else 
				self:RefreshUserHeadIcon(self.headimage_)	
			end
		end 
	else 
		if self.ndir_ == 0 then
			self.headimage_ = CCUserDefault:sharedUserDefault():getStringForKey("ply_face_")
		else 
			self.headimage_ = "images/YouXi/"..self.player_attr_.ply_guid_..".png"
		end
		self:RefreshUserHeadIcon(self.headimage_)
	end
	if self.player_attr_.ply_vip_~=nil  and self.player_attr_.ply_vip_.level_~=nil then
		self:RefreshVip()
	-- var_dump(self.player_attr_.ply_vip_)
		

	end
end

function Player:PlayerLeave()
	-- self.spriteimg:getParent():setVisible(false);
	self.spriteimg:setVisible(false);
	self.spriteHeadImg:setVisible(false)
	-- self.spriteHeadImg:setTexture(getCCTextureByName("images/DaTing/lobby_pic_touxiang75.png"))
	self.labelPlayername:setVisible(false);
	self.spriteVip:setVisible(false)
	self.player_attr_ = {};
	self.headimage_ = ""

	self.Clock:setVisible(false)
	self.alarm_num = 0;

	self.is_show_card_ = false;

	if (self.cardback~=nil) then
		self.cardback:setVisible(false)
	end
	self.meTip:setVisible(false)
	self.cards_.m_cCards = {}
	self.cards_.m_nBaoValue = 0;

end

function Player:OnPlayCardNot(noti)  --显示打出的牌
	self.play_card_:removeAllChildrenWithCleanup(true);

	local vecCards = {}  --模拟环境
    for k,v in pairs(noti.vecCards) do 
        table.insert(vecCards,v);
    end
    if (#vecCards <= 0) then
		return;
	end
	
	local cardSize = CCSizeMake(138,182);
    local nWidth = (#vecCards-1)* 40 + cardSize.width;
	local ptPlayCard = CCPointMake(0, 0);
	if (self.ndir_ == self.data.DIR_ME) then
		ptPlayCard.x = -nWidth/2;
	elseif (self.ndir_ == self.data.DIR_RIGHT) then
		ptPlayCard.x = - nWidth;
		ptPlayCard.y = ptPlayCard.y-50
	else
		ptPlayCard.x = 0;
		ptPlayCard.y = ptPlayCard.y-50
	end
	
	local sortFunc = function(a, b)
		local thisorderA =  a.m_nValue * 4 + a.m_nColor;
		local thisorderB = b.m_nValue * 4 + b.m_nColor
		if self.cards_.m_nBaoValue~=0 then
			if a.m_nValue==self.cards_.m_nBaoValue then
				if a.m_nCard_Baovalue>=3 and a.m_nCard_Baovalue<=15 then
					thisorderA = a.m_nCard_Baovalue*4+a.m_nColor
				end
			end
			if b.m_nValue==self.cards_.m_nBaoValue then
				if b.m_nCard_Baovalue>=3 and b.m_nCard_Baovalue<=15 then
					thisorderB = b.m_nCard_Baovalue*4+b.m_nColor
				end
			end
		end
	    if thisorderA > thisorderB then
	    	return true
	    else 
	    	return false
	    end
	end
	table.sort(vecCards, sortFunc)
	print("Player:OnPlayCardNot111")
	var_dump(vecCards)
	self.play_card_.zorder = 1
	local scale = 1
	if self.ndir_ ~= 0 then
		scale = 0.5
	end

	for i,v in ipairs(vecCards) do
		local pCard = require("moduleDdz.ctrllers.CCardSprite").new(self.gamescene,v,self.cards_.m_nBaoValue,scale,true);
        self.play_card_:addChild(pCard,i);
        -- if(pCard->getCardValue().m_nValue == cards_->m_nBaoValue)
		-- {
		-- 	CCSprite* sprite_laizi = HGResMgr::shareResMgr()->getDrawable("laizi.png");
		-- 	pCard->addChild(sprite_laizi);
		-- 	sprite_laizi->setPosition(CUIPOS(pCard,sprite_laizi,pgame_->laizi_card_size().width,pgame_->laizi_card_size().height));
		-- }
        pCard:setAnchorPoint(CCPointMake(0,0))
		--放到屏幕外面
		pCard:setPosition(ccp(-800, -800));

		local action1 = CCDelayTime:create(i*0.1);
		local action2 = CCMoveTo:create(0, ccp(ptPlayCard.x + (i-1)*40, ptPlayCard.y + 25));
		local action3 = CCMoveTo:create(0.1, ccp(ptPlayCard.x + (i-1)*40, ptPlayCard.y));
		pCard:runAction(transition.sequence({action1, action2, action3}));
	end
end

function Player:onChatNot(type, msg)
	local i = tonumber(string.sub(msg,9))
    if type == self.data.CHAT_TYPE_PAY_ANI then	   
		self:PlayChatAni(self.data.ANI_MAX_FREE+i+1)
    elseif type == self.data.CHAT_TYPE_ANI then
		self:PlayChatAni(i);
    elseif type == self.data.CHAT_TYPE_TXT then
		self:OnShowChatContent(phrasetable[i])
		gBaseLogic.audio:PlayAudio(i-1); --声音从0排
    elseif type == self.data.CHAT_TYPE_INPUT then
    	izxMessageBox("该功能还没有开放","用户输入");
    end
end

function Player:OnChatPayNot(expression)
	self:PlayChatAni2(expression)
end

function Player:PlayChatAni(i)
	if (self.is_play_ani_ == false) then
		self.is_play_ani_ = true;
		local ani = getAnimation("ani_"..i,"BiaoQing");
		if nil == ani then return end 

		local frame =  tolua.cast(ani:getFrames():objectAtIndex(0),"CCAnimationFrame"):getSpriteFrame()
  		local sprite = CCSprite:createWithSpriteFrame(frame);
		sprite:setOpacity(0);

		if (i == self.data.ANI_SHUAI) then
			sprite:runAction(CCAnimate:create(ani));
		else
			sprite:runAction(CCRepeatForever:create(CCAnimate:create(ani)));
		end
		sprite.belong = self;
		self.gamescene.gameLayer:addChild(sprite);
		sprite:setPosition(self.ani_chat_pos_);
		local fade_in = CCFadeIn:create(0.25);
		local fade_out = CCFadeOut:create(0.25);
		local fade_in_action = transition.sequence({fade_in,CCDelayTime:create(2.0),fade_out, CCCallFuncN:create(self.FinishAni)});
		sprite:runAction(fade_in_action);
	end
end

function Player:PlayChatAni2(i)
	if (self.is_play_ani_ == false) then
		self.is_play_ani_ = true;
		local ani = getAnimation2("ani_pay_"..i,"BiaoQing");
		if nil == ani then return end 

		local frame =  tolua.cast(ani:getFrames():objectAtIndex(0),"CCAnimationFrame"):getSpriteFrame()
  		local sprite = CCSprite:createWithSpriteFrame(frame);
		sprite:setOpacity(0);

		if (i == self.data.ANI_SHUAI) then
			sprite:runAction(CCAnimate:create(ani));
		else
			sprite:runAction(CCRepeatForever:create(CCAnimate:create(ani)));
		end
		sprite.belong = self;
		self.gamescene.gameLayer:addChild(sprite);
		sprite:setPosition(self.ani_chat_pos_);
		local fade_in = CCFadeIn:create(0.25);
		local fade_out = CCFadeOut:create(0.25);
		local fade_in_action = transition.sequence({fade_in,CCDelayTime:create(2.0),fade_out, CCCallFuncN:create(self.FinishAni)});
		sprite:runAction(fade_in_action);
	end
end
function Player:OnShowChatContent(msg)
	-- print("+++++++++++++++++++++++++++")
	-- var_dump(self)
	local txtback = CCSprite:create("images/DaTing/lobby_bg_gonggao.png");
	self.gamescene.gameLayer:addChild(txtback,10000);
	txtback:setPosition(self.txt_chat_pos_.x,self.txt_chat_pos_.y);
    local fadeIn = CCFadeIn:create(0.3);
	local fadeOut = CCFadeOut:create(0.3);
	local fade_in_action;
	local fade_in = CCShow:create();
	local fade_out = CCHide:create();
	fade_in_action = transition.sequence({fade_in,CCDelayTime:create(3.0),fade_out, CCCallFuncN:create(self.FinishAni)});

	txtback:runAction(fade_in_action);

	local txt_chat = CCLabelTTF:create(self.player_attr_.nickname_..": "..msg,"Helvetica",24);
	local txtbacksize = txtback:getContentSize()
    txt_chat:setPosition(ccp(txtbacksize.width/2,txtbacksize.height/2));
   	txtback:addChild(txt_chat);
    
    --有换行需求时
    -- local factor = CCDirector:sharedDirector():getContentScaleFactor();
    -- local pMoveBy = CCMoveBy:create(0.5, ccp(0, 27 / factor));
    
    -- local pActions = CCArray:create();
    -- local nChatTxtSize = string.len(msg)  / 3;
    -- local nChatScrollTime = ((nChatTxtSize - 2) / 10);
    -- for i=0,nChatScrollTime-1 do
    -- 	pActions:addObject(CCDelayTime:create(3.6 / (nChatScrollTime + 1)));
    --     pActions:addObject(pMoveBy);
    -- end
    -- if (pActions:count() > 0) then
    -- 	local pFiniteTimeAction = CCSequence:create(pActions);
    --     txt_chat:runAction(pFiniteTimeAction);
    -- end
end

function Player:RemoveNode()
	self:setVisible(false)
end

function Player:FinishAni()
	if self.belong ~= nil then
		self.belong.is_play_ani_ = false;
		self.belong = nil
	end
	self:removeFromParentAndCleanup(true);
end

function Player:GetPlayCards()  --手中的牌
	return self.cards_; 
end

function Player:play_card()
	return play_card_;
end

function Player:PlayAni(ani_type)
	local winSize = CCDirector:sharedDirector():getWinSize();
	if (ani_type == self.data.ANI_FEIJI) then
		local ani = getAnimation("ani_plan");
 		local frame =  tolua.cast(ani:getFrames():objectAtIndex(0),"CCAnimationFrame"):getSpriteFrame()
		local m_playAni = CCSprite:createWithSpriteFrame(frame);
		self.gamescene.gameLayer:addChild(m_playAni,3); 
		m_playAni:runAction(transition.sequence({CCRepeatForever:create(CCAnimate:create(ani))}));

		local pos = CCPointMake(0,winSize.height/2);
		m_playAni:setPosition(pos);

		if (self.ndir_ == 1) then
			pos.x = winSize.width;
			m_playAni:setPosition(pos);
			if (m_playAni:getScaleX() == -1) then
				m_playAni:setScaleX(1.0);
			end
			pos.x = -m_playAni:getContentSize().width;
		elseif (self.ndir_ == 2 or self.ndir_ == 0) then
			pos.x = 0;
			m_playAni:setPosition(pos);
			if (m_playAni:getScaleX() == 1) then
				m_playAni:setScaleX(-1.0);
			end
			pos.x = winSize.width + m_playAni:getContentSize().width;
		end
		
		m_playAni:setVisible(true);
		local action2 = CCMoveTo:create(1.6, pos);
		local actionMoveDone = CCCallFuncN:create(self.FinishAni);
		m_playAni:runAction(transition.sequence({action2,CCDelayTime:create(0.5),actionMoveDone}));
		gBaseLogic.audio:PlayAudio(15); --AUDIO_PLANE
	elseif (ani_type == self.data.ANI_ZHADAN) then
		local zhadanstr = "ani_zhadan";
		if self.player_attr_.ply_vip_~=nil  and self.player_attr_.ply_vip_.level_~=nil then
			if self.player_attr_.ply_vip_.level_>=8 then
				zhadanstr = "ani_zhadan_teshu"
			end
		end
		local ani = getAnimation(zhadanstr)
		local frame =  tolua.cast(ani:getFrames():objectAtIndex(0),"CCAnimationFrame"):getSpriteFrame()
		local m_playAni = CCSprite:createWithSpriteFrame(frame);
		self.gamescene.gameLayer:addChild(m_playAni,3); 
		m_playAni:setPosition(ccp(display.cx,300*winSize.height/640));

		m_playAni:setVisible(true);
		local actionMoveDone = CCCallFuncN:create(self.FinishAni);
		m_playAni:runAction(transition.sequence({CCAnimate:create(ani),CCDelayTime:create(0.2),actionMoveDone}));
		gBaseLogic.audio:PlayAudio(10); --AUDIO_BOMB
	elseif (ani_type == self.data.ANI_SHUNZI) then
		local ani = getAnimation("ani_shanzi");
		local frame =  tolua.cast(ani:getFrames():objectAtIndex(0),"CCAnimationFrame"):getSpriteFrame()
		local m_playAni = CCSprite:createWithSpriteFrame(frame);
		self.gamescene.gameLayer:addChild(m_playAni,3); 
		m_playAni:setPosition(ccp(display.cx,300*winSize.height/640));
		m_playAni:setVisible(true);
		local actionMoveDone = CCCallFuncN:create(self.FinishAni);
		m_playAni:runAction(transition.sequence({CCAnimate:create(ani),CCDelayTime:create(0.2),actionMoveDone}));
		gBaseLogic.audio:PlayAudio(17); --AUDIO_DANSHUN
	elseif (ani_type == self.data.ANI_HUOJIAN) then
		local ani = getAnimation("ani_huojian");
		local frame =  tolua.cast(ani:getFrames():objectAtIndex(0),"CCAnimationFrame"):getSpriteFrame()
		local m_playAni = CCSprite:createWithSpriteFrame(frame);
		self.gamescene.gameLayer:addChild(m_playAni,3); 
		m_playAni:runAction(transition.sequence({CCRepeatForever:create(CCAnimate:create(ani))}));
		local pos = CCPointMake(winSize.width/2,0);
		m_playAni:setPosition(pos);
		m_playAni:setVisible(true);
		pos.y = winSize.height+m_playAni:getContentSize().height;
		local action2 = CCMoveTo:create(1.2, pos);
		local actionMoveDone = CCCallFuncN:create(self.FinishAni);
		m_playAni:runAction(transition.sequence({action2,CCDelayTime:create(0.2),actionMoveDone}));
		gBaseLogic.audio:PlayAudio(19); --AUDIO_ROCKET
	elseif (ani_type == self.data.ANI_LIANDUI) then
		local ani = getAnimation("ani_liandui");
		local frame =  tolua.cast(ani:getFrames():objectAtIndex(0),"CCAnimationFrame"):getSpriteFrame()
		local m_playAni = CCSprite:createWithSpriteFrame(frame);
		self.gamescene.gameLayer:addChild(m_playAni,3); 
		m_playAni:setPosition(ccp(display.cx,300*winSize.height/640));
		m_playAni:setVisible(true);
		local actionMoveDone = CCCallFuncN:create(self.FinishAni);
		m_playAni:runAction(transition.sequence({CCAnimate:create(ani),CCDelayTime:create(0.2),actionMoveDone}));
		gBaseLogic.audio:PlayAudio(33); --AUDIO_DUIDUISHUN
	end
end	

function Player:PlayAniStep(node)
	
end	
	
function Player:getAnimation(ani_type)
	local pAnimation = CCAnimation:create();
	pAnimation:setDelayPerUnit(100/1000.0);
	local frame_;
    if ani_type == self.data.ANI_PAY_CAT_0 then
    	frame_ = {0,1,2,3,2,4,5,6,7,8,5,6,7};
    elseif ani_type == self.data.ANI_PAY_CAT_1 then
    	frame_ = {0,1,2,3,4,5,6,7};
    elseif ani_type == self.data.ANI_PAY_CAT_2 then
    	frame_ = {0,1,2};
    elseif ani_type == self.data.ANI_PAY_CAT_3 then
    	frame_ = {0,1,2,1,0,1,2,1,0,1,2,0,3,4,5,6,7,6,5,6,7,6,5,6,7,6,5,6,7,6};
    elseif ani_type == self.data.ANI_PAY_CAT_4 then
    	frame_ = {0,1,2,3,2,1,0};
    end
    
    if frame_ ~= nil then
	    for i=1,#frame_ do
    		local buff = "ani_pay_".. ani_type-self.data.ANI_MAX_FREE .."_"..frame_[i]..".png";
			local sprite = CCSprite:create("images/donghua/"..buff)
			pAnimation:addSpriteFrameWithTexture(sprite:getTexture(),sprite:getTextureRect());			
	    end            
	end
	return pAnimation;
end	

function Player:sprite_show_card_tip()
	return sprite_show_card_tip_;
end

function Player:txt_show_card_tip()
	return txt_show_card_tip_;
end

function Player:sprite_card_left()
	return sprite_card_left_;
end

function Player:set_is_show_card(flag)
	self.is_show_card_ = flag;
end

function Player:is_show_card()
	return self.is_show_card_;
end

function Player:set_is_auto(flag)
	is_auto_ = flag;
end

function Player:is_auto()
	return is_auto_;
end

function Player:is_ready()
	return is_ready_;
end

function Player:get_vip_icon(viplevel, bexpired)

end

function Player:get_vip_icon(vipdata)

end

function Player:drawvip()

end

return Player;