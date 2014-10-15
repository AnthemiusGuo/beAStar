--
-- Author: Xupinhui
-- Date: 2014-08-13 15:56:44
--
local LotteryDraw = class("LotteryDraw", izx.baseView)

  LotteryDraw.latencyTime = 10;

  function LotteryDraw:ctor(pageName,moduleName,initParam)
    print("LotteryDraw:ctor");
    self.super.ctor(self,pageName,moduleName,initParam);
  end
  
  function LotteryDraw:onAssignVars()
    print("LotteryDraw:onAssignVars")
    self.drawNode = tolua.cast(self["draw_node"], "CCNode");
    print("self.drawNode")
    self.lastTurnNode = tolua.cast(self["last_turn_node"], "CCNode");
      print("self.lastTurnNode")
    self.showNode = tolua.cast(self["show_node"], "CCNode");
    
    self.btnPai = {};
    self.awardNode = {};
    
    for i = 1, 4 do
      if self["btn_pai"..i] ~= nil then
        self.btnPai[i] = tolua.cast(self["btn_pai"..i], "CCControlButton");
      end
      
      if self["award_node_"..i] ~= nil then
        self.awardNode[i] = tolua.cast(self["award_node_"..i], "CCNode");
      end
    end
    
    self.sprite_icon = tolua.cast(self["sprite_item"], "CCSprite");
    
    self.txt_item_num = tolua.cast(self["txt_item_num"], "CCLabelTTF");
            
    self.txt_round_s = tolua.cast(self["txt_round_s"], "CCLabelTTF");
    print(111);
    self.txt_item_num:setString("sadsad")
    self:showHistory();
        print(112);
    self:setDrawStatus();
    self.rootNode = tolua.cast(self.rootNode, "CCNode");
    print(222);
        
  end
  
  function LotteryDraw:onInitView()
    self.myscheduler = require("framework.scheduler");
    self.mySchedulerHandle = self.myscheduler.scheduleGlobal(handler(self, self.onTimeOut), LotteryDraw.latencyTime);
    
    self.selectIndex = nil;
    
    local winSize = CCDirector:sharedDirector():getWinSize();
    
    function clickMask(event, x, y, prevX, prevY)
            echoInfo(event..":MASK!");
            if (event=="began") then
                return true;
            end
            
            if ((event=="ended")) then
                self:onPressBack();
            end 
            return true;
        end
    
    -- print("=========display.y = "..display.cy.." winSize.w = "..winSize.width.." winSize.h = "..winSize.height.." rootNode h = "..ccp(self.rootNode:getPosition()).y);
    
    self.maskLayerColor = display.newScale9Sprite("images/bg.png", display.cx, display.cy - ccp(self.rootNode:getPosition()).y, CCSizeMake(winSize.width, winSize.height));
    self.maskLayerColor:setTouchEnabled(true);
    self.maskLayerColor:addTouchEventListener(clickMask);
    
    self.rootNode:addChild(self.maskLayerColor);
    
    self.rootNode:reorderChild(self.drawNode, self.maskLayerColor:getZOrder()+1);
    self.rootNode:reorderChild(self.lastTurnNode, self.maskLayerColor:getZOrder()+1);
    self.rootNode:reorderChild(self.showNode, self.maskLayerColor:getZOrder()+1);
  end
  
  function LotteryDraw:onPressBack()
    
    --gBaseLogic.gameLogic.gamePage.view:closingBox()
    if self.blockClick==true then
    	return false;
    end
    self.logic.LotteryDrawWuLayershow = nil
    self.logic.gamePage.view:setBaoXiangSprite(false)
    gBaseLogic.sceneManager:removePopUp("LotteryDraw");
    if self.myscheduler ~= nil then
      self.myscheduler.unscheduleGlobal(self.mySchedulerHandle);
      self.myscheduler = nil;
    end
  end
  
  function LotteryDraw:onPressSelect(index)
    self.selectIndex = index;
    self.ctrller:sendAwardReq();
    
    if self.myscheduler ~= nil then
      self.myscheduler.unscheduleGlobal(self.mySchedulerHandle);
      --self.mySchedulerHandle = self.myscheduler.scheduleGlobal(handler(self, self.onTimeOut), 5);
    end
    
  end
  
  function LotteryDraw:onPressPai1()
    if self.selectIndex ~= nil then
      return;
    end
  
    self:onPressSelect(1);
    
    --self:openAni(1, {index_ = 1, number_ = 1000});
    --self:drawLight(self.selectIndex);
  end
  
  function LotteryDraw:onPressPai2()
    if self.selectIndex ~= nil then
      return;
    end
    
    self:onPressSelect(2);
  end
  
  function LotteryDraw:onPressPai3()
    if self.selectIndex ~= nil then
      return;
    end
    
    self:onPressSelect(3);
  end
  
  function LotteryDraw:onPressPai4()
    if self.selectIndex ~= nil then
      return;
    end
    
    self:onPressSelect(4);
  end
  
  function LotteryDraw:getAwardResult(items)
  
    if items == nil or  #items == 0 then
      return;
    end
  
    if nil ~= items[1] then
      self:openAni(self.selectIndex, items[1]);
      self:drawLight(self.selectIndex);
      
      --[[
      --更新除了游戏币外的其他道具
      if items[1].index_ ~= 0 then 
        for k,v in pairs(gBaseLogic.lobbyLogic.userData.ply_items_) do
          if items[1].index_ == v.index_ then
              v.num_ = v.num_ + items[1].number_;
          end
        end
      end
      --]]
      self.logic.LotteryDraw.history.item = items[1].index_;
      self.logic.LotteryDraw.history.num = items[1].number_;
    end
  
    local index = 1;
    for i = 2, 4 do
      if nil ~= items[i] then
        if index == self.selectIndex then
          index = index + 1;
        end
        --print("=====index = "..index);
        self:openAni(index, items[i], 1.5);
        
        index = index + 1;
      end
    end
       
    if self.myscheduler ~= nil then
      self.myscheduler.unscheduleGlobal(self.mySchedulerHandle);
      self.mySchedulerHandle = self.myscheduler.scheduleGlobal(handler(self, self.onTimeOut), 5);
    end
    
  end
  
  
  function LotteryDraw:openAni(index, item, delay)
    --print("===openAni index = "..index);
    var_dump(item);
    delay = delay or 0.1;
    local openAni = getAnimationWithFrameList("ani_choujiang", "ani_choujiang", "donghua", {0,1,2,3,4,5});
    --local openAni = getAnimation("ani_choujiang")
    local ani_first_frame = CCSprite:createWithSpriteFrame(tolua.cast(openAni:getFrames():objectAtIndex(0),"CCAnimationFrame"):getSpriteFrame());
    self.btnPai[index]:setVisible(false);
    ani_first_frame:setPosition(ccp(self.btnPai[index]:getPosition()));
    self.awardNode[index]:addChild(ani_first_frame);
    local showAward = function()
      self:drawAward(index, item);
    end
    ani_first_frame:runAction(transition.sequence({CCDelayTime:create(delay), CCAnimate:create(openAni), CCCallFuncN:create(showAward)}));
  end
  
  function LotteryDraw:drawAward(index, item)
    --self.btnPai[index]:setVisible(true);
    self.btnPai[index]:setEnabled(false);
    
    local itemInfo = nil;
    for k,v in pairs(gBaseLogic.lobbyLogic.userData.ply_items_) do
      if item.index_ == v.index_ then
          itemInfo = v;
      end
    end
    
    if itemInfo == nil then
      return;
    end
    local filemian = "images/TongYong/ChouJiangPaiBei_Hui.png"  
    if self.selectIndex==index then
    	filemian = "images/TongYong/ChouJiangPaiMian.png"    	
    end
    local spritemian = CCSprite:createWithTexture(getCCTextureByName(filemian));
    self.awardNode[index]:addChild(spritemian);
    izx.resourceManager:imgFileDown(itemInfo.url_,true,function(fileName)
      --print("==========(getCCTextureByName(fileName)================"..( getCCTextureByName(fileName) == nil and 0 or 1))
      local sprite = CCSprite:createWithTexture(getCCTextureByName(fileName));
      sprite:setScale(1.2);
      sprite:setPosition(ccp(0, 25));
      self.awardNode[index]:addChild(sprite);
    end);
    if self.selectIndex==index then
	    local sprite1 = CCSprite:createWithTexture(getCCTextureByName("images/TongYong/ChouJiangGuang.png"));
	     self.awardNode[index]:addChild(sprite1);
	 end
    
    local thisdesc = itemInfo.name_.."x"..item.number_;
    if item.index_==0 then
    	thisdesc = item.number_.."金币";
    end
    local number_num = CCLabelTTF:create(thisdesc,"Helvetica", 36)
    number_num:setPosition(-6,-122);
    -- self["shownode"..index]:addChild(number_num);
    self.awardNode[index]:addChild(number_num);
  end
  function LotteryDraw:showAward(index, item)
    --self.btnPai[index]:setVisible(true);
    -- if self.logic.LotteryDraw.curGames >= self.logic.LotteryDraw.reqGames then
    -- 	return;
    -- end
    -- self["shownode"..index]:removeAllChildrenWithCleanup(true);
    
    local itemInfo = nil;
    for k,v in pairs(gBaseLogic.lobbyLogic.userData.ply_items_) do
      if item.index_ == v.index_ then
          itemInfo = v;
      end
    end
    
    if itemInfo == nil then
      return;
    end
    
    izx.resourceManager:imgFileDown(itemInfo.url_,true,function(fileName)
      --print("==========(getCCTextureByName(fileName)================"..( getCCTextureByName(fileName) == nil and 0 or 1))
      local sprite = CCSprite:createWithTexture(getCCTextureByName(fileName));
      sprite:setScale(1.2);
      sprite:setPosition(ccp(0, 25));
      self["shownode"..index]:addChild(sprite);
    end);
    
    -- local number_num = CCLabelBMFont:create("x"..item.number_, "images/fonts/KaiBaoXiangBeiShu.fnt");
    -- CCLabelTTF()
    local thisdesc = itemInfo.name_.."x"..item.number_;
    if item.index_==0 then
    	thisdesc = item.number_.."金币";
    end
    local number_num = CCLabelTTF:create(thisdesc,"Helvetica", 36)
    number_num:setPosition(-6,-122);
    self["shownode"..index]:addChild(number_num);
  end
  
  function LotteryDraw:drawLight(index)
    
    local light = CCSprite:create("images/TongYong/ChouJiangPaiMian_XuanZhong.png");
    light:setPosition(ccp(0,0));
    self.awardNode[index]:addChild(light);
    
    light:runAction(CCRepeatForever:create(transition.sequence({CCFadeTo:create(1, 0), CCFadeTo:create(1, 200)})));
  end
  
  function LotteryDraw:onTimeOut()
    self:onPressBack();
  end
  
  function LotteryDraw:showHistory()

    if self.logic.LotteryDraw.history.item == nil then
      self.lastTurnNode:setVisible(false);
      return;
    end
    
    local itemInfo = nil;
    for k,v in pairs(gBaseLogic.lobbyLogic.userData.ply_items_) do
      if self.logic.LotteryDraw.history.item == v.index_ then
          itemInfo = v;
      end
    end
    var_dump(itemInfo)
    -- if itemInfo == nil then
    --   self.lastTurnNode:setVisible(false);
    --   return;
    -- end
    
    -- self.lastTurnNode:setVisible(true);
    
    -- izx.resourceManager:imgFileDown(itemInfo.url_,true,function(fileName)
    --   --print("==========(getCCTextureByName(fileName)================"..( getCCTextureByName(fileName) == nil and 0 or 1))
    --   self.sprite_icon:setTexture(getCCTextureByName(fileName));
    -- end);
	if itemInfo==nil then 
		self.lastTurnNode:setVisible(false);
	else

	    self.lastTurnNode:setVisible(true);
	    self.txt_item_num:setString(itemInfo.name_.."x"..(self.logic.LotteryDraw.history.num));
	end
    
  end
  
  function LotteryDraw:setDrawStatus()
  	print("LotteryDraw:setDrawStatus")
  	-- self.ctrller:pt_cb_get_luck_data_list_req()
    if self.logic.LotteryDraw.curGames >= self.logic.LotteryDraw.reqGames then
    	self.txt_round_s:setString("点击宝箱获取奖励")
    	print("111")
    	self.blockClick= true
      
      	local function runActionCallBack()
      		self.blockClick= false
  		end
  		local function runActionCallBack1()
  			print("11111");
      		self.drawNode:setVisible(true);
      		self.showNode:setVisible(false);
  		end
  		-- self.drawNode:setVisible(true);
    --   		self.showNode:setVisible(false);
  		local action0 = CCCallFunc:create(runActionCallBack1);
  		local action4 = CCCallFunc:create(runActionCallBack);
  		local action5 = CCDelayTime:create(0.5);
  		local action6 = CCDelayTime:create(1);
  		-- local action = CCDelayTime:create(0.2);
      for i=1,4 do

      	local px,py = self.awardNode[i]:getPosition();
      	local action1 = CCMoveTo:create(0.3, ccp(display.cx,py))  
      	local thisnu = -1
      	if i>2 then
      		thisnu=1
      	end    	
      	local action2 = CCMoveTo:create(0.3, ccp(display.cx+thisnu*160,py))
      	local action3 = CCMoveTo:create(0.3, ccp(px,py))
      	
      	self.awardNode[i]:runAction(transition.sequence({action6,action0,action5,action1,action5,action2,action1,action2,action1,action3,action4}))

      end
      
      
    else
      self.drawNode:setVisible(false);
      self.showNode:setVisible(true);
      
      self.txt_round_s:setString("还剩"..self.logic.LotteryDraw.reqGames - self.logic.LotteryDraw.curGames.."局就可抽取以下奖励");
    end
  end

return LotteryDraw;