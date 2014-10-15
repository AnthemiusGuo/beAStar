local GoldExchangeScene = class("GoldExchangeScene",izx.baseView)

function GoldExchangeScene:ctor(pageName,moduleName,initParam)
    print ("GoldExchangeScene:ctor")
    self.super.ctor(self,pageName,moduleName,initParam);
end

function GoldExchangeScene:onAssignVars()
    --var_dump(self);
    self.rootNode = tolua.cast(self.rootNode,"CCNode");

    if nil ~= self["exchangeSlider"] then
        self.exchangeSlider = tolua.cast(self["exchangeSlider"],"CCSprite")
    end
     if nil ~= self["proertyItem"] then
        self.proertyItem = tolua.cast(self["proertyItem"],"CCControl")
    end
    if nil ~= self["cardItem"] then
        self.cardItem = tolua.cast(self["cardItem"],"CCControl")
    end
    if nil ~= self["recordItem"] then
        self.recordItem = tolua.cast(self["recordItem"],"CCControl")
    end
end

function GoldExchangeScene:onPressBack()
    print "onPressBack"
    izx.baseAudio:playSound("audio_menu");
    gBaseLogic.lobbyLogic:goBackToMain();
end

function GoldExchangeScene:onPressProerty()
    print "onPressProerty"
    izx.baseAudio:playSound("audio_menu");
    if (true) then
        izxMessageBox("正在开发中，请稍候！", "即将推出");
        return;
    end
    --self.exchangeSlider:setPositionX(self.proertyItem:getPositionX())
    self:SliderMoveAction(self.exchangeSlider, self.proertyItem:getPositionX(), nil, 0.2)
    if (#(self.ctrller.data.propsData) == 0)then
        var_dump(self.ctrller.data.propsData);
        gBaseLogic:blockUI();
        self.ctrller:getData(0)
    else
        self.tabViewLayer:init(0,self.ctrller.data.propsData)
    end
end

function GoldExchangeScene:onPressCard()
    print "onPressCard"
    izx.baseAudio:playSound("audio_menu");
    --self.exchangeSlider:setPositionX(self.cardItem:getPositionX())
    self:SliderMoveAction(self.exchangeSlider, self.cardItem:getPositionX(), nil, 0.2)    
    if (#(self.ctrller.data.rechargeCardDataList) == 0)then
        var_dump(self.ctrller.data.rechargeCardDataList);
        gBaseLogic:blockUI();
        self.ctrller:getData(1)
    else
        self.tabViewLayer:init(1,self.ctrller.data.rechargeCardDataList)
    end

end

function GoldExchangeScene:onPressRecord()
    print "onPressRecord"
    izx.baseAudio:playSound("audio_menu");
    --self.exchangeSlider:setPositionX(self.recordItem:getPositionX())
    self:SliderMoveAction(self.exchangeSlider, self.recordItem:getPositionX(), nil, 0.2)
    if (#(self.ctrller.data.rechargeRecordDataList) == 0) then
        var_dump(self.ctrller.data.rechargeRecordDataList);
        gBaseLogic:blockUI();
        self.ctrller:getData(2)
    else
        --     self.ctrller.data.rechargeRecordDataList = {
        -- {desc="helloworld",
        --  order= "123456789",
        --  status="1",
        --  timeStr="1389938013"
        --  }
        -- }
        -- var_dump(self.ctrller.data.rechargeRecordDataList);
        self.tabViewLayer:init(2,self.ctrller.data.rechargeRecordDataList)
    end
end

function GoldExchangeScene:onInitView()
    --self:initBaseInfo();
    print "GoldExchangeScene:onInitView"
    self:createTableView();
    self:onPressCard();
end

function GoldExchangeScene:initBaseInfo()

end

local TableViewLayer = class("TableViewLayer")
TableViewLayer.__index = TableViewLayer

function TableViewLayer.extend(target)
    print "TableViewLayer.extend"
    local t = tolua.getpeer(target)
    if not t then
        t = {}
        tolua.setpeer(target, t)
    end
    setmetatable(t, TableViewLayer)
    return target
end

function TableViewLayer.cellSizeForTable(table,idx)
    return 113,1136
end

function TableViewLayer.numberOfCellsInTableView(table)
    -- var_dump(table.data);
    local data = table:getParent().data;
    print("numberOfCellsInTableView"..#data)
    return #data
end

function TableViewLayer.tableCellAtIndex(table, idx)

    print "TableViewLayer.tableCellAtIndex"
    local cell = table:dequeueCell()
    local label = nil
    if nil == cell then        
        cell = CCTableViewCell:new()
    else
        cell:removeAllChildrenWithCleanup(true);
    end 
    local winSize = CCDirector:sharedDirector():getWinSize()

    --------------------------------------------------------
    --props
    if (table:getParent().type==0) then

        local itemInfo = table:getParent().data[idx+1];
        local proxy = CCBProxy:create();
        local table = {};

        table.onPressExchange = function(self,asc,sender) 
            local idx = sender:getTag();
            print "Exchange buttion is pressing"
            --gBaseLogic:blockUI();
            --gBaseLogic.lobbyLogic.goldExchangeScene.ctrller:exchargingGift(1,idx);
        end 

        local node = CCBuilderReaderLoad("interfaces/DuiHuanDaoJu.ccbi",proxy,table);
        table.labelItemName = tolua.cast(table["labelItemName"],"CCLabelTTF")
        table.labelItemDesc = tolua.cast(table["labelItemDesc"],"CCLabelTTF")
        table.spriteItemIcon = tolua.cast(table["spriteItemIcon"],"CCSprite")

        -- local imgSpiteList = string.split(itemInfo.logo, "/");
        -- print(itemInfo.logo)
        -- var_dump(imgSpiteList);
        -- local tFiles = gBaseLogic.DownloadPath .. imgSpiteList[#imgSpiteList];
        -- if io.exists(tFiles) == false then
        --     gBaseLogic:img_file_down(tFiles,itemInfo.logo,function() 
        --         table.spriteItemIcon:setTexture(getCCTextureByName(tFiles))
        --         end)
        -- else 
        --     -- v.local_img = tFiles;
        --     table.spriteItemIcon:setTexture(getCCTextureByName(tFiles))
        -- end

        -- table.labelItemName:setString(itemInfo.sn)
        -- table.labelItemDesc:setString(itemInfo.desc)
        table.btnExchange:setTag(idx+1);

        cell:addChild(node)
    --------------------------------------------------------
    --rechargeableCard
    elseif(table:getParent().type==1) then

        local itemInfo = table:getParent().data[idx+1];
        local proxy = CCBProxy:create();
        local table = {};


        table.onPressExchange = function(self,asc,sender) 
            local idx = sender:getTag();
            print "Exchange buttion is pressing"
            gBaseLogic:blockUI();
            self.ctrller:exchargingGift(1,idx);
        end 

        local node = CCBuilderReaderLoad("interfaces/DuiHuanChongZhiKa.ccbi",proxy,table);
        table.ctrller = gBaseLogic.sceneManager.currentPage.ctrller;
        table.labelItemName = tolua.cast(table["labelItemName"],"CCLabelTTF")
        table.labelItemDesc = tolua.cast(table["labelItemDesc"],"CCLabelTTF")
        table.spriteItemIcon = tolua.cast(table["spriteItemIcon"],"CCSprite")

        local imgSpiteList = string.split(itemInfo.logo, "/");
        print(itemInfo.logo)
        var_dump(imgSpiteList);
        izx.resourceManager:imgFileDown(itemInfo.logo,true,function(fileName) 
            if table~=nil and table.spriteItemIcon~=nil then
                table.spriteItemIcon:setTexture(getCCTextureByName(fileName))
            end
        end);

        -- local tFiles = gBaseLogic.DownloadPath .. imgSpiteList[#imgSpiteList];
        -- if io.exists(tFiles) == false then
        --     gBaseLogic:img_file_down(tFiles,itemInfo.logo,function() 
        --         table.spriteItemIcon:setTexture(getCCTextureByName(tFiles))
        --         end)
        -- else 
            -- v.local_img = tFiles;
        --     table.spriteItemIcon:setTexture(getCCTextureByName(tFiles))
        -- end

        table.labelItemName:setString(itemInfo.sn)
        table.labelItemDesc:setString(itemInfo.desc)
        table.btnExchange:setTag(idx+1);

        cell:addChild(node)
    --------------------------------------------------------
    --rechargingRecords
    elseif(table:getParent().type==2) then

                tab=os.date("*t",1389938013)
        print(111111111111111111111111111111111111);
        print(tab.year, tab.month, tab.day, tab.hour, tab.min, tab.sec);

        local itemInfo = table:getParent().data[idx+1];
        local proxy = CCBProxy:create();
        local table = {};


        local node = CCBuilderReaderLoad("interfaces/DuiHuanJiLu.ccbi",proxy,table);
        table.labelItemOrder = tolua.cast(table["labelItemOrder"],"CCLabelTTF")
        table.labelItemDate = tolua.cast(table["labelItemDate"],"CCLabelTTF")
        table.labelItemDesc = tolua.cast(table["labelItemDesc"],"CCLabelTTF")
        table.labelItemSuc = tolua.cast(table["labelItemSuc"],"CCLabelTTF")
        table.labelItemErr = tolua.cast(table["labelItemErr"],"CCLabelTTF")
        table.spriteItemIcon = tolua.cast(table["spriteItemIcon"],"CCSprite")

        -- local imgSpiteList = string.split(itemInfo.logo, "/");
        -- print(itemInfo.logo)
        -- var_dump(imgSpiteList);
        -- local tFiles = gBaseLogic.DownloadPath .. imgSpiteList[#imgSpiteList];
        -- if io.exists(tFiles) == false then
        --     gBaseLogic:img_file_down(tFiles,itemInfo.logo,function() 
        --         table.spriteItemIcon:setTexture(getCCTextureByName(tFiles))
        --         end)
        -- else 
        --     -- v.local_img = tFiles;
        --     table.spriteItemIcon:setTexture(getCCTextureByName(tFiles))
        -- end

        table.labelItemOrder:setString(itemInfo.order)
        local tab=os.date("*t",tonumber(itemInfo.timeStr))
        local date = tab.month.."-"..tab.day.." "..tab.hour..":"..tab.min;
        table.labelItemDate:setString(date);
        table.labelItemDesc:setString(itemInfo.desc)

        --<0.失败 0,1.成功
        if(itemInfo.status >= 0) then
            table.labelItemSuc:setVisible(true)
            table.labelItemErr:setVisible(false)
        else
            table.labelItemSuc:setVisible(false)
            table.labelItemErr:setVisible(true)     
        end

        cell:addChild(node)
    end

    return cell
end

function TableViewLayer:init(type,data)

    print "TableViewLayer:init"



    self:removeAllChildrenWithCleanup(true);

    if(#(data)==0)then
        local msg = "您还没有兑换过礼物！"
        ShowNoContentTip(self,msg)
        -- izxMessageBox("您还没有兑换过礼物！","提示");
        return
    end

    --local winSize = CCDirector:sharedDirector():getWinSize()
    local winSize = self:getContentSize()
    self.type = type;
    self.data = data;
     -- self.tableViewcell ={}
    tableView = CCTableView:create(CCSizeMake(winSize.width,winSize.height))
    tableView:setDirection(kCCScrollViewDirectionVertical)
    --tableView:setPosition(ccp(0, 0))
    tableView:setVerticalFillOrder(kCCTableViewFillTopDown)
    self:addChild(tableView)
    tableView:registerScriptHandler(TableViewLayer.cellSizeForTable,CCTableView.kTableCellSizeForIndex)
    tableView:registerScriptHandler(TableViewLayer.tableCellAtIndex,CCTableView.kTableCellSizeAtIndex)
    tableView:registerScriptHandler(TableViewLayer.numberOfCellsInTableView,CCTableView.kNumberOfCellsInTableView)
    tableView:reloadData()

    return true

end

function TableViewLayer.create(goldExchangeScene)
    goldExchangeScene.tabViewLayer = TableViewLayer.extend(tolua.cast(goldExchangeScene["tabViewLayer"],"CCLayer"))
end

function GoldExchangeScene:createTableView()

    print "GoldExchangeScene:createTableView"
    TableViewLayer.create(self)

end

return GoldExchangeScene;
