<?php
include_once FR.'functions/user/user_info.func.php';
if (isset($_COOKIE[$zone_id.'SAL'])) {
	//取cookie
	//cookie解密
	$cookie = get_cookie();
	$uid = $cookie[0];
	$sid = $cookie[1];
	$cid = $cookie[2];	
	$uuid = $cookie[3];
    $online_id = $cookie[4];
    $u_account = user_get_user_base($uid);
    if($uid>0&&!empty($u_account)){
        $json_rst['rstno'] = 3;
        $json_rst['login_info'] = array('uid'=>$uid,
										'is_anonym'=>$u_account['is_anonym'],
                                    'sid'=>$sid);
        return;
    }
}
$uuid = isset($_GET['uuid'])?mysql_real_escape_string(trim($_GET['uuid'])):'';
$u_accounts = user_get_user_device_account_by_uuid($uuid);
if(empty($u_accounts)){
	//没有进入过游戏的设备
    $json_rst['rstno'] = 1;//新用户出注册登录选择页面
    $json_rst['url'] = 'reg';
    return;
}

$login_name = !empty($_GET['login_name']) ? mysql_real_escape_string(trim($_GET['login_name'])) : ('');
$login_pwd = !empty($_GET['login_pwd']) ? mysql_real_escape_string(trim($_GET['login_pwd'])) : ('');
//TODO 检测合法性
if($login_name!=''&&$login_name!=NULL){
	$sql = "SELECT uid,login_pwd,is_anonym FROM u_account WHERE login_name='$login_name'";
	$rst = mysql_w_query($sql);
	if($row = mysql_fetch_assoc($rst)){
		$u_account = $row;
		if($u_account['login_pwd']==$login_pwd){
			$json_rst['rstno'] = 3;//直接进入游戏
			$uid = $u_account['uid'];
			$sid = user_login($uid,$uuid);
			$json_rst['login_info'] = array('uid'=>$u_account['uid'],
											'is_anonym'=>$u_account['is_anonym'],
									'sid'=>$sid);
			return;
		}
	}
}
$user = new User();
$user->initByUuid($uuid);
    
// $u_account = user_get_user_account_by_uuid($uuid);
if(!empty($u_account)){
	if($u_account['is_anonym']==1){
		$json_rst['rstno'] = 2;//匿名用户 倒计时10S进入游戏
		$json_rst['url'] = 'loginwait';
		return;
	}else{
		//该设备已注册实名账号
		$json_rst['rstno'] = 4;//登录页面
		$json_rst['url'] = 'login';
		return;
	}
}else{
	//玩家登录过其他设备注册的账号
	$json_rst['rstno'] = 4;//登录页面
	$json_rst['url'] = 'login';
	return;
}
?>