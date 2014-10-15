local popChildren = class("SafeOperateProgress",izx.basePopup);
function popChildren:ctor(data,relateView)
    self.super.ctor(self,"SafeOperateProgress",data,relateView);
end

function popChildren:onAssignVars()
    self.labelPop2Progress = tolua.cast(self["labelPop2Progress"],"CCLabelTTF")
    self.labelPop2Result = tolua.cast(self["labelPop2Result"],"CCLabelTTF")

    self.labelPop2Progress:setVisible(false)
    self.labelPop2Result:setVisible(false)

    if self.data.type == "progress" then
        print 'cOperateCheckProgress'
        self.labelPop2Progress:setVisible(true)
        self.labelPop2Result:setVisible(false)
        local textConfig = {
            bind = '正在绑定手机号，请稍后...',
            getpwd = '正在处理，请稍后...',
            his = '正在获取数据，请稍后...',
            save = '正在存入金币，请稍后...',
            remove = '正在取出金币，请稍后...',
            modify = '正在获取数据，请稍后...'
        };
        local text = textConfig[self.data.ret];
        if (text==nil) then
            text = '正在处理，请稍后...';
        end
        self.labelPop2Progress:setString(text);
    else
        self.labelPop2Progress:setVisible(false)
        self.labelPop2Result:setVisible(true)
        local text = '';
        local textConfigG = {
            [-100] = "操作失败,网络超时",
            [-99] = '已发送短信,请查收',
            [-98] = '手机号与绑定手机号不一致',
            [-97] = '短信发送失败',
            [-96] = '设置失败',
            [-95] = '设置失败',
            [-94] = '成功',
            [-93] = '设置失败',
            [-92] = '输入格式有误'
        }
        text = textConfigG[self.data.ret]
        if (text==nil) then
            local textConfig = {
                onSetPwdAck = {
                    [0] = '成功'
                },
                getbackPwd = {
                    [0] = '成功'
                },
                updateInLayer = {
                    [0] = '存入成功',
                    [-1] = '未知错误',
                    [-2] = '存入金额有误',
                    [-3] = '非VIP用户不能存入',
                    [-4] = '您正在游戏中,无法存取游戏币!请游戏结束后再尝试。'
                },
                updateOutLayer = {
                    [0] = '领取成功',
                    [-1] = '未知错误',
                    [-2] = '取出金额有误',
                    [-3] = '取现密码有误',
                    
                    -- [self.data.cOperateGetPWDErrorDefault] =  '服务器错误',
                    -- [self.data.cOperateGetPWDErrorParam] =  '参数传入错误'
                },
                updateRecordLayer = {
                    [0] = '成功获取记录',
                    [-1] = '记录为空'
                },
                updateModifyLayer = {
                    [0] = '修改成功',
                    [-1] = '未知错误',
                    [-2] = '原密码有误'
                }
            };
            text = textConfig[self.data.type][self.data.ret];
            if (text==nil) then
                text = '未知错误';
            end
        end
        self.labelPop2Result:setString(text)
    end
end

function popChildren:onClosePopBox()
    izx.baseAudio:playSound("audio_menu");
    self.relateView.popChildren = nil;
    self.super.onClosePopBox(self);
end

return popChildren;