<?php

if($g_user->extendInfo['gen_online_gift']==1){
    $json_rst = array('rstno'=>-1,'error'=>'你今天已经领过登陆奖励了');
    return;
}
//$cfg_user_online_keeps_award[1] = 400;
//$cfg_user_online_keeps_award[2] = 800;
//$cfg_user_online_keeps_award[3] = 1500;
//$cfg_user_online_keeps_award[4] = 2500;
//$cfg_user_online_keeps_award[5] = 4000;
//$cfg_user_online_keeps_award[6] = 6000;
//$cfg_user_online_keeps_award[7] = 8500;
//$cfg_user_online_keeps_award_vip = 5000;
$change_list['extendInfo.gen_online_gift'] = $g_user->extendInfo['gen_online_gift'] = 1;
//if($g_user_extend['online_keeps']==1){
//    $change_credits = 2000;
//}else if($g_user_extend['online_keeps']==2){
//    $change_credits = 3000;
//}else{
//    $change_credits = 5000;
//}
$online_keeps = (int)$g_user->counters['online_keeps'];
if ($online_keeps<1){
    $online_keeps = 1;
}else if ($online_keeps>7){
    $online_keeps = 7;
}
$change_credits = $cfg_user_online_keeps_award[$online_keeps];
if ($g_user->baseInfo['vip_level']>0){
    $change_credits += $cfg_user_online_keeps_award_vip;
}
//ceshi todo
//$change_credits = $change_credits*100000;
$g_user->writeBackBatch($change_list);

$json_rst['credits'] = $g_user->changeCredits(40,402,$change_credits,0);
$json_rst['change_credits'] = $change_credits;