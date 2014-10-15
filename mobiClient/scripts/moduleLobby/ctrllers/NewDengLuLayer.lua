local NewDengLuLayerCtrller = class("NewDengLuLayerCtrller",izx.baseCtrller)

function NewDengLuLayerCtrller:ctor(pageName,moduleName,initParam)
	-- self.lobbyLogic = require("moduleLobby.logics.LobbyLogic").new();
    self.data = {
        ply_login_award2_ = '',
        ply_vip_ = ''
      
 
    };
    

	NewDengLuLayerCtrller.super.ctor(self,pageName,moduleName,initParam);
end

function NewDengLuLayerCtrller:run()
	

    self.logic:addLogicEvent("MSG_SOCK_pt_lc_get_user_already_login_days_ack",handler(self, self.pt_lc_get_user_already_login_days_ack),self)
	self.data.ply_login_award2_ = gBaseLogic.lobbyLogic.userData.ply_login_award2_;
    self.data.ply_vip_ = gBaseLogic.lobbyLogic.userData.ply_vip_;
	--self.data.ply_login_award_ = gBaseLogic.lobbyLogic.userData.ply_login_award_;

 	self.view:initBaseInfo();
	NewDengLuLayerCtrller.super.run(self);
	self:getEverydayTask();
    self:getHuoDongData();
    if self.data.ply_login_award2_.today_==0 then
        print("pt_cl_get_user_already_login_days_req")
        self:pt_cl_get_user_already_login_days_req();
    end
end
function NewDengLuLayerCtrller:pt_cl_get_user_already_login_days_req()
    local socketMsg = {opcode = 'pt_cl_get_user_already_login_days_req',
                        };
    self.logic:sendLobbySocket(socketMsg);
end

function NewDengLuLayerCtrller:pt_lc_get_user_already_login_days_ack(event)
    print("==================================")
    print("pt_lc_get_user_already_login_days_ack1")
    local message = event.message;
    var_dump(message)
    if message.days_~=nil then
        local ply_login_award2_ = gBaseLogic.lobbyLogic.userData.ply_login_award2_;
        local today_ = message.days_
        local money_ = 0
        if today_>#ply_login_award2_.login_award_ then
            today_ = #ply_login_award2_.login_award_
        end
        for k,v in pairs(ply_login_award2_.login_award_) do
            -- {login_days_:1,money_:1000}
            --self:createdaynode(v.login_days_,today_,v.money_)
            if (today_==v.login_days_) then
                money_ = v.money_
                break;
            end
        end
        self.view.Award1label:setString("今日登陆奖励 "..money_.." 金币！")
    end
end
function NewDengLuLayerCtrller:getEverydayTask()
    local url = URL.DAYTASK
    echoInfo("get EverydayTask: "..url);
    --self.view:Waitingbg()
    --self.view:loadingAni()
    HTTPPostRequest(url, nil, function(event)
    	print("NewDengLuLayerCtrller:getEverydayTask")
        self:onUpdateDayTask(event)
        end)
end

 function NewDengLuLayerCtrller:onUpdateDayTask(event)   
    self.taskMsg = event
    --var_dump(self.taskMsg)
    self.view:updateInfo(self.taskMsg)
end
--{"pageCount":354,"pageNow":1,"pageSize":3,"resultList":
--[{"aid":8646,"appid":449,"atime":1398150017,"content":"疯狂四月活动圆满结束，恭喜玩家“危机”获得千足金条大奖，活动获奖详细名单已经在微信公众号进行公布。","imgs":"http://img.cache.bdo.banding.com.cn/ance/春540x260.png","isLoginAnce":0,"pn":"com.izhangxin.ermj.ios.baihe","status":0,"timeStr":"","title":"获奖名单公布"},
--{"aid":8645,"appid":431,"atime":1398150017,"content":"疯狂四月活动圆满结束，恭喜玩家“危机”获得千足金条大奖，活动获奖详细名单已经在微信公众号进行公布。","imgs":"http://img.cache.bdo.banding.com.cn/ance/春540x260.png","isLoginAnce":0,"pn":"com.izhangxin.ermj.android.baihe","status":0,"timeStr":"","title":"获奖名单公布"},{"aid":8644,"appid":449,"atime":1398149943,"content":"疯狂四月活动圆满结束，恭喜玩家“危机”获得千足金条大奖，活动获奖详细名单已经在微信公众号进行公布。","imgs":"http://img.cache.bdo.banding.com.cn/ance/春540x260.png","isLoginAnce":0,"pn":"com.izhangxin.ermj.ios.baihe","status":0,"timeStr":"","title":"获奖名单公布"}],"rowCount":1061}
function NewDengLuLayerCtrller:getHuoDongData()
    --local url = URL.CURHUODONG
    --url = "http://payment.hiigame.com:18000/new/gateway/ance?pn=" --for test
    local url = "http://payment.hiigame.com:18000/new/gateway/ance?pn="
    var_dump(url)
    HTTPPostRequest(url, nil, function(event)
        print("NewDengLuLayerCtrller:getHuoDongData")
        self:onUpdateHuoDong(event)
        end)
end

function NewDengLuLayerCtrller:onUpdateHuoDong(event)   
    print("onUpdateHuoDong")
    var_dump(event,2)
    self.view:updateHuoDongInfo(event.resultList[1])
end


return NewDengLuLayerCtrller;