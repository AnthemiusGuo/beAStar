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
include_once FR.'functions/log/zha.log.php';
base_prepare();
db_connect();


 
$sql = "select * from robot_name";
$rst = mysql_w_query($sql);
while($row = mysql_fetch_assoc($rst)){
    $name_list[] = $row['name'];
}
shuffle($name_list);
$i = 0;
foreach($name_list as $name){
    echo '$config_robot_name['.$i.'] = "'.$name.'";<br/>';
    $i++;
}
exit;
$g_access_mode = -1;
include_once 'processes/base_init.process.php';
include_once FR.'config/server/'.$g_server_name.'.config.php';
include_once FR.'processes/lang.init.process.php';
include_once FR.'functions/common/base.func.php';
include_once FR.'functions/common/db.func.php';
base_prepare();
db_connect();
$temp_level = $now_level;
    if ($now_level<$cfg_user_level_max){ 
        for ($i=$now_level;$i<$cfg_user_level_max;$i++) {
            if ($now_exp<$cfg_user_level_exp[$i+1]){
                break;
            }
            $temp_level = $i;
        }
        if ($temp_level>$now_level){
            //升级了！
            $user_info['level'] = $temp_level;
            $changes['level'] = $temp_level;
        }
    }
    exit;
$room_id = 2;
$table_id = 102;

$sql = "UPDATE match_zha_zhuang SET uid=0";
mysql_w_query($sql);
$json_rst['robotszhuang'] = array();
for ($i=0;$i<20;$i++){
	$robot_uid = robot_get_a_robot($room_id);
    $user_info = user_get_user_base($robot_uid);
    if(empty($user_info)){
        continue;
    }
	if($i<=9&&$room_id!=1){        
        if($room_id==2){
            if($user_info['credits']>800000000||$user_info['credits']<30000000){
                $user_info['credits'] =  mt_rand(30000000,800000000);
            }
        }else if($room_id==3){
            if($user_info['credits']>300000000||$user_info['credits']<100000000){
                $user_info['credits'] =  mt_rand(100000000,300000000);
            }
        }
        
		$change['credits'] = $user_info['credits'];
		user_write_back_main_data($robot_uid,$user_info,$change);
        $robot = user_get_user_for_sock($robot_uid);
        $json_rst['robotszhuang'][] = $robot;
    }else{
        if($room_id==1){
            $user_info['credits'] = mt_rand(3000,15000);
        }else if($room_id==2){
            $user_info['credits'] = 1000000 + mt_rand(1,4000000);
        }else if($room_id==3){
            if($user_info['credits']<100000000){
                $user_info['credits'] =  mt_rand(10000000,50000000);
            }
        }
		$change['credits'] = $user_info['credits'];
		user_write_back_main_data($robot_uid,$user_info,$change);
        $robot = user_get_user_for_sock($robot_uid);
    }
    
	if ($i==0&&$room_id!=1){
		$zhuang = zha_init_zhuang_robot($room_id,$table_id,$robot);
		$json_rst['zhuang'] = user_get_user_for_sock($zhuang['uid']);
		$robot['is_zhuang'] = 1;
	} else {
		$robot['is_zhuang'] = 0;
	}
	$json_rst['robots'][] = $robot;
}
if($room_id==1){
    $json_rst['zhuang'] = array('credits'=>10000000,'is_robot'=>-1,
		                        'level'=>100,'vip_level'=>10,
		                        'pp_uid'=>1,'uname'=>'系统','uid'=>-1,'uuid'=>'',
		                        'avatar_id'=>0,'avatar_url'=>'');
}
	
$json_rst['room_info'] = gb_get_room_info($room_id);
var_dump($json_rst);

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
    