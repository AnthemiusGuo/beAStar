local LoadingSceneCtrller = class("LoadingSceneCtrller",izx.baseCtrller)

function LoadingSceneCtrller:ctor(pageName,moduleName,initParam)
    self.data = {
    
    };
    self.initlayer = nil;
    self.willGoBack = false;
	LoadingSceneCtrller.super.ctor(self,pageName,moduleName,initParam);
    self.enterModule = initParam.moduleName;
    self.gameId = tonumber(initParam.gameId);
    self.reDownloadCounter = 0;
end

function LoadingSceneCtrller:run()
    
    self.logic:addLogicEvent("MSG_RES_MODULE_BATCH_DOWNLOAD",handler(self, self.onResDownload),self);
    self.view:showLabelHint("正在更新");
    self.view.state = "init";
    CCTextureCache:sharedTextureCache():removeAllTextures();
    print ("LoadingSceneCtrller:run for "..self.enterModule)  
    if (self.enterModule=="miniGame") then
        if self.view.btnCancel ~= nil then self.view.btnCancel:setVisible(true); end
        if self.view.btnCancelText ~= nil then self.view.btnCancelText:setVisible(true); end

        local miniGameInfo = izx.miniGameManager:getMiniGame(self.gameId);
        echoInfo("miniGameInfo %s", miniGameInfo);
        if (MINIGAME_IN_DEVELOP) then
            gBaseLogic:runModule(miniGameInfo.gameModule,miniGameInfo);
        else
            -- izx.miniGameManager:reCheckVersion(self.gameId);
            if (miniGameInfo.versionReady) then
                echoInfo("miniGameInfo.versionReady == true");
                self:onResDownloadFinish();
            else
                self.view.state = "downloading";
                echoInfo("miniGameInfo.versionReady == false");
                
                if (miniGameInfo.downloadScheduler~=nil) then
                    scheduler.unscheduleGlobal(miniGameInfo.downloadScheduler) 
                    miniGameInfo.downloadScheduler = nil;
                end
                if (miniGameInfo.isDownloading) then
                    --  wait now downloading
                    -- scheduler.performWithDelayGlobal(function()
                    --     izx.resourceManager:startBatchDownload(miniGameInfo.versionFiles,"miniGameDownload",self.gameId,izx.miniGameManager);
                    -- end, 1)
                    
                else
                    izx.resourceManager:startBatchDownload(miniGameInfo.versionFiles,"miniGameDownload",self.gameId,izx.miniGameManager);
                end                
            end
        end                
    end
end

function LoadingSceneCtrller:onResDownload(msg)
    echoInfo("LoadingSceneCtrller:onResDownload msg.message.ret = %d ",msg.message.ret );
    if (msg.message.ret==0) then
        self:onResDownloadFinish();
    else
        if (self.reDownloadCounter<3) then
            self.reDownloadCounter = self.reDownloadCounter + 1;
            local miniGameInfo = izx.miniGameManager:getMiniGame(self.gameId);
            izx.resourceManager:startBatchDownload(miniGameInfo.versionFiles,"miniGameDownload",self.gameId,izx.miniGameManager);
        else
            self:onResDownloadFail(msg.message.ret,msg.message.msg);
        end
    end
end

function LoadingSceneCtrller:onResDownloadFinish()
    self.view.state = "finished";

    local miniGameInfo = izx.miniGameManager:getMiniGame(self.gameId);
    echoInfo("LoadingSceneCtrller:onResDownloadFinish" );
    var_dump(miniGameInfo);
    if (miniGameInfo.code==nil or miniGameInfo.code=="") then
        izx.miniGameManager:resetDownload(self.gameId);
        -- izx.resourceManager:startBatchDownload(miniGameInfo.versionFiles,"miniGameDownload",self.gameId,izx.miniGameManager);
        -- self.view.state = "downloading";
        -- self.reDownloadCounter = self.reDownloadCounter + 1;
        return;
    end
    if (miniGameInfo.code~="preinstalled") then
        echoInfo("LOADING CODE CHUNKS!!!"..miniGameInfo.code);
        if (not io.exists(miniGameInfo.code)) then
            echoInfo("miniGameManager code trunk don't exist"..miniGameInfo.code);
            izx.miniGameManager:resetDownload(self.gameId);
            izx.resourceManager:startBatchDownload(miniGameInfo.versionFiles,"miniGameDownload",self.gameId,izx.miniGameManager);
            self.view.state = "downloading";
            self.reDownloadCounter = self.reDownloadCounter + 1;
            
            return;
        end
        izx.resourceManager.fileManager:addSearchPath(miniGameInfo.resDir)

        CCLuaLoadChunksFromZIP(miniGameInfo.code);  
    else
        echoInfo("I'm preinstalled version!");
    end
    gBaseLogic:runModule(miniGameInfo.gameModule,miniGameInfo);
    gBaseLogic.gameLogic.resDir = miniGameInfo.resDir;
    self.view:showLabelHint("更新完成");
    self.view:showLoadingPercent(100,100);
end

function LoadingSceneCtrller:onResDownloadFail(ret,msg)
    self.view.state = "failed";
    self.view:showLabelHint(msg);

    -- avoid multi msg pushed up
    if (self.willGoBack ==false) then
        self.willGoBack = true;
        scheduler.performWithDelayGlobal(function()
            gBaseLogic.lobbyLogic:EnterLobby();
        end, 2)
    end
end


function LoadingSceneCtrller:onPluginStart(msg)
	self.view:showLabelHint("正在更新");
end

function LoadingSceneCtrller:onMainGameLoading(msg)
    var_dump(msg);
    -- self.view:showLabelHint(msg);
end

function LoadingSceneCtrller:gotoLobby()
    local scheduler = require(cc.PACKAGE_NAME .. ".scheduler");
    scheduler.performWithDelayGlobal(function()
        gBaseLogic.lobbyLogic:EnterLobby();
    end, 0.3)
end

function LoadingSceneCtrller:onPluginProgress(msg)

end

function LoadingSceneCtrller:onPluginError(msg)
	
end

function LoadingSceneCtrller:onEnter()
    -- body
end
  
return LoadingSceneCtrller;