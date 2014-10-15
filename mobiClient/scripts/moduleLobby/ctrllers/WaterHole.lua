local WaterHoleCtrller = class("WaterHoleCtrller", izx.baseCtrller)
  
  function WaterHoleCtrller:ctor(pageName,moduleName,initParam)
    print("WaterHoleCtrller:ctor");
    self.super.ctor(self,pageName,moduleName,initParam);
    
    self.data = {
      message_list = {},
      cur_game_id_ = -1,
    };
    
    var_dump(initParam);
    
    if nil ~= initParam.cur_game_id_ then
      self.data.cur_game_id_ = initParam.cur_game_id_;
    end
    
    print("===========ctor game_id_ "..self.data.cur_game_id_);
        
  end
  
  function WaterHoleCtrller:onEnter()
    print("WaterHoleCtrller:onEnter");
  end
  
  function WaterHoleCtrller:run()
    print("WaterHoleCtrller:run");
    
    self.logic:addLogicEvent("MSG_SOCK_pt_lc_spec_trumpet_ack", handler(self, self.pt_lc_spec_trumpet_ack), self);
    self.logic:addLogicEvent("MSG_SOCK_pt_lc_spec_trumpet_not", handler(self, self.onGetMessage), self);
    
    --[[
    table.insert(self.data.message_list, {ply_guid = 11, message = "阿道法法地方阿嫂打法速度发动司法送打发打发大", ply_face = "http://img2.91huo.cn/myreg91/center/face/middle_nosex.jpg"});
    table.insert(self.data.message_list, {ply_guid = 12, message = "阿道法法地方阿嫂打法速度发动司法送打发打发大", ply_face = "http://img2.91huo.cn/myreg91/center/face/middle_nosex.jpg"});
    table.insert(self.data.message_list, {ply_guid = gBaseLogic.lobbyLogic.userData.ply_guid_, message = "阿道法法地方阿嫂打法速度发动司法送打发打发大阿道法苏大发隧道发送打法速度发送打发打发阿道法法地方阿嫂打法速度发动司法送打发打发大阿道法苏大发隧道发送打法速度发送打发打发", ply_face = "http://img2.91huo.cn/myreg91/center/face/middle_nosex.jpg"});
    table.insert(self.data.message_list, {ply_guid = 13, message = "阿道法法地方阿嫂打法速度发动司法送打发打发大阿道法苏大发隧道发送打法速度发送打发打发", ply_face = "http://img2.91huo.cn/myreg91/center/face/middle_nosex.jpg"});
    --]]        
  end
  
  function WaterHoleCtrller:pt_lc_spec_trumpet_ack(event)
    if nil == event or nil == event.message then
      return;
    end
       
    --local message = event.message;
    var_dump(event.message);
    -- 0成功 -1未知错误 -2你说话太快，歇一会在说 -3禁止聊天 -4您的可用资产不足*W，不能聊天！
   
    if 0 == event.message.ret_ or -1 == event.message.ret_ then
      return;
    else
      --self.view:ShowGameTip(message.msg_);
      local message = {};
      message.ply_guid_ = 1000;
      message.message_ = event.message.msg_;
      print("=============WaterHoleCtrller:pt_lc_spec_trumpet_ack==============");
      var_dump(self.data.message_list);
      table.insert(self.data.message_list, message);
      var_dump(self.data.message_list);
      self.view:initTableView(self.data.message_list);
    end
    
    print("=======pt_lc_spec_trumpet_ack.ret_ = "..event.message.ret_);
  end
    
  function WaterHoleCtrller:onGetMessage(event)
    print("=======WaterHoleCtrller:onGetMessage=============");
    if nil == event or nil == event.message then
      return;
    end  
 
    var_dump(event.message);
    event.message.ply_guid_ = tostring64(event.message.ply_guid_);
    if event.message.ply_guid_ ~= gBaseLogic.lobbyLogic.userData.ply_guid_ then
      table.insert(self.data.message_list, event.message);
      
      if self.view.panel_node:isVisible() then
        self.view:initTableView(self.data.message_list);
        -- self.view:refurbishMessageTip(event.message);
      end
        
      if self.data.cur_game_id_ == event.message.game_id_ then
        self.view:refurbishMessageTip(event.message);
      end
    end
  
  end
  
  function WaterHoleCtrller:sendMessage(str)
  
    print("===========sendMessage game_id_ "..self.data.cur_game_id_);
  
    local socketMsg = {opcode = 'pt_cl_spec_trumpet_req',
                      game_id_ = self.data.cur_game_id_,
                      message_ = str,
                      image_ = gBaseLogic.lobbyLogic.face,
              };
    var_dump(socketMsg);
    gBaseLogic.lobbyLogic:sendLobbySocket(socketMsg);
    
    local message = {};
    message.opcode = "pt_lc_spec_trumpet_not";
    message.game_id_ = self.data.cur_game_id_;
    message.ply_guid_ = gBaseLogic.lobbyLogic.userData.ply_guid_;
    message.ply_nickname_ = gBaseLogic.lobbyLogic.userData.ply_nickname_;
    message.message_ = str;
    message.image_ = gBaseLogic.lobbyLogic.face;
    
    table.insert(self.data.message_list, message);
    
    self.view:initTableView(self.data.message_list);
    
    self.view:refurbishMessageTip(message);
    
  end
    
return WaterHoleCtrller;