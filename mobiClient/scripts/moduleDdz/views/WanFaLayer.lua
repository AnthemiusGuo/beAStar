local WanFaLayer = class("WanFaLayer",izx.baseView)

function WanFaLayer:ctor(pageName,moduleName,initParam)
	print ("WanFaLayer:ctor")
    self.super.ctor(self,pageName,moduleName,initParam);
end

function WanFaLayer:onAddToScene()
    self.rootNode:setPosition(cc.p(display.cx,display.cy));
end

function WanFaLayer:onAssignVars()
    self.rootNode = tolua.cast(self.rootNode,"CCNode");

end

function WanFaLayer:onPressCommon()
	print("onPressCommon")
    -- local scene = display.getRunningScene()
    -- scene:removeChild(self.rootNode)
    --gBaseLogic.currentScene.view.rootNode:removeChild(self.rootNode)
    gBaseLogic.sceneManager:removePopUp("WanFaLayer");
    -- self.rootNode:removeFromParentAndCleanup(true)
    gBaseLogic.sceneManager.currentPage.ctrller:initRobotInfo(0)
end

function WanFaLayer:onPressLaizi()
    print("WanFaLayer:onPressLaizi()")
    -- local scene = display.getRunningScene()
    -- scene:removeChild(self.rootNode)
    --gBaseLogic.currentScene.view.rootNode:removeChild(self.rootNode)
    --gBaseLogic.sceneManager.currentPage.view:closePopBox();
    --self.rootNode:removeFromParentAndCleanup(true)
    --self:showLaiZiTips()
    gBaseLogic.sceneManager:removePopUp("WanFaLayer");
    gBaseLogic:showLaiZiTips(0)
    --gBaseLogic.sceneManager.currentPage.ctrller:initRobotInfo(1)

end

function WanFaLayer:onInitView()
    print("WanFaLayer:onInitView()")
	--self:initBaseInfo();
end

function WanFaLayer:initBaseInfo()
    print("WanFaLayer:initBaseInfo()")
end

return WanFaLayer;