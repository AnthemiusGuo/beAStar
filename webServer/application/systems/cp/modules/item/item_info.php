<?php
//查询所有item
include_once FR.'config/define/define.squadposition.php';
$item_id = isset($_GET['item_id'])?(int)$_GET['item_id']:0;
$item_list = array();
$sql = "SELECT * FROM s_item WHERE item_typ IN (1,2)";
$ret = mysql_w_query($sql);
while($row=mysql_fetch_assoc($ret)){
	$item_list[$row['item_id']] = $row;
}
?>