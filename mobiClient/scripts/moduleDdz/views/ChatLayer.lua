local ChatLayer = class("ChatLayer",izx.baseView)

function ChatLayer:ctor(pageName,moduleName,initParam)
	print ("ChatLayer:ctor")
    self.super.ctor(self,pageName,moduleName,initParam);

end


function ChatLayer:onAssignVars()
	self.rootNode = tolua.cast(self.rootNode,"CCNode");

    if nil ~= self["chatTabView"] then
        self.chatTabView = tolua.cast(self["chatTabView"],"CCNode")
    end
    -- if nil ~= self["labelInput"] then
    --     self.labelInput = tolua.cast(self["labelInput"],"CCLayerTTF")
    -- end
    -- if nil ~= self["editInput"] then
    --     self.editInput = tolua.cast(self["editInput"],"CCNode")
    -- end 

    if nil ~= self["btnPhrase"] then
        self.btnPhrase = tolua.cast(self["btnPhrase"],"CCControl")
    end
    if nil ~= self["btnFace"] then
        self.btnFace = tolua.cast(self["btnFace"],"CCControl")
    end
    if nil ~= self["btnPay"] then
        self.btnPay = tolua.cast(self["btnPay"],"CCControl")
    end

    if (gBaseLogic.hasDownloadBiaoqing == false) then
        self.btnFace:setVisible(false);
        self.btnPay:setVisible(false);
    end
end

function ChatLayer:onPressPhrase()
    print "onPressPhrase"
    if self.chatType ~= 1 then
        self.chatType = 1
        --self.btnPhrase:setSelected(true)
        self.btnPhrase:setHighlighted(true)
        self.btnFace:setHighlighted(false)
        self.btnPay:setHighlighted(false)
        self:initPhraseInfo()
    end
end

function ChatLayer:onPressFace()
    print "onPressFace"
     if self.chatType ~= 2 then
        self.chatType = 2
        self.btnFace:setHighlighted(true)
        self.btnPay:setHighlighted(false)
        self.btnPhrase:setHighlighted(false)
        self:initFaceInfo()
    end
end

function ChatLayer:onPressPay()
    print "onPressPay"
     if self.chatType ~= 3 then
        self.chatType = 3
        self.btnPay:setHighlighted(true)
        self.btnFace:setHighlighted(false)
        self.btnPhrase:setHighlighted(false)
        self:initPayInfo()
    end
end

-- function ChatLayer:onPressInput()
--     print "onPressInput"
--     if self.chatType ~= 4 then
--         self.chatType = 4 
--         if self.ctrller.trumpetNum >= 0 then 
--             gBaseLogic.gameLogic:SendTrumpetReq(self.labelInput:getString()) 
--         else 
--             gBaseLogic.sceneManager.currentPage.view:ShowGameTip("您未购买礼包，无法使用，请到商品购买！") 
--         end
--         gBaseLogic.sceneManager:removePopUp("ChatLayer");  
--     end
-- end

function ChatLayer:onInitView()
    self.chatType = 0 -- 1:语句，2：表情，3付费
	self:initBaseInfo();
end

-- function ChatLayer:initTrumpetInfo()
--     local function editBoxTextEventHandle(strEventName,pSender)
--         local edit = tolua.cast(pSender,"CCEditBox")
       
--         self.labelInput:setString(edit:getText())
--         self.labelInput:setVisible(false)        
--     end 
--     --self.labelInput:setVisible(false)
--     --if nil == self.editInput then 
--         local bgsprite = CCScale9Sprite:create("images/LieBiao/list_bg_shurujihuo.png")
--         self.editInput = createEditBox(self.editInput, bgsprite, editBoxTextEventHandle,{strHolder = "请输入聊天信息...",maxLen=12})  
--         self.editInput:setEnabled(false);
--         if self.ctrller.trumpetNum >= 0 then 
--             self.editInput:setEnabled(true); 
--         else
--             gBaseLogic.sceneManager.currentPage.view:ShowGameTip("您未购买礼包，无法使用，请到商品购买！") 
--         end
--     --end
-- end 

--local TableViewLayer = require "izxFW.BaseTableView";
function ChatLayer:initBaseInfo()
    --常用短语
    print("initBaseInfo")
    --TableViewLayer.create(self.chatTabView,tolua.cast(self["chatTabView"],"CCNode"))
    --self:initTrumpetInfo()
    self:onPressPhrase() 
    --self.rootNode:addTouchEventListener(handler(self, self.onChatLayerTouch))
end 

-- function ChatLayer:onChatLayerTouch(event, x, y)
--     --常用短语 
--     local tab_x,tab_y = self.rootNode:getPosition();
--             print("tablexy",tab_x,tab_y,x,y)
--             if self.rootNode:boundingBox():containsPoint(CCPoint(x,y)) == false then 
--                 print("===========================================")
--                 return false 
--             end 
--     print("onChatLayerTouch=======================")
--     return true
-- end

function ChatLayer.cellSizeForTable(table,idx)
    if table:getParent().type == 1 then  
        return 49,458
    else 
        return 80,458
    end 
end
function ChatLayer.numberOfCellsInTableView(table)
    local data = table:getParent().data;
    if table:getParent().type==2 then 
        print(math.ceil(#data/5))
        return math.ceil(#data/5)
    elseif table:getParent().type==3 then 
        print(math.ceil(#data/5))
        return math.ceil(#data/5)
    else
        return #data
    end 
end
function ChatLayer.tableCellAtIndex(table, idx)
    print(idx.."-tableCellAtIndex-")
    local cell = table:dequeueCell()
    if nil == cell then        
        cell = CCTableViewCell:new()
    else
        print("-------remove cell")
        cell:removeAllChildrenWithCleanup(true);
    end 
--str ="<A┃┃"..i  表情 
--str = "<B┃┃"..i 语句
    local hasmovex = 0
    local hasmovey = 0
    local hasmove = 0
    local timeSendChat = 0 
    function onTouch_(target, event, x, y) 
        if (event=="began") then 
            print("=============================================")
            echoInfo(event..":Icon!");
            hasmovex = x
            hasmovey = y
            return true;
        end
        if (event=="ended") then
            echoInfo(event..":Icon!");
            if hasmove > 20 then 
                hasmove = 0 
                return true;
            end 

            if os.time() - timeSendChat < 3 then 
                return 
            end 
            timeSendChat = os.time()

            if table:getParent().type == 1 then 
                gBaseLogic.gameLogic:SendChatReq("<B┃┃"..target:getTag())
            elseif table:getParent().type == 2 then
                gBaseLogic.gameLogic:SendChatReq("<A┃┃"..target:getTag())
            else 
                if table:getParent().paycatnum <= 0 then 
                    gBaseLogic.lobbyLogic:showYouXiTanChu({msg="您未购买礼包，无法使用，请到商品购买！",type=2,needMoney=10000}) 
                    --gBaseLogic.sceneManager.currentPage.view:ShowGameTip("您未购买礼包，无法使用，请到商品购买！")    
                else
                    gBaseLogic.gameLogic.ChatLayer.ctrller:setPayCatNum(table:getParent().paycatnum - 1)
                    gBaseLogic.gameLogic:SendChatPayReq(target:getTag())
                end
            end
            if (gBaseLogic.MBPluginManager.frameworkVersion<14081501) then
                target:removeTouchEventListener()
            end
            
            gBaseLogic.sceneManager:removePopUp("ChatLayer");           
            return true;
        end
        hasmove = math.abs(y - hasmovey) + math.abs(x - hasmovex)

        echoInfo(event..":Icon!"); --moved
        return true;
    end

    if (table:getParent().type==2 ) then        
        local index_x = 60
        local parent = table:getParent()
        parent.idx = idx*5 + 1
        local num = #parent.data - parent.idx
        if num > 5 then 
            num = 5 
        end

        for i=1, num do       
            print("+++++++++++++++++++")  
            print( parent.data[parent.idx])
            local faceItem = CCSprite:create("images/BiaoQing/"..parent.data[parent.idx])
            faceItem:setTouchEnabled(true);
            faceItem:addTouchEventListener(handler(faceItem, onTouch_))
            faceItem:setTag(parent.idx)
            faceItem:setPosition(index_x,40)
            cell:addChild(faceItem)            

            index_x = index_x +85
            parent.idx = parent.idx + 1
        end

    elseif (table:getParent().type == 1 ) then
        local bgItem = CCSprite:create("images/TanChu/popup_bg_changyongyu.png")
        bgItem:setAnchorPoint(ccp(0,0))
        bgItem:setPosition(ccp(0, 0))
        bgItem:setTag(idx+1)
        bgItem:setTouchEnabled(true);
        bgItem:addTouchEventListener(handler(bgItem, onTouch_))
        cell:addChild(bgItem)  

        local phraseItem = CCLabelTTF:create(table:getParent().data[idx+1], "Helvetica", 25.0)
        phraseItem:setAnchorPoint(ccp(0,0))
        phraseItem:setPosition(ccp(0,10))
        phraseItem:setColor(ccc3(0,0,0))
        cell:addChild(phraseItem)
    elseif (table:getParent().type == 3 ) then
        local index_x = 60
        local parent = table:getParent()
        parent.idx = idx*5 + 1
        local num = #parent.data - parent.idx +1
        if num > 5 then 
            num = 5 
        end

        for i=1, num do       
            print("===========================")  
            print( parent.data[parent.idx])
            local payItem = CCSprite:create("images/BiaoQing/"..parent.data[parent.idx])
            local size = payItem:getContentSize()
            payItem:setScaleX(75/size.width)
            payItem:setScaleY(75/size.height)
            payItem:setTouchEnabled(true);
            payItem:addTouchEventListener(handler(payItem, onTouch_))
            payItem:setTag(parent.idx)
            payItem:setPosition(index_x,40) 
            if table:getParent().paycatnum <= 0 then
                --payItem:setOpacity(255)
                payItem:setColor(ccc3(166,166,166))
            end
            cell:addChild(payItem)            
 

            index_x = index_x +85
            parent.idx = parent.idx + 1
        end
    end

    return cell
end

function ChatLayer:initTableView(target,type,data)
    local winSize = target:getContentSize()
    print(winSize.width ,winSize.height)
    --TableViewLayer.initdata(target,winSize,type,data, self);
    createTabView(target,winSize,type,data, self);
end

function ChatLayer:initPhraseInfo()
    print("ChatLayer:initPhraseInfo()")
    --TableViewLayer.create(self.chatTabView,tolua.cast(self["chatTabView"],"CCLayer"))
    self:initTableView(self.chatTabView, 1, phrasetable);
end

function ChatLayer:initFaceInfo()
    print("ChatLayer:initFaceInfo()")
    --TableViewLayer.create(self.chatTabView,tolua.cast(self["chatTabView"],"CCLayer"))
    self:initTableView(self.chatTabView, 2, facetable);
end

function ChatLayer:initPayInfo()
    print("ChatLayer:initPayInfo()")
    --TableViewLayer.create(self.chatTabView,tolua.cast(self["chatTabView"],"CCLayer"))
    print(self.ctrller.catnum)
    self.chatTabView.paycatnum = self.ctrller:getPayCatNum()
    self:initTableView(self.chatTabView, 3, paytable);
    --self.chatTabView.paycatnum = self.ctrller:getPayCatNum()
end

function ChatLayer:onAddToScene()
    --self.rootNode:setPosition(CCPoint(display.cx,display.cy));
end

function ChatLayer:onPressBack()
    gBaseLogic.sceneManager:removePopUp("ChatLayer");
end

return ChatLayer;
