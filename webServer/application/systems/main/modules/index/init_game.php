<?php
include_once FR.'functions/common/lobby.func.php';
include_once FR.'functions/zha/zha.func.php';

$json_rst['user_info'] = $g_user->get_user_show(1,1);
$json_rst['user_info']['items']['speaker_count'] = $g_user->counters['speaker_count'];
$json_rst['level'] = $g_user->baseInfo['level'];
$json_rst['credits'] = $g_user->baseInfo['credits'];
$json_rst['is_anonym'] = $g_user->baseInfo['is_anonym'];
$json_rst['total_credits'] = $g_user->baseInfo['total_credits'];
$json_rst['room_list'] = mobi_get_room_list();
$json_rst['login_info'] = array('uuid'=>$g_user->baseInfo['uuid'],
                                'uid'=>$g_user->uid,
                                'is_anonym'=>$g_user->baseInfo['is_anonym'],
                                'ticket'=>$g_user->ticket);
$json_rst['can_give_gift'] = true;


?>
