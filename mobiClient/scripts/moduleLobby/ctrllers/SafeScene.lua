local SafeSceneCtrller = class("SafeSceneCtrller",izx.baseCtrller)

SafeSceneCtrller.url = {}
SafeSceneCtrller.url.getPwd = URL.SAFTGETPWD--"http://t.statics.hiigame.com/get/casino/safepassword?pid={pid}&phoneno={phoneno}&ticket={ticket}&signMsg={signMsg}"

function SafeSceneCtrller:ctor(pageName,moduleName,initParam)
    self.data = {
    amount_ = 0, --保险箱的金币总数
    money_ = 0,  --用户游戏币数
    isBindMobile_ = 0, --是否绑定手机号码
    history_ = {}, -- 历史记录
    };

    SafeSceneCtrller.super.ctor(self,pageName,moduleName,initParam);
end
function SafeSceneCtrller:run()
	print("SafeSceneCtrller:run")
    self.logic:addLogicEvent("MSG_SOCK_pt_lc_get_safe_data_ack",handler(self, self.onGetSafeDataAck),self);
    self.logic:addLogicEvent("MSG_SOCK_pt_lc_store_safe_amount_ack",handler(self, self.onStoreSafeAmountAck),self);
    self.logic:addLogicEvent("MSG_SOCK_pt_lc_remove_safe_amount_ack",handler(self, self.onRemoveSafeAmountAck),self);
    self.logic:addLogicEvent("MSG_SOCK_pt_lc_get_safe_history_ack",handler(self, self.onGetHistoryAck),self);
    self.logic:addLogicEvent("MSG_SOCK_pt_lc_modify_password_safe_ack",handler(self, self.onModifyPwdAck),self);
    self.logic:addLogicEvent("MSG_SOCK_pt_lc_set_password_safe_ack",handler(self, self.onSetPwdAck),self);
    
    self.logic:onSocketSafeDataReq();
    if CONFIG_USE_SOUND==false then
        izxMessageBox("CONFIG_USE_SOUND==false", "notic")
    end

    if SKIP_PLUGIN==true then
        izxMessageBox("SKIP_PLUGIN==true", "notic")
    end
    if SKIP_UPGRADE==true then
        izxMessageBox("SKIP_UPGRADE==true", "notic")
    end
 	SafeSceneCtrller.super.run(self);
end

function SafeSceneCtrller:onGetSafeDataAck(event)
    print ("SafeSceneCtrller:onGetSafeDataAck")
	self.data.amount_ = event.message.amount_
	self.data.money_ = event.message.money_
	self.data.isBindMobile_ = event.message.isBindMobile_
	
    print("isBindMobile_ = "..self.data.isBindMobile_)
    var_dump(event.message)

    self.view:updateBaseView()
end

function SafeSceneCtrller:onStoreSafeAmountAck(event)
    -- body
    self.view:updateInLayer(event.message.ret_)
end

function SafeSceneCtrller:onRemoveSafeAmountAck(event)
    -- body
    self.view:updateOutLayer(event.message.ret_)
end

function SafeSceneCtrller:onGetHistoryAck(event)
    -- body
    --var_dump(event.message.history_)
    self.data.history_ = event.message.history_
    self.view:updateRecordLayer(event.message.ret_)
end

function SafeSceneCtrller:onModifyPwdAck(event)
    -- body
    self.view:updateModifyLayer(event.message.ret_)
end

function SafeSceneCtrller:onSetPwdAck(event)
    -- body
    print "onSetPwdAck"

    local ret = event.message.ret_
    print("ret = "..ret)
    if ret == 0 then
        ret = self.view.constData.cOperateSetPWDSuccess       
    elseif ret == -2 then
        ret = self.view.constData.cOperateSetPWDErrorFormat
    elseif ret == -1 then
        ret = self.view.constData.cOperateSetPWDErrorUnknown 
    end
    self.view:showOperateProgress("onSetPwdAck", ret)

    self.logic:onSocketSafeDataReq();
end

function SafeSceneCtrller:getbackPwd(phoneNum)
    -- body phoneno={phoneno}&ticket={ticket}&Key={Key}

    local content = "pid="..self.logic.userData.ply_guid_ .."&phoneno="..phoneNum .."&ticket="..self.logic.userData.ply_ticket_ .."&Key=".."82ce45f20e951986cc3e09fc3714adc0";
    local sign = crypto.md5(content)

    local url = string.gsub(self.url.getPwd,"{pid}",self.logic.userData.ply_guid_)
    url = string.gsub(url,"{phoneno}",phoneNum);
    url = string.gsub(url,"{ticket}",self.logic.userData.ply_ticket_);
    url = string.gsub(url,"{signMsg}",sign);
    echoInfo("getbackPwd from: "..url);

    gBaseLogic:HTTPGetdata(url,0,function(event)
        print "getbackPwd rsp"
        if (event ~= nil) then
            var_dump(event)
            local ret = tonumber(event.result)
            print("ret = "..ret)

            if ret == 0 then
                ret = self.view.constData.cOperateGetPWDSuccess       
            elseif ret == -2 then
                ret = self.view.constData.cOperateGetPWDErrorPhone   
            elseif ret == -3 then
                ret = self.view.constData.cOperateGetPWDErrorMsg 
            elseif ret == -1 then
                ret = self.view.constData.cOperateGetPWDErrorDefault 
            elseif ret == -4 then
                ret = self.view.constData.cOperateGetPWDErrorParam 
            end
            self.view:showOperateProgress("getbackPwd", ret)
        end     
    end)

end

function SafeSceneCtrller:onEnter()
    -- body
end

return SafeSceneCtrller;