local HuoDongScene = class("HuoDongScene",izx.baseView)

function HuoDongScene:ctor(pageName,moduleName,initParam)
	print ("HuoDongScene:ctor")
    self.super.ctor(self,pageName,moduleName,initParam);
end


function HuoDongScene:onAssignVars()
	--var_dump(self);
	self.rootNode = tolua.cast(self.rootNode,"CCNode");

	if nil ~= self["webview"] then
        self.webViewNode = tolua.cast(self["webview"],"CCNode")
    end
    
end
function HuoDongScene:onRemovePage()
    -- call Java method
    closeWebview();
end
function HuoDongScene:onPressBack()
    print "onPressBack"
    izx.baseAudio:playSound("audio_menu");
    self:onRemovePage();
    gBaseLogic.lobbyLogic:removePage("HuoDongScene",true)
end
function HuoDongScene:onPressBack2()
    print "onPressBack2"
    izx.baseAudio:playSound("audio_menu");
    gBaseLogic.lobbyLogic:removePage("HuoDongScene",true)
end
function HuoDongScene:onInitView()
    local webSize = self.webViewNode:getContentSize();
    print("webSize.width :"..webSize.width);
    print("webSize.height :"..webSize.height);

    gBaseLogic:waitingAni(self.webViewNode,"HuoDong");

    local lt = CCPointMake(0, 0);
    local rb = CCPointMake(display.widthInPixels, display.heightInPixels);

    local canCommit = true;
    if self.logic.userHasLogined == false then
        canCommit = false
    end
    local params = {url=URL.Feedback,pid=self.logic.userData.ply_guid_,packageName=gBaseLogic.packageName,ticket=self.logic.userData.ply_ticket_,feedbackList=URL.FeedbackList,canCommit=canCommit}
    local htmlurl = string.gsub(URL.HUODONG,"{channel}",gBaseLogic.packageName)
    htmlurl = string.gsub(htmlurl,"{gameid}",MAIN_GAME_ID)
    htmlurl = string.gsub(htmlurl,"{uid}",self.logic.userData.ply_guid_)
    --MD5( "uid=1101134337162632&key=969e8232b375")
    local sign = crypto.md5("uid="..self.logic.userData.ply_guid_.."&key=232dw9kkds375")
    htmlurl = string.gsub(htmlurl,"{sign}",sign)
    htmlurl = string.gsub(htmlurl,"{time}",os.time())
    echoInfo("HuoDongUrl: "..htmlurl);

    
    openWebview(lt,rb,htmlurl,false,params,handler(self, self.onWebViewCallback));
end

function HuoDongScene:onWebViewCallback(event)
    echoInfo("JAVA CALLED LUA!!! param is %s ", event);

    if (event=="CLOSE") then
        self:onPressBack2();
    end  

end

return HuoDongScene;
