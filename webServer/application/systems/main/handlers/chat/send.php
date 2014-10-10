<?
$info = user_get_user_base($uid);
$words = isset($_GET['words'])?mysql_real_escape_string(trim($_GET['words'])):'';
 

if(empty($info)){
    $json_rst['rstno'] = -1;
    $json_rst['error'] = '数据错误';
    return;
}
//to do喇叭不够
//if($g_user_extend['speaker_count']<=0){
//    $json_rst['rstno'] = -2;
//    $json_rst['error'] = '喇叭不够';
//    return;
//}
if($g_user_extend['speaker_count']>0){
    $g_user_extend['speaker_count']--;
    $change['speaker_count'] = $g_user_extend['speaker_count'];
    user_write_back_extend_data($uid,$g_user_extend,$change);
}else{
    $user_base = user_get_user_base($uid);
    $cost = 10000;
    if($user_base['credits']>=$cost){
        change_credits($uid,60,601,-$cost,0);
        st_ser_change("chat_cost",10000);
        
    }else{
        $json_rst['rstno'] = -2;
        $json_rst['error'] = '金币不够';
        return;
    }
}
$json_rst['speaker_count'] = $g_user_extend['speaker_count'];
$json_rst['uname'] = $info['uname'];
$json_rst['words'] = $words;
user_send_chat($uid,1,$words);
?>