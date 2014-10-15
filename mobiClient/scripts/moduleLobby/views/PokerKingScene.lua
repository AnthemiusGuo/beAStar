local PokerKingScene = class("PokerKingScene",izx.baseView)

function PokerKingScene:ctor(pageName,moduleName,initParam)
	print ("PokerKingScene:ctor")
    self.super.ctor(self,pageName,moduleName,initParam);
end


function PokerKingScene:onAssignVars()
	--var_dump(self);
	self.rootNode = tolua.cast(self.rootNode,"CCNode");

	if nil ~= self["pokerKingLayer"] then
        self.pokerKingLayer = tolua.cast(self["pokerKingLayer"],"CCLayer")
    end
    if nil ~= self["joinLayer"] then
        self.joinLayer = tolua.cast(self["joinLayer"],"CCLayer")
    end
    if nil ~= self["pokerKingSlider"] then
        self.pokerKingSlider = tolua.cast(self["pokerKingSlider"],"CCSprite")
    end
     if nil ~= self["lastDayItem"] then
        self.lastDayItem = tolua.cast(self["lastDayItem"],"CCControl")
    end
    if nil ~= self["todayItem"] then
        self.todayItem = tolua.cast(self["todayItem"],"CCControl")
    end
    if nil ~= self["joinItem"] then
        self.joinItem = tolua.cast(self["joinItem"],"CCControl")
    end
end

function PokerKingScene:onPressBack()
    print "onPressBack"
    izx.baseAudio:playSound("audio_menu");
    gBaseLogic.lobbyLogic:goBackToMain();
end

function PokerKingScene:onPressLastDay()
    print "onPressLastDay"
    izx.baseAudio:playSound("audio_menu");
    self.pokerKingSlider:setPositionX(self.lastDayItem:getPositionX())
    if self.pokerKingLayer:isVisible() == false then
        self.pokerKingLayer:setVisible(true)
        self.initlayer:setVisible(false)
        self.initlayer = self.pokerKingLayer
    end
end

function PokerKingScene:onPressToday()
    print "onPressToday"
    izx.baseAudio:playSound("audio_menu");
    self.pokerKingSlider:setPositionX(self.todayItem:getPositionX())
    if self.pokerKingLayer:isVisible() == false then
        self.pokerKingLayer:setVisible(true)
        self.initlayer:setVisible(false)
        self.initlayer = self.pokerKingLayer
    end
end

function PokerKingScene:onPressJoin()
    print "onPressJoin"
    izx.baseAudio:playSound("audio_menu");
    self.pokerKingSlider:setPositionX(self.joinItem:getPositionX())
    if self.joinLayer:isVisible() == false then
        self.joinLayer:setVisible(true)
        self.initlayer:setVisible(false)
        self.initlayer = self.joinLayer
    end
end

function PokerKingScene:onInitView()
	self:initBaseInfo();
end

function PokerKingScene:initBaseInfo()
    self.initlayer = self.pokerKingLayer;
end

return PokerKingScene;
