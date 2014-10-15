--
-- Author: Xupinhui
-- Date: 2014-06-11 16:18:50
--
local DengLuXuanZeLayer = class("DengLuXuanZeLayer",izx.baseView)

function DengLuXuanZeLayer:ctor(pageName,moduleName,initParam)
	print ("DengLuXuanZeLayer:ctor")
    self.super.ctor(self,pageName,moduleName,initParam);
end


function DengLuXuanZeLayer:onAssignVars() 
    
	self.rootNode = tolua.cast(self.rootNode,"CCNode");
-- 	MAC8(mac8) 06-11 15:27:50
-- dengluNode
-- MAC8(mac8) 06-11 15:28:09
-- labelVersion
    if nil ~= self["labelVersion"] then
        self.labelVersion = tolua.cast(self["labelVersion"],"CCLabelTTF")
        local thisversion = 'v' .. SHOW_VERSION.."."..LUA_VERSION;
        if (gBaseLogic.MBPluginManager.distributions.noLuaVersionName) then
            thisversion = 'v' .. SHOW_VERSION;
        end
        if (PLUGIN_ENV==ENV_TEST) then
	        thisversion = thisversion.."测试环境"
	    elseif (PLUGIN_ENV== ENV_MIRROR ) then
	    	thisversion = thisversion.."镜像环境"
	    end
	    self.labelVersion:setString(thisversion);
        if gBaseLogic.MBPluginManager.distributions.showVersionMsg~=nil and 
        gBaseLogic.MBPluginManager.distributions.showVersionMsg~="" then
            self.labelVersion:setString(gBaseLogic.MBPluginManager.distributions.showVersionMsg);
        end
    end
    if nil ~= self["labelVersionqq"] then
        self.labelVersionqq = tolua.cast(self["labelVersionqq"],"CCLabelTTF")
        
        self.labelVersionqq:setString("客服QQ:"..self.logic.helpDesk);
    end
    if nil ~= self["dengluNode"] then
        self.dengluNode = tolua.cast(self["dengluNode"],"CCNode")
    end
    if nil ~= self["spriteLogo"] then
		self.spriteLogo = tolua.cast(self["spriteLogo"],"CCSprite")
		gBaseLogic.MBPluginManager:replacelogo("logodenglu",self.spriteLogo)
		-- self.labelStringMsg:setString(gBaseLogic.MBPluginManager:replaceText(t_string))
    end       
    -- self.labelVersion:setString('v' .. SHOW_VERSION);
end
 

function DengLuXuanZeLayer:onPressBack()
    print ("DengLuXuanZeLayer:onPressBack")
    izx.baseAudio:playSound("audio_menu");
    gBaseLogic.sceneManager:removePopUp("DengLuXuanZeLayer");
end

function DengLuXuanZeLayer:onPressClose()
    print ("DengLuXuanZeLayer:onPressClose")
    izx.baseAudio:playSound("audio_menu");
    gBaseLogic.sceneManager:removePopUp("DengLuXuanZeLayer");
end

 
function DengLuXuanZeLayer:onInitView()
    print ("DengLuXuanZeLayer:onInitView")
    local kongge = 172;
    local toX,toY = self.dengluNode:getPosition();
    if gBaseLogic.MBPluginManager.loginTypNum==1 then
    elseif gBaseLogic.MBPluginManager.loginTypNum==2 then
        toX = toX-86
    elseif gBaseLogic.MBPluginManager.loginTypNum==3 then
    	toX = toX-172
    elseif gBaseLogic.MBPluginManager.loginTypNum==4 then
        toX = toX-126-60
        kongge = 126
    end
    local k = 0;
    for name,plugIn in pairs(gBaseLogic.MBPluginManager.allLoginTyp) do
        k = k+1;  
        local fileName = {
                normal = "thirdparty/"..name .. ".png",
                pressed = "thirdparty/"..name .. "_1.png",
                disabled = "thirdparty/"..name .. "_1.png"
            }    
        
        local realPath = CCFileUtils:sharedFileUtils():fullPathForFilename(fileName.normal);
        if (realPath==nil or io.exists(realPath)==false) then
            fileName = {
                normal = "images/DengLu/"..name .. ".png",
                pressed = "images/DengLu/"..name .. "_1.png",
                disabled = "images/DengLu/"..name .. "_1.png"
            }
        end
        local thisButton = cc.ui.UIPushButton.new(fileName, {scale9 = false})
        :onButtonClicked(function(event)                    
                izx.baseAudio:playSound("audio_menu");
                gBaseLogic.sceneManager:removePopUp("DengLuXuanZeLayer");
                gBaseLogic.MBPluginManager:sessionLogin(name);
            end)
        -- :align(,  toX+subX*(i-1), toY)
        :addTo(self.rootNode);
        thisButton:setPosition(toX+kongge*(k-1), toY)
        -- thisButton:setAnchorPoint(ccp(0.5,0.5))
    end
end

 
 

function DengLuXuanZeLayer:onAddToScene()
	self.rootNode:setPosition(ccp(display.cx,display.cy));
end

return DengLuXuanZeLayer;