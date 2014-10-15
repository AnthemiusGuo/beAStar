local SocketWrapper = class("SocketWrapper");
socketIdCounter = 1;
SocketWrapper.OPEN_EVENT    = "open"
SocketWrapper.MESSAGE_EVENT = "message"
SocketWrapper.CLOSE_EVENT   = "close"
SocketWrapper.ERROR_EVENT   = "error"
SOCKET_PING_TIME = 15;

local scheduler = require(cc.PACKAGE_NAME .. ".scheduler");

function SocketWrapper:ctor(ListenerLogic,socketType,socketConfig,tag)
	self.ListenerLogic = ListenerLogic;
	self.isConnected = false;
	self.socketIdCounter = socketIdCounter;
    self.socketTag = tag;

    self.isrealConnected = 0 --是否真正连接成功 ping通 行令收发

	self.socket = require("izxFW."..socketType).new(self,socketConfig.socketIp,socketConfig.socketPort,self.socketTag);

    self.socket.socketIdCounter = socketIdCounter;
    self.socket.socketTag = tag;
    self.tempClose = false;

    socketIdCounter =socketIdCounter+1;

    self.reconnectCounter = 0;
end

function SocketWrapper:connect()
	self.tempClose = false;
	
	self.socket:connect();
end

function SocketWrapper:reConnect()
	if (self.socket) then
		self.socket:close();
		self.socket:connect();
	end
end

function SocketWrapper:send(msg)
	print("Socket:send..."..msg.opcode)
	print(self.tempClose)
	-- var_dump(self.socket)
	if (self.tempClose) then
		return
	end
	if (self.socket) then
		self.socket:send(msg);
	end
end

function SocketWrapper:onOpen()
	self.tempClose = false;
	print("socket open :"..self.socketTag);
	self.isConnect = 1;
	self.ListenerLogic.onReOpened = 0;
	self.isrealConnected = 1
	self:startPing();
	-- self.ListenerLogic:onSocketOpen()
end

function SocketWrapper:onReOpen()
	print("socket reOpen :"..self.socketTag);
	self.tempClose = false;
	self.isConnect = 1;
	self.isrealConnected = 2
	self:startPing();
	self.ListenerLogic.onReOpened = 1;
	-- if (self.ListenerLogic.onSocketReOpen) then
	-- 	self.ListenerLogic:onSocketReOpen()
	-- end
end

function SocketWrapper:onMessage(message)
	self.tempClose = false;
	-- if (message.opcode == "pt_gc_task_not") then
	-- 	print("====pt_gc_task_not=============");
	-- 	var_dump(message);
	-- end
	print("SocketWrapper:onMessage"..self.isrealConnected)
	var_dump(message)
	if message.opcode=="pt_pong" and (self.isrealConnected==1 or self.isrealConnected==2) then

		if self.isrealConnected==1 then
			print("self:onOpen")
			self.ListenerLogic:onSocketOpen()
		else
			print("self:onSocketReOpen")
			if (self.ListenerLogic.onSocketReOpen) then
				self.ListenerLogic:onSocketReOpen()
			end
		end
		self.isrealConnected=0;
		self:stopPing();
		self:startPing();
		return
	end
	self.ListenerLogic:onSocketMessage(message);
end

function SocketWrapper:onTempClose()
	self:stopPing();
	self.tempClose = true;
	if (self.ListenerLogic.onSocketTempClose) then
		self.ListenerLogic:onSocketTempClose()
	end
end

function SocketWrapper:onClose()
	self.tempClose = false;
	print("socket close :"..self.socketTag);
	self.isConnect = 0;
	self:stopPing();
	self.socket = nil;
	if (self.ListenerLogic.onSocketClose~=nil) then
		self.ListenerLogic:onSocketClose();
	end
	
end
function SocketWrapper:close()
	self.isConnect = 0;
	if (self.socket) then
		echoError("Someone ask me to close socket...");
		self.socket:close();
		self:stopPing();
	end
end

function SocketWrapper:onError(error)
	print("socket error :"..self.socketTag);
end

function SocketWrapper:onConnectFailure()

	print("socket onConnectFailure :"..self.socketTag);
	if (self.ListenerLogic.onConnectFailure~=nil) then
		self.ListenerLogic:onConnectFailure();
	end
end

function SocketWrapper:setNeedReConn(need)
	if (self.socket) then
		self.socket:setNeedReConn(need)
	end
end
function SocketWrapper:startPing()

	function sendPing()
		local now = os.time();
		if self.isrealConnected ~= 1 and self.isrealConnected ~= 2 then
			if (self.ListenerLogic.onSendPing~=nil) then
				self.ListenerLogic:onSendPing(now);
			end
		end
		self:send({opcode = 'pt_ping',now_ = now});
	end
	local pingTimes = SOCKET_PING_TIME
	if self.isrealConnected == 1 or self.isrealConnected == 2 then
		pingTimes = 0.1
	end
	self.pingTimeTickScheduler = scheduler.scheduleGlobal(sendPing, pingTimes)
end

function SocketWrapper:stopPing()
	if (self.pingTimeTickScheduler) then
		scheduler.unscheduleGlobal(self.pingTimeTickScheduler);
	end
end

return SocketWrapper;