<?php
include_once FR.'functions/zha/zha.func.php';

$room_id = (int)$_GET['room_id'];

$room_list = gb_get_room_list();

if (!isset($room_list[$room_id])){
    $json_rst['rstno'] = -2;
    return;
}
$json_rst['room_info'] = $room_list[$room_id];
$json_rst['table_info'] = zha_enter_room_choose_table($room_id);
?>