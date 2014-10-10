<?php

$json_rst['user'] = user_get_user_show($uid,1,1);
$json_rst['user']['display_uid'] = user_get_display_uid($uid);
$receive_send_credits = user_get_receive_send_credits($uid);
$send_credits = array();
foreach($receive_send_credits as $send_credits_info){
    if($send_credits_info['status']==0){
        $op_uid = $send_credits_info['send_uid'];
        $op_user_info = user_get_user_base($op_uid);
        if(!empty($op_user_info)){
            $send_credits_info['msg'] = $op_user_info['uname']."\n赠送给您游戏币\n".$send_credits_info['credits'];
            $send_credits[] = array('id'=>$send_credits_info['id'],'send_uid' =>$send_credits_info['send_uid'],
                                    'send_uname'=>$op_user_info['uname'],'credits'=>$send_credits_info['credits']);
        }
    }
}
$json_rst['user']['first_send_id'] = 0;
$json_rst['user']['send_msg'] = array();
if(!empty($send_credits)){
    $json_rst['user']['first_send_id'] = $send_credits[0]['id'];
    $json_rst['user']['send_msg'] = $send_credits;
}
$avatar_list = array();
for($i=1;$i<=15;$i++){
    //if($i == $json_rst['user']['avatar_id']){
    //    continue;
    //}
    $avatar_url = 'images/avatar/'. $i.'.png';
    if(!file_exists($avatar_url)){
        continue;
    }
    $info = array();
    $info['this_avatar_id'] = $i;
    $info['this_avatar_url'] = $avatar_url;
    $avatar_list[] = $info;
} 
$json_rst['avatar_id'] = $g_user_base['avatar_id'];
$json_rst['avatar_list'] = $avatar_list;
?>