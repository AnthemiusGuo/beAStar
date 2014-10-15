local LobbyScene = class("LobbyScene",izx.baseView)

function LobbyScene:ctor(pageName,moduleName,initParam)
	print ("LobbyScene:ctor")
    self.mainX = 0
    self.mainY = 0
    self.butMoveState = 0
    self.super.ctor(self,pageName,moduleName,initParam);

    self.noMinigamePositionFix = 0;
    self.configMainGames = {{id=1,name="huanle",order=1},{id=2,name="lazi",order=2},{id=3,name="bisai",order=3},{id=4,name="yule",order=4},{id=5,name="daji",order=5}}

end


function LobbyScene:onAssignVars()
	self.rootNode = tolua.cast(self.rootNode,"CCNode");

    if nil ~= self["labelMoneyNumber"] then
    	self.labelMoneyNumber = tolua.cast(self["labelMoneyNumber"],"CCLabelTTF")
    end
    if nil ~= self["spriteVipLevel"] then
        self.spriteVipLevel = tolua.cast(self["spriteVipLevel"],"CCSprite")
    end
    if nil ~= self["labelNickName"] then
        self.labelNickName = tolua.cast(self["labelNickName"],"CCLabelTTF")
    end

    if nil ~= self["labelGonggao"] then
        self.labelGonggao = tolua.cast(self["labelGonggao"],"CCLabelTTF")
    end
    if nil ~= self["spriteGonggao"] then
        self.spriteGonggao = tolua.cast(self["spriteGonggao"],"CCSprite")
    end 
    if nil ~= self["spriteDefaultHead"] then
        self.spriteDefaultHead = tolua.cast(self["spriteDefaultHead"],"CCSprite")
    end

    if nil ~= self["spriteContent"] then
        self.spriteContent = tolua.cast(self["spriteContent"],"CCScale9Sprite")
    end

    if nil ~= self["nodetrum"] then
        self.nodetrum = tolua.cast(self["nodetrum"],"CCNode")
    end

    if nil ~= self["labelvipprogress"] then
        self.labelvipprogress = tolua.cast(self["labelvipprogress"],"CCLabelTTF")
    end
    if nil ~= self["SpriteVipProgress"] then
        self.SpriteVipProgress = tolua.cast(self["SpriteVipProgress"],"CCSprite")
    end

    if nil ~= self["spriteLetterNumber"] then
        self.spriteLetterNumber = tolua.cast(self["spriteLetterNumber"],"CCSprite")
    end

    if nil ~= self["labelNew"] then
        self.labelNew = tolua.cast(self["labelNew"],"CCLabelTTF")
    end

    if nil ~= self["mainbtnNode"] then
        self.mainbtnNode = tolua.cast(self["mainbtnNode"],"CCNode")
    end

    if nil ~= self["gameNode"] then
        self.gameNode = tolua.cast(self["gameNode"],"CCNode")
    end

    if nil ~= self["fuzunode"] then
        self.fuzunode = tolua.cast(self["fuzunode"],"CCNode")
    end

    -- if nil ~= self["btnLazi"] then
    --     self.btnLazi = tolua.cast(self["btnLazi"],"CCControlButton")
    -- end

    -- -- if nil ~= self["btnYule"] then
    -- --     self.btnYule = tolua.cast(self["btnYule"],"CCControlButton")
    -- -- end

    -- if nil ~= self["btnQuick"] then
    --     print("btnQuick has this")
    --     self.btnQuick = tolua.cast(self["btnQuick"],"CCControlButton")
    -- end

    -- if nil ~= self["btnHappy"] then
    --     self.btnHappy = tolua.cast(self["btnHappy"],"CCControlButton")
    -- end 

    -- if nil ~= self["btnDanJi"] then
    --     self.btnDanJi = tolua.cast(self["btnDanJi"],"CCControlButton")
    -- end

    if nil ~= self["btnChongZhiJiangLi"] then
        self.btnChongZhiJiangLi = tolua.cast(self["btnChongZhiJiangLi"],"CCControlButton")
    end

    if nil ~= self["minGameScroll"] then
        self.minGameScroll = tolua.cast(self["minGameScroll"],"CCScrollView")
        print("minGameScroll")
    end

    -- self.circle = display.newCircle(10);


    if nil ~= self["fuzuView"] then
        self.fuzuView = tolua.cast(self["fuzuView"],"CCNode")
    end
    if nil ~= self["spriteLogo"] then
        self.spriteLogo = tolua.cast(self["spriteLogo"],"CCSprite")
        gBaseLogic.MBPluginManager:replacelogo("logodating",self.spriteLogo)
      
    end  

    if nil ~= self["btn_huodong"] then
        self.btn_huodong = tolua.cast(self["btn_huodong"],"CCControlButton");
        if (gBaseLogic.MBPluginManager.distributions.noactivity) then
            self.btn_huodong:setVisible(false);
        end
    end
    self:initMainGames();

    if gBaseLogic.MBPluginManager.distributions.specialShow~=nil and type(gBaseLogic.MBPluginManager.distributions.specialShow)=="string" then
        local specialShow = gBaseLogic.MBPluginManager.distributions.specialShow
        local filename = CCFileUtils:sharedFileUtils():fullPathForFilename("thirdparty/"..specialShow..".png")
        if io.exists(filename)==true then
            local px,py = self.nodetrum:getPosition();
            local thisuiButton = cc.ui.UIPushButton.new({
                        normal = "thirdparty/"..specialShow..".png",
                        pressed = "thirdparty/"..specialShow..".png",
                        disabled = "thirdparty/"..specialShow..".png",
                    }, {scale9 = false})
                    :onButtonClicked(function(event)  
                            gBaseLogic.MBPluginManager:enterSocial()                
                        end)
                    :addTo(self.rootNode);
            thisuiButton:setPosition(144,py);
            thisuiButton:setAnchorPoint(ccp(0.5,0.5));
        end
    end

    self:initMenuButton();
    


    
end
function LobbyScene:initMainGames()
	-- self.configMainGames = {{id=1,name="huanle",order=1},{id=2,name="lazi",order=2},{id=3,name="bisai",order=3},{id=4,name="yule",order=4},{id=5,name="daji",order=5}}
	if (gBaseLogic.MBPluginManager.distributions.disablematch==true) then
        self:removetableValuesById(3);
    end
	-- self:removetableValuesById(3);
	if (gBaseLogic.MBPluginManager.distributions.nominigame==true) then
        self:removetableValuesById(4);
    end
    -- self:removetableValuesById(4);
    -- self:removetableValuesById(3);
    -- self:removetableValuesById(5);
    if gBaseLogic.lobbyLogic.userHasLogined == false then 
        --izxMessageBox("暂未登录!", "提示");
        for k,v in pairs(self.configMainGames) do
        	if v.id==5 then
        		v.order = 0;
        		break;
        	end
        	
        end
    else
    	for k,v in pairs(self.configMainGames) do
        	if v.id==5 then
        		v.order = 5;
        		break;
        	end
        	
        end
    end 
    self:addgamebtnnodes()

end
function LobbyScene:addgamebtnnodes()
	local px,py = self.nodePosition:getPosition()
	local thisnum = #self.configMainGames
	table.sort(self.configMainGames,function(a,b)
		if a.order<b.order then
			return true;
		else
			return false;
		end
		end)
	if thisnum>4 then
		self.fuzuMainView:setContentSize(CCSizeMake(250*thisnum,310))
		self.minGameScroll:setContentSize(CCSizeMake(250*thisnum,310)) 
	end
	self.fuzuMainView:removeAllChildrenWithCleanup(true)
    if (device.platform~="windows") then
        if thisnum>4 then
            self.minGameScroll:setPaged(true);
            self.minGameScroll.isPaged = true;
            self.minGameScroll:setContentSize(CCSizeMake(250*thisnum,310)) 
        else
            self.minGameScroll:setPaged(false);
            self.minGameScroll.isPaged = false;
            self.minGameScroll:setContentSize(CCSizeMake(1000,310)) 
        end
    end

        -- self.fuzuView:setBounceable(false);
    if (thisnum<4) then
        px = px+((4-thisnum)*250)/2
    
    end  
    for k=1,#self.configMainGames do
        -- v = izx.miniGameManager.miniGameCfg[id]
        local v = self.configMainGames[k];
        local thisNode = CCNode:create();
        self.fuzuMainView:addChild(thisNode)
        local thisButton = cc.ui.UIPushButton.new({
            normal = "images/MainGames/lobby_main_"..v.id ..".png",
            pressed = "images/MainGames/lobby_main_"..v.id ..".png",
            disabled = "images/MainGames/lobby_main_"..v.id ..".png"
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
                self:onPressStartMainGame(v.id);
                return true;
            end
        end

        thisButton:setTouchEnabled(true);
        thisButton:addTouchEventListener(clickSprite);

        -- v.gameName = "摇摇乐乐"
        -- local label = CCLabelTTF:create(v.gameName, "Helvetica", 20.0);
        if gBaseLogic.MBPluginManager.distributions.hasnewminegame and v.id==4 then
            print("111")
            local newsprit = display.newSprite("images/DaTing/lobby_pic_new.png", 16, 164)
            newsprit:setAnchorPoint(ccp(0,0))
            thisNode:addChild(newsprit)
        end           
        thisNode:setPosition(px+250*(k-1), py)
        thisNode:setAnchorPoint(ccp(0.5,0.5))
    end

end
function LobbyScene:removetableValuesById(id)
	for i=1,#self.configMainGames do
		local v=self.configMainGames[i];
		if v.id==id then
			table.remove(self.configMainGames,i)
			break;
		end
	end

end
function LobbyScene:fixMainMenuWithDistributionAndOnlineParam()
    if (MAIN_GAME_ID ==13) then
        if(gBaseLogic.MBPluginManager.distributions.nosafe)then
            self.baoxianxiang:setVisible(false)
            if self.btnChongZhiJiangLi ~= nil then
                self.btnChongZhiJiangLi:setPosition(self.baoxianxiang:getPosition())
            end   
        end
        if(gBaseLogic.MBPluginManager.distributions.nojihuoma)then
            self.jihuoma:setVisible(false)
            if self.baoxianxiang:isVisible() then
                self.btnChongZhiJiangLi:setPosition(self.baoxianxiang:getPosition())
                self.baoxianxiang:setPosition(self.jihuoma:getPosition())
            else
                self.btnChongZhiJiangLi:setPosition(self.jihuoma:getPosition())
            end   
        end
        if(gBaseLogic.MBPluginManager.distributions.noexitgame)then
            self.btnExit:setVisible(false) 
        end
        if(gBaseLogic.MBPluginManager.distributions.nopromotion)then
            self.btnPromotion:setVisible(false) 
        end
    end
end

-- function LobbyScene:fixNoMinigamePosition()
--     print("fixNoMinigamePosition")
--     if (MAIN_GAME_ID ==10) then
--         self.noMinigamePositionFix = 120;

--         local toX = self.btnHappy:getPositionX();
--         local haX = self.btnLazi:getPositionX();
--         --local laX = self.btnYule:getPositionX();    
--         local xxx = self.btnDanJi:getPositionX();    
--         self.btnHappy:setPositionX(toX+self.noMinigamePositionFix);
--         self.btnLazi:setPositionX(haX+self.noMinigamePositionFix);
--         --self.btnYule:setPositionX(laX+self.noMinigamePositionFix);
--         self.btnDanJi:setPositionX(xxx+self.noMinigamePositionFix);
--         self.btnYule:setVisible(false)

--     elseif (MAIN_GAME_ID ==13) then
--         self.btnYule:setVisible(false);
--     end

-- end


--[[
function LobbyScene:onPressBtnMove()
    print "onPressBtnMove"
    izx.baseAudio:playSound("audio_menu");

    local size = self.btn_layer1 :getContentSize();
    local fDuration = 0.5
    if  self.butMoveState == 0  then
        print("button move to left:"..size.width)
        self.butMoveState = 1

        self.btn_move:setEnabled(false)
        self:SliderMoveAction(self.btn_layer1, 0-size.width,nil,fDuration)
        self:SliderMoveAction(self.btn_layer2, 0,nil,fDuration)
    elseif self.butMoveState == 1 then
        print("button move to right:"..size.width)
        self.butMoveState = 0

        self.btn_move:setEnabled(false)
        self:SliderMoveAction(self.btn_layer1, 0,nil,fDuration)
        self:SliderMoveAction(self.btn_layer2, size.width,nil,fDuration)
    end     
    
    --self.btn_move:runAction(CCFlipX:actionWithFlipX(true)) 
    self.btn_move:runAction(transition.sequence({CCRotateBy:create(0,180),CCDelayTime:create(fDuration),CCCallFuncN:create(function( )
            self.btn_move:setEnabled(true)
        end)}));

    -- local action1 = CCRotateBy:create(fDuration/2,90);
    -- local action2 = CCRotateBy:create(fDuration/2,90);
    -- local action3 = CCScaleTo:create(fDuration/2,1.1)
    -- local action4 = CCScaleTo:create(fDuration/2,1)
    -- self.btn_move:runAction(transition.sequence({CCSpawn:createWithTwoActions(action1, action3), CCSpawn:createWithTwoActions(action2, action4),CCCallFuncN:create(function( )
    --        self.btn_move:setEnabled(true)
    --     end)}));
end
--]]

function LobbyScene:onPressMenuBtn(tag)
    print("onPressMenuBtn"..tag)
    if gBaseLogic.lobbyLogic.userHasLogined == false then 
        --izxMessageBox("暂未登录!", "提示");
        self:noLoginTips()
        return true;
    end 

    if tag == 1 then 
        self:onPressDengLu()
    elseif tag == 2 then 
        self:onPressGoldExchange()
    elseif tag == 3 then
        print("gBaseLogic.MBPluginManager:showPingCoo")

        -- gBaseLogic.MBPluginManager:jumpToExtend(7)

        gBaseLogic.MBPluginManager:showPingCoo(1)
    elseif tag == 4 then
        self:onPressShop()
    elseif tag == 5 then
        self:onPressSafe()
    elseif tag == 6 then
        self:onPressTuiGuang()
        --self:onPressBiSaiChang()
    elseif tag == 7 then
        self:onPressActivationCode()
    elseif tag == 8 then
        self:onPressHelp()
    elseif tag == 9 then
        self:onPressFreeCoin()
    elseif tag == 10 then
        -- gBaseLogic.MBPluginManager.distributions.jumpToExtend
         print("gBaseLogic.MBPluginManager:jumpToExtend")
        local tag = 7
        gBaseLogic.MBPluginManager:jumpToExtend(tag)
    end
end

function LobbyScene:initMenuButtonWithSlide()
    local menuBtn = {1,2,3,9,4,5,6,8,10}
    --local menuBtn = {qiandao=1,yuanbao=2,shiwujiangli=3,mianfeijinbei=9,shangdian=4,baoxian=5,tuiguangyuan=6,jihuo=7,bangzhu=8}
    --在线参数判断大厅 激活码/推广/保险箱是否显示 0为显示 1为隐藏 

    if gBaseLogic.MBPluginManager.distributions.checkapple then 
        removeTableValue(menuBtn, 1)
        removeTableValue(menuBtn, 2)
    end
    echoInfo("gBaseLogic.MBPluginManager.distributions.showPingCoo");
    var_dump(gBaseLogic.MBPluginManager.distributions.showPingCoo)
    if gBaseLogic.MBPluginManager.distributions.showPingCoo==nil or gBaseLogic.MBPluginManager.distributions.showPingCoo==false then
         removeTableValue(menuBtn, 3)

    end
    if gBaseLogic.MBPluginManager.distributions.nosafe then
        removeTableValue(menuBtn, 5)
    end
    if gBaseLogic.MBPluginManager.distributions.nojihuoma then
        removeTableValue(menuBtn, 7)
    end
    if gBaseLogic.MBPluginManager.distributions.nopromotion then
        removeTableValue(menuBtn, 6)
    end
     if gBaseLogic.MBPluginManager.distributions.nopromotion then
        removeTableValue(menuBtn, 6)
    end
    if gBaseLogic.MBPluginManager.distributions.jumpToExtend==nil or gBaseLogic.MBPluginManager.distributions.jumpToExtend==false then
         removeTableValue(menuBtn, 10)

    end
    -- gBaseLogic.MBPluginManager.distributions.
    -- print("gBaseLogic.MBPluginManager.distributions.jumpToExtend")
    
    --table.remove(menuBtn,5) -- for test

    local rect = CCRect(0, 0, 720, 105) 
    local node = display.newClippingRegionNode(rect)
    self.rootNode:addChild(node)
    node:setAnchorPoint(ccp(0,1))
    node:setPosition(288,display.height)
    node:setContentSize(CCSize(720,105))
    local btnlayer = display.newNode()
    local btnDistance = 124
    for i, v in ipairs(menuBtn) do 
        --print(i,v) -- for test
        local thisButton = cc.ui.UIPushButton.new({
                normal = "images/DaTing/lobby_btn_"..v ..".png",
                pressed = "images/DaTing/lobby_btn_2"..v ..".png",
                disabled = "images/DaTing/lobby_btn_"..v ..".png",
            }, {scale9 = false})
            :onButtonClicked(function(event)  
                    if (event.x < (display.width-102)) and (event.x > 288) then           
                        self:onPressMenuBtn(v)
                    end
                end)
            :addTo(btnlayer);
        thisButton:setAnchorPoint(ccp(0.5,0.5));
        thisButton:setPosition(54+(i-1)*btnDistance,54)
    end 
    local dis = (#menuBtn-6)*125;
    if dis<=0 then
        dis = 0
    end
    local btnmove = cc.ui.UIPushButton.new({
                normal = "images/DaTing/lobby_pic_fanye11.png",
                pressed = "images/DaTing/lobby_pic_fanye12.png",
                disabled = "images/DaTing/lobby_pic_fanye11.png",
            }, {scale9 = false})
            :onButtonClicked(function(event)                    
                self:onPressBtnMove(dis)
                end)
            :addTo(self.rootNode);
    btnmove:setPosition(display.width-57,display.height-54)

    node:addChild(btnlayer)
    self.btn_layer = btnlayer
    self.btn_move = btnmove

end

function LobbyScene:initMenuButton()
    if (MAIN_GAME_ID ==10) then
        self:initMenuButtonWithSlide();
    else
        self:fixMainMenuWithDistributionAndOnlineParam();
    end 
end

function LobbyScene:noNetTips()
local msg = "网络不太给力啊，尝试下单机版本或重新登录吧！"
    gBaseLogic:confirmBox({
        msg=msg,
        closeWhenClick = true,
        clickMaskToClose = true,
        btnTitle={btnConfirm="重试",btnCancel="单机"},
        callbackConfirm = function()
            echoInfo("noNetTips show Login layer!!!");
            -- if (self.initParam.isFirstRun) then
            --     local toCheckLogin = 1;
            --     self.logic:requestHTTGongGao(toCheckLogin);
            -- else 
            --     gBaseLogic:checkLogin(); 
            -- end
            gBaseLogic.lobbyLogic:showLoginTypeLayer()
        end,
        callbackCancel = function()
            echoInfo("noNetTips Into Robot game!!!");
            gBaseLogic.is_robot = 1
            gBaseLogic.lobbyLogic:startRobotGame() 
           
        end})
end 

function LobbyScene:noLoginTips()
local msg = "使用该功能需要登录，你现在登录吗？"
    gBaseLogic:confirmBox({
        msg=msg,
        closeWhenClick = true,
        clickMaskToClose = true,
        btnTitle={btnConfirm="登录",btnCancel="暂时不"},
        callbackConfirm = function()
            echoInfo("noLoginTips show Login layer!!!");
            -- if (self.initParam.isFirstRun) then
            --     local toCheckLogin = 1;
            --     self.logic:requestHTTGongGao(toCheckLogin);
            -- else 
            --     gBaseLogic:checkLogin(); 
            -- end
            gBaseLogic.lobbyLogic:showLoginTypeLayer()
        end,
        callbackCancel = function()
            echoInfo("noNetTips close!!!");

        end})
end

function LobbyScene:onPressBtnMove(dis)
    print "onPressBtnMove"
    izx.baseAudio:playSound("audio_menu");

    local size = self.btn_layer:getContentSize();
    local fDuration = 0.5
    local moveDistance = dis
    if  self.butMoveState == 0  then
        print("button move to left:"..size.width)
        self.butMoveState = 1
        self.btn_move:setScaleX(-1)
        --self.btn_move:setEnabled(false)
        self:SliderMoveAction(self.btn_layer, 0-moveDistance,nil,fDuration)
    elseif self.butMoveState == 1 then
        print("button move to right:"..size.width)
        self.butMoveState = 0
        self.btn_move:setScaleX(1)
        --self.btn_move:setEnabled(false)
        self:SliderMoveAction(self.btn_layer, 0,nil,fDuration)

    end     
    --self.btn_move:runAction(CCFlipX:actionWithFlipX(true)) 
    --self.btn_move:runAction(transition.sequence({CCRotateBy:create(0,180),CCDelayTime:create(fDuration),CCCallFuncN:create(function( )
            --self.btn_move:setEnabled(true)
    --    end)}));

    -- local action1 = CCRotateBy:create(fDuration/2,90);
    -- local action2 = CCRotateBy:create(fDuration/2,90);
    -- local action3 = CCScaleTo:create(fDuration/2,1.1)
    -- local action4 = CCScaleTo:create(fDuration/2,1)
    -- self.btn_move:runAction(transition.sequence({CCSpawn:createWithTwoActions(action1, action3), CCSpawn:createWithTwoActions(action2, action4),CCCallFuncN:create(function( )
    --        self.btn_move:setEnabled(true)
    --     end)}));
end
function LobbyScene:onPressBiSaiChang()
    print("onPressBiSaiChang")
    izx.baseAudio:playSound("audio_menu");
    if self.logic.isOnGameExit==1 then
		gBaseLogic:unblockUI();
		self.logic:gobackGameforonExitConfirm();	
    else
    	gBaseLogic.lobbyLogic:showBiSaiChang();
    end
    --gBaseLogic.lobbyLogic:showBiSaiWinScene()
    --gBaseLogic.lobbyLogic:showBiSaiFailScene({nJifen = -1})
end 
function LobbyScene:onPressStartMainGame(id)
	-- if #self.configMainGames>4 then
	-- 	if id == self.configMainGames[5].id then
	-- 		return true
	-- 	end
	-- end
	if id==1 then
		self:onPressHappyField()
	elseif id==2 then
		self:onPressLaiziField()
	elseif id==3 then
		self:onPressBiSaiChang()
	elseif id==4 then
		self:onPressAmusement()
	elseif id==5 then
		self:onPressDanJi()
	end

end

function LobbyScene:onPressFreeCoin()
    print("onPressFreeCoin")
    izx.baseAudio:playSound("audio_menu");
    gBaseLogic.lobbyLogic:showFreeCoinLayer();
end 

function LobbyScene:onPressTuiGuang()
    print "onPressTuiGuang"
    --gBaseLogic.audio:PlayAudio(14);
    izx.baseAudio:playSound("audio_menu");
    gBaseLogic.lobbyLogic:showPromotionScene({type=1});
end

function LobbyScene:onPressSafe()
    print "onPressSafe"
    izx.baseAudio:playSound("audio_menu");
    -- self.logic:reqDoublechestData()
    gBaseLogic.lobbyLogic:showSafeScene();
end

function LobbyScene:onPressShop()
    print "onPressShop"
    izx.baseAudio:playSound("audio_menu");
    --gBaseLogic.lobbyLogic:quickPay(10000);
    gBaseLogic.lobbyLogic:showShopScene();
end 

function LobbyScene:onPressGoldExchange()
    print "onPressGoldExchange"
    izx.baseAudio:playSound("audio_menu");
    -- if (true) then
    --     izxMessageBox("正在开发中，请稍候！", "即将推出");
    --     return;
    -- end
    --gBaseLogic.lobbyLogic:showGoldExchangeScene();
    gBaseLogic.lobbyLogic:showAwardExchangeScene()
end 

function LobbyScene:onPressActivationCode()
    print "onPressActivationCode"
    izx.baseAudio:playSound("audio_menu");
    --gBaseLogic.lobbyLogic:showActivationCodeScene();
    gBaseLogic.lobbyLogic:showAwardExchangeScene()
end

--function LobbyScene:onPressPokerKing()
function LobbyScene:onPressDengLu()
    print("onPressDengLu")
    izx.baseAudio:playSound("audio_menu");
    -- createScreenShotElement(self.spriteVipLevel,'xxx.png','png');
    -- gBaseLogic.lobbyLogic:showMeiRiBiZuoLayer();
    --self.logic:showDengLuPopLayer()
    self.logic:showQianDaoLayer(1)
    -- if (true) then
    -- --    izxMessageBox("正在开发中，请稍候！", "即将推出");
    --     return;
    -- end
    -- gBaseLogic.lobbyLogic:showPokerKingScene();
end 

function LobbyScene:onPressChongZhiJiangLi()
    print("LobbyScene:onPressChongZhiJiangLi")
    izx.baseAudio:playSound("audio_menu");
    -- self.logic.getPayNum = 0;
    if self.logic.getPayNum == 0 then
        izxMessageBox("没有任务可领取", "暂无任务");
    else
        self.logic:showChongZhiJiangLiLayer()
    end
end

function LobbyScene:onPressHelp()
    print "onPressHelp"
    izx.baseAudio:playSound("audio_menu");
    gBaseLogic.lobbyLogic:showHelpScene();
    --gBaseLogic.lobbyLogic:showPromotionScene()
end

function LobbyScene:onPressShowNotice()
    print "onPressNotice"
    if gBaseLogic.lobbyLogic.userHasLogined == false then 
        --izxMessageBox("暂未登录!", "提示");
        self:noLoginTips()
        return true;
    end 
    izx.baseAudio:playSound("audio_menu");
    if nil ~= self.huodong then 
        self.huodong:removeFromParentAndCleanup(true);
    end
    gBaseLogic.lobbyLogic:showNoticeScene();
end

function LobbyScene:onPressTask()
    print "onPressTask"
    if gBaseLogic.lobbyLogic.userHasLogined == false then 
        --izxMessageBox("暂未登录!", "提示");
        self:noLoginTips()
        return true;
    end 
    izx.baseAudio:playSound("audio_menu");
    gBaseLogic.lobbyLogic:showTaskScene();
end 

function LobbyScene:onPressRecharge()
    if gBaseLogic.lobbyLogic.userHasLogined == false then 
        --izxMessageBox("暂未登录!", "提示");
        self:noLoginTips()
        return true;
    end 
    izx.baseAudio:playSound("audio_menu");
    gBaseLogic.lobbyLogic:showShopScene();
end

function LobbyScene:onPressPersonalInformation()
    print("onPressPersonalInformation")
    if gBaseLogic.lobbyLogic.userHasLogined == false then 
        --izxMessageBox("暂未登录!", "提示");
        self:noLoginTips()
        return true;
    end 
    izx.baseAudio:playSound("audio_menu");
    gBaseLogic.lobbyLogic:showPersonalInformationScene({tabNum=1});
end

function LobbyScene:onPressMail()
    print("onPressMail")
    if gBaseLogic.lobbyLogic.userHasLogined == false then 
        --izxMessageBox("暂未登录!", "提示");
        self:noLoginTips()
        return true;
    end 
    izx.baseAudio:playSound("audio_menu");
    gBaseLogic.lobbyLogic:showPersonalInformationScene({tabNum=3});
end

function LobbyScene:onPressDanJi()
    print("onPressDnJi")
    izx.baseAudio:playSound("audio_menu");
    echoInfo("Into Robot game!!!");
    gBaseLogic.is_robot = 1
    gBaseLogic.lobbyLogic:startRobotGame() 
end

function LobbyScene:onPressQuickBegin()
    print "onPressQuickBegin"
    izx.baseAudio:playSound("audio_menu");
    if gBaseLogic.lobbyLogic.userHasLogined == false then 
        echoInfo("Into Robot game!!!");
        gBaseLogic.is_robot = 1
        gBaseLogic.lobbyLogic:startRobotGame() 
    else
    -- gBaseLogic.gameLogic:showGameScene();
    -- gBaseLogic.gameLogic:startGameSever();
    -- game_type -1 快速开始，0：普通场 1:癞子场 2：娱乐场，3：比赛场
        self.logic:startGame("moduleDdz",-1)
    -- gBaseLogic.gameLogic:startSocket(gBaseLogic.socketConfig.ddzSocketConfig);
    end
end

function LobbyScene:sortMainButton()
    print("sortMainButton") 
    var_dump(gBaseLogic.lobbyLogic.userHasLogined)
    if gBaseLogic.MBPluginManager.distributions.onlyDisDanji then
        local px,py = self.nodePosition:getPosition()
        if gBaseLogic.lobbyLogic.userHasLogined then 
            self.btnHappy:setVisible(true)
            self.btnLazi:setVisible(true)
            if gBaseLogic.MBPluginManager.distributions.nominigame then
                self.btnHappy:setPositionX(px+126)
                self.btnLazi:setPositionX(px+126+252)
                self.btnDanJi:setPositionX(px+126+252*2)
            else                              
                self.btnHappy:setPositionX(px)
                self.btnLazi:setPositionX(px+252*1)
                self.btnYule:setPositionX(px+252*2)
                self.btnDanJi:setPositionX(px+252*3)  
            end 
               
        else
            

            if gBaseLogic.MBPluginManager.distributions.nominigame then
                self.btnDanJi:setPositionX(px+252+126)
                -- self.btnLazi:setPositionX(self.btnHappy:getPositionX())
                -- self.btnHappy:setPositionX(tmpX)  
                self.btnHappy:setVisible(false)
                self.btnLazi:setVisible(false)
            else
                self.btnDanJi:setPositionX(px+252-10)
                self.btnYule:setPositionX(px+252*2+20)
                -- self.btnHappy:setPositionX(tmpX)  
                self.btnHappy:setVisible(false)
                self.btnLazi:setVisible(false)
            end 
        end
        return;
    end
    if (gBaseLogic.MBPluginManager.distributions.nominigame==true) then 
        if gBaseLogic.lobbyLogic.userHasLogined == true then 
            if self.btnHappy:getPositionX() > self.btnDanJi:getPositionX() then
                local tmpX = self.btnDanJi:getPositionX()
                self.btnDanJi:setPositionX(self.btnLazi:getPositionX())
                self.btnLazi:setPositionX(self.btnHappy:getPositionX())
                self.btnHappy:setPositionX(tmpX)  
            end    
        end
        return
    end

    if gBaseLogic.lobbyLogic.userHasLogined == false then 
        if self.btnDanJi:getPositionX() > self.btnYule:getPositionX() then
            print("btnDanJi first") 
            local tmpX = self.btnDanJi:getPositionX()
            self.btnDanJi:setPositionX(self.btnHappy:getPositionX())
            self.btnHappy:setPositionX(self.btnLazi:getPositionX())
            self.btnLazi:setPositionX(self.btnYule:getPositionX())
            self.btnYule:setPositionX(tmpX)
        end
    else 
        if self.btnYule:getPositionX() > self.btnDanJi:getPositionX() then
            print("btnHappy first") 
            local tmpX = self.btnDanJi:getPositionX()
            self.btnDanJi:setPositionX(self.btnYule:getPositionX())
            self.btnYule:setPositionX(self.btnLazi:getPositionX())
            self.btnLazi:setPositionX(self.btnHappy:getPositionX())
            self.btnHappy:setPositionX(tmpX)  
        end    
    end
end

function LobbyScene:gameListScrollViewScroll()
    local curPage = self.minGameScroll:getCurPage();
    echoInfo("Now gameListScrollViewScroll page is %d / %d", curPage,self.totalPage );
    self:updateCurPageDot(curPage);
end

function LobbyScene:removePageDot()
    if (self.pageDotNode) then
        self.pageDotNode:removeFromParentAndCleanup(true);
        self.pageDotNode = nil;
        self.totalPage = nil;

    end
end

function LobbyScene:initPageDot(curPage)
    if (device.platform == "windows") then
        return;
    end
    self.totalPage = self.minGameScroll:getTotalPage();
    echoInfo("initPageDot %d / %d", curPage,self.totalPage );
    if (self.pageDotNode ~= nil) then
        self:removePageDot();
    end
    if(self.totalPage > 1) then
        self.pageDotNode = display.newNode():addTo(self.rootNode);
        self.pageDotNode:setPosition(display.cx,130);

        local dotDistance = 32;
        self.pageDotNode:removeAllChildrenWithCleanup(true)
    
        local px = dotDistance/2 - dotDistance/2*self.totalPage
        for i = 1,self.totalPage do
            local dotImg
            if(i == curPage) then
                dotImg = display.newSprite("images/DaTing/lobby_pic_fanye1.png")
            else
                dotImg = display.newSprite("images/DaTing/lobby_pic_fanye2.png")
            end
            dotImg:setPosition(ccp(px + dotDistance*(i -1),0))
            self.pageDotNode:addChild(dotImg)
        end
    end
end

function LobbyScene:updateCurPageDot(curPage)
    if (self.pageDotNode == nil) then
        return;
    end
    if(self.totalPage >= curPage) then
        for i = 1,self.totalPage do
            local dotSprite = tolua.cast(self.pageDotNode:getChildren():objectAtIndex(i-1), "CCSprite")
            if(i == curPage) then
                dotSprite:setTexture(getCCTextureByName("images/DaTing/lobby_pic_fanye1.png"))
            else
                dotSprite:setTexture(getCCTextureByName("images/DaTing/lobby_pic_fanye2.png"))
            end
        end
    end

end

function LobbyScene:showGameLists(type,flagF)
    if gBaseLogic.lobbyLogic.userHasLogined == false then 
        --izxMessageBox("暂未登录!", "提示");
        self:noLoginTips()
        return true;
    end 
    if gBaseLogic.inGamelist~=-1 and flagF==nil then
        return
    end 
    self.btnQuick:setVisible(false)
    self.beginAnimation:setVisible(false)
    gBaseLogic:logEventLabelDuration("gameTime","login",0)
    gBaseLogic.inGamelist = type;
    local toX,toY = self.nodePosition:getPosition();
    -- local haX = self.btnLazi:getPositionX();
    -- local laX = self.btnYule:getPositionX();    
    --local yuX = self.btnYule:getPositionX();
    -- if (gBaseLogic.MBPluginManager.distributions.nominigame==true) then
    --     toX = toX - self.noMinigamePositionFix;
    --     haX = haX - self.noMinigamePositionFix;
    --     laX = laX - self.noMinigamePositionFix;
    -- end
    local subX = 252
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
function LobbyScene:onPressGameBack()
    self:removePageDot();
    gBaseLogic.inGamelist = -1;
    self.btnQuick:setVisible(true)
    self.beginAnimation:setVisible(true)
    local actions = {};
    actions[#actions + 1] = CCEaseExponentialOut:create(CCMoveTo:create(0.4, ccp(self.mainX, self.mainY)));
    -- actions[#actions + 1] = CCCallFunc:create(handler(currentPop.view,currentPop.view.onAddToScene));
    self.gameNode:runAction(transition.sequence(actions));

end
function LobbyScene:onPressStartMiniGame(gameId)
    self.logic:startMiniGame(gameId)
    
    
end

function LobbyScene:onPressHappyField()
    print "onPressHappyField"
    -- self.logic:showGameList(0);
    -- self.logic:startGame("moduleDdz",0)
    self:showGameLists(0);
end 
function LobbyScene:onPressLaiziField()
    print "onPressLaiziField" 
    -- self.logic:startGame("moduleDdz",1)
    self:showGameLists(1);
end 
function LobbyScene:onPressAmusement()
    print "onPressAmusement"--小游戏
    self:showGameLists(2);
    
end 

function LobbyScene:onRemovePage()
end 

function LobbyScene:onInitView() 
    print("LobbyScene:onInitView")

    -- self.minGameScroll:setTouchEnabled(true)
    -- self.minGameScroll:registerScriptTouchHandler(function(event, x, y)
    --     print("self.minGameScroll:addTouchEventListener:"..event,x,y,event)
    --     if event=="began" then
    --         self.logic.gametomove = 0;
    --     end
    --     if event=="moved" then
    --         self.logic.gametomove = 1;
    --     end
       
    --     return true
    --     end); 
    if device.platform == "windows" then
    else
        self.minGameScroll:setPaged(true);
        self.minGameScroll:registerScriptHandler(handler(self,self.gameListScrollViewScroll),CCScrollView.kScrollViewScroll)
    end
    
    self.SpriteVipProgress:setAnchorPoint(ccp(0,0.5));
    self.SpriteVipProgress:setTextureRect(CCRectMake(0,0,0,16))
    self.SpriteVipProgress:setPositionX(176)

    self:initBaseInfo()
    self:showGonggao()

end

function LobbyScene:onTouch(event, x, y)    
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

function LobbyScene:showGonggao()
    self.labelGonggao:setString("进入欢乐场、癞子场完成牌桌任务，可获得元宝！")
    self.spriteGonggao:setTouchEnabled(true)
    self.spriteGonggao:addTouchEventListener(function(event, x, y, prevX, prevY)
       
    if event == "began" then
        if (self.spriteContent:isVisible()) then
            self.spriteContent:setVisible(false)
        else            
            self.spriteContent:setVisible(true)
            self.spriteContent:setPreferredSize(CCSizeMake(763, 410))
            -- print (2222);
            self:createTableView(self.spriteContent)
            local tableView = self.tabViewLayer:init(self.logic.guangBaoList);
            
            self.tabViewLayer:registerScriptTouchHandler(function(event, x, y)
                                                    return self:onTouch(event, x, y)
                                                end, false,0,true)
    
            self.tabViewLayer:setTouchEnabled(true)
            self.tabViewLayer:addChild(tableView) 
            tableView:reloadData()
            

        end

        print("self.nodeGonggao:addTouchEventListener")
    end
    end)
end 


function LobbyScene:showQuickStartAni()
    print("LobbyScene:showQuickStartAni")
    if self.beginAnimation ~= nil then
        local ani = getAnimation("beginAnimation");
        local frame =  tolua.cast(ani:getFrames():objectAtIndex(0),"CCAnimationFrame"):getSpriteFrame()
        local m_playAni = CCSprite:createWithSpriteFrame(frame);
        local action = CCRepeatForever:create(transition.sequence({CCAnimate:create(ani),CCDelayTime:create(2)}));
        m_playAni:runAction(action)--CCDelayTime:create(10)
        -- self.beginAnimation:setScale(1.4);
        self.beginAnimation:addChild(m_playAni);
    end
end

function LobbyScene:formatUserMoney(num) 
    --num = 99683---99683,9968309196，0，-1，-11111000 --测试数据 
    local userMoney = toMonetary(num) 
    local wanBiaoshi = numberChange(num)
    if #userMoney + #wanBiaoshi + 2 > 13 then 
        self.labelMoneyNumber:setString(userMoney.."\n".."("..wanBiaoshi..")")
    else
        if math.abs(num)>10000 then
            self.labelMoneyNumber:setString(userMoney.."("..wanBiaoshi..")") 
        else
            self.labelMoneyNumber:setString(userMoney) 
        end
    end
end 

function LobbyScene:showVipProgress()
    -- {level_:3,nex_level_total_days_:15,auto_upgrade_day_:10,login_award_:5000,friend_count_:10,next_level_due_days_:50,remaining_sum_:10,status_:0}; 
    if gBaseLogic.MBPluginManager.distributions.novip then 
        return
    end 

    if gBaseLogic.lobbyLogic.userHasLogined then
        local vipInfo = self.ctrller.data.ply_vip_
        print("self.showVipProgress.level_:"..vipInfo.level_)
        --var_dump(vipInfo)
        local vipLevel = self.logic.vipData.vipLevel;
        local vipRate = self.logic.vipData.vipRate
        if vipLevel>=1 then
            self.SpriteVipProgress:setVisible(true)
            self.labelvipprogress:setVisible(true)
            self.spriteVipLevel:setVisible(true)
            self.spriteProgress:setVisible(true)
            self:showVipIcon(self.spriteVipLevel, vipLevel, 1)
            print(self.spriteVipLevel)
            var_dump(self.weiKaitong)
            if self.weiKaitong~=nil then
                print("self.weiKaitong")
                self.weiKaitong:setVisible(false);
                self.weiKaitong:removeFromParentAndCleanup(true)
                -- self.weiKaitong=nil
            end
            --百分比
            -- local rateVip = 0;
            -- if ( vipInfo.nex_level_total_days_ ~=0 ) then
            --     rateVip  = math.floor((vipInfo.nex_level_total_days_-vipInfo.next_level_due_days_) / vipInfo.nex_level_total_days_ *100)
            -- else
            --     rateVip  = 100
            -- end
            local maxVipSize = {width=148,height=16};
            self.SpriteVipProgress:setTextureRect(CCRectMake(0,0,maxVipSize.width*vipRate/100,maxVipSize.height))
            self.labelvipprogress:setString(vipRate .. "%")
        else
            self.spriteProgress:setVisible(false)
            self.SpriteVipProgress:setVisible(false)
            self.labelvipprogress:setVisible(false)
            self.spriteVipLevel:setVisible(false)
            local px,py = self.spriteVipLevel:getPosition();
            self.weiKaitong = display.newSprite("images/DaTing/lobby_pic_weikaitong.png", px+20, py)
            self.rootNode:addChild(self.weiKaitong)
        end 
        -- if vipInfo.level_>=1 then
        --     self.SpriteVipProgress:setVisible(true)
        --     self.labelvipprogress:setVisible(true)
        --     self.spriteVipLevel:setVisible(true)
        --     self.spriteProgress:setVisible(true)
        --     self:showVipIcon(self.spriteVipLevel, vipInfo.level_, vipInfo.status_)
        --     print(self.spriteVipLevel)
        --     var_dump(self.weiKaitong)
        --     if self.weiKaitong~=nil then
        --         print("self.weiKaitong")
        --         self.weiKaitong:setVisible(false);
        --         self.weiKaitong:removeFromParentAndCleanup(true)
        --         -- self.weiKaitong=nil
        --     end
        --     --百分比
        --     local rateVip = 0;
        --     if ( vipInfo.nex_level_total_days_ ~=0 ) then
        --         rateVip  = math.floor((vipInfo.nex_level_total_days_-vipInfo.next_level_due_days_) / vipInfo.nex_level_total_days_ *100)
        --     else
        --         rateVip  = 100
        --     end
        --     local maxVipSize = {width=148,height=16};
        --     self.SpriteVipProgress:setTextureRect(CCRectMake(0,0,maxVipSize.width*rateVip/100,maxVipSize.height))
        --     self.labelvipprogress:setString(rateVip .. "%")
        -- else
        --     self.spriteProgress:setVisible(false)
        --     self.SpriteVipProgress:setVisible(false)
        --     self.labelvipprogress:setVisible(false)
        --     self.spriteVipLevel:setVisible(false)
        --     local px,py = self.spriteVipLevel:getPosition();
        --     self.weiKaitong = display.newSprite("images/DaTing/lobby_pic_weikaitong.png", px+20, py)
        --     self.rootNode:addChild(self.weiKaitong)
        -- end
    end

end 

function LobbyScene:showHeadImage()
    local tFiles = gBaseLogic.lobbyLogic.face
    print("showHeadImage:"..tFiles)

    if isLocalFile(tFiles) == false then
        izx.resourceManager:imgFileDown(gBaseLogic.lobbyLogic.face,true,function(fileName) 
            if self~=nil and self.spriteDefaultHead~=nil then
                self.spriteDefaultHead:setTexture(getCCTextureByName(fileName))
            end
    end);
    else 
         self.spriteDefaultHead:setTexture(getCCTextureByName(tFiles))
    end
end 

function LobbyScene:initBaseInfo()
    print("LobbyScene:initBaseInfo")
   

    self.ctrller:reSetData()
     
    self.labelNickName:setString(izx.UTF8.sub(self.ctrller.data.userName,1,7))
    --self.labelMoneyNumber:setString(self.ctrller.data.userMoney)
    self:formatUserMoney(self.ctrller.data.userMoney)
    -- self:changeChongzhijiangliButton()
    self:showHeadImage()
    self:showVipProgress()

    self:showQuickStartAni()
    -- self:sortMainButton()
    self:initMainGames()
    --初始化是否有新邮件
    self:showNewMsg();
    self.btnQuick:setVisible(true)
    self.beginAnimation:setVisible(true)
    



end
function LobbyScene:showNewMsg()
    if self.logic.hasNewMsg==1 then
        self.spriteLetterNumber:setVisible(true)
        self.labelNew:setVisible(true)
    else
        self.spriteLetterNumber:setVisible(false)
        self.labelNew:setVisible(false)
    end
end

function LobbyScene:showHuoDongHight()
    if (gBaseLogic.MBPluginManager.distributions.noactivity) then
        return;
    end
    local ani = getAnimation("ani_huodong","donghua");
    if nil == ani then return end 

    local frame =  tolua.cast(ani:getFrames():objectAtIndex(0),"CCAnimationFrame"):getSpriteFrame()
    local sprite = CCSprite:createWithSpriteFrame(frame)
    local x,y = self.btn_huodong:getPosition()
    sprite:setPosition(ccp(x-40,y+10))
    self.rootNode:addChild(sprite)
    sprite:runAction(CCRepeatForever:create(CCAnimate:create(ani)))
    self.huodong = sprite   
end

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
    local num = #table:getParent().data
    local label = CCLabelTTF:create(table:getParent().data[num - idx], "Helvetica", 20.0)
    label:setAnchorPoint(ccp(0,0))
    label:setPositionX(20)
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

function LobbyScene:createTableView(spriteContent)    
    -- TableViewLayer.create(spriteContent)
    self.tabViewLayer = TableViewLayer.create(spriteContent)
end

function LobbyScene:changeChongzhijiangliButton()
    -- self.logic.getPayNum = 100
    -- print("LobbyScene:changeChongzhijiangliButton")
    -- if self.logic.getPayNum ~= 10 then
    --     -- setBackgroundSpriteForState
    --     -- self.view.btnChongZhiJiangLi 
    --     local file0  = "images/DaTing/lobby_btn_chongzhijiangli1.png"
    --     local file1  = "images/DaTing/lobby_btn_chongzhijiangli2.png"
    --     if self.logic.getPayNum == 50 then
    --         file0  = "images/DaTing/lobby_btn_chongzhijiangli3.png"
    --         file1  = "images/DaTing/lobby_btn_chongzhijiangli4.png"
    --     else
    --         file0  = "images/DaTing/lobby_btn_chongzhijiangli5.png"
    --         file1  = "images/DaTing/lobby_btn_chongzhijiangli6.png"
    --     end
    --     local buttonimg0 = CCScale9Sprite:create(file0)
    --     local buttonimg1 = CCScale9Sprite:create(file1)
    --     local buttonimg2 = CCScale9Sprite:create(file1)
    --     -- pBackgroundHighlightedButton, CCControlStateHighlighted
    --     -- print("self.btnChongZhiJiangLi:setBackgroundSpriteForState")
    --     self.btnChongZhiJiangLi:setBackgroundSpriteForState(buttonimg0,1)
    --     self.btnChongZhiJiangLi:setBackgroundSpriteForState(buttonimg1,2)
    --     self.btnChongZhiJiangLi:setBackgroundSpriteForState(buttonimg2,3)
    -- end
end

return LobbyScene;
