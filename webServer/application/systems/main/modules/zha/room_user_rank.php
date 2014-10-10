<?php
include_once FR.'functions/zha/zha.func.php';
$room_id = $_GET['room_id'];
$table_id = $_GET['table_id'];

$json_rst['users'] = zha_get_user_rank($room_id,$table_id);
?>