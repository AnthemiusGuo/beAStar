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
?>
