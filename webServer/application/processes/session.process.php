<?php
include_once FR.'functions/common/cache_info.func.php';
include_once AR.'functions/user/user_session.func.php';

//先检查cookie
$new_pp_uid = 0;
if (isset($_COOKIE['super_mod']) && $_COOKIE['super_mod']==1){
    $g_version_op = 0;
    $g_version_flag = 0; 
}
if (isset($_COOKIE[$zone_id.'SAL'])) {
	//取cookie
	//cookie解密
	$cookie = get_cookie();
	$uid = $cookie[0];
	$ticket = $cookie[1];
	$uuid = $cookie[2];
	
	set_cookie($uid, $ticket, $uuid);	
	//标志
} else {
	$uid = '';
	$ticket = '';
	$uuid = '';
    set_cookie(0, 0, 0); 
}
if ($uid == ''){
	//未登录逻辑
    if ($g_module!='account'){ 
		return_no_login($g_view); 
    }
}else{
    if ($config['maintain_work']&&!in_array($pp_uid,$config_main_pp_uid) && (!isset($_COOKIE['super_mod']) || $_COOKIE['super_mod']!=1)){ 
        return_maintain_work($g_view);		 
    } else {
        //服务器校验session	
        $g_user = new User();
        $g_user->uid = $uid;
        if (!$g_user->verifyTicket($ticket)) {
            if($g_module!='reg'&&$g_module!='account'){
                $uid = 0;
                set_cookie(0, 0, 0,0);			 
                return_no_login($g_view);
            }
        }
        if (!$g_user->initFullByUid($uid)){
            //uid不存在
            return_no_login($g_view); 
        }
        $g_user->refreshTicket();

            
        //判断连续登录，加载成就的hook

        $last_online_detail = $g_user->extendInfo['last_online'];
        $days_last_online = ($last_online_detail - $last_online_detail%86400)/86400;
        $days_now_online = ($zeit - $zeit % 86400)/86400;
        
    }
}

$browser = common_get_user_browser();
?>
