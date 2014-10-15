local TuoXiangGengXinLayer = class("TuoXiangGengXinLayer",izx.baseView)

function TuoXiangGengXinLayer:ctor(pageName,moduleName,initParam)
	print ("TuoXiangGengXinLayer:ctor")
    self.super.ctor(self,pageName,moduleName,initParam);
    self.enblieclick = false
end


function TuoXiangGengXinLayer:onAssignVars() 
    print("TuoXiangGengXinLayer:onAssignVars");
	self.rootNode = tolua.cast(self.rootNode,"CCNode");
    if nil ~= self["spriteHeadImage1"] then
        self.spriteHeadImage1 = tolua.cast(self["spriteHeadImage1"],"CCSprite")
    end
    if nil ~= self["spriteHeadImage2"] then
        self.spriteHeadImage2 = tolua.cast(self["spriteHeadImage2"],"CCSprite")
    end
    if nil ~= self["spriteHeadImage3"] then
        self.spriteHeadImage3 = tolua.cast(self["spriteHeadImage3"],"CCSprite")
    end
    if nil ~= self["spriteHeadImage4"] then
        self.spriteHeadImage4 = tolua.cast(self["spriteHeadImage4"],"CCSprite")
    end 
    if nil ~= self["spriteHeadImage5"] then
        self.spriteHeadImage5 = tolua.cast(self["spriteHeadImage5"],"CCSprite")
    end
    if nil ~= self["spriteHeadImage6"] then
        self.spriteHeadImage6 = tolua.cast(self["spriteHeadImage6"],"CCSprite")
    end
    if gBaseLogic.MBPluginManager.distributions.checkapple then 
        self.checkAppNode:setVisible(false)
    end
end

function TuoXiangGengXinLayer:onPressBack()
    print ("TuoXiangGengXinLayer:onPressBack")
    izx.baseAudio:playSound("audio_menu");
    gBaseLogic.sceneManager:removePopUp("TouXiangGengXinLayer");
end

function TuoXiangGengXinLayer:onInitView()
    print ("TuoXiangGengXinLayer:onInitView")
    self:initBaseInfo()
end

function TuoXiangGengXinLayer:initBaseInfo()

end

function TuoXiangGengXinLayer:setHeadIamge(num)
    if self.enblieclick == true then 
        izx.baseAudio:playSound("audio_menu");
        self.ctrller:setDefaultHeadIamge(num) 
    else 
        izxMessageBox("头像获取中，请稍等！", "提示") 
    end
end 

function TuoXiangGengXinLayer:onPressHead1()
    self:setHeadIamge(1)
end
function TuoXiangGengXinLayer:onPressHead2()
    self:setHeadIamge(2)
end
function TuoXiangGengXinLayer:onPressHead3()
    self:setHeadIamge(3)
end
function TuoXiangGengXinLayer:onPressHead4()
    self:setHeadIamge(4)
end
function TuoXiangGengXinLayer:onPressHead5() 
    self:setHeadIamge(5)
end
function TuoXiangGengXinLayer:onPressHead6()
    self:setHeadIamge(6)
end
function TuoXiangGengXinLayer:onPressUpload()
    izx.baseAudio:playSound("audio_menu");
    if self.logic.userData.ply_lobby_data_.param_2_ >= 3 then
        self:onPressBack()
        gBaseLogic.MBPluginManager:initHeadFace()
    else 
        izxMessageBox("等级未达3级，暂未开放此功能", "提示") 
    end
end

function TuoXiangGengXinLayer:updateDefaultHeadIamge(msg)

    self.enblieclick = true 

    izx.resourceManager:imgFileDown(msg.image1,true,function(fileName) 
                if (self.spriteHeadImage1) then
                    self.spriteHeadImage1:setTexture(getCCTextureByName(fileName)) 
                end
                    end)
    izx.resourceManager:imgFileDown(msg.image2,true,function(fileName) 
                if (self.spriteHeadImage2) then
                    self.spriteHeadImage2:setTexture(getCCTextureByName(fileName))
                end
                    end)
    izx.resourceManager:imgFileDown(msg.image3,true,function(fileName) 
                if (self.spriteHeadImage3) then
                    self.spriteHeadImage3:setTexture(getCCTextureByName(fileName)) 
                end
                    end)
    izx.resourceManager:imgFileDown(msg.image4,true,function(fileName) 
                if (self.spriteHeadImage4) then
                    self.spriteHeadImage4:setTexture(getCCTextureByName(fileName)) 
                end
                    end)
    izx.resourceManager:imgFileDown(msg.image5,true,function(fileName) 
                if (self.spriteHeadImage5) then
                    self.spriteHeadImage5:setTexture(getCCTextureByName(fileName)) 
                end
                    end)
    izx.resourceManager:imgFileDown(msg.image6,true,function(fileName) 
                if (self.spriteHeadImage6) then
                    self.spriteHeadImage6:setTexture(getCCTextureByName(fileName)) 
                end
                    end)

end

function TuoXiangGengXinLayer:onAddToScene()
end

return TuoXiangGengXinLayer;