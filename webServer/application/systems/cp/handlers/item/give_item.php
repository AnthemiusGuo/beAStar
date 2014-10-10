<?php
include_once FR.'functions/item/item.func.php';
include_once FR.'functions/club/club.func.php';

$item_id = isset($_POST['item_id'])?(int)$_POST['item_id']:0;
$title = isset($_POST['title'])?mysql_real_escape_string($_POST['title']):'';
$cid = isset($_POST['cid'])?$_POST['cid']:'';
$gift_typ = isset($_POST['gift_typ'])?$_POST['gift_typ']:'';
$item_num = isset($_POST['item_num'])?$_POST['item_num']:'';
if(!$item_id)
{
	if(!empty($gift_typ))
	{
		foreach ($gift_typ as $key=>$val)
		{
			if($val==-1)
			{
				club_add_money($cid,8,$item_num[$key],1);
			}else if($val==-2)
			{
				club_add_money($cid,8,$item_num[$key],2);
			}else{
				$item_id = $val;
				$sql = "SELECT * FROM s_item WHERE item_id=$val";
				$ret = mysql_w_query($sql);
				if($row=mysql_fetch_assoc($ret)){
					if($row['item_typ']==1)
					{
						item_user_get_shop_item($cid,$item_id,1,$item_num[$key],6);
					}else if($row['item_typ']==2)
					{
						for($i=1;$i<=$item_num[$key];$i++)
						{
							item_user_get_shop_item($cid,$item_id,2,1,6);
						}
					}else if($row['item_typ']==3)
					{
						for($i=1;$i<=$item_num[$key];$i++)
						{
							item_user_get_shop_item($cid,$item_id,3,1,6);
						}
					}
				}
			}
		}
	}
	club_get_club_info($cid);
}
$gi = array();
$gi['gift_typ'] = $gift_typ;
$gi['item_num'] = $item_num;
$give_item = mysql_real_escape_string(json_encode($gi));
$time = time();
$sql = "INSERT INTO  `st_item_give_log` (`give_title` ,`give_cid` ,`give_item` ,`zeit`) VALUES ('$title', '$cid', '$give_item', '$time')";
mysql_w_query($sql);
?>