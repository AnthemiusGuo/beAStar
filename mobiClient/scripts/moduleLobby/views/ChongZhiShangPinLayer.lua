local ChongZhiShangPinLayer = class("ChongZhiShangPinLayer",izx.baseView)

function ChongZhiShangPinLayer:ctor(pageName,moduleName,initParam)
	print ("ChongZhiShangPinLayer:ctor")
    self.needMoney = initParam.money;
    self.super.ctor(self,pageName,moduleName,initParam);

end


function ChongZhiShangPinLayer:onAssignVars() 
    
	self.rootNode = tolua.cast(self.rootNode,"CCNode");
	 
    
 
    if nil ~= self["lableTishi"] then
        self.lableTishi = tolua.cast(self["lableTishi"],"CCLabelTTF")
    end 
    self.lableTishi:setString(self.initParam.msg)--"再充值 "..self.needMoney .." 元领取任务奖励！")
end



function ChongZhiShangPinLayer:onPressBack()
    print ("ChongZhiShangPinLayer:onPressBack")
    izx.baseAudio:playSound("audio_menu");
    self:onPressClose();
end

function ChongZhiShangPinLayer:onPressClose()
    print ("ChongZhiShangPinLayer:onPressClose")
    izx.baseAudio:playSound("audio_menu");
    gBaseLogic.sceneManager:removePopUp("ChongZhiShangPinLayer");
end
 
function ChongZhiShangPinLayer:onInitView()
    print ("ChongZhiShangPinLayer:onInitView")
    self:createTableView()
    self:initBaseInfo();
    
end

 
function ChongZhiShangPinLayer:initBaseInfo()
    if (self.logic.paymentItemList==nil) then
        gBaseLogic:blockUI();
        gBaseLogic.lobbyLogic:requestHTTPPaymentItems(0)
    else
        self:initTableView(self.tabViewLayer,self.logic.paymentItemList)
        -- self.tabViewLayer:addTouchEventListener(handler(self, self.onChongZhiShangPinLayerTouch))
    end
    
	
end
 
function ChongZhiShangPinLayer:onChongZhiShangPinLayerTouch(event, x, y)
    --常用短语
    print("onChongZhiShangPinLayerTouch=======================")
    return false
end
 
function ChongZhiShangPinLayer:onAddToScene()
    self.rootNode:setPosition(ccp(display.cx,display.cy));
end





--====================================

local TableViewLayer = require "izxFW.BaseTableView";
-- local TableViewLayer = class("TableViewLayer",require "izxFW.BaseTableView")
-- TableViewLayer.__index = TableViewLayer

function ChongZhiShangPinLayer.cellSizeForTable(table,idx)
    return 103,668
end
function ChongZhiShangPinLayer.numberOfCellsInTableView(table)
    -- var_dump(table.data);
    local data = table:getParent().data;
    return #data
end
function ChongZhiShangPinLayer.tableCellAtIndex(table, idx)
    local cell = table:dequeueCell()
    local label = nil
    if nil == cell then        
        cell = CCTableViewCell:new()
    else
        cell:removeAllChildrenWithCleanup(true);
    end 
    local winSize = CCDirector:sharedDirector():getWinSize()
    
     

    local itemInfo = table:getParent().data[idx+1];
    local boxid = itemInfo.boxid
    local proxy = CCBProxy:create();
    local table = {};
    table.onPressChongZhi = function(self,asc,sender) 
        local idx = sender:getTag();
        -- gBaseLogic:blockUI({autoUnblock=false})

        local data= gBaseLogic.lobbyLogic.paymentItemList[idx];
        gBaseLogic.lobbyLogic:onPayTips(3, "SMS", data, 0)
        -- gBaseLogic.lobbyLogic:pay(data,"SMS");
    end
    local node = CCBuilderReaderLoad("interfaces/ChongZhiShangPinNode.ccbi",proxy,table);
    table.ctrller = gBaseLogic.sceneManager.currentPage.ctrller;
    table.labelName = tolua.cast(table["labelName"],"CCLabelTTF")
    table.labelDesc = tolua.cast(table["labelDesc"],"CCLabelTTF")
    
    table.spriteImg = tolua.cast(table["spriteImg"],"CCSprite")

    izx.resourceManager:imgFileDown(itemInfo.icon,true,function(fileName) 
        if table~=nil and table.spriteImg~=nil then
            table.spriteImg:setTexture(getCCTextureByName(fileName))
        end
    end);
    
   
    table.btnBuy = tolua.cast(table["btnBuy"],"CCControlButton")
    table.btnBuy:setTag(idx+1);
    table.labelName:setString(itemInfo.boxname)
    table.labelDesc:setString(itemInfo.desc)

    cell:addChild(node)

    return cell
end

function ChongZhiShangPinLayer:initTableView(target,data)
    local winSize = self.tabViewLayer:getContentSize()
    TableViewLayer.initdata(target,CCSizeMake(winSize.width,winSize.height),0,data, self);
    -- createTabView(target,winSize,0,data, self);
    return true
end

function ChongZhiShangPinLayer:createTableView()
    --self.tabViewLayer = TableViewLayer.extend(tolua.cast(self["tabViewLayer"],"CCLayer"))
    TableViewLayer.create(self.tabViewLayer,self["tabViewLayer"])

end

return ChongZhiShangPinLayer;