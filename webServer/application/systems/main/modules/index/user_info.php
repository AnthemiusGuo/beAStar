<?php
$op_uid = $_GET['op_uid'];
$json_rst['user'] = user_get_user_show($op_uid);
$json_rst['user']['display_uid'] = user_get_display_uid($op_uid);
$can_send = 1; //是否可以赠送
if($uid==$op_uid){
    $relation = 0;//自己
    $can_send = 0;
}else{
    $user_buddy = user_get_user_buddy_list($uid);
    if(!empty($user_buddy)){        
        if(in_array($op_uid,$user_buddy)){
            $relation = 1;//好友
        }else{
            $relation = 2;
        }
    }else{
        $relation = 2;
    }
}
$json_rst['user']['can_send'] = $can_send;
$json_rst['user']['relation'] = $relation;


?>