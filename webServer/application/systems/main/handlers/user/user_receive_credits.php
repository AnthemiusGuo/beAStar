<?php
$id = isset($_GET['id'])?(int)$_GET['id']:0;
$receive_send_credits = user_get_receive_send_credits($uid);
$flag = 0;
foreach($receive_send_credits as $key=>$send_credits_info){
    if($send_credits_info['status']==0){
        if($send_credits_info['id']==$id){
            $flag=1;
            $send_uid = $send_credits_info['send_uid'];
            $send_credits = $send_credits_info['credits'];
            $this_key = $key;
            break;
        }
    }else{
        if($send_credits_info['id']==$id){
            $json_rst = array('rstno'=>-1,'error'=>'已经领取！');
            return;
        }
    }
}
if($flag==0){
    $json_rst = array('rstno'=>-2,'error'=>'数据错误！');
    return;
}
if($send_credits<0){
    $json_rst = array('rstno'=>-3,'error'=>'数据错误！');
    return;
}
change_credits($uid,20,201,$send_credits,$send_uid);
$sql = "UPDATE u_send_money SET status=1 WHERE id=$id";
mysql_w_query($sql);
user_update_receive_send_credits($uid);

$sql = "INSERT INTO u_strongbox_log (uid,typ,credits,zeit,op_uid,status) VALUES ($uid,3,$send_credits,$zeit,$send_uid,0)";
mysql_w_query($sql);
user_update_user_strongboxlog($uid);