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
        $json_rst['rstno'] = 5;
        $json_rst['login_info'] = array('uid'=>$uid,
										'is_anonym'=>$u_account['is_anonym'],
                                    'sid'=>$sid);
        return;
    }
}
$uuid = isset($_GET['uuid'])?mysql_real_escape_string(trim($_GET['uuid'])):'';
$has_ever_login = isset($_GET['has_ever_login'])?(int)(trim($_GET['has_ever_login'])):0;
//如果//1: 匿名重新进入
	//3; 设备已注册，或已记住密码，出登陆框
	//2； 设备未注册，出三选页

$u_accounts = user_get_user_device_account_by_uuid($uuid);
if(empty($u_accounts)){
	//没有进入过游戏的设备
    $json_rst['rstno'] = 1;//新用户出注册登录选择页面
    return;
}
$user = new User();
$user->initByUuid($uuid);
// $u_account = user_get_user_account_by_uuid($uuid);
if(!empty($u_account)){
	if($u_account['is_anonym']==1){
		/* 强制注册的规则 */
		if ($u_account['credits']>10000 || $u_account['vip_end_zeit']>0){
			$json_rst['rstno'] = 2;//匿名用户 注册登陆
			$json_rst['url'] = 'loginwait';
		} else {
			$json_rst['rstno'] = 2;//匿名用户 倒计时10S进入游戏
			$json_rst['url'] = 'loginwait';
		}
		
		return;
	}else{
		//该设备已注册实名账号
		$json_rst['rstno'] = 3;//登录页面
		$json_rst['url'] = 'login';
		return;
	}
}else{
	//玩家登录过其他设备注册的账号
	$json_rst['rstno'] = 2;//登录页面
	$json_rst['url'] = 'login';
	return;
}
?>