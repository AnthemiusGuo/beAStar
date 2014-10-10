<?php
$uid = (int)$_GET['uid'];
$json_rst['user'] = user_get_user_for_sock($uid);
?>