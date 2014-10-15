local BiSaiWinScene = class("BiSaiWinScene",izx.baseView)

function BiSaiWinScene:ctor(pageName,moduleName,initParam)
	print ("BiSaiWinScene:ctor")

	self.super.ctor(self,pageName,moduleName,initParam);
end

function BiSaiWinScene:onAssignVars()
	self.rootNode = tolua.cast(self.rootNode,"CCNode");

    if nil ~= self["labelRank"] then
    	self.labelRank = tolua.cast(self["labelRank"],"CCLabelTTF")
    end
    if nil ~= self["labelName1"] then
        self.labelName1 = tolua.cast(self["labelName1"],"CCLabelTTF")
    end
    if nil ~= self["labelName2"] then
        self.labelName2 = tolua.cast(self["labelName2"],"CCLabelTTF")
    end

    if nil ~= self["labelName3"] then
        self.labelName3 = tolua.cast(self["labelName3"],"CCLabelTTF")
    end
    if nil ~= self["labelReward1"] then
        self.labelReward1 = tolua.cast(self["labelReward1"],"CCLabelTTF")
    end
    if nil ~= self["labelReward2"] then
        self.labelReward2 = tolua.cast(self["labelReward2"],"CCLabelTTF")
    end

    if nil ~= self["labelReward3"] then
        self.labelReward3 = tolua.cast(self["labelReward3"],"CCLabelTTF")
    end
    if nil ~= self["spriteImg1"] then
        self.spriteImg1 = tolua.cast(self["spriteImg1"],"CCSprite")
    end 
    if nil ~= self["spriteImg2"] then
        self.spriteImg2 = tolua.cast(self["spriteImg2"],"CCSprite")
    end 
    if nil ~= self["spriteImg3"] then
        self.spriteImg3 = tolua.cast(self["spriteImg3"],"CCSprite")
    end 
    if nil ~= self["spriteTitleBg"] then
        self.spriteTitleBg = tolua.cast(self["spriteTitleBg"],"CCSprite")
    end 
    if nil ~= self["spriteTitle"] then
        self.spriteTitle = tolua.cast(self["spriteTitle"],"CCSprite")
    end  
end

function BiSaiWinScene:onInitView() 
    print("BiSaiWinScene:onInitView")
    self.labelName1:setString("");
    self.labelName2:setString("");
    self.labelName3:setString("");
    self.labelRank:setString("");

    self:lightAnimation()
    --self:initBaseInfo()
end

function BiSaiWinScene:initBaseInfo()
    print("BiSaiWinScene:initBaseInfo")

    self:showRankLists(self.ctrller.data.matchResult)
end


function BiSaiWinScene:onPressOther()
    print("onPressOther")
    izx.baseAudio:playSound("audio_menu");
    gBaseLogic.sceneManager:removePopUp("BiSaiWinScene");
    gBaseLogic.lobbyLogic:showBiSaiChang()
end


function BiSaiWinScene:onPressBack()
    print "onPressBack"
    izx.baseAudio:playSound("audio_menu");
    
    gBaseLogic.lobbyLogic:goBackToMain();
end

function BiSaiWinScene:lightAnimation()
    print("lightAnimation");
    local sName = "light_ani";
    local ani = CCAnimationCache:sharedAnimationCache():animationByName(sName);

    if (ani) then
    else
        ani = CCAnimation:create();
        ani:setDelayPerUnit(0.1);
        ani:addSpriteFrameWithFileName("images/DaTing/lobby_bisai_paibianguang1.png") 
        ani:addSpriteFrameWithFileName("images/DaTing/lobby_bisai_paibianguang2.png")             
        
        CCAnimationCache:sharedAnimationCache():addAnimation(ani, sName);

    end 

    local frame =  tolua.cast(ani:getFrames():objectAtIndex(0),"CCAnimationFrame"):getSpriteFrame()
    local sprite = CCSprite:createWithSpriteFrame(frame);

    sprite:setAnchorPoint(ccp(0.5,1.0))
    sprite:setPosition(self.spriteTitleBg:getPosition());
    self.rootNode:addChild(sprite);
    sprite:runAction(CCRepeatForever:create(CCAnimate:create(ani)));
end

function BiSaiWinScene:setMatchTitle()
    if self.ctrller.data.matchResult ~= nil then 
        local fileName = self.ctrller.matchTitle[self.ctrller.data.matchResult.match_typ_]
        print("setMatchTitle:",fileName)
        self.spriteTitle:setTexture(getCCTextureByName(fileName)) 
    end
end 
function BiSaiWinScene:onRemovePage()
	if self.scheduler~=nil then
	 	scheduler.unscheduleGlobal(self.scheduler)
    	self.scheduler = nil
    end
    if self.serTimeHandler~=nil then
	 	scheduler.unscheduleGlobal(self.serTimeHandler)
    	self.serTimeHandler = nil
    end
end 
function BiSaiWinScene:showRankLists(data)
    print("showRankLists")

    if data == nil then 
        return 
    end
    var_dump(data,3)
    self.ctrller:getHeadImage(data.ply_vec_) 
    self:setMatchTitle()
    HTTPPostRequest(URL.Match_Info, {matchid=data.match_id_}, function(event)
        print("BiSaiChangeSceneCtrller:reqRaceRoomInfoData")
        if (event ~= nil) then
            var_dump(event,5)
            local awardInfo = {};
            if event.awardInfo~=nil then
            	for k,v in pairs(event.awardInfo) do
            		awardInfo["rank"..v.rankid] = v;
            	end
            	self.labelReward1:setString(awardInfo["rank1"].bonusname)
	            self.labelReward2:setString(awardInfo["rank2"].bonusname)
	            self.labelReward3:setString(awardInfo["rank3"].bonusname)
            end
            if data.ply_vec_[data.rank_index_]~= nil and awardInfo["rank"..data.rank_index_]~=nil then
	            self.labelRank:setString("经过连番苦斗，最终斩获"..data.rank_index_.."，获得"..awardInfo["rank"..data.rank_index_].bonusname)
			end
            -- --local message =  self:initRaceRoomLocalInfoData()
            -- local message = event 
            -- gBaseLogic.lobbyLogic.matchInfo = message
            -- self:resetData(message)
            -- self.view:initBaseInfo(); 
       --      if event.matchinfo~=nil then
       --      	self.ctrller.data.matchtyp = event.matchinfo.matchtype;
		     -- 	if self.spriteTitle~=nil then
			    --     local fileName = self.ctrller.matchTitle[self.ctrller.data.matchtyp]

			    --     self.spriteTitle:setTexture(getCCTextureByName(fileName))
			    -- end
       --      end
        end     
        end);

    -- if gBaseLogic.lobbyLogic.matchInfo == nil then 
    --     self.ctrller:reqRaceRoomInfoData()
    --     return 
    -- end

    -- local reward ={}
    -- for k,v in pairs(gBaseLogic.lobbyLogic.matchInfo.riCheng) do  
    --     if v.matchid ==  data.match_id_ then 
    --         reward = v.reward 
    --         self.labelReward1:setString(reward[1].bonus)
    --         self.labelReward2:setString(reward[2].bonus)
    --         self.labelReward3:setString(reward[3].bonus)
    --     end
    -- end 
    

end

function BiSaiWinScene:updataHeadImage(idx,url,name)
	print("BiSaiWinScene:updataHeadImageView")
	print(idx,url,name);
    self["labelName"..idx]:setString(name)
    izx.resourceManager:imgFileDown(url,true,function(fileName) 
            if self~=nil and self.head_icon~=nil then
                self["spriteImg"..idx]:setTexture(getCCTextureByName(fileName))
            end
    end)
end 

function BiSaiWinScene:unWaitingAni(target,opt)
    scheduler.unscheduleGlobal(self.scheduler)
    self.scheduler = nil
    gBaseLogic:unblockUI();

end

function BiSaiWinScene:loadingAni()
     --gBaseLogic.sceneManager:waitingAni(self.rootNode,self.unWaitingAni,100)
     gBaseLogic:blockUI();
     self.scheduler = scheduler.performWithDelayGlobal(handler(self, self.unWaitingAni), 5.0)
end

return BiSaiWinScene;