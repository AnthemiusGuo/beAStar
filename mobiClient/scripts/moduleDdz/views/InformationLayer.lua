local InformationLayer = class("InformationLayer",izx.baseView)

function InformationLayer:ctor(pageName,moduleName,initParam)
	print ("InformationLayer:ctor")
    self.super.ctor(self,pageName,moduleName,initParam);
end


function InformationLayer:onAssignVars()
	--var_dump(self);
	self.rootNode = tolua.cast(self.rootNode,"CCNode");

    if nil ~= self["backsprite"] then
    	self.backsprite = tolua.cast(self["backsprite"],"CCSprite")
    end
    if nil ~= self["nickname"] then
        self.nickname = tolua.cast(self["nickname"],"CCLabelTTF")
    end
    if nil ~= self["money"] then
        self.money = tolua.cast(self["money"],"CCLabelTTF")
    end
    if nil ~= self["credits"] then
        self.credits = tolua.cast(self["credits"],"CCLabelTTF")
    end
    if nil ~= self["result"] then
        self.result = tolua.cast(self["result"],"CCLabelTTF")
    end
    if nil ~= self["spriteVip"] then
        self.spriteVip = tolua.cast(self["spriteVip"],"CCSprite")
    end 
    if nil ~= self["headicon"] then
        self.headicon = tolua.cast(self["headicon"],"CCSprite")
    end 
    if nil ~= self["lableLevel"] then
        self.lableLevel = tolua.cast(self["lableLevel"],"CCLabelTTF")
    end
end

function InformationLayer:onPressBack()
    gBaseLogic.sceneManager:removePopUp("InformationLayer");
end

function InformationLayer:onInitView()
	self:initBaseInfo();
end

function InformationLayer:initBaseInfo()
    local ply_data_ = self.initParam:getPlyData() 
    self.lableLevel:setString("Lv "..ply_data_.param_2_);
    self.nickname:setString(izx.UTF8.sub(ply_data_.nickname_));
    self.money:setString(ply_data_.money_ .."");
    self.credits:setString(ply_data_.gift_ .."");
    --ply_data_.won_ = 99999 --for test
    --ply_data_.lost_ = 99999
    self.result:setString(numberChange(ply_data_.won_).."胜/"..numberChange(ply_data_.lost_).."败")
    self:showVipIcon(self.spriteVip, ply_data_.ply_vip_.level_, ply_data_.ply_vip_.status_)
    izx.resourceManager:imgFileDown(self.initParam.headimage_,true,function(fileName) 
            if self~=nil and self.headicon~=nil then
                self.headicon:setTexture(getCCTextureByName(fileName))
            end
        end);

    -- self.backLayer:addTouchEventListener(function(event, x, y)
    --     return self:onTouch(event, x, y)
    -- end)
    -- self.backLayer:setTouchEnabled(true) 
end

-- function InformationLayer:onTouch(event, x, y)
--     if event == "began" then
--         if self.backLayer:isVisible() then
--             if self.backsprite:boundingBox():containsPoint(CCPoint(x,y))== false then
--               local scene = display.getRunningScene()
--               self.backLayer:removeTouchEventListener()
--               scene:removeChild(self.rootNode)
--             end
--         end
--     end
-- end

return InformationLayer;