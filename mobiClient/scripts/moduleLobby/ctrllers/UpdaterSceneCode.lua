local UpdaterSceneCodeCtrller = class("UpdaterSceneCodeCtrller",izx.baseCtrller)

function UpdaterSceneCodeCtrller:ctor(pageName,moduleName,initParam)
    self.data = {
    
    };
    self.initlayer = nil;
    self.willGoBack = false;
	UpdaterSceneCodeCtrller.super.ctor(self,pageName,moduleName,initParam);
    self.enterModule = initParam.moduleName;
    self.gameId = tonumber(initParam.gameId);
    self.reDownloadCounter = 0;
    self.allDownloadSize = 0;
end

function UpdaterSceneCodeCtrller:run()
   self.logic.updateManager:run();
end

function UpdaterSceneCodeCtrller:onResDownload(msg)
    echoInfo("UpdaterSceneCodeCtrller:onResDownload msg.message.ret = %d ",msg.message.ret );
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

function UpdaterSceneCodeCtrller:onResDownloadFinish()
    self.view.state = "finished";

    local miniGameInfo = izx.miniGameManager:getMiniGame(self.gameId);
    echoInfo("UpdaterSceneCodeCtrller:onResDownloadFinish" );
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
    self.view:removeLoadingPercentText();
end

function UpdaterSceneCodeCtrller:onResDownloadFail(ret,msg)
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


function UpdaterSceneCodeCtrller:onPluginStart(msg)
	self.view:showLabelHint("正在更新");
end

function UpdaterSceneCodeCtrller:onMainGameLoading(msg)
    var_dump(msg);
    -- self.view:showLabelHint(msg);
end

function UpdaterSceneCodeCtrller:gotoLobby()
    local scheduler = require(cc.PACKAGE_NAME .. ".scheduler");
    scheduler.performWithDelayGlobal(function()
        gBaseLogic.lobbyLogic:EnterLobby();
    end, 0.3)
end

function UpdaterSceneCodeCtrller:onPluginProgress(msg)

end

function UpdaterSceneCodeCtrller:onPluginError(msg)
	
end

function UpdaterSceneCodeCtrller:onEnter()
    -- body
end
  
return UpdaterSceneCodeCtrller;