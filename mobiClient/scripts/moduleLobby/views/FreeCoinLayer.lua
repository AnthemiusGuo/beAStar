local FreeCoinLayer = class("FreeCoinLayer",izx.baseView)

function FreeCoinLayer:ctor(pageName,moduleName,initParam)
	print ("FreeCoinLayer:ctor")
    self.super.ctor(self,pageName,moduleName,initParam);
    self.scheduler = nil
end


function FreeCoinLayer:onAssignVars()
    self.MyNode = display.newNode();
    --self.MyNode:setAnchorPoint(ccp(0.5,0.5));
    self.MyNode:setPosition(0,0);
    self.rootNode:addChild(self.MyNode);

    self.bgPanel = display.newScale9Sprite("images/TanChu/popup_bg5.png", 0, 0,CCSizeMake(860, 536));
    --self.bgPanel:setAnchorPoint(ccp(0.5,0.5));
    self.MyNode:addChild(self.bgPanel);

    self.sceensize = self.bgPanel:getContentSize()

    self.closeBtn = cc.ui.UIPushButton.new({
                normal = "images/TanChu/popup_btn_guanbi11.png",
                pressed = "images/TanChu/popup_btn_guanbi12.png",
                disabled = "images/TanChu/popup_btn_guanbi11.png",
            }, {scale9 = false})
            :onButtonClicked(function(event)  
                        self:onPressBtn(self.closeBtn)
                    end)
            :addTo(self.MyNode)
    self.closeBtn:setTag(100)
    self.closeBtn:setPosition(self.sceensize.width/2-15, self.sceensize.height/2-15)        

    self.title =  display.newSprite("images/TanChu/popup_pic_mianfeijinbi.png", 0, 0);
    self.title:setPosition(0, self.sceensize.height/2-40);
    self.MyNode:addChild(self.title);

    self.cloundL =  display.newSprite("images/TanChu/popup_bg_yun.png", 0, 0);
    self.cloundL:setPosition(-160, self.sceensize.height/2-40);
    self.cloundL:setScaleX(-1)
    self.MyNode:addChild(self.cloundL);

    self.cloundR =  display.newSprite("images/TanChu/popup_bg_yun.png", 0, 0);
    self.cloundR:setPosition(160, self.sceensize.height/2-40);
    self.MyNode:addChild(self.cloundR);
    
    self.coinTabView = display.newNode();
    self.coinTabView:setPosition(-self.sceensize.width/2, -self.sceensize.height/2+15);
    self.sceensize.height = self.sceensize.height-80
    self.coinTabView:setContentSize(self.sceensize)
    self.MyNode:addChild(self.coinTabView);
    

end

function FreeCoinLayer:unWaitingAni(target,opt)
    --echoInfo("THANKS TO unWaitingAni ME!!!");
    scheduler.unscheduleGlobal(self.scheduler)
    self.scheduler = nil
    gBaseLogic:unblockUI();

end

function FreeCoinLayer:loadingAni()
     gBaseLogic:blockUI();
     self.scheduler = scheduler.performWithDelayGlobal(handler(self, self.unWaitingAni), 5.0)
end

function FreeCoinLayer:onPressBtn(target)
    print "onPressBtn"
    izx.baseAudio:playSound("audio_menu");
    local tag = target:getTag()
    if tag == 1 then 
        self:loadingAni();
        gBaseLogic.lobbyLogic:sendReliefReq()
    elseif tag == 2 then 
        gBaseLogic.lobbyLogic:showQianDaoLayer(1)
    elseif tag == 3 then 
        gBaseLogic.lobbyLogic:startGame("moduleDdz",-1)
    elseif tag == 4 then
        gBaseLogic.lobbyLogic:showTaskScene()
    elseif tag == 5 then
        gBaseLogic.lobbyLogic:startMiniGame(105)
    elseif tag == 6 then
        print("developing ....")
    elseif tag == 101 then
        gBaseLogic.lobbyLogic:gotoVipShop()
    end

    if tag == 1 then 
        --target:setButtonLabel("normal", ui.newTTFLabel({text = "已领取",size = 24}))
        --target:setTitleForState(CCString:create("已领取"),CCControlStateNormal);
        --target:setButtonEnabled(false)
        --gBaseLogic.lobbyLogic.userData.ply_login_award2_.today_ = 0
    else 
        gBaseLogic.sceneManager:removePopUp("FreeCoinLayer")
    end  
end


function FreeCoinLayer:onInitView()
	self:initBaseInfo();
end

function FreeCoinLayer:initBaseInfo()
    print("initBaseInfo")
    self:initTableView(self.coinTabView, self.ctrller.data.state, self.ctrller.data.cont);
end 

function FreeCoinLayer:initTableView(target,type,data)
    local winSize = target:getContentSize()
    print(winSize.width ,winSize.height)
    createTabView(target,winSize,type,data, self);
end

function FreeCoinLayer.cellSizeForTable(table,idx)
    return 112,860
end

function FreeCoinLayer.numberOfCellsInTableView(table)
    return #table:getParent().data
end

    function onTouch_(target, event, x, y) 
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
            gBaseLogic.lobbyLogic.FreeCoinLayer.view:onPressBtn(target)
            --gBaseLogic.sceneManager.currentPage.view:onPressBtn(target)
            --target:removeTouchEventListener()
            --gBaseLogic.sceneManager:removePopUp("FreeCoinLayer");           
            return true;
        end

        return true;
    end
function FreeCoinLayer.tableCellAtIndex(table, idx)
    print(idx.."-tableCellAtIndex-")
    local cell = table:dequeueCell()
    if nil == cell then        
        cell = CCTableViewCell:new()
    else
        cell:removeAllChildrenWithCleanup(true);
    end 

    local hasmovex = 0
    local hasmovey = 0


    local data = table:getParent().data[idx+1]
    local fengeItem =  display.newSprite("images/TanChu/popup_pic_mianfeitiao.png", 0, 0);
    fengeItem:setScaleX(830)
    fengeItem:setAnchorPoint(ccp(0,0.5))
    fengeItem:setPosition(ccp(15,88))
    cell:addChild(fengeItem)
    local nameItem = CCLabelTTF:create(data[2], "Helvetica", 28.0)
    nameItem:setAnchorPoint(ccp(0,0.5))
    nameItem:setPosition(ccp(20,88))
    cell:addChild(nameItem)

    local btnItem = cc.ui.UIPushButton.new({
                normal = "images/TanChu/popup_btn_lan11.png",
                pressed = "images/TanChu/popup_btn_lan12.png",
                disabled = "images/TanChu/popup_btn_lan13.png",
            }, {scale9 = false})
            -- :onButtonClicked(function(event)  
            --     var_dump(event)
            --             self:onPressBtn(idx+1)
            --         end)
            :setButtonLabel(ui.newTTFLabel({
                text = data[4],
                size = 24,
                --color = ccc3(0,0,0)
                }))
            :addTo(cell)
    --btnItem:setAnchorPoint(ccp(0.5,0.5));
    btnItem:setPosition(750,32)
    btnItem:setTouchEnabled(true);
    btnItem:setTag(data[1])
    btnItem:addTouchEventListener(handler(btnItem, onTouch_))

    local contItem = CCLabelTTF:create(data[3], "Helvetica", 24.0)
    contItem:setAnchorPoint(ccp(0,0.5))
    contItem:setPosition(ccp(100,30))
    cell:addChild(contItem)

    if data[1] == 1 then 
        if gBaseLogic.lobbyLogic.relief_times_ > 0 then 
            if gBaseLogic.lobbyLogic.userData.ply_lobby_data_.money_ < 1000 then 
                btnItem:setButtonEnabled(true)
            else 
                btnItem:setButtonEnabled(false)
            end
        else 
            local btnTitle = "" 
            local vipLevel = gBaseLogic.lobbyLogic.vipData.vipLevel
            if gBaseLogic.MBPluginManager.distributions.novip then 
                vipLevel = 0
            end
            if vipLevel <= 0 then 

                btnTitle = "成为VIP2"
                contItem:setString("您今天的救助已领完，升级成VIP2可每天多领一次哦！")
                btnItem:setTag(idx+101)
            else 
                btnTitle = "已领取"
                btnItem:setButtonEnabled(false) 
            end 
            
            btnItem:setButtonLabel("normal", ui.newTTFLabel({
                        text = btnTitle,
                        size = 24
                    }))
        end 
        
        --[[
        if gBaseLogic.lobbyLogic.userData.ply_login_award2_.today_>0 then
            btnItem:setButtonEnabled(true)
        else
            btnItem:setButtonLabel("normal", ui.newTTFLabel({
                    text = "已领取",
                    size = 24
                }))
            --btnItem:setTitleForState(CCString:create("已领取"),CCControlStateNormal);
            btnItem:setButtonEnabled(false) 
        end 
        --]]
    end 
    if data[1] == 2 then 
        local strtime = CCUserDefault:sharedUserDefault():getStringForKey(gBaseLogic.ply_guid_.."QianDaoTime","")
        local curtime = os.date("%x", os.time())
        if curtime == strtime then 
            btnItem:setButtonLabel("normal", ui.newTTFLabel({
                        text = "去补签",
                        size = 24
                    }))
        end 
    end
    local iconItem = display.newSprite("images/TanChu/"..data[5], 0, 0);
    iconItem:setAnchorPoint(ccp(0,0.5))
    iconItem:setPosition(ccp(20,30))
    if data[1] == 5 then 
        iconItem:setScale(0.65)
    end  
    cell:addChild(iconItem)

    
    return cell
end

function FreeCoinLayer:onAddToScene()
    --self.rootNode:setPosition(CCPoint(display.cx,display.cy));
end

function FreeCoinLayer:onPressBack()
    gBaseLogic.sceneManager:removePopUp("FreeCoinLayer");
end

return FreeCoinLayer;
