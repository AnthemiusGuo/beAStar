                local BiSaiFailScene = class("BiSaiFailScene",izx.baseView)

function BiSaiFailScene:ctor(pageName,moduleName,initParam)
	print ("BiSaiFailScene:ctor")

	self.super.ctor(self,pageName,moduleName,initParam);
end

function BiSaiFailScene:onAssignVars()
	self.rootNode = tolua.cast(self.rootNode,"CCNode");

    if nil ~= self["labelRank"] then
    	self.labelRank = tolua.cast(self["labelRank"],"CCLabelTTF")
    end
    if nil ~= self["lableZeit"] then
    	self.lableZeit = tolua.cast(self["lableZeit"],"CCLabelTTF")
    end
    
    if nil ~= self["labelReliveNum"] then
        self.labelReliveNum = tolua.cast(self["labelReliveNum"],"CCLabelTTF")
    end

    if nil ~= self["spriteTitleBg"] then
        self.spriteTitleBg = tolua.cast(self["spriteTitleBg"],"CCSprite")
    end 

    if nil ~= self["spriteTitle"] then
        self.spriteTitle = tolua.cast(self["spriteTitle"],"CCSprite")
    end 
     if nil ~= self["btnRelive"] then
        self.btnRelive = tolua.cast(self["btnRelive"],"CCControlButton")
    end 
    
end

function BiSaiFailScene:onInitView() 
    print("BiSaiFailScene:onInitView")

    self:lightAnimation()
    --self:initBaseInfo()
end
-- function scheduler.performWithDelayGlobalWithPara(listener, time, para)
--     local handle
--     local sharedScheduler = CCDirector:sharedDirector():getScheduler()
--     handle = sharedScheduler:scheduleScriptFunc(function()
--         scheduler.unscheduleGlobal(handle)
--         listener(gBaseLogic.lobbyLogic,para)
--     end, time, false)
--     return handle
-- end
function BiSaiFailScene:initBaseInfo()
    print("BiSaiFailScene:initBaseInfo")
    self:showFailInfo(self.ctrller.data)


    --scheduler.performWithDelayGlobalWithPara(gBaseLogic.lobbyLogic.pt_lc_match_perpare_notf_handler, 5.0,{match_id_ = 1,match_order_id_ = 2,data_={game_id_=10,server_addr_ = "s3.casino.hiigame.net",server_port_ = "7305",channel_id_=1004,server_id_=1008,server_name_ = "高级场",current_score_ = 3000,round_index_ =1,totoal_round_ = 3}})--for test
end

function BiSaiFailScene:onPressOther()
    print("onPressOther")
    izx.baseAudio:playSound("audio_menu");
    gBaseLogic.sceneManager:removePopUp("BiSaiFailScene");
    gBaseLogic.lobbyLogic:showBiSaiChang()
end

function BiSaiFailScene:onPressRelive()
    print("onPressRelive")
    izx.baseAudio:playSound("audio_menu");
    if self.ctrller.data.reliveNum <= 0 then
        self.ctrller:getReliveCardPayInfo()
    elseif self.ctrller.data.canRelive == 0 then 
        izxMessageBox("比赛已经进行到最后一轮了，无法复活，不如参加下一场比赛吧。","温馨提示")
    else
        self.ctrller:pt_cl_match_reborn_req()
    end
end 

function BiSaiFailScene:onPressBack()
    print("onPressBack")
    izx.baseAudio:playSound("audio_menu");
    if self.ctrller.data.type == 0 or self.ctrller.data.type == 2 then 
        local msg = "您还有一场比赛没有结束,是否退赛？"

        gBaseLogic:confirmBox({
            msg=msg,
        callbackConfirm = function()
	        local socketMsg = {opcode = 'pt_cl_do_sign_match_req',
	                       match_id_ = self.ctrller.data.matchID, 
	                       match_order_id_ = self.ctrller.data.matchOrderID,
	                       operate_type_= 3,
	                       }
	                       print("BiSaiFailScene:onPressBack");
	          var_dump(socketMsg)
	    	gBaseLogic.lobbyLogic:sendLobbySocket(socketMsg);
            
            
        end})
    else 
        gBaseLogic.lobbyLogic:goBackToMain();
    end
    
end 

function BiSaiFailScene:onRemovePage()
    if scheduler ~= nil then 
        if self.ctrller.matchTimeHandler ~= nil  then
            scheduler.unscheduleGlobal(self.ctrller.matchTimeHandler)
            self.ctrller.matchTimeHandler = nil; 
        end
    end
    if self.scheduler~=nil then
	 	scheduler.unscheduleGlobal(self.scheduler)
    	self.scheduler = nil
    end
    if self.serTimeHandler~=nil then
	 	scheduler.unscheduleGlobal(self.serTimeHandler)
    	self.serTimeHandler = nil
    end
end

function BiSaiFailScene:setMatchTitle()
	print("BiSaiFailScene:setMatchTitle"..self.ctrller.data.matchtyp)
    if self.ctrller.data.matchtyp > 0 and self.ctrller.matchTitle[self.ctrller.data.matchtyp]~=nil then
    	local thistyp = self.ctrller.data.matchtyp;
    	-- if self.ctrller.data.matchID>6 then
    	-- 	thistyp = 6
    	-- end
        local fileName = self.ctrller.matchTitle[self.ctrller.data.matchtyp]
        self.spriteTitle:setTexture(getCCTextureByName(fileName))
    else
    	HTTPPostRequest(URL.Match_Info, {matchid=self.ctrller.data.matchID}, function(event)
        print("BiSaiChangeSceneCtrller:reqRaceRoomInfoData")
        var_dump(tableRst)
        if (event ~= nil) then
            -- var_dump(event,5)
            -- --local message =  self:initRaceRoomLocalInfoData()
            -- local message = event 
            -- gBaseLogic.lobbyLogic.matchInfo = message
            -- self:resetData(message)
            -- self.view:initBaseInfo(); 
            if event.matchinfo~=nil then
            	self.ctrller.data.matchtyp = event.matchinfo.matchtype;
		     	if self.spriteTitle~=nil then
			        local fileName = self.ctrller.matchTitle[self.ctrller.data.matchtyp]

			        self.spriteTitle:setTexture(getCCTextureByName(fileName))
			    end
            end
        end     
        end);
    end
end 

function BiSaiFailScene:lightAnimation()
    print("lightAnimation");
    local sName = "light_ani";
    local ani = CCAnimationCache:sharedAnimationCache():animationByName(sName);

    if (ani) then
    else
        ani = CCAnimation:create();
        ani:setDelayPerUnit(0.1);
        ani:addSpriteFrameWithFileName("images/DaTing/lobby_bisai_paibianguang1.png") 
        ani:addSpriteFrameWithFileName("images/DaTing/lobby_bisai_paibianguang2.png")             
        
        CCAnimationCache:sharedAnimationCache():addAnimation(ani, sName);

    end 

    local frame =  tolua.cast(ani:getFrames():objectAtIndex(0),"CCAnimationFrame"):getSpriteFrame()
    local sprite = CCSprite:createWithSpriteFrame(frame);

    sprite:setAnchorPoint(ccp(0.5,1.0))
    sprite:setPosition(self.spriteTitleBg:getPosition());
    self.rootNode:addChild(sprite);
    sprite:runAction(CCRepeatForever:create(CCAnimate:create(ani)));
end

function BiSaiFailScene:showFailInfo(data)
    var_dump(data)
    self:setMatchTitle()

    if data.type == 1 then 
        self.labelRank:setString("真遗憾！技不如人，你在本场比赛中，惨被淘汰了，总共"..(data.curRond+1).."/"..data.totoalRound.."轮。")
        if (data.totoalRound-(data.curRond+1)>1) then
	        self.labelTips:setString("选择复活可以重新挑战，但会消耗1个复活券")
	        self.nodeZeit:setVisible(true)
	        local this_num = 15;
	        local OnTimer = function(dt)
		    	print("BiSaiFailScene:OnTimer"..this_num);
		    	self.lableZeit:setString(this_num)
		    	
		    	if this_num==0 then
		    		scheduler.unscheduleGlobal(self.serTimeHandler)
    				self.serTimeHandler = nil
    				self.labelTips:setVisible(false);
	    			self.btnRelive:setEnabled(false);
	    			self.nodeZeit:setVisible(false)
		    	end

		    	this_num = this_num-1;
		        
		    end
		    if self.serTimeHandler==nil then
		    	self.serTimeHandler = scheduler.scheduleGlobal(OnTimer, 1, false)
		    end
	    else
	    	self.labelTips:setVisible(false);
	    	self.btnRelive:setEnabled(false);
	    end
        self.spriteTypeImage:setTexture(getCCTextureByName("images/TanChu/popup_pic_dizhusheng.png"))
        self.labelReliveNum:setString(data.reliveNum)
        self.nodeRelive:setVisible(true)
        self.nodeSignOther:setVisible(true)
        self.nodeBack:setVisible(true)
    elseif data.type == 0 then 
    	if data.pre_match==1 then
    		self.labelRank:setString("比赛即将开始，请耐心等待......")
    	else
	        self.labelRank:setString("还有选手没有结束比赛，请耐心等待......")
	    end
        self.labelTips:setString("话费券可以在兑换页面兑换实物话费")
        self.nodewait:setVisible(true);
        self.spriteTypeImage:setVisible(false);
        self.nodeRelive:setVisible(false)
        self.nodeSignOther:setVisible(false)
        self.nodeBack:setVisible(true)
        
	    self.nodeZeit:setVisible(false)
    elseif data.type == 2 then 
        self.labelRank:setString("运气不错，本轮比赛轮空了，离话费又近了一步。\n请耐心等待其他选手结束本轮比赛。"..data.curRond.."/"..data.totoalRound.."轮")
        self.labelTips:setString("话费券可以在兑换页面兑换实物话费")
        self.spriteTypeImage:setTexture(getCCTextureByName("images/TanChu/popup_pic_dizhusheng.png"))
        self.nodeLunkong:setVisible(true);
        self.spriteTypeImage:setVisible(false);
        self.nodeRelive:setVisible(false)
        self.nodeSignOther:setVisible(false)
        self.nodeBack:setVisible(true)
        self.nodeZeit:setVisible(false)
    else 
    end
end


function BiSaiFailScene:showReliveCardPay(info,data,x,y)
    local popBoxTips = {};
   
    function popBoxTips:onAssignVars()
        self.labelTitle = tolua.cast(self["labelTitle"],"CCLabelTTF");
        self.labelContent = tolua.cast(self["labelContent"],"CCLabelTTF");

        self.labelMoney = tolua.cast(self["labelMoney"],"CCLabelTTF");
        self.labelCount = tolua.cast(self["labelCount"],"CCLabelTTF")

        if nil ~= info then 
            print("showBuQianKaPay",info.url)
            izx.resourceManager:imgFileDown(info.url,true,function(fileName) 
                    self.spriteBuQianKa:setTexture(getCCTextureByName(fileName))
            end);
            self.labelTitle:setString("复活卡不足")
            self.labelMoney:setString("¥"..info.money)  
            self.labelCount:setString("复活卡（"..info.count.."张）")
            self.labelContent:setString("复活卡恢复3000比赛\n积分并重新回到比赛")           
        end
    end

    function popBoxTips:onPressClose()
        gBaseLogic.sceneManager.currentPage.view:closePopBox();
    end 

    function popBoxTips:onPressConfirm()
        local tmptype = "SMS" --"Normal"
        gBaseLogic:addLogDdefine("shopPay","payType",info.money)
        --if tmptype=="SMS" then
            --gBaseLogic.lobbyLogic:onPayTips(3, tmptype, data, 0)
        --else
            gBaseLogic.lobbyLogic:pay(data,tmptype,3);
        --end 
        gBaseLogic.sceneManager.currentPage.view:closePopBox();
        gBaseLogic:blockUI({autoUnblock=false})
        --for test 
        --[[
        local x = gBaseLogic.lobbyLogic.QianDaoLayer.ctrller.data.index
        local ply_items = gBaseLogic.lobbyLogic.userData.ply_items_
        gBaseLogic.lobbyLogic.QianDaoLayer.ctrller:setItemNumber(ply_items,x,5)
        gBaseLogic.lobbyLogic:dispatchLogicEvent({
            name = "MSG_SOCK_pt_lc_send_user_data_change_not",
            message = {ply_items_ = ply_items}
        })
        --]]
    end 
    gBaseLogic.sceneManager.currentPage.view:showPopBoxCCB("interfaces/QianDaoKa.ccbi",popBoxTips,true,1)
    gBaseLogic.sceneManager.currentPage.view.nodePopBox:setPosition(x,y);

end

function BiSaiFailScene:unWaitingAni(target,opt)
	if self.scheduler~=nil then
    	scheduler.unscheduleGlobal(self.scheduler)
    	self.scheduler = nil
    end
    gBaseLogic:unblockUI();

end

function BiSaiFailScene:loadingAni()
     --gBaseLogic.sceneManager:waitingAni(self.rootNode,self.unWaitingAni,100)
     gBaseLogic:blockUI();
     self.scheduler = scheduler.performWithDelayGlobal(handler(self, self.unWaitingAni), 5.0)
end


return BiSaiFailScene;