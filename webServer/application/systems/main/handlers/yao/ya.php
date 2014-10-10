<?php
include_once FR.'functions/yao/yao.func.php';
include_once FR.'functions/log/yao.log.php';
if (!isset($_GET['match_id']) || !isset($_GET['room_id']) || !isset($_GET['table_id'])){
    $json_rst['rstno'] = -1;
    return;
}
if (!isset($_GET['uid']) || !isset($_GET['point']) || !isset($_GET['men'])){
    $json_rst['rstno'] = -2;
    return;
}

$match_id = $_GET['match_id'];
$room_id = $_GET['room_id'];
$table_id = $_GET['table_id'];
$uid = $_GET['uid'];
$point = $_GET['point'];
$men = $_GET['men'];

//TODO根据room_id做各种判断

//校验玩家钱够不够
$pre_cost = $point;
$user_base = user_get_user_base($uid);
if ($user_base==false){
    #报错处理TODO
    
}
if ($pre_cost+$user_base['credits_locked']>$user_base['credits']){
    #报错处理TODO
    $json_rst['rstno'] = -201;
    return;
}
//预扣玩家的钱X倍锁定
$user_base['credits_locked']+=$pre_cost;
user_write_back_main_data($uid,$user_base);

//日志流水
yao_log_bet($room_id,$table_id,$match_id,$uid,$men,$point);
//押注信息写入数据库
yao_set_bet($room_id,$table_id,$match_id,$uid,$men,$point);


?>