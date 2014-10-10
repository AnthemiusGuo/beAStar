<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
</head>
<body>
<?php
 
$g_access_mode = -1;
include_once 'processes/base_init.process.php';
include_once FR.'config/server/'.$g_server_name.'.config.php';
include_once FR.'processes/lang.init.process.php';
include_once FR.'functions/common/base.func.php';
include_once FR.'functions/common/db.func.php';
include_once FR.'functions/user/user_info.func.php';
include_once FR.'functions/zha/zha.func.php';
include_once FR.'config/define/define.name.php';
include_once FR.'config/define/user.define.php';
//include_once FR.'functions/log/zha.log.php';
base_prepare();
db_connect();
$zeit = time();
//1627
$config_num = array(1=>700,2=>600,3=>327);
$sql_insert = array();
$sql = "DELETE FROM u_account WHERE is_robot=1";
mysql_w_query($sql);
$sql_insert = array();
//$max_key = $config_num[1]+$config_num[2]+$config_num[3];
//$uname_key_array = array_rand($config_robot_name,$max_key);

$key = 0;
for ($room_id=1;$room_id<=3;$room_id++){
    for($i=1;$i<=$config_num[$room_id];$i++){
		if(!isset($config_robot_name[$key])){
			continue;
		}
        $uname = $config_robot_name[$key];		
        $key++;

        if($room_id==1){
            $level = rand(1,7);
        }else if ($room_id==2){
            $level = rand(5,15);
        }else if($room_id==3){
            $level = rand(8,20);
        }
        $need_exp = $cfg_user_level_exp[$level+1] - $cfg_user_level_exp[$level];
        $exp = $cfg_user_level_exp[$level]+rand(1,$need_exp);
        $credits = 2000+$room_id*2000;
        $uuid = "robot_".$room_id;
        $avatar_id = rand(1,15);//meiMima*1024
        
        $sql_insert[] = "('$uuid', 0, $zeit,'$uname',$level,$exp,$credits,$credits,1,$avatar_id)";
        
    }
}
if(!empty($sql_insert)){
    $sql_insert_str = implode(',',$sql_insert);
    $sql = "INSERT INTO u_account
	(`uuid` ,`is_anonym` ,`reg_zeit`, uname,level,exp,credits,total_credits,is_robot,avatar_id)
	VALUES $sql_insert_str";
    mysql_w_query($sql);
}
robot_update_list(1);
robot_update_list(2);
robot_update_list(3);
echo "true";
 
?>
</body>
</html>
    