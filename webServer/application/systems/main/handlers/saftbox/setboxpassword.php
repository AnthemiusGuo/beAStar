<?php
$pwd = isset($_GET['pwd'])?trim(mysql_real_escape_string($_GET['pwd'])):'';
if(mb_strlen($pwd)<6){
    $json_rst = array('rstno'=>-1,'error'=>'密码长度不能小于6位');
    return;
}
$typ = isset($_GET['typ'])?(int)$_GET['typ']:0;
if($typ!=1&&$typ!=2){
    $json_rst = array('rstno'=>0,'error'=>'data error');
    return;
}
$user_info = user_get_user_base($uid);
if($typ==1){
    if($user_info['password_box'] != ''){
        $json_rst = array('rstno'=>0,'error'=>'data error');
        return;
    }
}else{
    $pwd_first = isset($_GET['pwd_first'])?trim(mysql_real_escape_string($_GET['pwd_first'])):'';
    if(substr(md5($pwd_first),0,16)!=$user_info['password_box']){
        $json_rst = array('rstno'=>-2,'error'=>'原始密码输入不正确');
        return;
    }
}
$pwd = substr(md5($pwd),0,16);

$user_info['password_box'] = $pwd;
$change_list['password_box'] = $user_info['password_box'];
user_write_back_main_data($uid,$user_info,$change_list);
$json_rst = array('rstno'=>1,'error'=>'密码设置成功');
 
?>
