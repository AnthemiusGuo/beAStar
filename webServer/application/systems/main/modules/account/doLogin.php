<?
include_once AR."functions/user/reg.func.php";
include_once AR."config/define/define.wordslength.php";
include_once AR."config/define/define.reg.php";
include_once AR.'functions/user/user_session.func.php';

//用帐号密码登录
$name = $g_input->post('phone');
$password = $g_input->post('password');
$g_account = new Account();
$login_rst = $g_account->init_by_name_pwd($name,$password);
if ($login_rst==1){
    //登录成功，
    if ($g_account->field_list['uid']->value==''){
        $json_rst['data']['goto_url'] = site_url('account/create/'.$g_account->id );
        return;
    }
    //走登录逻辑

} else if ($login_rst==-1){
    //密码不对
    $json_rst['rstno'] = -1;
    $json_rst['data']['msg'] = '密码不正确';
    return;
} else {
    //需要注册
    //自动创建 account 先
    $uuid = $g_account->create_account_by_name_pwd($name,$password);
    $json_rst['data']['goto_url'] = site_url('account/create/'.$uuid );
    return;
}
exit;

if ($config_open_reg==0){
    $json_rst['rstno'] = -1;
    $json_rst['error'] = _('本服务器已经关闭注册');
    return;
}

if (isset($_GET['uuid'])){
    $uuid = $_GET['uuid'];
    $g_user = new User();
    $g_user->initByUuid($uuid);

    if(!$g_user->hasGet){
        $g_user->regAnonymousUser($uuid);
        $g_user->setUuid($uuid);

        $is_anonym = 1;
        //创建匿名账户
        $uid = $g_user->uid;

        $ticket = $g_user->genTicket();

        $g_user->insertOnlineInfo();

        set_cookie($uid, $ticket,$uuid);

        $url  = './test.php';
        $json_rst['url'] = $url;
        //设备记录
        $json_rst['data']['uid'] = $g_user->uid;
        $json_rst['data']['ticket'] = $ticket;
        $json_rst['data']['user_info'] = $g_user->get_user_show($uid,1,1);
        $json_rst['data']['online_keeps'] = $g_user->counters['online_keeps'];

        return;
    }
    //实名登陆逻辑
     //刷新游戏伙伴
    //user_reload_user_intro_list($uid);
    $uid = $g_user->uid;
    $zeit = time();

    $last_login = $g_user->extendInfo['last_login'];
    $online_keeps = $g_user->counters['online_keeps'];

    $newData = array();

    if($last_login<$g_sunrise){
        //今天第一次登陆
        if($last_login>$g_sunrise-86400){
            //是连续登陆
            $online_keeps = $online_keeps+1;
        }else{
            $online_keeps = 1;
        }
        $g_user->counters['online_keeps'] = $online_keeps;
        $newData["counters.online_keeps"] = $online_keeps;
        $g_user->extendInfo['gen_online_gift'] = 0;
        $newData["extendInfo.gen_online_gift"] = 0;

        if($g_user->baseInfo['vip_end_zeit']<$zeit){
            $g_user->baseInfo['vip_level'] = 0;
            $newData["baseInfo.vip_level"] = 0;
        }
    }

    $g_user->extendInfo['last_login'] = $zeit;
    $g_user->extendInfo['last_online'] = $zeit;
    $newData["extendInfo.last_login"] = $zeit;
    $newData["extendInfo.last_online"] = $zeit;

    $g_user->writeBackBatch($newData);

} else {

}

$ticket = $g_user->getTicket();

$g_user->refreshTicket(true);

set_cookie($uid, $ticket,$uuid);
$json_rst['data']['uid'] = $g_user->uid;
$json_rst['data']['ticket'] = $ticket;
$json_rst['data']['user_info'] = $g_user->get_user_show($uid,1,1);
$json_rst['data']['online_keeps'] = $g_user->counters['online_keeps'];
$json_rst['data']['gen_online_gift'] = $g_user->extendInfo['gen_online_gift'];
$json_rst['data']['day_awards'] = $cfg_user_online_keeps_award;
$json_rst['data']['day_vip_awards'] = $cfg_user_online_keeps_award_vip;


$redis_key = "user/ticket/".$uid;
$ticket = $redis->get($redis_key);
if ($ticket===false){
	$json_rst['data']['ticket'] = genTicket($uid);
} else {
	$json_rst['data']['ticket'] = $ticket;
	$redis->setTimeout($redis_key, 3600);
}
// $json_rst['data']['lobby'] = array("host"=>"127.0.0.1","clientPort"=>3000);
$json_rst['rstno'] = 1;
?>
