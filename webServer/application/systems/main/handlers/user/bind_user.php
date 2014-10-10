<?
include_once FR."functions/user/reg.func.php"; 
include_once FR."config/define/define.wordslength.php";
include_once FR.'functions/user/user_session.func.php';
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
if(mb_strlen($login_pwd,'UTF-8')>16){
	$json_rst = array('rstno'=>-1,'error'=>'密码超长最多保留16位');
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
$user_base = user_get_user_base($uid);
$change_user_base = array();
$login_pwd = md5($login_pwd);
$change_user_base['login_name'] = $user_base['login_name'] = $login_name;
$change_user_base['login_pwd'] = $user_base['login_pwd'] = $login_pwd;
$change_user_base['uname'] = $user_base['uname'] = $uname;
$change_user_base['is_anonym'] = $user_base['is_anonym'] = 2;
user_write_back_main_data($uid,$user_base,$change_user_base);