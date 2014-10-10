<?php
include_once FR."functions/user/reg.func.php"; 
 
include_once FR."config/define/define.reg.php";
include_once FR.'functions/user/user_info.func.php';

$json_rst = array('rstno'=>1,'error'=>'error','url'=>'');
$uuid = !empty($_GET['uuid']) ? trim(mysql_real_escape_string($_GET['uuid'])) : ('');
$login_name = !empty($_GET['login_name']) ? trim(mysql_real_escape_string($_GET['login_name'])) : ('');
$login_pwd = !empty($_GET['login_pwd']) ? trim(mysql_real_escape_string(strtolower($_GET['login_pwd']))) : ('');
$uname = !empty($_GET['uname']) ? trim(mysql_real_escape_string($_GET['uname'])) : ('');
//验证数据
//$login_name,$login_pwd格式验证
$zeit = time();
if(mb_strlen($login_pwd,'UTF-8')<6){
	$json_rst = array('rstno'=>-1,'error'=>'密码不能少了6位');
	return;
}
if(mb_strlen($uname,'UTF-8')>16){
	$json_rst = array('rstno'=>-2,'error'=>'昵称超长最多保留16位');
	return;
}
if($uname==$login_name){
	$json_rst = array('rstno'=>-3,'error'=>'登录名和注册名不能相同');
	return;
}
if(isexist_uname($uname)){
	$json_rst = array('rstno'=>-5,'error'=>'昵称重复');
	return;	
}
if(isexist_login_name($login_name)){
	$json_rst = array('rstno'=>-6,'error'=>'用户名已存在，您是否已经注册过？');
	return;
}
//$u_account = user_get_user_account_by_uuid($uuid);
$login_pwd = md5($login_pwd);
//if(!empty($u_account)){
//	//已经匿名注册过的用户
//	$uid = $u_account['uid'];
//	$user_base = user_get_user_base($uid);
//	$change_user_base = array();
//	$change_user_base['login_name'] = $user_base['login_name'] = $login_name;
//	$change_user_base['login_pwd'] = $user_base['login_pwd'] = $login_pwd;
//	$change_user_base['uname'] = $user_base['uname'] = $uname;
//	$change_user_base['is_anonym'] = $user_base['is_anonym'] = 0;
//	user_write_back_main_data($uid,$user_base,$change_user_base);
//}else{
	$u_account = user_reg_new_user($uuid,$uname,$login_name,$login_pwd);
	$uid = $u_account['uid'];
//}
user_insert_into_device($uuid,$uid);

 
if ($config_open_reg==0){
    $json_rst['rstno'] = -8;
    $json_rst['error'] = _('本服务器已经关闭注册');
    return;
} 
 
$ts = time();

$sid = gen_session_id($uid,$zeit,$public_key);
$online_zeit = $zeit;

$online_id = gen_online_id($uid,$sid,$online_zeit,$uuid);
set_cookie($uid, $sid, $uid,$uuid,$online_id); 
init_user_session_and_cache($uid,$sid);	 
$url  = './';
$json_rst['url'] = $url;
$json_rst['login_info'] = array('uid'=>$u_account['uid'],
								'is_anonym'=>1,
                                'sid'=>$sid);
$json_rst['user_info'] = user_get_user_show($uid);
$json_rst['on_keeps'] = $user_extend['online_keeps'];
$json_rst['day_awards'] = $cfg_user_online_keeps_award;
$json_rst['day_vip_awards'] = $cfg_user_online_keeps_award_vip;
 
?>
