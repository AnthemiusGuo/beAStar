<?php
$useroldpwd = isset($_GET['useroldpwd'])?mysql_real_escape_string(trim($_GET['useroldpwd'])):'';
$usernewpwd = isset($_GET['usernewpwd'])?mysql_real_escape_string(trim($_GET['usernewpwd'])):'';
if(mb_strlen($usernewpwd,'utf-8')<6||mb_strlen($useroldpwd,'utf-8')<6){
    $json_rst = array('rstno'=>0,'error'=>'密码长度不能小于6位');    
    return;
}
if($useroldpwd==$usernewpwd){
    $json_rst = array('rstno'=>-1,'error'=>'新密码不能和原始密码相同');    
    return;
}

$user_base = user_get_user_base($uid);
if($user_base['login_pwd']!=md5($useroldpwd)){
    $json_rst = array('rstno'=>-2,'error'=>'原始密码不正确');    
    return;
}
$user_base['login_pwd'] = $change_list['login_pwd'] = md5($usernewpwd);
user_write_back_main_data($uid,$user_base,$change_list);
