<?php
$cid = (int)$_GET['cid'];
$club_info = club_get_club_info($cid);
if(empty($club_info)||$club_info['is_robot']!=3){
    $json_rst = array('rstno'=>-1,'error'=>'data errer!');
    return;
}
if($is_testing){
    $sql = "INSERT INTO `st_pay_price` (cid,cost_price,get_credits,zeit) VALUE($cid,1000,1000,$zeit);";
    mysql_w_query($sql);
}else{
    $sql = "INSERT INTO `st_pay_price_cheat` (cid,cost_price,get_credits,zeit) VALUE($cid,100,1000,$zeit);";
    mysql_w_query($sql);
}