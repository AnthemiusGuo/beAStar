<?php
$intro_cdk = isset($_GET['intro_cdk'])?trim($_GET['intro_cdk']):'';
 
if(strlen($intro_cdk)<6){
    $json_rst = array('rstno'=>0,'error'=>'推广码错误');
    return;
}
if($g_user_base['intro_uid']!=0){
    $json_rst = array('rstno'=>-1,'error'=>'您已经是别人的推广伙伴');
    return;
}
$intro_cdk = (int)base_convert($intro_cdk,32,10);
$intro_uid = (int)($intro_cdk-100000000)/2;
if($intro_uid<=0){
    $json_rst = array('rstno'=>0,'error'=>'推广码错误');
    return;
}
if($intro_uid==$uid){
    $json_rst = array('rstno'=>-2,'error'=>'推广人不能为自己');
    return;
}
$intro_user_base = user_get_user_base($intro_uid);
if(empty($intro_user_base)){
    $json_rst = array('rstno'=>-1,'error'=>'推广人不存在');
    return;
}
$g_user_base['intro_uid'] = $change['intro_uid'] = $intro_uid;
user_write_back_main_data($uid,$g_user_base,$change);
$w = date('w');
if($w!=6){
    $date_start = date("Ymd",strtotime("next Saturday"));
}else{
    $date_start = date('Ymd');
}

$sql = "INSERT INTO u_intro_list(uid,intro_uid,zeit,c_date) VALUES ($uid,$intro_uid,$zeit,$date_start)";
mysql_w_query($sql);

//加为好友
$sql = "INSERT INTO u_buddy (uid,op_uid) VALUES ($uid,$intro_uid),($intro_uid,$uid)";
mysql_w_query($sql);
user_update_user_buddy_list($uid);
user_update_user_buddy_list($intro_uid);