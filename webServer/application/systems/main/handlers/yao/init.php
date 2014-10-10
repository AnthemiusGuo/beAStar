<?php
include_once FR.'functions/yao/yao.func.php';
include_once FR.'functions/log/yao.log.php';
if ( !isset($_GET['room_id'])|| !isset($_GET['table_id'])){
    $json_rst['rst_no'] = -1;
    return;
}
$room_id = $_GET['room_id'];
$table_id = $_GET['table_id'];
#通知php该游戏上线
for ($i=0;$i<10;$i++){
	$robot_uid = robot_get_a_robot();
	$robot = user_get_user_for_sock($robot_uid);
	$json_rst['robots'][] = $robot;
}
$json_rst['room_info'] = gb_get_room_info($room_id);

?>