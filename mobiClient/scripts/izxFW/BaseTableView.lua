local BaseTableViewLayer = class("BaseTableViewLayer")
BaseTableViewLayer.__index = BaseTableViewLayer

function BaseTableViewLayer.extend(target)
    local t = tolua.getpeer(target)
    if not t then
        t = {}
        tolua.setpeer(target, t)
    end
    setmetatable(t, BaseTableViewLayer)
    return target
end

-- function BaseTableViewLayer.numberOfCellsInTableView(table)
--     -- var_dump(table.data);
--     local data = table:getParent().data;
--     return #data
-- end

function BaseTableViewLayer.create(target,node)
    target = BaseTableViewLayer.extend(node)
end

function BaseTableViewLayer.initdata(target,size,type,data, tabview)
	target:removeAllChildrenWithCleanup(true);
    target.type = type;
    target.data = data;
    
    local tableView = CCTableView:create(size)
    tableView:setDirection(kCCScrollViewDirectionVertical)
    tableView:setAnchorPoint(ccp(0.5,0.5))
    tableView:setPosition(ccp(0, 0))
    tableView:setVerticalFillOrder(kCCTableViewFillTopDown)
    --tableView:setClippingToBounds(true);
    --tableView:setBounceable(false);
    target:addChild(tableView)
    --tableView:registerScriptHandler(TableViewLayer.scrollViewDidScroll,CCTableView.kTableViewScroll)
    --tableView:registerScriptHandler(TableViewLayer.scrollViewDidZoom,CCTableView.kTableViewZoom)
    --tableView:registerScriptHandler(TableViewLayer.tableCellTouched,CCTableView.kTableCellTouched)
    tableView:registerScriptHandler(tabview.cellSizeForTable,CCTableView.kTableCellSizeForIndex)
    tableView:registerScriptHandler(tabview.tableCellAtIndex,CCTableView.kTableCellSizeAtIndex)
    tableView:registerScriptHandler(tabview.numberOfCellsInTableView,CCTableView.kNumberOfCellsInTableView)
    if (tabview.onTableViewScroll) then
        tableView:registerScriptHandler(tabview.onTableViewScroll,CCTableView.kTableViewScroll)
    end
    tableView:reloadData()
end

return BaseTableViewLayer;