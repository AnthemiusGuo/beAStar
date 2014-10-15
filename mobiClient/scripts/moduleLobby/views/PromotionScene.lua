local PromotionScene = class("PromotionScene",izx.baseView)

function PromotionScene:ctor(pageName,moduleName,initParam)
	print ("PromotionScene:ctor")
    self.super.ctor(self,pageName,moduleName,initParam);
    self.type = initParam.type
end

function PromotionScene:onAssignVars()
	--var_dump(self);
	self.rootNode = tolua.cast(self.rootNode,"CCNode");

    self.promoterNode = tolua.cast(self["promoterNode"],"CCNode");
    self.bindingNode = tolua.cast(self["bindingNode"],"CCNode");
    self.gameBeginNode = tolua.cast(self["gameBeginNode"],"CCNode");
    self.inputBox = tolua.cast(self["inputBox"],"CCNode");
    self.gotoPromote = tolua.cast(self["gotoPromote"],"CCNode");
    self.mypartner = tolua.cast(self["mypartner"],"CCNode");
    self.myrecord = tolua.cast(self["myrecord"],"CCNode");

    self.promoteLable = tolua.cast(self["promoteLable"],"CCLabelTTF");
    self.awardLabel = tolua.cast(self["awardLabel"],"CCLabelTTF");
    self.textLable = tolua.cast(self["textLable"],"CCLabelTTF");

    self.promote = tolua.cast(self["promote"],"CCControl");
    self.partner = tolua.cast(self["partner"],"CCControl");
    self.record = tolua.cast(self["record"],"CCControl");
    self.slider = tolua.cast(self["slider"],"CCSprite");
    self.getAwardBut = tolua.cast(self["getAwardBut"],"CCControl");
    self.btnToSet = tolua.cast(self["btnToSet"],"CCControl");
    self.btnGotoPromote = tolua.cast(self["btnGotoPromote"],"CCControl");

    self.promoteButton = tolua.cast(self["promoteButton"],"CCControl");
    self.bindingButton = tolua.cast(self["bindingButton"],"CCControl");
    self.tuiguangSlider = tolua.cast(self["tuiguangSlider"],"CCSprite"); 

    self.partnertabView = tolua.cast(self["partnertabView"],"CCLayer")
    self.recordtabview = tolua.cast(self["recordtabview"],"CCLayer")

    self.bindingButton:setEnabled(false)
    self.bindingNode:setVisible(false)
    self.ctrller:ifBinding()
    if (gBaseLogic.MBPluginManager.distributions.share~=true) then
        self.btnGotoPromote:setVisible(false);
    end
end

function PromotionScene:onPressBack()
    print "onPressBack"
    self.promotebasetab = nil;
    self.ctrller.partnerdata = nil;
    self.ctrller.recorddata = nil;
    self.logic:goBackToMain();
end

function PromotionScene:onPressCdkGet()
    print "onPressCdkGet"
    local cdk = self.inputBox:getChildByTag(2):getText();
    if cdk ~= "" then
        if cdk == self.promoteLable:getString() then
            izxMessageBox("推广码不能绑定自己", "提示");
        else
            self.ctrller:promotebinding(cdk);
        end
    else
        izxMessageBox("请输入有效推广码", "提示");
    end
end

function PromotionScene:onPressPromote()
    print "onPressPromote"
    --self.logic.userData.ply_lobby_data_.param_2_ = 8 -- for test
    if self.logic.userData.ply_lobby_data_.param_2_ >= 8 then
        self.bindingNode:setVisible(false);
        self.gameBeginNode:setVisible(false);
        
        self.promoterNode:setVisible(true);
        self.promoteButton:setEnabled(false);
        self.bindingButton:setEnabled(true);
        if self.ctrller.isPromoteOK == false then 
            self.btnGotoPromote:setEnabled(false)
            self.ctrller:getPromote(); 
        else 
            self.btnGotoPromote:setEnabled(gBaseLogic.MBPluginManager.hasSocial)
        end
        self:SliderMoveAction(self.tuiguangSlider, self.promoteButton:getPositionX(), nil, 0.2)
    else
        izxMessageBox("等级未达8级，暂未开放此功能", "提示");
    end
end

function PromotionScene:onPressBinding()
    print "onPressBinding"
    --self.ctrller.isBind = 0 --for test
    if self.ctrller.isBind == 0 then
        self.gameBeginNode:setVisible(false);
        self.bindingNode:setVisible(true);
    elseif self.ctrller.isBind == 1 then
        self.bindingNode:setVisible(false);
        self.gameBeginNode:setVisible(true);
    else 
        self.bindingNode:setVisible(false);
        self.gameBeginNode:setVisible(false);
    end 
    self.promoterNode:setVisible(false);
    self.bindingButton:setEnabled(false);
    self.promoteButton:setEnabled(true);
    self:SliderMoveAction(self.tuiguangSlider, self.bindingButton:getPositionX(), nil, 0.2)
end

function PromotionScene:onPressGotoPromote()
    print "onPressGotoPromote"
    var_dump(gBaseLogic.MBPluginManager.distributions.share);
    if (gBaseLogic.MBPluginManager.distributions.share~=true) then
        izxMessageBox("您的游戏版本较低，请安装新版本", "提示");
        return;
    end 
    if self.ctrller.isPromoteOK == true then 
        local str = string.format("您的好友 %s 邀请您加入掌心斗地主，邀请码：%s 游戏下载地址：http://www.izhangxin.com/ddz/，快和你的小伙伴一决高低吧！",self.logic.userData.ply_lobby_data_.nickname_,self.promoteLable:getString());
        str = gBaseLogic.MBPluginManager:replaceText(str);
        echoInfo(str);
        gBaseLogic.MBPluginManager:share(nil,str);
    else 
        izxMessageBox("获取推广码无效", "提示") 
    end
end

function PromotionScene:onPressProm()
    print "onPressIn-Promote"
    if self.gotoPromote and self.gotoPromote:isVisible() == false then
        self.gotoPromote:setVisible(true);
        self.mypartner:setVisible(false);
        self.myrecord:setVisible(false);
        --self.slider:setPositionY(self.promote:getPositionY());
        self:SliderMoveAction(self.slider, nil, self.promote:getPositionY(), 0.2)
    end
end

function PromotionScene:onPressPartner()
    print "onPressOut-partner"
    if self.mypartner and self.mypartner:isVisible() == false then
        self.mypartner:setVisible(true);
        self.gotoPromote:setVisible(false);
        self.myrecord:setVisible(false);
        --self.slider:setPositionY(self.partner:getPositionY());
        self:SliderMoveAction(self.slider, nil, self.partner:getPositionY(), 0.2)
        if #self.ctrller.partnerdata <= 0 then
            self.ctrller:getPromotePartner();
        end
    end
end

function PromotionScene:onPressRecord()
    print "onPressRecord"
    if self.myrecord and self.myrecord:isVisible() == false then
        self.myrecord:setVisible(true);
        self.gotoPromote:setVisible(false);
        self.mypartner:setVisible(false);
        --self.slider:setPositionY(self.record:getPositionY());
        self:SliderMoveAction(self.slider, nil, self.record:getPositionY(), 0.2)
        if #self.ctrller.recorddata <= 0 then
            self.ctrller:getPromoteRecord();
        end
    end
end

function PromotionScene:onPressGotoAward()
    print "onPressGotoAward"
    if self.ctrller.canaward == true then
        self.ctrller:getPromoteaward();
    end
end

function PromotionScene:onPressBeginGame()
    print "onPressBeginGame"
    self.logic:startGame("moduleDdz",-1);
end

function PromotionScene:onInitView()
    --创建输入框
    local function editBoxTextEventHandle(strEventName,pSender)
        local edit = tolua.cast(pSender,"CCEditBox")
        if edit:getText() ~= "" then 
            self.btnToSet:setEnabled(true)
        end
        --self.txt_person_name:setString(edit:getText())
        --self.txt_person_name:setVisible(false)
        
    end 
    local editbox = CCScale9Sprite:create("images/LieBiao/".."list_bg_shuru.png");
    --editbox:setScaleX(1.37);
    -- local EditBox = CCEditBox:create(editbox:getContentSize(),editbox)
    -- EditBox:setFontSize(30)
    -- EditBox:setPlaceholderFontColor(ccc3(0,0,0))
    -- EditBox:setFontColor(ccc3(0,0,0))
    -- EditBox:setPlaceHolder("输入推广码：")
    -- EditBox:setMaxLength(8)
    -- EditBox:setReturnType(kKeyboardReturnTypeDone)
    -- --Handler
    -- --EditBox:registerScriptEditBoxHandler(editBoxTextEventHandle)
    -- EditBox:setTag(2)
    -- self.inputBox:addChild(EditBox)
    createEditBox(self.inputBox, editbox, editBoxTextEventHandle, {
            maxLen = 8,
            cFontSize = 30,
            strHolder = "输入推广码：",
            tag = 2
        })
    self.btnToSet:setEnabled(false)
    if self.type == 2 then 
        self:onPressPromote()
    end
end

function PromotionScene:initBaseInfo(code)
    --self.promoteLable:setString(code) 
   

    --self.promotebasetab = require("izxFW.BaseTableView").new();
    --self.recordbasetab = require("izxFW.BaseTableView").new();
    --self:createTableView(self.promotebasetab,"partnertabView");
    --self:createTableView(self.promotebasetab,"recordtabview"); 
end

function PromotionScene:refreshPartner(status,lwMoney)
    self.awardLabel:setString(lwMoney)
    --status = 0
    if status == 0 then --未领取
        self.ctrller.canaward = true
        self.getAwardBut:setEnabled(true)
    else
        self.getAwardBut:setEnabled(false)
    end
    --self:initTableView(self.partnertabView,"partnertabView",0,self.ctrller.partnerdata)
    self:initTableView(self.partnertabView, 0,self.ctrller.partnerdata)
end

function PromotionScene:refreshRecord()
    --self:initTableView(self.recordtabview,"recordtabview",1,self.ctrller.recorddata)
    self:initTableView(self.recordtabview,1,self.ctrller.recorddata)
end


function PromotionScene.cellSizeForTable(table,idx)
    if table:getParent() then
        return 113,table:getParent():getContentSize().width;
    end
end

function PromotionScene.numberOfCellsInTableView(table)
    local data = table:getParent().data;
    return #data
end

function PromotionScene.tableCellAtIndex(table, idx)
    local cell = table:dequeueCell()
    local label = nil
    if nil == cell then        
        cell = CCTableViewCell:new()
    else
        cell:removeAllChildrenWithCleanup(true);
    end 
    
    if (table:getParent().type==0) then --伙伴
        local itemInfo = table:getParent().data[idx+1];
        local proxy = CCBProxy:create();
        local nodetable = {};                            
        local node = CCBuilderReaderLoad("interfaces/tuiguanghuobanLieBiao.ccbi",proxy,nodetable);
        nodetable.level = tolua.cast(nodetable["level"],"CCLabelTTF") 
        nodetable.nickname = tolua.cast(nodetable["nickname"],"CCLabelTTF")
        nodetable.winnum = tolua.cast(nodetable["winnum"],"CCLabelTTF")
        nodetable.awardtime = tolua.cast(nodetable["awardtime"],"CCLabelTTF")
        nodetable.headImage = tolua.cast(nodetable["headImage"],"CCSprite")
        nodetable.level:setString(itemInfo.level)
        nodetable.nickname:setString(itemInfo.nickname)
        nodetable.winnum:setString(itemInfo.twMoney)
        nodetable.awardtime:setString(itemInfo.time)
        izx.resourceManager:imgFileDown(itemInfo.faceurl,true,function(fileName) 
                if nodetable~=nil and nodetable.headImage~=nil then
                    nodetable.headImage:setTexture(getCCTextureByName(fileName))
                end
            end);
       
        cell:addChild(node)
    elseif (table:getParent().type==1) then --记录
        local itemInfo = table:getParent().data[idx+1];
        local proxy = CCBProxy:create();
        local nodetable = {};
        local node = CCBuilderReaderLoad("interfaces/tuiguangjiluLiebiao.ccbi",proxy,nodetable);
        nodetable.recordtime = tolua.cast(nodetable["recordtime"],"CCLabelTTF")
        nodetable.recordcontent = tolua.cast(nodetable["recordcontent"],"CCLabelTTF")
        nodetable.recordtime:setString(itemInfo.time)
        nodetable.recordcontent:setString(itemInfo.money)
        cell:addChild(node)
    end

    return cell
end

function PromotionScene:initTableView(target,type,data)
    --local winSize = resolutionFixedWidth(target,640)
    local winSize = target:getContentSize()
    createTabView(target, winSize, type, data, self);
end

-- function PromotionScene:initTableView(basetab,ccblayername,type,data)
--     local winSize = self[ccblayername]:getContentSize()
--     basetab.initdata(self[ccblayername],CCSizeMake(winSize.width,winSize.height),type,data, self);
-- end

-- function PromotionScene:createTableView(basetab,ccblayername)
--     basetab.create(self[ccblayername],tolua.cast(self[ccblayername],"CCLayer"))
-- end

return PromotionScene;
