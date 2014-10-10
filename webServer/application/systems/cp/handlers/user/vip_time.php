<?
$add_time = (int)$_GET['time'];
$sql = "SELECT uid FROM u_user WHERE vip_typ>0 AND vip_end_zeit>$zeit-86400";
$rst = mysql_x_query($sql);
while ($row = mysql_fetch_assoc($rst)){
    $user_uid = $row['uid'];
    $user_uinfo = user_get_user_base($user_uid);
    $user_uinfo['vip_end_zeit'] = $user_uinfo['vip_end_zeit']+$add_time*3600;
    $changes['vip_end_zeit'] = 1;
    user_write_back_main_data($user_uid,$user_uinfo,$changes);
}

?>