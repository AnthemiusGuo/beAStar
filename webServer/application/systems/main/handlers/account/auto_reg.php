<?php
include_once FR."functions/user/reg.func.php"; 
include_once FR."config/define/define.wordslength.php";
include_once FR."config/define/define.reg.php";
include_once FR.'functions/user/user_session.func.php';
include_once FR.'functions/common/lobby.func.php';

$json_rst = array('rstno'=>1,'error'=>'error','url'=>'');

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
    
        $json_rst['user_info'] = $g_user->get_user_show($uid,1,1);
        $json_rst['online_keeps'] = $g_user->counters['online_keeps'];
        $json_rst['gen_online_gift'] = $g_user->extendInfo['gen_online_gift'];
        $json_rst['day_awards'] = $cfg_user_online_keeps_award;
        $json_rst['day_vip_awards'] = $cfg_user_online_keeps_award_vip;
        $lobby_id = lobby_get_lobby_by_uid($uid);
        $json_rst['lobbyInfo'] = $config['lobby'][$lobby_id ];
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
    $uid = (int)$_GET['uid'];
    $g_user = new User();
    $g_user->init($uid);
}

$ticket = $g_user->getTicket();

$g_user->refreshTicket(true);

set_cookie($uid, $ticket,$uuid); 

$json_rst['user_info'] = $g_user->get_user_show($uid,1,1);
$json_rst['online_keeps'] = $g_user->counters['online_keeps'];
$json_rst['gen_online_gift'] = $g_user->extendInfo['gen_online_gift'];
$json_rst['day_awards'] = $cfg_user_online_keeps_award;
$json_rst['day_vip_awards'] = $cfg_user_online_keeps_award_vip;
$lobby_id = lobby_get_lobby_by_uid($uid);
$json_rst['lobbyInfo'] = $config['lobby'][$lobby_id ];

//$json_rst['login_info'] = array('uid'=>$u_account['uid'],
//                                'is_anonym'=>$u_account['is_anonym'],
//                                'sid'=>$sid);
?>
