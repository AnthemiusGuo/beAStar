<?php
$id = isset($_GET['id'])?(int)$_GET['id']:0;
$sql = "SELECT * FROM u_strongbox_log WHERE id=$id";
$rst = mysql_w_query($sql);
if($row = mysql_fetch_assoc($rst)){
    $strongbox_log = $row;
    if($strongbox_log['uid']!=$uid){
        $json_rst = array('rstno'=>0,'error'=>'data error');
        return;
    }
    if($strongbox_log['typ']!=3){
        $json_rst = array('rstno'=>0,'error'=>'data error');
        return;
    }
    if($strongbox_log['status']!=0){
        $json_rst = array('rstno'=>-2,'error'=>'已接收');
        return;
    }
    $credits = $strongbox_log['credits'];
    $op_uid = $strongbox_log['op_uid'];
}else{
    $json_rst = array('rstno'=>-1,'error'=>'data error');
    return;
}

$sql = "UPDATE u_strongbox_log SET status=1 WHERE id=$id";
mysql_w_query($sql);
user_update_user_strongboxlog($uid);
$rest_credit = change_credits($uid,20,201,$credits,$op_uid);
$json_rst = array('rstno'=>1,'error'=>'ok','user_refresh'=>1,'credits'=>$rest_credit);
    