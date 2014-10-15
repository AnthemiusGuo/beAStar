local AchievefinishLayer = class("AchievefinishLayer",izx.baseView)

function AchievefinishLayer:ctor(pageName,moduleName,initParam)
	print ("AchievefinishLayer:ctor")
    self.super.ctor(self,pageName,moduleName,initParam);
    self.data = initParam.message;
    -- self.data = {name_="sss",desc_="1111",index_=1}

end


function AchievefinishLayer:onAssignVars()
	self.rootNode = tolua.cast(self.rootNode,"CCNode");

    if nil ~= self["labelDesc"] then
        print("labelDesc")
        self.labelDesc = tolua.cast(self["labelDesc"],"CCLabelTTF")
    end
    if nil ~= self["imgChengjiu"] then
        self.imgChengjiu = tolua.cast(self["imgChengjiu"],"CCsprite")
    end
    if nil ~= self["btn_award"] then
        self.btn_award = tolua.cast(self["btn_award"],"CCControlButton")
    end
   
    local msg = string.format("真是不可思议，你居然完成了［%s］成就。因为你的突出表现，地主决定奖励你 %s。",self.data.name_,self.data.desc_);
    self.labelDesc:setString(msg);
    if gBaseLogic.MBPluginManager.distributions.share==false then
        self.btnShare:setVisible(false);
        self.btn_award:setPositionX(0);
    end
end

function AchievefinishLayer:onPressShare()
    print("onPressShare")
   
    local filename = "11Achievefinish"..os.time(t)..".jpg"
    self.rootNode:setContentSize(CCSizeMake(527, 328))
    local ret = createScreenShotElement(self.rootNode, filename,"jpg")
    gBaseLogic.scheduler.performWithDelayGlobal(function()
        gBaseLogic.MBPluginManager:share(CCFileUtils:sharedFileUtils():getWritablePath()..filename,gBaseLogic.MBPluginManager.distributions.gamename.."分享",2);
    end, 0.5);
    
    
    return true
end

function AchievefinishLayer:onPressAward()
    print("onPressAward")
    if self.data.index_~=nil then
        -- self.logic:reqAchieveAwardReq(self.data.index_);
        print ("AchievefinishLayer:reqAchieveAwardReq")
        local socketMsg = {opcode = 'pt_cb_get_achieve_award_req',index_ = self.data.index_};
        self.logic:sendGameSocket(socketMsg);
        self.btn_award:setEnabled(false)
    else
        gBaseLogic.sceneManager:removePopUp("AchievefinishLayer");
    end
end
 
 
function AchievefinishLayer:onInitView()
  
	self:initBaseInfo();
end

 
function AchievefinishLayer:initBaseInfo()
    print("initBaseInfo")
  
end 

 
   

function AchievefinishLayer:onAddToScene()
    --self.rootNode:setPosition(CCPoint(display.cx,display.cy));
end

function AchievefinishLayer:onPressBack()
    gBaseLogic.sceneManager:removePopUp("AchievefinishLayer");
end

return AchievefinishLayer;
