<?php
if (!isset($_COOKIE['admin_se'])){
    $admin_id = 0;    
    return;
}

$admin_id = (int)$_COOKIE['admin_se'];
$admin_token = mysql_real_escape_string($_COOKIE['admin_token']);
$admin_ts = mysql_real_escape_string($_COOKIE['admin_ts']);
$admin_lang = mysql_real_escape_string($_COOKIE['admin_lang']);
$admin_role = (int)$_COOKIE['admin_role'];
$ts = time();

if ($admin_ts<$ts-1800 || $admin_ts>$ts+60){
    $admin_id = 0;    
    return;
}

if ($admin_token != md5($admin_id.$admin_lang.md5($admin_ts))){
    $admin_id = 0;    
    return;
}

if ($admin_ts<$ts-300){
    set_admin_cookie($admin_id,$ts,$admin_lang,$admin_role);
}

?>