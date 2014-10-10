<?php
$op_uid = isset($_GET['op_uid'])?(int)$_GET['op_uid']:0;
$op_user_id = isset($_GET['op_show_id'])?mysql_real_escape_string($_GET['op_show_id']):0;
$op_user_id = strtoupper($op_user_id);
$credits = isset($_GET['credits'])?(int)$_GET['credits']:0;
$pwd = isset($_GET['pwd'])?(int)$_GET['pwd']:0;
if($op_uid==0){ 
    $op_uid = user_get_uid_by_display($op_user_id);
}
//$op_uid = $op_user_id;
if($op_uid==$uid){
    $json_rst = array('rstno'=>0,'error'=>'不能给自己赠送');
    return;
}
$op_user_base = user_get_user_base($op_uid);
if(empty($op_user_base)){
    $json_rst = array('rstno'=>-1,'error'=>'赠送的用户不存在');
    return;
}
$pwd = isset($_GET['pwd'])?trim(mysql_real_escape_string($_GET['pwd'])):'';
if(substr(md5($pwd),0,16)!=$g_user_base['password_box']){
    $json_rst = array('rstno'=>-2,'error'=>'保险箱密码错误');
    return;
}
if($credits<=0){
    $json_rst = array('rstno'=>-3,'error'=>'赠送的游戏币数量不能小于0');
    return;
}
$r_credits = 0-$credits;
$rest_credit = change_credits($uid,21,202,$r_credits,$op_uid);
if($rest_credit<0){
    $json_rst = array('rstno'=>-6,'error'=>'钱不够');
    return;
}
$sql = "INSERT INTO u_send_money (send_uid,uid,credits,status,zeit) VALUES ($uid,$op_uid,$credits,0,$zeit)";
mysql_w_query($sql);
user_update_receive_send_credits($op_uid);
$sql = "INSERT INTO u_strongbox_log (uid,typ,credits,zeit,op_uid,status) VALUES ($uid,2,$credits,$zeit,$op_uid,0)";
mysql_w_query($sql);
user_update_user_strongboxlog($uid);
$show_zeit = date('Ymd h:i:s',$zeit); 
$json_rst['msg']['log_msg'] = $show_zeit.' 你赠送'.$credits.'金币给'.$op_user_base['uname'];