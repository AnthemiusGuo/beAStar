<?php
include_once FR.'functions/common/cache_info.func.php';
include_once AR.'functions/user/user_info.func.php';

function check_user_session($sid,$uid)
{
    //temp code	 
    $temp_sid = get_cache($uid,'online_info',1);
    if ($temp_sid  ==-1){
	return 0;
    } elseif ($temp_sid  ==-2) {
        //没有缓存信息或超时，我需要重新刷一次自己的信息
        set_cache($uid,'online_info',$sid,1);
	$this_uid = $uid;
    } else {
        if ($sid==$temp_sid['data']){
            $this_uid  = $uid;
        } else {
            $this_uid = 0;
        }
        
    }
    return $this_uid;
}

function update_online_info($uid,$user_extend,$zeit,$online_id){
    global $session_config;
    if ($zeit - $user_extend['last_online'] > $session_config['memcache_sync_time']){
        $user_extend['last_online'] = $change['last_online'] = $zeit;
        user_write_back_extend_data($uid,$user_extend, $change);
        $sql = "UPDATE st_online_details SET last_online = $zeit WHERE 	id=$online_id";
        mysql_x_query($sql);
    }
}
?>
