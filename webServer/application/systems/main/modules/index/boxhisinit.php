<?php
$user_strongboxlog = user_get_strongboxlog($uid);
$user_box_log = array();
foreach($user_strongboxlog as $log){
    if($log['typ']==0||$log['typ']==1){
        $user_box_log[] = $log;
    }
    
}
$json_rst['password_box_has'] = $g_user_base['password_box']==""?0:1;
$json_rst['history_'] = $user_box_log;
