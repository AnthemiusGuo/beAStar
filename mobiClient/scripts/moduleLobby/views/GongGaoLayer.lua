local GongGaoLayer = class("GongGaoLayer",izx.baseView)

function GongGaoLayer:ctor(pageName,moduleName,initParam)
	print ("GongGaoLayer:ctor")
    self.super.ctor(self,pageName,moduleName,initParam);
end


function GongGaoLayer:onAssignVars() 
	self.rootNode = tolua.cast(self.rootNode,"CCNode");
	if nil ~= self["labelAnounceContent"] then
		self.labelAnounceContent = tolua.cast(self["labelAnounceContent"],"CCLabelTTF")
    end
    if nil ~= self["loginGongGaoBack"] then
    	self.loginGongGaoBack = tolua.cast(self["loginGongGaoBack"],"CCSprite")
    end 
end

function GongGaoLayer:onInitView()
	--self:initBaseInfo();
end

function GongGaoLayer:initBaseInfo()
	-- var_dump(self);
    -- self.gongGaoContent = event.ance.resultList[1].content;
    --         self.gongGaotitle = event.ance.resultList[1].title;
    
	self.labelAnounceContent:setString(self.logic.gongGaoContent);
end

function GongGaoLayer:onAddToScene()
	--self.rootNode:setPosition(CCPoint(display.cx,display.cy));
end

function GongGaoLayer:onPressBack()
     gBaseLogic.sceneManager:removePopUp("GongGaoLayer");
     izx.baseAudio:playSound("audio_menu");
     if self.logic.hasqiangtuigonggao==1 then
        self.logic.hasqiangtuigonggao =0
        if self.logic.userData~=nil and self.logic.userData.ply_login_award2_~=nil and self.logic.userData.ply_login_award2_.today_~=nil and self.logic.userData.ply_login_award2_.today_>0  then
            gBaseLogic.lobbyLogic:showDengLuJiangLiLayer();
        end
     end
    --  self.logic:dispatchLogicEvent({
    --     name = "closeGongGao",
    --     message = {}
    -- })
end

return GongGaoLayer;