local NoticeSceneCtrller = class("NoticeSceneCtrller",izx.baseCtrller)

function NoticeSceneCtrller:ctor(pageName,moduleName,initParam)
    self.data = {
    	notice_list = {}
    };

	self.super.ctor(self,pageName,moduleName,initParam);
end

function NoticeSceneCtrller:onEnter()
    -- body
end
function NoticeSceneCtrller:run()
	self:requestHTTGongGaoCommon();
	-- self.requestHTTGongGao()
    NoticeSceneCtrller.super.run(self);
end

function NoticeSceneCtrller:requestHTTGongGaoCommon()
	-- ???? todo
	local url = "http://payment.hiigame.com:18000/new/gateway/ance?pn="
	-- local url = "http://payment.hiigame.com:18000/new/gateway/ance?pn=" .. gBaseLogic.packageName;

	gBaseLogic:HTTPGetdata(url,0,function(event)        
        if (event == nil) then
        else
        	gBaseLogic:unblockUI()    
			self.data.notice_list = event.resultList; 
		    if	type(self.data.notice_list) == "table" then
		    	local index_ = 1
				for k,v in pairs(self.data.notice_list) do
					local imgSpiteList = string.split(v.imgs, '/');					
					local tFiles = gBaseLogic.DownloadPath .. imgSpiteList[#imgSpiteList];
					if io.exists(tFiles) == false then				  		 
				  		v.local_img = "images/Notice/none.jpg";
				  		gBaseLogic:img_file_down(tFiles,v.imgs,function() 
				  			self.data.notice_list[k].local_img = tFiles;
							self.view:refreshdata(index_)
				  			end)
				  	else 
				  		v.local_img = tFiles;
				 	end
				 	index_ = index_+1
				 end
			end
			self.view:refreshdata()
    	end
	    
        end)   
end  
return NoticeSceneCtrller;