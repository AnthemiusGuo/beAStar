local BiSaiChangScene = class("BiSaiChangScene",izx.baseView)

function BiSaiChangScene:ctor(pageName,moduleName,initParam)
	print ("BiSaiChangScene:ctor")
	self.diffTime = 0;
	self.super.ctor(self,pageName,moduleName,initParam);

end

function BiSaiChangScene:onAssignVars()
	self.rootNode = tolua.cast(self.rootNode,"CCNode");

    if nil ~= self["labelRaceTick"] then
    	self.labelRaceTick = tolua.cast(self["labelRaceTick"],"CCLabelTTF")
    end
    if nil ~= self["labelGift"] then
        self.labelGift = tolua.cast(self["labelGift"],"CCSprite")
    end
    if nil ~= self["labelCostTick"] then
        self.labelCostTick = tolua.cast(self["labelCostTick"],"CCLabelTTF")
    end

    if nil ~= self["labelMoney"] then
        self.labelMoney = tolua.cast(self["labelMoney"],"CCLabelTTF")
    end

    if nil ~= self["spriteTitleBg"] then
        self.spriteTitleBg = tolua.cast(self["spriteTitleBg"],"CCSprite")
    end 

    if nil ~= self["nodeRoom1"] then
        self.nodeRoom1 = tolua.cast(self["nodeRoom1"],"CCNode")
    end
    
end


function BiSaiChangScene:resetLabelValue(data)
    self.labelRaceTick:setString(data.cansaiquan) 
    self.labelCostTick:setString(data.huafeiquan) 
    self.labelGift:setString(data.gift) 
    self.labelMoney:setString(data.money)
end 

function BiSaiChangScene:onInitView() 
    print("BiSaiChangScene:onInitView")

    self:lightAnimation()
    --self:initBaseInfo()
end

function BiSaiChangScene:initBaseInfo()
    print("BiSaiChangScene:initBaseInfo")
    var_dump(self.ctrller.data.riCheng);
    self:showRoomLists(self.ctrller.data.riCheng) 

    -- if gBaseLogic.lobbyLogic.matchData ~= nil then 
    --     var_dump(gBaseLogic.lobbyLogic.matchData)
    --     for k,v in pairs(gBaseLogic.lobbyLogic.matchData) do 
    --         self:showMatchStartAni(v.match_id)
    --     end
         
    -- end
    --self:showMatchStartAni(1)  -- for test
    self:resetLabelValue(self.ctrller.data)
    var_dump(self.ctrller.raceTimeList);
    local curZeit = os.time();
    local curtime = tonumber(os.time());
    if self.ctrller.data.curtime~=nil then
    	curtime = self.ctrller.data.curtime;
    	self.diffTime = self.ctrller.data.curtime-curZeit;
    end
   
    local OnTimer = function(dt)
    	print("BiSaiChangScene:OnTimer"..#self.ctrller.raceTimeList);
        if self.ctrller.raceTimeList~=nil and #self.ctrller.raceTimeList>0 then
        	local zeit = tonumber(os.time());
        	local zeithasGo = zeit-curZeit;
        	for k,v in pairs(self.ctrller.raceTimeList) do
        		if v.remtime~=nil then
	        		v.remtime = tonumber(v.remtime)
	        		print("BiSaiChangScene:initBaseInforemtime:"..v.remtime)
	        		if v.remtime-zeithasGo<1800 and v.remtime-zeithasGo>0 then
	        			local ddt = os.date("%M:%S",v.remtime-zeithasGo);
	        			if v.labelRaceTime~=nil then
	        				v.labelRaceTime:setString("倒计时"..ddt);
	        			end
	        		end
	        		if v.remtime-zeithasGo<=0 then
	        			v.labelRaceTime:setString("比赛即将开始");
	        			if v.remtime-zeithasGo==0 then
	        				self.ctrller:reqRaceRoomInfoData(true) 
	        			end
	        		end
	        		-- print("v.spriteBaoMing:isVisable"..v.spriteBaoMing:isVisable())
	        		print(v.remtime-zeithasGo)
	        		if v.remtime-zeithasGo<=5 and v.state==1 then
	        			self.logic:showBiSaiFailScene({match_id_=v.matchid,pre_match=1})
	        		end
	        		
	        	end
        	end

        end
    end
    if self.serTimeHandler==nil then
    	print(1111);
    	self.serTimeHandler = scheduler.scheduleGlobal(OnTimer, 1, false)
    end
end

function BiSaiChangScene:onPressReward()
    print("onPressReward")
    izx.baseAudio:playSound("audio_menu");
    var_dump(self.ctrller.data.history)
    self:showReward(self.ctrller.data.history)
end

function BiSaiChangScene:onPressPay()
    print("onPressPay")
    izx.baseAudio:playSound("audio_menu");
    gBaseLogic.lobbyLogic:quickPay(0,3);--smsQuickPayCharge,//  游戏时玩家主动充值
end

function BiSaiChangScene:onPressRaceInfo()
    print("onPressRaceInfo")
    izx.baseAudio:playSound("audio_menu");
    self:showRiCheng(self.ctrller.data.riCheng)
end 

function BiSaiChangScene:onPressBack()
    print "onPressBack"
    izx.baseAudio:playSound("audio_menu");
    gBaseLogic.lobbyLogic:goBackToMain()
    -- gBaseLogic:confirmBox({
    --     msg="一大波笨笨的农民正在赶来，真的要退出比赛吗？话费正在远离你……",
    --     btnTitle={btnConfirm="继续报名",btnCancel="返回大厅"},
    --     callbackConfirm = function()
    --         gBaseLogic.sceneManager.currentPage.view:closePopBox() 
    --     end,
    --     callbackCancel = function()
    --         gBaseLogic.lobbyLogic:goBackToMain()
    --     end})
end

function BiSaiChangScene:lightAnimation()
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

function BiSaiChangScene:onPressGotoMatch(matchid)
    print("onPressGotoMatch:",matchid)
    for k,v in pairs(gBaseLogic.lobbyLogic.matchData) do 
        if matchid == v.match_id_ then 
            gBaseLogic.lobbyLogic:startMatchGame("moduleDdz",matchid,0)
        end 
    end
end

function BiSaiChangScene:showMatchStartAni(matchid)
    print("BiSaiChangScene:showMatchStartAni")
    local x = 0
    for k,v in pairs(self.ctrller.data.riCheng) do 
        if v.matchid == matchid then 
            x = k
            break
        end
    end 

    if x == 0  then 
        return 
    end

    local ani = getAnimation("beginAnimation");
    local frame =  tolua.cast(ani:getFrames():objectAtIndex(0),"CCAnimationFrame"):getSpriteFrame()
    local m_playAni = CCSprite:createWithSpriteFrame(frame);
    local action = CCRepeatForever:create(transition.sequence({CCAnimate:create(ani),CCDelayTime:create(2)}));
    m_playAni:runAction(action)--CCDelayTime:create(10)
    m_playAni:setPosition(self["nodeRoom"..x]:getPosition());
    self.rootNode:addChild(m_playAni); 
    --[[
    function onTouch(target, event, x, y) 
        print("showMatchStartAni--onTouch")
        if (event=="began") then 
            echoInfo(event..":Icon!");
            return true;
        end
        if (event=="ended") then
            echoInfo(event..":Icon!");
            var_dump(target)
            target:onPressGotoMatch(matchid)          
            return true;
        end

        return true;
    end
    m_playAni:setTouchEnabled(true);
    m_playAni:setTag(matchid)
    m_playAni:addTouchEventListener(handler(self, onTouch))
    --]]
end 

function BiSaiChangScene:showRoomLists(data)
	self.nodeRoomList:removeAllChildrenWithCleanup(true);
    for k,v in pairs(data) do
        local proxy = CCBProxy:create();
        local table = {};
        function table:onPressIntoRoom(asc,sender)
            local id = sender:getTag();
            -- if gBaseLogic.lobbyLogic.matchData ~= nil then 
            --     for k,v in pairs(gBaseLogic.lobbyLogic.matchData) do
            --         print(data[id].matchid,v.match_id_) 
            --         if data[id].matchid == v.match_id_ then 
            --             --gBaseLogic.lobbyLogic:startMatchGame("moduleDdz",v.matchid,0)
            --             self.view:onPressGotoMatch(v.match_id_) 
            --             return 
            --         end
            --     end 
            -- end
            self.view:showBaoMing(id);
            -- if os.time()> data[id].time then
            --      izxMessageBox("比赛已开始，报名时间已过，请选择其他比赛。","温馨提示")
            -- elseif os.time() >= data[id].time - data[id].signtime then 
                
            -- else 
            --     izxMessageBox("报名时间未到，请选择其他比赛。","温馨提示")
            -- end 
            
        end

        local node = CCBuilderReaderLoad("interfaces/BiSaiChangFangJian.ccbi",proxy,table);
        table.labelRaceTime = tolua.cast(table["labelRaceTime"],"CCLabelTTF")
        table.labelRaceName = tolua.cast(table["labelRaceName"],"CCLabelTTF")
        table.labelRaceTick = tolua.cast(table["labelRaceTick"],"CCLabelTTF")

        table.spriteRoomBg1 = tolua.cast(table["spriteRoomBg1"],"CCSprite")
        table.spriteRoomBg2 = tolua.cast(table["spriteRoomBg2"],"CCSprite")
        table.spriteRoomMark1 = tolua.cast(table["spriteRoomMark1"],"CCSprite")
        table.spriteRoomMark2 = tolua.cast(table["spriteRoomMark2"],"CCSprite")

        table.btnIntoRoom = tolua.cast(table["btnIntoRoom"],"CCControlButton")
        table.btnIntoRoom:setTag(k)
        table.view = self
        node:setPosition(self["nodeRoom"..k]:getPosition());
        self.nodeRoomList:addChild(node);
        self["nodeRoom"..k]:setVisible(true)
        if get00ofday()==get00ofday(v.time) then

        	table.labelRaceTime:setString(os.date("%H:%M", v.time).."开赛") 
        else
        	table.labelRaceTime:setString(os.date("%m月%d日", v.time).."开赛") 
        end
        self.ctrller.raceTimeList[k] = {labelRaceTime=table.labelRaceTime,time=v.time,spriteBaoMing=table.spriteBaoMing,remtime=v.remtime,matchid=v.matchid,state=v.state}
        if v.state==1 then
        	table.spriteBaoMing:setVisible(true);
        end
        table.labelRaceName:setString(v.name) 
        if PLUGIN_ENV~=ENV_OFFICIAL then
        	 table.labelRaceName:setString(v.name.."("..v.matchid..")") 
        end
        table.labelRaceTick:setString("报名费:"..v.ticket)
        if v.starttype == 1 then 
            table.spriteRoomBg1:setVisible(true)
        elseif v.starttype == 2 then 
            table.spriteRoomBg2:setVisible(true)
            table.spriteRoomMark1:setVisible(true)
        elseif v.starttype == 3 then 
            table.spriteRoomBg2:setVisible(true)
            table.spriteRoomMark2:setVisible(true)
        end 
    end
end

function BiSaiChangScene:showBaoMing(id)
    local popBoxTips = {};
    local data = self.ctrller.data.riCheng[id]
    data.ctrller = self.ctrller

    function popBoxTips:onAssignVars()
        self.nodeTabView = tolua.cast(self["nodeTabView"],"CCNode");
        self.labelTime = tolua.cast(self["labelTime"],"CCLabelTTF");
        self.labelTick = tolua.cast(self["labelTick"],"CCLabelTTF")
        self.labelRule = tolua.cast(self["labelRule"],"CCLabelTTF")
        self.btnBaoMing = tolua.cast(self["btnBaoMing"], "CCControlButton")
        if self.labelmatchTitle~=nil then
       	 	self.labelmatchTitle = tolua.cast(self["labelmatchTitle"],"CCLabelTTF");
       	end
        if data.race==0 then
	        self.btnBaoMing:setTitleForState(CCString:create(data.state == 0 and "报 名" or "取消报名"),CCControlStateNormal);
	    elseif data.race==1 then
	    	if data.state==0 then
	    		self.btnBaoMing:setVisible(false);
	    		local a1 = CCLabelTTF:create("进行中", "", 40);
	    		a1:setPosition(self.btnBaoMing:getPosition())
	    		self.rootNode:addChild(a1);
	    		-- self.btnBaoMing:setTitleForState(CCString:create("退赛"),CCControlStateNormal);
	    	else
	    		self.btnBaoMing:setTitleForState(CCString:create("退赛"),CCControlStateNormal);
	    	end
	    end
	    self.labelmatchTitle:setString(data.name) 
        self.labelTime:setString(data.desc)  
        self.labelTick:setString(data.ticket)
        self.labelRule:setString(data.rule) 
        self:initTableView(self.nodeTabView, 0, data.reward);
    end
    function popBoxTips:initTableView(target,type,data)
        local winSize = target:getContentSize()
        print(winSize.width ,winSize.height)
        createTabView(target,winSize,type,data, self);
    end

    function popBoxTips.cellSizeForTable(table,idx)
        return 40,390
    end

    function popBoxTips.numberOfCellsInTableView(table)
        return #table:getParent().data
    end

    function popBoxTips.tableCellAtIndex(table, idx)
        print(idx.."-tableCellAtIndex-")
        local cell = table:dequeueCell()
        if nil == cell then        
            cell = CCTableViewCell:new()
        else
            cell:removeAllChildrenWithCleanup(true);
        end 

        local reward = table:getParent().data[idx+1]
        var_dump(reward)
        local this_title = reward.rank;
        if reward.title~=nil then
        	this_title = reward.title
        end
        
        local nameItem = CCLabelTTF:create(this_title..":", "Helvetica", 24.0,CCSizeMake(100, 40), ui.TEXT_ALIGN_RIGHT, ui.TEXT_VALIGN_CENTER)
        nameItem:setAnchorPoint(ccp(0,0.5))
        nameItem:setPosition(ccp(-8,20))
        cell:addChild(nameItem)
        -- local nameDesc = CCLabelTTF:create(reward.bonus, "Helvetica", 28.0,CCSizeMake(100, 40))
        local bonus = reward.bonus;
        -- bonus="话费卷7200个+话费卷7200个"
        -- if izx.UTF8.length(bonus)>12 then
        -- 	bonus = izx.UTF8.sub(bonus,1,10).."...";
        -- end
        
        local nameDesc = CCLabelTTF:create(bonus, "Helvetica", 24.0)
        nameDesc:setAnchorPoint(ccp(0,0.5))

        nameDesc:setPosition(ccp(100,20))
        cell:addChild(nameDesc)
        if idx == 0 then 
            nameItem:setColor(ccc3(252,213,74))
            nameDesc:setColor(ccc3(252,213,74))
        end
        return cell
    end
    function popBoxTips:onPressConfirm()
        print("onPressConfirm")
        if data.state == 0 then 
            if data.voucher > 0 and data.ctrller.data.cansaiquan >= data.voucher then 
              data.ctrller:pt_cl_do_sign_match_req(id) 
            elseif data.ctrller.data.money >= data.money or data.ctrller.data.vipLevel >= vip then  
                data.ctrller:pt_cl_do_sign_match_req(id)
            else 
                izxMessageBox("报名条件不足，请选择其他比赛。","温馨提示")
            end 
        else 
            data.ctrller:pt_cl_do_sign_match_req(id)
        end
    end

    function popBoxTips:onPressClose()
        gBaseLogic.sceneManager.currentPage.view:closePopBox();
    end 

    gBaseLogic.sceneManager.currentPage.view:showPopBoxCCB("interfaces/BiSaiChangBaoMing.ccbi",popBoxTips,true,1)
    gBaseLogic.sceneManager.currentPage.view.nodePopBox:setPosition(display.cx,display.cy);

end

function BiSaiChangScene:showRiCheng(data)
    local popBoxTips = {};
   
    function popBoxTips:onAssignVars()
        self.nodeTabView = tolua.cast(self["nodeTabView"],"CCNode");
        if nil ~= info then         
        end
        self:initTableView(self.nodeTabView, 0, data);
    end
    function popBoxTips:initTableView(target,type,data)
        local winSize = target:getContentSize()
        print(winSize.width ,winSize.height)
        createTabView(target,winSize,type,data, self);
    end

    function popBoxTips.cellSizeForTable(table,idx)
        return 70,620
    end

    function popBoxTips.numberOfCellsInTableView(table)
        return #table:getParent().data
    end

    function popBoxTips.tableCellAtIndex(table, idx)
        print(idx.."-tableCellAtIndex-")
        local cell = table:dequeueCell()
        if nil == cell then        
            cell = CCTableViewCell:new()
        else
            cell:removeAllChildrenWithCleanup(true);
        end 

        local data = table:getParent().data[idx+1]

        local nameItem = CCLabelTTF:create(data.name, "Helvetica", 28.0)
        nameItem:setAnchorPoint(ccp(0,0.5))
        nameItem:setPosition(ccp(20,40))
        cell:addChild(nameItem)
        local nameDesc = CCLabelTTF:create(data.desc, "Helvetica", 28.0)
        nameDesc:setAnchorPoint(ccp(0,0.5))
        nameDesc:setPosition(ccp(220,40))
        cell:addChild(nameDesc)
        
        return cell
    end

    function popBoxTips:onPressClose()
        gBaseLogic.sceneManager.currentPage.view:closePopBox();
    end 

    gBaseLogic.sceneManager.currentPage.view:showPopBoxCCB("interfaces/BiSaiChangRiCheng.ccbi",popBoxTips,true,1)
    gBaseLogic.sceneManager.currentPage.view.nodePopBox:setPosition(display.cx,display.cy);

end


function BiSaiChangScene:showReward(data)
    local popBoxTips = {};
   
    function popBoxTips:onAssignVars()
        self.nodeTabView = tolua.cast(self["nodeTabView"],"CCNode");
        if nil ~= info then         
        end
        if #data==0 or data[1].name==nil then
        	ShowNoContentTip(self.nodeTabView,"您还没有参与过任何比赛,赶快报名一场最近的比赛赢取丰厚奖励吧")
        else
        	self:initTableView(self.nodeTabView, 0, data);
        end
        -- self.node1:setVisible(true)
        -- self.node2:setVisible(false)
    end
    function popBoxTips:initTableView(target,type,data)
        local winSize = target:getContentSize()
        print(winSize.width ,winSize.height)
        createTabView(target,winSize,type,data, self);
    end

    function popBoxTips.cellSizeForTable(table,idx)
        return 50,620
    end

    function popBoxTips.numberOfCellsInTableView(table)
        return #table:getParent().data
    end

    function popBoxTips.tableCellAtIndex(table, idx)
        print(idx.."-tableCellAtIndex-")
        local cell = table:dequeueCell()
        if nil == cell then        
            cell = CCTableViewCell:new()
        else
            cell:removeAllChildrenWithCleanup(true);
        end 

        local data = table:getParent().data[idx+1]
       

        local dayItem = CCLabelTTF:create(os.date("%y%m%d", data.day), "Helvetica", 24.0,CCSizeMake(100, 50), ui.TEXT_ALIGN_LEFT, ui.TEXT_VALIGN_CENTER)
        dayItem:setAnchorPoint(ccp(0,0.5))
        dayItem:setPosition(ccp(5,30))
        cell:addChild(dayItem)
        
        local nameItem = CCLabelTTF:create(data.name, "Helvetica", 24.0,CCSizeMake(200, 50), ui.TEXT_ALIGN_LEFT, ui.TEXT_VALIGN_CENTER)
        nameItem:setAnchorPoint(ccp(0,0.5))
        nameItem:setPosition(ccp(100,30))
        cell:addChild(nameItem)

        local rankItem = CCLabelTTF:create(data.rank, "Helvetica", 24.0,CCSizeMake(70, 50), ui.TEXT_ALIGN_LEFT, ui.TEXT_VALIGN_CENTER)
        rankItem:setAnchorPoint(ccp(0,0.5))
        rankItem:setPosition(ccp(300,30))
        cell:addChild(rankItem)
        
        local bonusItem = CCLabelTTF:create(data.bonus, "Helvetica", 24.0)
        bonusItem:setAnchorPoint(ccp(0,0.5))
        bonusItem:setPosition(ccp(370,30))
        cell:addChild(bonusItem)

        local stateItem 
        if data.state == 0 then 
            stateItem = cc.ui.UIPushButton.new({
                normal = "images/TanChu/popup_btn_lan11.png",
                pressed = "images/TanChu/popup_btn_lan12.png",
                disabled = "images/TanChu/popup_btn_lan13.png",
            }, {scale9 = false})
            :setButtonLabel(ui.newTTFLabel({
                text = "领取",
                size = 24,
                --color = ccc3(0,0,0)
                }))
            :addTo(cell)
            --stateItem:setAnchorPoint(ccp(0.5,0.5));
            stateItem:setPosition(555,25)
            stateItem:setTouchEnabled(true);
            stateItem:setTag(idx+1)
            stateItem:addTouchEventListener(handler(stateItem, function (target, event, x, y) 
                if (event=="began") then 
                    echoInfo(event..":Icon!");
                    hasmovex = x
                    hasmovey = y
                    return true;
                end
                if (event=="ended") then
                    echoInfo(event..":Icon!");
                    if math.abs(y - hasmovey) + math.abs(x - hasmovex) > 20 then 
                        return true;
                    end 
                    gBaseLogic.sceneManager.currentPage.ctrller:reqMatchGetAward(target)        
                    return true;
                end

                return true;
            end))

        else
            stateItem = CCLabelTTF:create(data.state == 2 and "联系客服" or "已发放", "Helvetica", 24.0,CCSizeMake(100, 70), ui.TEXT_ALIGN_RIGHT, ui.TEXT_VALIGN_CENTER)
            stateItem:setAnchorPoint(ccp(0,0.5))
            stateItem:setPosition(ccp(520,30))
            cell:addChild(stateItem)
        end

        if data.state == 2 then 
            dayItem:setColor(ccc3(252,213,74))
            rankItem:setColor(ccc3(252,213,74))
            bonusItem:setColor(ccc3(252,213,74))
            nameItem:setColor(ccc3(252,213,74))
            stateItem:setColor(ccc3(252,213,74))
        end
        return cell
    end

    function popBoxTips:onPressClose()
        gBaseLogic.sceneManager.currentPage.view:closePopBox();
    end 

    
    gBaseLogic.sceneManager.currentPage.view:showPopBoxCCB("interfaces/BiSaiChangJiangLi.ccbi",popBoxTips,true,1)
    gBaseLogic.sceneManager.currentPage.view.nodePopBox:setPosition(display.cx,display.cy);

end

function BiSaiChangScene:showGameLists(type)
    if gBaseLogic.lobbyLogic.userHasLogined == false then 
        --izxMessageBox("暂未登录!", "提示");
        self:noLoginTips()
        return true;
    end 
    if gBaseLogic.inGamelist==1 then
        return
    end 
    self.btnQuick:setVisible(false)
    self.beginAnimation:setVisible(false)
    gBaseLogic:logEventLabelDuration("gameTime","login",0)
    gBaseLogic.inGamelist = 1;
    local toX,toY = self.btnHappy:getPosition();
    local haX = self.btnLazi:getPositionX();
    local laX = self.btnYule:getPositionX();    
    --local yuX = self.btnYule:getPositionX();
    if (gBaseLogic.MBPluginManager.distributions.nominigame==true) then
        toX = toX - self.noMinigamePositionFix;
        haX = haX - self.noMinigamePositionFix;
        laX = laX - self.noMinigamePositionFix;
    end
    local subX = haX - toX;
    local i=1;  
    print("==========================="..subX)
    self.fuzuView:setAnchorPoint(ccp(0,0));
    -- print(self.fuzuView:getContentSize().height,self.fuzuView:getContentSize().width,self.fuzuView:getPositionX(),self.fuzuView:getPositionY()); 
    
    self.fuzuView:removeAllChildrenWithCleanup(true);

    if (type~=2) then
        local filename = "images/DaTing/lobby_huanle.png";
        if type==1 then
            filename = "images/DaTing/lobby_laizi.png";
        end
        local configMoney = {};
        -- var_dump(self.logic.server_datas_)
        for k,v in pairs(self.logic.server_datas_) do
            local mini_money = tonumber(v.min_money_)
           
            if (tonumber(v.isLaiZi)==type) then
                v.level = tonumber(v.level)
                if  v.level== 1 then
                    configMoney[1] = "入场需"..mini_money .."游戏币";
                elseif v.level == 2 then
                    configMoney[2] = "入场需"..mini_money .."游戏币";
                elseif v.level==3 then
                    configMoney[3] = "入场需"..mini_money .."游戏币";
                end
            end

        end
        var_dump(configMoney);
        local minNum = 0

        for k1,v1 in pairs(configMoney) do
            minNum = minNum+1;
        end
        local thisnum = minNum 
        local kge = 0;
        local startX = 0;
        if minNum<4 then
            if (minNum==2) then
                kge = 80;
            elseif minNum==3 then
                kge = 40;
            end            
            startX = ((4-minNum)*subX-kge*(minNum-1))/2
        end
        echoInfo("minNum is %d,thisnum is %d",minNum,thisnum);
        
        self.fuzuView:setContentSize(CCSizeMake(300*thisnum,310)) 
        if device.platform~="windows" then
            if (thisnum>0 ) then
                self.minGameScroll:setPaged(true);
                self.minGameScroll.isPaged = true;
                self.minGameScroll:setContentSize(CCSizeMake(300*thisnum,310)) 
                self:initPageDot(1);
            else
                self.minGameScroll:setPaged(false);
                self.minGameScroll.isPaged = false;
                self.minGameScroll:setContentSize(CCSizeMake(300*thisnum,310)) 
                self:removePageDot();
            end
        end
        
        for k=1,3 do 
            if (configMoney[k]~=nil) then
                local thisNode = CCNode:create();
                self.fuzuView:addChild(thisNode)
                local thisButton = cc.ui.UIPushButton.new({
                    normal = "images/DaTing/ddz_btn"..k .. ".png",
                    pressed = "images/DaTing/ddz_btn"..k ..".png",
                    disabled = "images/DaTing/ddz_btn"..k ..".png",
                }, {scale9 = false})
                :onButtonClicked(function(event)                    
                        self.logic:startGameByTypLevel(type,k)
                    end)
                -- :align(,  toX+subX*(i-1), toY)
                :addTo(thisNode);
                local label = CCLabelTTF:create(configMoney[k], "Helvetica", 20.0);
                label:setPosition(0,-135);     
                label:setColor(ccc3(255,214,21))     
                thisNode:addChild(label);
                local Sprite = display.newSprite(filename,72,105)
                thisNode:addChild(Sprite);
                thisNode:setPosition(toX+startX+(subX+kge)*(i-1)-40, toY)
                thisNode:setAnchorPoint(ccp(0.5,0.5))
                i = i+1;
                print("gamelist")
                print(toX,toY);
                print(toX+startX+(subX+kge)*(i-1), toY)
            end
        end
    else
        print("-----------do here!!----------");
        
        local minNum = 0
        local gameList = {}
        for k,v in pairs(izx.miniGameManager.miniGameCfg) do
            minNum = minNum+1;
            v.game_id = k;
            table.insert(gameList,v);
        end
        table.sort(gameList, function(a,b)
            if a.order==nil then
                return true
            end
            if a.order  < b.order then
                return true
            else 
                return false
            end
            end)
        var_dump(izx.miniGameManager.miniGameCfg);
        local kge = 48;
        local startX = 0;  
        local thisnum = minNum 
        if thisnum<3 then
            thisnum = 3
        end

        self.fuzuView:setContentSize(CCSizeMake(300*thisnum,310))
        if (device.platform~="windows") then
            if thisnum>0 then
                self.minGameScroll:setPaged(true);
                self.minGameScroll.isPaged = true;
                self.minGameScroll:setContentSize(CCSizeMake(300*thisnum,310)) 
                self:initPageDot(1);
            else
                self.minGameScroll:setPaged(false);
                self.minGameScroll.isPaged = false;
                self.minGameScroll:setContentSize(CCSizeMake(300*thisnum,310)) 
                self:removePageDot();
            end
        end

        -- self.fuzuView:setBounceable(false);
        if (minNum==2) then
            kge = 60;
            startX = ((3-2)*252+30*(2-1))/2
        elseif minNum==1 then
            kge = 0;
            startX = ((3-1)*252+30*(1-1))/2
        end  
        for k_1=1,#gameList do
            -- v = izx.miniGameManager.miniGameCfg[id]
            local v = gameList[k_1];
            local k = gameList[k_1].game_id;
            local thisNode = CCNode:create();
            self.fuzuView:addChild(thisNode)
            local thisButton = cc.ui.UIPushButton.new({
                normal = v.iconFile1,
                pressed = v.iconFile2,
                disabled = v.iconFile1
            }, {scale9 = false})
            -- :onButtonClicked(function(event)
            --     if (self.logic.gametomove==1) then
            --         return
            --     end
            --     self:onPressStartMiniGame(k);                    
            --     end)
            -- :align(display.CENTER,  toX+startX+(subX+kge)*(i-1), toY)
            :addTo(thisNode);
            local function clickSprite(event,x,y)
                echoInfo("-----------clickSprite:"..event.."--------");
                if (event=="began") then
                    self.logic.distrank = x
                    return true;
                elseif (event=="moved") then
                    self.logic.gametomove=1;
                    return true;
                elseif (event=="ended") then
                    if self.logic.distrank~=0 then
                        self.logic.distrank = x-self.logic.distrank
                    end
                    if (self.logic.gametomove==1 and math.abs(self.logic.distrank)>20) then
                        self.logic.gametomove=0;
                        self.logic.distrank = 0;
                        return false;
                    end
                    self:onPressStartMiniGame(k);
                    return true;
                end
            end

            thisButton:setTouchEnabled(true);
            thisButton:addTouchEventListener(clickSprite);

            -- v.gameName = "摇摇乐乐"
            local label = CCLabelTTF:create(v.gameName, "Helvetica", 20.0);
            label:setPosition(0,-135);  
            label:setColor(ccc3(255,214,21))      
            thisNode:addChild(label);
            thisNode:setPosition(toX+10+startX+(252+kge)*(i-1), toY)
            -- thisNode:setPosition(toX+10, toY+(i-1)*310)
            thisNode:setAnchorPoint(ccp(0.5,0.5))
            i = i+1;
        end
        
    end
    
    print("num:"..i)
    local mainX,mainY = self.mainbtnNode:getPosition();
    local fuX,fuY = self.fuzunode:getPosition();
    local thisX,thisY = self.gameNode:getPosition();
    self.mainX = thisX;
    self.mainY = thisY;
    local actions = {};
    actions[#actions + 1] = CCEaseExponentialOut:create(CCMoveTo:create(0.4, ccp(thisX-fuX+mainX, thisY)));
   
    self.gameNode:runAction(transition.sequence(actions));
    
    -- 
    -- actions[#actions + 1] = CCEaseExponentialOut:create(CCMoveTo:create(0.5, ccp(-500,toY)));
    -- self.gameNode:runAction(transition.sequence(actions));
end

function BiSaiChangScene:onTouch(event, x, y)    
    -- print(x,y);
    local tab_x,tab_y = self.nodetrum:getPosition();
    print("tablexy",tab_x,tab_y,event)
    if event == "began" then
        -- local sss = self.spriteContent:boundingBox()
        -- print(sss:getMinX(),sss:getMinY(),sss:getMaxX(),sss:getMaxY())
        if (self.tabViewLayer~=nil) then
            
            if self.spriteContent:boundingBox():containsPoint(CCPoint(x-tab_x,y-tab_y)) == false then

                self.spriteContent:setVisible(false)
                self.tabViewLayer:unregisterScriptTouchHandler()
                self.tabViewLayer:removeAllChildrenWithCleanup(true);
                self.tabViewLayer = nil
            else
                print (222)
            end
        end
        
    end
    return true
end 


function BiSaiChangScene:unWaitingAni(target,opt)
    scheduler.unscheduleGlobal(self.scheduler)
    self.scheduler = nil
    gBaseLogic:unblockUI();

end

function BiSaiChangScene:loadingAni()
     --gBaseLogic.sceneManager:waitingAni(self.rootNode,self.unWaitingAni,100)
     gBaseLogic:blockUI();
     self.scheduler = scheduler.performWithDelayGlobal(handler(self, self.unWaitingAni), 5.0)
end
function BiSaiChangScene:onRemovePage()
	if self.scheduler~=nil then
	 	scheduler.unscheduleGlobal(self.scheduler)
    	self.scheduler = nil
    end
    if self.serTimeHandler~=nil then
	 	scheduler.unscheduleGlobal(self.serTimeHandler)
    	self.serTimeHandler = nil
    end
end 

return BiSaiChangScene;