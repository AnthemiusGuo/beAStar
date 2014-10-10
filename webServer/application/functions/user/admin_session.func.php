<?php
function get_admin_cookie(){
    global $config;
	//$uid:$sid:$admin_token:$admin_ts
	$config['srv_id'] =1;
    if (isset($_COOKIE[$config['srv_id'].'ADM'])){
		$str = $_COOKIE[$config['srv_id'].'ADM'];
		$str = strrev($str);
		$str = base64_decode($str);
		$array = explode(":", $str);
		return $array;
    } else {
	return array(0,0,0,0,0);
    }
    
}

//@uid  用户id
//@sid  session id
//@cid  cookie id
function set_admin_cookie($admin_id,$sid,$admin_ts,$admin_role){
	global $config,$public_key,$g_server_name;
        if ($g_server_name=='local'){
            $url_host = substr($_SERVER['HTTP_HOST'],strstr('.',$_SERVER['HTTP_HOST']));
        } else {
            $url_host = $_SERVER['HTTP_HOST'];
        }
	
	$admin_token = md5($admin_id.$sid.$admin_ts.$public_key);
    
    $str = "$admin_id:$sid:$admin_token:$admin_ts:$admin_role";
    $str = base64_encode($str);
    $str = strrev($str);
    setcookie($config['srv_id'].'ADM',$str,time()+3600*72,'/',$url_host);
}

function delete_admin_cookie(){
    global $config,$public_key;
    setcookie($config['srv_id'].'ADM','',0,'/');
}

function admin_get_user_base($admin_id){
	$sql = "SELECT * FROM admin_editor WHERE admin_uid = $admin_id";
	$rst = mysql_query($sql);
	if ($row = mysql_fetch_assoc($rst)){
		return $row;
	} else {
		return -1;
	}
}
?>
