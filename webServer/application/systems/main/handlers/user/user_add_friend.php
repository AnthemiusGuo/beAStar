<?php
$op_user_id = isset($_GET['op_user_id'])?mysql_real_escape_string($_GET['op_user_id']):0;
$op_user_id = strtoupper($op_user_id);
$op_uid = user_get_uid_by_display($op_user_id);
$op_user_base = user_get_user_base($op_uid);
if(empty($op_user_base)){
    $json_rst = array('rstno'=>-1,'error'=>'输入的用户id不正确','op_uid'=>$op_uid);
    return;
}
$rst = user_add_friend($uid,$op_uid);
if($rst==0){
    $json_rst = array('rstno'=>-2,'error'=>'该用户已经是你好友');
    return;
}