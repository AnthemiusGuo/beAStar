<?php
$date_w = date('w');
if($date_w!=0&&$date_w!=6){
    $json_rst = array('rstno'=>-1,'error'=>'不在可领取时间');
    return;
}
if($g_user_base['level']<8){
    $json_rst = array('rstno'=>-2,'error'=>'data error');
    return;
}
$cur_date = date('Ymd');
if($date_w==6){
    $date_start = date("Ymd",$zeit-7*86400);
    $can_get_date1 = $cur_date;
    $can_get_date2 = date("Ymd",$zeit+86400);    
}else if($date_w==0){
    $date_start = date("Ymd",strtotime("last Saturday")-7*86400);
    $can_get_date1 = $cur_date;
    $can_get_date2 = date("Ymd",$zeit-86400);
}
if($g_user_extend['gen_intro_gift_zeit']==$can_get_date1||$g_user_extend['gen_intro_gift_zeit']==$can_get_date2){
    //已经领取
    $json_rst = array('rstno'=>-4,'error'=>'您已领取上周推广宝箱累计金币');
    return;    
}

$all_credits = 0;
$user_buddy = user_get_user_intro_list($uid,1);
foreach($user_buddy as $info){
    if($date_start<$info['c_date']){
        continue;
    }
    $op_uid = $info['uid'];        
    $lucky_chest_info = user_get_lucky_chest_info($op_uid,$date_start);
    if(empty($lucky_chest_info)){
        continue;
    }
    $end_exp = $lucky_chest_info['end_exp'];
    $add_exp_all = $lucky_chest_info['add_exp_all'];
    $exp_first = $end_exp-$add_exp_all;
    $this_credits =  user_calculate_intro_credits($exp_first,$end_exp,$add_exp_all);
    $all_credits += $this_credits;
}
$all_credits = round($all_credits);
$change = array();
$g_user_extend['gen_intro_gift_zeit'] = $change['gen_intro_gift_zeit'] = $cur_date;
user_write_back_extend_data($uid,$g_user_extend,$change);
$json_rst['credits'] = change_credits($uid,40,405,$all_credits,0);
$json_rst['change_credits'] = $all_credits;
