<?php
include_once FR.'functions/common/filecache.func.php';
/* system cache */
global $game_kv;
function get_gameworld_value(){
    global $game_kv;
    if (isset($game_kv)){
        return $game_kv;
    }
    $gameworld_info = get_cache('','world_kv',1);
    if ($gameworld_info ==-1 || $gameworld_info ==-2 ) {
        //没有缓存信息或者缓存信息是别人帮我刷新的，我需要重新刷一次自己的信息
        $gameworld_info = _update_gameworld_value();
    } else {
        $gameworld_info = $gameworld_info['data'];
    }
    
    return $gameworld_info;
}

function set_gameworld_value($key,$value){
    $sql = "UPDATE s_game_kv SET `value`='$value' WHERE `key`='$key'";
    mysql_x_query($sql);
    _update_gameworld_value();
}

function _update_gameworld_value(){
    global $game_kv;
    $gameworld_info = array();
    $sql = "SELECT * FROM s_game_kv";
    $rst =mysql_x_query($sql);
    while ($row = mysql_fetch_assoc($rst)){
            $gameworld_info[$row['key']] = $row['value'];
    }
    set_cache('','gameworld_info',$gameworld_info);
    $game_kv = $gameworld_info;
    return $gameworld_info;
}
?>