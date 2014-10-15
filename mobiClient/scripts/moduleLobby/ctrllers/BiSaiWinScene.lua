local BiSaiWinSceneCtrller = class("BiSaiWinSceneCtrller",izx.baseCtrller)

function BiSaiWinSceneCtrller:ctor(pageName,moduleName,initParam)
    self.data = {
        matchResult={}
    };
    self.matchTitle = {
        [1]="images/BiSai/bisai_sanyuansai.png",
        [2]="images/BiSai/bisai_10yuansai.png",
        [3]="images/BiSai/bisai_50yuansai.png",
        [4]="images/BiSai/bisai_100yuansai.png",
        [5]="images/BiSai/bisai_300yuansai.png",
        [6]="images/BiSai/bisai_500yuansai.png",
    }
	BiSaiWinSceneCtrller.super.ctor(self,pageName,moduleName,initParam);
end

function BiSaiWinSceneCtrller:run()
    print ("BiSaiWinSceneCtrller:run")
  
    self.logic:addLogicEvent("MSG_SOCK_pt_lc_match_result_notf",handler(self, self.pt_cl_match_result_notf),self)

    self.logic:addLogicEvent("MSG_Socket_pt_lc_send_user_data_change_not",handler(self, self.pt_lc_send_user_data_change_not),self)

    BiSaiWinSceneCtrller.super.run(self);
  
    self:resetData(gBaseLogic.lobbyLogic.matchResult)
    self.view:initBaseInfo();
end

function BiSaiWinSceneCtrller:resetData(data)
    if data ~= nil then 
        self.data.matchResult = data 
    end 
end

function BiSaiWinSceneCtrller:pt_lc_send_user_data_change_not()
    print("pt_lc_send_user_data_change_not")
    --self:resetData(message)
    --self.view:initBaseInfo(); 
end 

function BiSaiWinSceneCtrller:getHeadImage(ply_guids)
	var_dump(ply_guids)
    for k,guidinfo in pairs(ply_guids) do 
    	local guid = tostring64(guidinfo.ply_guid_)
        local url = string.gsub(URL.USERBATCH,"{uids}",guid)
        --url = "http://t.payment.hiigame.com/new/gateway/user/batch?uids=1101133836943856"
        echoInfo("get user head image: "..url);

        gBaseLogic:HTTPGetdata(url, 0, function(event)
            if event~=nil then 
                self:onGetHeadImage(guidinfo.rank_index_,event)
            end
            end)
    end
end 
--{"list":[{"account":"goon003","address":"","age":0,"code":"","desc":"","face":"http://img.cache.izhangxin.com/faces/default.png","isforbid":0,"nickname":"goon003","phone":"","plat":11,"realname":"","sex":0,"status":0,"uid":"1101133836943856"}]}
function BiSaiWinSceneCtrller:onGetHeadImage(idx,event)
    print("BiSaiWinSceneCtrller:onGetHeadImage")
    print(idx);
    var_dump(event,5);
    if event.list ~= nil and event.list[1] ~= nil then 
        self.view:updataHeadImage(idx,event.list[1].face,event.list[1].nickname) 
    end
end 

-- NET_PACKET(MatchPlayerRank)
-- {
--     int rank_index_;//排名 1～
--     guid ply_guid_
-- };
--     int match_id_;
--     string match_name_;
--     int rank_index_;
--     vector<MatchPlayerRank> ply_vec_;

function BiSaiWinSceneCtrller:pt_lc_match_result_notf(event)
    print("pt_lc_match_result_notf")
    local message = event.message;
    --for test reward
    -- local message = {
    --     match_id_ =1, match_name_ ="500现金争霸赛",rank_index_=4,
    --     ply_vec_={
    --         {rank_index_=1,nick_name_="JL",url_="http://iface.b0.upaiyun.com/751a150c-c4ee-4448-bbf9-5467974801e2.png!p300"},
    --         {rank_index_=2,nick_name_="JL2",url_="http://iface.b0.upaiyun.com/751a150c-c4ee-4448-bbf9-5467974801e2.png!p300"},
    --         {rank_index_=3,nick_name_="gaojian",url_="http://iface.b0.upaiyun.com/a545cbea-12f0-48d8-a5cb-ad6ff74d1515.png!p300"},
    --         {rank_index_=4,nick_name_="xiaxia",url_="http://iface.b0.upaiyun.com/1401262125-1805436962.png!p300"},
    --     }
    -- }

    self:resetData(message)
    self.view:initBaseInfo(); 

end

function BiSaiWinSceneCtrller:reqRaceRoomInfoData()
    print("BiSaiWinSceneCtrller:reqRaceRoomInfoData")

    local tableRst = {gameid=MAIN_GAME_ID,guid = gBaseLogic.lobbyLogic.userData.ply_guid_};
    gBaseLogic:blockUI();
    HTTPPostRequest(URL.MATCHINFODATA, tableRst, function(event)
        gBaseLogic:unblockUI();
        var_dump(tableRst)
        if (event ~= nil) then
            var_dump(event,5)

            gBaseLogic.lobbyLogic.matchInfo = event
            self.view:initBaseInfo(); 
        end     
        end);
end

return BiSaiWinSceneCtrller;
