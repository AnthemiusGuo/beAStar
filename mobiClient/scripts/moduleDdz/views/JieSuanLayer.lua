local JieSuanLayer = class("JieSuanLayer",izx.baseView)

function JieSuanLayer:ctor(pageName,moduleName,initParam)
	print ("JieSuanLayer:ctor")
    self.super.ctor(self,pageName,moduleName,initParam);
end

function JieSuanLayer:onAddToScene()
    self.rootNode:setPosition(display.cx,display.cy);
end


function JieSuanLayer:onAssignVars()
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
    if nil ~= self["labelmoney"] then
        self.labelmoney = tolua.cast(self["labelmoney"],"CCLabelTTF")
    end
    if nil ~= self["labelprice"] then
        self.labelprice = tolua.cast(self["labelprice"],"CCLabelTTF")
    end
    if nil ~= self["labelname1"] then
        self.labelname1 = tolua.cast(self["labelname1"],"CCLabelTTF")
    end
    if nil ~= self["labelname2"] then
        self.labelname2 = tolua.cast(self["labelname2"],"CCLabelTTF")
    end
    if nil ~= self["labelname3"] then
        self.labelname3 = tolua.cast(self["labelname3"],"CCLabelTTF")
    end
    if nil ~= self["labelnum1"] then
        self.labelnum1 = tolua.cast(self["labelnum1"],"CCLabelTTF")
    end
    if nil ~= self["labelnum2"] then
        self.labelnum2 = tolua.cast(self["labelnum2"],"CCLabelTTF")
    end
    if nil ~= self["labelnum3"] then
        self.labelnum3 = tolua.cast(self["labelnum3"],"CCLabelTTF")
    end
    if nil ~= self["labelmoney"] then
        self.labelmoney = tolua.cast(self["labelmoney"],"CCLabelTTF")
    end
    if nil ~= self["labelprice"] then
        self.labelprice = tolua.cast(self["labelprice"],"CCLabelTTF")
    end
    if nil ~= self["spritdizhuicon"] then
        self.spritdizhuicon = tolua.cast(self["spritdizhuicon"],"CCSprite")
    end
     if nil ~= self["nodedizhu"] then
        print ("nodedizhu")
        self.sprite1 = tolua.cast(self["nodedizhu"],"CCNode")
    end
    if nil ~= self["nodenongming"] then
        print ("nodenongming")
        self.sprite2 = tolua.cast(self["nodenongming"],"CCNode")
    end
    if nil ~= self["layer_jiesuan_task"] then
        self.layer_jiesuan_task = tolua.cast(self["layer_jiesuan_task"],"CCNode")
    end
    if nil ~= self["btnchang"] then
        print("btnchange===")
        self.btnchang = tolua.cast(self["btnchang"],"CCControlButton")
    end
   
    
end
--onPressExit is gotogaojiChang
function JieSuanLayer:onPressExit()
    print("onPressExit");
    self.logic:gotogaojiChang();
        
    
end

function JieSuanLayer:onPressBack()
    -- gBaseLogic.MBPluginManager:logEventEnd("JieSuanLayer")
    -- self:onPressContinue();
    print("JieSuanLayer:onPressBack")
end

function JieSuanLayer:onPressContinue()
    print "onPressContinue"
    izx.baseAudio:playSound("audio_menu");
    gBaseLogic.sceneManager:removePopUp("JieSuanLayer");
    
    self.logic.result = {};
    self.logic.result = {bType=1,cDouble=0,cCallScore=0,bShowCard=1,nBombCount=0,bSpring=0,bReverseSpring=0,bRobLord=2,cLord=1,nGameMoney=0,getGift=0,getMoney=0,task_status_=0,vecUserResult={{nChairID=0,name='...',nScore=12},{nChairID=1,name='...',nScore=4},{nChairID=2,name='...',nScore=3}}}
    
    self.logic.is_chang_table = 1;
    
    if gBaseLogic.is_robot ~= 0 then
        --gBaseLogic.sceneManager.currentPage.ctrller:reInit()
        --gBaseLogic.sceneManager.currentPage.ctrller.robotai:setGameStateAndData(EVENT_ID["cb_change_table_req"],0)
        gBaseLogic.sceneManager.currentPage.ctrller:checkRobotMonery()

    else 
        if self.logic.gameSocket~=nil and self.logic.gameSocket.isConnect == 1 then
            --self.logic:changeTable();
            gBaseLogic.sceneManager.currentPage.ctrller:reInit()
        else
            self.logic:LeaveGameScene(-1)
        end
        
    end
    self.ctrller = nil;    
end

function JieSuanLayer:onPressClose()
    print "onPressClose"
    izx.baseAudio:playSound("audio_menu");
    if gBaseLogic.is_robot ~= 0 then
        --self.logic:send_pt_cb_leave_table_req();
        --gBaseLogic.currentScene.ctrller.robotai:setGameStateAndData(EVENT_ID["pt_cb_ready_req"],0)
        gBaseLogic.sceneManager:removePopUp("JieSuanLayer");
        gBaseLogic.sceneManager.currentPage.view:onPressExit()
    else  
       
        if self.logic.playInTable==0 and self.logic.gameSocket~=nil and self.logic.gameSocket.isConnect == 1 then
            self.logic:send_pt_cb_leave_table_req()
        else
            self.logic:LeaveGameScene(-1)
        end
    end
end

 

function JieSuanLayer:onInitView()
	self:initBaseInfo();
end


function JieSuanLayer:initBaseInfo()
    if gBaseLogic.is_robot ~= 0 then
        self.btnchang:setVisible(false)
    end
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
   
    local result = self.logic.result;
    if result.bShowCard == 0 then result.bShowCard = 1 else result.bShowCard = 2 end
    if result.bReverseSpring == 0 then result.bReverseSpring = 1 else result.bReverseSpring = 2 end
    if result.bSpring == 0 then result.bSpring = 1 else result.bSpring = 2 end
    if result.nBombCount == 0 then result.nBombCount = 1 end

    self.labelzhu1:setString("x"..result.bRobLord );
    self.labelzhu2:setString("x"..result.bShowCard);
    self.labelzhu3:setString("x"..result.bReverseSpring );
    self.labelzhu4:setString("x"..result.bSpring);
    self.labelzhu5:setString("x"..result.nBombCount);
    self.labelzhu6:setString("x"..result.cCallScore);
    self.labelzhuall:setString("x"..result.cDouble);
    self.labelname1:setString(izx.UTF8.sub(result.vecUserResult[1].name))
    self.labelname2:setString(izx.UTF8.sub(result.vecUserResult[2].name))
    self.labelname3:setString(izx.UTF8.sub(result.vecUserResult[3].name))
    self.labelnum1:setString(result.vecUserResult[1].nScore)
    self.labelnum2:setString(result.vecUserResult[2].nScore)
    self.labelnum3:setString(result.vecUserResult[3].nScore)
    -- var_dump(result.vecUserResult)
    self.labeldizhu:setString(result.nGameMoney)
    
    self:showDoubleAction(result.cDouble)

    -- int         gift_;
    -- int64       money_;
    if result.cLord >=0 and result.cLord<=2 then
        local spritdizhuicon_y = 47 - result.cLord * 34 
        self.spritdizhuicon:setPosition(CCPoint(-5,spritdizhuicon_y))
    end
    -- result.bType = 1;
    if (result.bType==1) then --地主赢
        print("popup_pic_dizhu")
        -- var_dump(self.spriteheadleft);
        -- var_dump(getCCTextureByName());
        -- CCTextureCache:sharedTextureCache():addImage("Images/fire.png")
        self.nodedizhu:setVisible(true)
        self.nodenongming:setVisible(false);
        -- self.sprite1:setTexture(getCCTextureByName("images/TanChu/popup_pic_dizhu.png"))
        -- self.sprite2:setTexture(getCCTextureByName("images/TanChu/popup_pic_dizhusheng.png"))
    else
        print("popup_pic_nongmin")
        self.nodedizhu:setVisible(false)
        self.nodenongming:setVisible(true);
    end
    if gBaseLogic.is_robot ~= 0 then
        self.layer_jiesuan_task:setVisible(false)
    else
        if self.logic.curSocketConfigList.level>=3 then
            -- local label = display.newLabelTT
            print("=====去拉霸机")
            local tempString = CCString:create("去拉霸机")
            self.btnchang:setTitleForState(tempString,CCControlStateNormal);


            -- local label = CCLabelTTF:create("去拉霸机", "", 26)
            -- self.btnchang:setTitleLabelForState(label,6)
        end
        self.labelmoney:setString(result.getMoney)
        print("initBaseInfo"..result.getGift)
        self.labelprice:setString(result.getGift)
        if (result.task_status_==1) then
            self.labeltask:setString("已完成")
        end
    end
   
    
end

return JieSuanLayer;
