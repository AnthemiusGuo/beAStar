local BaseGameLogic = class("BaseGameLogic")

function BaseGameLogic:dispatchLogicEvent(event)
	if (gBaseLogic.sceneManager.inTransition) then
		print("界面切换中，事件被我吃掉了");
		var_dump(event);
		print("_______");
		table.insert(self.eventCache, event);
	else
		self:dispatchEvent(event)
	end
end

function BaseGameLogic:dispatchEventToCache(event)
	table.insert(self.eventCache, event);
end

function BaseGameLogic:dispatchCachedEvent()
	print("界面切换完毕，事件我又吐出来了");
	local count = #self.eventCache;
	if (count>0) then
		for i=1,count do
			self:dispatchEvent(self.eventCache[1]);
			table.remove(self.eventCache,1);
		end		
	end 
	if (#self.eventCache>0) then
		self:dispatchCachedEvent();
	end
end

function BaseGameLogic:removePage(pageName)
	if (self[pageName]~=nil) then
		self[pageName]:removePage();
		self[pageName] = nil;
	end
end

function BaseGameLogic:onConnectFailure()
	gBaseLogic:unblockUI();
	izxMessageBox("服务器连接出错", "连接失败")
end
function BaseGameLogic:onSocketClose()
	izxMessageBox("服务器连接出错", "连接失败")
	self.is_chang_table = 0;
	if (self.gamePage) then 
		self.gamePage:removePage()
		self.gamePage = nil
	end
	if gBaseLogic.lobbyLogic.lobbyErr==1 then
		gBaseLogic.lobbyLogic:showLoginScene(false);
	else
		gBaseLogic.lobbyLogic:EnterLobby();
	end
	
end

function BaseGameLogic:onSendPing(now)
	if (self.lastNotifyTime==nil) then
		self.lastNotifyTime = 0;
	end
	--在上一次提示触发后125秒，如果网络仍未恢复则再次发送提示。
	if (os.time() - self.lastNotifyTime>125) then
		local PingTimeOut = 3;
		self.lastNotifyTime = os.time();
		echoInfo("onSendPing->performWithDelayGlobal now is:%d",os.time());
		self.pingTimeoutScheduler = scheduler.performWithDelayGlobal(handler(self,self.onSendPingTimeout), PingTimeOut);
	end
end

function BaseGameLogic:onSendPingTimeout()
	echoInfo("BaseGameLogic->onSendPingTimeout now is:%d",os.time());
	gBaseLogic:showTopTips("您的网络不太给力，请确认网络连接是否正常");
end

function BaseGameLogic:pt_pong_handler(msg)
	self.pong_now = msg.now_
	if (self.pingTimeoutScheduler) then
		scheduler.unscheduleGlobal(self.pingTimeoutScheduler);
	end
end

function BaseGameLogic:onSocketMessage(message)
	print ("收到消息" .. message.opcode);
	
	if (self[message.opcode .. "_handler"]~=nil) then
		self[message.opcode .. "_handler"](self,message);
		return;
	else
		echoInfo("直接抛出消息，不管了[%s]",message.opcode)
		
		self:dispatchLogicEvent({
	        name = "MSG_SOCK_"..message.opcode,
	        message = message
	    })
	end
end
function BaseGameLogic:addLogicEvent(eventName,handler,target)
	target.handlerPool = target.handlerPool or {};
	target.handlerPool[eventName] = self:addEventListener(eventName,handler);
end


return BaseGameLogic;