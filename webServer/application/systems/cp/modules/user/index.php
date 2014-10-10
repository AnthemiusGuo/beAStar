<?
$user_uid = 0;
$club_name = '';
$pp_uid = '';
$manager_name = '';
$users = array();
if (isset($_GET['user_uid'])){
    $user_uid = (int)(trim($_GET['user_uid']));
    
} elseif (isset($_GET['club_name'])){
    $club_name = mysql_real_escape_string(trim($_GET['club_name']));
    $sql = "SELECT cid from c_club_info WHERE club_name LIKE '%$club_name%'";
    $rst = mysql_query($sql);
    
    while ($row = mysql_fetch_assoc($rst)){
        $row['base_info'] = user_get_user_base($row['cid']);
        $row['club_info'] = club_get_club_info($row['cid']);
        $row['uid'] = $row['cid'];
        $users[] = $row;
    }
    if (mysql_numrows($rst)==0){
        $user_uid = -1;
        return;
    }
} elseif (isset($_GET['pp_uid'])){
    $pp_uid = mysql_real_escape_string(trim($_GET['pp_uid']));
    $sql = "SELECT uid,pp_uid,DOA from u_user WHERE pp_uid='$pp_uid'";
    $rst = mysql_query($sql);
    $users = array();
    if ($row = mysql_fetch_assoc($rst)){
        $row['base_info'] = user_get_user_base($row['uid']);
        $row['club_info'] = club_get_club_info($row['uid']);
        $users[] = $row;
    } else {
        $user_uid = -1;
        return;
    }
}else if(isset($_GET['manager_name'])){
    $manager_name = mysql_real_escape_string(trim($_GET['manager_name']));
    $sql = "SELECT cid from c_club_info WHERE manager_name LIKE '%$manager_name%'";
    $rst = mysql_query($sql);
    
    while ($row = mysql_fetch_assoc($rst)){
        $row['base_info'] = user_get_user_base($row['cid']);
        $row['club_info'] = club_get_club_info($row['cid']);
        $row['uid'] = $row['cid'];
        $users[] = $row;
    }
    if (mysql_numrows($rst)==0){
        $user_uid = -1;
        return;
    }
}
if ($user_uid>0){
    $base_info = user_update_user_base($user_uid);
    
    if ($base_info==false){
        $user_uid = -1;
        return;
    }
    $extend_info = user_update_user_extend($user_uid);
    $club_info = _update_club_info($user_uid);
    if($club_info['cid']){
        $cid = $club_info['cid'];
        $squad_info = player_update_squad_list($cid);
    }else{
        $squad_info = array();
    }

    $pid_list = _update_player_id_list_in_team($cid);
    $player_info = array();
    foreach($pid_list as $this_pid_key){
        $this_player_info = new user_player($this_pid_key);
        $player_info[$this_pid_key] = $this_player_info->_update_player_info();
    }
    
}


?>