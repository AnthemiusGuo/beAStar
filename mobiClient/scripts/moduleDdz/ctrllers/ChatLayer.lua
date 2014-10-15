local ChatLayerCtrller = class("ChatLayerCtrller",izx.baseCtrller)

function ChatLayerCtrller:ctor(pageName,moduleName,initParam)
    self.data = {
--     enum ITEM_INDEX{
--     ITEM_TRUMPET            = 1,    //小喇叭
--     ITEM_CARD_RECORD        = 2,    //记牌器
--     ITEM_MATCH_TICKET       = 3,    //比赛卷
--     ITEM_KICK_OUT           = 4,    //踢人道具
--     ITEM_EXPRESSION_PARCEL  = 5,    //招财猫表情包
--     ITEM_RED_WINE           = 6,    //红酒
--     ITEM_EGG                = 8,    //鸡蛋
--     ITEM_FLOWER             = 9,    //鲜花
--     ITEM_LABA_COIN          = 50,//拉霸币

-- };
    };
    for k,v in pairs(gBaseLogic.lobbyLogic.userData.ply_items_) do
        if v.index_== gBaseLogic.gameLogic.ITEM_EXPRESSION_PARCEL  then
        	self.catNum = v.num_
        end 
        if v.index_== gBaseLogic.gameLogic.ITEM_TRUMPET  then
            self.trumpetNum = v.num_
        end 
    end
	self.super.ctor(self,pageName,moduleName,initParam);
end

function ChatLayerCtrller:onEnter()
    -- body
end
function ChatLayerCtrller:getPayCatNum()
    -- for k,v in pairs(gBaseLogic.lobbyLogic.userData.ply_items_) do
    --     if v.index_== gBaseLogic.gameLogic.ITEM_EXPRESSION_PARCEL  then
    --     	print("pay cat num:"..v.num_)
    --     end
    -- end
    print("current pay cat num:"..self.catNum)
    return self.catNum
end

function ChatLayerCtrller:setPayCatNum(num)
    -- for k,v in pairs(gBaseLogic.lobbyLogic.userData.ply_items_) do
    --     if v.index_== gBaseLogic.gameLogic.ITEM_EXPRESSION_PARCEL  then
    --     	v.num_ = num
    --     end
    -- end
    self.catNum = num
    print("set current pay cat num:"..num)
end

function ChatLayerCtrller:getTrumpetNum()
    -- for k,v in pairs(gBaseLogic.lobbyLogic.userData.ply_items_) do
    --     if v.index_== gBaseLogic.gameLogic.ITEM_EXPRESSION_PARCEL  then
    --      print("pay cat num:"..v.num_)
    --     end
    -- end
    print("current trumpet Num:"..self.trumpetNum)
    return self.trumpetNum
end

function ChatLayerCtrller:setTrumpetNum(num)
    -- for k,v in pairs(gBaseLogic.lobbyLogic.userData.ply_items_) do
    --     if v.index_== gBaseLogic.gameLogic.ITEM_EXPRESSION_PARCEL  then
    --      v.num_ = num
    --     end
    -- end
    self.trumpetNum = num
    print("set current trumpet Num:"..num)
end

function ChatLayerCtrller:run()
	ChatLayerCtrller.super.run(self);
end

function ChatLayerCtrller:onMsgData(event)
	
end

return ChatLayerCtrller;