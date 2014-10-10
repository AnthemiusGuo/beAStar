<?php
$op_uid = isset($_GET['op_uid'])?mysql_real_escape_string($_GET['op_uid']):0;
$op_user_base = user_get_user_base($op_uid);
if(empty($op_user_base)){
    $json_rst = array('rstno'=>-1,'error'=>'数据错误','op_uid'=>$op_uid);
    return;
}
$rst = user_del_friend($uid,$op_uid);
if($rst==0){
    $json_rst = array('rstno'=>-2,'error'=>'该用户已经是你好友');
    return;
}
$json_rst['error'] = "删除好友成功";