--
-- Author: Guo Jia
-- Date: 2014-04-08 17:53:28
--
local CSockets = class("CSockets");
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler");
local bit = require "bit";
local ByteArray = require("extensions.ByteArray");

local STATUS_CLOSED = "closed"
local STATUS_NOT_CONNECTED = "Socket is not connected"
local STATUS_TIMEOUT = "timeout"

local SOCKET_TICK_TIME = 0.1                         -- check socket data interval
local SOCKET_RECONNECT_TIME = 5                        -- socket reconnect try interval
local SOCKET_CONNECT_FAIL_TIMEOUT = 3        -- socket failure timeout

CSockets.TEXT_MESSAGE = 0
CSockets.BINARY_MESSAGE = 1
CSockets.BINARY_ARRAY_MESSAGE = 2

CSockets.OPEN_EVENT    = "open"
CSockets.MESSAGE_EVENT = "message"
CSockets.CLOSE_EVENT   = "close"
CSockets.ERROR_EVENT   = "error"

function CSockets:ctor(wrapper,ip,port,tag,needRetry)
    self.wrapper = wrapper;
    self.ip = ip;
    self.port = port;
    self.socketTag = tag;
    self.isConnected = false;
    self.counter = 1;
    self.tickScheduler = nil                        -- timer for data
    self.reconnectScheduler = nil                -- timer for reconnect
    self.connectTimeTickScheduler = nil        -- timer for connect timeout
    self.isNeedRetry = needRetry;
    self.isNeedReConnect = true;
    self.reConnCounter = 0;
end

function CSockets.getTime()
        return socket.gettime();
end

function CSockets:setNeedReConn(need) 
    self.isNeedReConnect = need;
end

function CSockets:setTickTime(_time)
        SOCKET_TICK_TIME = _time
        return self
end

function CSockets:setReconnTime(_time)
        SOCKET_RECONNECT_TIME = _time
        return self
end

function CSockets:setConnFailTime(_time)
        SOCKET_CONNECT_FAIL_TIMEOUT = _time
        return self
end

function CSockets:onSocket(event)
	var_dump(event);
end

function CSockets:connect()
    print("CSockets:connect")

    if (self.isConnected) then
        self:close(); 
    end
    self.totalRecvPack = nil;
    self.socket = MBSocket:createLua(handler(self,onSocket),self.ip,tonumber(self.port));
    echoInfo("SOCKET: connenting ".. self.ip .. ":" .. self.port);
    
    self.socket:Connect();
    
end

return CSockets
