<?php
$info['level'] = $g_user_base['level'];
$info['gen_online_gift'] = $g_user_extend['gen_online_gift'];
$info['online_keeps'] = $g_user_extend['online_keeps'];
$info['online_award'] = 2000;
if($info['online_keeps']<3&&$info['online_keeps']>0){
   $info['online_award']= $cfg_user_online_keeps_award[$info['online_keeps']];
}else if($info['online_keeps']>=3){
    $info['online_award'] = $cfg_user_online_keeps_award[3];
}
$info['credits_lucky'] = 0;
$info['can_get'] = -1;//不能领取
$info['can_get_tuoguang'] = -1;//不能领取
$info['credits_tuoguang'] = 0;
$date_w = date('w');
$cur_date = date('Ymd');
if($date_w==6){
    $date_start = date("Ymd",$zeit-7*86400);
    $info['can_get_tuoguang'] = $info['can_get'] = 1;
    $can_get_date1 = $cur_date;
    $can_get_date2 = date("Ymd",$zeit+86400); 
}else if($date_w==0){
    $date_start = date("Ymd",strtotime("last Saturday")-7*86400);
    $info['can_get_tuoguang'] = $info['can_get'] = 1;//可以领取
    $can_get_date1 = $cur_date;
    $can_get_date2 = date("Ymd",$zeit-86400); 
}else{
    $date_start = date("Ymd",strtotime("last Saturday"));
    $info['can_get_tuoguang'] = $info['can_get'] = -1;
}
if($info['can_get_tuoguang']==1){
    if($g_user_extend['gen_intro_gift_zeit']==$can_get_date1||$g_user_extend['gen_intro_gift_zeit']==$can_get_date2){
        //已经领取
        $info['can_get_tuoguang'] = 2;        
    }
}
$info['date_w'] = $date_w;
if($info['level']>=8){
    $all_credits = 0;
    $user_buddy = user_get_user_intro_list($uid);
    foreach($user_buddy as $this_info){
        if($date_start<$this_info['c_date']){
            continue;
        }
        $op_uid = $this_info['uid'];        
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
    $info['credits_tuoguang'] = ($all_credits);
   
}else{
    $info['can_get_tuoguang'] = 0; 
}



if($info['level']>=5){
    
    $lucky_chest_info = user_get_lucky_chest_info($uid,$date_start);
    if(!empty($lucky_chest_info)){
        $end_exp = $lucky_chest_info['end_exp'];
        $add_exp_all = $lucky_chest_info['add_exp_all'];
        $exp_first = $end_exp-$add_exp_all;
        $add_credits = user_get_lucky_chest_credits($exp_first,$end_exp,$add_exp_all);         
        $info['credits_lucky'] = (round($add_credits));
        if($info['credits_lucky']==0){
            $info['can_get'] = 0;
        }
        if($info['can_get']==1){            
            if($lucky_chest_info['status']==1){
                $info['can_get'] = 2;//已经领取
            }
        }
    }else{
        $info['credits_lucky'] = 0;
        $info['can_get'] = 0;//不能领取
    }
    
}else{
    $info['credits_lucky'] = 0;
    $info['can_get'] = 0;//不能领取
}

//救济金

$user_extend = user_get_user_extend($uid);
//var_dump($user_extend);
$date = (int)date('Ymd',$zeit);
if($user_extend['gen_alms_zeit']<$date){
    $info['LowProtectGet'] = 1;
}else{
    if($user_extend['gen_alms_num']==0){
        $info['LowProtectGet'] = 1;
    }else{
        $info['LowProtectGet'] = 2;
    }
}
if($info['LowProtectGet'] == 1){
    $info['LowProtectGet'] = 0;
}
$info['LowProtectCredits']=3000;
$json_rst['info'] = $info;
