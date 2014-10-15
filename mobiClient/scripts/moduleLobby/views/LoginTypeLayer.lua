local LoginTypeLayer = class("LoginTypeLayer",izx.baseView)

function LoginTypeLayer:ctor(pageName,moduleName,initParam)
	print ("LoginTypeLayer:ctor")
    self.super.ctor(self,pageName,moduleName,initParam);
end


function LoginTypeLayer:onAssignVars()
	--var_dump(self);
	self.rootNode = tolua.cast(self.rootNode,"CCNode");
    if nil ~= self["spriteBack"] then
        self.spriteBack = tolua.cast(self["spriteBack"],"CCSprite")
    end
end

function LoginTypeLayer:onPressTourist()
    print "onPressTourist"
    izx.baseAudio:playSound("audio_menu");
    gBaseLogic.sceneManager:removePopUp("LoginTypeLayer");
    gBaseLogic.MBPluginManager:sessionLogin("SessionGuest");
    
end

function LoginTypeLayer:onPressMicroblog()
    print "onPressMicroblog"
    izx.baseAudio:playSound("audio_menu");
    gBaseLogic.sceneManager:removePopUp("LoginTypeLayer");
    gBaseLogic.MBPluginManager:sessionLogin("SessionWeibo");
    
end

function LoginTypeLayer:onPressQQ()
    print "onPressQQ"
    izx.baseAudio:playSound("audio_menu");
    gBaseLogic.sceneManager:removePopUp("LoginTypeLayer");
    gBaseLogic.MBPluginManager:sessionLogin("SessionTencent");
    
end

function LoginTypeLayer:onInitView()
end


function LoginTypeLayer:onPressBack()
    print("LoginTypeLayer:onPressBack")
    izx.baseAudio:playSound("audio_menu");
    gBaseLogic.sceneManager:removePopUp("LoginTypeLayer");
end
return LoginTypeLayer;
