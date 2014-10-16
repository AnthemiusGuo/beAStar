local BasePage = class("BasePage")

require "izxFW.CCBReaderLoad"
ccb = ccb or {}

BasePage.PAGE_TYP_CODE = 1;
BasePage.PAGE_TYP_CCB = 2;
BasePage.PAGE_TYP_CCJ = 3;

function BasePage:ctor(logic,pageName,moduleName,opt)
    self.pageName = pageName;
    self.moduleName = moduleName;
    self.logic = logic;
    self.isBlockTouch = false;
    self.isKeyPadListen = false;
    self.isScene = false;
    default_opt = {
        initParam = {},
        pageType = BasePage.PAGE_TYP_CODE,
        ccbFileName = '',
        ccbController = self.pageName,
        slideIn = "left",
        targetX = 0,
        targetY = 0,
        isCodeScene = false,
    };
    genParam(opt,default_opt);
    self.cback = opt.cback;
    self.view = require(moduleName .. ".views." .. pageName).new(pageName,moduleName,opt.initParam);
    self.ctrller = require(moduleName .. ".ctrllers." .. pageName).new(pageName,moduleName,opt.initParam);

    self.view.ctrller = self.ctrller;
    self.ctrller.view = self.view;
    self.ctrller.running = false;
    
    self.view.logic = logic;
    self.ctrller.logic = logic;
    self.slideIn = opt.slideIn;
    self.targetX = opt.targetX;
    self.targetY = opt.targetY;
    self.block = false;
    
    if (opt.pageType == BasePage.PAGE_TYP_CCB) then
        ccb[opt.ccbController] = self.view;
        -- 取数据
        local proxy = CCBProxy:create();
        self.view.rootNode = CCBuilderReaderLoad(opt.ccbFileName,proxy,self.view);
        self.view.rootNode.controller = self.ctrller;
        self.view:onDidLoadFromCCB();
    elseif (opt.pageType == BasePage.PAGE_TYP_CCJ) then
        ccb[opt.ccbController] = self.view;
        -- 取数据
        local reader = CCJReader.new(opt.ccjFileName);
        self.view.rootNode = reader:load(self.view);
        self.view.rootNode.controller = self.ctrller;
        self.view:onDidLoadFromCCJ();
        
    else
        if opt.isCodeScene then
            self.view.rootNode = CCLayer:create();
        else 
            self.view.rootNode = CCNode:create();
        end
        self.view.rootNode.controller = self.ctrller;
        self.view:onDidLoadFromCode();
    end
end

function BasePage:run()
    print("BasePage:run")
    -- echoError("BasePage:run")
    self.view:onInitView();
	self.ctrller:run();
    
    self.ctrller.running = true;
end

function BasePage:onCEvent(event)
    print("----"..self.pageName..": on "..event.."------------");
    if (event=="cleanup" or event=="exit") then

        -- 移除lua代码
        self:removePage();

        if (gBaseLogic.sceneManager.oldPage and gBaseLogic.sceneManager.oldPage.pageName == self.pageName) then
            gBaseLogic.sceneManager.oldPage = nil;
        end
    elseif (event=="enterTransitionFinish") then
        print("enterTransitionFinish")
        var_dump(self.cback)
        local layer = tolua.cast(self.view.rootNode,"CCLayer");
        layer:addKeypadEventListener(handler(self,self.onKeypad));
        layer:setKeypadEnabled(true);
        self.isKeyPadListen = true;
        layer:setTouchEnabled(true);
        
        if self.block == true then
            gBaseLogic:blockUI()
        end
        self:run();

        if self.cback then 
            self.cback(); 
        end
        -- 仅用来释放资源的loading界面不放事件出来
        if (self.pageName~="FakeLoadingScene" and self.pageName~="FakeLoadingSceneCode") then
            self.logic:dispatchCachedEvent();
        end
        if (self.view.onFinishedTransition) then
            print("view onFinishedTransition");
            self.view:onFinishedTransition()
        end

        gBaseLogic.sceneManager.inTransition = false;
        
    end
end

function BasePage:onKeypad(event)
    if event == "back" then
        if (gBaseLogic.sceneManager.inTransition) then
            return;
        end
        if gBaseLogic.sceneManager.currentPage.view.nodePopBox then
            return
        end
        if (gBaseLogic.sceneManager.currentPop and gBaseLogic.sceneManager.currentPop.view.onPressBack) then
            gBaseLogic.sceneManager.currentPop.view:onPressBack()
            print("====press back!!!!!!!====1111");
        elseif(self.view.currentPopBox) then
            print("====press back!!!!!!!====2222");
            if (self.view.currentPopBox.onPressBack) then
                self.view.currentPopBox:onPressBack()
            elseif (self.view.currentPopBox.onPressExit) then
                self.view.currentPopBox:onPressExit()
            end
        else
            print("====press back!!!!!!!====2222");
            self.view:onPressKeyBack();
        end
        print("====press back!!!!!!!====");
    elseif event == "menu" then
        self.view:onPressKeyMenu();
        print("====press menu!!!!!!!====");
    end
end

function BasePage:enterScene(block)
    self.isScene = true;
    self.scene = display.newScene(self.pageName);
    local layer = tolua.cast(self.view.rootNode,"CCLayer");
    self.scene:addChild(layer);
    -- transition or init run
    self.scene:registerScriptHandler(handler(self,self.onCEvent));
    gBaseLogic.MBPluginManager:logEventBegin(self.moduleName.."_"..self.pageName)
    -- print("========BasePage:enterScene")
    if (gBaseLogic.sceneManager:enterScene(self,block)) then
        self:run();
    end
end

function BasePage:addToScene(opt)
    self.isScene = false;
    if gBaseLogic.sceneManager.popUps[self.pageName]~=nil then
        return
    end
    gBaseLogic.sceneManager:addToScene(self,opt);
    gBaseLogic.MBPluginManager:logEventBegin(self.moduleName.."_"..self.pageName)
    self:run();
end

function BasePage:addToTargetNode(targetNode)
    local layer = tolua.cast(self.view.rootNode,"CCNode");
    targetNode:addChild(layer);
    self.view:onAddToScene();
    self:run();
end

function BasePage:addToRootNode(targetView)
    self.isScene = false;
    local layer = tolua.cast(self.view.rootNode,"CCNode");
    targetView.rootNode:addChild(layer);
    self.view:onAddToScene();
    self:run();
end

function BasePage:removePage()
    gBaseLogic.MBPluginManager:logEventEnd(self.moduleName.."_"..self.pageName)
    if (self.isScene) then
        gBaseLogic.sceneManager:removePopUps(self.pageName);
    end
    gBaseLogic.sceneManager.popUps[self.pageName] = nil
    if (self.view) then
        self.view:unschedule()
        if (self.view.nodePopBox) then
            self.view:realClosePopBox()
        end
        if (self.isBlockTouch and self.view.maskLayerColor) then
            self.view.maskLayerColor = tolua.cast(self.view.maskLayerColor,"CCNode")
            if (self.view.maskLayerColor) then  
                if (gBaseLogic.MBPluginManager.frameworkVersion>=14081501)  then
                    self.view.maskLayerColor:removeAllNodeEventListeners();

                else
                    self.view.maskLayerColor:unregisterScriptHandler();

                end
                self.view.maskLayerColor:removeFromParentAndCleanup(true);
            end
            self.view.maskLayerColor = nil;            
        end
        local layer = tolua.cast(self.view.rootNode,"CCLayer");
        if (layer and self.isKeyPadListen) then
            layer:removeKeypadEventListener();
        end
        
        if self.view.rootNode~=nil then
            if (gBaseLogic.MBPluginManager.frameworkVersion>=14081501)  then
                self.view.rootNode:removeAllNodeEventListeners();
            else
                self.view.rootNode:unregisterScriptHandler();
            end
            self.view.rootNode:removeAllChildrenWithCleanup(true);
            self.view.rootNode:removeFromParentAndCleanup(true);
            self.view.rootNode = nil;
        end
        self.view:onRemovePage();
        self.view = nil;
    end
    if (self.ctrller) then
        self.ctrller:removeAllEvent();  
        self.ctrller.running = false;
        self.ctrller = nil; 
    end
    if (gBaseLogic.sceneManager.currentPop) then
        gBaseLogic.sceneManager.currentPop = nil;
    end
    gBaseLogic.currentPop = nil;
end

return BasePage;