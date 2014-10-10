<?php
$sys_message = user_get_user_message_list(0);
$user_message = user_get_user_message_list($uid);
$msg_list = array_merge($sys_message,$user_message);
uasort($msg_list,function($a,$b){
    return $b['zeit']-$a['zeit'];
    });
$json_rst['msgList'] = $msg_list;