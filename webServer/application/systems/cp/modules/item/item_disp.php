<?php
//查询所有item
include_once FR.'config/define/define.squadposition.php';
$item_id = isset($_GET['item_id'])?(int)$_GET['item_id']:0;
$item_list = array();
$sql = "SELECT * FROM gift_package_content WHERE package_id=$item_id";
$ret = mysql_w_query($sql);
$i=0;
while($row=mysql_fetch_assoc($ret)){
	$i++;
	$item_list[$i] = $row;
	if($row['item_typ']==2)
	{
		$item_list[$i]['package_name'] = '礼券';
	}else if($row['item_typ']==1)
	{
		$item_list[$i]['package_name'] = '足球币';
	}else if($row['item_typ']==3||$row['item_typ']==4)
	{
		$item_id = $row['item_id'];
		$sql = "SELECT * FROM s_item WHERE item_id=$item_id";
		$ret1 = mysql_w_query($sql);
		$row1=mysql_fetch_assoc($ret1);
		$item_list[$i]['package_name'] = $row1['item_name'];
	}
}
?>