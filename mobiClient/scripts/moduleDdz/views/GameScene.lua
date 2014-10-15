local GameScene = class("GameScene",izx.baseView)

function GameScene:ctor(pageName,moduleName,initParam)
	print ("GameScene:ctor")
    self.cardForTouch = {};
    self.cardForTouchSprite = {};
    self.myHandCard = 0; 
    self.timeSendChat = 0;
    self.hasUnselected = 0;
    self.super.ctor(self,pageName,moduleName,initParam);
    self.btnPointX = {}
    self.butLayerState = 1
    self.btnFaHaoPai = 0
    self.hasAddGame2 = 0
end

function GameScene:onAssignVars()
	--var_dump(self);
    print("GameScene:onAssignVars")
	self.rootNode = tolua.cast(self.rootNode,"CCNode");
    local gametable = require("moduleDdz.ctrllers.GameTable")

    --for k,v in pairs(gametable) do
    --    self[v.name] = tolua.cast(self[v.name],v.type)
    --end
    -- self.nodetask:setVisible(false);
    -- self.nodeBtnTips:setVisible(false);
     self.nodeimg0:setVisible(false);    
     self.nodeimg1:setVisible(false);
     self.nodeimg2:setVisible(false);
    -- self.leftClock:setVisible(false);
    -- self.meClock:setVisible(false);
    -- self.rightClock:setVisible(false);
    
end

function GameScene:initTaskContent()
    print("initTaskContent")
    -- var_dump()
    self.nodetask:setVisible(true);
    local taskInfo = self.ctrller.data.task_item_;
    -- self.ctrller.task_item_.task_desc_
    self.labelTaskContent:setString(taskInfo.task_desc_);
    print(taskInfo.task_money_,taskInfo.task_mission_)
    self.labelTaskAward:setString(taskInfo.task_mission_)
    -- if taskInfo.task_money_type_~=1 then
   
        
    -- else
    --     self.labelTaskAward:setString("元宝"..taskInfo.task_money_)
    -- end
end

function GameScene:setMatchTitle()
	self.nodetask:setVisible(true);
	-- self.labelTaskContent:setString(self.logic.matchName);
	print("GameScene:setMatchTitle view")
	print(gBaseLogic.gameLogic.curMatchRound)
	self.labelTaskAward:setVisible(true);
	self.labelTaskContent:setVisible(false);
    -- self.labelTaskAward:setString("第"..(gBaseLogic.gameLogic.curMatchRound+1).."轮")
    self.labelTaskAward:setFontSize(36);
    self.labelTaskAward:setDimensions(CCSize(456, 60));
	local function callback()
		self.nodetask:setVisible(true);
		self.labelTaskAward:setString(self.logic.matchInfoFromSys.matchname..("(第"..(gBaseLogic.gameLogic.curMatchRound+1).."轮)"));
	end
    self:getMatchInfo(callback)
    
end
function GameScene:getMatchInfo(callback)
	HTTPPostRequest(URL.Match_Info, {matchid=self.logic.curMatchID}, function(event)
        print("BiSaiChangeSceneCtrller:reqRaceRoomInfoData")
        var_dump(tableRst)
        if (event ~= nil) then
            var_dump(event,5)
            -- --local message =  self:initRaceRoomLocalInfoData()
            -- local message = event 
            -- gBaseLogic.lobbyLogic.matchInfo = message
            -- self:resetData(message)
            -- self.view:initBaseInfo(); 

            if event.matchinfo~=nil and event.matchinfo.matchname~=nil then
            	 self.logic.awardInfoFromSys = event.awardInfo;
            	 self.logic.matchInfoFromSys = event.matchinfo;
            	 callback();
            	self.labelTaskContent:setString(self.logic.matchInfoFromSys.matchname..("第"..(gBaseLogic.gameLogic.curMatchRound+1).."轮"));
            end
        end     
        end);
end

function GameScene:onInitView()
    print("GameScene:onInitView....................")
    self:initBaseInfo(); 

    if gBaseLogic.is_robot ~= 0 then 
        self.ctrller.is_robot = gBaseLogic.is_robot

        --self.ctrller:initRobotInfo(0)
        --self.logic:showWanFa()
        --self:addMaskLayer(ccc4(0,0,0,80), nil, true)
        --self.currentPopBox = self.logic:showWanFa(self)
        --self.logic:showWanFa(self)
        --self:showWanFaDialog(true)
        
        return
    end
    
    --广播添加
    --self.spriteContent:setVisible(true)
    --[[
    -- self.nodetrum:setZOrder(10000)
    -- self.spriteGonggao:setTouchEnabled(true)
    -- self.spriteGonggao:addTouchEventListener(function(event, x, y, prevX, prevY)
    
    --     if event == "began" then
    --         if (self.spriteContent:isVisible()) then
    --             self.spriteContent:setVisible(false)
    --             self.nodetask:setVisible(true)
    --             --print (1111);
    --         else            
    --             self.nodetask:setVisible(false)
    --             self.spriteContent:setVisible(true)
    --             self.spriteContent:setPreferredSize(CCSizeMake(763, 410))
    --             --print (2222);
    --             self:createTableView(self.spriteContent)
    --             local tableView = self.tabViewLayer:init(gBaseLogic.lobbyLogic.guangBaoList);
    --             self.tabViewLayer:registerScriptTouchHandler(function(event, x, y)
    --                                                     return self:onTouch(event, x, y)
    --                                                 end, false,0,true)
        
    --             self.tabViewLayer:setTouchEnabled(true)
    --             self.tabViewLayer:addChild(tableView) 
    --             tableView:reloadData()

    --         end

    --         print("self.nodeGonggao:addTouchEventListener")
    --     end
    -- end)
    --]]
end

function GameScene:initBaseInfo()
    print("GameScene:initBaseInfo")

    -- if gBaseLogic.gameLogic.isMatch == 1 then
    --     if gBaseLogic.lobbyLogic.matchInfo == nil then
    --         self.ctrller:reqRaceRoomInfoData(0) 
    --     end
        
    -- end 
    --self.nodeimg0:setVisible(true);
    --self.nodeimg1:setVisible(true);
    --self.nodeimg2:setVisible(true);
    local data = self.ctrller.data;
    data.players_[1] = require("moduleDdz.ctrllers.Me").new(self);
    data.players_[1]:Init(0);
    --data.players_[1].super.Clock = tolua.cast(self["meClock"],"CCSprite")
    data.players_[1].super.meTip = tolua.cast(self["meReady"],"CCSprite")
    data.players_[1].super.nodeimg = tolua.cast(self["nodeimg0"],"CCNode")
    
    data.players_[1].super.labelPlayername = tolua.cast(self["labelName0"],"CCLabelTTF")
    data.players_[1].super.spriteimg = tolua.cast(self["spriteimg0"],"CCSprite")
    data.players_[1].super.spriteimg:getParent():setVisible(false);
    data.players_[1].super.spriteimg:setVisible(false);
    data.players_[1].super.spriteVip = tolua.cast(self["spriteVip0"],"CCSprite")
    data.players_[1].super.spriteHeadImg = tolua.cast(self["spriteHeadImg0"],"CCSprite") 
    data.players_[1].super.lableUsericonmoney = tolua.cast(self["lableUsericonmoney"],"CCLabelTTF")
    data.players_[1].super.btntouKuang = tolua.cast(self["btntouKuang0"],"CCControlButton")
    --data.players_[1]:onEnterTransitionDidFinish();
    for i = 2, data.MAX_PLY_NUM do
        data.players_[i] = require("moduleDdz.ctrllers.Player").new(self);
        data.players_[i]:Init(i-1);
        --data.players_[i].Clock = (i== 2 and tolua.cast(self["rightClock"],"CCSprite") or tolua.cast(self["leftClock"],"CCSprite")) 
        data.players_[i].meTip = (i== 2 and tolua.cast(self["rightReady"],"CCSprite") or tolua.cast(self["leftReady"],"CCSprite")) 
        data.players_[i].cardback = (i== 2 and tolua.cast(self["rightCard"],"CCSprite") or tolua.cast(self["leftCard"],"CCSprite")) 
        data.players_[i].cardback:setVisible(false)
        data.players_[i].nodeimg = tolua.cast(self["nodeimg"..(i-1)],"CCNode")    
        -- var_dump(data.players_[i].nodeimg);       
        data.players_[i].labelPlayername = tolua.cast(self["labelname"..(i-1)],"CCLabelTTF") 
        data.players_[i].spriteimg = tolua.cast(self["spriteimg"..(i-1)],"CCSprite")
        data.players_[i].spriteimg:getParent():setVisible(false);
        data.players_[i].spriteimg:setVisible(false); 
        data.players_[i].spriteVip = tolua.cast(self["spriteVip"..(i-1)],"CCSprite") 
        data.players_[i].spriteHeadImg = tolua.cast(self["spriteHeadImg"..(i-1)],"CCSprite") 
        data.players_[i].btntouKuang = tolua.cast(self["btntouKuang"..(i-1)],"CCControlButton")
        --data.players_[i]:onEnterTransitionDidFinish();
    end
    
    scheduler.performWithDelayGlobal(function ()
        if self.hasAddGame2 == 0 then 
            self:initBaseInfo2()
        end 
    end, 0.2)
    
    -- self.logic:showdibaomsg();
end

function GameScene:initBaseInfo2()
    if self.hasAddGame2 == 0 then 
        self:addGameToGameScene()
        self.hasAddGame2 = 1
    end 
    self:storeBtnPosition()
    
    self.leftClock:setVisible(true);
    self.meClock:setVisible(true);
    self.rightClock:setVisible(true);
    print("GameScene:initBaseInfo....................")
    --一些单机版不许显示的东西
    local data = self.ctrller.data;
    data.players_[1].super.Clock =tolua.cast(self["meClock"],"CCSprite")
    data.players_[1]:onEnterTransitionDidFinish();
    data.players_[2].Clock =tolua.cast(self["rightClock"],"CCSprite")
    data.players_[2]:onEnterTransitionDidFinish();
    data.players_[3].Clock =tolua.cast(self["leftClock"],"CCSprite")
    data.players_[3]:onEnterTransitionDidFinish();
    if gBaseLogic.is_robot == 0 then
        self.labelGonggao:setString("完成任务获得元宝，2000元宝可兑换20元话费！")
        print("........=====")
        
        if self.scheduler==nil then
            self.scheduler = require("framework.scheduler");
            local OnTimer = function(dt)
                for i=1,self.ctrller.data.MAX_PLY_NUM do
                    self.ctrller.data.players_[i]:onTimer(dt)
                end
                if self.logic.isMatch==0 then
	                if self.logic.roundTaskNum~=nil then
	                    self.logic.roundTaskNum = self.logic.roundTaskNum+1;
	                else
	                    self.logic.roundTaskNum = 1;
	                end
	                if self.logic.roundTaskNum%60==0 then
	                    self.logic.baoXiangRenWu.giftStat = 10000
	                    -- self.logic.roundTaskFinishNum = 0
	                    -- self.logic:pt_cb_get_task_system_req()
	                    self.logic:onSocketGetOnlieAward(0) --刷新在线任务
	                end
	            end
            end
            self.serTimeHandler = self.scheduler.scheduleGlobal(OnTimer, 1, false)
            self:changeChongzhijiangliButton()
        else
            self.btnChongZhiJiangLi:setVisible(false)
        end
        -- self.nodeBtnTips:setVisible(true)
        -- self.spriteBtnTips:runAction(CCEaseIn:create(CCFadeOut:create(2.5), 6));
        -- self.labelTip:runAction(CCEaseIn:create(CCFadeOut:create(2.5), 6));

        --tanchuzhiyi
        -- local function actionMoveDone()
        --     -- self.nodeBtnTips:setVisible(false)
        --     self.nodeBtnTips:setPositionX(self.nodeBtnTips:getPositionX()+110)
        --     self.labelTip:setString("宝箱任务已经开启，\n点击查看任务");
        --     self.nodeBtnTips:setVisible(true)
            

        -- end
        -- local function actionMoveDone1()
        --     self.nodeBtnTips:setVisible(false)
        -- end
        --  local function actionMoveDone2()
        --     self.nodeBtnTips:setVisible(true)
        --     self.nodeBtnTips:setZOrder(10001)
        -- end
        
        -- local fade_seq = transition.sequence({
        --     CCCallFuncN:create(actionMoveDone2),
        --     CCDelayTime:create(2.0),
        --     CCEaseIn:create(CCFadeOut:create(2.5), 6),
        --     CCCallFuncN:create(actionMoveDone1),
        --     CCCallFuncN:create(actionMoveDone),
        --     CCDelayTime:create(3.0),
        --     CCEaseIn:create(CCFadeOut:create(2.5), 6),
        --     CCCallFuncN:create(actionMoveDone1),
        --     });
        -- self.spriteBtnTips:runAction(fade_seq);
        -- local fade_seq1 = transition.sequence({
        --     CCDelayTime:create(2.0), 
        --     CCEaseIn:create(CCFadeOut:create(2.5), 6),  
        --     CCDelayTime:create(3.0),
        --     CCEaseIn:create(CCFadeOut:create(2.5), 6),
        --     });
        -- self.labelTip:runAction(fade_seq1);
        
    
        self.btn_game_manage:setVisible(true)
        self.btn_game_chat:setVisible(true)
        self.btn_game_memory:setVisible(true)
        self.btn_game_git:setVisible(true)
        -- self.btn_Chongzhi:setVisible(true)
        --self.btn_game_git:setVisible(true)
        self.nodeGameGit:setVisible(true)
        self.btnChongZhiJiangLi:setVisible(true)
        if self.logic.isMatch ~= 1 then
	        self:initBaoXiang();
	    end
        -- self.label_game_manage:setVisible(true)
        -- self.label_game_chat:setVisible(true)
        -- self.label_game_memory:setVisible(true)
        -- self.label_game_git:setVisible(true)
        
    else
    	self.nodeGameGit:setVisible(false)
    	self.btnChongZhiJiangLi:setVisible(true)
    end 

    if self.logic.isMatch == 1 then
        self:HidenOpBtn()
        self:setMatchTitle()
        self.btnMatchReward:setVisible(true)
        self.btnMatchRank:setVisible(true)
        self.spriteUserCoin:setVisible(true)
        self.nodeGameGit:setVisible(false)
        self.btnChongZhiJiangLi:setVisible(false)
        self.spriteUserCoin:setVisible(false)
        self.labelGonggao:setString("")
    	self.nodetrum:setVisible(false)
    end
    self.cLordCardNode = display.newNode();
    self.nDouble = CCLabelAtlas:create("0", "images/YouXi/game_pic_beishushuzi.png", 19, 26, 48)
    --self.gameLayer:addChild(self.cLordCardNode);
    self.layer_game_card:addChild(self.cLordCardNode);
    self.layer_game_card:addChild(self.nDouble);

    self.cLordCardNode:setPosition(ccp(225,56))
    self.nDouble:setPosition(ccp(476,52))
    self.nodeLaiZi:setVisible(false)
    self.nodeLaiZi:setPosition(ccp(display.cx,display.cy))
    self.nDouble:setString("1");
    self.nDizhu:setString("");
    self.nMoney:setString(self.logic.needMoney);
end

function GameScene:addGameToGameScene()
    local proxy = CCBProxy:create();
    local node = CCBuilderReaderLoad("interfaces/YouXi2.ccbi",proxy,self);

    --node:setPosition(ccp(display.cx,display.cy))
    print(gBaseLogic.MBPluginManager.frameworkVersion)
    if (gBaseLogic.MBPluginManager.frameworkVersion>=14081501) then
        print("GameScene:addGameToGameScene 2.2.5")
        -- cocos 2.2.5!!!
        -- 设置触摸模式
        self.puKeLayer:setTouchMode(cc.TOUCH_MODE_ONE_BY_ONE) -- 单点触摸
        self.puKeLayer:setTouchEnabled(true)


        -- 是否允许当前 node 和所有子 node 捕获触摸事件
        -- 默认值： true
        self.puKeLayer:setTouchCaptureEnabled(true)

        -- 如果当前 node 响应了触摸，是否吞噬触摸事件（阻止事件继续传递）
        -- 默认值： true
        self.puKeLayer:setTouchSwallowEnabled(false)

        self.puKeLayer:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
            if not self.ctrller.data.is_game_start_ then 
                return false;
            end
            return self:onTouch(event.name, event.x, event.y );
        end)
        -- self.view.puKeLayer:addNodeEventListener(cc.NODE_TOUCH_CAPTURE_EVENT, function(event)
        --     return self.view:onTouch(event.name, event.x, event.y );
        -- end)
    else
        print("GameScene:addGameToGameScene 2.2.1")
        self.puKeLayer:registerScriptTouchHandler(function(event, x, y)
            return self:onTouch(event, x, y)
        end,false,0,false)    
        self.puKeLayer:setTouchEnabled(true)
    end
	   self.rootNode:addChild(node)
    self.btnChongZhiJiangLi = tolua.cast(self["btnChongZhiJiangLi"], "CCControlButton")

end 

function GameScene:onPressExit()
    print "onPressExit"
    izx.baseAudio:playSound("audio_menu");--AUDIO_MENU
    local isrobot = gBaseLogic.is_robot
    if isrobot ~= 0 then
        self.ctrller:destoryRobot()
        if isrobot == 1 then          
            self.logic:LeaveGameScene(1)   
        elseif isrobot == 2 then
            self.logic:LeaveGameScene(2)   
        end
        gBaseLogic.audio:StopBackground()
        return
    end
    if self.logic.gameSocket~=nil and self.logic.gameSocket.isConnect == 1 then
        -- self.logic:
        -- self.logic:send_pt_cb_leave_table_req()
        local msg = "您确定要退出游戏吗？"
        if self.logic.isMatch == 1 then 
            msg="您还有一场比赛没有结束，不能退出";
            izxMessageBox(msg, "提示")
            return;
        end
        if self.ctrller:is_game_start() == true then
            if self.logic.isMatch == 1 then 
                msg="您还有一场比赛没有结束，是否继续？"
            else
                msg="如果现在退出游戏，会由系统接管哦。输了的话千万别怪它！"
            end
        end
        gBaseLogic:confirmBox({
            msg=msg,
        callbackConfirm = function()
            if self.ctrller:is_game_start() == true then
                gBaseLogic.lobbyLogic.isMatchOnGameExit = self.logic.isMatch
                
                gBaseLogic.lobbyLogic.isOnGameExit = 1;
                self.logic:LeaveGameScene(-1)
            else
                self.logic:LeaveGameScene(1)
            end
            
        end})
    else
        self.logic:LeaveGameScene(-1)
    end 
    
end

function GameScene:ChangeLayer()
    print("ChangeLayer")
    local fDuration = 0.5
    --self.layer_game_btn:setVisible(true)
    --self.layer_game_card:setVisible(true)
    if  self.butLayerState == 0  then
        self.butLayerState = 1
        print("button move to btn:",self.butLayerState)
        --self.btn_move:setEnabled(false)
        self:SliderMoveAction(self.layer_game_btn, nil,display.height+1,fDuration)
        self:SliderMoveAction(self.layer_game_card, nil,display.height+95,fDuration)
        self.btn_game_manage:setEnabled(true)
        self.btn_game_chat:setEnabled(true)
        self.btn_game_memory:setEnabled(true)
        self.btn_game_set:setEnabled(true)
        self.btn_game_exit:setEnabled(true)
    elseif self.butLayerState == 1 then
        self.butLayerState = 0
        print("button move to card:",self.butLayerState)
        --self.btn_move:setEnabled(false)
        self:SliderMoveAction(self.layer_game_btn, nil, display.height+45, fDuration)
        self:SliderMoveAction(self.layer_game_card, nil, display.height+1, fDuration)
        self.btn_game_manage:setEnabled(false)
        self.btn_game_chat:setEnabled(false)
        self.btn_game_memory:setEnabled(false)
        self.btn_game_set:setEnabled(false)
        self.btn_game_exit:setEnabled(false)
    end   

    self.btn_changelayer:runAction(transition.sequence({CCRotateBy:create(0,180),CCDelayTime:create(fDuration),CCCallFuncN:create(function( )
            --self.btn_move:setEnabled(true)
        end)}));
end

function GameScene:onPressChangeLayer()
    print("onPressChangeLayer")
    izx.baseAudio:playSound("audio_menu");--AUDIO_MENU
    --if self.ctrller:is_game_start() == true then 
        self:ChangeLayer()
    --end
end 

function GameScene:onPressManagement()
    print "onPressManagement"
    if self.ctrller:is_game_start() == true then
        izx.baseAudio:playSound("audio_menu");--AUDIO_MENU
        if (self.ctrller.is_auto_ == false) then
            -- self:showManageBtn()
            -- --GetMe()->EnableOpt(false);
            -- self.ctrller.is_auto_ = true ;
            self.ctrller:pt_cg_auto_req_send(1)
            -- if (self.fourSprite:isVisible() and self.fourSprite:getTag()== 9) then
            --     -- onClick(btn_tips_);
            --     -- if(GetMe()->GetPlayCards()->m_vecTipsCards.size()>0)
            --     --     onClick(btn_play_card_);
            --     -- is_operate_self_ = false;
            -- end
        else
            self:ManagementClick()
        end
    else
        izxMessageBox("游戏未开始", "提示")
    end
end

function GameScene:showManageBtn()
    -- echoError("GameScene:showManageBtn")
    local winSize = CCDirector:sharedDirector():getWinSize()
    local button = ui.newImageMenuItem({
    image = "images/YouXi/game_btn_quxiaotuoguan1.png",
    imageSelected  = "images/YouXi/game_btn_quxiaotuoguan2.png",
    x = winSize.width/2,
    y = 80,
    listener = function()
        self:ManagementClick()
    end,
     })
    local menu = ui.newMenu({button})
    self.gameLayer:addChild(menu,2,2)
    --izx.baseAudio:playSound("audio_menu");--AUDIO_MENU
end

function GameScene:ManagementClick()
    print "ManagementClick"
    -- if (self.ctrller.is_auto_ == true) then -- 非托管状态不发送请求
        -- self.ctrller.is_auto_ = false
    self.ctrller:pt_cg_auto_req_send(0)
        -- self.gameLayer:removeChildByTag(2)
        --izx.baseAudio:playSound("audio_menu");--AUDIO_MENU
    -- end
end

function GameScene:onPressSet()
    print "onPressSet"
    gBaseLogic.gameLogic:showSetupLayer();
    izx.baseAudio:playSound("audio_menu");--AUDIO_MENU
    --self.logic:showWanFa(self)
    --self.logic:showWanFa2()
end

function GameScene:onPressChat()
    print "onPressChat"
    -- self.logic:showNewJieSuan()
    -- self.logic.achieve_award_not = {name_="sdasdas",desc_="sadsad",index_=59}
    -- self.logic:showAchievefinishContent(self.logic.achieve_award_not);
    if os.time() - self.timeSendChat < 4 then 
        izxMessageBox("您发送聊天信息太频繁，请稍后再试", "聊天提示");
        return 
    end 
    self.timeSendChat = os.time()
    gBaseLogic.gameLogic:showChat();
    -- self:ShowGameTip("此功能暂未开放") 
end

function GameScene:onPressChongzhi()
    -- gBaseLogic.lobbyLogic:quickPay(0,3);--smsQuickPayCharge,//  游戏时玩家主动充值
    -- local puid = gBaseLogic.lobbyLogic.userData.ply_guid_;
    -- CCUserDefault:sharedUserDefault():setStringForKey("payday"..puid,os.date("%x", os.time()))
    -- CCUserDefault:sharedUserDefault():setIntegerForKey("paydayNeedMoney"..puid,0)
end
function GameScene:onPressChongZhiJiangli()
     izx.baseAudio:playSound("audio_menu");
     
     -- self.logic:showLotteryDraw()
     self.btnChongZhiJiangLi:setEnabled(false)
     gBaseLogic.lobbyLogic:quickPay(0,3);
    
end

function GameScene:onPressMemory()
    print "onPressMemory"
    -- local memoryNode = self.gameLayer:getChildByTag(1)
    var_dump(self.ctrller.data.is_game_start_ )
    if self.ctrller.data.is_game_start_ == false then
        izxMessageBox("游戏未开始", "提示")
        return;
    end
    print("1212321412421")
    var_dump(self.nodeNoteCards:isVisible())
    if self.nodeNoteCards:isVisible() then
        self.nodeNoteCards:setVisible(false)
    else   
        if self.ctrller.noteCardsNum>0 then   
            self:showNoteCardsContent();         
            
        else
         -- todo 记牌器不够的提醒
            print("记牌器不够");
            local initParam = {msg="道具不足，记牌器可查看牌桌上已出的牌，方便您记牌，点击确定立即购买使用！",type=2,needMoney=0,subtyp=0};
            gBaseLogic.lobbyLogic:showYouXiTanChu(initParam)
            -- self:ShowGameTip("记牌器不够，请去商店购买")
        end           
    end
end
function GameScene:showNoteCardsContent()
    print("self.nodeNoteCards:setVisible")
    self.nodeNoteCards:setVisible(true)
    self.logic:pt_cg_card_count_req_send();
end
function GameScene:replaceCardNote(resCardsTabel)    
    self.nodeNoteCards:setVisible(true)
    self.gameLayer:reorderChild(self.nodeNoteCards, 1)
    for i=3,17 do
        print(i,resCardsTabel[i]);
        local cardsLabel = tolua.cast(self.nodeNoteCards:getChildByTag(i),"CCLabelTTF"); 
        cardsLabel:setString(resCardsTabel[i])
    end
end

--广播牌时刷新
function GameScene:refreshCardNote(cards)
    if self.nodeNoteCards:isVisible() and self.ctrller.useNoteCards==1 then
        for k,v in pairs(cards) do
            local cardNum;
            if (v.m_nValue==16 and v.m_nColor==1) then
                cardNum = 17
            else
                cardNum = v.m_nValue
            end 
            local cardsLabel = tolua.cast(self.nodeNoteCards:getChildByTag(cardNum),"CCLabelTTF"); 
            local restNum = math.floor(cardsLabel:getString() - 1);
            if restNum<0 then
                restNum = 0;
            end
            cardsLabel:setVisible(true)
            cardsLabel:setString(restNum)
        end
    end
end

function GameScene:showMatchReward(data)
    local popBoxTips = {};
   
    function popBoxTips:onAssignVars()
        self.nodeTabView = tolua.cast(self["nodeTabView"],"CCNode");
        if nil ~= info then         
        end
        -- self.node1:setVisible(false)
        -- self.node2:setVisible(true)
        self:initTableView(self.nodeTabView, 0, data);
    end
    function popBoxTips:initTableView(target,type,data)
        local winSize = target:getContentSize()
        print(winSize.width ,winSize.height)
        if data~=nil and #data~=0 then
        	createTabView(target,winSize,type,data, self);
        end
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
 		local reward = table:getParent().data[idx+1]
        var_dump(reward)
        local nameItem = CCLabelTTF:create(reward.titlename..":", "Helvetica", 30.0,CCSizeMake(100, 50), ui.TEXT_ALIGN_RIGHT, ui.TEXT_VALIGN_CENTER)
        nameItem:setAnchorPoint(ccp(0,0.5))
        nameItem:setPosition(ccp(50,30))
        cell:addChild(nameItem)
        local nameDesc = CCLabelTTF:create(reward.bonusname, "Helvetica", 28.0)
        nameDesc:setAnchorPoint(ccp(0,0.5))
        nameDesc:setPosition(ccp(200,30))
        cell:addChild(nameDesc)
        if idx == 0 then 
            nameItem:setColor(ccc3(252,213,74))
            nameDesc:setColor(ccc3(252,213,74))
        end
        return cell
    end

    function popBoxTips:onPressClose()
        gBaseLogic.sceneManager.currentPage.view:closePopBox();
    end 

    
    gBaseLogic.sceneManager.currentPage.view:showPopBoxCCB("interfaces/BiSaiChangJiangLi.ccbi",popBoxTips,true)
    gBaseLogic.sceneManager.currentPage.view.nodePopBox:setPosition(display.cx,display.cy);

end 
--{rank = 1, nikename = "JL", score = 3000, round = 1},
function GameScene:showMatchRank(data)
    local popBoxTips = {};
   
    function popBoxTips:onAssignVars()
        self.randDesc = {[1]="预赛第一场",[2]="预赛第二场",[3]="预赛第三场",[4]="预赛第四场",[5]="预赛第五场",}
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

        local reward = table:getParent().data[idx+1]
        var_dump(reward)
         local itemOwner = {};
-- 			labelRank
-- MAC8(mac8) 09-30 10:39:41
-- labelName labelSoce labelbisai
		local item = CCBuilderReaderLoad("interfaces/BiSaiChangPaiMingNode.ccbi", CCBProxy:create(), itemOwner);
	-- 
		itemOwner.labelRank = tolua.cast(itemOwner["labelRank"], "CCLabelTTF");
		itemOwner.labelName = tolua.cast(itemOwner["labelName"], "CCLabelTTF");
		itemOwner.labelSoce = tolua.cast(itemOwner["labelSoce"], "CCLabelTTF");
		itemOwner.labelbisai = tolua.cast(itemOwner["labelbisai"], "CCLabelTTF");
        local reward = table:getParent().data[idx+1]
        var_dump(reward)
        itemOwner.labelRank:setString(idx+1);
        itemOwner.labelName:setString(reward.nickname);
        if self.logic.curMatchRound==0 then
        	itemOwner.labelSoce:setString("3000");
        else
         	itemOwner.labelSoce:setString(reward.score);
         end
         local randDesc = {[1]="预赛第一场",[2]="预赛第二场",[3]="预赛第三场",[4]="预赛第四场",[5]="预赛第五场",}
         local desc = "预赛第一场";
         if randDesc[self.logic.curMatchRound+1]~=nil then
         	desc = randDesc[self.logic.curMatchRound+1]
         end
         itemOwner.labelbisai:setString(desc);
        
        cell:addChild(item);
        return cell
    end

    function popBoxTips:onPressClose()
        gBaseLogic.sceneManager.currentPage.view:closePopBox();
    end 

    
    gBaseLogic.sceneManager.currentPage.view:showPopBoxCCB("interfaces/BiSaiChangPaiMing.ccbi",popBoxTips,true)
    gBaseLogic.sceneManager.currentPage.view.nodePopBox:setPosition(display.cx,display.cy);

end 

function GameScene:onPressMatchReward()
    print("GameSceneonPressMatchReward") 
    if self.logic.awardInfoFromSys==nil then
    	print(111);
    	self:getmatchinfo()
    	izxMessageBox("数据请求中，请稍后再试！", "提示")
    else
    	var_dump(self.logic.awardInfoFromSys)
    	self:showMatchReward(self.logic.awardInfoFromSys)
    end
    -- if gBaseLogic.lobbyLogic.matchInfo ~= nil then 
    --     local isfindOK = false
    --     local riCheng = gBaseLogic.lobbyLogic.matchInfo.riCheng
    --     for k,v in pairs(riCheng) do 
    --         if v.matchid ==  self.logic.curMatchID then 
    --             self:showMatchReward(v.reward)
    --             isfindOK = true
    --         end
    --     end 
    --     if isfindOK ==  false then 
    --         izxMessageBox("暂时没有数据", "提示")
    --     end
    -- else 
    --     self.ctrller:reqRaceRoomInfoData(0)  
    -- end
end 

function GameScene:onPressMatchRank()
    print("onPressMatchRank")
    self.ctrller:reqMatchRankInfoData()  
end 

function GameScene:onPressGift()
    print "GameScene:onPressGift"
    -- self.logic:showAchievefinishContent()
    -- self.logic.baoXiangRenWu.giftStat = 0
    -- self.logic.roundTaskFinishNum = 0
    self.logic:showBaoXiangRenWu();
    -- self.logic:pt_cb_get_task_system_req()
    -- self.logic:pt_cb_get_online_award_items_req()
    -- self.logic:pt_cb_get_task_award_req(0)
    
end


function GameScene:onPressOneButton()
    print "onPressOneButton"
    local tag = self.oneSprite:getTag()
    if tag == 2 then --3分
        izx.baseAudio:playSound("audio_menu");--AUDIO_MENU
        self.ctrller:sendCallSoces(self.ctrller.data.SCORE_THREE)
        self:HidenOpBtn()        
    elseif tag == 6 then --不出
        self.ctrller:sendNoCard()
        gBaseLogic.audio:PlayAudio(25); --AUDIO_PASS
    end
    print("onPressOneButton")
end

function GameScene:onPressTwoButton()
    print "onPressTwoButton"
    local tag = self.twoSprite:getTag()
    print (tag);
    if tag == 3 then --1分
        self.ctrller:sendCallSoces(self.ctrller.data.SCORE_ONE)
        self:HidenOpBtn()
        izx.baseAudio:playSound("audio_menu");--AUDIO_MENU
    elseif tag ==7 then --提示
        self.ctrller:callTips()
    elseif tag == 10 then --准备
        
        if gBaseLogic.is_robot == 0 then
            if gBaseLogic.lobbyLogic.userData.ply_lobby_data_.money_ < self.logic.curSocketConfigList.min_money_ then
                -- self.logic.moneyNotEnough=1
                gBaseLogic:onNeedMoney("gameenter", self.logic.curSocketConfigList.min_money_, 2)
                return;
            end
            self:HidenOpBtn()
            self.logic:sendTableReady()
        else
            --self.ctrller:checkRobotMonery()
            self:HidenOpBtn()
            self.ctrller.robotai:setGameStateAndData(EVENT_ID["pt_cb_ready_req"],0)
        end
    end
end

function GameScene:onPressThreeButton()
    print "onPressThreeButton"
    local tag = self.threeSprite:getTag()
    if tag == 1 then --抢地主
        self.ctrller:sendRobLord(self.ctrller.data.ROB_LORD)
        self:HidenOpBtn()
    elseif tag == 4 then --2分
        self.ctrller:sendCallSoces(self.ctrller.data.SCORE_TWO)
        self:HidenOpBtn()
        izx.baseAudio:playSound("audio_menu");--AUDIO_MENU
    elseif tag == 8 then --重选
        --self:releaseSelectedCard()
        --izx.baseAudio:playSound("audio_menu");--AUDIO_MENU
    end
end

function GameScene:onPressFourButton()
    print "onPressFourButton"
    local tag = self.fourSprite:getTag()
    if tag == 0 then --不抢
        self.ctrller:sendRobLord(self.ctrller.data.NO_ROB_LORD)
        self:HidenOpBtn()
    elseif tag == 5 then --不叫
        self.ctrller:sendCallSoces(self.ctrller.data.SCORE_ZERO)
        self:HidenOpBtn()
        izx.baseAudio:playSound("audio_menu");--AUDIO_MENU
    elseif tag == 9 then --出牌
        self.ctrller:CheckSelect()
    elseif tag == 11 then --换桌
        if gBaseLogic.is_robot == 0 then
            if gBaseLogic.lobbyLogic.userData.ply_lobby_data_.money_ < self.logic.curSocketConfigList.min_money_ then
                -- self.logic.moneyNotEnough=1
                gBaseLogic:onNeedMoney("gameenter", self.logic.curSocketConfigList.min_money_, 2)
                return;
            end
            self:HidenOpBtn()
            self.ctrller:reInitAll();
            self.logic:changeTable()
        else
            self:HidenOpBtn()
            self.ctrller:reInitAll();
            self.ctrller.robotai:setGameStateAndData(EVENT_ID["cb_change_table_req"],0)
        end
    end
    
end

function GameScene:onPressFaHaoPaiButton()
    --发好牌
    print("onPressFaHaoPaiButton")
    self.ctrller:CheckBetterSeat()
end 

function GameScene:onPressPlayer()
    print "onPressPlayer"
    if self.ctrller:is_game_start() == true and self.logic.isMatch==0 then
        gBaseLogic.gameLogic:showInformation(self.ctrller.data.players_[1]);
    end
end

function GameScene:onPressLeftPlayer()
    print "onPressLeftPlayer"
    if self.ctrller:is_game_start() == true then
        gBaseLogic.gameLogic:showInformation(self.ctrller.data.players_[3]);
    end
end

function GameScene:onPressRightPlayer()
    print "onPressRightPlayer"
    if self.ctrller:is_game_start() == true then
        gBaseLogic.gameLogic:showInformation(self.ctrller.data.players_[2]);
    end
end

function GameScene:showFaHaoPaiAni()
    print("LobbyScene:showFaHaoPaiAni")
    if self.btnFaHaoPai == 0 then
        self.btnFaHaoPai = cc.ui.UIPushButton.new({
                normal = "images/YouXi/game_ani_fahaopai2.png",
                pressed = "images/YouXi/game_ani_fahaopai2.png",
                disabled = "images/YouXi/game_ani_fahaopai2.png",
            }, {scale9 = false})
            :onButtonClicked(function(event)  
                var_dump(event)
                self:onPressFaHaoPaiButton()
            end)
            -- :setButtonLabel(ui.newTTFLabel({
            --     text = data[3],
            --     size = 24,
            --     color = ccc3(0,0,0)
            --     }))
            :addTo(self.rootNode)
 
            var_dump(self.btnFaHaoPai)
        local ani = getAnimation("game_ani_fahaopai");
        local frame =  tolua.cast(ani:getFrames():objectAtIndex(0),"CCAnimationFrame"):getSpriteFrame()
        local m_playAni = CCSprite:createWithSpriteFrame(frame);
        local action = CCRepeatForever:create(transition.sequence({CCAnimate:create(ani),CCDelayTime:create(2)}));
        m_playAni:runAction(action)--CCDelayTime:create(10)
        self.btnFaHaoPai:addChild(m_playAni);

        self.spriteBeeterSeat =  display.newSprite("images/DaTing/lobby_pic_mail2.png", 0, 0);
        self.labelBeeterSeat = CCLabelTTF:create(0, "Helvetica", 18.0)
        self.rootNode:addChild(self.spriteBeeterSeat)
        self.rootNode:addChild(self.labelBeeterSeat)

        local y = self.twoButton:getPositionY()
        self.btnFaHaoPai:setPositionY(y)
        self.spriteBeeterSeat:setPositionY(y-40)
        self.labelBeeterSeat:setPositionY(y-40)
    end
end

function GameScene:showReadyChange() 
    print("showReadyChange")
    --self.oneButton:setVisible(false)
    --self.oneSprite:setVisible(false)
    --self.threeButton:setVisible(false)
    --self.threeSprite:setVisible(false)
    self.twoButton:setVisible(true)  
    self.twoSprite:setVisible(true)
    self.fourButton:setVisible(true)  
    self.fourSprite:setVisible(true)

    self.twoSprite:setTexture(getCCTextureByName("images/YouXi/game_btn_zhunbei.png"))  --准备
    self.fourSprite:setTexture(getCCTextureByName("images/YouXi/game_btn_huanzhuo.png"))  --换桌

    self.twoSprite:setTag(10)
    self.fourSprite:setTag(11)


    if gBaseLogic.is_robot == 0 then 
        self.fourButton:setPositionX(self.btnPointX[3])
        self.fourSprite:setPositionX(self.btnPointX[3])
    else 
        self:showFaHaoPaiAni()

        local width = self.twoButton:getContentSize().width + 20
        self.twoButton:setPositionX(display.cx - width)
        self.twoSprite:setPositionX(display.cx - width)
        self.fourButton:setPositionX(display.cx ) 
        self.fourSprite:setPositionX(display.cx )
        self.btnFaHaoPai:setPositionX(display.cx + width)
        self.btnFaHaoPai:setVisible(true)

        local betterSeat = CCUserDefault:sharedUserDefault():getIntegerForKey("better_seat"..self.ctrller.data.ply_guid_,-1)

        if betterSeat == nil or betterSeat == -1 then 
            betterSeat = 2
            if (gBaseLogic.lobbyLogic.userHasLogined == true) then
                local ply_items = gBaseLogic.lobbyLogic.userData.ply_items_
                for k,v in pairs(ply_items) do 
                    if v.index_ == self.ctrller.data.index then 
                        betterSeat  =  v.num_
                    end
                end
            else 
                --maybe should do something
            end

            CCUserDefault:sharedUserDefault():setIntegerForKey("better_seat"..self.ctrller.data.ply_guid_,betterSeat)
        end
        self.labelBeeterSeat:setVisible(true)
        self.spriteBeeterSeat:setVisible(true)
        self.labelBeeterSeat:setString(betterSeat)
        self.labelBeeterSeat:setPositionX(display.cx + width + 60)
        self.spriteBeeterSeat:setPositionX(display.cx + width + 60)
        
    end
    
end

function GameScene:showHaoPaiKaPay(info,data,x,y)
    print("showHaoPaiKaPay")
    local popBoxTips = {};
   
    function popBoxTips:onAssignVars()
        --self.labelTitle = tolua.cast(self["labelTitle"],"CCLabelTTF");
        --self.labelContent = tolua.cast(self["labelContent"],"CCLabelTTF");
        self.labelMoney = tolua.cast(self["labelMoney"],"CCLabelTTF");
        self.labelCount = tolua.cast(self["labelCount"],"CCLabelTTF")      
        if nil ~= info then 
            izx.resourceManager:imgFileDown(info.url,true,function(fileName) 
                    self.spriteHaoPaiKa:setTexture(getCCTextureByName(fileName))
            end);
            --self.labelTitle:setString("未知")
            --self.labelContent:setString("未知")
            self.labelMoney:setString("¥"..info.money)  
            self.labelCount:setString("好牌卡（"..info.count.."张）")          
        end
    end

    function popBoxTips:onPressClose()
        gBaseLogic.sceneManager.currentPage.view:closePopBox();
    end 

    function popBoxTips:onPressConfirm()
        local tmptype = "SMS" --"Normal"
        gBaseLogic:addLogDdefine("shopPay","payType",info.money)
        --if tmptype=="SMS" then
            --gBaseLogic.lobbyLogic:onPayTips(3, tmptype, data, 0)
        --else
            gBaseLogic.lobbyLogic:pay(data,tmptype,3);
        --end 
        gBaseLogic.sceneManager.currentPage.view:closePopBox();
        gBaseLogic:blockUI({autoUnblock=false})
    end 
    gBaseLogic.sceneManager.currentPage.view:showPopBoxCCB("interfaces/HaoPaiKa.ccbi",popBoxTips,true,1)
    gBaseLogic.sceneManager.currentPage.view.nodePopBox:setPosition(x,y);

end

function GameScene:showCallScore(nScore) 
    print("GameScene:showCallScore(nScore):"..nScore)
    self.fourButton:setVisible(true)  
    self.fourSprite:setVisible(true)
    self.oneButton:setVisible(true)  
    self.oneSprite:setVisible(true)

    self.oneButton:setEnabled(true) 
    self.fourSprite:setTag(5)
    self.oneSprite:setTag(2)
    self.fourSprite:setTexture(getCCTextureByName("images/YouXi/game_btn_bujiao.png"))  --不叫
    self.oneSprite:setTexture(getCCTextureByName("images/YouXi/game_btn_jiaodizhu.png"))  --叫地主
    self.fourSprite:setPositionX(self.btnPointX[2])
    self.fourButton:setPositionX(self.btnPointX[2])

    self.oneSprite:setPositionX(self.btnPointX[3])
    self.oneButton:setPositionX(self.btnPointX[3])
end 

--[[
function GameScene:showCallScore(nScore) 
    print("GameScene:showCallScore(nScore):"..nScore)
    if (nScore == -1) then 
        self.oneButton:setVisible(true)
        self.oneSprite:setVisible(true)
        self.twoButton:setVisible(true)  
        self.twoSprite:setVisible(true)
        self.threeButton:setVisible(true)  
        self.threeSprite:setVisible(true)
        self.fourButton:setVisible(true)
        self.fourSprite:setVisible(true) 
        self.oneButton:setEnabled(true)
        self.fourSprite:setTexture(getCCTextureByName("images/YouXi/game_btn_bujiao.png"))  --不叫
        self.twoSprite:setTexture(getCCTextureByName("images/YouXi/game_btn_1fen.png"))  --1分
        self.threeSprite:setTexture(getCCTextureByName("images/YouXi/game_btn_2fen.png"))  --2分
        self.oneSprite:setTexture(getCCTextureByName("images/YouXi/game_btn_3fen.png"))  --3分

        self.twoSprite:setTag(3)
        self.threeSprite:setTag(4)

        self.oneSprite:setPositionX(self.btnPointX[4])
        self.oneButton:setPositionX(self.btnPointX[4])
        self.fourSprite:setPositionX(self.btnPointX[1])
        self.fourButton:setPositionX(self.btnPointX[1])
    elseif nScore == 0 then 
        self.oneButton:setVisible(true)
        self.oneSprite:setVisible(true)
        self.twoButton:setVisible(true)  
        self.twoSprite:setVisible(true)
        self.threeButton:setVisible(true)  
        self.threeSprite:setVisible(true)
        self.fourButton:setVisible(true)
        self.fourSprite:setVisible(true) 
        self.oneButton:setEnabled(true)
        self.fourSprite:setTexture(getCCTextureByName("images/YouXi/game_btn_bujiao.png"))  --不叫
        self.twoSprite:setTexture(getCCTextureByName("images/YouXi/game_btn_1fen.png"))  --1分
        self.threeSprite:setTexture(getCCTextureByName("images/YouXi/game_btn_2fen.png"))  --2分
        self.oneSprite:setTexture(getCCTextureByName("images/YouXi/game_btn_3fen.png"))  --3分

        self.oneSprite:setTag(2)
        self.twoSprite:setTag(3)
        self.threeSprite:setTag(4)
        self.fourSprite:setTag(5)

        self.oneSprite:setPositionX(self.btnPointX[4])
        self.oneButton:setPositionX(self.btnPointX[4])
        self.fourSprite:setPositionX(self.btnPointX[1])
        self.fourButton:setPositionX(self.btnPointX[1])

    elseif nScore == 1 then 
        self.oneButton:setVisible(true)
        self.oneSprite:setVisible(true)
        self.threeButton:setVisible(true)  
        self.threeSprite:setVisible(true)
        self.fourButton:setVisible(true)
        self.fourSprite:setVisible(true)

        self.fourSprite:setTexture(getCCTextureByName("images/YouXi/game_btn_bujiao.png"))  --不叫
        self.threeSprite:setTexture(getCCTextureByName("images/YouXi/game_btn_2fen.png"))  --2分
        self.oneSprite:setTexture(getCCTextureByName("images/YouXi/game_btn_3fen.png"))  --3分
        self.oneButton:setEnabled(true)
        self.oneSprite:setTag(2)
        self.threeSprite:setTag(4)
        self.fourSprite:setTag(5)

        local width = self.oneButton:getContentSize().width + 20
        self.oneButton:setPositionX(display.cx - width)
        self.oneSprite:setPositionX(display.cx - width)
        self.threeButton:setPositionX(display.cx ) 
        self.threeSprite:setPositionX(display.cx )
        self.fourButton:setPositionX(display.cx + width)
        self.fourSprite:setPositionX(display.cx + width)

    elseif nScore == 2 then 
        self.oneButton:setVisible(true)
        self.oneSprite:setVisible(true)
        self.fourButton:setVisible(true)
        self.fourSprite:setVisible(true) 

        self.fourSprite:setTexture(getCCTextureByName("images/YouXi/game_btn_bujiao.png"))  --不叫
        self.oneSprite:setTexture(getCCTextureByName("images/YouXi/game_btn_3fen.png"))  --3分
        self.oneButton:setEnabled(true)
        self.oneSprite:setTag(2)
        self.fourSprite:setTag(5)

        self.oneSprite:setPositionX(self.btnPointX[3])
        self.oneButton:setPositionX(self.btnPointX[3])
        self.fourSprite:setPositionX(self.btnPointX[2])
        self.fourButton:setPositionX(self.btnPointX[2])
    end
end
--]]
function GameScene:HidenOpBtn()  --隐藏按钮
    self.myHandCard = 0;
    self.oneButton:setVisible(false)
    self.oneSprite:setVisible(false)
    self.twoButton:setVisible(false)  
    self.twoSprite:setVisible(false)
    self.threeButton:setVisible(false)  
    self.threeSprite:setVisible(false)
    self.fourButton:setVisible(false)
    self.fourSprite:setVisible(false)

    if self.btnFaHaoPai ~= 0 then 
        self.labelBeeterSeat:setVisible(false)
        self.spriteBeeterSeat:setVisible(false)
        self.btnFaHaoPai:setVisible(false)
    end
end

function GameScene:showRobLord()
    self.fourButton:setVisible(true)  
    self.fourSprite:setVisible(true)
    self.threeButton:setVisible(true)  
    self.threeSprite:setVisible(true)
    self.fourSprite:setTag(0)
    self.threeSprite:setTag(1)
    self.fourSprite:setTexture(getCCTextureByName("images/YouXi/game_btn_buqiang.png"))  --不抢
    self.threeSprite:setTexture(getCCTextureByName("images/YouXi/game_btn_qiangdizhu.png"))  --抢地主
    self.fourSprite:setPositionX(self.btnPointX[2])
    self.fourButton:setPositionX(self.btnPointX[2])
    self.threeSprite:setPositionX(self.btnPointX[3])
    self.threeButton:setPositionX(self.btnPointX[3])
end

function GameScene:showLordCardNot()
    -- dizhu_chaird_ = S2C(noti->cLord);
    -- GetMe()->hand_card_area()->set_is_can_touch(true);
    -- for (size_t i=0;i<MAX_PLY_NUM;i++)
    -- {
    --     if(players_[i]!=NULL)
    --         players_[i]->RefreshHeadIcon();
    -- }
    -- char buff[64];
    -- for(int i=0;i<MAX_PLY_NUM;i++)
    -- {
    --     sprintf(buff,"dipai_%d",i);
    --     if(getChildByName("dianchi_node")->getChildByName(buff))
    --     {
    --         getChildByName("dianchi_node")->getChildByName(buff)->removeFromParentAndCleanup(true);
    --     }
    -- }
    -- local winSize = CCDirector:sharedDirector():getWinSize()
    self.cLordCardNode:setVisible(true)
    for k,v in pairs(self.ctrller.data.cLordCard) do
        local pCard = require("moduleDdz.ctrllers.CCardSprite").new(self,v,self.ctrller:GetMe().cards_.m_nBaoValue,0.4);
        self.cLordCardNode:addChild(pCard)
        
        pCard:setPositionX(k*30);
    end
    
end

function GameScene:showDouble(nDouble,nper)
    if self.butLayerState == 1 then
        self:ChangeLayer() 
    end
    
    self.nDouble:setString(nDouble);
    if nper==2 or nper==3 or nper==4 then
        self.btn_changelayer:setEnabled(false)
        local winSize = CCDirector:sharedDirector():getWinSize();
        local ani = getAnimation("game_ani_x"..nper);
        local frame =  tolua.cast(ani:getFrames():objectAtIndex(0),"CCAnimationFrame"):getSpriteFrame()
        local m_playAni = CCSprite:createWithSpriteFrame(frame);
        self.gameLayer:addChild(m_playAni,3); 
        m_playAni:setPosition(ccp(display.cx,display.cy));

        m_playAni:setVisible(true);
        local function FinishDone(playAni)
            playAni:setVisible(false);
            playAni:removeFromParentAndCleanup(true)
            self.btn_changelayer:setEnabled(true)
        end
        --local x,y = self.layer_game_card:getPosition()
        local actionFinishDone = CCCallFuncN:create(FinishDone);
        local action1 = CCEaseExponentialOut:create(CCMoveTo:create(0.5, ccp(display.cx+200,display.height-32)));
        local action2 = CCScaleTo:create(0.5,0.5);

        local fade_seq = transition.sequence({CCAnimate:create(ani),CCDelayTime:create(0.5),CCSpawn:createWithTwoActions(action1, action2),CCFadeOut:create(0.5),CCHide:create(),
            actionFinishDone})

        m_playAni:runAction(fade_seq);
    elseif nper==1 and nDouble ~= 1 then 
        self:ShowGameTip("本场限制倍数为"..nDouble.."倍")
    end
end 


function GameScene:showLaiziCard()
    print("showLaiziCard",self.butLayerState)
    if self.butLayerState == 1 then
        self:ChangeLayer() 
    end 

    self.btn_changelayer:setEnabled(false)
    local v = self.ctrller.data.cLaiziCard
    local pCard2 = require("moduleDdz.ctrllers.CCardSprite").new(self,v,self.ctrller.data.nBaoValue,0.4);
    pCard2:setPositionX(150);
    self.cLordCardNode:addChild(pCard2)    

    

    self.nodeLaiZi:setVisible(true)
    local pCard1 = require("moduleDdz.ctrllers.CCardSprite").new(self,v,self.ctrller.data.nBaoValue,0.9);
    --pCard1:setPosition(ccp(0,0))
    self.nodeLaiZi:addChild(pCard1) 
    --local x, y = self.layer_game_card:getPosition()
    --local action1 = CCMoveTo:create(0.5, ccp(x+150,y));
    local FinishAni = function()
        self.btn_changelayer:setEnabled(true)
    end
    local action1 = CCEaseExponentialOut:create(CCMoveTo:create(0.5, ccp(display.cx+65,display.height-40)));
    local action2 = CCScaleTo:create(1.0,0.4);
    local fade_seq = transition.sequence({CCFadeIn:create(0.5),
                    CCDelayTime:create(2.0),
                    CCSpawn:createWithTwoActions(action1, action2),
                    CCDelayTime:create(0.2),
                    CCFadeOut:create(0.3),
                    CCHide:create(),
                    CCCallFuncN:create(handler(slelf,FinishAni))}); --CCCallFuncN:create(RemoveNode)
    self.nodeLaiZi:runAction(fade_seq); 
    
end

function GameScene:changeBtnPosition() 
    local width = self.oneButton:getContentSize().width + 20
    self.oneButton:setPositionX(display.cx - width)
    self.oneSprite:setPositionX(display.cx - width)
    self.twoButton:setPositionX(display.cx ) 
    self.twoSprite:setPositionX(display.cx )
    self.fourButton:setPositionX(display.cx + width)
    self.fourSprite:setPositionX(display.cx + width)
end 

function GameScene:storeBtnPosition() 
    self.btnPointX[1] = self.oneButton:getPositionX()
    self.btnPointX[2] = self.twoButton:getPositionX()
    self.btnPointX[3] = self.threeButton:getPositionX()
    self.btnPointX[4] = self.fourButton:getPositionX()
end

function GameScene:resetBtnPosition() 
    self.oneButton:setPositionX(self.btnPointX[1])
    self.oneSprite:setPositionX(self.btnPointX[1])
    self.twoButton:setPositionX(self.btnPointX[2]) 
    self.twoSprite:setPositionX(self.btnPointX[2])
    self.threeButton:setPositionX(self.btnPointX[3])
    self.threeSprite:setPositionX(self.btnPointX[3])
    self.fourButton:setPositionX(self.btnPointX[4])
    self.fourSprite:setPositionX(self.btnPointX[4])
end

function GameScene:showPlayCardBtn()
    self.myHandCard = 1;
    self.ctrller:GetMe().play_card_:removeAllChildrenWithCleanup(true);
    self.oneButton:setVisible(true)
    self.oneButton:setEnabled(true)
    self.oneSprite:setVisible(true)
    self.twoButton:setVisible(true)  
    self.twoSprite:setVisible(true)
    --self.threeButton:setVisible(true)  
    --self.threeSprite:setVisible(true)
    self.fourButton:setVisible(true)
    self.fourSprite:setVisible(true)
    self.oneSprite:setTexture(getCCTextureByName("images/YouXi/game_btn_buchu.png"))  --不出
    self.twoSprite:setTexture(getCCTextureByName("images/YouXi/game_btn_tishi.png"))  --提示
    --self.threeSprite:setTexture(getCCTextureByName("images/YouXi/game_btn_chongxuan.png"))  --重选
    self.fourSprite:setTexture(getCCTextureByName("images/YouXi/game_btn_chupai.png"))  --出牌
    self.oneSprite:setTag(6)
    self.twoSprite:setTag(7)
    --self.threeSprite:setTag(8)
    self.fourSprite:setTag(9) 
    self:changeBtnPosition() 
end

function GameScene:showWanFaDialog(bShow)
    self.popChildren = require("moduleDdz.views.WanFaDialog").new(nil,self);
    self:showPopBoxCCB("interfaces/XuanZeWanFa.ccbi",self.popChildren,true);
end


--jipaiqishuaxing
function GameScene:initNoteCardsNum()
    if gBaseLogic.lobbyLogic.vipData.vipLevel>=9 then
        self.spriteLetterNumber1:setVisible(true)
        self.labelNew1:setVisible(true)
        self.labelNew1:setString("∞")
    else
        if self.ctrller.noteCardsNum>0 then
            self.spriteLetterNumber1:setVisible(true)
            self.labelNew1:setVisible(true)
            self.labelNew1:setString(self.ctrller.noteCardsNum)
        else
            self.spriteLetterNumber1:setVisible(false)
            self.labelNew1:setVisible(false)
        end
    end
end
--
function GameScene:initRoundTasknum()
    print("GameScene:initRoundTasknum"..self.logic.roundTaskFinishNum)
    if self.logic.roundTaskFinishNum>0 then
        if self.logic.roundTaskFinishNum>3 then
            self.logic.roundTaskFinishNum = 3;
        end
        self.spriteLetterNumber2:setVisible(true)
        self.labelNew2:setVisible(true)
        self.labelNew2:setString(self.logic.roundTaskFinishNum)
    else
        self.logic.roundTaskFinishNum = 0;
        self.spriteLetterNumber2:setVisible(false)
        self.labelNew2:setVisible(false)
    end
end 


function GameScene:actionMoveDone()
    -- self:hideGameTip()
    self:setVisible(false)
end
function GameScene:onRemovePage()
    if (self.scheduler) then
        self.scheduler.unscheduleGlobal(self.serTimeHandler)
        self.scheduler = nil 
        self.serTimeHandler = nil;
    end
end
function GameScene:hideGameTip()
    if self.notspriteback~=nil then
        self.notspriteback:setVisible(false)
    end
end
function GameScene:ShowGameTip(str,isShow) --游戏内通用提示
    print("GameScene:ShowGameTip")
    -- if false == isShow then 
    --     local fade_seq = transition.sequence({
    --     CCFadeOut:create(0.25),
    --     CCHide:create(),
    --     CCCallFuncN:create(self.actionMoveDone)});
    --     self.notspriteback:runAction(fade_seq);
    --     return
    -- end
    if self.notspriteback==nil then
        local scene = self.rootNode;
        local spriteback = CCSprite:create("images/DaTing/lobby_bg_gonggao.png")
        spriteback:setPosition(display.cx,display.cy+5)
        scene:addChild(spriteback);
        local text = CCLabelTTF:create(str,"Helvetica",24);
        local textbacksize = spriteback:getContentSize()
        text:setPosition(ccp(textbacksize.width/2,textbacksize.height/2));
        spriteback:addChild(text);
        self.spritebacktext = text;
        self.notspriteback = spriteback
    else
        -- setVisible(true)
        
        if self.spritebacktext~=nil then
            self.spritebacktext:setString(str)
        else
            local text = CCLabelTTF:create(str,"Helvetica",24);
            local textbacksize = self.notspriteback:getContentSize()
            text:setPosition(ccp(textbacksize.width/2,textbacksize.height/2));
            self.notspriteback:addChild(text);
            self.spritebacktext = text;
        end
        self.notspriteback:setVisible(true)
    end
    if nil == isShow then
        local fade_seq = transition.sequence({CCFadeIn:create(0.25),
        CCDelayTime:create(1.0),
        CCFadeOut:create(0.25),
        CCHide:create(),
        CCCallFuncN:create(self.actionMoveDone)});
        self.notspriteback:runAction(fade_seq);
    end
end

function GameScene:OnGameResult(noti)
    -- if (is_robot) then
    --     pt_gc_game_result_not1 not1 = *((pt_gc_game_result_not1*)noti);
    --     GameSession::GetInstancePtr()->set_pt_gc_game_result(not1);
    -- end

    gBaseLogic:addLogCounter("matchCounter",1)
    local Cards = self.ctrller.data.players_[2]:GetPlayCards();
    
    local num = #Cards.m_cCards;
    CCDirector:sharedDirector():purgeCachedData();
    if (num > 0 and Cards.m_cCards[1].m_nValue ~= 0) then
        self.ctrller.data.players_[2].play_card_:removeAllChildrenWithCleanup(true)
        Cards:CleanUp();
        for i,v in ipairs(Cards.m_cCards) do
            local cardsprite = require("moduleDdz.ctrllers.CCardSprite").new(self,v,Cards.m_nBaoValue,0.5);

            self.ctrller.data.players_[2].play_card_:addChild(cardsprite,num*math.floor((i-1)/10)+num-i);
            cardsprite:setAnchorPoint(ccp(0,0.5))
            cardsprite:setPosition(0-(i-1)%10*35,0-math.floor((i-1)/10)*50);
        end
    end

    Cards = self.ctrller.data.players_[3]:GetPlayCards();
    
    if (#Cards.m_cCards > 0 and Cards.m_cCards[1].m_nValue ~= 0) then
        self.ctrller.data.players_[3].play_card_:removeAllChildrenWithCleanup(true)
        Cards:CleanUp();
         for i,v in ipairs(Cards.m_cCards) do
            local cardsprite = require("moduleDdz.ctrllers.CCardSprite").new(self,v,Cards.m_nBaoValue,0.5);
            self.ctrller.data.players_[3].play_card_:addChild(cardsprite,num*math.floor((i-1)/10));
            cardsprite:setAnchorPoint(ccp(1,0.5))
            cardsprite:setPosition((i-1)%10*35,0-math.floor((i-1)/10)*50);
        end
    end
    --播放地主胜利动画
    -- gBaseLogic.scheduler.performWithDelayGlobal(function()
    --     self.logic:showNewJieSuan()
    --     end,4.0)
     local function RemoveNode()
       self.gameLayer:removeChildByTag(1000)
       self.logic:showNewJieSuan()
       self.ctrller:reInit()

       --[[
       self.ctrller.data.players_[1].play_card_:removeAllChildrenWithCleanup(true);
       self.ctrller.data.players_[2].play_card_:removeAllChildrenWithCleanup(true)
       self.ctrller.data.players_[3].play_card_:removeAllChildrenWithCleanup(true)
        self.clientTimerPos = -1;
        self.ctrller.vernier_index = 1;--提示
        self.ctrller.is_auto_ = false;
        self.ctrller.useNoteCards = 0;--是否打开过记牌器面板  
        self.ctrller.nDouble = 1;
        self.logic.isErrorJoin = 0;
        self.nodetask:setVisible(false);
        self.nodeNoteCards:setVisible(false)       
        self.nDouble:setString("1");       
        self.cLordCardNode:setVisible(false)
        self.nodeLaiZi:setVisible(false)
        self.nodeLaiZi:setScale(1.0)
        self.nodeLaiZi:setPosition(ccp(display.cx,display.cy))
        --self:GetMe().play_card_:removeAllChildrenWithCleanup(true);
        self.ctrller:GetMe().cards_.m_cCards = {};
        self.ctrller:GetMe().cards_:SetBaoValue(0);
        self.puKeLayer:removeAllChildrenWithCleanup(true);
        self.ctrller.data.nowCardTyp = {m_nTypeBomb=0,m_nTypeNum=0,m_nTypeValue=0}--上个出牌人的出牌类型
        self.ctrller.data.nowcChairID = 0--上个出牌人的位置
        self:resetBtnPosition()
        self.gameLayer:removeChildByTag(2)
        -- self.gamescene.puKeLayer:removeAllChildrenWithCleanup(true);
        --]]

    end
    if (noti.bType == 1) then
        print("ani_rob_win")
        local ani = getAnimation("ani_rob_win");
        -- if ani==false then
        --     self.logic:showJieSuan()
        -- else
        print("111")
            local frame =  tolua.cast(ani:getFrames():objectAtIndex(0),"CCAnimationFrame"):getSpriteFrame()
            local m_pSprite = CCSprite:createWithSpriteFrame(frame);
            -- local m_pSprite = display.newNode()
            self.gameLayer:addChild(m_pSprite,10,1000); 
            m_pSprite:setPosition(display.cx,display.cy);
            
            local call = CCCallFuncN:create(RemoveNode);
            m_pSprite:runAction(CCRepeatForever:create(CCAnimate:create(ani)));
            m_pSprite:runAction(transition.sequence({CCDelayTime:create(4.0),call}));
        -- end
    elseif (noti.bType == 2) then
        print("ani_rob_failure")
        local ani = getAnimation("ani_rob_failure");
        print("111")
            local frame =  tolua.cast(ani:getFrames():objectAtIndex(0),"CCAnimationFrame"):getSpriteFrame()
            local m_pSprite = CCSprite:createWithSpriteFrame(frame);
            self.gameLayer:addChild(m_pSprite,10,1000);
            m_pSprite:setPosition(display.cx,display.cy);
            
            local call = CCCallFuncN:create(RemoveNode);
            m_pSprite:runAction(CCRepeatForever:create(CCAnimate:create(ani)));
            m_pSprite:runAction(transition.sequence({CCDelayTime:create(4.0),call}));
    end
    print("222")
end

function GameScene:GameStart(nMoney)
    if self.butLayerState == 1 then
        self:ChangeLayer() 
    end 
    self.nDizhu:setString(nMoney);
    for i=1,3 do
        self.ctrller.data.players_[i].meTip:setVisible(false);
    end
    gBaseLogic.audio:PlayBackground();
    gBaseLogic:logEventLabelDuration("gameTime","ready",1)
end

function GameScene:onTouch(event, x, y)
    if event == "began" then
        if (self.ctrller:is_game_start()) and self.ctrller.is_auto_ == false  then
            self.m_pCardSprite = self:itemForTouch(x, y);
                if (self.m_pCardSprite ~= nil) then
                    if self.m_pCardSprite:getStatus() == self.m_pCardSprite.data.ST_UNSELECTED then
                        table.insert(self.cardForTouch,self.m_pCardSprite:getCardValue().m_nValue)
                    else
                        self.hasUnselected = 1
                    end
                    self.m_pCardSprite:selected();
                end
        end
        if (self.tabViewLayer~=nil and self.spriteContent:isVisible()) then
            local tab_x,tab_y = self.nodetrum:getPosition();
            --print("tablexy",tab_x,tab_y)
            if self.spriteContent:boundingBox():containsPoint(CCPoint(x-tab_x,y-tab_y)) == false then
                --print (111)
                self.spriteContent:setVisible(false)
                self.tabViewLayer:unregisterScriptTouchHandler()
                self.tabViewLayer:removeAllChildrenWithCleanup(true);
                self.tabViewLayer = nil 
                self.nodetask:setVisible(true)
            else
                --print (222)
            end
        end
        return true
    elseif event == "moved" then
        if (self.ctrller:is_game_start()  and self.ctrller.is_auto_ == false) then
            local curCard = self:itemForTouch(x, y);
            if curCard ~= nil then 
                if (curCard:getCardValue().m_nValue == 99) then
                    return;
                elseif curCard ~= self.m_pCardSprite then
                    self.m_pCardSprite = curCard;
                    
                    if self.m_pCardSprite:getStatus() == self.m_pCardSprite.data.ST_UNSELECTED then
                        table.insert(self.cardForTouch,curCard:getCardValue().m_nValue)
                    else
                        self.hasUnselected = 1
                    end
                    self.m_pCardSprite:selected();
                end
            end
        end
    elseif event == "ended" then
        print("=======end")
        -- self:checkSelectCards();
        -- self.ctrller:GetMe():GetPlayCards().m_vecTipsCards
        -- if 
        -- var_dump(self.cardForTouch);
        -- print(#self.cardForTouch)
        if self.hasUnselected==1 or true then
            return
        end
        if (self.myHandCard==1 and #self.cardForTouch>1) then
             
            local flag = 0;
            if self.ctrller.data.nowcChairID==-1 or self.ctrller.data.nowCardTyp.m_nTypeNum==0 or self.ctrller.data.nowcChairID==self.ctrller.data.self_ply_attrs_.chair_id_ then
                flag = 0;
            else
                if (#self.ctrller:GetMe():GetPlayCards().m_vecTipsCards>0) then
                    flag = 1;
                end
            end
            print("=======endfor"..flag)
            if flag==1 then
                local maxindex = 0;
                local maxkey = 0;

                 local mecard = self.ctrller.data.players_[1].MeCCard;
                -- var_dump(vecCard)
                local selectedCards = {}
                local selectedCardsNums = 0
                for i=1, #mecard do
                    local pObject = mecard[i]
                    if (pObject and pObject:getStatus() == pObject.data.ST_SELECTED) then
                        table.insert(selectedCards,pObject)
                        selectedCardsNums = selectedCardsNums+1
                    end
                end
                local selectedKey = 0;
                for k,v in pairs(selectedCards) do
                    for k1,vCards in pairs(self.ctrller:GetMe():GetPlayCards().m_vecTipsCards) do
                        local thisnum = 0;
                        for k2,v2 in pairs(vCards) do
                            if v.m_nValue==v2.m_nValue then
                                thisnum = thisnum+1;
                            end
                        end
                        if thisnum==selectedCardsNums then
                            print("111111111111")
                            selectedKey = k1;
                            break;
                        end
                    end
                    if selectedKey~=0 then
                        local selectvecCard = self.ctrller:GetMe():GetPlayCards().m_vecTipsCards[selectedKey];
                        self:setSelectedCard(selectvecCard);
                        var_dump(selectvecCard)
                        break;
                    end
                end


                -- for k1,vCards in pairs(self.ctrller:GetMe():GetPlayCards().m_vecTipsCards) do
                --     kvindex = 0;
                --     local cardForTouch = self.cardForTouch
                --     for k,v in pairs(vCards) do
                        
                --         for km,vn in pairs(cardForTouch) do
                --             if vn==v.m_nValue then
                --                 kvindex = kvindex+1;
                --                 local newcardForTouch = {}
                --                 for k2,e in pairs(cardForTouch) do
                --                     if k2~=km then
                --                         table.insert(newcardForTouch,e);
                --                     end
                --                 end
                --                 cardForTouch = nil;
                --                 cardForTouch = newcardForTouch;
                --                 break;
                --             end
                --         end                       
                --     end
                --     if kvindex>maxindex then
                --         maxindex = kvindex
                --         maxkey = k1
                --     end
                -- end
                -- if (maxkey~=0) then
                    -- local selectvecCard = self.ctrller:GetMe():GetPlayCards().m_vecTipsCards[maxkey];
                    --     self:setSelectedCard(selectvecCard);
                    --     var_dump(selectvecCard)
                -- end
            end
        end
        self.cardForTouch = {};
        -- self.hasUnselected = 0
    end
    
end

--滑动取牌的操作。
function GameScene:itemForTouch(x, y)
    local mecard = self.ctrller.data.players_[1].MeCCard;
    print("itemForTouch")
    --var_dump(mecard,3);
    for i=#mecard, 1, -1 do
        local pObject = mecard[i]
        --var_dump(pObject,3)
        if (pObject) then
            local r = pObject:rect();
            local Point  = pObject:convertToNodeSpace(CCPoint(x, y));
            r.origin = ccp(0,0);
            if (r:containsPoint(Point)) then
                return pObject;
            end
        end
    end
    return nil
end

function GameScene:getSelectedCard()
    local choose_cCards = {}
    local mecard = self.ctrller.data.players_[1].MeCCard;
    for i=1, #mecard do
        local pObject = mecard[i]
        if pObject and pObject:getStatus() == pObject.data.ST_SELECTED then
            table.insert(choose_cCards,pObject:getCardValue())
        end
    end
    return choose_cCards
end

function GameScene:releaseSelectedCard()
    local mecard = self.ctrller.data.players_[1].MeCCard;
    for i=1, #mecard do
        local pObject = mecard[i]
        if pObject and (pObject:getStatus() == pObject.data.ST_SELECTED) then
            pObject:setStatus(pObject.data.ST_UNSELECTED);
        end
    end
end

function GameScene:setSelectedCard(vecCard)
    self:releaseSelectedCard();
    local mecard = self.ctrller.data.players_[1].MeCCard;
    -- var_dump(vecCard)
    for k,v in pairs(vecCard) do
        for i=1, #mecard do
            local pObject = mecard[i]
            if (pObject and pObject:getStatus() == pObject.data.ST_UNSELECTED) then
                if pObject:getCardValue().m_nValue == v.m_nValue then
                    pObject:setStatus(pObject.data.ST_SELECTED);
                    break;
                end
            end
        end
    end
end

function GameScene:OnRefreshCard(message)
    local data = self.ctrller.data;
    local pPlayer = self.ctrller:FindPlayerByChairID(message.cChairID);
    --var_dump(message.vecCards)
    pPlayer:RefreshCard(message.vecCards);
end

function GameScene:getFrame(sName,  width,  height,  frame)
    local sprite = CCSprite:create(sName);
    
    if (sprite == nil) then
        return nil;
    end

    local ori = sprite:getTextureRect().origin;
    local size = sprite:getContentSize();

    local rect = CCRectMake(0,0,0,0);
    if (sprite:isTextureRectRotated() == false) then
        rect.origin.x = ori.x+frame%width*size.width/width;
        rect.origin.y = ori.y+math.floor(frame/width)%height*size.height/height;
    else
        rect.origin.x = ori.x+(height-math.floor(frame/width)%height-1)*size.height/height;
        rect.origin.y = ori.y+frame%width*size.width/width;
    end
    rect.size.width = size.width/width;
    rect.size.height = size.height/height;
    rect = self:CC_RECT_POINTS_TO_PIXELS(rect);
    sprite:setTextureRect(rect, sprite:isTextureRectRotated(),rect.size);

    return sprite;
end

function GameScene:CC_RECT_POINTS_TO_PIXELS(__points__)
    local CC_CONTENT_SCALE_FACTOR = function () return CCDirector:sharedDirector():getContentScaleFactor() end
    local rect = CCRectMake((__points__).origin.x * CC_CONTENT_SCALE_FACTOR(), (__points__).origin.y * CC_CONTENT_SCALE_FACTOR(), (__points__).size.width * CC_CONTENT_SCALE_FACTOR(), (__points__).size.height * CC_CONTENT_SCALE_FACTOR() )
    return rect
end
   
function GameScene:CUIPOS(__C__, __A__, __X__, __Y__)
    local  pos = ccp((__X__)+__A__:getContentSize().width/2, __C__:getContentSize().height-(__Y__)-__A__:getContentSize().height/2)
    return pos
end

-- function GameScene:Sqrt(x) --计算平方根
--     float val = x;  
--     --保存上一个计算的值  
--     float last;  
--     do 
--     {  
--         last = val;  
--         val =(val + x/val) / 2;  

--     }  
--     while (abs(val-last) > eps);  
--     return val;  
-- end


local TableViewLayer = class("TableViewLayer")
TableViewLayer.__index = TableViewLayer

function TableViewLayer.extend(target)
    local t = tolua.getpeer(target)
    if not t then
        t = {}
        tolua.setpeer(target, t)
    end
    setmetatable(t, TableViewLayer)
    return target
end 
function TableViewLayer.cellSizeForTable(table,idx)
    return 25,763
end

function TableViewLayer.tableCellAtIndex(table, idx)
    local cell = table:dequeueCell()
    local label = nil
    if nil == cell then        
        cell = CCTableViewCell:new()
    else
        cell:removeAllChildrenWithCleanup(true);
    end 
    local label = CCLabelTTF:create(table:getParent().data[idx+1], "Helvetica", 20.0)
    label:setAnchorPoint(ccp(0,0))
    cell:addChild(label) 
    return cell
end

function TableViewLayer.numberOfCellsInTableView(table)
    -- var_dump(table.data);
    local data = table:getParent().data;
    return #data
end

function TableViewLayer:init(data)
    self:removeAllChildrenWithCleanup(true);

    self.data = data;
    tableView = CCTableView:create(CCSizeMake(763, 410))
    tableView:setDirection(kCCScrollViewDirectionVertical)
    tableView:setVerticalFillOrder(kCCTableViewFillTopDown)
    -- self:addChild(tableView)     
    tableView:registerScriptHandler(TableViewLayer.cellSizeForTable,CCTableView.kTableCellSizeForIndex)
    tableView:registerScriptHandler(TableViewLayer.tableCellAtIndex,CCTableView.kTableCellSizeAtIndex)
    tableView:registerScriptHandler(TableViewLayer.numberOfCellsInTableView,CCTableView.kNumberOfCellsInTableView)
    -- tableView:reloadData()
    return tableView
end

function TableViewLayer.create(spriteContent)
    local tabViewLayer = display.newLayer();
    spriteContent:addChild(tabViewLayer)  
    tabViewLayer:setAnchorPoint(ccp(0,0))
    tabViewLayer:setPosition(ccp(0,0))
    tabViewLayer = TableViewLayer.extend(tabViewLayer)
    tabViewLayer:setContentSize(CCSizeMake(763,410))
    return tabViewLayer   
end

function GameScene:createTableView(spriteContent)    
    -- TableViewLayer.create(spriteContent)
    self.tabViewLayer = TableViewLayer.create(spriteContent)
end

function GameScene:changeChongzhijiangliButton()
    print("LobbyScene:changeChongzhijiangliButton")
        -- setBackgroundSpriteForState
        -- self.view.btnChongZhiJiangLi 
    -- local file0  = "images/DaTing/baoxiang_1.png"
    -- local file1  = "images/DaTing/baoxiang_1.png"
    -- if gBaseLogic.lobbyLogic.payInitList~=nil then
    --     if tonumber(gBaseLogic.lobbyLogic.payInitList.payMoney)>=tonumber(gBaseLogic.lobbyLogic.getPayNum) and tonumber(gBaseLogic.lobbyLogic.getPayNum)~=0 then
        
    --         file0  = "images/DaTing/baoxiang_2.png"
    --         file1  = "images/DaTing/baoxiang_2.png"
    --     end
    -- end
    
    -- local buttonimg0 = CCScale9Sprite:create(file0)
    -- local buttonimg1 = CCScale9Sprite:create(file1)
    -- local buttonimg2 = CCScale9Sprite:create(file1)
    -- -- pBackgroundHighlightedButton, CCControlStateHighlighted
    -- -- print("self.btnChongZhiJiangLi:setBackgroundSpriteForState")
    -- self.btnChongZhiJiangLi:setBackgroundSpriteForState(buttonimg0,1)
    -- self.btnChongZhiJiangLi:setBackgroundSpriteForState(buttonimg1,2)
    -- self.btnChongZhiJiangLi:setBackgroundSpriteForState(buttonimg2,3)
end
function GameScene:initBaoXiang()
    --[[
    if self.logic.baoXiangRenWu.taskSystem == nil then

    return
    end
    --]]
    --by Sonke 20140626 lottery draw
    print("GameScene:initBaoXiang():::::");


    if self.btn_task == nil then
        self.btn_task = CCControlButton:create("", "Helvetica", 24);
     
        self.btn_task:setPreferredSize(CCSizeMake(76,79));

        local point = ccp(self.btnChongZhiJiangLi:getPosition());
        local point2 = ccp(self.nodeGameGit:getPosition());
        print(point.y,point2.y)
        local task_y = point.y + point.y - point2.y; 
        self.btn_task:setPosition(point.x,task_y);

        print("==========baoxiang x "..point.x.."  y "..task_y);

        self.rootNode:addChild(self.btn_task);

        self.btn_task:addHandleOfControlEvent(function(strEventName,pSender)
                                    --self:setBaoXiangSprite(true);
                                    --self.logic:showBaoXiangRenWu();
                                    --by Sonke 20140626 lottery draw
                                    if self.logic.LotteryDraw.curTimes >= self.logic.LotteryDraw.MaxTimes then
                                      self:ShowGameTip("高级场会有更多抽奖机会哦!")
                                    --elseif self.logic.LotteryDraw.curGames >= self.logic.LotteryDraw.reqGames then
                                    else
                                    	if self.logic.LotteryDrawWuLayershow == nil then
                                    		self.logic.LotteryDrawWuLayershow = 1
                                      		self.logic:showLotteryDraw();
                                      		self:setBaoXiangSprite(true);
                                      	end
                                    --else
                                    --  self:ShowGameTip("还需要完成"..(self.logic.LotteryDraw.reqGames - self.logic.LotteryDraw.curGames).."局，才可以抽奖!")
                                      --self:setBaoXiangSprite(false);
                                    end 
                                    return true;
                                 end, CCControlEventTouchUpInside);
                                 
        self:setBaoXiangSprite(false);
    end
  
end 

function GameScene:setBaoXiangSprite(isOpen)
	print("GameScene:setBaoXiangSprite")
    if self.btn_task == nil then
        return;
    end

    var_dump(self.logic.LotteryDraw);
    if self.logic.LotteryDraw == nil or 
        self.logic.LotteryDraw.MaxTimes == -1 or self.logic.LotteryDraw.reqGames == -1 or 
        self.logic.LotteryDraw.MaxTimes == 0 or self.logic.LotteryDraw.reqGames == 0 then
        print("1111")
        self.btn_task:setVisible(false);
        return;
    else
    	print("1112")
        self.btn_task:setVisible(true);
    end

    local img_normal = nil;

    self.btn_task:removeAllChildrenWithCleanup(true);

    if isOpen then
    img_normal = CCScale9Sprite:create("images/YouXi/game_btn_choujiang2.png");
    self.btn_task:setBackgroundSpriteForState(img_normal, CCControlStateNormal);
    else
    --[[
    for i = 1, #self.logic.baoXiangRenWu.curTask do
      if self.logic.baoXiangRenWu.curTask[i].award_round_ ~= nil and 
         self.logic.baoXiangRenWu.curTask[i].cur_val_ >= self.logic.baoXiangRenWu.curTask[i].award_round_ then
        self:shakeBaoXiang();
        --self.btn_task:setVisible(false);
        img_normal = nil;
        return;
      end
    end
    --]]
    --by Sonke 20140626 lottery draw
    --print("==============curGames "..self.logic.LotteryDraw.curGames.." reqGames = "..self.logic.LotteryDraw.reqGames)
    if self.logic.LotteryDraw.curTimes < self.logic.LotteryDraw.MaxTimes and self.logic.LotteryDraw.curGames >= self.logic.LotteryDraw.reqGames then
      self:shakeBaoXiang();
      return;
    end

    img_normal = CCScale9Sprite:create("images/YouXi/game_btn_choujiang1.png");
    self.btn_task:setBackgroundSpriteForState(img_normal, CCControlStateNormal);
    end
    --local img_select = CCScale9Sprite:create("images/TanChu/baoxiang_2.png");
    --local img_disable = CCScale9Sprite:create("images/TanChu/baoxiang_2.png");


    --self.btn_task:setBackgroundSpriteForState(img_select, CCControlStateHighlighted);
    --self.btn_task:setBackgroundSpriteForState(img_disable, CCControlStateDisabled);

end

function GameScene:shakeBaoXiang()
    print("===================gameScene:shakeBaoXiang=================");
    self.btn_task:removeAllChildrenWithCleanup(true);
    local ani = getAnimation("round_baoxiang_ani");
    local first_frame = tolua.cast(ani:getFrames():objectAtIndex(0), "CCAnimationFrame"):getSpriteFrame();
    local ani_sprite = CCSprite:createWithSpriteFrame(first_frame);
    self.btn_task:addChild(ani_sprite);
    ani_sprite:setPosition(ccp(ani_sprite:getContentSize().width/2, ani_sprite:getContentSize().height/2));
    local action = CCRepeatForever:create(CCAnimate:create(ani));
    ani_sprite:runAction(action);
end
return GameScene;
