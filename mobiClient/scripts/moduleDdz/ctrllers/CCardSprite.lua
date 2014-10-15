local CCardSprite = class("CCardSprite",function()
					return display.newNode()
					end) 
function CCardSprite:ctor(gamescene, card, m_nBaoValue,scale,isshow)
	self.gamescene = gamescene;
    self.data = {
    	ST_SELECTED = 0,
		ST_UNSELECTED = 1,
		m_stCard = {},
		m_nBaoValue = m_nBaoValue,
		isshow = isshow
    };
    
    if scale ~= nil then
    	self.data.scale = scale
    	self:setScale(scale)
    end
 	self:setCard(card)
end

-- function CCardSprite:initWithCard(card)
	
-- end

function CCardSprite:initWithSprite()
	
end

-- function CCardSprite:initWithPutCard(card, scale)
	
-- end

function CCardSprite:setCard(card)
	self.data.m_stCard = card;
	--牌面
	if card ~= nil then
	    local pCardBack = CCSprite:create("images/PuKe/puke_paimian.png")
		self:addChild(pCardBack);
		pCardBack:setTag(1)
		self:setContentSize(pCardBack:getContentSize());
		local size = self:getContentSize();
		pCardBack:setPosition(CCPoint(size.width/2,size.height/2));
	   
		local cardBackSize = pCardBack:getContentSize();
		local showcardvalue = card.m_nValue;
		if self.data.isshow==true then
			if (card.m_nValue==self.data.m_nBaoValue) then
				if card.m_nCard_Baovalue >=3 and card.m_nCard_Baovalue<=15 then
					showcardvalue = card.m_nCard_Baovalue
				end
			end
		end
		--牌值
		if (showcardvalue <= 10 or showcardvalue == 14 or showcardvalue == 15) then
			local nFrame;
			if (showcardvalue <= 14) then
				nFrame = showcardvalue - 2;
			elseif (showcardvalue == 15) then
				nFrame = 0;
	        end

			if card.m_nColor == 0 then
				local pValue = self.gamescene:getFrame("images/PuKe/puke_shuzi2.png", 13, 1, nFrame);
				pCardBack:addChild(pValue);
				pValue:setPosition(self.gamescene:CUIPOS(pCardBack,pValue,9,10));--GameSession::GetInstancePtr()->card_shuzi()

				local pColor = CCSprite:create("images/PuKe/puke_heitao1.png");
				pCardBack:addChild(pColor);
				pColor:setPosition(self.gamescene:CUIPOS(pCardBack,pColor,10,60));--GameSession::GetInstancePtr()->card_xiaohua()

				local pColor2 = CCSprite:create("images/PuKe/puke_heitao.png");
				pCardBack:addChild(pColor2);
				pColor2:setPosition(self.gamescene:CUIPOS(pCardBack,pColor2,50,75));--GameSession::GetInstancePtr()->card_dahua()
			elseif card.m_nColor == 1 then
				local pValue = self.gamescene:getFrame("images/PuKe/puke_shuzi1.png", 13, 1, nFrame);
				pCardBack:addChild(pValue);
				pValue:setPosition(self.gamescene:CUIPOS(pCardBack,pValue,9,10));--GameSession::GetInstancePtr()->card_shuzi()

				local pColor = CCSprite:create("images/PuKe/puke_hongtao1.png");
				pCardBack:addChild(pColor);
				pColor:setPosition(self.gamescene:CUIPOS(pCardBack,pColor,10,60));--GameSession::GetInstancePtr()->card_xiaohua()

				local pColor2 = CCSprite:create("images/PuKe/puke_hongtao.png");
				pCardBack:addChild(pColor2);
				pColor2:setPosition(self.gamescene:CUIPOS(pCardBack,pColor2,50,75));--GameSession::GetInstancePtr()->card_dahua()
			elseif card.m_nColor == 2 then
				local pValue = self.gamescene:getFrame("images/PuKe/puke_shuzi2.png", 13, 1, nFrame);
				pCardBack:addChild(pValue);
				pValue:setPosition(self.gamescene:CUIPOS(pCardBack,pValue,9,10));--GameSession::GetInstancePtr()->card_shuzi()

				local pColor = CCSprite:create("images/PuKe/puke_meihua1.png");
				pCardBack:addChild(pColor);
				pColor:setPosition(self.gamescene:CUIPOS(pCardBack,pColor,10,60));--GameSession::GetInstancePtr()->card_xiaohua()

				local pColor2 = CCSprite:create("images/PuKe/puke_meihua.png");
				pCardBack:addChild(pColor2);
				pColor2:setPosition(self.gamescene:CUIPOS(pCardBack,pColor2,50,75));--GameSession::GetInstancePtr()->card_dahua()
			elseif card.m_nColor == 3 then
			    local pValue = self.gamescene:getFrame("images/PuKe/puke_shuzi1.png", 13, 1, nFrame);
				pCardBack:addChild(pValue);
				pValue:setPosition(self.gamescene:CUIPOS(pCardBack,pValue,9,10));--GameSession::GetInstancePtr()->card_shuzi()

				local pColor = CCSprite:create("images/PuKe/puke_fangkuai1.png");
				pCardBack:addChild(pColor);
				pColor:setPosition(self.gamescene:CUIPOS(pCardBack,pColor,10,60));--GameSession::GetInstancePtr()->card_xiaohua()

				local pColor2 = CCSprite:create("images/PuKe/puke_fangkuai.png");
				pCardBack:addChild(pColor2);
				pColor2:setPosition(self.gamescene:CUIPOS(pCardBack,pColor2,50,75));--GameSession::GetInstancePtr()->card_dahua()
			end
		elseif (showcardvalue==11 or showcardvalue == 12 or showcardvalue == 13) then
		    local pColor2;
			if (showcardvalue == 11 and (card.m_nColor==0 or card.m_nColor == 2)) then
				pColor2 = CCSprite:create("images/PuKe/puke_heiJ.png");
			elseif (showcardvalue == 11 and (card.m_nColor == 1 or card.m_nColor == 3)) then
				pColor2 = CCSprite:create("images/PuKe/puke_hongJ.png");
			end
			if (showcardvalue == 12 and (card.m_nColor == 0 or card.m_nColor == 2)) then
				pColor2 = CCSprite:create("images/PuKe/puke_heiQ.png");
			elseif (showcardvalue == 12 and (card.m_nColor == 1 or card.m_nColor == 3)) then
			    pColor2 = CCSprite:create("images/PuKe/puke_hongQ.png");
			end
			if (showcardvalue == 13 and (card.m_nColor ==0 or card.m_nColor == 2)) then
				pColor2 = CCSprite:create("images/PuKe/puke_heiK.png");
			elseif (showcardvalue == 13 and (card.m_nColor == 1 or card.m_nColor == 3)) then
				pColor2 = CCSprite:create("images/PuKe/puke_hongK.png");
			end
			if (card.m_nColor == 0) then
				local pValue = self.gamescene:getFrame("images/PuKe/puke_shuzi2.png", 13, 1, showcardvalue - 2);
				pCardBack:addChild(pValue);
				pValue:setPosition(self.gamescene:CUIPOS(pCardBack,pValue,9,10));--GameSession::GetInstancePtr()->card_shuzi()

				local pColor = CCSprite:create("images/PuKe/puke_heitao1.png");
				pCardBack:addChild(pColor);
				pColor:setPosition(self.gamescene:CUIPOS(pCardBack,pColor,10,60));--GameSession::GetInstancePtr()->card_xiaohua()

				pCardBack:addChild(pColor2);
				pColor2:setPosition(self.gamescene:CUIPOS(pCardBack,pColor2,14,20));--GameSession::GetInstancePtr()->card_zhongjianhua()
			elseif (card.m_nColor == 1) then
				local pValue = self.gamescene:getFrame("images/PuKe/puke_shuzi1.png", 13, 1, showcardvalue-2);
				pCardBack:addChild(pValue);
				pValue:setPosition(self.gamescene:CUIPOS(pCardBack,pValue,9,10));--GameSession::GetInstancePtr()->card_shuzi()

				local pColor = CCSprite:create("images/PuKe/puke_hongtao1.png");
				pCardBack:addChild(pColor);
				pColor:setPosition(self.gamescene:CUIPOS(pCardBack,pColor,10,60));--GameSession::GetInstancePtr()->card_xiaohua()

				pCardBack:addChild(pColor2);
				pColor2:setPosition(self.gamescene:CUIPOS(pCardBack,pColor2,14,20));--GameSession::GetInstancePtr()->card_zhongjianhua()
			elseif (card.m_nColor == 2) then
				local pValue = self.gamescene:getFrame("images/PuKe/puke_shuzi2.png", 13, 1, showcardvalue -2);
				pCardBack:addChild(pValue);
				pValue:setPosition(self.gamescene:CUIPOS(pCardBack,pValue,9,10));--GameSession::GetInstancePtr()->card_shuzi()

				local pColor = CCSprite:create("images/PuKe/puke_meihua1.png");
				pCardBack:addChild(pColor);
				pColor:setPosition(self.gamescene:CUIPOS(pCardBack,pColor,10,60));--GameSession::GetInstancePtr()->card_xiaohua()

				pCardBack:addChild(pColor2);
				pColor2:setPosition(self.gamescene:CUIPOS(pCardBack,pColor2,14,20));--GameSession::GetInstancePtr()->card_zhongjianhua()
			elseif (card.m_nColor == 3) then
				local pValue = self.gamescene:getFrame("images/PuKe/puke_shuzi1.png", 13, 1, showcardvalue-2);
				pCardBack:addChild(pValue);
				pValue:setPosition(self.gamescene:CUIPOS(pCardBack,pValue,9,10));--GameSession::GetInstancePtr()->card_shuzi()

				local pColor = CCSprite:create("images/PuKe/puke_fangkuai1.png");
				pCardBack:addChild(pColor);
				pColor:setPosition(self.gamescene:CUIPOS(pCardBack,pColor,10,60));--GameSession::GetInstancePtr()->card_xiaohua()

				pCardBack:addChild(pColor2);
				pColor2:setPosition(self.gamescene:CUIPOS(pCardBack,pColor2,14,20));--GameSession::GetInstancePtr()->card_zhongjianhua()
			end
		elseif (card.m_nValue == 16) then 	--如果是大小王
			if (card.m_nColor == 0) then
				local pJoke = self.gamescene:getFrame("images/PuKe/puke_wang.png", 2, 1, 0);
				pCardBack:addChild(pJoke);
				pJoke:setPosition(self.gamescene:CUIPOS(pCardBack,pJoke,9,10));--GameSession::GetInstancePtr()->card_shuzi()
				
				local pJoke_color = CCSprite:create("images/PuKe/puke_xiaowang.png");
				pCardBack:addChild(pJoke_color);
				pJoke_color:setPosition(self.gamescene:CUIPOS(pCardBack,pJoke_color,14,20));--GameSession::GetInstancePtr()->card_zhongjianhua()
			else
				local pJoke = self.gamescene:getFrame("images/PuKe/puke_wang.png", 2, 1, 1);
				pCardBack:addChild(pJoke);
				pJoke:setPosition(self.gamescene:CUIPOS(pCardBack,pJoke,9,10));--GameSession::GetInstancePtr()->card_shuzi()

				local pJoke_reverse = CCSprite:create("images/PuKe/puke_dawang.png");
				pCardBack:addChild(pJoke_reverse) ;
				pJoke_reverse:setPosition(self.gamescene:CUIPOS(pCardBack,pJoke_reverse,14,20));
			end
		end
		if (card.m_nValue==self.data.m_nBaoValue) then
			local plazi = CCSprite:create("images/PuKe/puke_laizi.png");
			pCardBack:addChild(plazi);
			plazi:setPosition(self.gamescene:CUIPOS(pCardBack,plazi,10,100));--
		end		 

		self.m_nStatus = self.data.ST_UNSELECTED;
		self:setAnchorPoint(ccp(0.5,0.5));
	else

	end
end

function CCardSprite:setPutCard(card, scale)
	
end

function CCardSprite:rect()
	local px, py = self:getPosition()
	local ContentSize = self:getContentSize()
	local AnchorPoint = self:getAnchorPoint()
	local rect =  CCRectMake(px - ContentSize.width * AnchorPoint.x, 
		py - ContentSize.height * AnchorPoint.y,
		ContentSize.width, ContentSize.height);
	return rect
end

function CCardSprite:selected()
	local px, py = self:getPosition();
	if (self.m_nStatus == self.data.ST_SELECTED) then
		self.m_nStatus = self.data.ST_UNSELECTED;
		self:setPosition(ccp(px, py-10));
		-- if(m_pCardMask)
		-- 	m_pCardMask->setIsVisible(false);
	else
		self.m_nStatus = self.data.ST_SELECTED;
		self:setPosition(ccp(px, py+10));
		-- if(m_pCardMask)
		-- 	m_pCardMask->setIsVisible(true);
	end
end
	
function CCardSprite:setStatus(status)
    local px,py = self:getPosition();
	if (status == self.data.ST_SELECTED) then
		if (self.m_nStatus == self.data.ST_SELECTED) then
			return;
		else
			self.m_nStatus = self.data.ST_SELECTED ;
			self:setPosition(ccp(px, py+10));
			--m_pCardMask->setIsVisible(true);
		end
	else
	 	if (self.m_nStatus == self.data.ST_UNSELECTED) then
			return;
		else
			self.m_nStatus = self.data.ST_UNSELECTED;
			self:setPosition(ccp(px, py-10));
			--m_pCardMask->setIsVisible(false);		
		end
	end
end

function CCardSprite:getCardValue()
	return self.data.m_stCard;
end

function CCardSprite:getStatus()
	return self.m_nStatus;
end
	
function CCardSprite:showMask(flag)

end

function CCardSprite:clear()

end

return CCardSprite;
