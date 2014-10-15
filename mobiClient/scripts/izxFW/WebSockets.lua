
local WebSockets = class("WebSockets")

function WebSockets:ctor(ctrller,ip,port,tag)
    self.ctrller = ctrller;
    self.url = ip .. ":" .. port .. "/" .. tag;
end

function WebSockets:connect()
    require("framework.api.EventProtocol").extend(self)
    self.socket = WebSocket:create(self.url)
    if self.socket then
        self.socket:registerScriptHandler(handler(self, self.onOpen_), kWebSocketScriptHandlerOpen)
        self.socket:registerScriptHandler(handler(self, self.onMessage_), kWebSocketScriptHandlerMessage)
        self.socket:registerScriptHandler(handler(self, self.onClose_), kWebSocketScriptHandlerClose)
        self.socket:registerScriptHandler(handler(self, self.onError_), kWebSocketScriptHandlerError)
    end
end

function WebSockets:isReady()

    return self.socket and self.socket:getReadyState() == kStateOpen
end


function WebSockets:send(data)
    if not self:isReady() then
        echoError("WebSockets:send() - socket is't ready")
        return false
    end

    self.socket:sendTextMsg(json.encode(data))
    return true
end

function WebSockets:close()
    if self.socket then
        self.socket:close()
        self.socket = nil
    end
    self:removeAllEventListeners()
end

function WebSockets:onOpen_()
    self.ctrller:onOpen();
end

function WebSockets:onMessage_(message, messageLength)
    self.ctrller:onMessage(json.decode(message));
end

function WebSockets:onClose_()
    self.ctrller:onClose();
    self:close()
end

function WebSockets:onError_(error)
    self.ctrller:onError();
end

return WebSockets
