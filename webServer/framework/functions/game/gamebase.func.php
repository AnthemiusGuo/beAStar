<?
include_once FR.'config/define/define.room.php';

function gb_get_room_list(){
    global $room_list;
    return $room_list;
    //$data = _file_cache_get_cache('room_list');
    //if ($data['rst']<0){
    //    return _zha_update_room_list();
    //} else {
    //    return $data['data'];
    //}
}

function _gb_update_room_list(){
    $sql = "SELECT * FROM s_room";
    $rst = mysql_x_query($sql);
    $room_list = array();
    while ($row = mysql_fetch_assoc($rst)){
        $room_list[$row['room_id']] = $row;
    }
    _file_cache_gen_cache('room_list',$room_list);
    return $room_list;
}

function gb_get_room_info($room_id){
    $room_list = gb_get_room_list();
    if (isset($room_list[$room_id])){
        return $room_list[$room_id];
    } else {
        return array('room_id'=>-1);
    }
}
#TODO
function gb_get_room_status(){
    
}

function gb_set_room_status($room_id,$table_id,$status){
    
}
?>