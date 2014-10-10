<?php
include_once FR.'functions/zha/zha.func.php';
$room_id = $_GET['room_id'];
$table_id = $_GET['table_id'];
$zhuang = zha_get_zhuang($room_id,$table_id);
$json_rst['user_zhuang'] = user_get_user_show($zhuang['uid'],1);
?>