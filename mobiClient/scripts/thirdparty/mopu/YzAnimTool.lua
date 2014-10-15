local YzAnimTool = class("YzAnimTool") 
function YzAnimTool:ctor()
	
    self.data = {
    	
    };
    
end

-- function CCardSprite:initWithCard(card)
	
-- end

function YzAnimTool:CreateAnimByPng(sImg,DelayPerUnit,sFileType, sFrameName,idxBeginFrame,idxEndFrame, bRet)
	print("YzAnimTool:CreateAnimByPng")
	if sImg==nil then
		sImg = "SplashScreen"
	end
	-- local animFrames --= CCAnimationCache:sharedAnimationCache():animationByName(sImg);
	-- if animFrames==nil then	  	
		
		local cache = CCSpriteFrameCache:sharedSpriteFrameCache()
		if sFileType==nil then
			sFileType = "png";
		end
		cache:addSpriteFramesWithFile("thirdparty/"..sImg..".plist", "thirdparty/"..sImg.."."..sFileType) 
		var_dump(cache,4) 
		local i=1;
		local animFrames = CCArray:create()
		-- pAnimation = CCAnimation:create();
		if idxBeginFrame==nil then
			idxBeginFrame=1
		end
		local i = idxBeginFrame;
		if sFrameName==nil then
			sFrameName="";
		end
		if idxEndFrame==nil then
			idxEndFrame=100
		end
	    while true do
	        local frame = cache:spriteFrameByName(sFrameName..i..".png")	       
	        if frame==nil then
	        	break;
	        end
	        var_dump(frame)
	        print("111111"..i);
	        animFrames:addObject(frame)
	        if (idxEndFrame>1 and i==idxEndFrame) then
				break;
			end
	        i = i + 1
	    end
	    cache:removeSpriteFramesFromFile("thirdparty/"..sImg..".plist")
		-- CCAnimationCache:sharedAnimationCache():addAnimation(animFrames,sImg);
		print("========================================");
	-- end
	-- local animMixed = CCAnimation:createWithSpriteFrames(moreFrames, 0.3)

 --    SpriteFrameTest.m_pSprite2:runAction(CCRepeatForever:create( CCAnimate:create(animMixed) ) )
	local animation = CCAnimation:createWithSpriteFrames(animFrames, DelayPerUnit)
	if bRet==nil then
		bRet= false
	end
	animation:setRestoreOriginalFrame(bRet)
	return CCAnimate:create(animation);
	
end

function YzAnimTool:CreateRptAnimByPng(pngName,DelayPerUnit,fileType,frameName,beginFrameIndex,endFrameIndex,isReturn)

	return CCRepeatForever:create(self:CreateAnimByPng(pngName,DelayPerUnit,fileType,frameName,beginFrameIndex,endFrameIndex,isReturn));
end
function YzAnimTool:PlayStartSplash(scene,cback)
	-- local size = CCDirector:sharedDirector():getWinSize()
	local sp = CCSprite:create();
	if scene==nil then
		scene = CCDirector:sharedDirector():getRunningScene();
	end
	-- local scene = gBaseLogic.sceneManager.currentPage.scene
	scene:addChild(sp,1000);
	sp:setPosition(display.cx, display.cy);
	local actAmin = self:CreateAnimByPng("SplashScreen", 0.05);
	-- pCard:runAction(transition.sequence({action1, action2, action3,action4, action5,action6,action7}));
	-- local actSeq = CCSequence:create(actAmin, cback, CCRemoveSelf:create(), NULL);
	print("YzAnimTool:PlayStartSplash")
	local actionMoveDone= CCCallFuncN:create(function() 
		print(1111) 
		sp:removeFromParentAndCleanup(true);
		if cback then 
			cback()
		end
		end);
	sp:runAction(transition.sequence({actAmin,actionMoveDone}));
end

return YzAnimTool;