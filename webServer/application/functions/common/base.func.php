<?
include_once FR."functions/common/base.func.php";
include_once AR."functions/user/user_info.func.php";

function genTicket($uid){
	global $redis;
	$now = time();
	$redis_key = "user/ticket/".$uid;
	$ticket = md5(substr(md5($now.$uid."XWR555"),5,32-5));
	$redis->set($redis_key,$ticket);
	//一小时过期
	$redis->setTimeout($redis_key, 3600);
	return $ticket;
}