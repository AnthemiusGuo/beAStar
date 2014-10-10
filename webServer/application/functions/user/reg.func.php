<?php

function user_reg_new_user($uuid,$uname,$login_name,$login_pwd){
	global $zeit,$cfg_reg;	 
	$sql = "INSERT INTO u_account
	(`uuid` ,`is_anonym` ,`reg_zeit`, uname,level,exp,credits,total_credits,login_name,login_pwd)
	VALUES
	('$uuid', 0, $zeit,'$uname',0,0,$cfg_reg[credits],$cfg_reg[credits],'$login_name','$login_pwd' )";
	mysql_x_query($sql);
	$uid = mysql_insert_id();
	$account = array('uid'=>$uid,
					 'uuid'=>$uuid,
					 'is_anonym'=>0);
	
	$sql = "INSERT INTO u_user_extend
	(uid,json_data,probability_counter,online_keeps,last_login,last_online)
	VALUES
	($uid,'{}','{}',1,$zeit,$zeit)";
	mysql_x_query($sql);	
	return $account;
}




//-------------unfinished-----------//

function isexist_uname($uname){
	$sql = "SELECT uid FROM u_account WHERE uname = '$uname'";
	$result = mysql_x_query($sql);
	if(mysql_num_rows($result) > 0 ) {
		return true;
	}
	else {
		return false;
	}
}

function isexist_login_name($login_name){
	$sql = "SELECT uid FROM u_account WHERE login_name = '$login_name'";
	$result = mysql_x_query($sql);
	if(mysql_num_rows($result) > 0 ) {
		return true;
	}
	else {
		return false;
	}
}

function check_pp_uid_exists($uuid){
    global $zone_id;
    $sql = "SELECT uid FROM u_account WHERE pp_uid='$pp_uid' AND zone_id = $zone_id AND DOA<>-1";
    $rst = mysql_w_query($sql);
    if( mysql_num_rows($rst)>0){
            return true;
    }else{
            return false;
    }
}
?>
