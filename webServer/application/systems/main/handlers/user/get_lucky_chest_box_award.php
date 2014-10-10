<?php
$date_w = date('w');
if($date_w!=0&&$date_w!=6){
    $json_rst = array('rstno'=>-1,'error'=>'不在可领取时间');
    return;
}
if($g_user_base['level']<5){
    $json_rst = array('rstno'=>-2,'error'=>'data error');
    return;
}
if($date_w==6){
    $date_start = date("Ymd",$zeit-7*86400);
}else if($date_w==0){
    $date_start = date("Ymd",strtotime("last Saturday")-7*86400);
}
$lucky_chest_info = user_get_lucky_chest_info($uid,$date_start);
if(empty($lucky_chest_info)){
    $json_rst = array('rstno'=>-3,'error'=>'data error');
    return;
}
if($lucky_chest_info['status']==1){
    $json_rst = array('rstno'=>-4,'error'=>'您已领取上周幸运宝箱累计金币');
    return;
}
$lucky_chest_info['status'] = 1;
$end_exp = $lucky_chest_info['end_exp'];
$add_exp_all = $lucky_chest_info['add_exp_all'];
$exp_first = $end_exp-$add_exp_all;
$credits = user_get_lucky_chest_credits($exp_first,$end_exp,$add_exp_all);
user_set_lucky_chest_info($uid,$date_start,$lucky_chest_info,1);
$json_rst['credits'] = change_credits($uid,40,404,$credits,0);
$json_rst['change_credits'] = $credits;
