<?php
include_once FR.'functions/item/item.func.php';
function pay_mc_conn(){
    global $config,$pay_mc_obj;
    if (isset($pay_mc_obj)){
        return $pay_mc_obj;
    }
    $pay_mc_obj = new Memcache;
    foreach ($config['pay_mc'] as $this_server){
        $pay_mc_obj->addServer($this_server['host'], $this_server['port']);
    }
    return $pay_mc_obj;
}

function pay_mc_set($open_id,$token){
    $key = "token_".QQ_APP_ID.'_'.$open_id.'_'.$token;
    $memcache_obj = pay_mc_conn();
    if ( $rst = $memcache_obj->set($key,1,0,0))
    {
        return true;
    } else {
        return false;
    }
}


function pay_build_qq_box($store_id,$this_store_name,$can_change_count=0){
    global $res_url_prefix,$zone_id,$aa_api_data,$pp_uid;
    $stor_item_info = item_sys_get_all_store_items();
    $this_item_num = $stor_item_info[$store_id]['item_num'];
    $this_item_name = $stor_item_info[$store_id]['item_name'];
    $item_id = $stor_item_info[$store_id]['item_id'];
    
    $qq_item_name = $zone_id.'_'.$store_id.'*'.$stor_item_info[$store_id]['price_qq'].'*1';
    $this_item_desc = $stor_item_info[$store_id]['item_desc'];
    $qq_item_desc = $this_store_name.'*'.$this_item_desc;
    if ($stor_item_info[$store_id]['item_typ']==4||$store_id==20){
        $qq_url = $res_url_prefix.'qq/app_ico_100.png';
    } else if ($stor_item_info[$store_id]['item_typ']==6){
        $qq_url = $res_url_prefix.'images/shop/pay_'.$store_id.'.png';
    }else {
        $qq_url = $res_url_prefix.'images/shop/item_'.$item_id.'.png';
    }
    
    //params['manyouid']: 1: 赠送;0:自己购买;
    //params['manyouid'] 漫游ID;
    //params['device']: 0表示web，1表示手机，默认为0;
    //params['zoneid']: 分区ID，可以不用。
    
    $qq_params['zoneid'] = 0;
    //$qq_params['amttype'] = 'coin';
    if ($can_change_count==0){
        $appmode = 1;
    } else {
        $appmode = 2;
    }
    $api_token = $aa_api_data->getPayTokenV3($qq_item_name,$appmode,$qq_item_desc,$qq_url,$qq_params);
    
    if ($api_token==false){
        err_log('api_error for pay'.print_r($aa_api_data->getError(1,1),true));
        $json_rst = array('rstno'=>-7,'error'=>_('API错误'));
        return $json_rst;
    }
    if (!pay_mc_set($pp_uid,$api_token['token'])){
        $json_rst = array('rstno'=>-8,'error'=>_('MC错误'));
        return $json_rst;
    };
    $json_rst = array('rstno'=>1,'special_rstno'=>1);
    $json_rst['url_param'] = $api_token['url_params'];
    $json_rst['content_param'] = $store_id;
    return $json_rst;
}
function pay_build_qq_box_base($qq_item_name,$appmode,$qq_item_desc,$qq_url,$qq_params){
    global $res_url_prefix,$zone_id,$aa_api_data,$pp_uid;
    $api_token = $aa_api_data->getPayTokenV3($qq_item_name,$appmode,$qq_item_desc,$qq_url,$qq_params);    
    if ($api_token==false){
        err_log('api_error for pay'.print_r($aa_api_data->getError(1,1),true));
        $json_rst = array('rstno'=>-7,'error'=>_('API错误'));
        return $json_rst;
    }
    if (!pay_mc_set($pp_uid,$api_token['token'])){
        $json_rst = array('rstno'=>-8,'error'=>_('MC错误'));
        return $json_rst;
    };
    $json_rst = array('rstno'=>1,'special_rstno'=>1);
    $json_rst['url_param'] = $api_token['url_params'];
    $json_rst['content_param'] = $store_id;
    return $json_rst;
}
?>