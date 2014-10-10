<?php
include_once FR.'functions/zha/zha.func.php';
$room_id = $_GET['room_id'];
$table_id = $_GET['table_id'];

$uid = $_GET['uid'];
$json_rst['uid'] = $uid;
$user_info  = user_get_user_base($uid);
if ($user_info['credits']<$room_list[$room_id]['room_zhuang_limit_low']){
	$json_rst['rstno']=-2;    
    $json_rst['error'] = "您的游戏币不足".common_get_zipd_number($room_list[$room_id]['room_zhuang_limit_low'])."，不可以申请上庄";
    //this.client.send({event:global.EVENT_CODE.ZHA_ASK_ZHUANG,
//						'rstno':-2,
//						'error':'您的游戏币不足5000万，不可以申请上庄'});
//        return;
	return;	
}
$zhuang = zha_get_zhuang($room_id,$table_id);
if ($zhuang['uid']==$uid){
	$json_rst['rstno']=-3;
    $json_rst['error'] = "你是庄家，不可申请";
	return;
}
$json_rst['rstno']=1;


?>