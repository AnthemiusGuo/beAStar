<?php
include_once FR.'functions/user/user_info.func.php';
$cid = (int)$_GET['user_uid'];
$user_base = user_update_user_base($cid);

if($user_base['market_task_flag']==1){
    $json_rst = array('rstno'=>-1,'error'=>'该用户已经完成交叉营销任务');
    return;
} 
$sql = "UPDATE u_user SET market_flag=1,market_task_flag=1 WHERE uid=$cid"; 
mysql_w_query($sql);
$user_base = user_update_user_base($cid); 
$contractid = '100640938T2201304250001';//任务id
user_finish_market_task($cid,$user_base['pp_uid']);
$db_flag = 0;
db_connect();
global $aa_api_data;
$aa_api_data->getCrossmarketing($contractid, 0, $zone_id);   
?>