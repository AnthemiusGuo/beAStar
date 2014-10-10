<?php
include_once FR.'functions/user/admin_session.func.php';
$info = get_admin_cookie();

$admin_id = (int)$info[0];
$admin_sid = mysql_real_escape_string($info[1]);
$admin_token = mysql_real_escape_string($info[2]);
$admin_ts = mysql_real_escape_string($info[3]);
$admin_role = (int)$info[4];

if ($admin_token != md5($admin_id.$admin_sid.$admin_ts.$public_key)){
    $admin_id = 0;    
    return;
}

if ($admin_ts<$zeit-300){
    set_admin_cookie($admin_id,$admin_sid,$zeit,$admin_role);
}

?>