local NoticeScene = class("NoticeScene",izx.baseView)

function NoticeScene:ctor(pageName,moduleName,initParam)
	print ("NoticeScene:ctor")
    self.super.ctor(self,pageName,moduleName,initParam);
end


function NoticeScene:onAssignVars()
	--var_dump(self);
	self.rootNode = tolua.cast(self.rootNode,"CCNode");

	if nil ~= self["noticeSlider"] then
        self.noticeSlider = tolua.cast(self["noticeSlider"],"CCSprite")
    end
    if nil ~= self["activityItem1"] then
        self.activityItem1 = tolua.cast(self["activityItem1"],"CCControlButton")
    end
    if nil ~= self["activityItem2"] then
        self.activityItem2 = tolua.cast(self["activityItem2"],"CCControlButton")
    end
    if nil ~= self["activityItem3"] then
        self.activityItem3 = tolua.cast(self["activityItem3"],"CCControlButton")
    end
    if nil ~= self["activityItem4"] then
        self.activityItem4 = tolua.cast(self["activityItem4"],"CCControlButton")
    end
    if nil ~= self["activityItem5"] then
        self.activityItem5 = tolua.cast(self["activityItem5"],"CCControlButton")
    end
    if nil ~= self["scrollView"] then
        self.scrollView = tolua.cast(self["scrollView"],"CCScrollView")
    end
end

function NoticeScene:onPressBack()
    print "onPressBack"
    izx.baseAudio:playSound("audio_menu");
    gBaseLogic.lobbyLogic:goBackToMain();
end

function NoticeScene:onPressActivity1()
    print "onPressActivity1"
    izx.baseAudio:playSound("audio_menu");
    if self.index ~= 1 and self.ctrller.data.notice_list[1] ~= nil then
        self.index = 1
        self.noticeSlider:setPositionX(self.activityItem1:getPositionX())
        self:refreshdata()
    end
end

function NoticeScene:onPressActivity2()
    print "onPressActivity2"
    izx.baseAudio:playSound("audio_menu");
    if self.index ~= 2 and self.ctrller.data.notice_list[2] ~= nil then
        self.index = 2
        self.noticeSlider:setPositionX(self.activityItem2:getPositionX())
        self:refreshdata()
    end
end

function NoticeScene:onPressActivity3()
    print "onPressActivity3"
    izx.baseAudio:playSound("audio_menu");
    if self.index ~= 3 and self.ctrller.data.notice_list[3] ~= nil then
        self.index = 3
        self.noticeSlider:setPositionX(self.activityItem3:getPositionX())
        self:refreshdata()
    end
end

function NoticeScene:onPressActivity4()
    print "onPressActivity4"
    izx.baseAudio:playSound("audio_menu");
    if self.index ~= 4 and self.ctrller.data.notice_list[4] ~= nil then
        self.index = 4
        self.noticeSlider:setPositionX(self.activityItem4:getPositionX())
        self:refreshdata()
    end
end

function NoticeScene:onPressActivity5()
    print "onPressActivity5"
    izx.baseAudio:playSound("audio_menu");
    if self.index ~= 5 and self.ctrller.data.notice_list[5] ~= nil then
        self.index = 5
        self.noticeSlider:setPositionX(self.activityItem5:getPositionX())
        self:refreshdata()
    end
end

function NoticeScene:onInitView()
    local layer = CCLayer:create()
    self.scrollView.layer = layer
    self.scrollView:setContainer(layer)
    local function scrollView1DidScroll()
        print("scrollView1DidScroll")
    end
    local function scrollView1DidZoom()
        print("scrollView1DidZoom")
    end
    self.scrollView:setClippingToBounds(true)
    self.scrollView:setBounceable(true)
    self.scrollView:registerScriptHandler(scrollView1DidScroll,CCScrollView.kScrollViewScroll)
    self.scrollView:registerScriptHandler(scrollView1DidZoom,CCScrollView.kScrollViewZoom)
    self.index = 1
end

function NoticeScene:refreshpic(index_)
    if (self.index~=index_) then
        return;
    end
    local url = self.ctrller.data.notice_list[self.index].local_img
    local adsprite = self.scrollView.layer:getChildByTag(1)

    if  adsprite ~= nil then
        self.scrollView.layer:removeChildByTag(1)
    end
    adsprite =  CCSprite:create(url)
    if nil ~= adsprite then
        local screenSize = CCDirector:sharedDirector():getWinSize()
        adsprite:setAnchorPoint(CCPointMake(0.5,1))
        adsprite:setPosition(CCPointMake(screenSize.width/2,screenSize.height*0.6))
        adsprite:setTag(1)
        self.scrollView.layer:addChild(adsprite)
        self.scrollView:updateInset()
    end
end

function NoticeScene:refreshdata()
    --self.data.notice_list[1].local_img
    --刷新广告图片和活动内容
    if self.scrollView.layer == nil then
        return
    end
    self:refreshpic(self.index)

    local label = self.scrollView.layer:getChildByTag(2)
    if label ~= nil then
        self.scrollView.layer:removeChildByTag(2)
    end
    local picsize = self.scrollView.layer:getChildByTag(1):getContentSize()
    local winSize = CCDirector:sharedDirector():getWinSize()
    label = ui.newTTFLabel({
            text = self.ctrller.data.notice_list[self.index].content,
            size = 20,
            x = 50,
            y = winSize.height*0.6-picsize.height-20,
            dimensions = CCSizeMake(winSize.width-80,0),
            textAlign = TEXT_ALIGN_LEFT,
            color = ccc3(0,0,0),
    })
    label:setAnchorPoint(CCPointMake(0.5,1))
    label:setTag(2)
    self.scrollView.layer:addChild(label)
    self.scrollView:updateInset()
    for i=1,5 do
        if (self.ctrller.data.notice_list[i]~=nil) then
            -- local string = self['activityItem'..i]:getCurrentTitle()
            local tempString = CCString:create(self.ctrller.data.notice_list[i].title);
            self['activityItem'..i]:setTitleForState(tempString,CCControlStateNormal);

            -- setString(self.ctrller.data.notice_list[i].title)
            -- print(self.ctrller.data.notice_list[i].title)
            -- self['activityItem'..i]:setString(self.ctrller.data.notice_list[i].title)
        else
            local tempString = CCString:create("暂无活动");
            self['activityItem'..i]:setTitleForState(tempString,CCControlStateNormal);
            self['activityItem'..i]:setEnabled(false)
        end
    end 
end
 
return NoticeScene;
