local PlayCard = class("PlayCard");
function PlayCard:ctor()
	self.m_cCards = {}; --玩家手牌
	self.m_choose_cCards = {}; --玩家选中的牌
	self.m_nBaoValue = 0; --癞子牌
	self.m_cDiscardingType = {m_nTypeBomb= 0,m_nTypeNum= 0,m_nTypeValue = 0};--选中牌的类型
	self.cardsTable = {};
	self.m_vecTipsCards = {};--提醒牌table初始化
end

function PlayCard:CleanUp()
	-- local sortFunc = function(a, b)	
	-- 	if a.m_nValue == self.m_nBaoValue then
	-- 		return true
	-- 	end	
	--     if a.m_nValue * 4 + a.m_nColor > b.m_nValue * 4 + b.m_nColor then
	--     	return true
	--     else 
	--     	return false
	--     end
	-- end
	-- var_dump(self.m_cCards)
	table.sort(self.m_cCards, function(a, b)	
		if a.m_nValue == self.m_nBaoValue and b.m_nValue~=self.m_nBaoValue then
			return true
		elseif 	a.m_nValue ~= self.m_nBaoValue and b.m_nValue==self.m_nBaoValue then
			return false
		end
	    if a.m_nValue * 4 + a.m_nColor > b.m_nValue * 4 + b.m_nColor then
	    	return true
	    else 
	    	return false
	    end
	end)
    
end

function PlayCard:ScandCardTable()
	for i=1,17 do
		self.cardsTable[i] = 0;
	end
	for k,v in pairs(self.m_choose_cCards) do
		if v.m_nValue==self.m_nBaoValue then
			self.cardsTable[17] = self.cardsTable[17]+1;
		else
			self.cardsTable[v.m_nValue] = self.cardsTable[v.m_nValue]+1;
		end

	end
end	

function PlayCard:TipScanCardTable()

	for i=1,17 do
		self.cardsTable[i] = 0;
	end
	for k,v in pairs(self.m_cCards) do
		if v.m_nValue==self.m_nBaoValue then
			self.cardsTable[17] = self.cardsTable[17]+1;
		else
			self.cardsTable[v.m_nValue] = self.cardsTable[v.m_nValue]+1;
		end

	end
end
	
 

-- --判断是否是单顺(拖拉机),此函数适合5-12张牌情况; 
function PlayCard:IsSeries()	
	local nCardsCounter = 0;
	local nMinValue = 17;
	local nTypeValue = 0;		
	local nCounter = 0;		

	-- -- 2,大小王不能参加到顺
	if (self.m_nBaoValue ~= 15) then
		if (self.cardsTable[15] ~= 0) then
			return 0;
		end
	end
	if (self.cardsTable[16] ~= 0) then
		return 0;
	end

	local baopai = 	self.cardsTable[17];
	nCardsCounter = baopai;
	for i=14,3,-1 do 
		nCardsCounter = nCardsCounter+self.cardsTable[i];
		if (self.cardsTable[i] > 1) then
			return 0;
		elseif (self.cardsTable[i] == 1) then
			if i > nTypeValue then
				nTypeValue = i;	
			end
			if i < nMinValue then
				nMinValue = i;	
			end
			nCounter = nCounter+1;
		end
	end
	if nCardsCounter<5 then
		return 0;
	end
 	if (nTypeValue-nMinValue+1) == nCounter then
 		if (baopai>0) then
 			if (nTypeValue+baopai<=14) then
 				return nMinValue --or baopai
 			else
 				return nMinValue-baopai; --or baopai
 			end 			
 			-- 或者
 		else
 			return nMinValue;
 		end
 	else
 		local a_c = (nTypeValue-nMinValue+1)-nCounter;
 		if a_c > baopai then
 			return 0;
 		elseif a_c == baopai then
 			return nMinValue;
 		else
 			if (nTypeValue+baopai-a_c>14) then --or baopai
 				return nMinValue-baopai+a_c;
 			else
 				return nMinValue
 			end
 		end
 	end
 
	 
end

--判断是否是双顺;此函数适合6-20张牌情况;
function PlayCard:IsDoubleSeries() 
	local nCardsCounter = 0;
	local nMinValue = 17;
	local nMaxValue = 0;		
	local nCounter = 0;	
	if (self.m_nBaoValue ~= 15 and self.cardsTable[15] ~= 0) then
		return 0;
	end
	if (self.cardsTable[16] ~= 0) then
		return 0;
	end
	local baopai = self.cardsTable[17];
	nCardsCounter = baopai;
	for i=3,14 do
		nCardsCounter = nCardsCounter+self.cardsTable[i];
		if self.cardsTable[i] == 2 then
			nCounter = nCounter+1;
			if i > nMaxValue then
				nMaxValue = i;	
			end
			if i < nMinValue then
				nMinValue = i;	
			end
		elseif self.cardsTable[i] == 1 then
			if baopai<=0 then
				return 0;
			else
				baopai = baopai-1;
				nCounter = nCounter+1;
				if i > nMaxValue then
					nMaxValue = i;	
				end
				if i < nMinValue then
					nMinValue = i;	
				end
			end
		elseif  self.cardsTable[i] == 3 or self.cardsTable[i] == 4 then
			return 0;
		end
	end	
	
	if nCardsCounter<6 and nCardsCounter%2~=0 then
		return 0
	end
	if (nMaxValue-nMinValue+1)==nCounter then
		if baopai<=0 then

			return nMinValue;
		else
			if baopai%2==0 then
				if nMaxValue>=14 then
					return nMinValue-(baopai/2)
				end
				return nMinValue;-- or baopai
			end
		end
	else 

		local c_a = (nMaxValue-nMinValue+1)-nCounter;
		if  (c_a*2<baopai) then
			if nMaxValue>=14 then
				return nMinValue-((baopai-c_a*2)/2)
			end
			return nMinValue;
		elseif (c_a*2==baopai) then
			return nMinValue;
		else
			return 0;
		end
	end
end

--判断是否是三顺;此函数适合6-18张牌情况;
function PlayCard:IsThreeSeries()
 	local nCardsCounter = 0;
	local nMinValue = 17;
	local nMaxValue = 0;		
	local nCounter = 0;	
	if (self.m_nBaoValue ~= 15 and self.cardsTable[15] ~= 0) then
		return 0;
	end
	if (self.cardsTable[16] ~= 0) then
		return 0;
	end
	local baopai = self.cardsTable[17];
	nCardsCounter = baopai;
	for i=3,14 do		 
		nCardsCounter = nCardsCounter+self.cardsTable[i];
		if self.cardsTable[i]>0 then
			if self.cardsTable[i]+baopai >= 3 and self.cardsTable[i]<4 then
				nCounter = nCounter+1;
				if i > nMaxValue then
					nMaxValue = i;	
				end
				if i < nMinValue then
					nMinValue = i;	
				end
				baopai = baopai-3+self.cardsTable[i];	
			else
				return 0;
			end
		end
	end	
	if nCardsCounter<6 and nCardsCounter%3 ~= 0 then
		return 0
	end
	if (nMaxValue-nMinValue+1)==nCounter then
		if baopai==0 and nCounter>=2 then
			return nMinValue
		else
			if baopai == 3 then
				if (nMaxValue==14) then
					return nMinValue-1;
				else
					return nMinValue;-- or baopai
				end
			end
		end
	else
		local c_a = (nMaxValue-nMinValue+1)-nCounter;
		if  (c_a==1 and baopai==3) then
			return nMinValue;	 
		else
			return 0;
		end
	end	 
end

--判断是否是一对牌;
function PlayCard:Is2()
	local baopai = self.cardsTable[17];
	if baopai==2 then
		return self.m_nBaoValue;
	end
	for i = 3,16 do
		if (self.cardsTable[i] == 2) then
			return i;
		elseif (self.cardsTable[i] == 1 and baopai==1 and i~=16) then
			return i
		end
	end	
	return 0;    --出错,为空牌表;
end

--判断是否是三张;
function PlayCard:Is3()
	local baopai = self.cardsTable[17];
	if baopai==3 then
		return self.m_nBaoValue;
	end
	
	for i = 3,15 do
		-- nCardsCounter = nCardsCounter+self.cardsTable[i];
		if (self.cardsTable[i] == 3) then
			return i;
		elseif (self.cardsTable[i]+baopai == 3) then
			 return i;
		end
	end	
	return 0;    --出错,为空牌表;
end

--判断是否是四张(软炸弹); 
function PlayCard:IsSoftBomb()
 	local baopai = self.cardsTable[17];
 	if baopai == 4 or baopai==0 then
 		return 0;
 	end

	for i = 3,15 do
		if (self.cardsTable[i]+baopai == 4) then
			return i;		
		end
	end	
	return 0;
end

--判断是否是四张(炸弹); 
function PlayCard:IsHardBomb()
	for i = 3,17 do
		if (self.cardsTable[i] == 4) then
			-- if i==17 then
			-- 	return 16;
			-- end
			return i;		
		end
	end	
	return 0;
end

--判断是否是三带一单;
function PlayCard:Is31()
	local baopai = self.cardsTable[17];
	for i = 3,15 do
		if (self.cardsTable[i] == 3) then			
			return i;	
		elseif (self.cardsTable[i] == 2) then
			if baopai>=1 then			
				return i;
			end
		elseif (self.cardsTable[i] == 1) then
			if baopai>=2 then			
				return i;
			end		
		end
	end
	if baopai==3 then
		return self.m_nBaoValue;
	end	 
	
	return 0;
end

--判断是否是三带一对;
function PlayCard:Is32() 
	if (self.cardsTable[16] ~= 0) then
		return 0;
	end
	local nTypeValue = 0;
	local baopai = self.cardsTable[17];
	for i=15,3,-1 do
		local this_cards = self.cardsTable[i];
		if i==self.nBaoCount and baopai==3 then
			this_cards = 3;
			baopai = 0;
		end
		if this_cards>0 and this_cards ~= 4 and this_cards+baopai>=3  then	
			baopai = baopai-3+this_cards;		 
			nTypeValue = i;
			for j=3,15 do
				if (i~=j and self.cardsTable[j]+baopai==2) then
					return nTypeValue;
				end
			end 
		end
	end	
	 	 
	return 0;
end

--判断是否是四带两单;
function PlayCard:Is411() 
	local nTypeValue = 0;
	local nCounter = 0;
	local baopai = self.cardsTable[17];
	if (self.cardsTable[17] == 4) then
		nTypeValue = self.m_nBaoValue;	
		return nTypeValue 
	end		 

	for i=15,3,-1 do
		if (self.cardsTable[i] == 4) then
			return i;	
		elseif (self.cardsTable[i] == 3) then
			if baopai>=1 then
				return i;
			end	
		elseif (self.cardsTable[i] == 2) then
			if baopai>=2 then
				return i;
			end	
		elseif (self.cardsTable[i] == 1) then
			if baopai>=3 then
				return i;
			end		
		end
	end		 
	return 0;
end

--判断是否是三顺带两单;
function PlayCard:Is3311() 
	-- if (self.m_nBaoValue ~= 15 and self.cardsTable[15] == 3) then
	-- 	return 0;
	-- end
	local nCounter = 0;
	local baopai = self.cardsTable[17];
	for i=3,13 do
		if (self.cardsTable[i] >= 3) then			 
			if (self.cardsTable[i+1]+baopai>=3) then
				return i;
			else
				return 0;			
			end
		elseif (self.cardsTable[i] == 2) then
			local ac = baopai;
			 if (ac >= 1) then
			 	ac = ac-1;
			 	if (self.cardsTable[i+1]+ac>=3) then
					return i;
				end
			 end

		elseif (self.cardsTable[i] == 1) then
			local ac = baopai;
			if ac >=2 then
				ac = ac-2;
				if (self.cardsTable[i+1]+ac>=3) then
					return i;
				end				
			end		
		end
	end	

	return 0;
end

--判断是否是四带两对;
function PlayCard:Is422()
 	if (self.cardsTable[16] ~= 0) then
		return 0;
	end
	local nTypeValue = 0;
	local baopai = self.cardsTable[17]
	if (baopai == 4) then
		nTypeValue = self.m_nBaoValue;
		local nNum = 0;
		for i=3,15 do			
			if (self.cardsTable[i] == 2) then
				nNum = nNum+1;
			else
				return 0;				
			end
		end
		 
		if (nNum == 2) then
			return nTypeValue;
		else
			return 0;
		end
	end

	for i = 15,3,-1 do
		if  self.cardsTable[i]>0 and self.cardsTable[i]+baopai>=4  then
			nTypeValue = i;
			local res_baopai = self.cardsTable[i]+baopai-4;
			local nNum = 0;
			for j = 3,15 do
				if (self.cardsTable[j] == 2 or (self.cardsTable[j] == 1 and res_baopai>=1)) then
					if (i ~= j) then
						res_baopai = res_baopai-2+self.cardsTable[j];
						nNum = nNum+1;
					end
				end
			end
			if (nNum == 2) then
				return nTypeValue;
			end
		end
	end	
	return 0;
end

--判断是否是三顺带两对;	
function PlayCard:Is3322()
 
	if (self.cardsTable[16] ~= 0) then
		return 0;
	end
	local nTypeValue = 0;
	

	for i=3,13 do
		local baopai = self.cardsTable[17];
		if self.cardsTable[i]+baopai >= 3 and self.cardsTable[i]~=4 then
			baopai = self.cardsTable[i]+baopai-3;			 
			nTypeValue = i;
			if self.cardsTable[i+1]+baopai >= 3 and self.cardsTable[i]~=4 then
				local nNum = 0;
				for j=3,15 do
					if (self.cardsTable[j] == 2 or (self.cardsTable[j] == 1 and baopai>=1)) then
						if (j ~= i and (j ~= i+1)) then
							nNum = nNum+1;
							baopai = baopai-1;
						end
					end
				end
				if (nNum == 2) then
					return nTypeValue;
				end
			end
		end
	end	

	return 0;
end

--判断是否是三顺带三单;
function PlayCard:Is333111()

	local nTypeValue = 0;
	
	for i=3,12 do
		local baopai = self.cardsTable[17];	 
		if self.cardsTable[i]+baopai  >= 3 and self.cardsTable[i]~=4  then
			nTypeValue = i;
			baopai = self.cardsTable[i]+baopai-3; 
			if (self.cardsTable[i+1]+baopai >= 3 and self.cardsTable[i+1]~=4) then
				baopai = self.cardsTable[i+1]+baopai-3;
				if (self.cardsTable[i+2]+baopai >= 3 and self.cardsTable[i+2]~=4) then							 
					return nTypeValue;
				end
			end
		end
	end
	return 0;
end
 
--判断是否是三顺带三对;
function PlayCard:Is333222()	
 	if (self.cardsTable[16] ~= 0) then
		return 0;
	end
	local nTypeValue = 0;
	for i=3,12 do
		local baopai = self.cardsTable[17];
		-- if (self.cardsTable[i]==4) then
		-- 	return 0;
		-- end
		if self.cardsTable[i]+baopai  >= 3 and self.cardsTable[i]~=4 then
			nTypeValue = i;
			baopai = self.cardsTable[i]+baopai-3; 
			if (self.cardsTable[i+1]+baopai >= 3 and self.cardsTable[i+1]~=4) then
				baopai = self.cardsTable[i+1]+baopai-3;
				if (self.cardsTable[i+2]+baopai >= 3 and self.cardsTable[i+2]~=4) then	
					baopai = self.cardsTable[i+2]+baopai-3;	
					local nNum = 0;					 
					for j=3,15 do
						if (self.cardsTable[j] == 2 or (self.cardsTable[j] == 1 and baopai>=1)) then
							if (j ~= i and (j ~= i+1) and (j ~= i+2)) then
								baopai = self.cardsTable[j]+baopai-2;
								nNum = nNum+1;
							end
						end
					end
					if nNum==3 then
						return nTypeValue
					end
				end
			end
		end
	end
	return 0;
end
	
	 

--判断是否是三顺带四单;
function PlayCard:Is33331111() 
	local nTypeValue = 0; 
	for i=3,11 do
		local baopai = self.cardsTable[17];	 
		if self.cardsTable[i]+baopai  >= 3 and self.cardsTable[i]~=4  then
			nTypeValue = i;
			baopai = self.cardsTable[i]+baopai-3; 
			if (self.cardsTable[i+1]+baopai >= 3  and self.cardsTable[i+1]~=4 ) then
				baopai = self.cardsTable[i+1]+baopai-3;
				if (self.cardsTable[i+2]+baopai >= 3 and self.cardsTable[i+2]~=4) then							 
					baopai = self.cardsTable[i+2]+baopai-3;
					if (self.cardsTable[i+3]+baopai >= 3  and self.cardsTable[i+3]~=4) then							 
						return nTypeValue;
					end
				end
			end
		end
	end
	return 0;
end

-- function PlayCard:New()
-- {
-- 	self.m_nBaoValue = 0;
-- 	m_dwRule = 0/*RULE32|RULE422*/;
-- 	memset(&self.m_cDiscardingType, 0, sizeof(self.m_cDiscardingType));
-- 	memset(self.cardsTable, 0, sizeof(self.cardsTable));
-- 	m_cCards.clear();
-- 	m_choose_cCards.clear();
-- 	m_cDiscarding.clear();
-- 	m_vecTipsCards.clear();
-- }

-- /*
-- * 函数介绍：检查出牌的逻辑合法性;
-- * 返回值 ： 匹配成功返回1,不成功返回0;
-- */
function PlayCard:CheckChoosing(m_nCardType)
	self:ScandCardTable();
	local Table_Index;
 	local m_choose_cCards = self.m_choose_cCards;
 	-- var_dump(self.m_choose_cCards);
    local size = table.getn(m_choose_cCards);
 
	self.m_cDiscardingType = {m_nTypeBomb= 0,m_nTypeNum= 0,m_nTypeValue = 0};
   	if  size == 0 then
   	elseif size == 1 then
   		if ( m_choose_cCards[1].m_nValue == 16 ) then
   			self.m_cDiscardingType.m_nTypeNum = 1;
   			self.m_cDiscardingType.m_nTypeValue = 16+m_choose_cCards[1].m_nColor;
   			return 1;
		else
			self.m_cDiscardingType.m_nTypeNum = 1;
   			self.m_cDiscardingType.m_nTypeValue = m_choose_cCards[1].m_nValue;
   			return 1;
   		end
   	elseif size == 2 then
   		Table_Index = self:Is2();
   		print ("====Table_Index");
   		if ( Table_Index ~= 0 ) then
			--是大王,则为炸弹;
			if (Table_Index == 16) then
				self.m_cDiscardingType.m_nTypeBomb = 2;
				self.m_cDiscardingType.m_nTypeNum = 4;
   				self.m_cDiscardingType.m_nTypeValue = 16;
   				return 1;
			else
				self.m_cDiscardingType.m_nTypeBomb = 0;
				self.m_cDiscardingType.m_nTypeNum = 2;
   				self.m_cDiscardingType.m_nTypeValue = Table_Index;
   				if self.m_nBaoValue~=0 then
   					if self.cardsTable[17]==1 then
   						for k,v in pairs(self.m_choose_cCards) do
   							if v.m_nValue == self.m_nBaoValue then
   								v.m_nCard_Baovalue = Table_Index
   								break;
   							end
   						end
   					end

   				end
   				return 1;
   			end
   		end
	elseif size == 3 then
		Table_Index = self:Is3()
		if ( Table_Index ~= 0 ) then
			self.m_cDiscardingType.m_nTypeBomb = 0;
			self.m_cDiscardingType.m_nTypeNum = 3;
			self.m_cDiscardingType.m_nTypeValue = Table_Index;
			if self.m_nBaoValue~=0 then
				if self.cardsTable[17]==1 or self.cardsTable[17]==2 then
					for k,v in pairs(self.m_choose_cCards) do
						if v.m_nValue == self.m_nBaoValue then
							v.m_nCard_Baovalue = Table_Index
						end
					end
				end

			end
			return 1;
		end
	elseif size == 4 then
		Table_Index = self:IsHardBomb();
		if ( Table_Index ~= 0 ) then
			self.m_cDiscardingType.m_nTypeBomb = 2;
			self.m_cDiscardingType.m_nTypeNum = 4;
			self.m_cDiscardingType.m_nTypeValue = Table_Index;
			return 1;
		end
		Table_Index = self:IsSoftBomb();
		if ( Table_Index ~= 0 ) then
			-- self.m_cDiscardingType.SetValue(1,4,Table_Index);
			self.m_cDiscardingType.m_nTypeBomb = 1;
			self.m_cDiscardingType.m_nTypeNum = 4;
			self.m_cDiscardingType.m_nTypeValue = Table_Index;
			if self.cardsTable[17]>=1 and self.cardsTable[17]<=3 then
				for k,v in pairs(self.m_choose_cCards) do
					if v.m_nValue == self.m_nBaoValue then
						v.m_nCard_Baovalue = Table_Index
					end
				end
			end
			return 1;
		end
		Table_Index = self:Is31()
		if ( Table_Index ~= 0 ) then
			self.m_cDiscardingType.m_nTypeBomb = 0;
			self.m_cDiscardingType.m_nTypeNum = 31;
			self.m_cDiscardingType.m_nTypeValue = Table_Index;
			if self.cardsTable[17]>=1 and self.cardsTable[17]<=2 then
				if self.cardsTable[Table_Index]<3 then
					local num = 3-self.cardsTable[Table_Index]
					for k,v in pairs(self.m_choose_cCards) do
						if v.m_nValue == self.m_nBaoValue then
							v.m_nCard_Baovalue = Table_Index
							num = num-1;
							if num==0 then
								break;
							end
						end
					end
				end
			end
			return 1;
		end
		
	elseif size == 5 then

		Table_Index = self:IsSeries()
		
		if ( Table_Index ~= 0 ) then
			self.m_cDiscardingType.m_nTypeBomb = 0;
			self.m_cDiscardingType.m_nTypeNum = 5;
			self.m_cDiscardingType.m_nTypeValue = Table_Index;
			self:ChangeBaoValuesforSendcard(Table_Index,size,1)
			return 1;
		end		
		Table_Index = self:Is32()
		if ( Table_Index ~= 0 ) then
			self.m_cDiscardingType.m_nTypeBomb = 0;
			self.m_cDiscardingType.m_nTypeNum = 32;
			self.m_cDiscardingType.m_nTypeValue = Table_Index;

			if self.cardsTable[17]>=1 then
				local changecards = {}
				
				local thisnum = 3-self.cardsTable[Table_Index]	
				if thisnum>0 then
					for i=1,thisnum do
						table.insert(changecards,Table_Index)
					end
				end	
				if self.cardsTable[17]>3-self.cardsTable[Table_Index] then
					if self.cardsTable[17]-3+self.cardsTable[Table_Index]==1 then
						for k,v in pairs(self.m_choose_cCards) do
							if v.m_nValue ~= self.m_nBaoValue and v.m_nValue ~= Table_Index then
								table.insert(changecards,v.m_nValue)
								break;
							end
						end	
					end
				end
				
				self:ChangecarddisValue(changecards)
			end
			return 1;
		end	
		return 0;
	elseif size == 6 then
		Table_Index = self:IsDoubleSeries();
		if ( Table_Index ~= 0 ) then
			if (m_nCardType == 222 or m_nCardType==0) then

				-- self.m_cDiscardingType.SetValue(0,222,Table_Index);
				self.m_cDiscardingType.m_nTypeBomb = 0;
				self.m_cDiscardingType.m_nTypeNum = 222;
				self.m_cDiscardingType.m_nTypeValue = Table_Index;
				self:ChangeBaoValuesforSendcard(Table_Index,size,2)
				return 1;
			end
		end
		Table_Index = self:Is411();
		if ( Table_Index ~= 0 ) then
			if (m_nCardType == 411 or m_nCardType==0) then
				-- self.m_cDiscardingType.SetValue(0,411,Table_Index);
				self.m_cDiscardingType.m_nTypeBomb = 0;
				self.m_cDiscardingType.m_nTypeNum = 411;
				self.m_cDiscardingType.m_nTypeValue = Table_Index;
				if self.cardsTable[17]>=1 then
					if self.cardsTable[Table_Index]<4 then
						local num = 4-self.cardsTable[Table_Index]
						for k,v in pairs(self.m_choose_cCards) do
							if v.m_nValue == self.m_nBaoValue then
								v.m_nCard_Baovalue = Table_Index
								num = num-1;
								if num==0 then
									break;
								end
							end
							
						end
					end			
				end
				return 1;
			end
		end
		Table_Index = self:IsThreeSeries();
		if ( Table_Index ~= 0) then
			if (m_nCardType == 33 or m_nCardType==0) then
				-- self.m_cDiscardingType.SetValue(0,33,Table_Index);
				self.m_cDiscardingType.m_nTypeBomb = 0;
				self.m_cDiscardingType.m_nTypeNum = 33;
				self.m_cDiscardingType.m_nTypeValue = Table_Index;
				self:ChangeBaoValuesforSendcard(Table_Index,size,3)
				return 1;
			end
		end
		Table_Index = self:IsSeries()
		if ( Table_Index ~= 0 ) then
			if (m_nCardType == 6 or m_nCardType==0) then
				-- self.m_cDiscardingType.SetValue(0,6,Table_Index);
				self.m_cDiscardingType.m_nTypeBomb = 0;
				self.m_cDiscardingType.m_nTypeNum = 6;
				self.m_cDiscardingType.m_nTypeValue = Table_Index;
				self:ChangeBaoValuesforSendcard(Table_Index,size,1)

				return 1;
			end
		end	
		return 0;	
	elseif size == 7 then
		Table_Index = self:IsSeries()
		if ( Table_Index ~= 0 ) then
			self.m_cDiscardingType.m_nTypeBomb = 0;
			self.m_cDiscardingType.m_nTypeNum = 7;
			self.m_cDiscardingType.m_nTypeValue = Table_Index;
			
			self:ChangeBaoValuesforSendcard(Table_Index,size,1)
			return 1;
		end
		return 0;
	elseif size == 8 then		 
		Table_Index = self:Is422()
		if ( Table_Index ~= 0 ) then
			if (m_nCardType == 422 or m_nCardType==0) then
				self.m_cDiscardingType.m_nTypeBomb = 0;
				self.m_cDiscardingType.m_nTypeNum = 422;
				self.m_cDiscardingType.m_nTypeValue = Table_Index;

				if self.cardsTable[17]>=1 then
					local changecards = {}
					

					for k,v in pairs(self.m_choose_cCards) do
						if v.m_nValue ~= Table_Index and v.m_nValue ~= self.m_nBaoValue then
							if self.cardsTable[v.m_nValue]==1 then
								table.insert(changecards,v.m_nValue)
							end
						end
					end	
					local thisnum = 4-self.cardsTable[Table_Index]	
					if thisnum>=1 then
						for i=1,thisnum do
							table.insert(changecards,Table_Index)
						end
					end	
					local num = 1
					for k,v in pairs(self.m_choose_cCards) do
						if v.m_nValue == self.m_nBaoValue then
							if changecards[num]==nil then
								break;
							end
							v.m_nCard_Baovalue = changecards[num]
							num = num+1;
							
						end
					end	
				end
				return 1;
			end
			
		end
		Table_Index = self:Is3311()
		if ( Table_Index ~= 0 ) then
			if (m_nCardType == 3311 or m_nCardType==0) then
				self.m_cDiscardingType.m_nTypeBomb = 0;
				self.m_cDiscardingType.m_nTypeNum = 3311;
				self.m_cDiscardingType.m_nTypeValue = Table_Index;
				self:ChangeBaoValuesforSendcard(Table_Index,size,3)
				return 1;
			end
		end
		Table_Index = self:IsDoubleSeries()
		if ( Table_Index ~= 0 ) then
			if (m_nCardType == 2222 or m_nCardType==0) then
				self.m_cDiscardingType.m_nTypeBomb = 0;
				self.m_cDiscardingType.m_nTypeNum = 2222;
				self.m_cDiscardingType.m_nTypeValue = Table_Index;
				self:ChangeBaoValuesforSendcard(Table_Index,size,2)
				return 1;
			end
		end
		Table_Index = self:IsSeries()
		if ( Table_Index ~= 0 ) then
			if (m_nCardType == 8 or m_nCardType==0) then
				self.m_cDiscardingType.m_nTypeBomb = 0;
				self.m_cDiscardingType.m_nTypeNum = 8;
				self.m_cDiscardingType.m_nTypeValue = Table_Index;
				self:ChangeBaoValuesforSendcard(Table_Index,size,1)
				return 1;
			end
		end
		return 0;
	elseif size == 9 then		
		Table_Index = self:IsThreeSeries()
		if ( Table_Index ~= 0 ) then
			if (m_nCardType == 333 or m_nCardType==0) then
				self.m_cDiscardingType.m_nTypeBomb = 0;
				self.m_cDiscardingType.m_nTypeNum = 333;
				self.m_cDiscardingType.m_nTypeValue = Table_Index;
				self:ChangeBaoValuesforSendcard(Table_Index,size,3)
				return 1;
			end
		end
		Table_Index = self:IsSeries()
		if ( Table_Index ~= 0 ) then
			if (m_nCardType == 9 or m_nCardType==0) then
				self.m_cDiscardingType.m_nTypeBomb = 0;
				self.m_cDiscardingType.m_nTypeNum = 9;
				self.m_cDiscardingType.m_nTypeValue = Table_Index;
				self:ChangeBaoValuesforSendcard(Table_Index,size,1)
				return 1;
			end
		end		
		return 0;
	elseif size == 10 then
		Table_Index = self:Is3322()
		if ( Table_Index ~= 0 ) then
			if (m_nCardType == 3322 or m_nCardType==0) then
				self.m_cDiscardingType.m_nTypeBomb = 0;
				self.m_cDiscardingType.m_nTypeNum = 3322;
				self.m_cDiscardingType.m_nTypeValue = Table_Index;
				if self.cardsTable[17]>=1 then
					local changecards = {}
					for k,v in pairs(self.m_choose_cCards) do
						if v.m_nValue ~= Table_Index and v.m_nValue ~= self.m_nBaoValue and v.m_nValue ~= Table_Index+1 then
							if self.cardsTable[v.m_nValue]==1 then
								table.insert(changecards,v.m_nValue)
							end
						end
					end	
					local thisnum = 3-self.cardsTable[Table_Index]	
					if thisnum>=1 then
						for i=1,thisnum do
							table.insert(changecards,Table_Index)
						end
					end	
					local thisnum = 3-self.cardsTable[Table_Index+1]	
					if thisnum>=1 then
						for i=1,thisnum do
							table.insert(changecards,Table_Index+1)
						end
					end	
					local num = 1
					for k,v in pairs(self.m_choose_cCards) do
						if v.m_nValue == self.m_nBaoValue then
							if changecards[num]==nil then
								break;
							end
							v.m_nCard_Baovalue = changecards[num]
							num = num+1;
							
						end
					end	
				end
				return 1;
			end
		end
		Table_Index = self:IsDoubleSeries()
		if ( Table_Index ~= 0 ) then
			if (m_nCardType == 22222 or m_nCardType==0) then
				self.m_cDiscardingType.m_nTypeBomb = 0;
				self.m_cDiscardingType.m_nTypeNum = 22222;
				self.m_cDiscardingType.m_nTypeValue = Table_Index;
				self:ChangeBaoValuesforSendcard(Table_Index,size,2)
				return 1;
			end
		end	
		Table_Index = self:IsSeries()
		if ( Table_Index ~= 0 ) then
			if (m_nCardType == 10 or m_nCardType==0) then
				self.m_cDiscardingType.m_nTypeBomb = 0;
				self.m_cDiscardingType.m_nTypeNum = 10;
				self.m_cDiscardingType.m_nTypeValue = Table_Index;
				self:ChangeBaoValuesforSendcard(Table_Index,size,1)
				return 1;
			end
		end		
		return 0;			
	elseif size == 11 then
		Table_Index = self:IsSeries()
		if ( Table_Index ~= 0 ) then
			if (m_nCardType == 1 or m_nCardType==0) then
				self.m_cDiscardingType.m_nTypeBomb = 0;
				self.m_cDiscardingType.m_nTypeNum = 11;
				self.m_cDiscardingType.m_nTypeValue = Table_Index;
				self:ChangeBaoValuesforSendcard(Table_Index,size,1)
				return 1;
			end
		end		
		return 0;
	elseif size == 12 then
		Table_Index = self:IsThreeSeries()
		if ( Table_Index ~= 0 ) then
			if (m_nCardType == 3333 or m_nCardType==0) then
				self.m_cDiscardingType.m_nTypeBomb = 0;
				self.m_cDiscardingType.m_nTypeNum = 3333;
				self.m_cDiscardingType.m_nTypeValue = Table_Index;
				self:ChangeBaoValuesforSendcard(Table_Index,size,3)
				return 1;
			end
		end
		Table_Index = self:Is333111()
		if ( Table_Index ~= 0 ) then
			if (m_nCardType == 333111 or m_nCardType==0) then
				self.m_cDiscardingType.m_nTypeBomb = 0;
				self.m_cDiscardingType.m_nTypeNum = 333111;
				self.m_cDiscardingType.m_nTypeValue = Table_Index;
				self:ChangeBaoValuesforSendcard(Table_Index,9,3)
				return 1;
			end
		end	
		Table_Index = self:IsDoubleSeries()
		if ( Table_Index ~= 0 ) then
			if (m_nCardType == 222222 or m_nCardType==0) then
				self.m_cDiscardingType.m_nTypeBomb = 0;
				self.m_cDiscardingType.m_nTypeNum = 222222;
				self.m_cDiscardingType.m_nTypeValue = Table_Index;
				self:ChangeBaoValuesforSendcard(Table_Index,size,2)
				return 1;
			end
		end	
		Table_Index = self:IsSeries()
		if ( Table_Index ~= 0 ) then
			if (m_nCardType == 12 or m_nCardType==0) then
				self.m_cDiscardingType.m_nTypeBomb = 0;
				self.m_cDiscardingType.m_nTypeNum = 12;
				self.m_cDiscardingType.m_nTypeValue = Table_Index;
				self:ChangeBaoValuesforSendcard(Table_Index,size,1)
				return 1;
			end
		end		
		return 0;		
	elseif size == 13 then
		return 0;
	elseif size == 14 then
		
		Table_Index = self:IsDoubleSeries()
		if ( Table_Index ~= 0 ) then
			if (m_nCardType == 2222222 or m_nCardType==0) then
				self.m_cDiscardingType.m_nTypeBomb = 0;
				self.m_cDiscardingType.m_nTypeNum = 2222222;
				self.m_cDiscardingType.m_nTypeValue = Table_Index;
				self:ChangeBaoValuesforSendcard(Table_Index,size,2)
				return 1;
			end
		end	 
		return 0;
	elseif size == 15 then
		Table_Index = self:Is333222()
		if ( Table_Index ~= 0 ) then
			if (m_nCardType == 333222 or m_nCardType==0) then
				self.m_cDiscardingType.m_nTypeBomb = 0;
				self.m_cDiscardingType.m_nTypeNum = 333222;
				self.m_cDiscardingType.m_nTypeValue = Table_Index;
				if self.cardsTable[17]>=1 then
					local changecards = {}
					for k,v in pairs(self.m_choose_cCards) do
						if  (v.m_nValue < Table_Index or v.m_nValue>Table_Index+3)  and v.m_nValue ~= self.m_nBaoValue then
							if self.cardsTable[v.m_nValue]==1 then
								table.insert(changecards,v.m_nValue)
							end
						end
					end	
					for i=1,3 do
						local thisnum = 3-self.cardsTable[Table_Index+i-1]	
						if thisnum>=1 then
							for i=1,thisnum do
								table.insert(changecards,Table_Index+i-1)
							end
						end	
					end
					
					local num = 1
					for k,v in pairs(self.m_choose_cCards) do
						if v.m_nValue == self.m_nBaoValue then
							if changecards[num]==nil then
								break;
							end
							v.m_nCard_Baovalue = changecards[num]
							num = num+1;
							
						end
					end	
				end
				return 1;
			end
		end	 
		Table_Index = self:IsThreeSeries()
		if ( Table_Index ~= 0 ) then
			if (m_nCardType == 33333 or m_nCardType==0) then
				self.m_cDiscardingType.m_nTypeBomb = 0;
				self.m_cDiscardingType.m_nTypeNum = 33333;
				self.m_cDiscardingType.m_nTypeValue = Table_Index;
				self:ChangeBaoValuesforSendcard(Table_Index,size,3)
				return 1;
			end
		end	
		return 0;
		
	elseif size == 16 then
		Table_Index = self:Is33331111()
		if ( Table_Index ~= 0 ) then
			if (m_nCardType == 33331111 or m_nCardType==0) then
				self.m_cDiscardingType.m_nTypeBomb = 0;
				self.m_cDiscardingType.m_nTypeNum = 33331111;
				self.m_cDiscardingType.m_nTypeValue = Table_Index;
				self:ChangeBaoValuesforSendcard(Table_Index,12,3)
				return 1;
			end
		end	 
		Table_Index = self:IsDoubleSeries()
		if ( Table_Index ~= 0 ) then
			if (m_nCardType == 22222222 or m_nCardType==0) then
				self.m_cDiscardingType.m_nTypeBomb = 0;
				self.m_cDiscardingType.m_nTypeNum = 22222222;
				self.m_cDiscardingType.m_nTypeValue = Table_Index;
				self:ChangeBaoValuesforSendcard(Table_Index,size,2)
				return 1;
			end
		end	
		return 0;
		
	elseif size == 17 then
		return 0;
	elseif size == 18 then
		Table_Index = self:IsThreeSeries()
		if ( Table_Index ~= 0 ) then
			if (m_nCardType == 333333 or m_nCardType==0) then
				self.m_cDiscardingType.m_nTypeBomb = 0;
				self.m_cDiscardingType.m_nTypeNum = 333333;
				self.m_cDiscardingType.m_nTypeValue = Table_Index;
				self:ChangeBaoValuesforSendcard(Table_Index,size,3)
				return 1;
			end
		end	 
		Table_Index = self:IsDoubleSeries()
		if ( Table_Index ~= 0 ) then
			if (m_nCardType == 222222222 or m_nCardType==0) then
				self.m_cDiscardingType.m_nTypeBomb = 0;
				self.m_cDiscardingType.m_nTypeNum = 222222222;
				self.m_cDiscardingType.m_nTypeValue = Table_Index;
				self:ChangeBaoValuesforSendcard(Table_Index,size,2)
				return 1;
			end
		end	
		return 0;		
		
	elseif size == 19 then
		return 0;
	elseif size == 20 then
		Table_Index = self:IsDoubleSeries()
		if ( Table_Index ~= 0 ) then
			if (m_nCardType == 2000000000 or m_nCardType==0) then
				self.m_cDiscardingType.m_nTypeBomb = 0;
				self.m_cDiscardingType.m_nTypeNum = 2000000000;
				self.m_cDiscardingType.m_nTypeValue = Table_Index;
				self:ChangeBaoValuesforSendcard(Table_Index,size,2)
				return 1;
			end
		end	 
		return 0;
	else
		return 0;
	end
	return 0;
end

function PlayCard:ChangecarddisValue(changecards)

	local num = 1
	for k,v in pairs(self.m_choose_cCards) do
		if v.m_nValue == self.m_nBaoValue then
			if changecards[num]==nil then
				break;
			end
			v.m_nCard_Baovalue = changecards[num]
			num = num+1;
			
		end
	end	
end
--出牌时判断赖子牌并显示
function PlayCard:ChangeBaoValuesforSendcard(Table_Index,size,cNum)
	local changecards = {};
	if self.cardsTable[17]>=1 then
		local thisnum = math.floor(size/cNum)
		for i=1,thisnum do
			if self.cardsTable[Table_Index+i-1]<cNum then
				for j=1,cNum-self.cardsTable[Table_Index+i-1] do
					table.insert(changecards,Table_Index+i-1)
				end
			end
		end	
		self:ChangecarddisValue(changecards)		
	end
end

function PlayCard:CompareCards(cardType)
	if ( self.m_cDiscardingType.m_nTypeNum == 0 ) then
		return 0; --出牌不合法
	end
	if ( cardType.m_nTypeNum == 0 ) then
		return 1; --玩家首次出牌的时候
	end

	--大小判断;
	if (self.m_cDiscardingType.m_nTypeBomb > cardType.m_nTypeBomb) then
		return 1;
	elseif self.m_cDiscardingType.m_nTypeBomb == cardType.m_nTypeBomb then
		if self.m_cDiscardingType.m_nTypeNum==16 then
			return 1;
		end
		if self.m_cDiscardingType.m_nTypeNum == cardType.m_nTypeNum then
			if self.m_cDiscardingType.m_nTypeValue >  cardType.m_nTypeValue then
				return 1;
			end
		end
		return 0;
	else
		return 0;
	end
	 
	return 0;
end



function PlayCard:GetBomb()
	self:ScandCardTable();
	local nBomb = 0;
	for i=1,17 do
		if ( self.cardsTable[i] == 4 ) then
			nBomb = nBomb+1;
		end
	end
	 
	if ( self.cardsTable[16] == 2 ) then
		nBomb = nBomb+1;
	end
	return nBomb;
end

-- function PlayCard:TipScanCardTable()
-- {
-- 	--初始化扫描表
-- 	memset(self.cardsTable, 0, sizeof(self.cardsTable));
-- 	--扫描进表中;
-- 	for(local i = 0; i < m_cCards.size(); i++)
-- 	{
-- 		self.cardsTable[(local)m_cCards[i].m_nValue]++;
-- 	}
-- }

-- function PlayCard:Tips()
-- {
-- 	--初始化扫描表
-- 	m_vecTipsCards.clear();
-- 	TipScanCardTable();
-- 	--从单张牌开始提示
-- 	for(local i = 1; i <= 4; i++)
-- 	{
-- 		for(local j = 0; j <= 16; j++)
-- 		{
-- 			if ( self.cardsTable[j] == i || (j == 16 and self.cardsTable[j] == i and i == 1) )
-- 			{
-- 				VECCARD vecCard;
-- 				CCard cCard(0,j);
-- 				for(local n = 0; n < i; n++)
-- 				{
-- 					vecCard.push_back(cCard);
-- 				}
-- 				table.insert(self.m_vecTipsCards,vecCard);
-- 			}
-- 		}
-- 	}
-- 	--2个王
-- 	if ( self.cardsTable[16] == 2 )
-- 	{
-- 		CCard cCard(0,16);
-- 		VECCARD vecCard;
-- 		vecCard.push_back(cCard);
-- 		vecCard.push_back(cCard);
-- 		table.insert(self.m_vecTipsCards,vecCard);
-- 	}
-- 	return 0;
-- }
--清除提醒牌table
 

function PlayCard:TipsCom()
	self.m_vecTipsCards = {};--清除提醒牌
 	self:TipScanCardTable();
 	local flag = 0
 	for m=1,4 do
	 	for i=3,16 do	
	 		local vecCard ={};	
	 		local card ={m_nColor=-1,m_nValue=-1,m_nCard_Baovalue=-1};
			local cardNum = self.cardsTable[i];
			if i == self.m_nBaoValue then
				cardNum = self.cardsTable[17];
			end
			if (cardNum == m) then 
				card = {m_nColor=-1,m_nValue=i,m_nCard_Baovalue=-1};
				for j=1,m do
					table.insert(vecCard,card);
				end
				table.insert(self.m_vecTipsCards,vecCard);
				flag = 1;
			end
		end
		if flag==1 then
			break
		end
	end

end

--出牌提示
function PlayCard:Tips(cCardsType)
	local nRet = 0;
	self.m_vecTipsCards = {};--清除提醒牌
 	self:TipScanCardTable();
	local typNum = cCardsType.m_nTypeNum;
	print("==================================".. typNum);
	if typNum == 1 then nRet = self:TipsSearch1(cCardsType);
	elseif typNum == 2 then nRet = self:TipsSearch2(cCardsType);
	elseif typNum == 3 then nRet = self:TipsSearch3(cCardsType);
	elseif typNum == 4 then nRet = self:TipsSearch4(cCardsType);
	elseif typNum == 5 then nRet = self:TipsSearchSeries(cCardsType,5);
	elseif typNum == 6 then nRet = self:TipsSearchSeries(cCardsType,6);
	elseif typNum == 7 then nRet = self:TipsSearchSeries(cCardsType,7);
	elseif typNum == 8 then nRet = self:TipsSearchSeries(cCardsType,8);
	elseif typNum == 9 then nRet = self:TipsSearchSeries(cCardsType,9);
	elseif typNum == 10 then nRet = self:TipsSearchSeries(cCardsType,10);
	elseif typNum == 11 then nRet = self:TipsSearchSeries(cCardsType,11);
	elseif typNum == 12 then nRet = self:TipsSearchSeries(cCardsType,12);
	elseif typNum == 31 then nRet = self:TipsSearch31(cCardsType);
	elseif typNum == 32 then nRet = self:TipsSearch32(cCardsType);
	elseif typNum == 33 then nRet = self:TipsSearchThreeSeries(cCardsType,2);
	elseif typNum == 222 then nRet = self:TipsSearchDoubleSeries(cCardsType,3);
	elseif typNum == 333 then nRet = self:TipsSearchThreeSeries(cCardsType,3);
	elseif typNum == 411 then nRet = self:TipsSearch411(cCardsType);
	elseif typNum == 422 then nRet = self:TipsSearch422(cCardsType);
	elseif typNum == 2222 then nRet = self:TipsSearchDoubleSeries(cCardsType,4);
	elseif typNum == 3322 then nRet = self:TipsSearch3322(cCardsType);
	elseif typNum == 3333 then nRet = self:TipsSearchThreeSeries(cCardsType,4);
	elseif typNum == 3311 then nRet = self:TipsSearch3311(cCardsType);
	elseif typNum == 22222 then nRet = self:TipsSearchDoubleSeries(cCardsType,5);
	elseif typNum == 33333 then nRet = self:TipsSearchThreeSeries(cCardsType,5);
	elseif typNum == 222222 then nRet = self:TipsSearchDoubleSeries(cCardsType,6);
	elseif typNum == 333111 then nRet = self:TipsSearch333111(cCardsType);
	elseif typNum == 333222 then nRet = self:TipsSearch333222(cCardsType);
	elseif typNum == 333333 then nRet = self:TipsSearchThreeSeries(cCardsType,6);
	elseif typNum == 2222222 then nRet = self:TipsSearchDoubleSeries(cCardsType,7);
	elseif typNum == 22222222 then nRet = self:TipsSearchDoubleSeries(cCardsType,8);
	elseif typNum == 33331111 then nRet = self:TipsSearch33331111(cCardsType);
	elseif typNum == 222222222 then nRet = self:TipsSearchDoubleSeries(cCardsType,9);	
	end

	 

	if ( cCardsType.m_nTypeBomb == 0 ) then
		local card = {};
		local vecCard = {};
		--炸弹
		for i=3,15 do
			
			if (self.cardsTable[i]+self.cardsTable[17] >= 4 and self.cardsTable[i]>0 and self.cardsTable[i]<4) then
			--软炸弹	
				-- m_nColor(-1), m_nValue(-1), m_nCard_Baovalue(-1)
				
				vecCard = {};
				card = {m_nColor=-1,m_nValue=i,m_nCard_Baovalue=-1};
				for j=1,self.cardsTable[i] do
					table.insert(vecCard,card);
				end
				card = {m_nColor=-1,m_nValue=self.m_nBaoValue,m_nCard_Baovalue=i};
				for j=1,4-self.cardsTable[i] do				
					table.insert(vecCard,card);
				end
				table.insert(self.m_vecTipsCards,vecCard);
			end
		end
		for i=3,17 do
			
			if (self.cardsTable[i] == 4) then
			--硬炸弹	
				-- m_nColor(-1), m_nValue(-1), m_nCard_Baovalue(-1)
				
				vecCard = {};
				card = {m_nColor=-1,m_nValue=i,m_nCard_Baovalue=-1};
				table.insert(vecCard,card);
				table.insert(vecCard,card);
				table.insert(vecCard,card);
				table.insert(vecCard,card);
				table.insert(self.m_vecTipsCards,vecCard);
			end
		end
		--对鬼
		if (self.cardsTable[16] == 2) then
			 
			vecCard = {};
			 
			card = {m_nColor=0,m_nValue=16,m_nCard_Baovalue=-1};
			table.insert(vecCard,card);
			card = {m_nColor=1,m_nValue=16,m_nCard_Baovalue=-1};
			table.insert(vecCard,card);
			table.insert(self.m_vecTipsCards,vecCard);
		end
	end
	return nRet;
end

-- 在客户端使用，保存符合规则的各种组合
function PlayCard:TipsSearch1(cCardsType)
	local vecCard = {};
	local nBegin = cCardsType.m_nTypeValue + 1;	
	local card = {m_nColor=-1,m_nValue=-1,m_nCard_Baovalue=-1};
	for k,v in pairs(self.m_cCards) do
		vecCard = {};
		local card = {m_nColor=-1,m_nValue=-1,m_nCard_Baovalue=-1};
		if (v.m_nValue == 16 and v.m_nColor == 1 and cCardsType.m_nTypeValue==16) then				
			card = {m_nColor=1,m_nValue=16,m_nCard_Baovalue=-1};
			table.insert(vecCard,card);
			table.insert(self.m_vecTipsCards,vecCard);
		end		
	end 
	for i=nBegin,16 do
		vecCard = {};
		local cardNum = self.cardsTable[i];
		if i == self.m_nBaoValue then
			cardNum = self.cardsTable[17];
		end
		if (cardNum == 1) then			

			card = {m_nColor=-1,m_nValue=i,m_nCard_Baovalue=-1};
			table.insert(vecCard,card);
			table.insert(self.m_vecTipsCards,vecCard);
		end
	end
	 
	for i=nBegin,16 do
		vecCard = {};
		local cardNum = self.cardsTable[i];
		if i == self.m_nBaoValue then
			cardNum = self.cardsTable[17];
		end
		if (cardNum > 1) then			
			card = {m_nColor=-1,m_nValue=i,m_nCard_Baovalue=-1};
			table.insert(vecCard,card);
			table.insert(self.m_vecTipsCards,vecCard);
		end
	end	 
	
	-- self.m_vecTipsCards = vecCard;
	return 0;
end

function PlayCard:TipsSearch2(cCardsType)
	local nBegin = cCardsType.m_nTypeValue + 1;
	local card = {m_nColor=-1,m_nValue=-1,m_nCard_Baovalue=-1};
	local vecCard = {};
	
	
	for i=nBegin,15 do
		vecCard = {};
		if (self.cardsTable[i]== 2) then				 
			card = {m_nColor=-1,m_nValue=i,m_nCard_Baovalue=-1};
			table.insert(vecCard,card);
			table.insert(vecCard,card);
			table.insert(self.m_vecTipsCards,vecCard);
		end
	end
  	local nBaoCount = self.cardsTable[17];
	for i=nBegin,15 do
		vecCard = {};
		if (i == self.m_nBaoValue and nBaoCount>=2) then
		 
			card = {m_nColor=-1,m_nValue=self.m_nBaoValue,m_nCard_Baovalue=i};
			table.insert(vecCard,card);
			table.insert(vecCard,card);
			-- card.m_nCard_Baovalue = -1;
			table.insert(self.m_vecTipsCards,vecCard);
		else			
			if (self.cardsTable[i]==1 and nBaoCount>0) then
				-- card.m_nValue = i;
				card = {m_nColor=-1,m_nValue=i,m_nCard_Baovalue=-1};
				table.insert(vecCard,card);				
				card = {m_nColor=-1,m_nValue=self.m_nBaoValue,m_nCard_Baovalue=i};
				table.insert(vecCard,card);
				table.insert(self.m_vecTipsCards,vecCard);
			elseif self.cardsTable[i] ==3 then
				-- card.m_nValue = i;
				card = {m_nColor=-1,m_nValue=i,m_nCard_Baovalue=-1};
				table.insert(vecCard,card);
				table.insert(vecCard,card);
				table.insert(self.m_vecTipsCards,vecCard);
			end
		end 		 	
	end
	 
	return 0;
end

function PlayCard:TipsSearch3(cCardsType)
	local nBegin = cCardsType.m_nTypeValue + 1;
	local card = {m_nColor=-1,m_nValue=-1,m_nCard_Baovalue=-1};
	local vecCard = {};
	local nBaoCount = self.cardsTable[17];
	for i=nBegin,15 do
		vecCard = {};
		if (i == self.m_nBaoValue and nBaoCount>=3) then
			card = {m_nColor=-1,m_nValue=self.m_nBaoValue,m_nCard_Baovalue=i};
			table.insert(vecCard,card);
			table.insert(vecCard,card);
			table.insert(vecCard,card);
			table.insert(self.m_vecTipsCards,vecCard);
			card.m_nCard_Baovalue = -1;
		else
			if (self.cardsTable[i]+nBaoCount >= 3 and self.cardsTable[i]>0 and self.cardsTable[i]~=4 ) then
				if (self.cardsTable[i]==1) then
					card = {m_nColor=-1,m_nValue=i,m_nCard_Baovalue=-1};
					table.insert(vecCard,card);
					card = {m_nColor=-1,m_nValue=self.m_nBaoValue,m_nCard_Baovalue=i};
					table.insert(vecCard,card);
					table.insert(vecCard,card);
					table.insert(self.m_vecTipsCards,vecCard);
				elseif self.cardsTable[i] ==2 then
					card = {m_nColor=-1,m_nValue=i,m_nCard_Baovalue=-1};
					table.insert(vecCard,card);
					table.insert(vecCard,card);
					card = {m_nColor=-1,m_nValue=self.m_nBaoValue,m_nCard_Baovalue=i};
					table.insert(vecCard,card);
					
					table.insert(self.m_vecTipsCards,vecCard);
				elseif self.cardsTable[i] >=3 then
					card = {m_nColor=-1,m_nValue=i,m_nCard_Baovalue=-1};
					table.insert(vecCard,card);
					table.insert(vecCard,card);
					table.insert(vecCard,card);
					table.insert(self.m_vecTipsCards,vecCard);
				end
			end
		end 		 	
	end
	return 0;
end

function PlayCard:TipsSearch4(cCardsType)
	local nBegin = cCardsType.m_nTypeValue + 1;
	local card = {m_nColor=-1,m_nValue=-1,m_nCard_Baovalue=-1};
	local vecCard = {};
	local nBaoCount = self.cardsTable[17];
	if (cCardsType.m_nTypeNum == 4) then
		if (cCardsType.m_nTypeBomb == 1) then
			for i = nBegin,15 do	
				vecCard = {};			 
				if (self.cardsTable[i]>0 and self.cardsTable[i]~=4 and self.cardsTable[i] + nBaoCount >= 4) then
					card = {m_nColor=-1,m_nValue=i,m_nCard_Baovalue=-1};
					for j=1,self.cardsTable[i] do
						table.insert(vecCard,card); 
					end	
					local nUserBaocount = 4-self.cardsTable[i];
					if nUserBaocount>=1 then
						card = {m_nColor=-1,m_nValue=self.m_nBaoValue,m_nCard_Baovalue=i};
						for n=1,nUserBaocount do
							table.insert(vecCard,card); 
						end
						card.m_nCard_Baovalue = -1;
					end 
					table.insert(self.m_vecTipsCards,vecCard);
				end	
			end
			 
			for i = 3,15 do
				vecCard = {};	
				if (self.cardsTable[i] >= 4 or (i==self.m_nBaoValue and nBaoCount==4)) then			
					card = {m_nColor=-1,m_nValue=i,m_nCard_Baovalue=-1};
					table.insert(vecCard,card);
					table.insert(vecCard,card);
					table.insert(vecCard,card);
					table.insert(vecCard,card);
					table.insert(self.m_vecTipsCards,vecCard);
				end
			end
		elseif (cCardsType.m_nTypeBomb == 2) then
			for i = nBegin,15 do
				vecCard = {};	
				if (self.cardsTable[i] >= 4 or (i==self.m_nBaoValue and nBaoCount==4)) then				
					card = {m_nColor=-1,m_nValue=i,m_nCard_Baovalue=-1};
					table.insert(vecCard,card);
					table.insert(vecCard,card);
					table.insert(vecCard,card);
					table.insert(vecCard,card);
					table.insert(self.m_vecTipsCards,vecCard);
				end
			end
		end
	end
	 
	--对鬼
	if (self.cardsTable[16] == 2) then
		vecCard = {};
		card = {m_nColor=0,m_nValue=16,m_nCard_Baovalue=-1};
		table.insert(vecCard,card);
		card = {m_nColor=1,m_nValue=16,m_nCard_Baovalue=-1};
		table.insert(vecCard,card);
		table.insert(self.m_vecTipsCards,vecCard);
	end
	return 0;
end

--三带一
function PlayCard:TipsSearch31(cCardsType)
	local nBegin = cCardsType.m_nTypeValue + 1;
	local card = {m_nColor=-1,m_nValue=-1,m_nCard_Baovalue=-1};
	local vecCard = {};
	-- local nBaoCount = self.cardsTable[17];
	for i = nBegin,15 do
		local nBaoCount = self.cardsTable[17];
		vecCard = {};
		if (self.cardsTable[i] + nBaoCount >= 3 and self.cardsTable[i]~=4 and self.cardsTable[i]>0) then			
			card = {m_nColor=-1,m_nValue=i,m_nCard_Baovalue=-1};
			for j=1,self.cardsTable[i] do
				if j<=3 then
					table.insert(vecCard,card); 
				end
			end	
			local nUserBaocount = 3-self.cardsTable[i];
			if nUserBaocount>=1 then
				card = {m_nColor=-1,m_nValue=self.m_nBaoValue,m_nCard_Baovalue=i};
				for n=1,nUserBaocount do
					table.insert(vecCard,card); 
				end
			end 
			local bFind = 0;
			--寻找正好是单张的牌
			for j = 3,31 do	
				local thisvecCard = {}
				for k,v in pairs(vecCard) do
					table.insert(thisvecCard,v)
				end
				if j<=16 then									
					if (self.cardsTable[j] == 1  and (i~=j) and (j ~= self.m_nBaoValue)) then
						card = {m_nColor=-1,m_nValue=j,m_nCard_Baovalue=-1};
						table.insert(thisvecCard,card);
						if (self.cardsTable[i] ~= 0) then
							table.insert(self.m_vecTipsCards,thisvecCard);
							break;
						end
					end
				else
					j=j-16
					if (self.cardsTable[j] > 1 and self.cardsTable[j]~=4 and (i~=j) and (j ~= self.m_nBaoValue)) then
						card = {m_nColor=-1,m_nValue=j,m_nCard_Baovalue=-1};
						table.insert(thisvecCard,card);
						if (self.cardsTable[i] ~= 0) then
							table.insert(self.m_vecTipsCards,thisvecCard);
							break;
						end
					end
				end

			end
			
			
		end
	end
	return 0;
end

-- --五顺子
-- function PlayCard:TipsSearch5(cCardsType)
-- 	local nBegin = cCardsType.m_nTypeValue + 1;	
-- 	for i=nBegin-1,10 do	
-- 		local card = {m_nColor=-1,m_nValue=-1,m_nCard_Baovalue=-1};
-- 		local vecCard = {};
-- 		local nCount = 0;
-- 		for j=1,5 do
-- 			local nBaoCount = self.cardsTable[17];
-- 			if ((i + j) == self.m_nBaoValue) then
-- 			 	if nBaoCount>0 then
-- 			 		nCount = nCount+1;
-- 			 		nBaoCount = nBaoCount -1;
-- 			 		card.m_nValue = i + j;
-- 			 		table.insert(vecCard,card);
-- 			 	end
-- 			else
-- 				if (self.cardsTable[i + j] + nBaoCount >= 1) then
-- 					if (self.cardsTable[i + j]==0) then
-- 						nBaoCount = nBaoCount-1;
-- 						card.m_nValue = self.m_nBaoValue;
-- 						card.m_nCard_Baovalue = i+j;
-- 					else
-- 						card.m_nValue = i + j;	
-- 					end					 
-- 					table.insert(vecCard,card);						 
-- 					nCount = nCount+1;
-- 				end
-- 			end
-- 		end
-- 		if (nCount == 5) then
-- 			table.insert(self.m_vecTipsCards,vecCard);
-- 		end
-- 	end 
-- 	return 0;
-- end

--三带二
function PlayCard:TipsSearch32(cCardsType)
	local nBegin = cCardsType.m_nTypeValue + 1;
	local card = {m_nColor=-1,m_nValue=-1,m_nCard_Baovalue=-1};
	local vecCard = {};	
	
	for i=nBegin,15 do	 
		vecCard = {};
		
		local nBaoCount = self.cardsTable[17];
		-- if (i == self.m_nBaoValue and nBaoCount==3) then
		-- 	local doin = 0;
		-- 	for j=3,15 do
		-- 		if (i~=j and self.cardsTable[j]==2) then
		-- 			card = {m_nColor=-1,m_nValue=self.m_nBaoValue,m_nCard_Baovalue=i};
		-- 			table.insert(vecCard,card);
		-- 			table.insert(vecCard,card);
		-- 			table.insert(vecCard,card);				 
		-- 			card = {m_nColor=-1,m_nValue=j,m_nCard_Baovalue=-1};
		-- 			table.insert(vecCard,card);
		-- 			table.insert(vecCard,card);
		-- 			table.insert(self.m_vecTipsCards,vecCard);
		-- 			doin = 1;
		-- 			break;
		-- 		end
		-- 	end
		-- 	if doin==0 then
		-- 		for j=3,15 do
		-- 			if (i~=j and self.cardsTable[j]==3) then
		-- 				card = {m_nColor=-1,m_nValue=self.m_nBaoValue,m_nCard_Baovalue=i};
		-- 				table.insert(vecCard,card);
		-- 				table.insert(vecCard,card);
		-- 				table.insert(vecCard,card);
		-- 				card = {m_nColor=-1,m_nValue=j,m_nCard_Baovalue=-1};
		-- 				table.insert(vecCard,card);
		-- 				table.insert(vecCard,card);
		-- 				table.insert(self.m_vecTipsCards,vecCard);
		-- 				break;
		-- 			end
		-- 		end
		-- 	end
		-- else
			if (self.cardsTable[i]>0 and self.cardsTable[i] + nBaoCount >= 3 and self.cardsTable[i]~=4 ) then
				-- card.m_nValue = i;
				card = {m_nColor=-1,m_nValue=i,m_nCard_Baovalue=-1};
				local user_card = 3;

				if (self.cardsTable[i]==4) then
					user_card = 3;
				else 
					user_card = self.cardsTable[i];
				end
				for j=1,user_card do
					table.insert(vecCard,card); 
				end	
				local nUserBaocount = 3-user_card;
				if nUserBaocount >= 1 then
					-- card.m_nValue = self.m_nBaoValue;					
					-- card.m_nCard_Baovalue = i;
					card = {m_nColor=-1,m_nValue=self.m_nBaoValue,m_nCard_Baovalue=i};
					for n=1,nUserBaocount do
						table.insert(vecCard,card); 
					end
					-- card.m_nCard_Baovalue = -1;
					nBaoCount = nBaoCount - nUserBaocount;
				end 
				
				for j=3,15 do
					--配牌
					local thisvecCard = {}
					for k1,v1 in pairs(vecCard) do
						table.insert(thisvecCard,v1)
					end
					if (self.cardsTable[j]>=2 and (i~=j) and self.cardsTable[j]~=4) then
						card = {m_nColor=-1,m_nValue=j,m_nCard_Baovalue=-1};						
						for j=1,2 do
							table.insert(thisvecCard,card); 
						end							 
						table.insert(self.m_vecTipsCards,thisvecCard);
						break;
					end
				end				
			end
		end
	-- end
	return 0;
end


-- 		if (nCount == 6) then
-- 			table.insert(self.m_vecTipsCards,vecCard);
-- 		end
-- 	end 
-- 	return 0;
-- end
--单顺
function PlayCard:TipsSearchSeries(cCardsType,num)
	local nCount = 0;
	local nBegin = cCardsType.m_nTypeValue + 1;
	-- local card = {m_nColor=-1,m_nValue=-1,m_nCard_Baovalue=-1};
	-- local vecCard = {};	
	local endNum = 14-num;
	for i=nBegin-1,endNum do	
		local card = {m_nColor=-1,m_nValue=-1,m_nCard_Baovalue=-1};
		local vecCard = {};
		local nCount = 0;
		local nBaoCount = self.cardsTable[17];
		for j=1,num do
			if (i+j<15) then				
				if ((i + j) == self.m_nBaoValue) then
				 	if nBaoCount>0 then
				 		nCount = nCount+1;
				 		nBaoCount = nBaoCount -1;
				 		card = {m_nColor=-1,m_nValue=self.m_nBaoValue,m_nCard_Baovalue=i + j};
				 		table.insert(vecCard,card);
				 	end
				else
					if (self.cardsTable[i + j] + nBaoCount >= 1) then
						if (self.cardsTable[i + j]==0) then
							nBaoCount = nBaoCount-1;
							card = {m_nColor=-1,m_nValue=self.m_nBaoValue,m_nCard_Baovalue=i + j};
							-- card.m_nValue = self.m_nBaoValue;
							-- card.m_nCard_Baovalue = i+j;
						else
							card = {m_nColor=-1,m_nValue=i + j,m_nCard_Baovalue=-1};
						end					 
						table.insert(vecCard,card);						 
						nCount = nCount+1;
					else
						break;
					end
				end
			end
		end
		if (nCount == num) then
			table.insert(self.m_vecTipsCards,vecCard);
		end
	end 
	return 0;
end
 
--双顺
function PlayCard:TipsSearchDoubleSeries(cCardsType,num)
	local nBegin = cCardsType.m_nTypeValue + 1;
	local endNum = 15-num
	for  i = nBegin-1, endNum do
		local card = {m_nColor=-1,m_nValue=-1,m_nCard_Baovalue=-1};
		local vecCard = {};
		local nCount = 0;	
	 	local nBaoCount = self.cardsTable[17];	 
	 	for j=1,num do
			if (self.cardsTable[i+j] + nBaoCount >= 2) then
				card = {m_nColor=-1,m_nValue=i+j,m_nCard_Baovalue=-1};
				if (self.cardsTable[i+j]>2) then
					user_card = 2;
				else
					user_card = self.cardsTable[i+j];
				end
				for m=1,user_card do
					table.insert(vecCard,card); 
				end	
				local nUserBaocount = 2-user_card;
				if nUserBaocount>=1 then
					card = {m_nColor=-1,m_nValue=self.m_nBaoValue,m_nCard_Baovalue=i+j};
					for n=1,nUserBaocount do
						table.insert(vecCard,card); 
					end
					nBaoCount = nBaoCount-nUserBaocount;
				end 					 				 
				nCount = nCount+1;
			else
				break;
			end
		end		
		
		if (nCount==num) then
			table.insert(self.m_vecTipsCards,vecCard);
		end	
	end
	return 0;
end

-- 3坎
function PlayCard:TipsSearchThreeSeries(cCardsType,num)
	local nBegin = cCardsType.m_nTypeValue + 1;
	local endNum = 15-num
	local card = {m_nColor=-1,m_nValue=-1,m_nCard_Baovalue=-1};
	local vecCard = {};
	for  i = nBegin-1, endNum do
		vecCard = {};
		local nCount = 0;	
	 	local nBaoCount = self.cardsTable[17];
	 	for j=1,num do
	 		local cardUseNum;				
			if (self.cardsTable[i+j] + nBaoCount >= 3) then
				card = {m_nColor=-1,m_nValue=i+j,m_nCard_Baovalue=-1};
				if (self.cardsTable[i+j]>3) then
					cardUseNum = 3;
				else
					cardUseNum = self.cardsTable[i+j];
				end
				for m=1,cardUseNum do
					table.insert(vecCard,card); 
				end	
				local nUserBaocount = 3-cardUseNum;
				if nUserBaocount>=1 then
					card = {m_nColor=-1,m_nValue=self.m_nBaoValue,m_nCard_Baovalue=i+j};
					for n=1,nUserBaocount do
						table.insert(vecCard,card); 
					end
					nBaoCount = nBaoCount-nUserBaocount;
				end 					 				 
				nCount = nCount+1;
			else
				break;
			end
		end		
		
		if (nCount==num) then
			table.insert(self.m_vecTipsCards,vecCard);
		end	
	end
	return 0;
end

-- 四带两单
function PlayCard:TipsSearch411(cCardsType)
	local nBegin = cCardsType.m_nTypeValue + 1;
	local card = {m_nColor=-1,m_nValue=-1,m_nCard_Baovalue=-1};
	local vecCard = {};
	local nBaoCount = self.cardsTable[17];	
	for i=nBegin,15 do	
		vecCard = {};
		local dosel = 0;
		if (i == self.m_nBaoValue and nBaoCount==4) then
			card = {m_nColor=-1,m_nValue=self.m_nBaoValue,m_nCard_Baovalue=i};
			for m=1,4 do
				table.insert(vecCard,card); 
			end	
			dosel = 1;
		else		 		
			if (self.cardsTable[i]~=0 and self.cardsTable[i] + nBaoCount >= 4) then
				card = {m_nColor=-1,m_nValue=i,m_nCard_Baovalue=-1};
				for m=1,self.cardsTable[i] do
					table.insert(vecCard,card); 
				end	
				local nUserBaocount = 4-self.cardsTable[i];
				if nUserBaocount>=1 then
					card = {m_nColor=-1,m_nValue=self.m_nBaoValue,m_nCard_Baovalue=i};
					for n=1,nUserBaocount do
						table.insert(vecCard,card); 
					end
					nBaoCount = nBaoCount-nUserBaocount;
				end 
				dosel = 1;
			end
		end
		if (dosel == 1) then
			local nCount = 0; 
			for j=3,16 do
				if (self.cardsTable[j] == 1 and (i~=j) and (j ~= self.m_nBaoValue)) then
					card = {m_nColor=-1,m_nValue=j,m_nCard_Baovalue=-1};
					table.insert(vecCard,card);
					nCount = nCount+1;				
				end
				if (nCount == 2) then
					table.insert(self.m_vecTipsCards,vecCard);
					break;
				end
			end 
			if ( nCount ~= 2 ) then
				for m=3,15 do
					local thisCardNum = self.cardsTable[m];
					if (self.cardsTable[m] > 1 and (i~=m) ) then
						card = {m_nColor=-1,m_nValue=m,m_nCard_Baovalue=-1};					 
						for n=1,thisCardNum do
							table.insert(vecCard,card);
							nCount = nCount+1;	
							if (nCount==2) then
								break;
							end						
						end
									
					end
					if (nCount == 2) then
						table.insert(self.m_vecTipsCards,vecCard);
						break;
					end
					if (nCount~=2) then
						if nBaoCount>0 then
							thisCardNum = nBaoCount
							for n=1,thisCardNum do
								table.insert(vecCard,card);
								nCount = nCount+1;	
								if (nCount==2) then
									table.insert(self.m_vecTipsCards,vecCard);
									break;
								end						
							end
						end
					end
				end
			end 
		end
	end
	return 0;
end 

function PlayCard:TipsSearch3311(cCardsType)
	local nBegin = cCardsType.m_nTypeValue + 1;
	local card = {m_nColor=-1,m_nValue=-1,m_nCard_Baovalue=-1};
	local vecCard = {};
	for i=nBegin-1,12 do	
		vecCard = {};	
		local nBaoCount = self.cardsTable[17];
		local nCount = 0;	
		for j=1,2 do  		
			if (self.cardsTable[i+j] + nBaoCount >= 3) then
				nBaoCount = nBaoCount-3+self.cardsTable[i+j];				 
				card = {m_nColor=-1,m_nValue=i+j,m_nCard_Baovalue=-1};
				local useCardNum;
				if (self.cardsTable[i+j]>3) then
					useCardNum = 3
				else
					useCardNum = self.cardsTable[i+j]
				end
				for m=1,useCardNum do
					table.insert(vecCard,card); 
				end	
				local nUserBaocount = 3-useCardNum;
				if nUserBaocount>=1 then
					card = {m_nColor=-1,m_nValue=self.m_nBaoValue,m_nCard_Baovalue=i+j};
					for n=1,nUserBaocount do
						table.insert(vecCard,card); 
					end
				end 				
				nCount = nCount+1;
			else 
				break;
			end
		end
		-- print (nCount);
		-- var_dump(vecCard)
		if (nCount==2) then
			local nCount_r = 0; 
			for j=3,16 do
				if (self.cardsTable[j] == 1 and (j<=i or j>i+2) and (j ~= self.m_nBaoValue)) then
					card = {m_nColor=-1,m_nValue=j,m_nCard_Baovalue=-1};
					table.insert(vecCard,card);
					nCount_r = nCount_r+1;				
				end
				if (nCount_r == 2) then
					var_dump(vecCard)
					table.insert(self.m_vecTipsCards,vecCard);
					break;
				end
			end 
			
			if ( nCount_r ~= 2 ) then
				for m=3,15 do
					local thisCardNum = self.cardsTable[m];
					if (thisCardNum > 1 and (m<=i or m>i+2) and (m ~= self.m_nBaoValue) ) then						 
						card = {m_nColor=-1,m_nValue=m,m_nCard_Baovalue=-1};
						for n=1,thisCardNum do
							table.insert(vecCard,card);
							nCount_r = nCount_r+1;	
							if (nCount_r==2) then
								break;
							end						
						end 
									
					end
					if (nCount_r == 2) then
						var_dump(vecCard)
						table.insert(self.m_vecTipsCards,vecCard);
						break;
					end
				end
			end 
		end		 
	end
	return 0;
end

--四张带两对
function PlayCard:TipsSearch422(cCardsType)
	local nBegin = cCardsType.m_nTypeValue + 1;
	local card = {m_nColor=-1,m_nValue=-1,m_nCard_Baovalue=-1};
	local nBaoCount = self.cardsTable[17];	
	local vecCard = {};
	for i=nBegin,15 do	
		vecCard = {};
		local has_sel = 0;
		if (i == self.m_nBaoValue and nBaoCount==4) then
			card = {m_nColor=-1,m_nValue=self.m_nBaoValue,m_nCard_Baovalue=i};
			for m=1,4 do
				table.insert(vecCard,card); 
			end	
			nBaoCount = 0;
			has_sel = 1;
		else		 		
			if (self.cardsTable[i]~=0 and self.cardsTable[i] + nBaoCount >= 4) then
				card = {m_nColor=-1,m_nValue=i,m_nCard_Baovalue=-1};
				for m=1,self.cardsTable[i] do
					table.insert(vecCard,card); 
				end	
				local nUserBaocount = 4-self.cardsTable[i];
				if nUserBaocount>=1 then
					card = {m_nColor=-1,m_nValue=self.m_nBaoValue,m_nCard_Baovalue=i};					
					for n=1,nUserBaocount do
						table.insert(vecCard,card); 
					end
					nBaoCount = nBaoCount-nUserBaocount;
				end 
				has_sel = 1
			end
		end
		if ( has_sel == 1) then
			local nCount = 0; 
			for j=3,15 do
				if (self.cardsTable[j] == 2 and (i~=j)) then
					card = {m_nColor=-1,m_nValue=j,m_nCard_Baovalue=-1};
					table.insert(vecCard,card);
					table.insert(vecCard,card);
					nCount = nCount+1;				
				end
				if (nCount == 2) then
					table.insert(self.m_vecTipsCards,vecCard);
					break;
				end
			end 
			if ( nCount ~= 2 ) then
				for m=3,15 do
					local thisCardNum = self.cardsTable[m];
					if ((thisCardNum==1 and nBaoCount>=1) or thisCardNum==3) and (i~=m) then
						card.m_nValue = m;
						if thisCardNum >2 then
							thisCardNum =2;
						end
						for n=1,thisCardNum do
							table.insert(vecCard,card); 
						end	
						local nUserBaocount = 2-thisCardNum;
						if nUserBaocount>=1 then
							card = {m_nColor=-1,m_nValue=self.m_nBaoValue,m_nCard_Baovalue=m};
							for k=1,nUserBaocount do
								table.insert(vecCard,card); 
							end
							nBaoCount = nBaoCount-nUserBaocount;
						end 
									
					end
					if (nCount == 2) then
						table.insert(self.m_vecTipsCards,vecCard);
						break;
					end
				end
				if (nCount==1) then
					if nBaoCount>=2 then
						card.m_nValue = self.m_nBaoValue;
						card.m_nCard_Baovalue = self.m_nBaoValue;
						for k=1,2 do
							table.insert(vecCard,card); 
						end
						nCount = nCount+1;
						table.insert(self.m_vecTipsCards,vecCard);
					end
				end
			end
		end 
	end
	return 0;
end
 
 

 

 

--两坎两对
function PlayCard:TipsSearch3322(cCardsType)
	local nBegin = cCardsType.m_nTypeValue + 1;
	local card = {m_nColor=-1,m_nValue=-1,m_nCard_Baovalue=-1};
	local vecCard = {};	
	for i=nBegin-1,12 do	
		vecCard = {};	
		local nBaoCount = self.cardsTable[17];
		local nCount = 0;	
		for j=1,2 do  		
			if (self.cardsTable[i+j] + nBaoCount >= 3) then
				nBaoCount = nBaoCount-3+self.cardsTable[i+j];				 
				card = {m_nColor=-1,m_nValue=i+j,m_nCard_Baovalue=-1};
				local useCardNum;
				if (self.cardsTable[i+j] > 3) then
					useCardNum = 3;
				else
					useCardNum=self.cardsTable[i+j];
				end
				for m=1,useCardNum do
					table.insert(vecCard,card); 
				end	
				local nUserBaocount = 3-useCardNum;
				if nUserBaocount>=1 then
					card = {m_nColor=-1,m_nValue=self.m_nBaoValue,m_nCard_Baovalue=i+j};
					for n=1,nUserBaocount do
						table.insert(vecCard,card); 
					end
				end 				
				nCount = nCount+1;
			else 
				break;
			end
		end
		if (nCount==2) then
			nCount = 0; 
			for j=3,15 do
				if (self.cardsTable[j] == 2 and (j<=i or j>i+2)) then
					card = {m_nColor=-1,m_nValue=j,m_nCard_Baovalue=-1};
					table.insert(vecCard,card);
					table.insert(vecCard,card);
					nCount = nCount+1;				
				end
				if (nCount == 2) then
					table.insert(self.m_vecTipsCards,vecCard);
					break;
				end
			end 
			if ( nCount ~= 2 ) then
				for m=3,15 do
					local thisCardNum = self.cardsTable[m];
					if ((thisCardNum==1 and nBaoCount>=1) or thisCardNum==3) and (m<=i or m>i+2) then
						card = {m_nColor=-1,m_nValue=m,m_nCard_Baovalue=-1};
						if thisCardNum >2 then
							thisCardNum =2;
						end
						for n=1,thisCardNum do
							table.insert(vecCard,card); 
						end	
						local nUserBaocount = 2-thisCardNum;
						if nUserBaocount>=1 then
							card = {m_nColor=-1,m_nValue=self.m_nBaoValue,m_nCard_Baovalue=m};
							for k=1,nUserBaocount do
								table.insert(vecCard,card); 
							end
							nBaoCount = nBaoCount-nUserBaocount;
						end 
						nCount = nCount+1;
									
					end
					if (nCount == 2) then
						table.insert(self.m_vecTipsCards,vecCard);
						break;
					end
				end
				if (nCount==1) then
					if nBaoCount>=2 then
						card = {m_nColor=-1,m_nValue=self.m_nBaoValue,m_nCard_Baovalue=self.m_nBaoValue};
						for k=1,2 do
							table.insert(vecCard,card); 
						end
						nCount = nCount+1;
						table.insert(self.m_vecTipsCards,vecCard);
					end
				end
			end
		end 
	end
	return 0;
end


 

--三坎带三单张
function PlayCard:TipsSearch333111(cCardsType)
	local nBegin = cCardsType.m_nTypeValue + 1;
	local card = {m_nColor=-1,m_nValue=-1,m_nCard_Baovalue=-1};
	local vecCard = {};
	for i=nBegin-1,11 do	
		vecCard = {};	
		local nBaoCount = self.cardsTable[17];
		local nCount = 0;	
		for j=1,3 do  		
			if (self.cardsTable[i+j] + nBaoCount >= 3) then
				nBaoCount = nBaoCount-3+self.cardsTable[i+j];				 
				card = {m_nColor=-1,m_nValue=i+j,m_nCard_Baovalue=-1};
				local useCardNum;
				if (self.cardsTable[i+j]>3) then
					useCardNum = 3
				else
					useCardNum = self.cardsTable[i+j]
				end
				for m=1,useCardNum do
					table.insert(vecCard,card); 
				end	
				local nUserBaocount = 3-useCardNum;
				if nUserBaocount>=1 then
					card = {m_nColor=-1,m_nValue=self.m_nBaoValue,m_nCard_Baovalue=i+j};
					for n=1,nUserBaocount do
						table.insert(vecCard,card); 
					end
				end 				
				nCount = nCount+1;
			else 
				break;
			end
		end
		-- print (nCount);
		-- var_dump(vecCard)
		if (nCount==3) then
			local nCount_r = 0; 
			for j=3,16 do
				if (self.cardsTable[j] == 1 and (j<=i or j>i+3) and (j ~= self.m_nBaoValue)) then
					card = {m_nColor=-1,m_nValue=j,m_nCard_Baovalue=-1};
					table.insert(vecCard,card);
					nCount_r = nCount_r+1;				
				end
				if (nCount_r == 3) then
					table.insert(self.m_vecTipsCards,vecCard);
					break;
				end
			end 
			
			if ( nCount_r ~= 3 ) then
				for m=3,15 do
					local thisCardNum = self.cardsTable[m];
					if (thisCardNum > 1 and (m<=i or m>i+3) ) then						 
						card = {m_nColor=-1,m_nValue=m,m_nCard_Baovalue=-1};
						for n=1,thisCardNum do
							table.insert(vecCard,card);
							nCount_r = nCount_r+1;	
							if (nCount_r==3) then
								break;
							end						
						end  			
					end
					if (nCount_r == 3) then
						table.insert(self.m_vecTipsCards,vecCard);
						break;
					end
				end
				if (nCount_r~=3) then
					if (nCount_r+nBaoCount>=3) then
						thisCardNum = 3-nCount_r
						card = {m_nColor=-1,m_nValue=self.m_nBaoValue,m_nCard_Baovalue=self.m_nBaoValue};
						for n=1,thisCardNum do
							table.insert(vecCard,card);
							nCount_r = nCount_r+1;	
							if (nCount_r==3) then
								table.insert(self.m_vecTipsCards,vecCard);
								break;
							end						
						end
					end
				end
			end 
		end		 
	end
	return 0;
end 


 

--三坎三对
function PlayCard:TipsSearch333222(cCardsType)
	local nBegin = cCardsType.m_nTypeValue + 1;
	local card = {m_nColor=-1,m_nValue=-1,m_nCard_Baovalue=-1};
	local vecCard = {};	
	for i=nBegin-1,11 do	
		vecCard = {};	
		local nBaoCount = self.cardsTable[17];
		local nCount = 0;	
		for j=1,3 do  		
			if (self.cardsTable[i+j] + nBaoCount >= 3) then
				nBaoCount = nBaoCount-3+self.cardsTable[i+j];				 
				card = {m_nColor=-1,m_nValue=i+j,m_nCard_Baovalue=-1};
				local useCardNum;
				if (self.cardsTable[i+j] > 3) then
					useCardNum = 3;
				else
					useCardNum=self.cardsTable[i+j];
				end
				for m=1,useCardNum do
					table.insert(vecCard,card); 
				end	
				local nUserBaocount = 3-useCardNum;
				if nUserBaocount>=1 then
					card = {m_nColor=-1,m_nValue=self.m_nBaoValue,m_nCard_Baovalue=i+j};
					for n=1,nUserBaocount do
						table.insert(vecCard,card); 
					end
				end 				
				nCount = nCount+1;
			else 
				break;
			end
		end
		if (nCount==3) then
			nCount = 0; 
			for j=3,15 do
				if (self.cardsTable[j] == 2 and (j<=i or j>i+2)) then
					card = {m_nColor=-1,m_nValue=j,m_nCard_Baovalue=-1};
					table.insert(vecCard,card);
					nCount = nCount+1;				
				end
				if (nCount == 3) then
					table.insert(self.m_vecTipsCards,vecCard);
					break;
				end
			end 
			if ( nCount ~= 3 ) then
				for m=3,15 do
					local thisCardNum = self.cardsTable[m];
					if ((thisCardNum==1 and nBaoCount>=1) or thisCardNum==3) and (m<=i or m>i+3) then
						card = {m_nColor=-1,m_nValue=m,m_nCard_Baovalue=-1};
						if thisCardNum >2 then
							thisCardNum =2;
						end
						for n=1,thisCardNum do
							table.insert(vecCard,card); 
						end	
						local nUserBaocount = 2-thisCardNum;
						if nUserBaocount>=1 then
							card = {m_nColor=-1,m_nValue=self.m_nBaoValue,m_nCard_Baovalue=m};
							for k=1,nUserBaocount do
								table.insert(vecCard,card); 
							end
							nBaoCount = nBaoCount-nUserBaocount;
						end 
						nCount = nCount+1;
									
					end
					if (nCount == 3) then
						table.insert(self.m_vecTipsCards,vecCard);
						break;
					end
				end
				if (nCount==2) then
					if nBaoCount>=2 then
						card = {m_nColor=-1,m_nValue=self.m_nBaoValue,m_nCard_Baovalue=self.m_nBaoValue};
						for k=1,2 do
							table.insert(vecCard,card); 
						end
						nCount = nCount+1;
						table.insert(self.m_vecTipsCards,vecCard);
					end
				end
			end
		end 
	end
	return 0;
end


 

function PlayCard:TipsSearch33331111(cCardsType)

	local nBegin = cCardsType.m_nTypeValue + 1;
	local card = {m_nColor=-1,m_nValue=-1,m_nCard_Baovalue=-1};
	local vecCard = {};
	for i=nBegin-1,10 do	
		vecCard = {};	
		local nBaoCount = self.cardsTable[17];
		local nCount = 0;	
		for j=1,4 do  		
			if (self.cardsTable[i+j] + nBaoCount >= 3) then
				nBaoCount = nBaoCount-3+self.cardsTable[i+j];				 
				card = {m_nColor=-1,m_nValue=i+j,m_nCard_Baovalue=-1};
				local useCardNum;
				if (self.cardsTable[i+j]>3) then
					useCardNum = 3
				else
					useCardNum = self.cardsTable[i+j]
				end
				for m=1,useCardNum do
					table.insert(vecCard,card); 
				end	
				local nUserBaocount = 3-useCardNum;
				if nUserBaocount>=1 then
					card = {m_nColor=-1,m_nValue=self.m_nBaoValue,m_nCard_Baovalue=i+j};
					for n=1,nUserBaocount do
						table.insert(vecCard,card); 
					end
				end 				
				nCount = nCount+1;
			else 
				break;
			end
		end
		-- print (nCount);
		-- var_dump(vecCard)
		if (nCount==4) then
			local nCount_r = 0; 
			for j=3,16 do
				if (self.cardsTable[j] == 1 and (j<=i or j>i+4) and (j ~= self.m_nBaoValue)) then
					card = {m_nColor=-1,m_nValue=j,m_nCard_Baovalue=-1};
					table.insert(vecCard,card);
					nCount_r = nCount_r+1;				
				end
				if (nCount_r == 4) then
					table.insert(self.m_vecTipsCards,vecCard);
					break;
				end
			end 
			
			if ( nCount_r ~= 4 ) then
				for m=3,15 do
					local thisCardNum = self.cardsTable[m];
					if (thisCardNum > 1 and (m<=i or m>i+4) ) then						 
						card = {m_nColor=-1,m_nValue=m,m_nCard_Baovalue=-1};
						for n=1,thisCardNum do
							table.insert(vecCard,card);
							nCount_r = nCount_r+1;	
							if (nCount_r==4) then
								break;
							end						
						end  			
					end
					if (nCount_r == 4) then
						table.insert(self.m_vecTipsCards,vecCard);
						break;
					end
				end
				if (nCount_r~=4) then
					if (nCount_r+nBaoCount>=4) then
						thisCardNum = 4-nCount_r
						card = {m_nColor=-1,m_nValue=self.m_nBaoValue,m_nCard_Baovalue=self.m_nBaoValue};
						for n=1,thisCardNum do
							table.insert(vecCard,card);
							nCount_r = nCount_r+1;	
							if (nCount_r==4) then
								table.insert(self.m_vecTipsCards,vecCard);
								break;
							end						
						end
					end
				end
			end 
		end		 
	end
	return 0;
end

function PlayCard:SetBaoValue(card)
	-- local nValue = card.m_nValue;
	-- if (nValue == 15) then
	-- 	self.m_nBaoValue = 3;
	-- elseif (nValue == 16 or nValue == 17) then
	-- 	self.m_nBaoValue = 3;
	-- else
	-- 	self.m_nBaoValue = nValue + 1;
	-- end
	self.m_nBaoValue = card;
	print("set bao value"..self.m_nBaoValue)
end

function PlayCard:CheckCards(vecCards)
	local nCount = 0;
	local cardsNum = 0;
	for k,v in pairs(vecCards) do
		cardsNum = cardsNum+1;
		for k1,v1 in pairs(self.m_cCards) do
			if (v1.m_nValue == v.m_nValue and v1.m_nColor == v.m_nColor) then
				nCount = nCount+1;
			end
		end
	end
	if (nCount==cardsNum) then
		self.m_choose_cCards = vecCards;
		return true;
	end	
	return false;
end

function PlayCard:EraseCards(vecCards)
	for k,v in pairs(vecCards) do
		for k1,v1 in pairs(self.m_cCards) do
			if (v1.m_nValue == v.m_nValue and v1.m_nColor == v.m_nColor) then
				self.m_cCards[k1] = nil;
				break;
			end
		end
	end
end

function PlayCard:LordAddCards(vecCards) 
	for k,v in pairs(vecCards) do
		table.insert(self.m_cCards,v);
	end
end

--[[
 


function PlayCard:CheckTigerValue(local nTigerCount)
{	
	if (self.cardsTable[BAO] >= nTigerCount)
	{
		self.cardsTable[BAO] -= nTigerCount;
		return true;
	}
	return false;
}

function PlayCard:RevertTigerValue()
{
	self.cardsTable[BAO] = 0;	
	self.cardsTable[self.m_nBaoValue] = 0;

	--扫描进表中;
	for(size_t i = 0; i < m_choose_cCards.size(); i++)
	{
		if ((local)m_choose_cCards[i].m_nValue == self.m_nBaoValue)
		{
			self.cardsTable[BAO]++;
		}
	}
}

function PlayCard:SelectCard( VECCARD& vecCards )
{
	bool is_get_selected = true ;
	TipScanCardTable();
	m_choose_cCards.clear();
	m_tempCard.clear();
	m_tempCard = m_cCards;
	for(size_t i=0;i<vecCards.size();i++)
	{
		if (self.cardsTable[vecCards[i].m_nValue]>0)
		{
			for(size_t j=0;j<m_tempCard.size();j++)
			{
				if (m_tempCard[j].m_nValue == vecCards[i].m_nValue )
				{
					m_choose_cCards.push_back(m_cCards[j]);
					m_tempCard[j].m_nValue = 0;
					m_tempCard[j].m_nColor = 0;
					self.cardsTable[vecCards[i].m_nValue]--;
					--g_pLogger->Log("tips_card:%d",vecCards[i].m_nValue);
					break;
				}
			}
		}
	}
	return is_get_selected;
}


 

function PlayCard:TipsSoftBomb( cCardsType )
{
	if (self.m_nBaoValue > 0)
	{
		local nBegin = cCardsType.m_nTypeValue + 1;
		for(local i = nBegin; i < 16; i++)
		{
			local nBaoCount = self.cardsTable[self.m_nBaoValue];
			if (i == self.m_nBaoValue)
			{
				nBaoCount = 0;
			}
			if (self.cardsTable[i] + nBaoCount >= 4)
			{
				CCard card;
				VECCARD vecCard;
				card.m_nValue = i;
				for(local j = 0; j < min(4,self.cardsTable[i]); j++)
				{
					table.insert(vecCard,card);
				}
				local nUsedCatCount = min(nBaoCount, 4 - self.cardsTable[i]);
				for(local k = 0; k < nUsedCatCount; k++)
				{
					card.m_nValue = self.m_nBaoValue;
					table.insert(vecCard,card);
				}				
				if (self.cardsTable[i] ~= 0)
				{
					table.insert(self.m_vecTipsCards,vecCard);
				}
			}	
		}
		
	}
	return 0;
}

function PlayCard:RevertCardValue( local value,local num)
{
	for(local a =0;a<num;a++)
	{
		for(local i=0;i<m_choose_cCards.size();i++)
		{
			if (m_choose_cCards[i].m_nValue == self.m_nBaoValue and m_choose_cCards[i].m_nCard_Baovalue < 3)
			{
				m_choose_cCards[i].m_nCard_Baovalue = value;
			}
		}
	}
}
]]--
return PlayCard
