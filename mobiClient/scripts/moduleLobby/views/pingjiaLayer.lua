--
-- Author: Xupinhui
-- Date: 2014-08-27 10:15:33
--
local pingjiaLayer = class("pingjiaLayer",izx.baseView)

function pingjiaLayer:ctor(pageName,moduleName,initParam)
	print ("pingjiaLayer:ctor")
    self.super.ctor(self,pageName,moduleName,initParam);
    self.evaluateUrl = initParam.evaluateUrl
end


function pingjiaLayer:onAssignVars()    
	self.rootNode = tolua.cast(self.rootNode,"CCNode");
    
end

function pingjiaLayer:onPressbtn1()
    print("pingjiaLayer:onPressbtn1")
	print(self.evaluateUrl)
     CCNative:openURL(self.evaluateUrl);
     self.logic:setEvaluateTime(2)
  --    local url = string.gsub(URL.UPDATEEVALUATE,"{pid}",self.userData.ply_guid_);
		
		-- gBaseLogic:HTTPGetdata(url,0,function(event)
		-- 	if event.ret == 0 then
		-- 		print("URL.UPDATEEVALUATE")
		-- 	end
		-- end)
     self:onPressClose()
end
function pingjiaLayer:onPressbtn2()
	
	self.logic:setEvaluateTime(2)
    self:onPressClose()
     
end
function pingjiaLayer:onPressbtn3()
    self.logic:setEvaluateTime(1)
     self:onPressClose()
end
function pingjiaLayer:onPressClose()
    print ("pingjiaLayer:onPressClose")
    izx.baseAudio:playSound("audio_menu");
    gBaseLogic.sceneManager:removePopUp("pingjiaLayer");
end

 

function pingjiaLayer:onPressBack()
    print ("pingjiaLayer:onPressBack")
    izx.baseAudio:playSound("audio_menu");
    gBaseLogic.sceneManager:removePopUp("pingjiaLayer");
    
end


 
function pingjiaLayer:onInitView()
    print ("pingjiaLayer:onInitView")
    
end

function pingjiaLayer:initBaseInfo()
     
end

 

function pingjiaLayer:onAddToScene()
	self.rootNode:setPosition(ccp(display.cx,display.cy));
end

return pingjiaLayer;