local YouXiTanChuLayer = class("YouXiTanChuLayer",izx.baseView)

--type:1,游戏弹出 2：短代弹出 3：元宝不够 4:vip购买短代 
--tyoe:1003:推廣員綁定信息,1004,1005 单机机器人
--type：1000 普通情况 type=其他也为普通弹出
function YouXiTanChuLayer:ctor(pageName,moduleName,initParam)
	print ("YouXiTanChuLayer:ctor")
    self.type = initParam.type;
    self.btnTxt = initParam.btnTxt
    -- self.money = initParam.money
    self.initParam = initParam

    self.super.ctor(self,pageName,moduleName,initParam);

end


function YouXiTanChuLayer:onAssignVars() 
    
	self.rootNode = tolua.cast(self.rootNode,"CCNode");
	 
    

    if nil ~= self["labelTips"] then
        self.labelTips = tolua.cast(self["labelTips"],"CCLabelTTF")
    end
    if nil ~= self["labelTitile"] then
        self.labelTitile = tolua.cast(self["labelTitile"],"CCLabelTTF")
    end
    if nil ~= self["btnConfirm"] then
        self.btnConfirm = tolua.cast(self["btnConfirm"],"CCControlButton")
    end
--     MAC8(MAC8) 14:59:50
-- labelTitile
-- MAC8(MAC8) 14:59:59
-- btnConfirm
 


end
-- function YouXiTanChuLayer:onPressToLaba()
--     print ("YouXiTanChuLayer:onPressConfirm")
--     self:onPressClose();
--     self.logic:startMiniGame(100);
-- end
-- function YouXiTanChuLayer:onPressToYaoyaole()
--     print ("YouXiTanChuLayer:onPressConfirm")
--     self:onPressClose();
--     self.logic:startMiniGame(101);
-- end

function YouXiTanChuLayer:onPressBack()
    print ("YouXiTanChuLayer:onPressBack")
    izx.baseAudio:playSound("audio_menu");
    self:onPressClose();
end

function YouXiTanChuLayer:onPressClose()
    print ("YouXiTanChuLayer:onPressClose")
    izx.baseAudio:playSound("audio_menu");
    gBaseLogic.sceneManager:removePopUp("YouXiTanChuLayer");
    if self.type==2 then 
            local needMoney = self.initParam.needMoney;
            if needMoney == nil or needMoney<0 then
                needMoney = 0
            end
            local subtyp = 0
            if self.initParam.subtyp~= nil then
                subtyp = self.initParam.subtyp
            end
            gBaseLogic.scheduler.performWithDelayGlobal(function()
                gBaseLogic:onNeedMoney("gameenter",needMoney,subtyp);
                end, 0.1)
        
    elseif self.type==4 then
        local needMoney = self.initParam.needMoney;
        if needMoney == nil or needMoney<0 then
            needMoney = 0
        end
        local nextVipneedMoney = self.logic.vipData.nextVipneedMoney
        local items = {};
        for k,v in pairs(self.logic.payItemNormal) do
            table.insert(items,v)
        end
        
        local sortFunc = function(a, b)     
            if  a.price<b.price then
                return true
            else 
                return false
            end
        end
        table.sort(items,sortFunc)
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
    if self.type == 1003 then 
        gBaseLogic.lobbyLogic:dispatchLogicEvent({
                    name = "MSG_ifBinding_send",
                    message = ''
                });
    end 
    if self.type == 1004 then 
        print("MSG_robotMonery_rst_send 1004")
        gBaseLogic.gameLogic:dispatchLogicEvent({
                    name = "MSG_robotMonery_rst_send",
                    message = "START"
                });
        
    end
    if self.type == 1005 then 
        print("MSG_robotMonery_rst_send 1005")
        gBaseLogic.gameLogic:dispatchLogicEvent({
                    name = "MSG_robotMonery_rst_send",
                    message = "COLSE"
                });
    end 
    if self.type == 1006 then 
        print("MSG_robotMonery_rst_send 1006")
        gBaseLogic.gameLogic:dispatchLogicEvent({
                    name = "MSG_robotMonery_rst_send",
                    message = "OK"
                });
    end 
    if self.type == 1007 then 
        print("MSG_robotMonery_rst_send 1007")
        gBaseLogic.gameLogic:dispatchLogicEvent({
                    name = "MSG_robotMonery_rst_send",
                    message = "ERROR"
                });
    end
    
    if self.type == 1008 then 
        print("MSG_robotMonery_rst_send 1008")
        gBaseLogic.gameLogic:dispatchLogicEvent({
                    name = "MSG_robotMonery_rst_send",
                    message = "BEETERSEAT"
                });
    end

end
 
function YouXiTanChuLayer:onInitView()
    print ("YouXiTanChuLayer:onInitView")
    
    self:initBaseInfo();
    
end

 
function YouXiTanChuLayer:initBaseInfo()
    self.labelTips:setString(self.initParam.msg);
    --local tmpTxt = "确 定"
    if nil ~= self.btnTxt then 
        local tempString = CCString:create(self.btnTxt)
        self.btnConfirm:setTitleForState(tempString,CCControlStateNormal);
    end
end
 
function YouXiTanChuLayer:onPressConfirm()
    if self.type==1 then
        local level = 1;
        local userMoney = self.logic.userData.ply_lobby_data_.money_
        if (userMoney>50000) then
            level = 3;
        elseif userMoney>10000 then
            level = 2;
        end
        self.logic:startGameByTypLevel2(self.initParam.gameType,level);   
         
    elseif self.type==3 then
        gBaseLogic.scheduler.performWithDelayGlobal(function()
            self.logic:showXinShouTiShiLayer(1);
            end, 0.1)
        -- self.logic.showXinShouTiShiLayer(1);
      
    elseif self.type==1001 then
        self:onPressClose();
        gBaseLogic.lobbyLogic:showNewbieGuide("login")
   
    end
    if self.initParam.cback~=nil then
        local cback= self.initParam.cback;
        cback();
    end

    self:onPressClose();
end 

function YouXiTanChuLayer:onAddToScene()
	self.rootNode:setPosition(ccp(display.cx,display.cy));
end

return YouXiTanChuLayer;