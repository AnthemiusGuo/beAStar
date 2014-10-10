<?php
include_once FR.'functions/zha/zha.func.php';
include_once FR.'functions/log/zha.log.php';
if ( !isset($_GET['room_id'])|| !isset($_GET['table_id'])){
    $json_rst['rst_no'] = -1;
    return;
}
$room_id = $_GET['room_id'];
$table_id = $_GET['table_id'];
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
	$json_rst['robots'][$robot_uid] = $robot;
}
if($room_id==1){
    $json_rst['zhuang'] = array('credits'=>10000000,'is_robot'=>-1,
		                        'level'=>100,'vip_level'=>10,
		                        'pp_uid'=>1,'uname'=>'系统','uid'=>-1,'uuid'=>'',
		                        'avatar_id'=>0,'avatar_url'=>'');
}
	
$json_rst['room_info'] = gb_get_room_info($room_id);

?>