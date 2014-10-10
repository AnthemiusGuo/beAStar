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

if (isset($_GET['uuid'])){
    $uuid = $_GET['uuid'];
    $u_account = array();
    $sql = "SELECT * FROM u_account WHERE uuid='$uuid' AND is_anonym!=0";
	$rst = mysql_w_query($sql);
	if ($row = mysql_fetch_assoc($rst)){
		$u_account = $row;
	}
    if(empty($u_account)){
        $u_account = user_reg_anonymous_user($uuid);
        $is_anonym = 1;
    }else{
        $is_anonym = $u_account['is_anonym'];
    }
    if($is_anonym==2){
        $json_rst = array('rstno'=>-2,"error"=>"你的匿名账号已绑定账号，请使用账号密码登陆！");
        return;
    }
    $uid = $u_account['uid'];
    if ($is_anonym==1){
        //创建匿名账户    
        $uuid = isset($u_account['uuid'])?$u_account['uuid']:0;
        $sid = gen_session_id($uid,$zeit,$public_key);
        $online_id = gen_online_id($uid,$sid,$zeit,$uuid);
        set_cookie($uid, $sid, $uid,$uuid,$online_id); 
        init_user_session_and_cache($uid,$sid);	
        $g_user_base = user_get_user_base($uid);
        $g_user_extend = user_get_user_extend($uid);
        $user_extend['online_keeps']=$change_list['online_keeps']=1;
        $user_extend['gen_online_gift']=$change_list['gen_online_gift']=0;
        $user_extend['last_login']=$change_list['last_login']=$zeit;
        $user_extend['last_online'] =$change_list['last_online']= $zeit;
        user_write_back_extend_data($uid,$user_extend,$change_list);
        $url  = './test.php';
        $json_rst['url'] = $url;
        //设备记录
        user_insert_into_device($uuid,$uid);
        $json_rst['login_info'] = array('uid'=>$u_account['uid'],
                                        'is_anonym'=>$u_account['is_anonym'],
                                        'sid'=>$sid);
        return;
    }     
    //实名登陆逻辑
     //刷新游戏伙伴
    user_reload_user_intro_list($uid);   
    $zeit = time();
    $g_sunrise = $zeit-($zeit+8*3600)%86400;
    $g_sunset = $g_sunrise + 86399;
    $user_extend = user_get_user_extend($uid);
    $last_login = $user_extend['last_login'];
    $online_keeps = $user_extend['online_keeps'];
    if($last_login<$g_sunrise){
        //今天第一次登陆
        if($last_login>$g_sunrise-86400){
            //是连续登陆
            $online_keeps = $online_keeps+1;            
        }else{
            $online_keeps = 1;
        }
        $user_extend['online_keeps']=$change_list['online_keeps']=$online_keeps;
        $user_extend['gen_online_gift']=$change_list['gen_online_gift']=0;
        $user_info_base = user_get_user_base($uid);
        if($user_info_base['vip_end_zeit']<$zeit){
            $change_user_base = array();
            $change_user_base['vip_level'] = $user_info_base['vip_level'] = 0;
            user_write_back_main_data($uid,$user_info_base,$change_user_base);
        }
    }
    $user_extend['last_login']=$change_list['last_login']=$zeit;
    $user_extend['last_online'] =$change_list['last_online']= $zeit;
    user_write_back_extend_data($uid,$user_extend,$change_list);

} else {
    $uid = (int)$_GET['uid'];
    $u_account = user_get_user_base($uid);
    $uuid = $u_account['uuid'];
}

$uuid = isset($u_account['uuid'])?$u_account['uuid']:0;

$sid = gen_session_id($uid,$zeit,$public_key);
$online_id = gen_online_id($uid,$sid,$zeit,$uuid);
set_cookie($uid, $sid, $uid,$uuid,$online_id); 
init_user_session_and_cache($uid,$sid);	
$g_user_base = user_get_user_base($uid);
$g_user_extend = user_get_user_extend($uid);
$url  = './test.php';
$json_rst['url'] = $url;
 
$json_rst['login_info'] = array('uid'=>$u_account['uid'],
                                'is_anonym'=>$u_account['is_anonym'],
                                'sid'=>$sid);
?>
