local LuaSockets = class("LuaSockets");
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler");
local socket = require "socket";
local bit = require "bit";
local ByteArray = require("extensions.ByteArray");

local STATUS_CLOSED = "closed"
local STATUS_NOT_CONNECTED = "Socket is not connected"
local STATUS_TIMEOUT = "timeout"

local SOCKET_TICK_TIME = 0.1                         -- check socket data interval
local SOCKET_RECONNECT_TIME = 5                        -- socket reconnect try interval
local SOCKET_CONNECT_FAIL_TIMEOUT = 3        -- socket failure timeout

LuaSockets.TEXT_MESSAGE = 0
LuaSockets.BINARY_MESSAGE = 1
LuaSockets.BINARY_ARRAY_MESSAGE = 2

LuaSockets.OPEN_EVENT    = "open"
LuaSockets.MESSAGE_EVENT = "message"
LuaSockets.CLOSE_EVENT   = "close"
LuaSockets.ERROR_EVENT   = "error"

function LuaSockets:ctor(wrapper,ip,port,tag,needRetry)
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
    self.isFirstConnect = true;
end

function LuaSockets.getTime()
        return socket.gettime();
end

function LuaSockets:setNeedReConn(need) 
    self.isNeedReConnect = need;
end

function LuaSockets:setTickTime(_time)
        SOCKET_TICK_TIME = _time
        return self
end

function LuaSockets:setReconnTime(_time)
        SOCKET_RECONNECT_TIME = _time
        return self
end

function LuaSockets:setConnFailTime(_time)
        SOCKET_CONNECT_FAIL_TIMEOUT = _time
        return self
end


function LuaSockets:connect()
    print("LuaSockets:connect")

    if (self.isConnected) then
        self:close(); 
    end
    self.totalRecvPack = nil;
    self.socket = socket.tcp();
    self.socket:settimeout(0);
    echoInfo("SOCKET: connenting ".. self.ip .. ":" .. self.port);
    
    self.socket:connect(self.ip, self.port);
    local waitConnectTimer = 0;
    local _connectTimeTick = function ()
        print("check Connect");
        if self.isConnected then 
            scheduler.unscheduleGlobal(self.connectTimeTickScheduler)
            return 
        end
        self.waitConnect = self.waitConnect or 0
        self.waitConnect = self.waitConnect + SOCKET_TICK_TIME
        print(self.waitConnect);
        if self.waitConnect >= SOCKET_CONNECT_FAIL_TIMEOUT then
            self.waitConnect = nil
            self:close()
            self:_connectFailure()
            return;
        end
        if (self.socket==nil) then
            self.waitConnect = nil
            self:close()
            self:_connectFailure()
            scheduler.unscheduleGlobal(self.connectTimeTickScheduler)
            return;
        end
        local __body, __status, __partial = self.socket:receive("*l")
        print("[" .. self.socketTag .. "]".. __status);
        --print("receive:", __body, __status, string.len(__partial))
        if __status == STATUS_TIMEOUT then
            waitConnectTimer = waitConnectTimer+1;
            if (waitConnectTimer>0) then
                self.waitConnect = nil
                self:onOpen_();
            end
        end

    end
    self.connectTimeTickScheduler = scheduler.scheduleGlobal(_connectTimeTick, SOCKET_TICK_TIME)
end

function LuaSockets:onOpen_()
    self.isConnected = true;
    echoInfo("Lua Socket Open!!!");
    print("LuaSockets:onOpen_")
    var_dump(self.isFirstConnect)
    if (self.isFirstConnect) then
        self.wrapper:onOpen();
    else
        self.wrapper:onReOpen();
        echoInfo("Socket Re Open!!!!!")
    end
    if self.connectTimeTickScheduler then 
        scheduler.unscheduleGlobal(self.connectTimeTickScheduler) 
    end

    self.isNeedReConnect = true;
    self.reConnCounter = 0;
    local _tick = function()
        while true do
            -- if use "*l" pattern, some buffer will be discarded, why?
            if self.socket == nil then
                return
            end
            local __body, __status, __partial = self.socket:receive("*a")        -- read the package body
            
            if __status == STATUS_CLOSED or __status == STATUS_NOT_CONNECTED then
                self:close()
                if self.isConnected then
                    self:_onDisconnect()
                else 
                    self:_connectFailure()
                end
                return
            end
            --echoInfo(self.socketTag .. "__status:[" .. __status .. "]");
            --echoInfo(self.socketTag .. ":__body:[" ..__body .."],__status:[" .. __status .. "],__partial:[" .. __partial .."]");
            if  (__body and string.len(__body) == 0) or
                (__partial and string.len(__partial) == 0) then
                return
            end
            echoInfo(self.socketTag .. ":Lua Socket get data...");
            if __body and __partial then
                __body = __body .. __partial
            end
            
            local data=(__partial or __body);
            self:onRecv_(data);
        end
    end

    -- start to read TCP data
    self.tickScheduler = scheduler.scheduleGlobal(_tick, SOCKET_TICK_TIME)
end

function LuaSockets:_onDisconnect()
    echoError("["..self.socketTag.."]DISCONNECT");
    self:close();
    if (self.isNeedReConnect and self.reConnCounter<SOCKET_RECONNECT_TIME) then
        echoInfo("TEMP CLOSE!!!");

        self.wrapper:onTempClose();
        scheduler.performWithDelayGlobal(function()
            self:reConnect();
        end, 0.2)
    else
        self.isFirstConnect = true;
        self.wrapper:onClose();
    end
end

function LuaSockets:_connectFailure()
    echoError("["..self.socketTag.."]CONNECT FAIL");
    echoInfo("self.reConnCounter = "..self.reConnCounter);

    self:close();
    -- if (network.isInternetConnectionAvailable()==false) then
    --     self.wrapper:onConnectFailure();
    --     return;
    -- end
    -- if (self.reConnCounter==0) then
    --     self.wrapper:onConnectFailure();
    -- else

    if (self.isNeedReConnect and self.reConnCounter<SOCKET_RECONNECT_TIME) then
        self:reConnect();
    else
        
        if (self.reConnCounter>=SOCKET_RECONNECT_TIME) then
            self.isFirstConnect = true;
            self.wrapper:onClose();
        else
            self.isFirstConnect = true;
            self.wrapper:onConnectFailure();
        end
    end
    -- end
    
end

function LuaSockets:reConnect()
    print ("SOCKET: retry ".. self.ip .. ":" .. self.port);
    print("self.reConnCounter = "..self.reConnCounter);
    self.reConnCounter = self.reConnCounter+1;
    self.isConnected = false;
    self.isFirstConnect = false;
    self.socket = nil;
    self:connect();
end

function LuaSockets:isReady()
    if (self.socket) then
        if (self.socket:getstats() == "0") then
            print(self.socket:getstats());
            return false
        else 
            return true
        end
    else
        return false
    end
end

function LuaSockets:encode(data)
    local opcode = data.opcode;
    
    if (packetDefine[opcode]==nil) then
        echoError("Unknown packet!encoding:%s",opcode);
        return;
    end
    local protocols = packetDefine[opcode];
    -- print("--------------------------");
    -- var_dump(protocols);
    -- print("--------------------------");
    self:encodeProtos( protocols, data,1);
end

function LuaSockets:encodeValue(protos,msg)
    local type_txt = protos["type"];
    local name_txt = protos["name"];

    local switch = {    
        guid =      function(value) 
                                if (value==nil) then
                                    value = 0;
                                end
                                local high = math.floor(value / 0x100000000);
                                local low = value % 0x100000000;
                     
                                self.sendByte:writeInt(high) ;
                                self.sendByte:writeUInt(low) ;
                            end,
        float =     function(value) 
                            if (value==nil) then
                                value = 0;
                            end
                            local float = string.format("%f",value)
                            self.sendByte:writeShort(string.len(float));
                            self.sendByte:writeString(float)
                          return tonumber(float)
                            end,
        string =    function(value)
                            if (value==nil) then
                                value = "";
                            end 
                                self.sendByte:writeShort(string.len(value));
                                self.sendByte:writeString(value) 
                            end,
        int64 =     function(value) 
                            if (value==nil) then
                                value = 0;
                            end
                                local high = math.floor(value / 0xFFFFFFFF);
                                local low = value % 0x100000000;
                                self.sendByte:writeInt(high) ;
                                self.sendByte:writeUInt(low) ; 
                            end,
        int =       function(value) 
                            if (value==nil) then
                                value = 0;
                            end
                            self.sendByte:writeInt(value) 
                        end,
        uint =      function(value)  
                            if (value==nil) then
                                value = 0;
                            end
                            self.sendByte:writeUInt(value) 
                            end,
        short =     function(value)  
                            if (value==nil) then
                                value = 0;
                            end
                            self.sendByte:writeShort(value) 
                            end,
        ushort =    function(value)  
                            if (value==nil) then
                                value = 0;
                            end
                            self.sendByte:writeShort(value) 
                            end,
        byte =      function(value)  
                            if (value==nil) then
                                value = 0;
                            end
                            self.sendByte:writeByte(value) 
                            end,
        char =      function(value)  
                            if (value==nil) then
                                value = 0;
                            end
                            self.sendByte:writeChar(value) 
                        end
    };
    if (switch[type_txt]) then
        switch[type_txt](msg)
    else 
        
        print ("analyses " .. name_txt .. " as " .. type_txt);
        self:encodeProtos( packetDefine[type_txt], msg,2);
    end
end

function LuaSockets:decodeValue(recvPack,protos)
    local type_txt = protos["type"];
    local name_txt = protos["name"];

    local switch = {    
        guid =      function()
                        local high = 1.0*recvPack:readInt() ;
                        local low = 1.0*recvPack:readUInt() ;
                        local t_int64 = high*(2^32)+low;
                        if (t_int64>9007199254740991) then 
                            echoError("Lua don't support int longger than 9007199254740991,but your's are %f", t_int64);
                        end
                        return t_int64; 
                    end,
        float =     function() 
                        local _len = recvPack:readShort();
                        local float = recvPack:readStringBytes(_len) 
                        return tonumber(float)
                        end,
        string =    function() 
                                local _len = recvPack:readShort();
                                return recvPack:readStringBytes(_len) 
                                end,
        int64 =     function() 
                        local high = recvPack:readInt() ;
                        local low = recvPack:readUInt() ;
                        local t_int64 = high*(2^32)+low;
        
                        return t_int64;
                    end,
        int =       function() return recvPack:readInt() end,
        uint =      function() return recvPack:readUInt() end,
        short =     function() return recvPack:readShort() end,
        ushort =    function() return recvPack:readUShort() end,
        byte =      function() return recvPack:readByte() end,
        char =      function() return recvPack:readChar() end
    };
    
    local msg;
    if (switch[type_txt]) then
        if (name_txt=="opcode") then
            local tmp_value = switch[type_txt]();
            msg = opcodeReverse[tmp_value] or tmp_value;
        else
            msg = switch[type_txt]()
        end
    else 
        
        --print("read a structure as :"..type_txt);
        if (packetDefine[type_txt]) then
            msg = self:decodeProtos(recvPack, packetDefine[type_txt]);
        else
            echoError("!!!!!!!PACKET ERROR:no define structure:"..type_txt); 
        end
    end
    return msg;
end

function LuaSockets:encodeProtos(protos, msg,depth)
    local protos_len = #protos;
    for i = 1,protos_len,1 do
        local proto = protos[i];
        local name_txt = proto.name;
        local option_txt = proto.option;
        if (name_txt == "opcode") then
            if (msg.opcode == nil or (msg.opcode~=0 and opcodeDefine[msg.opcode]==nil)) then
            --     echoError("!!!!!!!PACKET ERROR:no define opcode:"); 
            --     var_dump(msg.opcode);
            --     return;
            -- elseif msg.opcode==0 then
            --     opcode_value = 0;
                if (depth==1) then
                    echoError("!!!!!!!PACKET ERROR:no define opcode:"); 
                    var_dump(msg.opcode);
                    return;
                else
                    opcode_value = 999;
                end
            else
                opcode_value = opcodeDefine[msg.opcode];
            end
            self:encodeValue(proto,opcode_value);
        elseif (option_txt=="required") then
            root = msg[name_txt];
            self:encodeValue(proto,root);
        elseif (option_txt=="repeated") then 
            self.sendByte:writeShort(#msg[name_txt])
            for j=1,#msg[name_txt],1 do
                self:encodeValue(proto,msg[name_txt][j]);
            end
        end
    end
end

function LuaSockets:decodeProtos(recvPack,protos)
    local protos_len = #protos;
    local msg = {};
    for i = 1,protos_len,1 do
        local proto = protos[i];
        local name_txt = proto.name;
        local option_txt = proto.option;
        local type_txt = proto.type;
        
        if (name_txt == "opcode") then
            msg[name_txt] = self:decodeValue(recvPack,proto);
        elseif (option_txt=="required") then
            msg[name_txt] = self:decodeValue(recvPack,proto);
        elseif (option_txt=="repeated") then 
            msg[name_txt] = self:decodeArray(recvPack,proto);
        end
    end
    -- print("result is :");
    -- var_dump(msg);
    -- print("--------result end--------");
    return msg;
end

function LuaSockets:decodeArray(recvPack,proto)    
    local len = recvPack:readShort();
    local msg = {};
    for j=1,len,1 do
        msg[j] = self:decodeValue(recvPack,proto);
    end
    return msg;
end

function LuaSockets:PackPacket(data)
    local bit = require("bit")
    local m_shSeed = 1606;
    self.sendByte = ByteArray.new();
    self.sendByte:setEndian(self.sendByte.ENDIAN_BIG);
    -- print("=========data==================")
    -- var_dump(data);
    -- print("==========data=================")
    self:encode(data);
    self.sendPack = ByteArray.new();
    self.sendPack:setEndian(self.sendPack.ENDIAN_BIG);
    local nInLen = self.sendByte:getLen();

    local cCompress = 0;
    local cCRC = 0;
    local sInLen = 0;
    local sVerifyCode = 0;
    self.sendByte:setPos(1);

    sVerifyCode = bit.bxor(nInLen , m_shSeed);
    for i = 1,nInLen,1 do
        cCRC = cCRC + self.sendByte:readUChar();
    end

    self.sendPack:writeShort(nInLen);
    self.sendPack:writeShort(sVerifyCode);
    self.sendPack:writeChar(cCompress);
    self.sendPack:writeChar(cCRC);

    self.sendByte:setPos(1);
    for i = 1,nInLen,1 do
        self.sendPack:writeChar(self.sendByte:readUChar());
    end
    
end

function LuaSockets:unPackPacket(recvPack)
    --require("extensions.mobdebug").start() 
    echoVerb("---------------");
    echoVerb("recv package will do unpack");
    recvPack:setPos(1);
    
    local opCode = recvPack:readShort();
    if (opcodeReverse[opCode]==nil) then
        print("Unknown packet!"..opCode);
        return;
    end
    local real_opcode = opcodeReverse[opCode];
    echoVerb("recv opcode :"..opCode.." as "..real_opcode);
    if (opcodeDefine[real_opcode]==nil) then
        print("Unknown packet!"..real_opcode);
        return;
    end
    local data = {};
    local protocols = packetDefine[real_opcode];
    recvPack:setPos(1);
    --require("extensions.mobdebug").start();
    data = self:decodeProtos(recvPack, protocols);
    echoVerb("Recving Msg Info>>>>>>>>>");
    if (DEBUG>=3) then
        var_dump(data,4);
    end
    echoVerb("Recving Msg Info end");
    return data;
end

function LuaSockets:readBuff()

end

function LuaSockets:onRecv_(data)
    if (self.totalRecvPack==nil) then
        self.data = '';
        self.totalRecvPack = ByteArray.new();
        self.totalRecvPack:setEndian(ByteArray.ENDIAN_BIG);
        self.nInLen = 0;
    end
    self.totalRecvPack:writeBufNoChangePos(data);
    self.data = self.data .. data;
    if (SOCKET_DEBUG==true) then
        echoInfo("recv Msg as---------------");
        echoInfo(self.totalRecvPack:toString(16));
        echoInfo("end --------------");
    end
    while (self.totalRecvPack~=nil and self.totalRecvPack:getAvailable()>0) do 
        if (self.nInLen==0) then 
            self.nInLen = self.totalRecvPack:readShort();
            local sVerifyCode = self.totalRecvPack:readShort();
            local cCompress = self.totalRecvPack:readChar();
            local cCRC = self.totalRecvPack:readChar();
            echoVerb("!!!!!A MESSAGE COMMING!!!nInLen:"..self.nInLen);
        else
            echoVerb("!!!!!CONTINUE MESSAGE!!!nInLen:"..self.nInLen);
        end
        
        if (self.totalRecvPack:getAvailable()<self.nInLen) then
            print("--------------------NOT RECV FULL PACKAGE------------"..self.totalRecvPack:getAvailable());
            return;
        else 
            local recvPack = ByteArray.new();
            recvPack:setEndian(recvPack.ENDIAN_BIG);
            recvPack:writeBuf(string.sub(self.data,self.totalRecvPack:getPos(),self.totalRecvPack:getPos()+self.nInLen));
            self.totalRecvPack:readBuf(self.nInLen)
            -- recvPack:writeBuf(self.totalRecvPack:readBuf(self.nInLen));
            -- 
            if (SOCKET_DEBUG==true) then
                echoInfo("WILL Decoding Msg as---------------");
                echoInfo(recvPack:toString(16));
                echoInfo("end --------------");
            end
            
            local message = self:unPackPacket(recvPack);
            -- if (message.opcode == "pt_gc_task_not") then
            --     print("LUASOCKET====pt_gc_task_not=============");
            --     var_dump(message);
            -- end
            if (message~=nil) then
                local status, err = pcall((function()
                    self.wrapper:onMessage(message);
                end));
                
                if (status) then

                else
                    echoError("There are Error to handler socket msg");
                    var_dump(message,3);
                    var_dump(err);
                end

                -- echoInfo("Decoding Msg as---------------"..message.opcode);
                -- var_dump(message,3);
            end
            recvPack = nil;
            self.nInLen = 0;
        end
        
    end    
    self.totalRecvPack = nil;
    self.nInLen = 0;
    self.recvPos = nil;
end

function LuaSockets:send(data)
    -- print("LuaSockets:send() - socket is't ready")
    if not self:isReady() then
        print("LuaSockets:send() - socket is't ready")
        return false
    end
    echoVerb("Sending Msg as---------------");
    self.sendByte = nil;
    self:PackPacket(data);
    echoVerb("Encoding Msg as---------------");
    echoVerb(self.sendPack:toString(16));
    echoVerb("end --------------");
    self.socket:send(self.sendPack:getPack());
    -- self.socket:send("ccssssssssssssc");
    -- LuaSockets:onRecv_(self.sendPack:getPack());
    print "sending";
    return true
end

function LuaSockets:close()
    
    self.totalRecvPack = nil;
    self.nInLen = 0;
    self.recvPos = nil;

    if self.socket then
        if self.connectTimeTickScheduler then 
            scheduler.unscheduleGlobal(self.connectTimeTickScheduler) 
        end
        if self.tickScheduler then 
            scheduler.unscheduleGlobal(self.tickScheduler) 
        end
        self.socket:close()
        self.socket = nil
    end
end

function LuaSockets:onError_(error)
    self.wrapper:onError(error);
end

return LuaSockets
