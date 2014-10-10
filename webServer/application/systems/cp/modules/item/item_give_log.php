<?php
//查询所有item
include_once FR.'config/define/define.squadposition.php';
$give_log_list = array();
$sql = "SELECT * FROM st_item_give_log WHERE 1 ORDER BY id DESC";
$ret = mysql_w_query($sql);
while($row=mysql_fetch_assoc($ret)){
	$give_log_list[$row['id']] = $row;
}
?>