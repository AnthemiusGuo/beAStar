<?
$uid = $_GET['uid'];
$redis_key = "user/ticket/".$uid;
$rst = $redis->setTimeout($redis_key, 3600);
if ($rst) {
	$json_rst['rstno'] = 1;
} else {
	$json_rst['data']['ticket'] = genTicket($uid);
	$json_rst['rstno'] = 1;
}

?>