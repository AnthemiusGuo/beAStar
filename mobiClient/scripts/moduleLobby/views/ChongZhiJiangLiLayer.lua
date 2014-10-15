local ChongZhiJiangLiLayer = class("ChongZhiJiangLiLayer",izx.baseView)

function ChongZhiJiangLiLayer:ctor(pageName,moduleName,initParam)
	print ("ChongZhiJiangLiLayer:ctor")
    self.super.ctor(self,pageName,moduleName,initParam);

end


function ChongZhiJiangLiLayer:onAssignVars() 
    
	self.rootNode = tolua.cast(self.rootNode,"CCNode");
	 
    

    if nil ~= self["labelContent"] then
        self.labelContent = tolua.cast(self["labelContent"],"CCLabelTTF")
    end
    if nil ~= self["labelAwardDesc"] then
        self.labelAwardDesc = tolua.cast(self["labelAwardDesc"],"CCLabelTTF")
    end
    if nil ~= self["labelTishi"] then
        self.labelTishi = tolua.cast(self["labelTishi"],"CCLabelTTF")
    end
    if nil ~= self["labelTitle"] then
        self.labelTitle = tolua.cast(self["labelTitle"],"CCLabelTTF")
    end

    if nil ~= self["gouSprite"] then
        self.gouSprite = tolua.cast(self["gouSprite"],"CCSprite")
    end
    if nil ~= self["gouBackSprite"] then
        self.gouBackSprite = tolua.cast(self["gouBackSprite"],"CCSprite")
    end
    
    


end

function ChongZhiJiangLiLayer:onPressAward()
    print ("ChongZhiJiangLiLayer:onPressAward")
    izx.baseAudio:playSound("audio_menu");
    -- if true then
    --     self.logic.getPayNum = 0;
    --     self:initgetAward(100)
    --     self.logic:dispatchLogicEvent({
    --         name = "MSG_Socket_ChongZhiJiangLi",
    --         message = self.logic.payInitList
    --     })
    --     return;
    -- end
    if tonumber(self.logic.payInitList.payMoney)>=tonumber(self.logic.getPayNum) then
        
        gBaseLogic:blockUI()
        self.ctrller:getChongZhiJiangLiAward()
    else
        print("sss去购买")
        self:onPressBack()
        local money = tonumber(self.logic.getPayNum)-tonumber(self.logic.payInitList.payMoney)
        local msg = "再充值 "..money .." 元领取任务奖励！"
        self.logic:showChongZhiShangPin({money=money,msg=msg})
        return;
    end   
end

function ChongZhiJiangLiLayer:onPressBack()
    print ("ChongZhiJiangLiLayer:onPressBack")
    izx.baseAudio:playSound("audio_menu");
    self:onPressClose();
end

function ChongZhiJiangLiLayer:onPressClose()
    print ("ChongZhiJiangLiLayer:onPressClose")
    izx.baseAudio:playSound("audio_menu");
    gBaseLogic.sceneManager:removePopUp("ChongZhiJiangLiLayer");
end
 
function ChongZhiJiangLiLayer:onInitView()
    print ("ChongZhiJiangLiLayer:onInitView")
    self:initBaseInfo();
    
    
end

 
function ChongZhiJiangLiLayer:initBaseInfo()
    self.gouSprite:setVisible(false)
    self.gouBackSprite:setVisible(false)
    self.nodeBtn:removeAllChildrenWithCleanup(true);
    self.nodeBtn:setVisible(false)
    self.btnConfirm:setVisible(true)
    if self.logic.payInitList==nil then
        self.labelTitle:setString("暂无充值任务奖励")
        self.labelAwardDesc:setString("")
        self.btnConfirm:setVisible(false)
        self.labelTishi:setString("")
        self.labelContent:setString("")
        return
    end
    self.labelTitle:setString("累计"..self.logic.getPayNum .."元充值任务奖励")
    self.labelAwardDesc:setString("累计"..self.logic.getPayNum .."元充值任务奖励内含：")
    local tishimsg = ""
    local hasDone = 0;
    if tonumber(self.logic.payInitList.payMoney)>=tonumber(self.logic.getPayNum) then
        tishimsg = "您当前累计充值 "..self.logic.payInitList.payMoney.." 元，现在可以领取任务奖励啦！"
        hasDone = 1
    else
        tishimsg = "您当前累计充值 "..self.logic.payInitList.payMoney.." 元，再充值 "..tonumber(self.logic.getPayNum)-tonumber(self.logic.payInitList.payMoney) .." 元可领取任务奖励"
        hasDone = 0
    end
    local awardReval = 0;
    local itemList = {}
    for k,v in pairs(self.logic.payInitList.items) do
        if v.awardMoney==self.logic.getPayNum then
            awardReval = v.awardReval
            itemList = v.awardMx
            -- "awardMoney":10,"awardId":52,"awardStatus":1
            self.ctrller.curAwardId = v.awardId
            self.ctrller.curAwardStatus = v.awardStatus
            break;
        end
    end

    self.labelTishi:setString(tishimsg)
    self.labelContent:setString("奖励总价值:￥"..awardReval)
    self.nodeDaoju:removeAllChildrenWithCleanup(true);
    for k,itemInfo in pairs(itemList) do 
        local proxy = CCBProxy:create();
        local table = {};
        local node = CCBuilderReaderLoad("interfaces/ChongZhiJiangLiNode.ccbi",proxy,table);
        self.nodeDaoju:addChild(node)
        node:setPosition(-239+(151*(k-1)),-33)
        table.labelDaoJu = tolua.cast(table["labelDaoJu"],"CCLabelTTF")
        table.labelDaoJu:setString(izx.UTF8.sub(itemInfo.itemName, 1, 5))
        table.labelDaoJu:setFontSize(16)
        table.labelNum = tolua.cast(table["labelNum"],"CCLabelTTF")
        table.daoJuSprite = tolua.cast(table["daoJuSprite"],"CCSprite")
        -- izx.UTF8.sub(str, startChar, numChars)
        table.labelNum:setString("+"..itemInfo.itemNum.."个")
        table.daoJuSprite:setTexture(getCCTextureByName("images/DaoJu/daoju"..itemInfo.itemIndex ..".png"))
    end
	
end

function ChongZhiJiangLiLayer:initgetAward(money)
    self.gouSprite:setVisible(true)
    self.gouBackSprite:setVisible(true)
    self.nodeBtn:setVisible(true)
    self.btnConfirm:setVisible(false)
    self.labelTishi:setString("成功领取了累计"..money .."元充值的任务奖励")
    if (self.logic.getPayNum~=0) then
        cc.ui.UIPushButton.new("images/TanChu/popup_btn_huang1.png", {scale9 = true})
                :setButtonSize(159, 55)
                :setButtonLabel("normal", ui.newTTFLabel({
                    text = "查看"..self.logic.getPayNum.."元充值任务",
                    size = 16
                }))
                :setButtonLabel("pressed", ui.newTTFLabel({
                    text = "查看"..self.logic.getPayNum.."元充值任务",
                    size = 16,
                    color = ccc3(255, 255, 255)
                }))
                :setButtonLabel("disabled", ui.newTTFLabel({
                    text = "查看"..self.logic.getPayNum.."元充值任务",
                    size = 16,
                    color = ccc3(0, 0, 0)
                }))
                :onButtonClicked(function(event)
                    print(111);
                    self:initBaseInfo();
                end)
                :addTo(self.nodeBtn)
    end
end
 
 
 
function ChongZhiJiangLiLayer:onAddToScene()
    self.rootNode:setPosition(ccp(display.cx,display.cy));
end

return ChongZhiJiangLiLayer;