local Me = class("Me",require "moduleDdz.ctrllers.Player")

function Me:ctor(gamescene)
    self.super:ctor(gamescene);
end

function Me:onEnterTransitionDidFinish()
    self.super:onEnterTransitionDidFinish();
end

function Me:RefreshCard(Cards,isShowLaizi)  --刷新玩家牌
    --local vecCards = message.vecCards;
    print("++++++++++++++++++++++++++++")
    print("____________________________")
    -- print("thiscardNum"..#Cards)
    var_dump(Cards)
    local vecCards = {}   
    self.cards_.m_cCards = nil
    self.cards_.m_cCards = {}
    vecCards = cleanCopy(Cards)
    self.cards_.m_cCards = cleanCopy(Cards)
    -- self.super:RefreshCard(Cards)
    local orgCards = {}
    -- self.cards_.m_cCards = Cards
    if self.MeCCard ~=nil and self.gamescene.ctrller:is_game_start() ~= false then        
        local num = 0;
        for i=1, #self.MeCCard do
            local pCard = self.MeCCard[i-num]
            
            if pCard  then
                local this_flag = 0
                for k,v in pairs(Cards) do
                    if v.m_nColor == pCard.data.m_stCard.m_nColor and v.m_nValue == pCard.data.m_stCard.m_nValue then
                        this_flag = 1;
                        break;
                    end
                end          
                if this_flag == 0 then
                    pCard:retain();
                    self.gamescene.puKeLayer:removeChild(pCard, true);
                    table.remove(self.MeCCard, i-num)
                    num = num + 1
                end
            end
        end
        if #self.cards_.m_cCards==#self.MeCCard and num==0 and isShowLaizi~=true then
            print("=========self.cards_.m_cCards====")
            return
        end
        -- for k,v in pairs(self.MeCCard) do
        --     table.insert(orgCards,v);
        -- end
        orgCards = cleanCopy(self.MeCCard)
        if #self.cards_.m_cCards<#self.MeCCard then
            for k,v in pairs(self.MeCCard) do
                local thisflag = 0;
                for k1,v1 in pairs(self.cards_.m_cCards) do
                    if v.data.m_stCard.m_nColor == v1.m_nColor and v.data.m_stCard.m_nValue == v1.m_nValue then
                        thisflag = 1;
                        break;
                    end
                end
                if thisflag==0 then
                    self.gamescene.puKeLayer:removeChild(v, true);
                end
            end
        end
    end
    self.MeCCard = nil
    self.MeCCard = {}
    
    print("thiscardNum:"..#Cards)
    print("orgCards:"..#orgCards)
    var_dump(Cards)
    local cardscale = 200/182
    local cardSize = CCSizeMake(152,200) --(138,182)
    local winSize = CCSizeMake(1136,200) --牌面显示区域
    local screenWidth = CCDirector:sharedDirector():getWinSize().width
    local nNum = #self.cards_.m_cCards
    local nDistance = winSize.width  / (nNum +1); --两牌间距 
    if (nDistance > 50) then
        nDistance =  50;
    end
    local nWidth = (nNum - 1) * nDistance + cardSize.width;
    local ptHandCardPos = ccp(-nWidth / 2 + cardSize.width/2,cardSize.height/2-2);
    --local nWidth = nNum * nDistance;
    --local ptHandCardPos = ccp(-nWidth / 2 + nDistance,cardSize.height/2);
    -- self.cards_:CleanUp();
    self.cards_:CleanUp();
    if self.gamescene.ctrller:is_game_start() == false then -- !pgame_->is_game_start() 第一次发牌
        
        self.gamescene.puKeLayer:removeAllChildrenWithCleanup(true);
        for i = 0, nNum-1 do
            local pCard = require("moduleDdz.ctrllers.CCardSprite").new(self.gamescene,vecCards[i+1],self.cards_.m_nBaoValue,cardscale); 
            --pCard:setScale(1.098)
            -- if (GameSession::GetInstancePtr()->is_slider_player())
            --     pCard = CCardSprite::initWithSprite();
            -- else
            --     pCard = CCardSprite::initWithCard(vecCards[i]/*cards_.m_cCards[i]*/);
            -- end
            -- if (pCard:getCardValue().m_nValue == cards_.m_nBaoValue) then
            --     CCSprite* sprite_laizi = HGResMgr::shareResMgr()->getDrawable("laizi.png");
            --     pCard->addChild(sprite_laizi);
            --     sprite_laizi->setPosition(CUIPOS(pCard,sprite_laizi,pgame_->laizi_card_size().width,pgame_->laizi_card_size().height));
            -- end
            self.gamescene.puKeLayer:addChild(pCard,i);
            pCard:setPosition(ccp(-1000,0));

            local action1 = CCDelayTime:create(i*0.1);
            local x = ptHandCardPos.x+i*nDistance;
            local y = math.sqrt(math.pow(nWidth*2, 2) - math.pow(math.abs(math.floor(x)), 2)) - nWidth*2+120;
            local action2 = CCMoveTo:create(0,ccp(x+screenWidth/2,y));
            local r =  -21+math.floor(45.0/nNum) * i;
            local action3 = CCRotateTo:create(0, r);
            --local playsound = CCCallFunc:actionWithTarget(self, callfunc_selector(Me:OnRefreshCardSound));
            local action4 = CCDelayTime:create((nNum-i)*0.1);
            local action51 = CCMoveTo:create(0.5, ccp(screenWidth/2, ptHandCardPos.y));
            local action52 = CCRotateTo:create(0.5, 0);
            local action5 = CCSpawn:createWithTwoActions(action51, action52);
            
            local action6;
            --[[if(GameSession::GetInstancePtr()->is_slider_player())
            {
                action6 = CCMoveTo::actionWithDuration(0.5, ccp(ptHandCardPos.x+i*nDistance, ptHandCardPos.y));
                pCard->runAction(CCSequence::actions(action1, action2, action3, playsound, action4, action5,action6, NULL));
            }
            else --]]
            for k,v in pairs(self.cards_.m_cCards) do
                if v.m_nColor == vecCards[i+1].m_nColor and v.m_nValue == vecCards[i+1].m_nValue then
                    self.MeCCard[k] = pCard;
                    action7 = CCMoveTo:create(0.5, ccp(ptHandCardPos.x+(k-1)*nDistance+screenWidth/2, ptHandCardPos.y));
                    local doithander = function()
                        self.gamescene.puKeLayer:reorderChild(pCard,k+1)
                    end
                    action6 = CCCallFunc:create(doithander)
                    break
                end
            end
            action8 = CCCallFunc:create(function()
                --发牌完成
                if ( self.gamescene.ctrller.data.is_game_start_ == false) then
                    self.gamescene.ctrller:set_is_game_start(true)
                end
            end)
            pCard:runAction(transition.sequence({action1, action2, action3,action4, action5,action6,action7,action8}));
        end
        
        self.gamescene.ctrller:sendCardokAck();
    else --游戏中刷新牌面  
        -- if(!pgame_->is_auto())
        --     hand_card_area_->set_is_can_touch(true);

        local ks = 0
        if orgCards==nil or type(orgCards)~="table" or isShowLaizi==true then
            ks=1                    
        end
        if ks == 0 then
            for i,v2 in pairs(self.cards_.m_cCards) do

                if orgCards~=nil and #orgCards>0 then
                    ks = 1;
                    for m,v1 in pairs(orgCards) do
                        if v1.data.m_stCard.m_nColor == v2.m_nColor and v1.data.m_stCard.m_nValue == v2.m_nValue then
                            ks = 0;
                            break;
                        end
                    end
                    if ks==1 then
                        break;
                    end
                else
                    ks = 1;
                end
            end
        end
        if ks==1 then
            print("resssssssss"..ks)
            self.gamescene.puKeLayer:removeAllChildrenWithCleanup(true);
            for i,v in pairs(self.cards_.m_cCards) do
                local pCard = require("moduleDdz.ctrllers.CCardSprite").new(self.gamescene,v,self.cards_.m_nBaoValue,cardscale);
                self.MeCCard[i] = pCard;
                self.gamescene.puKeLayer:addChild(pCard,(i-1));
                pCard:setPosition(ccp(ptHandCardPos.x+(i-1)*nDistance+screenWidth/2, ptHandCardPos.y));
            end
            orgCards = nil
            return
        end
        print("resssssssss212"..ks)

        for i,v2 in pairs(self.cards_.m_cCards) do
            local flag=0            
            if flag==0 then
                 for m,v1 in pairs(orgCards) do
                    if v1.data.m_stCard.m_nColor == v2.m_nColor and v1.data.m_stCard.m_nValue == v2.m_nValue then
                        print("ptHandCardPos.x+(i-1)*nDistance+screenWidth/2, ptHandCardPos.y"..i)
                        print(ptHandCardPos.x+(i-1)*nDistance+screenWidth/2, ptHandCardPos.y);
                        -- ccp(ptHandCardPos.x+(k-1)*nDistance+screenWidth/2, ptHandCardPos.y)
                        -- ccp(ptHandCardPos.x+(i-1)*nDistance+screenWidth/2, ptHandCardPos.y)
                        local moveaction = CCMoveTo:create(0.5, ccp(ptHandCardPos.x+(i-1)*nDistance+screenWidth/2, ptHandCardPos.y))
                        local doithander = function()
                            self.gamescene.puKeLayer:reorderChild(v1,i+1)
                        end
                        local actionCallBack = CCCallFunc:create(doithander)
                        v1:stopAllActions()
                        v1:runAction(transition.sequence({moveaction,actionCallBack}))
                        self.MeCCard[i] = v1
                        flag = 1;
                        break;
                    end                    
                end
            end
        end
        orgCards = nil

       
    end
end

function Me:Init(nDir)  --初始化
    self.super:Init(nDir)
end

function Me:ReInit()
    self.super:ReInit()
end

function Me:RequestHeadIcon()  --请求头像地址

end

function Me:InitTip()  --初始化提示的牌

end

function Me:setUserData(data)  --设置玩家信息
   self.super:setUserData(data)
end

function Me:ReleaseSelectCard() --取消手中所选牌

end

function Me:GetSelectedCard(m_nTypeNum)  --获取选中的牌
   
    local selectCards = self.gamescene:getSelectedCard();
    if (self.cards_:CheckCards(selectCards)) then
        -- local flag = self.cards_:CheckChoosing(m_nTypeNum)
        -- if flag==1 then
        --     -- self.m_cDiscardingType.m_nTypeBomb = 0;
        --     -- self.m_cDiscardingType.m_nTypeNum = 31;
        --     -- self.m_cDiscardingType.m_nTypeValue = Table_Index;
        -- end
        return self.cards_:CheckChoosing(m_nTypeNum);
    else
        return 0;
    end
    -- self.cards_.m_choose_cCards = self.gamescene:getSelectedCard()
    
    -- var_dump(self.cards_.cardsTable);
end

function Me:PlaySelectCard()
    self.play_card_:removeAllChildrenWithCleanup(true);
    local cardSize = CCSizeMake(138,182);
    local nWidth = (#self.cards_.m_choose_cCards-1)* 40 + cardSize.width;
    local ptPlayCard = CCPointMake(-nWidth / 2, 0);
    local num = 0;
    for i=1, #self.MeCCard do
        local pCard = self.MeCCard[i-num]
        if pCard and pCard:getStatus() == pCard.data.ST_SELECTED then
            local px,py = pCard:getPosition();
            local pt = self.gamescene.puKeLayer:convertToWorldSpace(ccp(px,py));

            pCard:retain();
            self.gamescene.puKeLayer:removeChild(pCard, true);
            pt = self.play_card_:convertToNodeSpace(pt);
            self.play_card_:addChild(pCard);
            pCard:release()
            pCard:selected();
            pCard:setPosition(pt);
            table.remove(self.MeCCard, i-num)
            num = num + 1
        end
    end
   
    local children = self.play_card_:getChildren();
    local discardList = {};
    local discardvalues = {}
    if (children and children:count() > 0) then
        for i=0, children:count()-1 do
            local pCard = children:objectAtIndex(i)
            table.insert(discardList,pCard)
            table.insert(discardvalues,pCard:getCardValue())
            if self.cards_.m_nBaoValue==0 or self.cards_.cardsTable[17]==0 then
                if pCard:getCardValue().m_nValue ~= 99 then
                    pCard:setAnchorPoint(CCPointMake(0,0))
                    self.play_card_:reorderChild(pCard,i+1)
                    local action1 = CCMoveTo:create(0.2, ccp(ptPlayCard.x+i*40, ptPlayCard.y));
                    local action2 = CCScaleTo:create(0.2,0.9);
                    local action5 = CCSpawn:createWithTwoActions(action1, action2);
                    pCard:runAction(action5);
                    i = i+1;
                end
            end
            
        end
        if self.cards_.m_nBaoValue~=0 and self.cards_.cardsTable[17]~=0 then
            local sortFunc = function(a, b)  
                local anValue =  a:getCardValue().m_nValue  
                local anColor =  a:getCardValue().m_nColor  
                local bnValue =  b:getCardValue().m_nValue  
                local bnColor =  b:getCardValue().m_nColor 
                local thisorderA =  anValue * 4 + anColor;
                local thisorderB = bnValue * 4 + bnColor;
                if self.cards_.m_nBaoValue~=0 then
                    if anValue==self.cards_.m_nBaoValue then
                        if a:getCardValue().m_nCard_Baovalue>=3 and a:getCardValue().m_nCard_Baovalue<=15 then
                            thisorderA = a:getCardValue().m_nCard_Baovalue*4+anColor
                        end
                    end
                    if bnValue==self.cards_.m_nBaoValue then
                        if b:getCardValue().m_nCard_Baovalue>=3 and b:getCardValue().m_nCard_Baovalue<=15 then
                            thisorderB = b:getCardValue().m_nCard_Baovalue*4+bnColor
                        end
                    end
                end
                if thisorderA > thisorderB then
                    return true
                else 
                    return false
                end
            end
            print("Me:PlaySelectCard=====")
            var_dump(discardvalues)
            table.sort(discardList, sortFunc)
            local i=0;
            for k,pCard in pairs(discardList) do
                if pCard:getCardValue().m_nValue ~= 99 then
                    local thiscardValue = pCard:getCardValue()
                    if pCard:getCardValue().m_nCard_Baovalue~=0 then
                        -- pCard:removeAllChildrenWithCleanup(true);
                        pCard:removeFromParentAndCleanup(true)
                        local pCard1 = require("moduleDdz.ctrllers.CCardSprite").new(self.gamescene,thiscardValue,self.cards_.m_nBaoValue,1,true);
                        pCard1:setAnchorPoint(CCPointMake(0,0))
                        self.play_card_:addChild(pCard1,i+1)
                        local action1 = CCMoveTo:create(0.2, ccp(ptPlayCard.x+i*40, ptPlayCard.y));
                        local action2 = CCScaleTo:create(0.2,0.9);
                        local action5 = CCSpawn:createWithTwoActions(action1, action2);
                        pCard1:runAction(action5);
                        
                    else
                        pCard:setAnchorPoint(CCPointMake(0,0))
                        self.play_card_:addChild(pCard,i+1)
                        local action1 = CCMoveTo:create(0.2, ccp(ptPlayCard.x+i*40, ptPlayCard.y));
                        local action2 = CCScaleTo:create(0.2,0.9);
                        local action5 = CCSpawn:createWithTwoActions(action1, action2);
                        pCard:runAction(action5);
                    end
                    i = i+1;
                end
            end
        end
        -- print("Me:PlaySelectCard=====")
        -- var_dump(discardvalues)
    end
    self:AlignHandCard()
end
   
function Me:OnRefreshCardSound()

end

-- function Me:OnReorder(sender, data)
--     self.gamescene.puKeLayer:reorderChild(sender,data);
-- end

function Me:AlignHandCard()
    local cardSize = CCSizeMake(152,200) --(138,182)
    local winSize = CCSizeMake(1136,200) --牌面显示区域
    local screenWidth = CCDirector:sharedDirector():getWinSize().width
    local nNum = #self.MeCCard
    local nDistance = winSize.width  / (nNum + 1); --两牌间距 
    if (nDistance > 50) then
        nDistance =  50;
    end
    local nWidth = (nNum - 1) * nDistance + cardSize.width;
    local ptHandCardPos = ccp(-nWidth / 2 + cardSize.width/2,cardSize.height/2-2);
    -- local moveaction = CCMoveTo:create(0.5, ccp(ptHandCardPos.x+(i-1)*nDistance+screenWidth/2, ptHandCardPos.y))
    --                     local doithander = function()
    --                         self.gamescene.puKeLayer:reorderChild(v1,i+1)
    --                     end
    --                     action6 = CCCallFunc:create(doithander)
    --                     v1:runAction(transition.sequence({moveaction}))
    --                     self.MeCCard[i] = v1
    --local pChildren = self.gamescene.puKeLayer:getChildren();
    for i=1, #self.MeCCard do
        local pObject = self.MeCCard[i]
        if pObject and pObject:getCardValue().m_nValue ~= 99 then
            local moveaction = CCMoveTo:create(0.5, ccp(ptHandCardPos.x+(i-1)*nDistance+screenWidth/2, ptHandCardPos.y))
            local doithander = function()
                self.gamescene.puKeLayer:reorderChild(pObject,i+1)

            end
            local actionCallBack = CCCallFunc:create(doithander)
            pObject:runAction(transition.sequence({moveaction,actionCallBack}))
            -- local action = CCMoveTo:create(0.5, ccp(ptHandCardPos.x+i*nDistance+screenWidth/2, ptHandCardPos.y));
            -- pObject:runAction(action);
        end
    end

    -- if (pChildren) then
    --     for i=0, pChildren:count()-1 do
    --         local pObject = pChildren:objectAtIndex(i)
    --         if pObject and pObject:getCardValue().m_nValue ~= 99 then
    --             local action = CCMoveTo:create(0.5, ccp(ptHandCardPos.x+i*nDistance+screenWidth/2, ptHandCardPos.y));
    --             pObject:runAction(action);
    --         end
    --     end
    -- end
end

function Me:EnableOpt(flag)  --设置是否可操作 用于托管

end

function Me:DownloadHeadIcon(head_url)

end

function Me:startClientTimer(nSecond)
    local ctrllerGame = self.gamescene.ctrller

    if self.gamescene.ctrller.is_auto_ == false then
        -- if self.gamescence.
        if ctrllerGame.data.is_game_start_==true then
            if (ctrllerGame.data.nowcChairID==-1 or ctrllerGame.data.nowcChairID==ctrllerGame.data.self_ply_attrs_.chair_id_ or ctrllerGame.data.nowCardTyp.m_nTypeNum==0) then
               
            else            
                if #self.cards_.m_vecTipsCards==0 and nSecond~=0 then
                    nSecond = 3
                end
            end
        end
        
    end
    self.super:startClientTimer(nSecond)
end

function Me:onTimer(dt)
    self.super:onTimer(dt)

end
function Me:resAlarmNum(reNum)
    self.super:resAlarmNum(reNum)
end

function Me:ShowTips(nOp)  --显示玩家操作提示
    self.super:ShowTips(nOp)
end

function Me:OnPlayCardNot(noti)  --显示打出的牌
    self.super:OnPlayCardNot(noti)
end

function Me:PlayAni(ani_type)
    self.super:PlayAni(ani_type)
end
return Me;
