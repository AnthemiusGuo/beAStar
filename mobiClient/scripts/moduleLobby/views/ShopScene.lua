local ShopScene = class("ShopScene",izx.baseView)

-- NET_PACKET(pt_lc_send_vip_data_change_not)      // 
-- {
--     int vipLevel        ;
--     int vipRate ;
--     int nextVipneedMoney                ;   // money
--     string param_ ;
-- };
function ShopScene:ctor(pageName,moduleName,initParam)
	print ("ShopScene:ctor")
    self.loadVipPage = 0;
    self.super.ctor(self,pageName,moduleName,initParam);
    -- self.shopTypeView = 0;
    -- if (initParam.type~=nil) then
    --     self.shopTypeView = initParam.type;
    -- end
    self.vipgongneng = {}
    self.vipgongneng[1] = {{img_icon="vipicon1",desc="VIP标识"},{img_icon="vipicon2",desc="现金保险箱"}}
    self.vipgongneng[2] = {{img_icon="vipicon1",desc="VIP标识"},{img_icon="vipicon2",desc="现金保险箱"},{img_icon="vipicon3",desc="每日破产救助+1"}}
    self.vipgongneng[3] = {{img_icon="vipicon1",desc="VIP标识"},{img_icon="vipicon2",desc="现金保险箱"},{img_icon="vipicon3",desc="每日破产救助+1"},{img_icon="vipicon4",desc="牌桌橙色昵称"}}
    self.vipgongneng[4] = {{img_icon="vipicon1",desc="VIP标识"},{img_icon="vipicon2",desc="现金保险箱"},{img_icon="vipicon3",desc="每日破产救助+1"},{img_icon="vipicon4",desc="牌桌橙色昵称"},{img_icon="vipicon5",desc="签到奖励多1千"}}
    self.vipgongneng[5] = {{img_icon="vipicon1",desc="VIP标识"},{img_icon="vipicon2",desc="现金保险箱"},{img_icon="vipicon3",desc="每日破产救助+1"},{img_icon="vipicon4",desc="牌桌橙色昵称"},{img_icon="vipicon11",desc="签到奖励多2千"}}
    self.vipgongneng[6] = {{img_icon="vipicon1",desc="VIP标识"},{img_icon="vipicon2",desc="现金保险箱"},{img_icon="vipicon3",desc="每日破产救助+1"},{img_icon="vipicon4",desc="牌桌橙色昵称"},{img_icon="vipicon12",desc="签到奖励多3千"},{img_icon="vipicon6",desc="银色头像"}}
    self.vipgongneng[7] = {{img_icon="vipicon1",desc="VIP标识"},{img_icon="vipicon2",desc="现金保险箱"},{img_icon="vipicon3",desc="每日破产救助+1"},{img_icon="vipicon4",desc="牌桌橙色昵称"},{img_icon="vipicon13",desc="签到奖励多5千"},{img_icon="vipicon7",desc="金色头像"}}
    self.vipgongneng[8] = {{img_icon="vipicon1",desc="VIP标识"},{img_icon="vipicon2",desc="现金保险箱"},{img_icon="vipicon3",desc="每日破产救助+1"},{img_icon="vipicon4",desc="牌桌橙色昵称"},{img_icon="vipicon14",desc="签到奖励多8千"},{img_icon="vipicon7",desc="金色头像"},{img_icon="vipicon8",desc="VIP炸弹"}}
    self.vipgongneng[9] = {{img_icon="vipicon1",desc="VIP标识"},{img_icon="vipicon2",desc="现金保险箱"},{img_icon="vipicon3",desc="每日破产救助+1"},{img_icon="vipicon4",desc="牌桌橙色昵称"},{img_icon="vipicon14",desc="签到奖励多8千"},{img_icon="vipicon9",desc="钻石头像"},{img_icon="vipicon8",desc="VIP炸弹"},{img_icon="vipicon10",desc="免费记牌器"}}
    self.vipgongneng[10] = {{img_icon="vipicon1",desc="VIP标识"},{img_icon="vipicon2",desc="现金保险箱"},{img_icon="vipicon3",desc="每日破产救助+1"},{img_icon="vipicon4",desc="牌桌橙色昵称"},{img_icon="vipicon15",desc="签到奖励多1万"},{img_icon="vipicon9",desc="钻石头像"},{img_icon="vipicon8",desc="VIP炸弹"},{img_icon="vipicon10",desc="免费记牌器"}}

end

function ShopScene:onPressBuyVip()
    print("ShopScene:onPressBuyVip")
    local nextVipneedMoney = self.logic.vipData.nextVipneedMoney
    local items = {};
    var_dump(self.logic.payItemNormal)
    print("=====================dd")
    for k,v in pairs(self.logic.payItemNormal) do
        table.insert(items,v)
    end
    var_dump(items)
    print("=====================dd")
    local sortFunc = function(a, b)     
        if  a.price<b.price then
            return true
        else 
            return false
        end
    end
    table.sort(items,sortFunc)
    var_dump(items)
    local paydata = {}
    for k,v in pairs(items) do
        if v.price>=nextVipneedMoney then
            paydata = v;
            break;
        end
        paydata = v;
    end
    self.logic:onPayTips(3, "SMS", paydata, 0)

end
function ShopScene:onAssignVars()
	--var_dump(self);
	self.rootNode = tolua.cast(self.rootNode,"CCNode");

    if nil ~= self["shopSlider"] then
        self.shopSlider = tolua.cast(self["shopSlider"],"CCSprite")
    end
     if nil ~= self["proertyItem"] then
        self.proertyItem = tolua.cast(self["proertyItem"],"CCControl")
    end
    if nil ~= self["vipItem"] then
        self.vipItem = tolua.cast(self["vipItem"],"CCControl")
    end
    if nil ~= self["chargeRecordItem"] then
        self.chargeRecordItem = tolua.cast(self["chargeRecordItem"],"CCControl")
    end
    if nil ~= self["tabViewLayer"] then
        self.tabViewLayer = tolua.cast(self["tabViewLayer"],"CCLayer")
    end 
    if nil ~= self["tabViewLayer2"] then
        self.tabViewLayer2 = tolua.cast(self["tabViewLayer2"],"CCLayer")
    end 
    if nil ~= self["spriteItem"] then
        self.spriteItem = tolua.cast(self["spriteItem"],"CCSprite")
    end 
    if nil ~= self["buttonSelt"] then
        self.buttonSelt = tolua.cast(self["buttonSelt"],"CCControlButton")
    end
    if nil ~= self["labelText"] then
        self.labelText = tolua.cast(self["labelText"],"CCLabelTTF")
    end
    if nil ~= self["labelText2"] then
        self.labelText2 = tolua.cast(self["labelText2"],"CCLabelTTF")
    end
    if nil ~= self["layerZhiFu"] then
        self.layerZhiFu = tolua.cast(self["layerZhiFu"],"CCNode")
    end

    -- vip table
    
    if nil ~= self["vipSpriteRate"] then
        self.vipSpriteRate = tolua.cast(self["vipSpriteRate"],"CCSprite")
    end 
    if nil ~= self["vipRate"] then
        self.vipRate = tolua.cast(self["vipRate"],"CCLabelTTF")
    end 
  
    if nil ~= self["labelVipMoneyDesc"] then
        self.labelVipMoneyDesc = tolua.cast(self["labelVipMoneyDesc"],"CCLabelTTF")
    end
    if nil ~= self["vip1"] then
        self.vip1 = tolua.cast(self["vip1"],"CCLabelTTF")
    end
    if nil ~= self["vip2"] then
        self.vip2 = tolua.cast(self["vip2"],"CCLabelTTF")
    end

    if gBaseLogic.MBPluginManager.distributions.novip then 
        self.vipItem:setVisible(false) 
        self.vipDi:setVisible(false) 
        self.proertyItem:setPositionX(self.vipItem:getPositionX())
        self.proertyDi:setPositionX(self.vipDi:getPositionX())
        self.shopSlider:setPositionX(self.proertyItem:getPositionX())
        self:showPayType()
    end 

    self:getPayIconAndShow()
    -- local PayMidList = gBaseLogic:getPayMidList()
    -- --self.payTypelist = nil --for test
    -- if nil ~= PayMidList and #PayMidList > 0 then
    --     if self.shopTypeView == 0 then
    --         local payMid = CCUserDefault:sharedUserDefault():getIntegerForKey("UserPayMid",PayMidList[1].mid)
    --         local fileName = nil
    --         for k,v in pairs(PayMidList) do 
    --             if self.shopTypeView == 0 then 
    --                 if v.mid == payMid  then 
    --                     fileName = v.imgPrev
    --                 end
    --             elseif self.shopTypeView == 1 then 
    --                 if v.imgPrev ~= ""  then 
    --                     fileName = v.imgPrev
    --                 end 
    --             end    
    --         end
    --         if fileName == "" then 
    --             fileName = "zhifufangshi_shoujiduanxin"
    --         end                  
    --         fileName = fileName..".png"

    --         if (not io.exists(CCFileUtils:sharedFileUtils():fullPathForFilename(fileName))) then
    --             fileName = "images/ZhiFu/"..fileName                
    --         end 
    --         self.spriteItem:setTexture(getCCTextureByName(fileName))
    --     end

    -- end


end

function ShopScene:onPressBack()
    print "onPressBack"
    izx.baseAudio:playSound("audio_menu");
    gBaseLogic.lobbyLogic:goBackToMain();
    --TableViewLayer = nil
end

function ShopScene:onPressProerty()
    print "onPressProerty"
    izx.baseAudio:playSound("audio_menu");
    self.ctrller.shopType = 0;
    self:initBaseInfo()
    --self.shopSlider:setPositionX(self.proertyItem:getPositionX())
    self:SliderMoveAction(self.shopSlider, self.proertyItem:getPositionX(), nil,0.2)

    self.ctrller:checkPayType()
    if (self.ctrller.payitemslist==nil) then
        gBaseLogic:blockUI();
        gBaseLogic.lobbyLogic:requestHTTPPaymentItems(self.ctrller.shopType)
    else
        self:initTableView(self.tabViewLayer,0,self.ctrller.payitemslist)
    end
end 

function ShopScene:onPressVip()
    -- echoError("onPressVip");
    izx.baseAudio:playSound("audio_menu");
    self.ctrller.shopType = 1;
    self:initBaseInfo()
    --self.shopSlider:setPositionX(self.vipItem:getPositionX())
    self:SliderMoveAction(self.shopSlider, self.vipItem:getPositionX(), nil, 0.2)
    -- self.ctrller:checkPayType()
    -- if (self.ctrller.payitemslist==nil) then
    --     gBaseLogic:blockUI();
    --     print("====================ShopScene:onPressVip2")
    --     gBaseLogic.lobbyLogic:requestHTTPPaymentItems(self.ctrller.shopType)
        
    -- else
    --     gBaseLogic:unblockUI();
    --     print("====================ShopScene:onPressVip2")
    --     self:initTableView(self.tabViewLayer,1,self.ctrller.payitemslist)
    -- end
   
   
    if self.logic.vipData~=nil and self.loadVipPage==0 then
        self:loadvippageInfo()
       
    end
end
function ShopScene:loadvippageInfo()
    local vipLevel = self.logic.vipData.vipLevel;
    local nextVipneedMoney = self.logic.vipData.nextVipneedMoney
    self.vip1:setString(vipLevel)
    if vipLevel<=5 then
        self.vipbtnPageid = 1
    else
        self.vipbtnPageid = 2
    end
    if vipLevel==10 then
        self.vip2:setString(vipLevel)
        self.labelVipMoneyDesc:setString("达到vip最高等级10");
        self.vipRate:setString("100/100");
       
        local maxVipSize = {width=423,height=22};        
        self.vipSpriteRate:setTextureRect(CCRectMake(0,0,maxVipSize.width,maxVipSize.height))
    else
        self.vip2:setString(vipLevel+1)
        self.labelVipMoneyDesc:setString(string.format("还需充值%d元可达到VIP%d",nextVipneedMoney,vipLevel+1));
        self.vipRate:setString(self.logic.vipData.vipRate.."%");
       
        local maxVipSize = {width=423,height=22};        
        self.vipSpriteRate:setTextureRect(CCRectMake(0,0,maxVipSize.width*self.logic.vipData.vipRate/100,maxVipSize.height))
    end
    if vipLevel==0 then
        vipLevel = 1;
    end
    self:initVipBtnList(vipLevel)
    self:initVipDescList(vipLevel)
    self.loadVipPage=1
end
function ShopScene:initVipDescList(vipLevel)
    self.vipmiaoshuNode:removeAllChildrenWithCleanup(true)
    local i = 0
    for k,v in pairs(self.vipgongneng[vipLevel]) do
        i = i+1;
        local proxy = CCBProxy:create();
        local newtable = {};
        local node = CCBuilderReaderLoad("interfaces/VipGongNeng.ccbi",proxy,newtable);       
        newtable.labelVIpDesc = tolua.cast(newtable["labelVIpDesc"],"CCLabelTTF")
        newtable.spriteVipicon = tolua.cast(newtable["spriteVipicon"],"CCSprite")
        newtable.labelVIpDesc:setString(v.desc)
        -- setTexture(getCCTextureByName("images/DaTing/lobby_pic_fanye1.png"))
        newtable.spriteVipicon:setTexture(getCCTextureByName("images/VIP/"..v.img_icon..".png"))
        local w_i = i%5==0 and 5 or i%5

        local h_i = math.ceil(i/5);
        node:setPosition(159+205*(w_i-1),self["nodePosion"..h_i]:getPositionY())
        
        self.vipmiaoshuNode:addChild(node)
    end

end
function ShopScene:initVipBtnList(vipLevel)
    self.selecttabList = {}
    self.viptabBode:removeAllChildrenWithCleanup(true)
    local btn_start = 91;
    if gBaseLogic.sceneManager.currentPage.view.vipbtnPageid==2 then
        btn_start = 91-380;
    end
    for i=1,10 do
        local proxy = nil;
        proxy = CCBProxy:create();
        local newtable = nil;
        newtable = {}
        newtable.vipLevel = vipLevel;
        newtable.onPressvipSelect = function(self,asc,sender) 
            local selecttabList = gBaseLogic.sceneManager.currentPage.view.selecttabList
            local pageId = gBaseLogic.sceneManager.currentPage.view.vipbtnPageid
            local idx = sender:getTag();
            print("idx:"..idx)
            var_dump(selecttabList)
            idx = tonumber(idx)
            gBaseLogic.sceneManager.currentPage.view:initVipDescList(idx)
            if selecttabList[idx]~=nil then
                for k,v in pairs(selecttabList) do
                    if k==idx then
                        print(k)
                        v:setVisible(true)
                    else
                         print(k)
                        v:setVisible(false)
                    end
                end
            end

            if pageId==1 then
                if idx==8 or idx==7 then
                    local viptabBode=gBaseLogic.sceneManager.currentPage.view.viptabBode
                    local tox,toy = viptabBode:getPosition()
                    local actions = {};
                    actions[#actions + 1] = CCEaseExponentialOut:create(CCMoveTo:create(0.4, ccp(tox-380, toy)));
                    -- actions[#actions + 1] = CCCallFunc:create(handler(currentPop.view,currentPop.view.onAddToScene));
                    viptabBode:runAction(transition.sequence(actions));
                    gBaseLogic.sceneManager.currentPage.view.vipbtnPageid = 2
                end

            else
                if idx==3 or idx==4 then
                    local viptabBode=gBaseLogic.sceneManager.currentPage.view.viptabBode
                    local tox,toy = viptabBode:getPosition()
                    local actions = {};
                    actions[#actions + 1] = CCEaseExponentialOut:create(CCMoveTo:create(0.4, ccp(tox+380, toy)));
                    -- actions[#actions + 1] = CCCallFunc:create(handler(currentPop.view,currentPop.view.onAddToScene));
                    viptabBode:runAction(transition.sequence(actions));
                    gBaseLogic.sceneManager.currentPage.view.vipbtnPageid = 1
                end
            end
            -- gBaseLogic.sceneManager.currentPage.view:initVipBtnList(idx)
            -- self.ctrller:sendPluginPayRequest(idx);
        end 
        local node = CCBuilderReaderLoad("interfaces/VipTab.ccbi",proxy,newtable);
        -- newtable.ctrller = gBaseLogic.sceneManager.currentPage.ctrller;
        newtable.btnvipcheck = tolua.cast(newtable["btnvipcheck"],"CCControlButton")
        reSetControlButtonTitle(newtable.btnvipcheck,"VIP"..i)
        newtable.btnvipcheck:setTag(i)
        newtable.labelVip = tolua.cast(newtable["labelVip"],"CCLabelTTF")
        newtable.selectedNode = tolua.cast(newtable["selectedNode"],"CCLayer")
        newtable.labelVip:setString("VIP"..i)
        node:setPosition(btn_start+148*(i-1),0)
        newtable.selectedNode:setVisible(false)
        if i==vipLevel then
            newtable.selectedNode:setVisible(true)
        
        else
            newtable.selectedNode:setVisible(false)
        end
        table.insert(self.selecttabList,newtable.selectedNode)
        -- self.selecttabList[i] = newtable.selectedNode
        self.viptabBode:addChild(node)
        
    end
end

function ShopScene:onPressChargeRecord()
    print "onPressChargeRecord"
    izx.baseAudio:playSound("audio_menu");
    self.ctrller.shopType = 2;
    self:initBaseInfo()
    --self.shopSlider:setPositionX(self.chargeRecordItem:getPositionX())
    self:SliderMoveAction(self.shopSlider, self.chargeRecordItem:getPositionX(), nil,0.2)
    if (self.ctrller.data.historylist==nil) then
        self.ctrller:requestHTTShopHistory()
    else
        --self.tabViewLayer:init(2,self.ctrller.data.historylist)
        self:initTableView(self.tabViewLayer2,2,self.ctrller.data.historylist)
    end
    
end

function ShopScene:onPressSelectPayType()
    local pt = self.buttonSelt:convertToWorldSpace(ccp(0,0))
    local table = self.tabViewLayer:getChildByTag(101)
    print(pt.x,pt.y)
    self:showPayPad(table,gBaseLogic:getPayMidList(),pt.x-470,pt.y+45) 
end

function ShopScene:onInitView()
	self:initBaseInfo();

    --self:createTableView()
    -- if (self.ctrller.data.itemlist==nil) then
    --     self.ctrller:requestHTTShopData(0)
    -- else
    --     self.tabViewLayer:init(0,self.ctrller.data.itemlist)
    -- end
    
end

function ShopScene:initBaseInfo()
    if self.ctrller.shopType == 2 then 
        self.liBiaoNode:setVisible(true)
        self.vipNode:setVisible(false)
        print("222222222222222222222")
        self.tabViewLayer2:setVisible(true)
        self.tabViewLayer:setVisible(false)
        self.labelText2:setVisible(false)
        self.layerZhiFu:setVisible(false)
    elseif self.ctrller.shopType == 1 then
        self.liBiaoNode:setVisible(false)
        self.vipNode:setVisible(true)
    else
        print("0000000000000111111111")
        self.liBiaoNode:setVisible(true)
        self.vipNode:setVisible(false)
        self.tabViewLayer2:setVisible(false)
        self.tabViewLayer:setVisible(true)
        self:showPayType()
    end
end 

function ShopScene:getPayIconAndShow()
    local tmppayTypelist = gBaseLogic:getPayMidList()
    local fileName = nil
    var_dump(tmppayTypelist)
    for k,v in pairs(tmppayTypelist) do 
        if self.ctrller.shopType == 0 then 
            if v.mid == self.ctrller.payMid  and v.payTyp == self.ctrller.payType then 
                fileName = v.imgPrev
            end
        elseif self.ctrller.shopType == 1 then 
            if v.mid == self.ctrller.payMidvip and v.payTyp == self.ctrller.payTypevip then 
                fileName = v.imgPrev
            end 
        end    
    end 
    if nil == fileName then 
        print("getPayMidList value has ERROR !!!!")
        return
    end

    if fileName == "" then 
        fileName = "zhifufangshi_shoujiduanxin"
    else
        gBaseLogic.MBPluginManager.IAPType = fileName
    end                  
    fileName = fileName..".png"

    if (not io.exists(CCFileUtils:sharedFileUtils():fullPathForFilename("thirdparty/"..fileName))) then
        fileName = "images/ZhiFu/"..fileName                
    else
        fileName = "thirdparty/"..fileName
    end 
    print("fileName:",fileName)
    self.spriteItem:setTexture(getCCTextureByName(fileName))

    if #tmppayTypelist == 1 then
        --newtable.buttonSelt:setEnabled(false)
    end
end

function ShopScene:showPayType()
    if gBaseLogic.MBPluginManager.distributions.novip then 
        print("showPayType:",gBaseLogic.MBPluginManager.distributions.novip)
        self.labelText2:setVisible(false)
        self.layerZhiFu:setVisible(false) 
        return
    end 

    if self.ctrller.payMid == 0 then 
        print("33333333333333")
        self.labelText2:setVisible(true)
        self.layerZhiFu:setVisible(false)
        self.ctrller:getMaxPayMoney(self.labelText2)
    else
        print("44444444444444")
        self.labelText2:setVisible(false)
        self.layerZhiFu:setVisible(true)
        self.ctrller:getMaxPayMoney(self.labelText)
        self:getPayIconAndShow()
    end
      
end
--local TableViewLayer = require "izxFW.BaseTableView";
-- local TableViewLayer = class("TableViewLayer",require "izxFW.BaseTableView")
-- TableViewLayer.__index = TableViewLayer
-- typ=0 没网络，typ=1，socket断，typ=2, 被踢下线，msg=nil或空用默认的话，
function ShopScene:showPayPad(target,payTypelist,x,y)
    local popBoxPayType = {};
    --self.tabviewtouch = false
    if nil ~= target then 
        target:setTouchEnabled(false)
    end
    function popBoxPayType:onPressPayType(mid,type)
        local  current = gBaseLogic.sceneManager.currentPage
        if current.ctrller.shopType == 0 then
            if current.ctrller.payMid == mid and current.ctrller.payType == type then 
                current.view:closePopBox();
                return
            end
            CCUserDefault:sharedUserDefault():setIntegerForKey("UserPayMid",mid)
            CCUserDefault:sharedUserDefault():setStringForKey("UserPayType",type)
            current.ctrller.payMid = mid 
            current.ctrller.payType = type
        elseif current.ctrller.shopType == 1 then
            if current.ctrller.payMidvip == mid and current.ctrller.payTypevip == type then 
                current.view:closePopBox();
                return
            end
            CCUserDefault:sharedUserDefault():setIntegerForKey("UserPayMidVip",mid)
            CCUserDefault:sharedUserDefault():setStringForKey("UserPayTypeVip",type)
            current.ctrller.payTypevip = type 
            current.ctrller.payMidvip = mid 
        end 

        for k,v in pairs(payTypelist) do
            if v.mid==mid and v.imgPrev~="" then
                gBaseLogic.MBPluginManager.IAPType = v.imgPrev
            end
        end
        
        current.ctrller:checkPayType()
        current.view:initTableView(current.view.tabViewLayer,0,current.ctrller.payitemslist)

        local tabview = current.view.tabViewLayer:getChildByTag(101)
        if nil ~= tabview then 
            tabview:setTouchEnabled(false)
        end

        current.view:showPayType()
        current.view:closePopBox()
    end 

    function popBoxPayType:onClosePopBox()
        --self.tabviewtouch = true
        local tabview = gBaseLogic.sceneManager.currentPage.view.tabViewLayer:getChildByTag(101)
        if nil ~= tabview then 
            tabview:setTouchEnabled(true)
        end
    end 
    
    function popBoxPayType:checkFileIsExist(fileName)
        if (not io.exists(CCFileUtils:sharedFileUtils():fullPathForFilename("thirdparty/"..fileName))) then
            fileName = "images/ZhiFu/"..fileName    
        else
            fileName = "thirdparty/"..fileName            
        end 
        print("---:"..fileName)
        return fileName
    end

    function popBoxPayType:onAssignVars()
        local i = 0;
        local j = 1;
        if (payTypelist == nil) then
            return
        end 
        if nil ~= self["spritePaypad"] then
            self.spritePaypad = tolua.cast(self["spritePaypad"],"CCSprite")
        end
        local tmpshopType = gBaseLogic.sceneManager.currentPage.ctrller.shopType
        --for k=0 , 6 do 
            for k,v in pairs(payTypelist) do
                if i >= 3 then
                    i = 0
                    j = 0
                end 

                print(v.imgPrev,tmpshopType,v.payTyp)
                if tmpshopType == 1 and v.payTyp == 'SMS' then 
                else 
                    local fileName = v.imgPrev
                    if fileName == "" then 
                        fileName = "zhifufangshi_shoujiduanxin"
                    end 
                    local thisButton = cc.ui.UIPushButton.new({
                        normal = self:checkFileIsExist(fileName.."01.png"),
                        pressed = self:checkFileIsExist(fileName.."02.png"),
                        disabled = self:checkFileIsExist(fileName.."01.png")
                    }, {scale9 = false})
                    :onButtonClicked(function(event)
                            self:onPressPayType(v.mid, v.payTyp);
                        end)
                    :align(display.BOTTOM_LEFT,  i*220+50, j*115+55)
                    :addTo(self.spritePaypad);
                    i = i+1;
                end
            end 
        --end
    end
    
    gBaseLogic.sceneManager.currentPage.view:showPopBoxCCB("interfaces/DaoJuZhiFu.ccbi",popBoxPayType,true,1)
    gBaseLogic.sceneManager.currentPage.view.nodePopBox:setPosition(x,y);

end

function ShopScene.cellSizeForTable(table,idx)
    return 113,1136
end
function ShopScene.numberOfCellsInTableView(table)
    -- var_dump(table.data);
    local data = table:getParent().data;
    return #data
end
function ShopScene.tableCellAtIndex(table, idx)
    local cell = table:dequeueCell()
    local label = nil
    if nil == cell then        
        cell = CCTableViewCell:new()
    else
        cell:removeAllChildrenWithCleanup(true);
    end 
    local winSize = CCDirector:sharedDirector():getWinSize()
    
    if (table:getParent().type==2) then
        --{"boxId":442,"desc":"游戏币x120000,记牌器x30,招财猫表情包x15","money":10,"order":"201402267095759172","status":0,"timeStr":"02-26 14:22","tn":"实物","type":1,"uid":1501134337144068}
        local itemInfo = table:getParent().data[idx+1];
        local proxy = CCBProxy:create();
        local table = {};
        
        local node = CCBuilderReaderLoad("interfaces/ShangDianJiLu.ccbi",proxy,table);
        var_dump(itemInfo)
        table.labelorder = tolua.cast(table["labelorder"],"CCLabelTTF")
        table.labeldesc = tolua.cast(table["labeldesc"],"CCLabelTTF")
        table.labelday = tolua.cast(table["labelday"],"CCLabelTTF")
        table.labelsuc = tolua.cast(table["labelsuc"],"CCLabelTTF")
        table.labelerr = tolua.cast(table["labelerr"],"CCLabelTTF")
        table.spriteimg = tolua.cast(table["spriteimg"],"CCSprite")
        table.labelorder:setString(itemInfo.order)
        table.labeldesc:setString(itemInfo.desc)
        table.labelday:setString(itemInfo.timeStr)
        if itemInfo.status==0 then
            table.labelsuc:setVisible(true)
            table.labelerr:setVisible(false)
        else
            table.labelerr:setVisible(true)
            table.labelsuc:setVisible(false)
        end 
        if gBaseLogic.lobbyLogic.paymentItemList ~= nil then
            for k,v in pairs(gBaseLogic.lobbyLogic.paymentItemList) do 
                print("boxid:"..v.boxid)
                if v.boxid == itemInfo.boxId  then
                    izx.resourceManager:imgFileDown(v.icon,true,function(fileName) 
                    table.spriteimg:setTexture(getCCTextureByName(fileName))
                    end);
                end 
            end 
        end

        -- local sprite = CCSprite:create("images/DaoJu/baoxiang05.png")
        -- sprite:setAnchorPoint(ccp(0,0))
        -- sprite:setPosition(ccp(40, 5))
        -- cell:addChild(sprite)
     
        -- sprite = CCSprite:create("images/LieBiao/list_bg_fenge.png")
        -- sprite:setPosition(ccp(winSize.width/2, 2))
        -- cell:addChild(sprite)

        -- label = CCLabelTTF:create("订单号："..table:getParent().data[idx+1].order, "Helvetica", 20.0)
        -- label:setPosition(ccp(200,60))
        -- label:setAnchorPoint(ccp(0,0))
        cell:addChild(node)
    elseif (table:getParent().type==0 or table:getParent().type==1) then
        
        local proxy = CCBProxy:create();
        local newtable = {};
        --[[
        local tmppayType = gBaseLogic.sceneManager.currentPage.ctrller.payType
        if tmppayType == 0 then 
            idx = idx +1
        end
        
        if idx == 0 then 
            local tmppayTypelist = gBaseLogic:getPayMidList()

            newtable.onPressSelectPayType = function(self,asc,sender) 
                local pt = sender:convertToWorldSpace(ccp(0,0))
                print(pt.x,pt.y)
                gBaseLogic.sceneManager.currentPage.view:showPayPad(table,tmppayTypelist,pt.x-450,pt.y+50) 
                
            end 
            
            local node = CCBuilderReaderLoad("interfaces/ShangDianDaoJuZhiFu.ccbi",proxy,newtable);
            newtable.spriteItem = tolua.cast(newtable["spriteItem"],"CCSprite")
            newtable.buttonSelt = tolua.cast(newtable["buttonSelt"],"CCControlButton")
            newtable.labelText = tolua.cast(newtable["labelText"],"CCLabelTTF")

            --newtable.labelText:setString(gBaseLogic.sceneManager.currentPage.ctrller.maxMoney)
            gBaseLogic.sceneManager.currentPage.ctrller:getMaxPayMoney(newtable.labelText)

            var_dump(tmppayTypelist)
            for k,v in pairs(tmppayTypelist) do 
                if v.mid == tmppayType  then   
                    local fileName = v.imgPrev
                    if fileName == "" then 
                        fileName = "zhifufangshi_shoujiduanxin"
                    end                  
                    fileName = fileName..".png"

                    if (not io.exists(CCFileUtils:sharedFileUtils():fullPathForFilename(fileName))) then
                        fileName = "images/ZhiFu/"..fileName                
                    end 
                    print("fileName:"..fileName)
                    newtable.spriteItem:setTexture(getCCTextureByName(fileName))
                    
                end 
            end 
            
            if #tmppayTypelist == 1 then
                --newtable.buttonSelt:setEnabled(false)
            end
            cell:addChild(node)
            return cell
        end  
        ]]
        newtable.onPressBuy = function(self,asc,sender) 
            
            local idx = sender:getTag();
            self.ctrller:sendPluginPayRequest(idx);
        end 
        idx = idx +1
        local itemInfo = table:getParent().data[idx];
       
        local node = CCBuilderReaderLoad("interfaces/ShangDianDaoJu.ccbi",proxy,newtable);
        newtable.ctrller = gBaseLogic.sceneManager.currentPage.ctrller;
        newtable.labelItemName = tolua.cast(newtable["labelItemName"],"CCLabelTTF")
        newtable.labelItemDesc = tolua.cast(newtable["labelItemDesc"],"CCLabelTTF")
        newtable.labelItemPrice = tolua.cast(newtable["labelItemPrice"],"CCLabelTTF")
        newtable.spriteItem = tolua.cast(newtable["spriteItem"],"CCSprite")

        izx.resourceManager:imgFileDown(itemInfo.icon,true,function(fileName) 
            if newtable~=nil and newtable.spriteItem~=nil then
                newtable.spriteItem:setTexture(getCCTextureByName(fileName))
            end
        end);
        local send_money = 0
        local this_desc = ""
        local isshuangbei=1
        if in_table(itemInfo.boxid,gBaseLogic.lobbyLogic.doubleChestids) then
            isshuangbei=2
        end

        if itemInfo.content~=nil then
            -- local sortFunc = function(a, b) 
            --     if a.idx>=b.idx then
            --         return true;
            --     else
            --         return false;
            --     end

            -- end
            -- local contentList = {};
            -- for k,v in pairs(itemInfo.content) do
            --     table.insert(contentList,v)
            -- end
            
            -- table.sort(contentList,function(a, b) 
            --     if a.idx>=b.idx then
            --         return true;
            --     else
            --         return false;
            --     end

            -- end)
            for k,v in pairs(itemInfo.content) do
                if v.idx==0 then
                    send_money = v.num
                else
                    if gBaseLogic.lobbyLogic.userData.items_user[v.idx]~=nil then
                        if v.idx==5 then
                            this_desc= this_desc..",招财猫表情包"
                        elseif v.idx==2 then
                            this_desc= this_desc..","..gBaseLogic.lobbyLogic.userData.items_user[v.idx].name_..(v.num*isshuangbei).."个"
                        else
                            this_desc= this_desc..","..gBaseLogic.lobbyLogic.userData.items_user[v.idx].name_..v.num.."个"
                        end
                    end
                end
            end
        end
        local desc = ""
        if in_table(itemInfo.boxid,gBaseLogic.lobbyLogic.doubleChestids) then
            local shuangbei = display.newSprite("images/TanChu/shuangbei.png", 0, 0)
            newtable.nodeshuangbei:addChild(shuangbei)
            send_money = send_money*2;
            if send_money~=0 then

                desc = "含".. math.floor(send_money/10000).."万游戏币"..this_desc.."（限购一次）";
            else
                desc = "含"..this_desc.."（限购一次）";
            end
        else
            if send_money~=0 then
                desc = "含".. math.floor(send_money/10000).."万游戏币"..this_desc;
            else
                desc = itemInfo.desc
            end
        end


        -- local imgSpiteList = string.split(itemInfo.icon, '/');                 
        -- local tFiles = gBaseLogic.DownloadPath .. imgSpiteList[#imgSpiteList];
        -- -- local tFiles = gBaseLogic.DownloadPath .. "shopitem_"..boxid .. ".png";
        -- if io.exists(tFiles) == false then  
        --     gBaseLogic:img_file_down(tFiles,itemInfo.icon,function() 
        --         table.spriteItem:setTexture(getCCTextureByName(tFiles))
        --         end)
        -- else 
        --     -- v.local_img = tFiles;
        --     table.spriteItem:setTexture(getCCTextureByName(tFiles))
        -- end
         
        newtable.btnBuy = tolua.cast(newtable["btnBuy"],"CCControlButton")
        newtable.btnBuy:setTag(idx);
        newtable.labelItemPrice:setString("价格：￥"..itemInfo.price ..".00")
        newtable.labelItemName:setString(itemInfo.boxname)
        newtable.labelItemDesc:setString(desc)
 
        cell:addChild(node)
    end

    return cell
end

function ShopScene:initTableView(target,type,data)
    if #data==0  then
        target:removeAllChildrenWithCleanup(true);
        target.type = type;
        target.data = data;
        if type==2 then            
            ShowNoContentTip(target,"没有充值记录")
        else
            ShowNoContentTip(target,"暂无商品")
        end
        return 
    end
    
    --local winSize = self.tabViewLayer:getContentSize()
    --TableViewLayer.initdata(target,CCSizeMake(winSize.width,winSize.height),type,data, self);
    local winSize = resolutionFixedWidth(target,640)
    print("initTableView");
    var_dump(data)
    print(gBaseLogic.MBPluginManager.distributions.novip)
    if gBaseLogic.MBPluginManager.distributions.novip then 
        winSize.height = winSize.height + 112
    end 
    createTabView(target,winSize,type,data, self);
    return 
end

function ShopScene:createTableView()
    --self.tabViewLayer = TableViewLayer.extend(tolua.cast(self["tabViewLayer"],"CCLayer"))
    TableViewLayer.create(self.tabViewLayer,tolua.cast(self["tabViewLayer"],"CCLayer"))

end

return ShopScene;