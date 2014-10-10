<?php
include_once FR.'functions/item/item.func.php';
$item_id = isset($_POST['item_id'])?(int)$_POST['item_id']:0;
$item_name = isset($_POST['item_name'])?$_POST['item_name']:'';
$gift_typ = isset($_POST['gift_typ'])?$_POST['gift_typ']:'';
$item_num = isset($_POST['item_num'])?$_POST['item_num']:'';
if(!$item_id)
{
	$sql_item_new_insert_str = "('$item_name')";
	$sql = "INSERT INTO `gift_package` (`package_name`) VALUES $sql_item_new_insert_str";
	mysql_w_query($sql);
	$gift_item_id = mysql_insert_id();
	if(!empty($gift_typ))
	{
		foreach ($gift_typ as $key=>$val)
		{
			if($val==-1)
			{
				$gift_typ_item = 1;
				$item_id = 0;
			}else if($val==-2)
			{
				$gift_typ_item = 2;
				$item_id = 0;
			}else{
				$item_id = $val;
				$sql = "SELECT * FROM s_item WHERE item_id=$val";
				$ret = mysql_w_query($sql);
				if($row=mysql_fetch_assoc($ret)){
					if($row['item_typ']==1)
					{
						$gift_typ_item = 3;
					}else if($row['item_typ']==2)
					{
						$gift_typ_item = 4;
					}
				}
			}
			$item_num_gift = $item_num[$key];
			$sql_item_new_insert_str = "('$gift_item_id', '$item_id', '$gift_typ_item', '$item_num_gift')";
			$sql = "INSERT INTO gift_package_content (package_id, item_id , item_typ, item_count) VALUES $sql_item_new_insert_str";
			mysql_w_query($sql);
		}
	}
}
_update_all_item_list();
_update_all_gift_item_list();
?>