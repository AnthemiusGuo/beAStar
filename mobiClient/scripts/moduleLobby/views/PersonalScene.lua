local PersonalScene = class("PersonalScene",izx.baseView)

function PersonalScene:ctor(pageName,moduleName,initParam)
	print ("PersonalScene:ctor")
    self.super.ctor(self,pageName,moduleName,initParam);
end


function PersonalScene:onAssignVars()
	--var_dump(self);
	self.rootNode = tolua.cast(self.rootNode,"CCNode");

	if nil ~= self["informationLayer"] then
        self.informationLayer = tolua.cast(self["informationLayer"],"CCLayer")
    end
    if nil ~= self["mailLayer"] then
        self.mailLayer = tolua.cast(self["mailLayer"],"CCLayer")
    end
    if nil ~= self["proertyLayer"] then
        self.proertyLayer = tolua.cast(self["proertyLayer"],"CCLayer")
    end
    if nil ~= self["personalSlider"] then
        self.personalSlider = tolua.cast(self["personalSlider"],"CCSprite")
    end
    if nil ~= self["informationItem"] then
        self.informationItem = tolua.cast(self["informationItem"],"CCControl")
    end
    if nil ~= self["proertyItem"] then
        self.proertyItem = tolua.cast(self["proertyItem"],"CCControl")
    end
    if nil ~= self["mailItem"] then
        self.mailItem = tolua.cast(self["mailItem"],"CCControl")
    end
    if nil ~= self["txt_person_money"] then
        self.txt_person_money = tolua.cast(self["txt_person_money"],"CCLabelTTF")
    end

    if nil ~= self["txt_person_gift"] then
        self.txt_person_gift = tolua.cast(self["txt_person_gift"],"CCLabelTTF")
    end
    if nil ~= self["txt_person_win"] then
        self.txt_person_win = tolua.cast(self["txt_person_win"],"CCLabelTTF")
    end
    if nil ~= self["txt_person_name"] then
        self.txt_person_name = tolua.cast(self["txt_person_name"],"CCLabelTTF")
    end
    if nil ~= self["txt_person_id"] then
        self.txt_person_id = tolua.cast(self["txt_person_id"],"CCLabelTTF")
    end

    if nil ~= self["table_update_headimage"] then
        self.table_update_headimage = tolua.cast(self["table_update_headimage"],"CCLabelTTF")
    end
    if nil ~= self["table_change_headimage"] then
        self.table_change_headimage = tolua.cast(self["table_change_headimage"],"CCLabelTTF")
    end
    if nil ~= self["btn_person_name"] then
        self.btn_person_name = tolua.cast(self["btn_person_name"],"CCControl")
    end
    if nil ~= self["btn_change_name"] then
        self.btn_change_name = tolua.cast(self["btn_change_name"],"CCControl")
    end
    if nil ~= self["edit_person_name"] then 
        self.edit_person_name = tolua.cast(self["edit_person_name"],"CCNode")
    end
    if nil ~= self["head_icon"] then
        self.head_icon = tolua.cast(self["head_icon"],"CCSprite")
    end
    -- if nil ~= self["mail_noconet"] then
    --     self.mail_noconet = tolua.cast(self["mail_noconet"],"CCLabelTTF")
    -- end
    if nil ~= self["txt_person_level"] then
        self.txt_person_level = tolua.cast(self["txt_person_level"],"CCLabelTTF")
    end
    
    if (gBaseLogic.MBPluginManager.distributions.novip) then
        self.lableVipTab:setVisible(false);
        self.NovipNode:setVisible(false);
    end
    if (not gBaseLogic.MBPluginManager.distributions['switchuser']) then
        -- hide switch
        self.btnChangeUser:setVisible(false);
    end
    if gBaseLogic.MBPluginManager.distributions.usercenter then
        local px,py = self.btnChangeUser:getPosition();
        local text_str = "个人中心"
        if gBaseLogic.MBPluginManager.distributions.replace_gerenxinxi_text~=nil then
            local v = split(gBaseLogic.MBPluginManager.distributions.replace_gerenxinxi_text,"|")
            for k,info in pairs(v) do
                local v2 = split(info,":")
                if v2[1]==text_str then
                    text_str = v2[2];
                    break;
                end
            end

        end
        local thisuiButton = cc.ui.UIPushButton.new({
                    normal = "images/LieBiao/list_btn_da1.png",
                    pressed = "images/LieBiao/list_btn_da2.png",
                    disabled = "images/LieBiao/list_btn_da2.png",
                }, {scale9 = false})
                 :setButtonLabel(ui.newTTFLabel({
                    text = text_str,
                    size = 36
                }))
                :onButtonClicked(function(event)  
                        gBaseLogic.MBPluginManager:enterSocial()                
                end)
                :addTo(self.informationLayer);
        thisuiButton:setPosition(px-300,py);
        thisuiButton:setAnchorPoint(ccp(0.5,0.5));
    end
end

function PersonalScene:onPressCenter()
    print "onPressCenter"
    izx.baseAudio:playSound("audio_menu");
end

function PersonalScene:onPressAcount()
    print "onPressAcount"
    izx.baseAudio:playSound("audio_menu");
    -- gBaseLogic.lobbyLogic.personalScene = nil
    --gBaseLogic.lobbyLogic:closeSocket();
    
    if (gBaseLogic.MBPluginManager.distributions.logoutwhenswitch) then
        self.logic.needSessionLogout = 1;
        -- gBaseLogic.scheduler.performWithDelayGlobal(function()
        --     gBaseLogic.lobbyLogic:closeSocket();
        --     gBaseLogic.MBPluginManager:sessionLogout();
        -- end, 1.5);
        
    end
    gBaseLogic.lobbyLogic:reShowLoginScene(false)
    --gBaseLogic:prepareRelogin()
    --gBaseLogic:checkLogin();
    --gBaseLogic.lobbyLogic:requestHTTPPaymentItems(0);
end

function PersonalScene:onPressVip()
    print "onPressVip"
    izx.baseAudio:playSound("audio_menu");
    gBaseLogic.lobbyLogic:gotoVipShop();

end

function PersonalScene:onPressOpenVip()
    print "onPressOpenVip"
    izx.baseAudio:playSound("audio_menu");
    gBaseLogic.lobbyLogic:gotoVipShop();
end

function PersonalScene:onPressHeadImage()
    print "onPressHeadImage"
    izx.baseAudio:playSound("audio_menu");
    --if self.table_change_headimage:isVisible() == true then
        --self.table_change_headimage:setVisible(false)
        --self.table_update_headimage:setVisible(true)
        --gBaseLogic:blockUI();
        --self:updataHeadInfo()
        --gBaseLogic.MBPluginManager:initHeadFace()
    --end
    echoInfo("gBaseLogic.lobbyLogic:showTouXiangGengXin");
    gBaseLogic.lobbyLogic:showTouXiangGengXin()
end

function PersonalScene:onRemovePage()
    -- call Java method
    gBaseLogic:stopWaitingAni('mail');
    closeWebview();
end

function PersonalScene:onPressChangeName()
    if self.haschangename == true then 
        izxMessageBox("名字只能修改一次哦，您已经修改过了。","温馨提示");
    else 
        self:showNameEditBox()
    end
end

function PersonalScene:onPressName()
    print "onPressName"
    izx.baseAudio:playSound("audio_menu");

    print(self.txt_person_name:getString())
    self.ctrller.nikename = self.txt_person_name:getString()
    if (self.ctrller.nikename == "") then
        izxMessageBox("没有输入昵称","温馨提示")
    elseif self.ctrller.nikename == self.ply_lobby_data_.nickname_ then 
        izxMessageBox("输入昵称相同","温馨提示")
    else
        self.ctrller:setCharacterNameCommit()
    end

end


function PersonalScene:onPressBack()
    izx.baseAudio:playSound("audio_menu");
    self:onRemovePage();
    gBaseLogic.lobbyLogic:goBackToMain();
    --TableViewLayer = nil
end

function PersonalScene:onPressInformation()
    self:onRemovePage();
    print "onPressInformation"
    izx.baseAudio:playSound("audio_menu");
    if self.informationLayer:isVisible() == false then
        --self.personalSlider:setPositionX(self.informationItem:getPositionX())
        self:SliderMoveAction(self.personalSlider, self.informationItem:getPositionX(), nil, 0.2)
        self.informationLayer:setVisible(true)
        self.initlayer:setVisible(false)
        self.initlayer = self.informationLayer
        self:initPersonInfo()
    end
end

function PersonalScene:onPressProerty()
    self:onRemovePage();
    print "onPressProerty"
    izx.baseAudio:playSound("audio_menu");
     if self.proertyLayer:isVisible() == false then
       --self.personalSlider:setPositionX(self.proertyItem:getPositionX())
       self:SliderMoveAction(self.personalSlider, self.proertyItem:getPositionX(), nil, 0.2)
       self.initlayer:setVisible(false)
       self.proertyLayer:setVisible(true)
       
       self.initlayer = self.proertyLayer
       self:initProertyInfo()
       --self.super.blockUI2(display.getRunningScene())
    end
end

function PersonalScene:onPressMail()
    print "onPressMail"

    izx.baseAudio:playSound("audio_menu");
    --self.personalSlider:setPositionX(self.mailItem:getPositionX())
    self:SliderMoveAction(self.personalSlider, self.mailItem:getPositionX(), nil, 0.2)
    if (self.mailLayer:isVisible()==false) then
        self.initlayer:setVisible(false)
        self.mailLayer:setVisible(true)
        self.initlayer = self.mailLayer
        if nil == self.ctrller.mailMsg then
            self.logic:pt_cl_get_unread_msg_req_send()
        else
            self:initMailInfo();
        end
    end
    
                
end

-- typ=0 没网络，typ=1，socket断，typ=2, 被踢下线，msg=nil或空用默认的话，
function PersonalScene:showEquipmentTips(typ,cn,x,y)
    local popBoxTips = {};
   
    function popBoxTips:onAssignVars()
        self.lableuser = tolua.cast(self["lableuser"],"CCLabelTTF");
        self.lableget = tolua.cast(self["lableget"],"CCLabelTTF");
        self.lablename = tolua.cast(self["lablename"],"CCLabelTTF");       
        print(cn.index_)
        if nil ~= cn then 
            local data = gBaseLogic.sceneManager.currentPage.view.ctrller.data
            if not data[cn.index_] then 
                self.lableuser:setString("未知")
                self.lableget:setString("未知")  
                self.lablename:setString(cn.name_)          
            else
                self.lableuser:setString(data[cn.index_].user)
                self.lableget:setString(data[cn.index_].get)
                self.lablename:setString(cn.name_)
            end
        end
    end
    
    gBaseLogic.sceneManager.currentPage.view:showPopBoxCCB("interfaces/DaoJuXinXi.ccbi",popBoxTips,true,1)
    gBaseLogic.sceneManager.currentPage.view.nodePopBox:setPosition(x,y);

end

function PersonalScene:onInitView()
    print "PersonalScene:onInitView()"
	self:initBaseInfo();
end

function PersonalScene:initBaseInfo()
    print("PersonalScene:initBaseInfo")
    -- var_dump(self.logic.userData.ply_items_)
    self.initlayer = self.informationLayer;
    self.ply_lobby_data_ = self.logic.userData.ply_lobby_data_
    self.ply_vip_ = self.logic.userData.ply_vip_
    self.ply_items_ = {}
    var_dump(gBaseLogic.gameItems);
    if gBaseLogic.gameItems~=nil then
         for k,v in pairs(self.logic.userData.ply_items_) do
            if v.index_==80 then
                v.num_= self.logic.userData.ply_lobby_data_.gift_
            elseif v.index_==0 then
                v.num_= self.logic.userData.ply_lobby_data_.money_
            end

            if gBaseLogic.gameItems[v.index_]==1 and v.num_>0 then
                table.insert(self.ply_items_,v)
            end
        end
    else
        self.ply_items_ = self.logic.userData.ply_items_
    end
    

    self.haschangename = self.logic.haschangename

    if 3 == self.initParam.tabNum then 
        self.proertyLayer:setVisible(false)
        self.informationLayer:setVisible(false)
        self:onPressMail()
    elseif 2 == self.initParam.tabNum then  
        self.informationLayer:setVisible(false)
        self.mailLayer:setVisible(false)
        self:onPressProerty()
    else 
        self.proertyLayer:setVisible(false)
        self.mailLayer:setVisible(false)        
        self:initPersonInfo() 
    end
end

function PersonalScene:initPersonInfo()
    print("PersonalScene:initPersonInfo()")
    -- NET_PACKET(PlyLobbyData)
    -- {
    --     guid    ply_guid_;
    --     string  nickname_;
    --     int     sex_;               //0男 1女
    --     int     gift_;
    --     int64   money_;
    --     int     score_;             //比赛积分 暂时不用
    --     int     won_;               //赢次数
    --     int     lost_;              //输次数
    --     int     money_rank_;        //游戏币排名
    --     int     won_rank_;          //胜利次数排名
    --     int     param_1_;           //扩展属性1(胜率排行)
    --     int     param_2_;           //扩展属性2
    -- };

    local tFiles = gBaseLogic.lobbyLogic.face
    if io.exists(tFiles) == false then
        izx.resourceManager:imgFileDown(tFiles,true,function(fileName) 
            if self~=nil and self.head_icon~=nil then
                self.head_icon:setTexture(getCCTextureByName(fileName))
            end
    end);
    else 
         self.head_icon:setTexture(getCCTextureByName(tFiles))
    end
    self.table_update_headimage:setVisible(false)
    self.table_change_headimage:setVisible(true) 

    
    --self.haschangename = false
    -- if self.haschangename == true then
         self:hideNameEditBox() 
    -- else
    --    self:showNameEditBox()    
    -- end 
    --self:updataVipInfo()
    self:userChange()
    -- self.txt_person_level:setString("Lv "..self.ply_lobby_data_.param_2_)
    -- self.txt_person_id:setString(string.format("ID: %s",self.logic.userData.ply_guid_))
    -- self.txt_person_money:setString(self.ply_lobby_data_.money_)
    -- self.txt_person_gift:setString(self.ply_lobby_data_.gift_)
    -- self.txt_person_win:setString(string.format("%d 胜/%d 败",self.ply_lobby_data_.won_, self.ply_lobby_data_.lost_))
     
end 
function PersonalScene:userChange()
    self:updataVipInfo()
    self.txt_person_level:setString("Lv "..self.ply_lobby_data_.param_2_)
    self.txt_person_id:setString(string.format("ID: %s",self.logic.userData.ply_guid_))
    self.txt_person_money:setString(self.ply_lobby_data_.money_)
    self.txt_person_gift:setString(self.ply_lobby_data_.gift_)
    self.txt_person_win:setString(string.format("%d 胜/%d 败",self.ply_lobby_data_.won_, self.ply_lobby_data_.lost_))
end
function PersonalScene:hideNameEditBox() 
    print("hideNameEditBox")
    self.btn_person_name:setVisible(false)
    self.edit_person_name:setVisible(false)
    self.txt_person_name:setString(self.ply_lobby_data_.nickname_)
    self.txt_person_name:setVisible(true) 
    self.btn_change_name:setVisible(true)      
end

function PersonalScene:showNameEditBox() 
    print("showNameEditBox")
    local function editBoxTextEventHandle(strEventName,pSender)
        local edit = tolua.cast(pSender,"CCEditBox")
       
        self.txt_person_name:setString(edit:getText())
        self.txt_person_name:setVisible(false)
        
    end 
    self.txt_person_name:setString("")
    self.btn_person_name:setVisible(true)
    self.edit_person_name:setVisible(true)
    self.txt_person_name:setVisible(false)
    self.btn_change_name:setVisible(false)
    if nil == self.editbox_person_name then 
        local bgsprite = CCScale9Sprite:create("images/LieBiao/list_bg_shurujihuo.png")
        self.editbox_person_name = createEditBox(self.edit_person_name, bgsprite, editBoxTextEventHandle,{strHolder = "请输入您的昵称",maxLen=8})  
        --self.editbox_person_name:setEnabled(false);
    end     
    
end 

function PersonalScene:unWaitingAni(target,opt)
    echoInfo("THANKS TO unWaitingAni ME!!!");
    --target:removeChildByTag(100,true)
    opt:removeFromParentAndCleanup(true);
    --izxMessageBox("请求服务器失败","网络错误");
    self.table_update_headimage:setVisible(false)
    self.table_change_headimage:setVisible(true)
    self.table_change_headimage:setString("点此更新头像") 
    
end

function PersonalScene:updataHeadInfo(msg) 
    print("updataHeadInfo") --gBaseLogic.lobbyLogic.face
    var_dump(msg) 
    --gBaseLogic:unblockUI();
    self.table_update_headimage:setVisible(true)
    self.table_change_headimage:setVisible(false)
    gBaseLogic.sceneManager:waitingAni(self.head_icon,self.unWaitingAni,100, self)
    if msg.PlatformResultCode == 0 or msg.PlatformResultCode == 2 then
        local tFiles = msg.url 
        gBaseLogic.lobbyLogic.face = tFiles
        if io.exists(tFiles) == false then  
            
            
            izx.resourceManager:imgFileDown(tFiles,true,function(fileName)
                if self~=nil and self.head_icon~=nil then
                    self.head_icon:setTexture(getCCTextureByName(fileName)) 
                    self.table_update_headimage:setVisible(false)
                    self.table_change_headimage:setVisible(true)                
                    self.table_change_headimage:setString("更新头像成功")
                    self.head_icon:removeChildByTag(100,true)
                    gBaseLogic.scheduler.performWithDelayGlobal(function()
                        self.table_change_headimage:setString("点此更新头像")   
                    end, 1)
                end
                --izxMessageBox("头像更新成功", "成功！")
            end);
        else 
            self.head_icon:setTexture(getCCTextureByName(tFiles))
       
            self.table_update_headimage:setVisible(false)
            self.table_change_headimage:setVisible(true) 
            self.table_change_headimage:setString("更新头像成功")
            self.head_icon:removeChildByTag(100,true)
            gBaseLogic.scheduler.performWithDelayGlobal(function()
                    self.table_change_headimage:setString("点此更新头像")   
                end, 1)
            --izxMessageBox("头像更新成功", "成功！")
        end
    elseif msg.PlatformResultCode == 1 then 
        self.table_update_headimage:setVisible(false)
        self.table_change_headimage:setVisible(true)                
        self.table_change_headimage:setString("更新头像失败")
        self.head_icon:removeChildByTag(100,true)
        gBaseLogic.scheduler.performWithDelayGlobal(function()
            self.table_change_headimage:setString("点此更新头像")   
        end, 1)
    elseif msg.PlatformResultCode == 3 then      
        self.table_update_headimage:setVisible(false)
        self.table_change_headimage:setVisible(true)                
        self.table_change_headimage:setString("更新头像失败")
        self.head_icon:removeChildByTag(100,true)
        gBaseLogic.scheduler.performWithDelayGlobal(function()
            self.table_change_headimage:setString("点此更新头像")   
        end, 1)
    end

end  

function PersonalScene:updateNameChange(ret) 
    print("---------------------"..ret)
    if 0 ~= ret then 
        self.haschangename = true
        self.logic.haschangename = true
        --self:hideNameEditBox() 
    else
        self.haschangename = false
        self.logic.haschangename = false
        --self:showNameEditBox() 
        -- if nil ~= self.editbox_person_name then
        --     self.editbox_person_name:setEnabled(true);
        -- end
    end
end 

function PersonalScene:updateNickName(event)
    if event.ret == 0 then 
        self.logic.userData.ply_lobby_data_.nickname_ = self.ctrller.nikename;
        self:hideNameEditBox() 
        self.logic.haschangename = true
        self.haschangename = true
        izxMessageBox("修改昵称成功","成功")
    else 
        -- local editbox = self.view.edit_person_name:getChildByTag(2)
        -- editbox:setText(event.msg)
        izxMessageBox("修改昵称失败","失败")
    end 
end 

function PersonalScene:updataVipInfo()
    if (gBaseLogic.MBPluginManager.distributions.novip) then
        return;
    end
    -- NET_PACKET(VipData)
    -- {
    --     int     level_;                 // VIP等级
    --     int     nex_level_total_days_;  // 升至下级总共需要的天数      5,15,35...
    --     int     auto_upgrade_day_;      // 自动升级天数                   5,10,20...
    --     int     login_award_;           // VIP登录奖励
    --     int     friend_count_;          // 好友个数
    --     int     next_level_due_days_;   // 升至下一级还剩的天数           nex_level_total_days-existing_day
    --     int     remain_due_days_;       // 剩余到期天数                   DB: due_date
    --     int     status_;                // VIP当前状态                  0无效 1有效
    -- };
    local layer_no_open = tolua.cast(self.informationLayer:getChildByTag(1),"CCNode") --1:未开通VIP,2:VIP,3:VIP续费

    -- if self.ply_vip_.level_ >= 0 then
    --     viplevel = self.ply_vip_.level_
    -- end
    local vipLevel = self.logic.vipData.vipLevel
    print("PersonalScene:updataVipInfo"..vipLevel)
    if vipLevel == 0 then
        layer_no_open:setVisible(true)
    else 
        local vipIcon = nil 
        layer_no_open:setVisible(false)
         
         local  layer_vip_avail = tolua.cast(self.informationLayer:getChildByTag(2),"CCNode")
        vipIcon = tolua.cast(layer_vip_avail:getChildByTag(1),"CCSprite")
         layer_vip_avail:setVisible(true)
         self:showVipIcon(vipIcon, vipLevel,  1)
        -- if self.ply_vip_.status_ == 0 then
        --     local  layer_vip_unavail = tolua.cast(self.informationLayer:getChildByTag(3),"CCNode")
        --     vipIcon = tolua.cast(layer_vip_unavail:getChildByTag(1),"CCSprite")
        --     layer_vip_unavail:setVisible(true)

        --     --vipIcon:setTexture(getCCTextureByName("images/VIP/viplblx"..viplevel ..".png"))

        -- else
        --     local  layer_vip_avail = tolua.cast(self.informationLayer:getChildByTag(2),"CCNode")
        --     local  vop_data = tolua.cast(layer_vip_avail:getChildByTag(2),"CCLabelTTF")
            
        --     layer_vip_avail:setVisible(true)
        --     --vipIcon:setTexture(getCCTextureByName("images/VIP/viplbl"..viplevel..".png"))
        --     vop_data:setString("（"..self.ply_vip_.remain_due_days_.."天后过期）")
        -- end 
        -- self:showVipIcon(vipIcon, viplevel,  self.ply_vip_.status_)
    end
end

--local TableViewLayer = require "izxFW.BaseTableView";
-- local TableViewLayer = class("TableViewLayer",require "izxFW.BaseTableView")
-- TableViewLayer.__index = TableViewLayer

function PersonalScene.cellSizeForTable(table,idx)
    if table:getParent().type == 1 then
        local mailItem = table:getParent().data[idx+1]; 
        local winSize = CCDirector:sharedDirector():getWinSize()

        local length = string.len("内容："..mailItem.message_)
        length = math.floor(14*length/(winSize.width-80))

        return 113+26*length, 1136
    else 
        return 177,1136
    end 
end
function PersonalScene.numberOfCellsInTableView(table)
    -- var_dump(table.data);
    local data = table:getParent().data;
    if table:getParent().type==0 then 
        --print(math.ceil(#data/5))
        return math.ceil(#data/5)
        --return #data
    else
        return #data
    end 
end
function PersonalScene.tableCellAtIndex(table, idx)
    print(idx.."-tableCellAtIndex-")
    local cell = table:dequeueCell()
    if nil == cell then        
        cell = CCTableViewCell:new()
    else
        cell:removeAllChildrenWithCleanup(true);
    end 
    --table.width = 1136
    --table.heigth = 113
-- // 道具扩展属性
-- NET_PACKET(ItemData)
-- {
--     int index_;
--     int num_;
--     int game_id_;               //Game ID
--     int param_1_;               //扩展属性1
--     int param_2_;               //扩展属性2
--     string name_;               //道具名称
--     string url_;                //道具图片URL
-- };     

    if (table:getParent().type==0 ) then        
        --var_dump(table:getParent().data)
        local index_x = 150
        local parent = table:getParent()


        -- if  parent.idx >= #parent.data then 
        --     print("==============================")
        --     return cell
        -- end
        local hasmovex = 0
        local hasmovey = 0
        local hasmove = 0
        local bgSprite = CCSprite:create("images/LieBiao/list_bg_daoju.png")
        bgSprite:setAnchorPoint(ccp(0,0))
        bgSprite:setPosition(ccp(28, 0))
        cell:addChild(bgSprite)
        parent.idx = idx*5 + 1
        local num = #parent.data - parent.idx +1
        if num > 5 then 
            num = 5 
        end


        for i=1, num do
            local itemInfo = parent.data[parent.idx]; 
            local proxy = CCBProxy:create();
            local newtable = {};
            newtable.onTouch_ = function(target, event, x, y) 
                if (event=="began") then
                    echoInfo(event..":Icon!");
                    hasmovex = x
                    hasmovey = y
                    return true;
                end
                if (event=="ended") then
                    echoInfo(event..":Icon!");
                    if hasmove > 30 then 
                        hasmove = 0 
                        return true;
                    end
                    local dir = 1
                    if x > display.cx+100 then 
                        dir = -1
                    end

                    local pt = target:convertToWorldSpace(ccp(0,0))
                    local data = table:getParent().data[target:getTag()]
                    --print(pt.x,pt.y)
                    if dir == 1 then  
                        gBaseLogic.sceneManager.currentPage.view:showEquipmentTips(0,data,pt.x+50,pt.y+160)
                    else 
                        gBaseLogic.sceneManager.currentPage.view:showEquipmentTips(0,data,pt.x-360,pt.y+160) 
                    end
                    return true;
                end
                hasmove = math.abs(y - hasmovey) + math.abs(x - hasmovex)

                echoInfo(event..":Icon!"); --moved
                return true;
            end
            local node = CCBuilderReaderLoad("interfaces/DaoJuLan.ccbi",proxy,newtable);
            newtable.labelNum = tolua.cast(newtable["labelNum"],"CCLabelTTF")
            newtable.daojuIcon= tolua.cast(newtable["daojuIcon"],"CCSprite")
            if itemInfo.index_ == 0 then 
                newtable.labelNum:setString(numberChange(gBaseLogic.lobbyLogic.userData.ply_lobby_data_.money_)) 
            elseif itemInfo.index_ == 80 then
                newtable.labelNum:setString(numberChange(gBaseLogic.lobbyLogic.userData.ply_lobby_data_.gift_.."个")) 
            elseif itemInfo.index_ == 5 then 
                newtable.labelNum:setString(itemInfo.num_.."天") 
            else 
                newtable.labelNum:setString(itemInfo.num_.."个") 
            end
            newtable.daojuIcon:setTouchEnabled(true);
            newtable.daojuIcon:addTouchEventListener(handler(node, newtable.onTouch_))
            node:setTag(parent.idx)
            --node:setTag(itemInfo.index_)
            node:setPosition(index_x,56)
            cell:addChild(node)
            
            --print(itemInfo.url_)
            izx.resourceManager:imgFileDown(itemInfo.url_,true,function(fileName) 
                    newtable.daojuIcon:setTexture(getCCTextureByName(fileName))
            end);
            -- local str = itemInfo.url_
            -- local n, filename = string_last_of(str, "/")

            -- local tFiles = gBaseLogic.DownloadPath .. filename;
            -- if io.exists(tFiles) == false then  
            --     gBaseLogic:img_file_down(tFiles,itemInfo.url_,function() 
            --         newtable.daojuIcon:setTexture(getCCTextureByName(tFiles))
            --         end)
            -- else 
            --     newtable.daojuIcon:setTexture(getCCTextureByName(tFiles))
            -- end

            index_x = index_x +210
            parent.idx = parent.idx + 1
        end

    elseif (table:getParent().type == 1 ) then
--     NET_PACKET(FriendMsg){
--     guid    rcv_ply_guid_;      
--     guid    snd_ply_guid_;              //1000为系统发送
--     string  snd_nickname_;              //WEB端发送时，0为发送给所有人，否则将指定用户ID填入
--     string  message_;
--     int     type_;                      //0普通消息 1加好友请求 2邀请游戏请求 3同意加好友 4拒绝加好友 5删好友通知 6系统消息
--     int     time_;
--    }; 
        local winSize = CCDirector:sharedDirector():getWinSize()  
        local sprite = CCSprite:create("images/LieBiao/list_bg_fenge.png")
        sprite:setPosition(ccp(winSize.width/2, 2))
        cell:addChild(sprite)  

        local mailItem = table:getParent().data[idx+1]; 
        mailItem.message_ = gBaseLogic.MBPluginManager:replaceText(mailItem.message_)

        local length = string.len("内容："..mailItem.message_)
        length = math.floor(14*length/(winSize.width-80))

        local label = CCLabelTTF:create("内容："..mailItem.message_, "Helvetica", 28.0,CCSizeMake(winSize.width-80, 32*length), ui.TEXT_ALIGN_LEFT, ui.TEXT_VALIGN_BOTTOM)
        label:setAnchorPoint(ccp(0,0))
        label:setPosition(ccp(40,20))

        cell:addChild(label)

        local labeltime = CCLabelTTF:create("时间："..os.date("%Y-%m-%d %H:%M:%S", mailItem.time_), "Helvetica", 28.0)
        labeltime:setAnchorPoint(ccp(0,0))

        labeltime:setPosition(ccp(40,60+20*length))
        --label:setColor(ccc3(218,119,119))
        cell:addChild(labeltime)
    end

    return cell
end 



function PersonalScene:initTableView(target,type,data)
    local winSize = resolutionFixedWidth(target,640)
    --TableViewLayer.initdata(target,winSize,type,data, self);
    --print(winSize.width,winSize.height)
    --print(target:getResolutionScale()) 
    if data==nil or #data==0 then
        target:removeAllChildrenWithCleanup(true);
        target.type = type;
        target.data = data;
        if data~=nil and #data==0 and type==1 then
            ShowNoContentTip(target,"暂无邮件")
        end
        return
    end
    createTabView(target,winSize,type,data, self);
end

function PersonalScene:initProertyInfo()
    print("PersonalScene:initProertyInfo()")
    --self.proertyLayer = TableViewLayer.extend(tolua.cast(self["proertyLayer"],"CCLayer"))
    --TableViewLayer.create(self.proertyLayer,tolua.cast(self["proertyLayer"],"CCLayer"))
    var_dump(self.ply_items_)
    if gBaseLogic.lobbyLogic.vipData.vipLevel>=9 then
        for k,v in pairs(self.ply_items_) do
            if v.index_== 2 then
                self.ply_items_[k].num_="∞";
            end
        end
    end
    self:initTableView(self.proertyLayer, 0,self.ply_items_);
end

function PersonalScene:initMailInfo()
    print("PersonalScene:initMailInfo()")
    --self.ctrller.mailMsg = nil
    -- if nil == self.ctrller.mailMsg then 
    --     self.mail_noconet:setVisible(true)
    -- else 
    --     --self.mailLayer = TableViewLayer.extend(tolua.cast(self["mailLayer"],"CCLayer"))
    --     --TableViewLayer.create(self.mailLayer,tolua.cast(self["mailLayer"],"CCLayer"))
    --     self.mail_noconet:setVisible(false)
    --     self:initTableView(self.mailLayer, 1,self.ctrller.mailMsg);
    -- end
    local winSize = resolutionFixedWidth(self.mailLayer,640);

    gBaseLogic:waitingAni(self.mailLayer,"mail");

    local lt = CCPointMake(0,  display.heightInPixels-(winSize.height+30)*display.heightInPixels/display.height);
    local rb = CCPointMake(display.widthInPixels, display.heightInPixels-20*display.heightInPixels/display.height);


    local canCommit = true;
    if self.logic.userHasLogined == false then
        canCommit = false
    end
    local paramObj = {};
    for k,v in pairs(self.ctrller.mailMsg) do
        table.insert(paramObj,{reply=v.message_,rptimeStr=v.time_})
    end
    local url = "interfaces/webRes/mail.html";
    openWebview(lt,rb,url,true,paramObj,handler(self, self.onWebViewCallback));
end

function PersonalScene:onWebViewCallback(event)
    echoInfo("JAVA CALLED LUA!!! param is %s ", event);

    if (event=="CLOSE") then
        self:onPressBack();
    end  

end

function PersonalScene:onEnter()
    -- body
    print "PersonalScene:onEnter()11"

end

return PersonalScene;
