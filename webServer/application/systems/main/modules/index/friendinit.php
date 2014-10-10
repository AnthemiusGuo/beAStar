<?php
$user_buddy = user_get_user_buddy_list($uid);

$user_friend_list = array();
if(!empty($user_buddy)){
    foreach($user_buddy as $op_uid){
        $this_info = user_get_user_show($op_uid,0);
        if(!empty($this_info)){
            $user_friend_list[] = $this_info;
        }
    }
}
$json_rst['user_friend_list']=$user_friend_list;