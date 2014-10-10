<?php
if($g_user_extend['gen_online_gift']==1){
    $json_rst = array('rstno'=>-1,'error'=>'你今天已经领过登陆奖励了');
    return;
}

$change_list['gen_online_gift'] = $g_user_extend['gen_online_gift'] = 1;
if($g_user_extend['online_keeps']==1){
    $change_credits = 2000;
}else if($g_user_extend['online_keeps']==2){
    $change_credits = 3000;
}else{
    $change_credits = 5000;
}
//ceshi todo
//$change_credits = $change_credits*100000;
user_write_back_extend_data($uid,$g_user_extend,$change_list);

$json_rst['credits'] = change_credits($uid,40,402,$change_credits,0);
$json_rst['change_credits'] = $change_credits;