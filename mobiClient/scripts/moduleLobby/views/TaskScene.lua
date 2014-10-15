local TaskScene = class("TaskScene",izx.baseView)

function TaskScene:ctor(pageName,moduleName,initParam)
	print ("TaskScene:ctor")
    self.super.ctor(self,pageName,moduleName,initParam);
end


function TaskScene:onAssignVars()
	--var_dump(self);
    print "TaskScene:onAssignVars"
	self.rootNode = tolua.cast(self.rootNode,"CCNode");

	if nil ~= self["taskSlider"] then
        self.taskSlider = tolua.cast(self["taskSlider"],"CCSprite")
    end
     if nil ~= self["everydayTaskItem"] then
        self.everydayTaskItem = tolua.cast(self["everydayTaskItem"],"CCControl")
    end
    if nil ~= self["newTaskItem"] then
        self.newTaskItem = tolua.cast(self["newTaskItem"],"CCControl")
    end
    if nil ~= self["achieveItem"] then
        self.achieveItem = tolua.cast(self["achieveItem"],"CCControl")
    end 
    if nil ~= self["tabViewLayer"] then
        self.tabViewLayer = tolua.cast(self["tabViewLayer"],"CCLayer")
    end 
end

function TaskScene:onPressBack()
    print "onPressBack"
    izx.baseAudio:playSound("audio_menu");
    gBaseLogic.lobbyLogic:goBackToMain();
end

function TaskScene:onPressEverydayTask()
    print "onPressEverydayTask"
    izx.baseAudio:playSound("audio_menu");

    --self.taskSlider:setPositionX(self.everydayTaskItem:getPositionX())
    self:SliderMoveAction(self.taskSlider, self.everydayTaskItem:getPositionX(), nil, 0.2)
    if (#(self.ctrller.data.dayTaskList)==0) then
        gBaseLogic:blockUI();
        self.ctrller:getData(0)
    else
        --self.tabViewLayer:init(0,self.ctrller.data.dayTaskList)
        self:initTableView(self.tabViewLayer,0,self.ctrller.data.dayTaskList)
    end

end

function TaskScene:onPressNewTask()
    print "onPressNewTask"
    izx.baseAudio:playSound("audio_menu");
    --self.taskSlider:setPositionX(self.newTaskItem:getPositionX())
    self:SliderMoveAction(self.taskSlider, self.newTaskItem:getPositionX(), nil, 0.2)
    if (#(self.ctrller.data.newTaskList)==0) then
        gBaseLogic:blockUI();
        self.ctrller:getData(1)
    else
        --self.tabViewLayer:init(1,self.ctrller.data.newTaskList)
        self:initTableView(self.tabViewLayer,1,self.ctrller.data.newTaskList)
    end
end

function TaskScene:onPressAchieve()
    print "onPressAchieve"
    izx.baseAudio:playSound("audio_menu");
    --self.taskSlider:setPositionX(self.achieveItem:getPositionX())
    self:SliderMoveAction(self.taskSlider, self.achieveItem:getPositionX(), nil, 0.2)
    if (#(self.ctrller.data.achieveList)==0) then
        gBaseLogic:blockUI();
        self.ctrller:getData(2)
    else
        --self.tabViewLayer:init(2,self.ctrller.data.achieveList)
        self:initTableView(self.tabViewLayer,2,self.ctrller.data.achieveList)
    end

end

function TaskScene:onInitView()
	--self:initBaseInfo();
    print "TaskScene:onInitView"
end

function TaskScene:initBaseInfo()
    print "TaskScene:initBaseInfo"
end

function TaskScene.cellSizeForTable(table,idx)
    return 113,1136
end

function TaskScene.tableCellAtIndex(table, idx)

    print "TaskScene.tableCellAtIndex"
    local cell = table:dequeueCell()
    local label = nil
    if nil == cell then        
        cell = CCTableViewCell:new()
    else
        cell:removeAllChildrenWithCleanup(true);
    end 
    local winSize = CCDirector:sharedDirector():getWinSize()

    --------------------------------------------------------
    --dayTask
    if (table:getParent().type==0) then

        local itemInfo = table:getParent().data[idx+1];
        local proxy = CCBProxy:create();
        local table = {};

        table.onPressDoTask = function(self,asc,sender) 
            local idx = sender:getTag();
            print "DoTask buttion is pressing"
        end

        table.onPressGetAward = function(self,asc,sender) 

            local idx = sender:getTag();
            print "GetAward buttion is pressing"
            gBaseLogic:blockUI();
            self.ctrller:getDayTaskAward(idx);
            --local idx = sender:getTag();
            --print "GetAward buttion is pressing"

            --gBaseLogic.lobbyLogic.taskscene.ctrller:getAward(idx);
        end

        local node = CCBuilderReaderLoad("interfaces/RenWuRiChang.ccbi",proxy,table);
        table.ctrller = gBaseLogic.sceneManager.currentPage.ctrller;
        table.labelItemName = tolua.cast(table["labelItemName"],"CCLabelTTF")
        table.labelItemDesc = tolua.cast(table["labelItemDesc"],"CCLabelTTF")
        table.labelItemProcess = tolua.cast(table["labelItemProcess"],"CCLabelTTF")
        table.labelHavaReceived = tolua.cast(table["labelHavaReceived"],"CCLabelTTF")
        table.labelNotCompleted = tolua.cast(table["labelNotCompleted"],"CCLabelTTF")
        local tFiles = "images/Renwu/tubiao"..(idx+1)..".png";
        table.spriteItemIcon = tolua.cast(table["spriteItemIcon"],"CCSprite")
        table.spriteItemIcon:setTexture(getCCTextureByName(tFiles))
        

        -- table.onPressDoTask = function(asc,sender) 

        --     local idx = sender:getTag();
        --     print "DoTask buttion is pressing"
        
        -- end

        -- table.onPressGetAward = function(asc,sender) 

        --     local idx = sender:getTag();
        --     print "GetAward buttion is pressing"
        --     gBaseLogic:blockUI();
        --     self.ctrller:getDayTaskAward()

        -- end
        table.labelItemName:setString(itemInfo.name_)
        --  int     money_award_;   //游戏币奖励
--  int     gift_award_;    //礼券奖励
--  int     prop_1_award_;  //道具一: 记牌器
--  int     prop_2_award_;  //道具二: 小喇叭
--  int     prop_3_award_;  //道具三: 参赛券
        local str = "奖励：" 
        if itemInfo.money_award_ > 0 then 
            str = str..itemInfo.money_award_.."游戏币"
        end
        if itemInfo.gift_award_ > 0 then 
            str = str..itemInfo.gift_award_.."元宝" 
        end
        if itemInfo.prop_1_award_ > 0 then 
            str = str..itemInfo.prop_1_award_.."记牌器"
        end
        if itemInfo.prop_2_award_ > 0 then 
            str = str..itemInfo.prop_2_award_.."小喇叭"
        end
        if itemInfo.prop_3_award_ > 0 then 
            str = str..itemInfo.prop_3_award_.."参赛券"
        end 

        table.labelItemDesc:setString(str)
        if(itemInfo.value_ > itemInfo.max_) then 
            table.labelItemProcess:setString("进度: "..itemInfo.max_ .."/"..itemInfo.max_);
        else
            table.labelItemProcess:setString("进度: "..itemInfo.value_ .."/"..itemInfo.max_);
        end
        table.status = itemInfo.status_
        if itemInfo.value_ < itemInfo.max_ then
            table.status = 2
        end
        --table.status = 0
        --0.Get award
        --1.Hava Received
        --2.Not Completed
        -- if (nil~=table["btnDoTask"]) then
        --     table.btnDoTask = tolua.cast(table["btnDoTask"],"CCControlButton")
        --     table.btnDoTask:setTag(idx+1);

        --     if (idx==2) then
        --          print("==================iteminfo3")
        --     end
        -- end
        if (table.status == 0) then
           table.labelNotCompleted:setVisible(false)
           table.labelHavaReceived:setVisible(false)
           table.btnGetAward:setVisible(true)
           table.btnGetAward = tolua.cast(table["btnGetAward"],"CCControlButton")
           table.btnGetAward:setTag(idx+1);
        elseif (table.status == 1) then
           table.labelNotCompleted:setVisible(false)
           table.btnGetAward:setVisible(false)
           table.labelHavaReceived:setVisible(true)
        elseif (table.status == 2) then
           table.btnGetAward:setVisible(false)
           table.labelHavaReceived:setVisible(false)
           table.labelNotCompleted:setVisible(true)
        end

        cell:addChild(node)
    ---------------------------------------------------------
    --newTask
    elseif(table:getParent().type==1) then

        local itemInfo = table:getParent().data[idx+1];
        local proxy = CCBProxy:create();
        local table = {};

        table.onPressDoTask = function(self,asc,sender) 
            local idx = sender:getTag();
            print "DoTask buttion is pressing"
        end

        table.onPressGetAward = function(self,asc,sender) 

            local idx = sender:getTag();
            print "GetAward buttion is pressing"
            gBaseLogic:blockUI();
            self.ctrller:getNewTaskAward(idx);

        end

        local node = CCBuilderReaderLoad("interfaces/RenWuXinShou.ccbi",proxy,table);
        table.ctrller = gBaseLogic.sceneManager.currentPage.ctrller;
        table.labelItemName = tolua.cast(table["labelItemName"],"CCLabelTTF")
        table.labelItemDesc = tolua.cast(table["labelItemDesc"],"CCLabelTTF")
        table.labelHavaReceived = tolua.cast(table["labelHavaReceived"],"CCLabelTTF")
        table.labelNotCompleted = tolua.cast(table["labelNotCompleted"],"CCLabelTTF")
        table.spriteItemIcon = tolua.cast(table["spriteItemIcon"],"CCSprite")

        izx.resourceManager:imgFileDown(itemInfo.taskimgs,true,function(fileName) 
            if table~=nil and table.spriteItemIcon~=nil then
                table.spriteItemIcon:setTexture(getCCTextureByName(fileName))
            end
        end);
        -- local imgSpiteList = string.split(itemInfo.taskimgs, "/");
        -- print(imgSpiteList);          
        -- local tFiles = gBaseLogic.DownloadPath .. imgSpiteList[#imgSpiteList];

        -- if io.exists(tFiles) == false then
        --     gBaseLogic:img_file_down(tFiles,itemInfo.taskimgs,function() 
        --         table.spriteItemIcon:setTexture(getCCTextureByName(tFiles))
        --         end)
        -- else 
        --     -- v.local_img = tFiles;
        --     table.spriteItemIcon:setTexture(getCCTextureByName(tFiles))
        -- end

        table.labelItemName:setString(itemInfo.taskname)
        table.labelItemDesc:setString(itemInfo.taskdesc)
        table.status = itemInfo.taskstatus

        -- -1 完成未领奖
        --  0 完成已领奖
        --  1 未完成

        if (table.status == -1) then
           table.labelNotCompleted:setVisible(false)
           table.labelHavaReceived:setVisible(false)
           table.btnGetAward:setVisible(true)
           table.btnGetAward = tolua.cast(table["btnGetAward"],"CCControlButton")
           table.btnGetAward:setTag(idx+1);
        elseif (table.status == 0) then
           table.labelNotCompleted:setVisible(false)
           table.btnGetAward:setVisible(false)
           table.labelHavaReceived:setVisible(true)
        elseif (table.status == 1) then
           table.btnGetAward:setVisible(false)
           table.labelHavaReceived:setVisible(false)
           table.labelNotCompleted:setVisible(true)
        end

        cell:addChild(node)
    ---------------------------------------------------------
    --achieve
    elseif(table:getParent().type==2) then

        local itemInfo = table:getParent().data[idx+1];
        local proxy = CCBProxy:create();
        local table = {};

        table.onPressDoTask = function(self,asc,sender) 
            local idx = sender:getTag();
            print "DoTask buttion is pressing"
        end

        table.onPressGetAward = function(self,asc,sender) 

            local idx = sender:getTag();
            print "GetAward buttion is pressing"
            gBaseLogic:blockUI();
            self.ctrller:getAchieveAward(idx);

        end

        local node = CCBuilderReaderLoad("interfaces/RenWuChengJiu.ccbi",proxy,table);
        table.ctrller = gBaseLogic.sceneManager.currentPage.ctrller;
        table.labelItemName = tolua.cast(table["labelItemName"],"CCLabelTTF")
        table.labelItemDesc = tolua.cast(table["labelItemDesc"],"CCLabelTTF")
        table.labelItemProcess = tolua.cast(table["labelItemProcess"],"CCLabelTTF")
        table.labelTaskCondition = tolua.cast(table["labelTaskCondition"],"CCLabelTTF")
        table.labelHavaReceived = tolua.cast(table["labelHavaReceived"],"CCLabelTTF")
        table.labelNotCompleted = tolua.cast(table["labelNotCompleted"],"CCLabelTTF")
        local tFiles = "images/Renwu/chengjiu"..(idx+1)..".png";
        table.spriteItemIcon = tolua.cast(table["spriteItemIcon"],"CCSprite")
        table.spriteItemIcon:setTexture(getCCTextureByName(tFiles))

        table.labelItemName:setString(itemInfo.name_)
        table.labelItemDesc:setString(itemInfo.desc_)
        local str = "奖励：" 
        if itemInfo.money_award_ > 0 then 
            str = str..itemInfo.money_award_.."游戏币"
        end
        if itemInfo.gift_award_ > 0 then 
            str = str..itemInfo.gift_award_.."元宝" 
        
        end 
        table.labelTaskCondition:setString(str)
        if(itemInfo.value_ > itemInfo.max_) then 
            table.labelItemProcess:setString("进度: "..itemInfo.max_ .."/"..itemInfo.max_);
        else
            table.labelItemProcess:setString("进度: "..itemInfo.value_ .."/"..itemInfo.max_);
        end

        table.status = itemInfo.status_
        if itemInfo.value_ < itemInfo.max_ then
            table.status = 2
        end

        --table.status = 0

        if (table.status == 0) then
           table.labelNotCompleted:setVisible(false)
           table.labelHavaReceived:setVisible(false)
           table.btnGetAward:setVisible(true)
           table.btnGetAward = tolua.cast(table["btnGetAward"],"CCControlButton")
           table.btnGetAward:setTag(idx+1);
        elseif (table.status == 1) then
           table.labelNotCompleted:setVisible(false)
           table.btnGetAward:setVisible(false)
           table.labelHavaReceived:setVisible(true)
        elseif (table.status == 2) then
           table.btnGetAward:setVisible(false)
           table.labelHavaReceived:setVisible(false)
           table.labelNotCompleted:setVisible(true)
        end

        cell:addChild(node)    

    end

    return cell
end

function TaskScene.numberOfCellsInTableView(table)
    -- var_dump(table.data);
    local data = table:getParent().data;
    return #data
end

function TaskScene.onTableViewScroll(table)
    var_dump(table);
end

function TaskScene:initTableView(target,type,data)
    local winSize = target:getContentSize()
    if(#(data)==0)then
        izxMessageBox("服务器异常\n请稍候再试","提示");
        return
    end
    print(winSize.width,winSize.height,target)
    createTabView(target,winSize,type,data, self);
end 

return TaskScene;
