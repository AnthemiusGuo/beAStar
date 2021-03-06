local FakeLoadingSceneCodeCtrller = class("FakeLoadingSceneCodeCtrller",izx.baseCtrller)

function FakeLoadingSceneCodeCtrller:ctor(pageName,moduleName,initParam)
    self.data = {
    
    };
    self.initlayer = nil;

	FakeLoadingSceneCodeCtrller.super.ctor(self,pageName,moduleName,initParam);
    self.enterModule = initParam.moduleName;
end

function FakeLoadingSceneCodeCtrller:run()
    CCTextureCache:sharedTextureCache():removeAllTextures();
    print ("FakeLoadingSceneCodeCtrller:run")  
    if (self.enterModule=="moduleLobby") then
        if nil ~= self.view.btnCancel then self.view.btnCancel:setVisible(false); end
        if nil ~= self.view.btnCancelText then self.view.btnCancelText:setVisible(false); end
        self:gotoLobby();
    elseif (self.enterModule=="moduleMainGame") then
        if nil ~= self.view.btnCancel then self.view.btnCancel:setVisible(true) end
        if nil ~= self.view.btnCancelText then self.view.btnCancelText:setVisible(true) end
        self.logic:addLogicEvent("MSG_MAINGAME_LOADING",handler(self, self.onMainGameLoading),self)
        
        self.logic:addLogicEvent("MSG_GAME_FINISH",handler(self, self.view.onPressBack),self)
        local cback = function()
            print("=====moduleMainGame")
            if (gBaseLogic.gameLogic~=nil) then
                self.view:setLoadingPercent(0.7);   
                gBaseLogic.gameLogic:startGamesocket(); 

            end
        end
        scheduler.performWithDelayGlobal(cback, 0.02)
    else
        if nil ~= self.view.btnCancel then self.view.btnCancel:setVisible(true) end
        if nil ~= self.view.btnCancelText then self.view.btnCancelText:setVisible(true) end
    end
    self.view:setLoadingPercent(0.5);
end

function FakeLoadingSceneCodeCtrller:gotoLobby()
    local scheduler = require(cc.PACKAGE_NAME .. ".scheduler");
    scheduler.performWithDelayGlobal(function()
        self.view:setLoadingPercent(0.9); 
        gBaseLogic.lobbyLogic:enterLocation();
    end, 0.3)
end

function FakeLoadingSceneCodeCtrller:onEnter()
    -- body
end
  
return FakeLoadingSceneCodeCtrller;