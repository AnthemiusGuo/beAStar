local TouXiangGengXinLayerCtrller = class("TouXiangGengXinLayerCtrller",izx.baseCtrller)

function TouXiangGengXinLayerCtrller:ctor(pageName,moduleName,initParam)
    self.data = {

    };
    self.defaultHeadIamge = nil 
    self.selectHeadIamge = nil
	TouXiangGengXinLayerCtrller.super.ctor(self,pageName,moduleName,initParam);
	
end

function TouXiangGengXinLayerCtrller:run()
	TouXiangGengXinLayerCtrller.super.run(self);
	self:getDefaultHeadIamge(); 
	scheduler.performWithDelayGlobal(function ( )
		if self.view.enblieclick == false then 
			izxMessageBox("获取默认头像失败！", "提示") 
		end 
	end, 5)
end

function TouXiangGengXinLayerCtrller:getDefaultHeadIamge()
	--local listSrc = {'pid','token'}
	local sb = "uid="..self.logic.userData.ply_guid_ .."&key=".."969e8232b375";
	local sign = crypto.md5(sb)
	local tableRst = {uid = self.logic.userData.ply_guid_,token = sign};
	--local url = supplant(URL.GETALLHEADIMAGE,listSrc,tableRst);
	--"http://t.statics.hiigame.com/get/face/all?uid={pid}&token={token}"
	--url = "http://t.statics.hiigame.com/get/face/all?uid=100000&token=80a6bc09f9c6f63b3ce1af7e34af5add"
--{"image2":"http://iface.b0.upaiyun.com/bfe38d3a-c948-4e2e-a413-c8eae947a2ad.png!p300","image1":"http://iface.b0.upaiyun.com/a545cbea-12f0-48d8-a5cb-ad6ff74d1515.png!p300","image4":"http://iface.b0.upaiyun.com/1216af01-41bc-474a-b853-ad1672e47748.png!p300","image3":"http://iface.b0.upaiyun.com/751a150c-c4ee-4448-bbf9-5467974801e2.png!p300","image6":"http://iface.b0.upaiyun.com/df815121-e7ac-4470-9a5a-2b37d9e32c2a.png!p300","image5":"http://iface.b0.upaiyun.com/b2a6c527-dd96-476a-bc99-d8eca151d3fd.png!p300"}
	--gBaseLogic:HTTPGetdata(url,0,handler(self, self.onUpdateDefaultHeadIamge));
	HTTPPostRequest(URL.GETALLHEADIMAGE,tableRst,handler(self, self.onUpdateDefaultHeadIamge))
end

function TouXiangGengXinLayerCtrller:onUpdateDefaultHeadIamge(event)
var_dump(event)	
	if event ~= nil then 
		self.defaultHeadIamge = event
		--var_dump(self.defaultHeadIamge)
		self.view:updateDefaultHeadIamge(self.defaultHeadIamge) 
	else  
		izxMessageBox("获取默认头像失败！", "提示") 
    end
end

function TouXiangGengXinLayerCtrller:setDefaultHeadIamge(idx)
	print("setDefaultHeadIamge:"..idx)
	--local listSrc = {'type','uid','token'}
	local sb = "uid="..self.logic.userData.ply_guid_ .."&key=".."969e8232b375";
	local sign = crypto.md5(sb)
	local tableRst = {type = idx, uid = self.logic.userData.ply_guid_, token = sign};
	print("CHANGE USER HEAD!!!!!!!!!!!");
	var_dump(tableRst);
	--local url = supplant(URL.SETALLHEADIMAGE,listSrc,tableRst);

	--url = "http://t.statics.hiigame.com/get/face/url?type={type}&uid={uid}&token={token}"
--{"ret":0,"faceUrl":"http://qzapp.qlogo.cn/qzapp/100289601/C7890B2F618F44FCB2DD503FEEC0041D/100"}
	--gBaseLogic:HTTPGetdata(url,0,handler(self, self.onSetDefaultHeadIamge));
	HTTPPostRequest(URL.SETALLHEADIMAGE,tableRst,handler(self, self.onSetDefaultHeadIamge))
end

function TouXiangGengXinLayerCtrller:onSetDefaultHeadIamge(event)
	print("onSetDefaultHeadIamge")
	if event ~= nil then 
		if event.ret == 0 then 
			self.view:onPressBack() 
			self.selectHeadIamge = event.faceUrl
			local headImageRst = {
				PlatformResultCode = 0,
				msg = "更新头像成功",
				url = event.faceUrl
			};

			gBaseLogic:onHeadImageResult(headImageRst);			
		else 
			izxMessageBox("更新头像失败！", "提示") 
		end  
    end
end

return TouXiangGengXinLayerCtrller;