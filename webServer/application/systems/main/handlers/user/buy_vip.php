<?php
$typ = isset($_GET['typ'])?(int)$_GET['typ']:0;
if(!in_array($typ,array(1,2,3))){
    $json_rst = array('rstno'=>0,'error'=>'data error!');
    return;
}

//to do ��ʵ��Ǯ �� ���ɶ���


$credits = user_buy_vip($uid,$typ);
$json_rst['credits'] = $credits;