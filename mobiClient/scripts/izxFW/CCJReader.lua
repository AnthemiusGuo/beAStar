--
-- Author: Guo Jia
-- Date: 2014-01-22 14:37:22
--
local CCJReader = class("CCJReader")
local CCJReader_VERSION = 0.5;
local debugPrefix = "";
function CCJReader:ctor(ccjFileName)
	self.jsonStr = CCString:createWithContentsOfFile(ccjFileName):getCString().."";
    self.jsonFile = json.decode(self.jsonStr);
end

function CCJReader:read()
	self.jsonNodeList = self.jsonFile.nodeList;
end

function CCJReader:getPosition(posInfo,parentWeight,parentHeight)
	if (posInfo[5]==nil) then
		posInfo[5] = "LEFT_BOTTOM"
	end
	local posTyp = display[posInfo[5]];
	-- display.CENTER        = 1
	-- display.LEFT_TOP      = 2; display.TOP_LEFT      = 2
	-- display.CENTER_TOP    = 3; display.TOP_CENTER    = 3
	-- display.RIGHT_TOP     = 4; display.TOP_RIGHT     = 4
	-- display.CENTER_LEFT   = 5; display.LEFT_CENTER   = 5
	-- display.CENTER_RIGHT  = 6; display.RIGHT_CENTER  = 6
	-- display.BOTTOM_LEFT   = 7; display.LEFT_BOTTOM   = 7
	-- display.BOTTOM_RIGHT  = 8; display.RIGHT_BOTTOM  = 8
	-- display.BOTTOM_CENTER = 9; display.CENTER_BOTTOM = 9
	local myX = 0;
	local myY = 0;

	if (posInfo[2]=="%") then
		if (posTyp==display.CENTER or posTyp==display.CENTER_TOP or posTyp==display.CENTER_BOTTOM) then
			myX = parentWeight/2 + posInfo[1] * parentWeight /100;
		elseif (posTyp==display.RIGHT_TOP or posTyp==display.RIGHT_CENTER or posTyp==display.RIGHT_BOTTOM) then
			myX = parentWeight - posInfo[1] * parentWeight /100;
		else
			myX = posInfo[1] * parentWeight /100;
		end
	elseif (posInfo[2]=="px") then
		if (posTyp==display.CENTER or posTyp==display.CENTER_TOP or posTyp==display.CENTER_BOTTOM) then
			myX = parentWeight/2 + posInfo[1];
		elseif (posTyp==display.RIGHT_TOP or posTyp==display.RIGHT_CENTER or posTyp==display.RIGHT_BOTTOM) then
			myX = parentWeight - posInfo[1];
		else
			myX = posInfo[1];
		end
	end

	if (posInfo[4]=="%") then
		if (posTyp==display.CENTER or posTyp==display.LEFT_CENTER or posTyp==display.RIGHT_CENTER) then
			myY = parentHeight/2 + posInfo[3] * parentHeight /100;
		elseif (posTyp==display.CENTER_TOP or posTyp==display.LEFT_TOP or posTyp==display.RIGHT_TOP) then
			myY = parentHeight - posInfo[3] * parentHeight /100;
		else
			myY = posInfo[3] * parentHeight /100;
		end
	elseif (posInfo[4]=="px") then
		if (posTyp==display.CENTER or posTyp==display.LEFT_CENTER or posTyp==display.RIGHT_CENTER) then
			myY = parentHeight/2 + posInfo[3];
		elseif (posTyp==display.CENTER_TOP or posTyp==display.LEFT_TOP or posTyp==display.RIGHT_TOP) then
			myY = parentHeight - posInfo[3];
		else
			myY = posInfo[3];
		end
	end
	return myX,myY;

end

function CCJReader:createCCNode(info)
	local thisNode = display.newNode();
	return thisNode;
end

function CCJReader:createCCLayer(info)
	local thisNode = display.newLayer();
	return thisNode;
end

function CCJReader:createCCSprite(info)
	local thisNode = display.newSprite(info.properties.displayFrame);
	return thisNode;
end

function CCJReader:createCCScale9Sprite(info)
	local thisNode = display.newScale9Sprite(info.properties.displayFrame,display.cx,display.cy,CCSizeMake(display.width, display.height));
	if (info.properties.inset) then
		if (info.properties.inset[1]>0) then
			thisNode:setInsetTop(info.properties.inset[1])
		end
		if (info.properties.inset[2]>0) then
			thisNode:setInsetRight(info.properties.inset[2])
		end
		if (info.properties.inset[3]>0) then
			thisNode:setInsetBottom(info.properties.inset[3])
		end
		if (info.properties.inset[4]>0) then
			thisNode:setInsetLeft(info.properties.inset[4])
		end
	end
	return thisNode;
end

function CCJReader:createCCLayerColor(info)
	local thisNode = display.newColorLayer(ccc4(info.properties.color[1],info.properties.color[2],info.properties.color[3],info.properties.opacity));
	return thisNode;
end

function CCJReader:createCCControlButton(info)
	local thisNode = nil;
	local imgButton = {};
	if (type(info.properties.backgroundSpriteFrame)=="table") then
		imgButton = {
            normal = info.properties.backgroundSpriteFrame[1],
            pressed = info.properties.backgroundSpriteFrame[2],
            disabled = info.properties.backgroundSpriteFrame[3]
        };
    elseif  (type(info.properties.backgroundSpriteFrame)=="string") then
    	imgButton = {
            normal = info.properties.backgroundSpriteFrame,
            pressed = info.properties.backgroundSpriteFrame,
            disabled = info.properties.backgroundSpriteFrame
        };
    end
	thisNode = cc.ui.UIPushButton.new(imgButton,{scale9 = info.properties.scale9});
	if (info.properties.title==nil) then

	elseif (#info.properties.title==1) then
		thisNode:setButtonLabel(ui.newTTFLabel({
                text = info.properties.title[1].title,
                size = info.properties.title[1].titleTTFSize,
                color = ccc3(info.properties.title[1].titleColor[1],
                	info.properties.title[1].titleColor[2],
                	info.properties.title[1].titleColor[3])
            }));
	elseif (#info.properties.title==3) then
		thisNode:setButtonLabel("normal",ui.newTTFLabel({
                text = info.properties.title[1].title,
                size = info.properties.title[1].titleTTFSize,
                color = ccc3(info.properties.title[1].titleColor[1],
                	info.properties.title[1].titleColor[2],
                	info.properties.title[1].titleColor[3])
            }))
			:setButtonLabel("pressed",ui.newTTFLabel({
                    text = info.properties.title[2].title,
                    size = info.properties.title[2].titleTTFSize,
                    color = ccc3(info.properties.title[2].titleColor[1],
                    	info.properties.title[2].titleColor[2],
                    	info.properties.title[2].titleColor[3])
                }))
			:setButtonLabel("disabled",ui.newTTFLabel({
                    text = info.properties.title[3].title,
                    size = info.properties.title[3].titleTTFSize,
                    color = ccc3(info.properties.title[3].titleColor[1],
                    	info.properties.title[3].titleColor[2],
                    	info.properties.title[3].titleColor[3])
                }));
	end  
	
	return thisNode;
end

function CCJReader:createCCLabelTTF(info)
	local thisNode = ui.newTTFLabel({
	                    text = info.properties.string,
	                    size = info.properties.fontSize,
	                    color = ccc3(info.properties.fontColor[1],
	                    	info.properties.fontColor[2],
	                    	info.properties.fontColor[3]),
	                    font = info.properties.fontName,
	                    align = info.properties.align});
		-- info.properties.align
		-- display.CENTER        = 1
		-- display.LEFT_TOP      = 2; display.TOP_LEFT      = 2
		-- display.CENTER_TOP    = 3; display.TOP_CENTER    = 3
		-- display.RIGHT_TOP     = 4; display.TOP_RIGHT     = 4
		-- display.CENTER_LEFT   = 5; display.LEFT_CENTER   = 5
		-- display.CENTER_RIGHT  = 6; display.RIGHT_CENTER  = 6
		-- display.BOTTOM_LEFT   = 7; display.LEFT_BOTTOM   = 7
		-- display.BOTTOM_RIGHT  = 8; display.RIGHT_BOTTOM  = 8
		-- display.BOTTOM_CENTER = 9; display.CENTER_BOTTOM = 9
	return thisNode;
end

function CCJReader:createCCLabelBMFont(info)
	local thisNode = ui.newBMFontLabel({
				text = info.properties.string,
				align = info.properties.align,
				font = info.properties.fntFile
			});
	return thisNode;
end

function CCJReader:createElement(info,parentWeight,parentHeight)
	echoInfo("%s dealing createElement %s",debugPrefix,info.baseClass);
	local thisNode = nil;
	if (self['create'..info.baseClass]) then
		thisNode = self['create'..info.baseClass](self,info);
	else
		echoError("no route for class:%s",info.baseClass);
		return nil;
	end

	local myWeight = 0;
	local myHeight = 0;
	if (info.properties.contentSize) then
		if (info.properties.contentSize[2]=="%") then
			myWeight = info.properties.contentSize[1] * parentWeight /100;
		elseif (info.properties.contentSize[2]=="px") then
			myWeight = info.properties.contentSize[1];
		end

		if (info.properties.contentSize[4]=="%") then
			myHeight = info.properties.contentSize[3] * parentHeight /100;
		elseif (info.properties.contentSize[4]=="px") then
			myHeight = info.properties.contentSize[3];
		end
		echoInfo("%s dealing contentSize w:%d,h:%d",debugPrefix,myWeight,myHeight);
		thisNode:setContentSize(CCSizeMake(myWeight, myHeight));
	else
		myWeight,myHeight = thisNode:getContentSize();
	end
	if (info.properties.scale) then
		thisNode:setScaleX(info.properties.scale[1]);
		thisNode:setScaleY(info.properties.scale[2]);
	end
	if (info.properties.anchorPoint) then
		thisNode:setAnchorPoint(ccp(info.properties.anchorPoint[1],info.properties.anchorPoint[2]));
	end
	if (info.properties.position) then

		local myX,myY = self:getPosition(info.properties.position,parentWeight,parentHeight);
		echoInfo("%s dealing position x:%d,y:%d",debugPrefix,myX,myY);
		thisNode:setPosition(myX,myY);
	end
	if (info.properties.preferedSize) then
		if (info.properties.preferedSize[2]=="%") then
			myWeight = info.properties.preferedSize[1] * parentWeight /100;
		elseif (info.properties.preferedSize[2]=="px") then
			myWeight = info.properties.preferedSize[1];
		end

		if (info.properties.preferedSize[4]=="%") then
			myHeight = info.properties.preferedSize[3] * parentHeight /100;
		elseif (info.properties.preferedSize[4]=="px") then
			myHeight = info.properties.preferedSize[3];
		end
		echoInfo("%s dealing preferedSize w:%d,h:%d",debugPrefix,myWeight,myHeight);
		if (info.baseClass == "CCControlButton") then
			thisNode:setButtonSize(myWeight, myHeight)
		else
			thisNode:setPreferredSize(CCSizeMake(myWeight,myHeight));
		end
	end
	if (info.properties.visible==false) then
		thisNode:setVisible(false);
	end

	if (info.var and info.var~="null") then
		self.targetRoot[info.var] = thisNode;
	end
	if (info.ccControl and info.ccControl~="null") then
		thisNode:onButtonClicked(handler(self.targetRoot,self.targetRoot[info.ccControl]));
	end
	
	if (info.children) then
		debugPrefix = debugPrefix.."\t";

		for k,v in pairs(info.children) do
			local tmpNode = self:createElement(v,myWeight,myHeight);
			if (tmpNode~=nil) then
				thisNode:addChild(tmpNode);
			end
		end
	end
	return thisNode;

end

function CCJReader:load(targetRoot)
	if (self.jsonFile == nil) then
		return;
	end
	self.targetRoot = targetRoot;
	local rootNode = self:createElement(self.jsonFile.nodeGraph.root,display.width,display.height);
	self.jsonFile = nil;
	self.jsonStr = nil;
	self.targetRoot = nil;
	return rootNode;
end

return CCJReader;