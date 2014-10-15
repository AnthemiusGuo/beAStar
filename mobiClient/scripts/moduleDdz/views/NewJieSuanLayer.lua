local NewJieSuanLayer = class("NewJieSuanLayer",izx.baseView)

function NewJieSuanLayer:ctor(pageName,moduleName,initParam)
    print ("NewJieSuanLayer:ctor")
    self.super.ctor(self,pageName,moduleName,initParam);
    self.nJifen = 0
end

function NewJieSuanLayer:onAddToScene()
    self.rootNode:setPosition(display.cx,display.cy);
end


function NewJieSuanLayer:onAssignVars()
    self.rootNode = tolua.cast(self.rootNode,"CCNode");
 --    if nil ~= self["layerBackground"] then
 --        self.layerBackground = tolua.cast(self["layerBackground"],"CCLabelTTF")
 --    end
    -- if nil ~= self["chatBack"] then
 --        self.chatBack = tolua.cast(self["chatBack"],"CCLabelTTF")
 --    end
    -- var_dump(self,4);
    if nil ~= self["labelzhu1"] then
        -- print("labelzhu1")
        self.labelzhu1 = tolua.cast(self["labelzhu1"],"CCLabelTTF")
    end
    if nil ~= self["labelzhu2"] then
        -- print("labelzhu2")
        self.labelzhu2 = tolua.cast(self["labelzhu2"],"CCLabelTTF")
    end
    if nil ~= self["labelzhu3"] then
        self.labelzhu3 = tolua.cast(self["labelzhu3"],"CCLabelTTF")
    end
    if nil ~= self["labelzhu4"] then
        self.labelzhu4 = tolua.cast(self["labelzhu4"],"CCLabelTTF")
    end
    if nil ~= self["labelzhu5"] then
        self.labelzhu5 = tolua.cast(self["labelzhu5"],"CCLabelTTF")
    end
    if nil ~= self["labelzhu6"] then
        self.labelzhu6 = tolua.cast(self["labelzhu6"],"CCLabelTTF")
    end
    if nil ~= self["labelzhuall"] then
        self.labelzhuall = tolua.cast(self["labelzhuall"],"CCLabelTTF")
    end
    -- CCLabelTTF
    if nil ~= self["labeldizhu"] then
        self.labeldizhu = tolua.cast(self["labeldizhu"],"CCLabelTTF")
    end
    if nil ~= self["labeltask"] then
        print ("labeltask==============")
        self.labeltask = tolua.cast(self["labeltask"],"CCLabelTTF")
    end
    if nil ~= self["labelmoney0"] then
        self.labelmoney0 = tolua.cast(self["labelmoney0"],"CCLabelTTF")
    end
    if nil ~= self["labelmoney1"] then
        self.labelmoney1 = tolua.cast(self["labelmoney1"],"CCLabelTTF")
    end
    if nil ~= self["labelmoney2"] then
        self.labelmoney2 = tolua.cast(self["labelmoney2"],"CCLabelTTF")
    end
    if nil ~= self["labelprice"] then
        self.labelprice = tolua.cast(self["labelprice"],"CCLabelTTF")
    end
    --
    if nil ~= self["labelname1"] then
        self.labelname1 = tolua.cast(self["labelname1"],"CCLabelTTF")
    end
    if nil ~= self["labelname2"] then
        self.labelname2 = tolua.cast(self["labelname2"],"CCLabelTTF")
    end
    -- if nil ~= self["labelname3"] then
    --     self.labelname3 = tolua.cast(self["labelname3"],"CCLabelTTF")
    -- end
   
    -- if nil ~= self["labelnum31"] then
    --     self.labelnum3 = tolua.cast(self["labelnum3"],"CCLabelTTF")
    -- end
    -- if nil ~= self["labelnum32"] then
    --     self.labelnum3 = tolua.cast(self["labelnum3"],"CCLabelTTF")
    -- end
  
    if nil ~= self["labelprice"] then
        self.labelprice = tolua.cast(self["labelprice"],"CCLabelTTF")
    end
    if nil ~= self["lableTotalMoney"] then
        self.lableTotalMoney = tolua.cast(self["lableTotalMoney"],"CCLabelTTF")
    end
    -- if nil ~= self["spritdizhuicon"] then
    --     self.spritdizhuicon = tolua.cast(self["spritdizhuicon"],"CCSprite")
    -- end
    if nil ~= self["sprite1"] then
        self.spritdizhuicon = tolua.cast(self["sprite1"],"CCSprite")
    end
    if nil ~= self["sprite2"] then
        self.spritdizhuicon = tolua.cast(self["sprite2"],"CCSprite")
    end
    if nil ~= self["spritePlayer0"] then
        self.spritdizhuicon = tolua.cast(self["spritePlayer0"],"CCSprite")
    end
    if nil ~= self["spritePlayer1"] then
        self.spritdizhuicon = tolua.cast(self["spritePlayer1"],"CCSprite")
    end
    if nil ~= self["spritePlayer2"] then
        self.spritdizhuicon = tolua.cast(self["spritePlayer2"],"CCSprite")
    end
    if nil ~= self["spritePlayerDi0"] then
        self.spritdizhuicon = tolua.cast(self["spritePlayerDi0"],"CCSprite")
    end
    if nil ~= self["spritePlayerDi1"] then
        self.spritdizhuicon = tolua.cast(self["spritePlayerDi1"],"CCSprite")
    end
    if nil ~= self["spritePlayerDi2"] then
        self.spritdizhuicon = tolua.cast(self["spritePlayerDi2"],"CCSprite")
    end
     if nil ~= self["nodedizhu"] then
        print ("nodedizhu")
        self.sprite1 = tolua.cast(self["nodedizhu"],"CCNode")
    end
    if nil ~= self["nodenongming"] then
        print ("nodenongming")
        self.sprite2 = tolua.cast(self["nodenongming"],"CCNode")
    end
    -- if nil ~= self["layer_jiesuan_task"] then
    --     self.layer_jiesuan_task = tolua.cast(self["layer_jiesuan_task"],"CCNode")
    -- end
    if nil ~= self["btnchang"] then
        print("btnchange===")
        self.btnchang = tolua.cast(self["btnchang"],"CCControlButton")
    end
    if nil ~= self["spriteDiBan"] then
        print("btnchange===")
        self.spriteDiBan = tolua.cast(self["spriteDiBan"],"CCSprite")
    end
   
    
end
--onPressExit is gotogaojiChang
function NewJieSuanLayer:onPressExit()
    print("onPressExit");
    self.logic:gotogaojiChang();
        
    
end

function NewJieSuanLayer:onPressBack()
    print("JieSuanLayer:onPressBack")
end

function NewJieSuanLayer:onPressContinue()
    print "onPressContinue"
    izx.baseAudio:playSound("audio_menu");
    if gBaseLogic.is_robot == 0 then 
        if gBaseLogic.lobbyLogic.userData.ply_lobby_data_.money_ < self.logic.curSocketConfigList.min_money_ then
            -- self.logic.moneyNotEnough=1
            gBaseLogic:onNeedMoney("gameenter", self.logic.curSocketConfigList.min_money_, 2)
            return;
        end 
    end
    gBaseLogic.sceneManager.currentPage.view:closePopBox();
    gBaseLogic.sceneManager:removePopUp("NewJieSuanLayer");
    
    self.logic.result = {};
    self.logic.result = {bType=1,cDouble=0,cCallScore=0,bShowCard=1,nBombCount=0,bSpring=0,bReverseSpring=0,bRobLord=2,cLord=1,nGameMoney=0,getGift=0,getMoney=0,task_status_=0,vecUserResult={{nChairID=0,name='...',nScore=12},{nChairID=1,name='...',nScore=4},{nChairID=2,name='...',nScore=3}}}
    
    self.logic.is_chang_table = 1;
    
    if gBaseLogic.is_robot ~= 0 then
        --gBaseLogic.sceneManager.currentPage.ctrller:reInit()
        --gBaseLogic.sceneManager.currentPage.ctrller.robotai:setGameStateAndData(EVENT_ID["cb_change_table_req"],0)

        gBaseLogic.sceneManager.currentPage.ctrller:checkRobotMonery()
        gBaseLogic.sceneManager.currentPage.view:showReadyChange()

    else 
        if gBaseLogic.gameLogic.isMatch == 1 then 
            --self.logic:LeaveGameScene(-1)
            if self.schedulerMatch ~= nil then 
                scheduler.unscheduleGlobal(self.schedulerMatch)
            end
            gBaseLogic.lobbyLogic:showBiSaiFailScene({nJifen = self.nJifen,match_id_=self.logic.curMatchID,match_order_id_ = self.logic.curMatchOrderID})
        else
            if self.logic.gameSocket~=nil and self.logic.gameSocket.isConnect == 1 then
                --self.logic:changeTable();
                
                self.logic:sendTableReady()

                -- gBaseLogic.sceneManager.currentPage.ctrller:reInit()
            else
                self.logic:LeaveGameScene(-1)
            end 
        end
    end
    self.ctrller = nil;    
end

function NewJieSuanLayer:onPressClose()
    print "onPressClose"
    izx.baseAudio:playSound("audio_menu");
    if gBaseLogic.is_robot ~= 0 then
        --self.logic:send_pt_cb_leave_table_req();
        --gBaseLogic.currentScene.ctrller.robotai:setGameStateAndData(EVENT_ID["pt_cb_ready_req"],0)
        gBaseLogic.sceneManager:removePopUp("NewJieSuanLayer");
        --gBaseLogic.sceneManager.currentPage.view:onPressExit()
        gBaseLogic.sceneManager.currentPage.ctrller:checkRobotMonery()
        gBaseLogic.sceneManager.currentPage.view:showReadyChange()
    else  
       
        -- if self.logic.playInTable==0 and self.logic.gameSocket~=nil and self.logic.gameSocket.isConnect == 1 then
        --     self.logic:send_pt_cb_leave_table_req()
        -- else
        gBaseLogic.sceneManager:removePopUp("NewJieSuanLayer");
        print("gBaseLogic.gameLogic.isMatch",gBaseLogic.gameLogic.isMatch)
        if gBaseLogic.gameLogic.isMatch == 1 then
            --self.logic:LeaveGameScene(-1)
            if self.schedulerMatch ~= nil then 
                scheduler.unscheduleGlobal(self.schedulerMatch)
            end
            gBaseLogic.lobbyLogic:showBiSaiFailScene({nJifen = self.nJifen,match_id_=self.logic.curMatchID,match_order_id_ = self.logic.curMatchOrderID})
        else
            gBaseLogic.sceneManager.currentPage.view:showReadyChange() 
        end
        -- if self.logic~=nil and self.logic.LeaveGameScene~=nil then

        --     self.logic:LeaveGameScene(-1)
        -- end
    end
end

 function NewJieSuanLayer:onPressChongZhi()
        print "onPressChongZhi" 
    gBaseLogic.lobbyLogic:quickPay(0,3);--smsQuickPayCharge,//  游戏时玩家主动充值
    local puid = gBaseLogic.lobbyLogic.userData.ply_guid_;
    CCUserDefault:sharedUserDefault():setStringForKey("payday"..puid,os.date("%x", os.time()))
    CCUserDefault:sharedUserDefault():setIntegerForKey("paydayNeedMoney"..puid,0)
 end

function NewJieSuanLayer:onInitView()
    self:initBaseInfo();
    if gBaseLogic.gameLogic.isMatch == 1 then 
        self.btnchang:setVisible(false)
        self.btnChongZhi:setVisible(false)
        self.btnContinue:setVisible(false)

    end
    if gBaseLogic.is_robot ~= 0 then
        self.btnchang:setVisible(false)
    end
end

function NewJieSuanLayer:initBaseInfo()

    -- if self.logic.diBaoMsg~="" then
    --     local msg = "游戏币不够，无法继续！请充值。"
    --     local initParam = {msg=msg,type=2,needMoney=self.logic.curSocketConfigList.min_money_,subtyp=5};
    --     gBaseLogic.lobbyLogic:showYouXiTanChu(initParam) 
    -- end
    -- if self.logic.moneyNotEnough == 1 then
    --      gBaseLogic.scheduler.performWithDelayGlobal(function()
    --         self.ctrller:notEnoughMoney()
    --         end, 5)
        
    -- end
    --for test
   --self.logic.result = {bType=1,cDouble=128,cCallScore=0,bShowCard=1,nBombCount=0,bSpring=0,bReverseSpring=0,bRobLord=2,cLord=1,nGameMoney=0,getGift=0,getMoney=0,task_status_=0,vecUserResult={{nChairID=0,name='...',nScore=12},{nChairID=1,name='...',nScore=4},{nChairID=2,name='...',nScore=3}}}
    local result = self.logic.result;
    print("NewJieSuanLayer:initBaseInfo")
    var_dump(result,4)
    if result.bShowCard == 0 then result.bShowCard = 1 else result.bShowCard = 2 end
    if result.bReverseSpring == 0 then result.bReverseSpring = 1 else result.bReverseSpring = 2 end
    if result.bSpring == 0 then result.bSpring = 1 else result.bSpring = 2 end
    if result.nBombCount == 0 then result.nBombCount = 1 end
    self.labelzhuall:setString("x"..result.cDouble);
 
    self.labeldizhu:setString(result.nGameMoney)
    self.labelprice:setString(result.getGift)
    local playerIsDizhu = result.vecUserResult[1].is_lord;
    -- 
    if (result.bType==0) then
        self.sprite2:setTexture(getCCTextureByName("images/TanChu/popup_pic_nongminsheng.png"))
    end
    local userWin = 2;
    if (result.bType==1 and playerIsDizhu==1) or (result.bType==2 and playerIsDizhu==0) then
        self.sprite1:setTexture(getCCTextureByName("images/TanChu/popup_pic_shengli.png"))
        userWin = 1;
        if gBaseLogic.lobbyLogic.userData.ply_lobby_data_~=nil and gBaseLogic.lobbyLogic.userData.ply_lobby_data_.won_~=nil then
             gBaseLogic.lobbyLogic.userData.ply_lobby_data_.won_=gBaseLogic.lobbyLogic.userData.ply_lobby_data_.won_+1
        end
       
    else
        self.labelDiZhu:setColor(ccc3(137,194,238))
        self.labelDouble:setColor(ccc3(137,194,238))
        self.labelGift0:setColor(ccc3(137,194,238))
        self.labelGift1:setColor(ccc3(137,194,238))
        self.labelGift2:setColor(ccc3(137,194,238))
        self.labelCoin0:setColor(ccc3(137,194,238))
        self.labelCoin1:setColor(ccc3(137,194,238))
        self.labelCoin2:setColor(ccc3(137,194,238))
        self.lableTotalCoin:setColor(ccc3(137,194,238))
        self.spriteDiBan:setTexture(getCCTextureByName("images/TanChu/popup_bg_jiesuan2.png"))
        self.sprite1:setTexture(getCCTextureByName("images/TanChu/popup_pic_shibai.png"))
        userWin = 2;
         if gBaseLogic.lobbyLogic.userData.ply_lobby_data_~=nil and gBaseLogic.lobbyLogic.userData.ply_lobby_data_.lost_~=nil then
             gBaseLogic.lobbyLogic.userData.ply_lobby_data_.lost_=gBaseLogic.lobbyLogic.userData.ply_lobby_data_.lost_+1
        end
        
    end
    for i=1,3 do
        local info = result.vecUserResult[i]
        if i~=1 then
            self["labelname"..(i-1)]:setString(izx.UTF8.sub(info.name))
        end
        self["labelmoney"..(i-1)]:setString(info.nScore)
        -- is_lord=is_lord,headimage=pPlayer.headimage_
        if info.is_lord == 1 then
            local imagfile = "images/TanChu/popup_pic_dizhu"..userWin..".png"
            if info.sex_~=nil and info.sex_==0 then
                imagfile = "images/TanChu/popup_pic_dizhu"..userWin.."1.png"
            end

            self["spritePlayerDi"..(i-1)]:setTexture(getCCTextureByName(imagfile))
        else
            local imagfile = "images/TanChu/popup_pic_nongmin"..userWin..".png"
            if info.sex_~=nil and info.sex_==0 then
                imagfile = "images/TanChu/popup_pic_nongmin"..userWin.."1.png"
            end
            self["spritePlayerDi"..(i-1)]:setTexture(getCCTextureByName(imagfile))
        end 
        if gBaseLogic.is_robot == 0 then 
            izx.resourceManager:imgFileDown(info.headimage,true,function(fileName) 
                if self~=nil and self["spritePlayer"..(i-1)]~=nil then
                    self["spritePlayer"..(i-1)]:setTexture(getCCTextureByName(fileName))
                end
            end); 
        else 
            if self~=nil and self["spritePlayer"..(i-1)]~=nil then
                    self["spritePlayer"..(i-1)]:setTexture(getCCTextureByName(info.headimage))
                end
        end
        
    end
 
    if gBaseLogic.is_robot == 0 then        
        if self.logic.curSocketConfigList.level>=3 then
            print("=====去拉霸机")
            if gBaseLogic.MBPluginManager.distributions.nominigame then
                self.btnchang:setVisible(false)
            else
                local tempString = CCString:create("去拉霸机")
                self.btnchang:setTitleForState(tempString,CCControlStateNormal);
            end
            
        end
        if gBaseLogic.lobbyLogic.userData.ply_lobby_data_~=nil then
            var_dump(gBaseLogic.lobbyLogic.userData.ply_lobby_data_)
            if gBaseLogic.gameLogic.isMatch == 1 then 
                self.nJifen = result.vecUserResult[1].nScore + result.vecUserResult[1].nJifen
                self.lableTotalMoney:setString(self.nJifen)
                
            else
            self.lableTotalMoney:setString(gBaseLogic.lobbyLogic.userData.ply_lobby_data_.money_)
            end
        end
        if (result.task_status_==1) then
            --finish table task
            -- self.labeltask:setString("已完成")
        end
    else 
        local robotMonery = CCUserDefault:sharedUserDefault():getIntegerForKey("p_money_4",0)
        self.lableTotalMoney:setString(tostring(robotMonery))
        --self.lableTotalMoney:setString(gBaseLogic.lobbyLogic.userData.ply_lobby_data_.money_) 
    end
   
    print("gBaseLogic.gameLogic.isMatch",gBaseLogic.gameLogic.isMatch)
    if gBaseLogic.gameLogic.isMatch == 1 then 
        self.lableTotalCoin:setString("总积分：")
        self.labelCoin0:setString("积分：")
        self.labelCoin1:setString("积分：")
        self.labelCoin2:setString("积分：")
        local nJifen = self.nJifen 
        self.schedulerMatch = scheduler.performWithDelayGlobal(function()
            
            print("NewJieSuanLayer colse")
            self.ctrller.data.hadColse = true
            gBaseLogic.sceneManager.currentPage.view:closePopBox();
            gBaseLogic.sceneManager:removePopUp("NewJieSuanLayer");

            --self.logic:LeaveGameScene(-1)
            gBaseLogic.lobbyLogic:showBiSaiFailScene({nJifen = nJifen,match_id_=self.logic.curMatchID,match_order_id_ = self.logic.curMatchOrderID})
        end,3.0)
    else 
        self:showDoubleAction(result.cDouble)
    end 
end


function NewJieSuanLayer:showDoubleAction(nDouble)
    print("NewJieSuanLayer:showDoubleAction:"..nDouble)
    self.beiNode = display.newNode();
    self.beiNode:setPosition(0, display.bottom+800);
    self.rootNode:addChild(self.beiNode);

    local str = tostring(nDouble)
    local len = #str 
    local j = 1

    for i=1,len do 
        local beiNumber = CCLabelAtlas:create(string.sub(str,i,i), "images/TanChu/popup_pic_beishu.png", 45, 64, 48)
        beiNumber:setPosition(ccp(i*45,0));
        self.beiNode:addChild(beiNumber);
        j = i
    end 

    local bgBei = display.newSprite("images/TanChu/popup_pic_bei.png", j*45+45, 0);
    bgBei:setAnchorPoint(ccp(0,0));
    self.beiNode:addChild(bgBei);

    self:SliderMoveAction(self.beiNode,0, display.bottom+200, 1.0)
end

return NewJieSuanLayer;
