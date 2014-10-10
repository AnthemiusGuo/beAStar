<?php
//查询所有item
include_once FR.'config/define/define.squadposition.php';
$item_id = isset($_GET['item_id'])?(int)$_GET['item_id']:0;
$gift_voucher_list = array();
if($item_id==0)
{
	$sql = "SELECT * FROM gift_voucher WHERE 1 ORDER BY voucher_id DESC";
}else{
	$sql = "SELECT * FROM gift_voucher WHERE package_id=$item_id ORDER BY voucher_id DESC";
}
$ret = mysql_w_query($sql);
while($row=mysql_fetch_assoc($ret)){
	$gift_voucher_list[$row['voucher_id']] = $row;
}
$item_list = array();
$sql = "SELECT * FROM gift_package ORDER BY package_id";
$ret = mysql_w_query($sql);
while($row=mysql_fetch_assoc($ret)){
    $item_list[$row['package_id']]=$row;
}
?>