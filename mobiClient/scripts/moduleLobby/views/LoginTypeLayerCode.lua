local LoginTypeLayerCode = class("LoginTypeLayerCode",izx.baseView)

function LoginTypeLayerCode:ctor(pageName,moduleName,initParam)
	print ("LoginTypeLayerCode:ctor")
    self.super.ctor(self,pageName,moduleName,initParam);
end


function LoginTypeLayerCode:onAssignVars()
	self.bgPanel = display.newSprite("images/DengLu/login_bg4.png", display.cx, display.bottom);
    self.bgPanel:setAnchorPoint(ccp(0.5,0));
    -- 设置处理函数
    self.rootNode:addChild(self.bgPanel);

    self.listHolder = display.newNode();
    self.listHolder:setPosition(0, display.bottom+50);

    
    self.rootNode:addChild(self.listHolder);

    local size = self.bgPanel:getContentSize()

    self.chooseType = display.newSprite("images/DengLu/login_btn_xuanze1.png", display.cx, display.bottom + size.height+21);
    self.bgPanel:setAnchorPoint(ccp(0.5,0));
    -- 设置处理函数
    self.rootNode:addChild(self.chooseType);

end


function LoginTypeLayerCode:onInitView()
    -- self.loginTypNum
    local k = 0;
    local toX = 208
    if gBaseLogic.MBPluginManager.loginTypNum==1 then
        toX = 565.5
    elseif gBaseLogic.MBPluginManager.loginTypNum==2 then
        toX = 208+(3-gBaseLogic.MBPluginManager.loginTypNum)*303/2+53
    end
    for name,plugIn in pairs(gBaseLogic.MBPluginManager.allLoginTyp) do
        k = k+1;      
        local fileName = {
            normal = "images/DengLu/"..name .. ".png",
            pressed = "images/DengLu/"..name .. "_1.png",
            disabled = "images/DengLu/"..name .. "_1.png"
        }
        local realPath = CCFileUtils:sharedFileUtils():fullPathForFilename(fileName.normal);
        if (realPath==nil or io.exists(realPath)==false) then
            fileName = {
                normal = "thirdparty/"..name .. ".png",
                pressed = "thirdparty/"..name .. "_1.png",
                disabled = "thirdparty/"..name .. "_1.png"
            }
        end
        local thisButton = cc.ui.UIPushButton.new(fileName, {scale9 = false})
        :onButtonClicked(function(event)                    
                izx.baseAudio:playSound("audio_menu");
                gBaseLogic.sceneManager:removePopUp("LoginTypeLayerCode");
                self:realClosePopBox();
                gBaseLogic.MBPluginManager:sessionLogin(name);
            end)
        -- :align(,  toX+subX*(i-1), toY)
        :addTo(self.bgPanel);
        thisButton:setPosition(toX+357*(k-1), 50)
        -- thisButton:setAnchorPoint(ccp(0.5,0.5))
    end

end


function LoginTypeLayerCode:onPressBack()
    print("LoginTypeLayerCode:onPressBack");
    izx.baseAudio:playSound("audio_menu");
    gBaseLogic.sceneManager:removePopUp("LoginTypeLayerCode");
end
return LoginTypeLayerCode;
