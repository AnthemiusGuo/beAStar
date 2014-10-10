<?
function become_robot($uid,$level){
    $sql = "INSERT INTO s_robot (cid,level) VALUES ($uid,$level)";
    mysql_w_query($sql);
    switch ($level){
        case 1:
            $exp = 4000;
            break;
        case 2:
            $exp = 7000;
            break;
        case 3:
            $exp = 13000;
            break;
        default://先升级到10级，之后慢慢升级，免得被玩家发现
            $exp = 23000;
            break;
    }
    club_add_club_exp($uid,$exp,1);
}

function robot_get_list($room_id){
    global $sys_id;
    $robot_list = get_cache($sys_id.':'.$room_id,'robot',0);
    //$robot_list = -1;
    if ($robot_list ==-1 || $robot_list ==-2 ) { 
            $robot_list = robot_update_list($room_id); 
    } else { 
            $robot_list = $robot_list['data']; 
    }
    return $robot_list;
}

function robot_get_vernier($room_id){
    global $sys_id;
    $vernier = get_cache($sys_id.":".$room_id,'robot_vernier',0);
    if ($vernier ==-1 || $vernier ==-2 ) {
        $vernier = 0;
    } else { 
        $vernier = $vernier['data']; 
    }
    return $vernier;
}

function robot_update_list($room_id){
    global $sys_id;
    $uuid = "robot_".$room_id;
    $sql = "SELECT uid FROM u_account WHERE is_robot=1 AND uuid='$uuid'";
    $rst = mysql_w_query($sql);
    $robot_list = array();
    $vernier = -1;
    $i = 0;
    while ($row = mysql_fetch_assoc($rst)){		 
        $robot_list[] = $row['uid'];
        //游标指向第一个未使用的值
        if ($vernier==-1){
            $vernier = $i;
        }        
        $max = $i;
        $i++;
    }
    set_cache($sys_id.':'.$room_id,'robot',$robot_list,0);
    set_cache($sys_id.':'.$room_id,'robot_vernier',$vernier,0);
    return $robot_list;
}
//返回robot uid
function robot_get_a_robot($room_id){
    global $sys_id;
    $robot_list = robot_get_list($room_id);
    $vernier = robot_get_vernier($room_id);
    
    $vernier++;
    if ($vernier>=count($robot_list)){
        $vernier = 0;
    }
    set_cache($sys_id.':'.$room_id,'robot_vernier',$vernier,0);
    
    return $robot_list[$vernier];
}

?>