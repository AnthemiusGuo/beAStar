<?php
include_once FR.'functions/user/user_info.func.php';
$exp = isset($_GET['exp'])?(int)$_GET['exp']:0;
$this_uid = isset($_GET['uid'])?(int)$_GET['uid']:$uid;


if($exp<=0){
    $json_rst = array('rstno'=>-1,'error'=>"input error");
    return;
}
user_add_exp($this_uid,$exp)