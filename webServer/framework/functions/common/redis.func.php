<?php
$redis_flag = 0;
$redis = null;

function redis_connect(){
    global $app_config,$redis_flag,$redis;
    if ($redis_flag != 1) {
        $redis=new Redis() or die("Can not load redis.");
        $redis->connect($app_config['redis']['host'],$app_config['redis']['port']);
        $redis_flag = 1;
    }

    return $redis;
}

function redis_incr($key = '')
{
    # code...
}

function redis_get_value($redis_key)
{
    global $redis;
    return $redis->get($redis_key);
}

function redis_refresh($redis_key,$expire = 3600)
{
    global $redis;
    if ($expire > 0 ) {
        $redis->setTimeout($redis_key, 3600);
    }
}

function redis_set_value($redis_key,$value,$expire = 0)
{
    global $redis;
    $redis->set($redis_key,$value);
    if ($expire > 0 ) {
        $redis->setTimeout($redis_key, 3600);
    }
}

function redis_get_hash($redis_key)
{
    global $redis;
    return $redis->hgetall($redis_key);
}

function redis_set_hash($redis_key,$values,$expire = 0)
{
    global $redis;
    $redis->hmset($redis_key,$values);
    if ($expire > 0 ) {
        $redis->setTimeout($redis_key, 3600);
    }
}
//-2:已经超时
//-1没找到
function redis_get_cache($key,$typ,$is_user=1,$special_refresh_interval=0)
{
    global $redis;
    global $session_config,$zone_id,$g_version_op,$g_banben,$sys_id,$g_is_public;
    $ts = time();
    //if ($g_is_public==0){
    //    return -1;
    //}
    if ($is_user==0){
        //系统缓存走腾讯的CMEM,或者联运的另外一个
        $memcache_obj = cmem_conn();
        if ( $rst = $memcache_obj->get($key.'_'.$typ))
        {
            return array('data'=>$rst);
        } else {
            return -1;
        }
    } else {
        $memcache_obj = mcached_conn();
        if ($memcache_obj==false){
            return -1;
        }
        if( $rst = memcache_version_get($memcache_obj, md5($sys_id.'_'.$key.'_'.$typ)) )
        {
            $rst['sync_memcache'] = 0;
            if ($ts - $rst['last_sync_memcache_zeit'] > $session_config['memcache_sync_time']) {
                $rst['last_sync_memcache_zeit'] = $ts;
                memcache_version_set($memcache_obj, md5($sys_id.'_'.$key.'_'.$typ),$rst,MEMCACHE_COMPRESSED,$session_config['memcache_store_time']);
                $rst['sync_memcache']=1;
            }
            if ($special_refresh_interval!=0){
                $out_of_date_time = $special_refresh_interval;
            } elseif ($is_user==1){
                $out_of_date_time = $session_config['update_session_time'];
            } else {
                $out_of_date_time = $session_config['update_global_cache_time'];
            }
            if ($ts - $rst['last_update_zeit'] > $out_of_date_time) {

                if ($special_refresh_interval!=0){

                    $rst['last_update_zeit'] = $ts;

                    $rst['last_sync_memcache_zeit'] = $ts;

                    memcache_version_set($memcache_obj, md5($sys_id.'_'.$key.'_'.$typ),$rst,MEMCACHE_COMPRESSED,$session_config['memcache_store_time']);

                }

                return -2;

            } else {
                return $rst;
            }
        } else {
            return -1;
        }
    }
}

function redis_set_cache($key,$typ,$value,$is_user=1)
{
    global $zone_id,$is_testing,$g_banben,$sys_id;
    global $session_config,$g_is_public;
    // if ($g_is_public==0){
    //    return -1;
    //}
    if ($is_user==0){
        //系统缓存走腾讯的CMEM
        $memcache_obj = cmem_conn();
        //if($g_banben==1){
            if ( $rst = $memcache_obj->set($key.'_'.$typ,$value,0,0))
            {
                return $rst;
            } else {
                return -1;
            }
        //}else{
        //    if ( $rst = $memcache_obj->set($sys_id.'_'.$key.'_'.$typ,$value,0,0))
        //    {
        //        return $rst;
        //    } else {
        //        return -1;
        //    }
        //}
    } else {
        $ts = time();
        $rst['data'] = $value;
        $rst['last_sync_memcache_zeit'] = $ts;
        $rst['last_update_zeit'] = $ts;
        $rst['sync_memcache'] = 0;
        $memcache_obj = mcached_conn();
        if( memcache_version_set($memcache_obj, md5($sys_id.'_'.$key.'_'.$typ),$rst,MEMCACHE_COMPRESSED,$session_config['memcache_store_time']) )
        {
            return 1;
        } else {
            return -1;
        }
    }
}

function redis_set_sys_cache($key,$typ,$value,$check_online=1)
{
    global $zone_id,$sys_id;
    global $session_config;
    $ts = time();
    $rst['data'] = $value;
    $rst['last_sync_memcache_zeit'] = $ts;
    $rst['last_update_zeit'] = $ts;
    $rst['sync_memcache'] = 0;
    $rst['online']= $check_online;
    $memcache_obj = mcached_conn();
    if( memcache_version_set($memcache_obj, md5($sys_id.'_'.$key.'_'.$typ),$rst,MEMCACHE_COMPRESSED,$session_config['memcache_store_time']) )
    {
        return 1;
    } else {
        return -1;
    }
}

function redis_delete_cache($key,$typ)
{
    global $zone_id,$sys_id;
    $memcache_obj = mcached_conn();
    memcache_version_del($memcache_obj,md5($sys_id.'_'.$key.'_'.$typ));
}
?>
