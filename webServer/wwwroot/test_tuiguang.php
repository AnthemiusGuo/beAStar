<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
</head>
<body>
<?php
/*
*  
*/
//$playerLevelFile = "cdk4399.txt";
//$file = fopen($playerLevelFile,"w+");
//$all_str = '';
//for($key_id=1;$key_id<=50000;$key_id++){
//	$this_key = str_pad($key_id, 6, '0', STR_PAD_LEFT);
//	$str = $this_key.'-ZQ-'.strtoupper(substr(md5('ZQ'.$key_id.'xiaohui'),0,5));
//	$str = base64_encode($str);
//	$all_str .= $str."\n";
//    
//}
//fwrite($file,$all_str);

 
$g_access_mode = -1;
include_once 'processes/base_init.process.php';
include_once FR.'config/server/'.$g_server_name.'.config.php';
include_once FR.'processes/lang.init.process.php';
include_once FR.'functions/common/base.func.php';
include_once FR.'functions/common/db.func.php';
base_prepare();
db_connect();
$uid = isset($_GET['uid'])?(int)$_GET['uid']:0;
if($uid<=0){
	echo "uid false";
	exit;
}
$sql = "SELECT uid from u_account where level>5";
$rst = mysql_w_query($sql);

while($row = mysql_fetch_assoc($rst)){
	$uidarray[$row['uid']] = $row['uid'];
}
$uids = array_rand($uidarray,5);
//	$cost = mt_rand(10,100000);
//	$sql1 = "INSERT INTO  u_win_log (`date`, `uid`, `credits`) VALUES($date, $uid, $cost)
//		ON DUPLICATE KEY UPDATE credits=credits+$cost";
//		mysql_w_query($sql1);
//}
//rank_update_winners_rank($date);
$date_w = date('w');
$cur_date = date('Ymd');
if($date_w==6){
    $date_start = date("Ymd",$zeit-7*86400);     
}else if($date_w==0){
    $date_start = date("Ymd",strtotime("last Saturday")-7*86400);    
}else{
    $date_start = date("Ymd",strtotime("last Saturday"));
}
 

foreach($uids as $this_uid){
	$exp = mt_rand(50,5000);
	$end_exp = mt_rand($exp+10,80000000);
	$add_exp_all = $end_exp-$exp;
	$sql = "INSERT INTO u_lucky_chest(uid,date_start,add_exp_all,end_exp,status) VALUES
			($this_uid,$date_start,$add_exp_all,$end_exp,0)
			ON DUPLICATE KEY UPDATE add_exp_all=$add_exp_all,end_exp=$end_exp,status=0";
	mysql_w_query($sql);
	if($uid!=$this_uid){
		$sql1 = "INSERT INTO u_intro_list(intro_uid,uid) VALUES ($uid,$this_uid)";
		mysql_w_query($sql1);
	}
	$temp_level = 1;
	for ($i=1;$i<$cfg_user_level_max;$i++) {
		if ($end_exp<$cfg_user_level_exp[$i+1]){
			break;
		}
		$temp_level = $i;
	}
	$sql = "update u_account set level=$temp_level where uid=$this_uid";
	mysql_w_query($sql);
	user_update_user_base($this_uid);
}

echo "true";
//if (isset($_COOKIE[$zone_id.'SAL'])) {
//	//取cookie
//	//cookie解密
//	$uid = 0;
//	$sid = 0;
//	$cid = 0;
//	$uuid = 0;
//    set_cookie(0, 0, 0,0);
//}
 
//echo "true";
?>
</body>
</html>
    