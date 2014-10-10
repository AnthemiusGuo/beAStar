<?php
include_once FR.'functions/club/club.func.php';
$user_uid = mysql_real_escape_string($_GET['user_uid']);
$typ = (int)$_GET['typ'];
$special_content = mysql_real_escape_string(trim($_GET['special_content']));
$msg_content = mysql_real_escape_string($_GET['msg_content']);
$uid_list = explode(",", $user_uid);
foreach ($uid_list as $cid){
    //发送消息
    $msg_info = array('uid'=>$cid,'typ'=>$typ,'special_content'=>$special_content,'msg_content'=>$msg_content);
    msg_sends($cid,$msg_info); 
}
?>