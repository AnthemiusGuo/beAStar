<?php
include_once FR.'functions/zha/zha.func.php';
include_once FR.'functions/log/zha.log.php';
if (!isset($_GET['user_list']) || !isset($_GET['room_id'])|| !isset($_GET['table_id'])){
    $json_rst['rst_no'] = -1;
    return;
}
$room_id = $_GET['room_id'];
$table_id = $_GET['table_id'];
$user_list = explode(',',$_GET['user_list']);

if (count($user_list)<10){
    //TODO 补充robot
}

zha_update_user_list($room_id,$table_id,$user_list);
//TODO 把补充的robot告诉perl

?>