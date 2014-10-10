<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
</head>
<body>
<?php
 
$g_access_mode = -1;
include_once 'processes/base_init.process.php';
include_once FR.'config/server/'.$g_server_name.'.config.php';
include_once FR.'processes/lang.init.process.php';
include_once FR.'functions/common/base.func.php';
include_once FR.'functions/common/db.func.php';
include_once FR.'functions/user/user_info.func.php';
include_once FR.'functions/zha/zha.func.php';
include_once FR.'functions/log/zha.log.php';
base_prepare();
db_connect();
$zeit = time();
$sql_insert = array();
$sql ="DELETE FROM st_date_srv";
mysql_w_query($sql);
for($i=1;$i<=1000;$i++){
    $time = $zeit + ($i-1)*86400;
    $date = (int)date("Ymd",$time);
    $sql_insert[] = "($date,0,0,0)";    
}
$sql = "INSERT INTO st_date_srv(date,sys_send,sys_win,sys_lost) VALUES ".implode(',',$sql_insert);
print($sql);
mysql_w_query($sql);
echo "true";
?>
</body>
</html>
    