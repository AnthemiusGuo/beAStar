<?php
include_once FR.'functions/zha/zha.func.php';
include_once FR.'functions/log/zha.log.php';
if (!isset($_GET['next_zhuang_uid']) || !isset($_GET['room_id'])|| !isset($_GET['table_id'])){
    $json_rst['rstno'] = -1;
    return;
}
$next_zhuang_uid = (int)$_GET['next_zhuang_uid'];
$next_zhuang_typ = (int)$_GET['next_zhuang_typ'];
$room_id = (int)$_GET['room_id'];
$table_id = (int)$_GET['table_id'];

//err_log(json_encode($_GET));

if ($next_zhuang_uid==0){
	$json_rst['rstno'] = -1;
    return;
}

$user_info  = user_get_user_base($next_zhuang_uid);
#再次校验钱是不是够
//if ($user_info['credits']<50000000*4 && $next_zhuang_typ==0){
//    $user_info['credits'] = 50000000*3 + rand(0,100000000);
//    $change['credits'] = $user_info['credits'];
//    user_write_back_main_data($next_zhuang_uid,$user_info,$change);
//}
if ($user_info['credits']<$room_list[$room_id]['room_zhuang_limit_low']){
    $json_rst['rstno']=-2;
    $json_rst['credits']=$user_info['credits'];
    $json_rst['room_id']=$room_id;
    $json_rst['room_zhuang_limit_low']=$room_list[$room_id]['room_zhuang_limit_low'];
    return;
}
$is_robot = $user_info['is_robot'];
$zhuang = zha_init_new_zhuang($room_id,$table_id,$is_robot,$next_zhuang_uid);
$json_rst['zhuang'] = user_get_user_for_sock($zhuang['uid']);
?>