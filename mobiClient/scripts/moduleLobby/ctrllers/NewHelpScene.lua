local NewHelpSceneCtrller = class("NewHelpSceneCtrller",izx.baseCtrller)

function NewHelpSceneCtrller:ctor(pageName,moduleName,initParam)
    self.data = {
    
    };
    self.initlayer = nil;

	NewHelpSceneCtrller.super.ctor(self,pageName,moduleName,initParam);
end

function NewHelpSceneCtrller:onEnter()
    -- body
end

function NewHelpSceneCtrller:sendFeedback(msg)
	local url = string.gsub(URL.Feedback,"{pid}",self.logic.userData.ply_guid_);  
	url = string.gsub(url,"{packageName}",gBaseLogic.packageName);
	url = string.gsub(url,"{msg}",trim(msg));
	url = string.gsub(url,"{ticket}",self.logic.userData.ply_ticket_);
	print (url);
	gBaseLogic:HTTPGetdata(url,0,function(event)
		gBaseLogic:unblockUI();
        -- 是否持久化
        
        -- CCUserDefault:sharedUserDefault():setStringForKey("ply_guid_", userInfo.ply_guid_)
        if (event.ret==0) then
        	izxMessageBox("谢谢您的意见", "意见提交成功")
        else
           izxMessageBox("意见反馈提交失败", "提交失败") 
	    end
        self.view:showFeedbackMsg()
        self.view.editBox:setText("");
	    
        end)  
end
  
return NewHelpSceneCtrller;