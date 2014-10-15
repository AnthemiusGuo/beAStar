local HelpSceneCtrller = class("HelpSceneCtrller",izx.baseCtrller)

function HelpSceneCtrller:ctor(pageName,moduleName,initParam)
    self.data = {
    
    };
    self.initlayer = nil;
    self.feedbacklist = {};

	HelpSceneCtrller.super.ctor(self,pageName,moduleName,initParam);
end

function HelpSceneCtrller:onEnter()
    -- body
end
--DEFAULT.URL.Feedback = "http://t.payment.hiigame.com/new/gateway/feedback?pid={pid}&ticket={ticket}&msg={msg}&pn={packageName}"
function HelpSceneCtrller:sendFeedback(msg)
    --local url = URL.Feedback.."?pid="..self.logic.userData.ply_guid_.."&ticket="..self.logic.userData.ply_ticket_.."&msg="..trim(msg).."&pn="..gBaseLogic.packageName
	local params = {
                    pid = self.logic.userData.ply_guid_,
                    ticket = self.logic.userData.ply_ticket_,
                    msg = trim(msg),
                    pn = gBaseLogic.packageName,
            };
    local url = URL.Feedback

    HTTPPostRequest(url, params, function(event)
        gBaseLogic:unblockUI();
        -- 是否持久化
        
        -- CCUserDefault:sharedUserDefault():setStringForKey("ply_guid_", userInfo.ply_guid_)
        if (event.ret==0) then
            izxMessageBox("谢谢您的意见", "意见提交成功")
        else
           izxMessageBox("意见反馈提交失败", "提交失败") 
        end
        self.view.editBox:setText("");
        self:sendFeedBackListReq() 
    end)
end

function HelpSceneCtrller:sendFeedBackListReq()
    local url = string.gsub(URL.FEEDBACKLIST,"{pid}",self.logic.userData.ply_guid_);
    url = string.gsub(url,"{packageName}",gBaseLogic.packageName);
    print("url:",url);

    gBaseLogic:HTTPGetdata(url, 0, function(event)
           self:onGetFeedBackList(event)
          end)
end

function HelpSceneCtrller:onGetFeedBackList(event)
    gBaseLogic:unblockUI();
    self.feedbacklist = event.resultList;
    self.view:onRefreshFeedBackList();
end

return HelpSceneCtrller;