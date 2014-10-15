local XinShouTiShiLayer = class("XinShouTiShiLayer",izx.baseView)

function XinShouTiShiLayer:ctor(pageName,moduleName,initParam)
	print ("XinShouTiShiLayer:ctor")
    self.typNum = initParam.num;
    self.super.ctor(self,pageName,moduleName,initParam);

end


function XinShouTiShiLayer:onAssignVars() 
    
	self.rootNode = tolua.cast(self.rootNode,"CCNode");
	 
    
    if nil ~= self["labelDesc"] then
        self.labelDesc = tolua.cast(self["labelDesc"],"CCLabelTTF")

        if(self.typNum == 3)then
            --self.labelDesc:setString("当您的游戏币大于"..(tonumber(gBaseLogic.MBPluginManager.distributions.yaoyaoleneedmoney)/10000).."W以上，不妨玩玩这款骰子游戏，与高端玩家欢聚一桌，快来试试运气吧！真人美女荷官邀您一起游戏");
            self.labelDesc:setString("不妨玩玩这款骰子游戏，与高端玩家欢聚一桌，快来试试运气吧！真人美女荷官邀您一起游戏");
        end
    end
    if nil ~= self["labelGift"] then
        self.labelGift = tolua.cast(self["labelGift"],"CCLabelTTF")
    end
--     labelTitle
-- MAC8(MAC8) 14:42:17
-- onPressToLaba
-- MAC8(MAC8) 14:42:51
-- onPressToYaoyaole


end
function XinShouTiShiLayer:onPressToLaba()
    print ("XinShouTiShiLayer:onPressConfirm")
    izx.baseAudio:playSound("audio_menu");
    self:onPressClose();
    self.logic:startMiniGame(100);
end
function XinShouTiShiLayer:onPressToYaoyaole()
    print ("XinShouTiShiLayer:onPressConfirm")
    izx.baseAudio:playSound("audio_menu");
    self:onPressClose();
    self.logic:startMiniGame(101);
end

function XinShouTiShiLayer:onPressBack()
    print ("XinShouTiShiLayer:onPressBack")
    izx.baseAudio:playSound("audio_menu");
    self:onPressClose();
end

function XinShouTiShiLayer:onPressClose()
    print ("XinShouTiShiLayer:onPressClose")
    izx.baseAudio:playSound("audio_menu");
    gBaseLogic.sceneManager:removePopUp("XinShouTiShiLayer");
    
end 

function XinShouTiShiLayer:onPressConfirm()
    print ("XinShouTiShiLayer:onPressConfirm")
    izx.baseAudio:playSound("audio_menu");
    gBaseLogic.sceneManager:removePopUp("XinShouTiShiLayer");
    if self.typNum == 4 then 
        gBaseLogic.lobbyLogic:showPromotionScene({type=2}); 
    end
end 

function XinShouTiShiLayer:onPressCancel()
    self:onPressClose()
end
 
function XinShouTiShiLayer:onInitView()
    print ("XinShouTiShiLayer:onInitView")
    self:initBaseInfo();
    
end

 
function XinShouTiShiLayer:initBaseInfo()
	 if (self.typNum==1) then
        self.labelGift:setString("数量:"..self.logic.userData.ply_lobby_data_.gift_)
     end 
end
 
function XinShouTiShiLayer:onPressDuihuan()
    self.logic:showAwardExchangeScene()
end
function XinShouTiShiLayer:onAddToScene()
	self.rootNode:setPosition(ccp(display.cx,display.cy));
end

return XinShouTiShiLayer;