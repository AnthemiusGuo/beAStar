<?php
$manager_id = isset($_GET['manager_id'])?(int)$_GET['manager_id']:0;

//删除管理员
$sql = "DELETE FROM admin_editor WHERE admin_uid=$manager_id";
mysql_w_query($sql);
include_once FR.'functions/news/news.func.php';
_update_week_news();
?>