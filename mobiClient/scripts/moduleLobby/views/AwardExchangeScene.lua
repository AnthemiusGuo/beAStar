
local AwardExchangeScene = class("AwardExchangeScene", izx.baseView);
----------------------------------------------------------------------------------------------------
function AwardExchangeScene:ctor(pageName, moduleName, initParam)

	self.super.ctor(self, pageName, moduleName, initParam);
end

function AwardExchangeScene:onAssignVars()
	print("AwardExchangeScene:onAssignVars")
	self.numTicketsText = tolua.cast(self["numTicketsText"], "CCLabelTTF");
	self.numTicketsText2 = tolua.cast(self["numTicketsText2"], "CCLabelTTF");
	var_dump(gBaseLogic.lobbyLogic.userData.ply_items_)
	self.huafeiquan = 0
	for i = 1, #gBaseLogic.lobbyLogic.userData.ply_items_ do
		local itemData = gBaseLogic.lobbyLogic.userData.ply_items_[i];
		if itemData.index_ == 56 then
			self.numTicketsText:setString(itemData.num_);
			self.huafeiquan = itemData.num_
		end		 
	end
	self.numTicketsText2:setString(gBaseLogic.lobbyLogic.userData.ply_lobby_data_.gift_);
	self.buttonBackground = tolua.cast(self["buttonBackground"], "CCSprite");

	-- self.giftExchangeButton = tolua.cast(self["giftExchangeButton"], "CCControlButton");

	self.ticketExchangeButton = tolua.cast(self["ticketExchangeButton"], "CCControlButton");

	self.codeExchangeButton = tolua.cast(self["codeExchangeButton"], "CCControlButton");

	self.exchangeRecordButton = tolua.cast(self["exchangeRecordButton"], "CCControlButton");
	-- 
	self.ticketExchangeLayer = tolua.cast(self["ticketExchangeLayer"], "CCLayer");

	self.ticketExchangeTableViewReference = tolua.cast(self["ticketExchangeTableViewReference"], "CCNode");
	-- 
	self.codeExchangeLayer = tolua.cast(self["codeExchangeLayer"], "CCLayer");

	self.inputTextReference = tolua.cast(self["inputTextReference"], "CCNode");

	self.inputText = CCEditBox:create(self.inputTextReference:getContentSize(), CCScale9Sprite:create("images/LieBiao/list_bg_shurujihuo.png"));
	self.inputText:setFontSize(30);
	self.inputText:setFontColor(ccc3(0, 0, 0));
	self.inputText:setPlaceholderFontColor(ccc3(128, 128, 128));
	self.inputText:setPlaceHolder("点击此处输入激活码");
	self.inputText:setReturnType(kKeyboardReturnTypeDone);
	self.inputText:setMaxLength(128);
	self.inputText:setAnchorPoint(self.inputTextReference:getAnchorPoint());
	self.inputText:setPosition(self.inputTextReference:getPosition());

	self.codeExchangeLayer:addChild(self.inputText);

	self.helpDescriptionText = tolua.cast(self["helpDescriptionText"], "CCLabelTTF");
	if gBaseLogic.MBPluginManager.distributions.jihuomaMsg~=nil and 
		gBaseLogic.MBPluginManager.distributions.jihuomaMsg~="" then
		self.helpDescriptionText:setString(gBaseLogic.MBPluginManager.distributions.jihuomaMsg);
	else
		self.helpDescriptionText:setString("您可以通过关注微信公众号：qipai999 或 QQ群：121764511 获取激活码。");
	end
	-- 
	self.exchangeRecordLayer = tolua.cast(self["exchangeRecordLayer"], "CCLayer");

	self.exchangeRecordTableViewReference = tolua.cast(self["exchangeRecordTableViewReference"], "CCNode");
	-- 
	self:hideAllLayer();
	self:showTicketExchangeLayer(-1);
	self.ticketExchangeButton:setEnabled(false);
	--self:showGiftExchangeLayer()
	--self.giftExchangeButton:setEnabled(false);
end

function AwardExchangeScene:onInitView()

end
----------------------------------------------------------------------------------------------------
function AwardExchangeScene:onPressBack()

	izx.baseAudio:playSound("audio_menu");

	self.logic:goBackToMain();
end

function AwardExchangeScene:onPressTicketExchangeButton()

	izx.baseAudio:playSound("audio_menu");

	self:hideAllLayer();

	self:showTicketExchangeLayer(-1);

	-- self.giftExchangeButton:setEnabled(true);
	self.ticketExchangeButton:setEnabled(false);
	self.codeExchangeButton:setEnabled(true);
	self.exchangeRecordButton:setEnabled(true);
	self:SliderMoveAction(self.shopSlider, self.ticketExchangeButton:getPositionX(), nil, 0.2);
end

function AwardExchangeScene:onPressGiftExchangeButton()

	izx.baseAudio:playSound("audio_menu");

	self:hideAllLayer();

	self:showTicketExchangeLayer(80);

	-- self.giftExchangeButton:setEnabled(false);
	self.ticketExchangeButton:setEnabled(true);
	self.codeExchangeButton:setEnabled(true);
	self.exchangeRecordButton:setEnabled(true);
	self:SliderMoveAction(self.shopSlider, self.giftExchangeButton:getPositionX(), nil, 0.2);
end


function AwardExchangeScene:onPressCodeExchangeButton()

	izx.baseAudio:playSound("audio_menu");

	self:hideAllLayer();

	self:showCodeExchangeLayer();

	-- self.giftExchangeButton:setEnabled(true);
	self.codeExchangeButton:setEnabled(false);
	self.ticketExchangeButton:setEnabled(true);
	self.exchangeRecordButton:setEnabled(true);
	self:SliderMoveAction(self.shopSlider, self.codeExchangeButton:getPositionX(), nil, 0.2);
end

function AwardExchangeScene:onPressExchangeRecordButton()

	izx.baseAudio:playSound("audio_menu");

	self:hideAllLayer();

	self:showExchangeRecordLayer();

	-- self.giftExchangeButton:setEnabled(true);
	self.exchangeRecordButton:setEnabled(false);
	self.ticketExchangeButton:setEnabled(true);
	self.codeExchangeButton:setEnabled(true);
	self:SliderMoveAction(self.shopSlider, self.exchangeRecordButton:getPositionX(), nil, 0.2);
end

function AwardExchangeScene:onPressExchangeButton()

	izx.baseAudio:playSound("audio_menu");

	local code = self.inputText:getText();

	if #code < 1 or string.find(code, " ") ~= nil then

		izxMessageBox("无效的激活码，\n请重新输入。","提示");

		return;
	end

    if (code==">>*>>sro") then
    --   切正式环境
        gBaseLogic:switchEnv(ENV_OFFICIAL);
    elseif (code==">>*>>srt") then
        gBaseLogic:switchEnv(ENV_TEST );
    --切测试环境
    elseif (code==">>*>>srm") then
        gBaseLogic:switchEnv(ENV_MIRROR );
    --todoelseif
    --切镜像环境)
    elseif (code==">>*>>ver") then
        gBaseLogic:showVersion(self);
    elseif (code==">>*>>upt") then
        CCUserDefault:sharedUserDefault():setIntegerForKey("testUpgradeNew",ENV_TEST+1);
        CCDirector:sharedDirector():endToLua(); 
    elseif (code==">>*>>upm") then
        CCUserDefault:sharedUserDefault():setIntegerForKey("testUpgradeNew",ENV_MIRROR+1); 
        CCDirector:sharedDirector():endToLua();
    elseif (code==">>*>>upo") then
        CCUserDefault:sharedUserDefault():setIntegerForKey("testUpgradeNew",ENV_OFFICIAL+1); 
        CCDirector:sharedDirector():endToLua();
    elseif (code==">>*>>log") then
        CCUserDefault:sharedUserDefault():setBoolForKey("superLog",true); 
        CCDirector:sharedDirector():endToLua();
    elseif (code==">>*>>nol") then
        CCUserDefault:sharedUserDefault():setBoolForKey("superLog",false); 
        CCDirector:sharedDirector():endToLua();
    else
		self.ctrller:exchangeAward(code);
	end
end
----------------------------------------------------------------------------------------------------
function AwardExchangeScene:hideAllLayer()

	self.ticketExchangeLayer:setVisible(false);
	self.codeExchangeLayer:setVisible(false);
	self.exchangeRecordLayer:setVisible(false);
end

function AwardExchangeScene:showTicketExchangeLayer(idx)

	self.ticketExchangeLayer:setVisible(true);

	self.ctrller:getTicketExchangeData(idx);
end

function AwardExchangeScene:showCodeExchangeLayer()

	self.codeExchangeLayer:setVisible(true);
end

function AwardExchangeScene:showExchangeRecordLayer()

	self.exchangeRecordLayer:setVisible(true);

	self.ctrller:getExchangeRecordData();
end

function AwardExchangeScene:initTableView(type, data)

	local target;
	local message;

	if type == 0 then

		target = self.ticketExchangeTableViewReference;
		message = "没有可兑换的物品";

	elseif type == 1 then

		target = self.exchangeRecordTableViewReference;
		message = "没有兑换记录";
	else
		return;
	end

	if data ~= nil and #data > 0 then

		target.data = data;

		createTabView(target, target:getContentSize(), type, data, self);
	else
		ShowNoContentTip(target, message);
	end
end

function AwardExchangeScene.tableCellAtIndex(table, index)

	local cell = table:dequeueCell();
	cell = cell == nil and CCTableViewCell:new() or cell;
	cell:removeAllChildrenWithCleanup(true);
    
    
	if table:getParent().type == 0 then

		for i=0,1 do  
		if index*2+1 + i > #table:getParent().data then 
			return cell
		end
		local itemOwner = {};
		itemOwner.onPressExchangeButton0 = function()
			itemOwner["exchange0"]();
		end;
		print("self.self.self.huafeiquan========"..gBaseLogic.sceneManager.currentPage.view.huafeiquan)
		-- print(self.huafeiqian)
		-- -- 
		local item = CCBuilderReaderLoad("interfaces/DuiHuanDaoju.ccbi", CCBProxy:create(), itemOwner);
		-- 
		itemOwner.ctrller = gBaseLogic.sceneManager.currentPage.ctrller;
		itemOwner.iconReference0 = tolua.cast(itemOwner["iconReference0"], "CCSprite");
		itemOwner.typeDescriptionText0 = tolua.cast(itemOwner["typeDescriptionText0"], "CCLabelTTF");
		itemOwner.numberText0 = tolua.cast(itemOwner["numberText0"], "CCLabelTTF");
		itemOwner.requirementText0 = tolua.cast(itemOwner["requirementText0"], "CCLabelTTF");
		itemOwner.exchangeButton0 = tolua.cast(itemOwner["exchangeButton0"], "CCControlButton");
		
			local data = table:getParent().data[index*2+1 + i];

			if data ~= nil then
				itemOwner["exchange0"] =  function()	
					ptint("AwardExchangeScene.tableCellAtIndex"..data.id);

					-- HTTPPostRequest(URL.GET_EXCHANGE_PERSONAL_INFO, {matchid=self.logic.curMatchID}, function(event)
				         
				 --        var_dump(tableRst)
				 --        if (event ~= nil) then
				 --            -- var_dump(event,5)
				 --            -- --local message =  self:initRaceRoomLocalInfoData()
				 --            -- local message = event 
				 --            -- gBaseLogic.lobbyLogic.matchInfo = message
				 --            -- self:resetData(message)
				 --            -- self.view:initBaseInfo(); 
				 --            if event.matchinfo~=nil and event.matchinfo[1].matchname~=nil then
				 --            	self.labelTaskContent:setString(event.matchinfo[1].matchname);
				 --            end
				 --        end     
				 --        end);
					-- gBaseLogic.sceneManager.currentPage.ctrller:exchargingTicket(data.id,itemOwner);
					if data.index == 56 and gBaseLogic.sceneManager.currentPage.view.huafeiquan>=data.vou then
						gBaseLogic:blockUI();
						gBaseLogic.sceneManager.currentPage.ctrller:exchargingTicket(data.id,itemOwner);
					elseif data.index == 80 and gBaseLogic.lobbyLogic.userData.ply_lobby_data_.gift_>=data.vou then
						gBaseLogic:blockUI();
						gBaseLogic.sceneManager.currentPage.ctrller:exchargingTicket(data.id,itemOwner);
					else
						local msgtxt = ""
						if data.index == 56 then 
							msgtxt = "您的话费券数量不够！"
						elseif data.index == 80 then 
							msgtxt = "您的元宝数量不够！"
						else 
							msgtxt = "您的话费券和元宝不够！"
						end
						local initParam = {msg=msgtxt,type=1000};
						gBaseLogic.lobbyLogic:showYouXiTanChu(initParam)
					end
				end
				-- 
				
				itemOwner["typeDescriptionText0"]:setString(data.name);
				itemOwner["numberText0"]:setString("剩余："..data.left.."张");
				itemOwner["requirementText0"]:setString(data.vou..(data.index == 56 and "话费券" or "元宝"));
				itemOwner["exchangeButton0"]:setEnabled(tonumber(data.left) > 0 and true or false);


				izx.resourceManager:imgFileDown(data.logo,true,function(fileName) 
		            if itemOwner~=nil and itemOwner.iconReference0~=nil then
		                itemOwner.iconReference0:setTexture(getCCTextureByName(fileName))
		            end
		        end);
			end

		-- 
		item:setPosition(300+i*530,90)
		cell:addChild(item);
		end
	elseif table:getParent().type == 1 then
		local itemOwner = {};
		local item = CCBuilderReaderLoad("interfaces/ExchangeRecordItem.ccbi", CCBProxy:create(), itemOwner);
		-- 
		itemOwner.timeText = tolua.cast(itemOwner["timeText"], "CCLabelTTF");
		itemOwner.typeText = tolua.cast(itemOwner["typeText"], "CCLabelTTF");
		itemOwner.contentText = tolua.cast(itemOwner["contentText"], "CCLabelTTF");
		itemOwner.statusText = tolua.cast(itemOwner["statusText"], "CCLabelTTF");
		-- 
		local data = table:getParent().data[index + 1];
		local splittedContentTextTable = string.split(data.desc, ",");

		itemOwner.timeText:setString(data.time);
		itemOwner.typeText:setString(data.name);
		itemOwner.contentText:setString(#splittedContentTextTable < 2 and data.desc or splittedContentTextTable[1].."\n"..splittedContentTextTable[2]);
		itemOwner.statusText:setString(data.status);
		-- 
		cell:addChild(item);
	end

	return cell;
end

function AwardExchangeScene.cellSizeForTable(table, index)

	if table:getParent().type == 0 then

		return 180, 1136;

	elseif table:getParent().type == 1 then

		return 104, 1022;
	else
		return 0, 0;
	end
end

function AwardExchangeScene.numberOfCellsInTableView(table)

	local numData = #table:getParent().data;

	if table:getParent().type == 0 then

		return math.ceil(numData / 2);

	elseif table:getParent().type == 1 then

		return numData;
	else
		return 0;
	end
end
----------------------------------------------------------------------------------------------------
return AwardExchangeScene;
----------------------------------------------------------------------------------------------------