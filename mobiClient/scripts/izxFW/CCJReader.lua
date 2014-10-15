--
-- Author: Guo Jia
-- Date: 2014-01-22 14:37:22
--
local CCJReader = class("CCJReader")

function CCJReader:ctor(ccjFileName)
    self.jsonFile = json.decode(CCString:createWithContentsOfFile(ccjFileName):getCString());
end

function CCJReader:read()
	self.jsonNodeList = self.jsonFile.nodeList;
end
