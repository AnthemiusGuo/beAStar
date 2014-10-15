local WaterHole = class("WaterHole", izx.baseView)

  function WaterHole:ctor(pageName,moduleName,initParam)
    print("WaterHole:ctor");
    self.super.ctor(self,pageName,moduleName,initParam);
    self.position = nil;
    
    if (nil ~= initParam.cur_point_) then 
      self.position = initParam.cur_point_;
      print("==============self.position is not nil====================")
    end
        
  end     
  
  function WaterHole:onAssignVars()
    print("WaterHole:onAssignVars");
    
    self.rootNode = tolua.cast(self.rootNode,"CCNode");
    
    self.activation_node = tolua.cast(self["activation_node"], "CCNode");

    self.panel_node = tolua.cast(self["panel_node"], "CCNode");
    if nil ~= self.panel_node then
      self.panel_node:setVisible(false);
    end
    
    self.message_node = tolua.cast(self["message_node"], "CCNode");
    self.sprite_message = tolua.cast(self["sprite_message"], "CCScale9Sprite");
    self.txt_message = tolua.cast(self["txt_message"], "CCLabelTTF");
    self.sprite_frame = tolua.cast(self["sprite_frame"], "CCSprite");
    self.chat_area = tolua.cast(self["chat_area"], "CCNode");
    self.sprite_input = tolua.cast(self["sprite_input"], "CCSprite");
      
    --self.message_node:setPosition(ccp(-600, -500));
  end
  
  function WaterHole:onInitView()
    print("WaterHole:onInitView");  
    
    if self.position ~= nil then
      self.activation_node:setPosition(ccp(self.position));
    end
    
    local winSize = CCDirector:sharedDirector():getWinSize();
    local factor = CCDirector:sharedDirector():getContentScaleFactor();
       
    local function editBoxTextEventHandle(strEventName,pSender)
      local edit = tolua.cast(pSender,"CCEditBox")
      local strFmt
      if strEventName == "began" then
        strFmt = string.format("editBox %p DidBegin !", edit)
        print(strFmt)
        edit:setText(self.sendMsg);
      elseif strEventName == "ended" then
        strFmt = string.format("editBox %p DidEnd !", edit)
        print(strFmt)
        self.sendMsg = edit:getText();
        local len = string.len(self.sendMsg);
        if len > 25 then
          edit:setText(self:SplitString(self.sendMsg, 20).."...");
        end
      elseif strEventName == "return" then
        strFmt = string.format("editBox %p was returned !",edit)
        print(strFmt)
      elseif strEventName == "changed" then
        strFmt = string.format("editBox %p TextChanged, text: %s ", edit, edit:getText())
        print(strFmt)
      end
    end
    
    local editSprite = CCScale9Sprite:create("images/WaterHole/LiaoTianShuRuKuang.png");
    
    self.msg_edit = CCEditBox:create(self.sprite_input:getContentSize(), editSprite);
    self.msg_edit:setFont("Helvetica",24/factor);
    self.msg_edit:setPlaceholderFontColor(ccc3(124,124,124));
    self.msg_edit:setFontColor(ccc3(0,0,0));
    self.msg_edit:setPlaceHolder("请输入...");
    self.msg_edit:setReturnType(kKeyboardReturnTypeDone);
    self.msg_edit:registerScriptEditBoxHandler(editBoxTextEventHandle);
    self.msg_edit:setAnchorPoint(ccp(0, 0));
    self.msg_edit:setPosition(ccp(self.sprite_input:getPosition()));
    self.sprite_input:getParent():addChild(self.msg_edit);
    
    self.sprite_input:setVisible(false);

    local point = ccp(self.sprite_frame:getPosition());
    
    local size = self.sprite_frame:getContentSize();
    local parentPoint = ccp(self.activation_node:getPosition());
    point.x = point.x + parentPoint.x ;
    point.y = point.y + parentPoint.y;
     
    local rect = CCRectMake(point.x, point.y, size.width, size.height);

    local clickMask = function(event, x, y, prevX, prevY)
                      if (event=="began") then
                        if not rect:containsPoint(ccp(x,y)) then
                          self.panel_node:setVisible(false);
                          self.masklayer:setVisible(false);
                          self.sprite_message:setVisible(true);
                          self.txt_message:setVisible(true);
                        end
                        return true;
                      end
                      
                      if (event=="ended") then
                       
                      end
                      
                      echoInfo(event..":MASK!");
                      return true;
                    end
                    
    self.masklayer = display.newScale9Sprite("images/bg.png", display.cx,display.cy, CCSizeMake(display.width, display.height));
    self.masklayer:setTouchEnabled(true);
    self.masklayer:addTouchEventListener(clickMask);
    self.activation_node:getParent():addChild(self.masklayer);
    self.masklayer:setVisible(false);
    
    self.activation_node:getParent():reorderChild(self.activation_node, self.masklayer:getZOrder() + 1);
    self:addScrollBar();
  end
  
  function WaterHole:onPressIcon()
    self.panel_node:setVisible(not self.panel_node:isVisible());
    self.masklayer:setVisible(self.panel_node:isVisible());
    
    self.sprite_message:setVisible(not self.panel_node:isVisible());
    self.txt_message:setVisible(not self.panel_node:isVisible());
    
    if self.panel_node:isVisible() then
      self:initTableView(self.ctrller.data.message_list);
    end
  end
  
  function WaterHole:ShowGameTip(str)
  
      local scene = display.getRunningScene();
      local spriteback = CCSprite:create("images/DaTing/lobby_bg_gonggao.png")
      spriteback:setPosition(display.cx,display.cy)
      scene:addChild(spriteback);
      local text = CCLabelTTF:create(str,"Helvetica",24);
      local textbacksize = spriteback:getContentSize()
      text:setPosition(ccp(textbacksize.width/2,textbacksize.height/2));
      spriteback:addChild(text);
  
      local fade_seq = transition.sequence({CCFadeIn:create(0.25),
      CCDelayTime:create(1.0),
      CCFadeOut:create(0.25),
      CCHide:create(),
      CCCallFuncN:create(function(obj)
        obj:removeFromParentAndCleanup(true)
      end)});
      spriteback:runAction(fade_seq);
    
  end
  
  function WaterHole:onTimeOut()
  
    self.myscheduler.unscheduleGlobal(self.mySchedulerHandle);
    self.sendInterval = false;
  
  end
  
  function WaterHole:onPressSend()
  --[[
    if self.logic.userData.ply_lobby_data_.money_ < 100000 then
      self:ShowGameTip("您的可用资产不足10W，不能聊天！");
      return;
    end
  --]]
  
  
    if nil ~= self.sendInterval and true == self.sendInterval then
      self:ShowGameTip("你说话太快，歇一会在说");
      return;
    end
    
    if nil == self.myscheduler then
      self.myscheduler = require("framework.scheduler");
    end
   
    local str = self.sendMsg;    
    if self:CalcCharCount(str) > 0 then
      self.sendMsg = "";
      self.msg_edit:setText("");
      self.ctrller:sendMessage(str);
      
       
      self.mySchedulerHandle = self.myscheduler.scheduleGlobal(handler(self, self.onTimeOut), 5);
      self.sendInterval = true;
    end  
    
  end
  
  function WaterHole.createText(var, message, width)
    print("=======createText==========");
    local str = message.ply_nickname_..":"..message.message_;
    message.txt_message = CCLabelTTF:create(str, "Helvetica", 26);
    local size = message.txt_message:getContentSize();
    if size.width > width then
      message.txt_message = CCLabelTTF:create(str, "Helvetica", 26, CCSizeMake(width, 0), ui.TEXT_ALIGN_LEFT, ui.TEXT_VALIGN_TOP);
      --size = message.txt_message:getContentSize();
    end
    
    message.txt_message:setColor(ccc3(58,16,13));
  end
  
  function WaterHole.cellSizeForTable(table,idx)

    local width = table:getParent():getContentSize().width - 52 - 30 - 20;
    local message = table:getParent().data[idx+1]; 
    var_dump(message);
    if message.ply_guid_ == 1000 then
      local str = message.message_;
      message.txt_message = CCLabelTTF:create(str, "Helvetica", 18);
    else
      WaterHole:createText(message, width);
    end
    
    local size = message.txt_message:getContentSize();
    print("=============size w = "..size.width.." h = "..size.height);
    return size.height + 25, size.width;
  end
  
  function WaterHole.numberOfCellsInTableView(table)
    local data = table:getParent().data;
    return #data;
  end
   
  function WaterHole.tableCellAtIndex(table, idx)
    print(idx.."-tableCellAtIndex-")
    local cell = table:dequeueCell()
    if nil == cell then        
        cell = CCTableViewCell:new()
    else
        cell:removeAllChildrenWithCleanup(true);
    end 
    
    local message = table:getParent().data[idx+1];
    local proxy = CCBProxy:create();
    local newtable = {};
    
    var_dump(message);
    local node = CCNode:create();
    if message.ply_guid_ == 1000 then
  -- 填充系统
      local winSize = table:getParent():getContentSize();
          
      local sprite_pop = CCScale9Sprite:create("images/WaterHole/LiaoTianPaoPao_1.png");
      sprite_pop:setAnchorPoint(ccp(0.5,0));
      sprite_pop:setPosition(ccp(winSize.width / 2, 5))
      sprite_pop:setColor(ccc3(77, 77, 77));
      sprite_pop:setOpacity(150);
      
      local str = message.message_;
      message.txt_message = CCLabelTTF:create(str, "Helvetica", 18);
      message.txt_message:setColor(ccc3(0, 0, 0));
      
      
      local size = message.txt_message:getContentSize();
      sprite_pop:setContentSize(CCSizeMake(size.width + 25, size.height + 20));
      message.txt_message:setAnchorPoint(ccp(0, 1));
      size = sprite_pop:getContentSize();
      message.txt_message:setPosition(ccp(10, size.height - 10));
      
      sprite_pop:addChild(message.txt_message)
      sprite_pop:setScale(0.75);
      
      
      node:addChild(sprite_pop)
    
    else
    
  -- 填充聊天
      local winSize = table:getParent():getContentSize();
      
      local sprite_icon = CCSprite:create("images/TanChu/popup_bg_shangpin.png");
      sprite_icon:setAnchorPoint(ccp(0,0));
      
      local tFiles = message.image_;
      if io.exists(tFiles) == false then
          izx.resourceManager:imgFileDown(tFiles,true,
            function(fileName) 
              if sprite_icon ~= nil then
                  sprite_icon:setTexture(getCCTextureByName(fileName))
              end
            end);
      else
        sprite_icon:setTexture(getCCTextureByName(tFiles))
      end 
      
      local sprite_pop = nil;
      local sprite_arrow = nil;
      
      if true then --nil  == message.txt_message then
        local width = table:getParent():getContentSize().width - 52 - 30 - 20;
        --local message = table:getParent().data[idx+1]; 
        WaterHole:createText(message, width);
      end
      
      var_dump(message.txt_message);
       
      local size = message.txt_message:getContentSize();
      
      if message.ply_guid_ == gBaseLogic.lobbyLogic.userData.ply_guid_ then
        sprite_arrow = CCSprite:create("images/WaterHole/LiaoTianPaoPao_4.png");
        sprite_pop = CCScale9Sprite:create("images/WaterHole/LiaoTianPaoPao_3.png");
        sprite_arrow:setScaleX(-1);
      else
        sprite_arrow = CCSprite:create("images/WaterHole/LiaoTianPaoPao_2.png");
        sprite_pop = CCScale9Sprite:create("images/WaterHole/LiaoTianPaoPao_1.png");
      end
      
      sprite_arrow:setAnchorPoint(ccp(0, 0));
      sprite_pop:setAnchorPoint(ccp(0, 0));
      
      sprite_pop:setContentSize(CCSizeMake(size.width + 20, size.height + 20));
      
      node:setContentSize(CCSizeMake(winSize.width - 10, size.height + 20 + 10)); 
      
      if message.ply_guid_ == gBaseLogic.lobbyLogic.userData.ply_guid_ then
        sprite_icon:setPosition(ccp(winSize.width - 10 - sprite_icon:getContentSize().width, size.height + 20 - sprite_icon:getContentSize().height));
        sprite_arrow:setPosition(ccp(winSize.width - 10 - sprite_icon:getContentSize().width - 5, size.height + 20 - sprite_icon:getContentSize().height / 2))
        sprite_pop:setPosition(ccp(winSize.width - 10 - sprite_icon:getContentSize().width - sprite_pop:getContentSize().width - 15, 0));
        --txt_message:setPosition(ccp(winSize.width - 10 - sprite_icon:getContentSize().width - sprite_pop:getContentSize().width - 10, 0));
      else
        sprite_icon:setPosition(ccp(10, size.height + 20 - sprite_icon:getContentSize().height));
        sprite_arrow:setPosition(ccp(10 + sprite_icon:getContentSize().width + 5, size.height + 20 - sprite_icon:getContentSize().height / 2))
        sprite_pop:setPosition(ccp(10 + sprite_icon:getContentSize().width + 15, 0));
        --txt_message:setPosition(ccp(10 + sprite_icon:getContentSize().width + 20, 0));
      end
      
      node:addChild(sprite_icon);
      node:addChild(sprite_arrow);
      node:addChild(sprite_pop);
  
      message.txt_message:setAnchorPoint(ccp(0, 1));
      message.txt_message:setPosition(ccp(10, sprite_pop:getContentSize().height - 10));
      sprite_pop:addChild(message.txt_message);
    end
    
   
    cell:addChild(node)
    return cell
  end
  
  function WaterHole:initTableView(data)
    print("=========waterHole:initTableView===============");
    
    createTabView(self.chat_area, self.chat_area:getContentSize(), 0, data, self);
    self.tableView = tolua.cast(self.chat_area:getChildren():objectAtIndex(0), "CCTableView");
    self.tableView:setContentOffset(ccp(0, 0));
    
    local scrollViewDidScroll = function(view)
      --print("====view.getContentOffset x = "..(ccp(view:getContentOffset()).y / (self.tableView:getContentSize().height - self.tableView:getViewSize().height)));
      
      self:setScrollBar(ccp(view:getContentOffset()).y / (self.tableView:getContentSize().height - self.tableView:getViewSize().height));
    end
    
    --print("=========self.tableView:getContentSize().height = ".. self.tableView:getContentSize().height);
    
    self.tableView:registerScriptHandler(scrollViewDidScroll, CCTableView.kTableViewScroll)
    
    self.scrollbar:setVisible(self.tableView:getViewSize().height < self.tableView:getContentSize().height);
    
    
    if device.platform ~= "windows" then
      self.tableView:setAlignCellNum(0)
    end
    
    --self.scrollbar:setVisible(false);
  end
  
  function WaterHole:addScrollBar()
    local scrollbarTouch = function(event, x, y, prevX, prevY)
      if (event=="began") then
        print("========scrollBar began==============")
        self.curY = y;
        return true;
      end
      
      if (event=="moved") then
        if self.curY ~= nil then
          local point = ccp(self.scrollbar:getPosition());
          point.y = point.y + (y - self.curY);
          self.curY = y;
          if point.y < self.scrollbarMax and point.y > self.scrollbarMin then
            self.scrollbar:setPosition(point);
          end
          
          if self.tableView then        
--            print("==============scrollBar " ..(point.y - self.scrollbarMin) .." max "..(self.scrollbarMax - self.scrollbarMin).. 
--                                                "  "..(self.tableView:getContentSize().height - self.tableView:getViewSize().height) )
            local y = (point.y - self.scrollbarMin) / (self.scrollbarMax - self.scrollbarMin) * (self.tableView:getContentSize().height - self.tableView:getViewSize().height);
            self.tableView:setContentOffset(ccp(0, -y));
          end
        end
      end
                        
      if (event=="ended") then
        print("========scrollBar ended==============")
        self.curY = nil;
        return true;
      end
                        
      echoInfo(event..":scrollBar!  y "..y);
      return true;
    end
  
    if nil == self.scrollbar then
      self.scrollbar = CCSprite:create("images/WaterHole/LiaoTianHuaKuai.png");
      self.scrollbar:setTouchEnabled(true);
      self.scrollbar:addTouchEventListener(scrollbarTouch);
      
      local winSize = self.chat_area:getParent():getContentSize();
      local barSize = self.scrollbar:getContentSize();
      self.scrollbarMin = barSize.height / 2 + 2;
      self.scrollbarMax = winSize.height - barSize.height / 2 - 2;
      self.scrollbarRight = winSize.width - barSize.width / 2 - 1;
      
      self:setScrollBar(0);
      self.chat_area:getParent():addChild(self.scrollbar);
    end
  end
  
  function WaterHole:setScrollBar(offset)
    if offset > 0 then
      offset = 0;
    elseif offset < -1 then
      offset = -1;
    end
    
    offset = 0 - offset;
    local point = ccp(self.scrollbarRight, (self.scrollbarMax - self.scrollbarMin) * offset + self.scrollbarMin);
    print("=============point x = "..point.x.." y = "..point.y);
    self.scrollbar:setPosition(point);
  end
    
  function WaterHole:refurbishMessageTip(message)
    
    local str = message.ply_nickname_;
    local len = string.len(str);
    if len > 10 then
      str = self:SplitString(str, 7).."...";
      len = self:CalcCharCount(str);
    end
    
    --print("================================message tip str = "..str);
    str = str..":"
    --print("================================message tip str = "..str);
    str = str..message.message_;
    len = string.len(str);
    if len > 25 then
      str = self:SplitString(str, 20).."...";
    end
    --print("================================message tip str = "..str);
    self.txt_message:setString(str);
    
    local fade_in = CCFadeIn:create(0.25);
    local fade_out = CCFadeOut:create(0.25);
    local fade_in_action = transition.sequence({fade_in, CCDelayTime:create(2), fade_out})
    self.message_node:runAction(fade_in_action);
  end
  
  function WaterHole:CalcCharCount(str)
    local len = #str;
    local left = len;
    local cnt = 0;
    local arr={0,0xc0,0xe0,0xf0,0xf8,0xfc};
    while left ~= 0 do
      local tmp=string.byte(str,-left);
      local i=#arr;
      while arr[i] do
      if tmp>=arr[i] then left=left-i;break;end
        i=i-1;
      end
      cnt=cnt+1;
    end
    return cnt
  end
  
  function WaterHole:SplitString(str,length)
    if not str or not length then
      return "",""
    end
    local code=0
    local pos = 1
    local len = 0;
    while len < length do
      code = string.byte(str,pos)
      if not code then
        break
      end
      --0,0xc0,0xe0,0xf0
      if code >= 0xf0 then
        pos = pos + 4;
        len = len + 2;
      elseif code >= 0xe0 then
        pos = pos + 3;
        len = len + 2;
      elseif code >= 0xc0 then
        pos = pos + 2
        len = len + 2;
      else
        pos = pos + 1
        len = len + 1;
      end
  
      --len = len + 1;
    end
  
    return string.sub(str,1,pos - 1),string.sub(str,pos);
  end
  
return WaterHole;