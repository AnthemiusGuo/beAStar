<?php
//现在不考虑负载均衡和down机，先看直接取模分配
function lobby_get_lobby_by_uid($uid){
	$redis_key = "user/lobby/"+$uid;
	$ret = redis_get_value($redis_key);
	if ($ret == null) {
		return lobby_find_lobby_by_uid($uid);
	}
	return $ret;
}

function lobby_find_lobby_by_uid($uid){
	global $config;
	$allLobbies = array_values($config['lobby']);
	$count = count($allLobbies);

	$lobbyId = $allLobbies[ hexdec($uid) % $count ]["id"];

	$redis_key = "user/lobby/"+$uid;
	redis_set_value($redis_key,$lobbyId);

	return $lobbyId;
}

?>