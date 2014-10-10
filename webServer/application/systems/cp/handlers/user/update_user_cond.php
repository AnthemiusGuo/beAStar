<?php
include_once FR.'functions/club/club.func.php';
$cid = (int)$_GET['user_uid'];
$club_info = club_get_club_info($cid);
if($admin_role!=1&&$admin_role!=4){
    $json_rst = array('rstno'=>-2,'error'=>'权限不够');
    return;
}
if(empty($club_info)){
    $json_rst = array('rstno'=>-1,'error'=>'玩家不存在');
    return;
}

if($club_info['is_robot']==3){
    $is_robot = 0;
}else if($club_info['is_robot']==0){
    $is_robot = 3;
}else {
    $json_rst = array('rstno'=>-3,'error'=>'玩家有误');
    return;
}
$sql = "UPDATE c_club_info SET is_robot=$is_robot WHERE cid=$cid";
mysql_w_query($sql);
_update_club_info($cid);
?>