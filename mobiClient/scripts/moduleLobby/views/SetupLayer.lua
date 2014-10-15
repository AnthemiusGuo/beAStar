local SetupLayer = class("SetupLayer",izx.baseView)

function SetupLayer:ctor(pageName,moduleName,initParam)
	print ("SetupLayer:ctor")
    self.super.ctor(self,pageName,moduleName,initParam);
end

function SetupLayer:onAddToScene()
    --self.rootNode:setPosition(cc.p(display.cx,display.cy));
end

function SetupLayer:onAssignVars()
	--var_dump(self);
	self.rootNode = tolua.cast(self.rootNode,"CCNode");
 
    if nil ~= self["shezhiBack"] then
    	self.shezhiBack = tolua.cast(self["shezhiBack"],"CCSprite")
    end
    self.holderSlider1 = tolua.cast(self["holderSlider1"],"CCNode")
    self.holderSlider2 = tolua.cast(self["holderSlider2"],"CCNode")
end

function SetupLayer:onInitView()
	self:initBaseInfo();
end

function SetupLayer:initBaseInfo()
    local function valueChanged(strEventName,pSender)
            if nil == pSender  then
                return
            end
            local pControl = tolua.cast(pSender,"CCControlSlider")
            local strFmt = nil
            if pControl:getTag() == 1 then
                --strFmt = string.format("Upper slider value = %.02f",pControl:getValue())
                izx.baseAudio:SetEffectValue(pControl:getValue());
            elseif pControl:getTag() == 2 then
                --strFmt = string.format("Lower slider value = %.02f",pControl:getValue())
                izx.baseAudio:SetAudioValue(pControl:getValue());
            end
    end
    --Add the slider
    local pSlider = CCControlSlider:create("images/TanChu/popup_pic_jindu1.png","images/TanChu/popup_pic_jindu2.png" ,"images/LieBiao/list_btn_huadong1.png")
    pSlider:setMinimumValue(0.0)
    pSlider:setMaximumValue(1.0)
    pSlider:setScale(0.9)
    pSlider:setAnchorPoint(ccp(0.5, 0.5))
    pSlider:setPosition(ccp(39, 0))
    pSlider:setValue(izx.baseAudio.fEffectVal)
    pSlider:addHandleOfControlEvent(valueChanged, CCControlEventValueChanged)
    pSlider:setTag(1)
    self.holderSlider1:addChild(pSlider)

    pSlider = CCControlSlider:create("images/TanChu/popup_pic_jindu1.png","images/TanChu/popup_pic_jindu2.png" ,"images/LieBiao/list_btn_huadong1.png")
    pSlider:setMinimumValue(0.0)
    pSlider:setMaximumValue(1.0)
    pSlider:setScale(0.9)
    pSlider:setAnchorPoint(ccp(0.5, 0.5))
    pSlider:setPosition(ccp(39, 0))
    pSlider:setValue(izx.baseAudio.fMusicVal)
    pSlider:addHandleOfControlEvent(valueChanged, CCControlEventValueChanged)
    pSlider:setTag(2)
    self.holderSlider2:addChild(pSlider)
end

function SetupLayer:onPressBack()
    print "onPressBack"
    izx.baseAudio:playSound("audio_menu");
    gBaseLogic.sceneManager:removePopUp("SetupLayer");
end

return SetupLayer;