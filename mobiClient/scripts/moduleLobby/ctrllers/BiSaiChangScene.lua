local BiSaiChangSceneCtrller = class("BiSaiChangSceneCtrller",izx.baseCtrller)

function BiSaiChangSceneCtrller:ctor(pageName,moduleName,initParam)
    self.data = {
        riCheng = {},
        history = {},
        ply_items={},
        huafeiquan = 0,
        gift = 0,
        money = 0,
        cansaiquan = 0,
        vipLevel = 0,
    };
    self.raceTimeList = {};
	BiSaiChangSceneCtrller.super.ctor(self,pageName,moduleName,initParam);
end

function BiSaiChangSceneCtrller:resetData(data)
    if nil ~= data then 
        self.data.riCheng = data.riCheng
        self.data.history = data.history
        if data.curtime~=nil then
        	self.data.curtime = data.curtime
        end
    end
    self.data.ply_items = gBaseLogic.lobbyLogic.userData.ply_items_
    self.data.huafeiquan = self:getItemNumber(56) 
    self.data.cansaiquan = self:getItemNumber(3) 
    self.data.gift = gBaseLogic.lobbyLogic.userData.ply_lobby_data_.gift_
    self.data.money = gBaseLogic.lobbyLogic.userData.ply_lobby_data_.money_
    self.data.vipLevel = gBaseLogic.lobbyLogic.vipData.vipLevel
end

function BiSaiChangSceneCtrller:run()
    print ("BiSaiChangSceneCtrller:run")

    self.logic:addLogicEvent("MSG_SOCK_pt_lc_do_sign_match_ack",handler(self, self.pt_lc_do_sign_match_ack),self)

    self.logic:addLogicEvent("MSG_change_chongzhi_btn",handler(self, self.quickPayResult),self)

    self.logic:addLogicEvent("MSG_Socket_pt_lc_match_perpare_notf",handler(self, self.pt_lc_match_perpare_notf),self)


    self.logic:addLogicEvent("MSG_Socket_pt_lc_send_user_data_change_not",handler(self, self.pt_lc_send_user_data_change_not),self)

    BiSaiChangSceneCtrller.super.run(self);
    
    

    -- if gBaseLogic.lobbyLogic.matchInfo == nil then 
        self:reqRaceRoomInfoData() 
    -- else 
    --     self:resetData(gBaseLogic.lobbyLogic.matchInfo)
    --     self.view:initBaseInfo(); 
    -- end
end

function BiSaiChangSceneCtrller:getItemNumber(index) 
    local num = 0
    for k,v in pairs(self.data.ply_items) do 
        --print(index,v.index_,v.num_)
        if v.index_ == index then 
            num = v.num_ 
        end
    end 
    return num
end

function BiSaiChangSceneCtrller:quickPayResult(event)
    print("quickPayResult")
    if event.message.code == 0 then 
        self:resetData() 
        self.view:resetLabelValue(self.data)
    else
        izxMessageBox("支付失败", "支付提示")
    end
end 

function BiSaiChangSceneCtrller:pt_lc_send_user_data_change_not(event)
    print("BiSaiChangSceneCtrller:pt_lc_send_user_data_change_not")
    self:resetData() 
    self.view:resetLabelValue(self.data)
end

function BiSaiChangSceneCtrller:pt_lc_match_perpare_notf(event)
    print("MSG_Socket_pt_lc_match_perpare_notf")
    var_dump(gBaseLogic.lobbyLogic.matchData,3)
    gBaseLogic:unblockUI();
    for k,v in pairs(gBaseLogic.lobbyLogic.matchData) do 
        self.view:showMatchStartAni(v.match_id_) 
    end 
end 
--http://t.statics.hiigame.com/get/player/bonus?guid=9910040000000005&gameid=10&matchid=1&index=3
function BiSaiChangSceneCtrller:reqMatchGetAward(target)
    print("BiSaiChangSceneCtrller:reqMatchGetAward")
    local tag = target:getTag()
    local x = self.data.history[tag]
    local tableRst = {gameid=MAIN_GAME_ID,guid = gBaseLogic.lobbyLogic.userData.ply_guid_,matchid=x.matchid,index=x.index};

    gBaseLogic:blockUI();
    HTTPPostRequest(URL.MATCHGETAWARDE, tableRst, function(event)
        gBaseLogic:unblockUI();
        var_dump(tableRst)
        if (event ~= nil) then
            var_dump(event,5)
            if event.ret == 0 then 
            	
                gBaseLogic.lobbyLogic.matchInfo.history[tag].state=1
                self.data.history[tag].state=1
                gBaseLogic.sceneManager.currentPage.view:closePopBox();
                if event.reward~=nil then
                	local item = {}
                	for k,v in pairs(event.reward) do
                		if self.logic.userData.items_user[v.itemindex]~=nil then
                			table.insert(item,self.logic.userData.items_user[v.itemindex].name_.."x"..v.itemcount);
                		end
                	end
                	local itemDesc = table.concat(item, ",");
                	gBaseLogic:alertbox("领取奖励成功，获得"..itemDesc ..",请去背包查看", 1)
                	
                else
                	izxMessageBox("领取奖励成功，请去背包查看","提示")
                end
                
            else
            	izxMessageBox("领取奖励失败，或者已经领取过了","提示")
            end
        end     
        end);
end


function BiSaiChangSceneCtrller:reqRaceRoomInfoData(flag)
    print("BiSaiChangSceneCtrller:reqRaceRoomInfoData")

    local tableRst = {gameid=MAIN_GAME_ID,guid = gBaseLogic.lobbyLogic.userData.ply_guid_};
    if flag==nil or flag==false then
    	gBaseLogic:blockUI();
    end
    HTTPPostRequest(URL.MATCHINFODATA, tableRst, function(event)
    	if flag==nil or flag==false then
        	gBaseLogic:unblockUI();
        end
        print("BiSaiChangSceneCtrller:reqRaceRoomInfoData")
        var_dump(tableRst)
        if (event ~= nil) then
            var_dump(event,5)
            --local message =  self:initRaceRoomLocalInfoData()
            local message = event 
            gBaseLogic.lobbyLogic.matchInfo = message
            if flag then
	            if self.view.serTimeHandler~=nil then
				 	scheduler.unscheduleGlobal(self.view.serTimeHandler)
			    	self.view.serTimeHandler = nil
			    end
			end
            self:resetData(message)
            self.view:initBaseInfo(); 
        end     
        end);
end
--[[
race：0未开始 1开始 2结束啊
function BiSaiChangSceneCtrller:initRaceRoomLocalInfoData()
    print("initRaceRoomLocalInfoData")
    local info = {
        ret = 0,
        riCheng = {                
            {matchid= 1, race=0, name = "500现金争霸赛",desc="每月1日，15日21:30各一场",time=1398213017,ticket="1参赛券",money=0,vip=0,voucher=1,state = 0,type=3,rule="进行4轮比赛，每轮比赛积分为0的选手被淘汰，4轮后积分最高的前三名获胜",reward={{indx=1,rank="冠军",bonus="500元现金券"},
            {indx=2,rank="亚军",bonus="50元现金券"},
            {indx=3,rank="季军",bonus="10元现金券"},
            {indx=4,rank="4-12名",bonus="50万游戏币"},
            {indx=13,rank="13-50名",bonus="5万游戏币"}}},

            {matchid= 2, race=0, name = "100元话费赛",desc="每天21:00一场",time=1398210018,ticket="10万，VIP7免费",money=0,vip=0,voucher=1,state = 0,type=2,rule="进行4轮比赛，每轮比赛积分为0的选手被淘汰，4轮后积分最高的前三名获胜",reward={{indx=1,rank="冠军",bonus="100元话费券"},
            {indx=2,rank="亚军",bonus="50元话费券"},
            {indx=3,rank="季军",bonus="10元话费券"},
            {indx=4,rank="4-12名",bonus="50万游戏币"},
            {indx=13,rank="13-50名",bonus="5万游戏币"}}},

            {matchid= 3, race=0, name = "50元话费赛",desc="每天12:00-20:00各一场",time=1398150019,ticket="5万，VIP5免费",money=0,vip=0,voucher=1,state = 1,type=1,rule="进行4轮比赛，每轮比赛积分为0的选手被淘汰，4轮后积分最高的前三名获胜",reward={{indx=1,rank="冠军",bonus="50元话费券"},
            {indx=2,rank="亚军",bonus="10元话费券"},
            {indx=3,rank="季军",bonus="50万游戏币"},
            {indx=4,rank="4-12名",bonus="10万游戏币"},
            {indx=13,rank="13-50名",bonus="5万游戏币"}}},

            {matchid= 4, race=0, name = "10元话费赛",desc="每天9:30-23:30每二个小时1场",time=1398150020,ticket="1万，VIP2免费",money=0,vip=0,voucher=1,state = 1,type=1,rule="进行4轮比赛，每轮比赛积分为0的选手被淘汰，4轮后积分最高的前三名获胜",reward={{indx=1,rank="冠军",bonus="10元话费券"},
            {indx=2,rank="亚军",bonus="50万游戏币"},
            {indx=3,rank="季军",bonus="10万游戏币"},
            {indx=4,rank="4-12名",bonus="5万游戏币"},
            {indx=13,rank="13-50名",bonus="1万游戏币"}}},

            {matchid= 5, race=0, name = "3元话费赛",desc="每天9:00-23:00每一个小时1场",time=1398150021,ticket="2千，VIP2免费",money=0,vip=0,voucher=1,state = 0,type=1,rule="进行4轮比赛，每轮比赛积分为0的选手被淘汰，4轮后积分最高的前三名获胜",reward={{indx=1,rank="冠军",bonus="3元话费券"},
            {indx=2,rank="亚军",bonus="50万游戏币"},
            {indx=3,rank="季军",bonus="10万游戏币"},
            {indx=4,rank="4-12名",bonus="3万游戏币"},
            {indx=13,rank="13-50名",bonus="1万游戏币"}}},
        },
        history={{index=1,matchid= 1,day=1398213017,name = "500现金争霸赛",rank="季军",bonus="100元现金",state=0},{index=2,matchid= 1,day=1398213017,name = "10元话费争霸赛",rank="冠军",bonus="10元话费券",state=1},{index=3,matchid= 1,day=1398213017,name = "50元话费争霸赛",rank="10",bonus="5万游戏币",state=1},{index=4,matchid= 1,day=1398213017,name = "100元话费争霸赛",rank="亚军",bonus="10元话费券",state=1},{index=5,matchid= 1,day=1398213017,name = "3元话费争霸赛",rank="亚军",bonus="1万游戏币",state=1}},
    }
    return info
end 

----]]

function BiSaiChangSceneCtrller:pt_cl_do_sign_match_req(id)
    print("pt_cl_do_sign_match_req")
    self.view:loadingAni()
    --调用showBaoMing时已经加判断了
    local operate_type_ = 0
    if self.data.riCheng[id].race == 0 then
    	 operate_type_= self.data.riCheng[id].state == 0 and 1 or 2;
    else
    	if self.data.riCheng[id].state==1 then
    		operate_type_ = 3;
    	else
    		izxMessageBox("比赛已经开始，不能报名", "提示")
    		return
    	end
    end
    var_dump(self.data.riCheng[id])
    local socketMsg = {opcode = 'pt_cl_do_sign_match_req',
                       match_id_ = self.data.riCheng[id].matchid, 
                       match_order_id_ = 0,
                       operate_type_= operate_type_,
                       }
    var_dump(socketMsg)
    gBaseLogic.lobbyLogic:sendLobbySocket(socketMsg);

    --for test 
    --[[
    function pt_lc_do_sign_match_ack()
        gBaseLogic.lobbyLogic:dispatchLogicEvent({
                    name = "MSG_SOCK_pt_lc_do_sign_match_ack",
                    message = {ret_ = 0, operate_type_ = socketMsg.operate_type_, match_id_ = socketMsg.match_id_}
                });
    end
    scheduler.performWithDelayGlobal(pt_lc_do_sign_match_ack, 1.0)
    ----]]
end 

function BiSaiChangSceneCtrller:pt_lc_do_sign_match_ack(event)
    print("pt_lc_do_sign_match_ack")
    local message = event.message;
    self.view:unWaitingAni()
    var_dump(event)
    gBaseLogic.sceneManager.currentPage.view:closePopBox();

    if message.ret_ == 0 then
    	local thisid=1;
    	for k,v in pairs(gBaseLogic.lobbyLogic.matchInfo.riCheng) do
    		if v.matchid==message.match_id_ then
    			thisid = k;
    			break;
    		end
    	end

        if message.operate_type_  == 1 then             
            self.data.riCheng[thisid].state = 1
            sendNotifyByTS(self.data.riCheng[thisid].time-120,"亲，您报名的一场"..
            	self.data.riCheng[thisid].name.."元话费赛2分钟后就要开始咯，下周的话费就靠它了！","温馨提示");

            gBaseLogic.lobbyLogic.matchInfo.riCheng[thisid].state = 1
            izxMessageBox("报名成功，请等待比赛开始。","温馨提示")
            
        elseif message.operate_type_ ==2 then
            self.data.riCheng[thisid].state = 0
            deleteNotifyByTS(self.data.riCheng[thisid].time-120);
            gBaseLogic.lobbyLogic.matchInfo.riCheng[thisid].state = 0
            izxMessageBox("取消报名成功，请选择其他比赛。","温馨提示")
        elseif message.operate_type_ ==3 then 
        	izxMessageBox("退赛成功","温馨提示")
        	gBaseLogic.lobbyLogic.matchInfo.riCheng[thisid].state = 0

        end
        self.logic:sendReloadUserData()
        self:reqRaceRoomInfoData(true)
    else 
        local msg_array = {[-1]="比赛不存在",[-2]="vip等级不够",[-3]="没有报名费",[-4]="比赛已经开始",[-5]="本轮没有结束",[-6]="没有报名",[-7]="没有参赛券",[-8]="您在这场比赛前后30分钟内报名了其它比赛",[-9]="比赛报名时间未到"}

    	if msg_array[message.ret_]~=nil then
    		izxMessageBox(msg_array[message.ret_],"温馨提示")
    		
    		
    	else
			if message.operate_type_  == 1 then
				izxMessageBox("报名失败","温馨提示")
			elseif message.operate_type_  == 2 then
				izxMessageBox("取消报名失败","温馨提示")
			elseif message.operate_type_  == 3 then
				izxMessageBox("退出比赛失败","温馨提示")
			else
				izxMessageBox("未知错误","温馨提示")
				
			end
			
    	end
    	self:reqRaceRoomInfoData(true)
        
    end 
    
end 

return BiSaiChangSceneCtrller;
