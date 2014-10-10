<?php
$avatar_id = isset($_GET['avatar_id'])?(int)$_GET['avatar_id']:0;
$avatar_url = $res_url_prefix.'images/avatar/'. $avatar_id.'.png';
if(!file_exists($avatar_url)){
    $json_rst = array('rstno'=>-1,'error'=>'头像不存在');
    return;
}
$user_base = user_get_user_base($uid);
if($user_base['avatar_id']==$avatar_id){
    $json_rst = array('rstno'=>-2,'error'=>'头像没有发生变化');
    return;
}
$user_base['avatar_id'] = $change_list['avatar_id'] = $avatar_id;
user_write_back_main_data($uid,$user_base,$change_list);
$json_rst['avatar_url'] = $avatar_url;