local NewHelpScene = class("NewHelpScene",izx.baseView)

function NewHelpScene:ctor(pageName,moduleName,initParam)
	print ("NewHelpScene:ctor")
    self.super.ctor(self,pageName,moduleName,initParam);
end


function NewHelpScene:onAssignVars()
	--var_dump(self);
	self.rootNode = tolua.cast(self.rootNode,"CCNode");

	if nil ~= self["webview"] then
        self.webViewNode = tolua.cast(self["webview"],"CCNode")
    end
    
end
function NewHelpScene:onRemovePage()
    -- call Java method
    gBaseLogic:stopWaitingAni("helpScene");
    closeWebview();
end
function NewHelpScene:onPressBack()
    print "onPressBack"
    izx.baseAudio:playSound("audio_menu");
    self:onRemovePage();
    print("gBaseLogic.lobbyLogic.isloginpage:");
    var_dump(gBaseLogic.lobbyLogic.isloginpage);
    if gBaseLogic.lobbyLogic.isloginpage == true then
       gBaseLogic.lobbyLogic:showLoginScene()
       gBaseLogic.lobbyLogic:dispatchEvent({
            name = "MSG_Socket_UserData",
            message = {}
        })       
    else
       gBaseLogic.lobbyLogic:goBackToMain();
    end
end

function NewHelpScene:onInitView()
    local webSize = self.webViewNode:getContentSize();
    print("webSize.width :"..webSize.width);
    print("webSize.height :"..webSize.height);

    gBaseLogic:waitingAni(self.webViewNode,"helpScene");

    local lt = CCPointMake(0, 0);
    local rb = CCPointMake(display.widthInPixels, display.heightInPixels);

    local canCommit = true;
    if self.logic.userHasLogined == false then
        canCommit = false
    end
    local params = {url=URL.Feedback,pid=self.logic.userData.ply_guid_,packageName=gBaseLogic.packageName,ticket=self.logic.userData.ply_ticket_,feedbackList=URL.FeedbackList,canCommit=canCommit,firstShow=1,noVip=gBaseLogic.MBPluginManager.distributions.novip}
    local url = "interfaces/webRes/index.html";

    
    openWebview(lt,rb,url,true,params,handler(self, self.onWebViewCallback));
end

function NewHelpScene:onWebViewCallback(event)
    echoInfo("JAVA CALLED LUA!!! param is %s ", event);

    if (event=="CLOSE") then
        self:onPressBack();
    elseif (event=="gotoVip") then
        gBaseLogic.lobbyLogic:gotoVipShop();
    end
end

return NewHelpScene;
