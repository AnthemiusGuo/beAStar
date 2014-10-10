<?php
$uid = (int)$_GET['uid'];
$user_base = user_get_user_base($uid);
$user_base['credits_pass']='';
 $user_base['lock_zeit'] = 0;
 $changes = array('credits_pass'=>$user_base['credits_pass'],'lock_zeit'=>0);
user_write_back_main_data($uid,$user_base,$changes);
?>