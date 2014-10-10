<?php
include_once FR."functions/user/reg.func.php"; 
include_once FR."config/define/define.wordslength.php";
include_once FR."config/define/define.reg.php";
include_once FR.'functions/user/user_session.func.php';

$json_rst = array('rstno'=>1,'error'=>'error','url'=>'');

if ($config_open_reg==0){
    $json_rst['rstno'] = -1;
    $json_rst['error'] = _('本服务器已经关闭注册');
    return;
}
$uuid = isset($_GET['uuid'])?mysql_real_escape_string(trim($_GET['uuid'])):'';
$login_name = !empty($_GET['login_name']) ? mysql_real_escape_string(trim($_GET['login_name'])) : ('');
$uname = !empty($_GET['uname']) ? mysql_real_escape_string(trim($_GET['uname'])) : ('');
$login_pwd = !empty($_GET['login_pwd']) ? mysql_real_escape_string(trim(strtolower($_GET['login_pwd']))) : ('');
$remember_pwd = !empty($_GET['remember_pwd']) ? mysql_real_escape_string(trim($_GET['remember_pwd'])) : ('');
$is_remember_login = !empty($_GET['is_remember_login']) ? (int)$_GET['is_remember_login'] :0;

$sql = "SELECT uid,login_pwd,is_anonym FROM u_account WHERE login_name='$login_name'";
$rst = mysql_w_query($sql);
if($row = mysql_fetch_assoc($rst)){
    $u_account = $row;
    
}else{
    $json_rst['rstno'] = -2;
    $json_rst['error'] = _('用户名不存在');
    return;
}
 
 if($is_remember_login==0&&md5($login_pwd)!=$u_account['login_pwd']){
    $json_rst['rstno'] = -3;
    $json_rst['error'] = _('密码错误');
    return;
 }
if($is_remember_login==1 && $remember_pwd!=substr($u_account['login_pwd'],3,6)){
    $json_rst['rstno'] = -3;
    $json_rst['error'] = _('密码错误');
    return;
}
$uid = $u_account['uid'];
$sid = user_login($uid,$uuid);
//设备记录
user_insert_into_device($uuid,$uid);
$json_rst['login_info'] = array('uid'=>$u_account['uid'],
                                'is_anonym'=>$u_account['is_anonym'],
                                'sid'=>$sid);
$json_rst['user_info'] = user_get_user_show($uid);
$user_extend = user_get_user_extend($uid);
$json_rst['on_keeps'] = $user_extend['online_keeps'];
$json_rst['day_awards'] = $cfg_user_online_keeps_award;
$json_rst['day_vip_awards'] = $cfg_user_online_keeps_award_vip;
?>
