<?php
$item_id = isset($_POST['item_id'])?(int)$_POST['item_id']:0;
$num = isset($_POST['num'])?$_POST['num']:'';
$validity = isset($_POST['validity'])?$_POST['validity']:'';
$calendar = isset($_POST['calendar'])?$_POST['calendar']:'';
if($item_id>0)
{
	$gift_item_id = 0;
	for($i=0;$i<$num;$i++)
	{
		$time = time();
		$mdtime = $gift_item_id.$time;
		$mdtime = md5($mdtime);
		$verify_num = strtoupper(substr($mdtime,0,8));
		if($validity==0)
		{
			$sql_item_new_insert_str = "('$item_id', '$verify_num', '$time', '0')";
		}else{
			$time =strtotime($calendar);
			$sql_item_new_insert_str = "('$item_id', '$verify_num', '$time', '1')";
		}
		$sql = "SELECT * FROM gift_voucher WHERE verify_num='$verify_num'";
		$ret = mysql_w_query($sql);
		if($row=mysql_fetch_assoc($ret)){
			continue;
		}
		$sql = "INSERT INTO `gift_voucher` (`package_id`, `verify_num`, `zeit`, `voucher_typ`) VALUES $sql_item_new_insert_str";
		mysql_w_query($sql);
		$gift_item_id = mysql_insert_id();
	}
}
?>