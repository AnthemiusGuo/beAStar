<?php
$user_base = user_get_user_base($uid);
$json_rst['change_credits'] = 0;
if($user_base['total_credits']>=1000){
    $json_rst = array('rstno'=>-1,'error'=>'当前游戏币小于1000才可领取! ');
    return;
    
}
$user_extend = user_get_user_extend($uid);
$date = (int)date('Ymd',$zeit);
if($user_extend['gen_alms_zeit']<$date){
    $user_extend['gen_alms_zeit'] = $change['gen_alms_zeit'] = $date;
    $user_extend['gen_alms_num'] = $change['gen_alms_num'] = 1;
}else{
    if($user_extend['gen_alms_num']==0){
        $user_extend['gen_alms_zeit'] = $change['gen_alms_zeit'] = $date;
        $user_extend['gen_alms_num'] = $change['gen_alms_num'] = 1;
    }else{
        $json_rst = array('rstno'=>-2,'error'=>'今天已经领取过了! ');
        return;
    }
}
$change_credits = 3000;
user_write_back_extend_data($uid,$user_extend,$change);
$json_rst['credits'] = change_credits($uid,40,403,$change_credits,0);
$json_rst['change_credits'] = $change_credits;