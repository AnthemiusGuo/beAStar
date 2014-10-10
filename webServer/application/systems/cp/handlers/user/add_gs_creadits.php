<?php
include_once FR.'functions/club/club.func.php';
$cid = (int)$_GET['cid'];
$club_info = club_get_club_info($cid);
if(empty($club_info)||$club_info['is_robot']!=3){
    $json_rst = array('rstno'=>-1,'error'=>'data errer!');
    return;
}
$num = isset($_GET['num'])?(int)$_GET['num']:10000;
club_add_real_credits($cid,6,$num);
?>