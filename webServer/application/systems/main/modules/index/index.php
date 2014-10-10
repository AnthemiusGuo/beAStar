<?php
$pre_loader = array(
    //array('typ'=>'swf','url'=>$res_url_prefix.'images/flash/framework_4.6.0.22920.swf'),
    //array('typ'=>'swf','url'=>$res_url_prefix.'images/flash/textLayout_2.0.0.232.swf')
);
$rand_index = mt_rand(1,10000);

$login_zeit = $zeit;
$token = substr(md5($login_zeit.md5($public_key.$rand_index.$uid)),0,16);
$login_token_str = $token.'|'.$login_zeit.'|'.$rand_index;


//获取是否需要弹窗领礼包



?>