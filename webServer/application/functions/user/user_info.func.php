<?
include_once AR.'config/define/user.define.php';
include_once FR.'functions/common/memcache.func.php';
include_once FR.'functions/common/ubbcode.func.php';
include_once AR.'functions/user/user_session.func.php';

function user_get_user_device_account_by_uuid($uuid){
	$user_account = get_cache($uuid,'u_account_devices',1);
	if ($user_account ==-1 || $user_account ==-2) { 
	    $user_account = user_load_device_account_by_uuid($uuid); 
	} else { 
	    $user_account = $user_account['data']; 
	}	
	return $user_account;
}
function user_load_device_account_by_uuid($uuid){
	$sql = "SELECT * FROM u_account_devices WHERE uuid='$uuid'";
	$rst = mysql_w_query($sql);
	$user_account = array();
	while ($row = mysql_fetch_assoc($rst)){
		$user_account[$row['uid']] = $row;
	}
	if(!empty($user_account)){
		set_cache($uuid,'u_account_devices',$user_account,1);
	}
	return $user_account;
	
}

function user_insert_into_device($uuid,$uid){
	$user_account = user_get_user_device_account_by_uuid($uuid);
	if(!isset($user_account[$uid])){
		$sql = "INSERT INTO u_account_devices (uuid,uid) VALUES ('$uuid',$uid)";
		mysql_w_query($sql);
		$user_account[$uid] = array('uuid'=>$uuid,'uid'=>$uid);
		set_cache($uuid,'u_account_devices',$user_account,1);
		return true;
	}
	return false;
	
}

function user_get_header_info($uid){
		return array();
}
function user_get_user_base($uid,$need_online=0){
	global $g_users_base,$zeit;
	if (isset($g_users_base[$uid])){
	    return $g_users_base[$uid];
	}
	$user_info_base = get_cache($uid,'user_base_info',1);
    $user_info_base = -1;
	if ($user_info_base ==-1 || $user_info_base ==-2) { 
	    $user_info_base = user_update_user_base($uid); 
	} else { 
	    $user_info_base = $user_info_base['data']; 
	}	
	$g_users_base[$uid] = $user_info_base;
	return $user_info_base;

} 


function user_update_user_base($uid){ 
	global $g_users_base;  
	$sql = "SELECT * FROM u_account  WHERE uid = '$uid'";
	$rst = mysql_w_query($sql);
	if ($row_user_base = mysql_fetch_assoc($rst)){
		$row_user_base['credits_locked'] = 0;
		set_cache($uid,'user_base_info',$row_user_base,1);
		$g_users_base[$uid] = $row_user_base;
		return $row_user_base;
	} else {
		return array();
	} 
}

function user_get_user_for_sock($uid){
	global $res_url_prefix;
	$user_info = user_get_user_base($uid);
	$cfg_show_to_other = array('credits','is_robot',
		                        'level','vip_level',
		                        'pp_uid','uname','uid','uuid',
		                        'avatar_id','avatar_url');
	$return = array();
	foreach ($cfg_show_to_other as $key) {
		$return[$key] = $user_info[$key];
	}
	if ($return['avatar_url']==''){
		$return['avatar_url'] = $res_url_prefix.'images/avatar/'. $return['avatar_id'].'.png';
	}
	return $return;
}

function user_get_user_show($uid,$show_credits=0,$is_myself=0){
	global $res_url_prefix;
	$user_info = user_get_user_base($uid);
	if(empty($user_info)){
		return array();
	}
	if ($user_info['avatar_id']>0){
		$user_info['avatar_url'] = $res_url_prefix.'images/avatar/'. $user_info['avatar_id'].'.png';
	}
	return array('uname'=>$user_info['uname'],
				'vip_level'=>$user_info['vip_level'],
			'uid'=>$uid,
			'level'=>$user_info['level'],
            'exp'=>$user_info['exp'],
            'exp_len'=>0,
			'credits'=>($show_credits==1)?$user_info['credits']:0,
			'credits_in_box'=>($is_myself==1)?$user_info['credits_in_box']:0,
			'total_credits'=>($is_myself==1)?$user_info['total_credits']:0,
			'credits_show'=>($show_credits==1)?common_get_zipd_number($user_info['credits']):0,
			'avatar_url'=>$user_info['avatar_url'],
			'avatar_id'=>$user_info['avatar_id'],
			'show_uid'=>user_get_display_uid($uid),
			'is_anonym'=>$user_info['is_anonym']
    );
}
 

function user_write_back_main_data($uid,$user_info,$change_list=array()){
    global $g_users_base;
	$sql_plus = array();
    foreach ($change_list as $key=>$val){
        if ($key == 'credits_locked'){
            continue;
        }
        $sql_plus[] = "$key = '".$user_info[$key]."' ";
    }
	$g_users_base[$uid] = $user_info;
    set_cache($uid,'user_base_info',$user_info,1);
	
    if (count($sql_plus)==0){
        return;
    }
    
    $sql = "UPDATE u_account SET ".implode(',',$sql_plus)." WHERE uid=$uid";
    mysql_x_query($sql);    
}

function user_write_back_extend_data($uid,$user_extend_info, $change_list=array()){
    global $g_users_extend,$g_user_extend;
    //$arr = array_diff_assoc($user_extend_info,$g_users_extend[$uid]);        
    $skip = array('week_day');
    $sql_plus = array();
    if(!empty($change_list)){
        foreach ($change_list as $this_key=>$this_val){
            if (in_array($this_key,$skip)){
				continue;
			}
			$sql_plus[] = "$this_key = '".$user_extend_info[$this_key]."' ";
        }
    }else{
        $arr = array_diff_assoc($user_extend_info,$g_users_extend[$uid]);
        foreach($arr as $this_key=>$val){
            if($this_key=='week_day'){
                continue;
            }else{
                $sql_plus[] = "$this_key = '".$user_extend_info[$this_key]."'";
            }
        }
    }
    if (count($sql_plus)==0){
        return $user_extend_info;
    }
    $g_users_extend[$uid] = $user_extend_info;
    $g_user_extend = $user_extend_info;
    set_cache($uid,'user_extend_info',$user_extend_info,1); 
    $sql = "UPDATE u_user_extend SET ".implode(',',$sql_plus)." WHERE uid=$uid";  
    mysql_x_query($sql);
    return $user_extend_info;
}

function user_get_user_extend($uid,$need_online=0){
    global $g_users_extend,$zeit,$cfg_refresh_energy_zeit;
    if (isset($g_users_extend[$uid])){
        return $g_users_extend[$uid];
    }
    $user_info_extend = get_cache($uid,'user_extend_info',1);
	$user_info_extend = -1;
    if ($user_info_extend ==-1 || $user_info_extend ==-2) { 
        $user_info_extend = user_update_user_extend($uid);
    } else {
        $user_info_extend = $user_info_extend['data'];
    } 
    $g_users_extend[$uid] = $user_info_extend;
    return $user_info_extend;
}

function user_update_user_extend($uid){
	global $g_users_extend;	
	$sql = "SELECT * FROM u_user_extend WHERE uid = '$uid'";
	$rst = mysql_x_query($sql);
	if ($row_user_base = mysql_fetch_assoc($rst)){
        set_cache($uid,'user_extend_info',$row_user_base,1);
        $g_users_extend[$uid] = $row_user_base;
        return $row_user_base;
	} else {
		return false;
	}

}

function user_delete_user($uid){
    global $zeit;
    //目前只考虑删除未过新手期的用户，牵扯到的表较少
    $sql = "SELECT pid FROM p_player WHERE cid = $uid";
    $rst = mysql_x_query($sql);
    $pids = array();
    while ($row = mysql_fetch_assoc($rst)){
        $pids[] = $row['pid'];
    }
    if (empty($pids)){
        return -1;
    }
    $pid_list = implode(',',$pids);
    
    $sql = "DELETE FROM p_player WHERE pid IN ($pid_list)";
    mysql_x_query($sql);
    $sql = "DELETE FROM p_player_base_attr WHERE pid IN ($pid_list)";
    mysql_x_query($sql);
    $sql = "DELETE FROM p_player_final_attr WHERE pid IN ($pid_list)";
    mysql_x_query($sql);
    $sql = "DELETE FROM p_player_middle_attr WHERE pid IN ($pid_list)";
    mysql_x_query($sql);
    $sql = "DELETE FROM p_player_skill WHERE pid IN ($pid_list)";
    mysql_x_query($sql);
    $sql = "DELETE FROM p_player_train WHERE pid IN ($pid_list)";
    mysql_x_query($sql);
    
    
    $sql = "DELETE FROM p_player_youth WHERE  cid=$uid";
    mysql_x_query($sql);
    $sql = "DELETE FROM p_player_youth_study WHERE  cid=$uid";
    mysql_x_query($sql);
    $sql = "DELETE FROM p_player_youth_study_site WHERE cid=$uid";
    mysql_x_query($sql);
    
    
    $sql = "DELETE FROM c_club_info WHERE cid=$uid";
    mysql_x_query($sql);
    $sql = "DELETE FROM c_formation WHERE cid=$uid";
    mysql_x_query($sql);
    $sql = "DELETE FROM c_fixture WHERE cid=$uid OR op_cid=$uid";
    mysql_x_query($sql); 
    $sql = "DELETE FROM c_squad WHERE cid=$uid";
    mysql_x_query($sql);
    $sql = "DELETE FROM c_tactic WHERE cid=$uid";
    mysql_x_query($sql);
    $sql = "DELETE FROM c_team_employees WHERE cid=$uid";
    mysql_x_query($sql);
    
    $sql = "DELETE FROM st_player_statistics WHERE cid=$uid";
    mysql_x_query($sql);
    
    
    $sql = "DELETE FROM c_ins_history WHERE cid=$uid";
    mysql_x_query($sql);
    $sql = "DELETE FROM c_ins_league_table WHERE ins_uid=$uid";
    mysql_x_query($sql);
    $sql = "DELETE FROM c_ins_match_fixture WHERE ins_uid=$uid";
    mysql_x_query($sql);
    
    $sql = "DELETE FROM e_user WHERE uid=$uid";
    mysql_x_query($sql);
    $sql = "DELETE FROM feed_detail_user_news WHERE uid=$uid";
    mysql_x_query($sql);    
    $sql = "DELETE FROM t_task WHERE uid=$uid";
    mysql_x_query($sql);
    $sql = "DELETE FROM t_task_step WHERE uid=$uid";
    mysql_x_query($sql);
    $sql = "DELETE FROM u_user_extend WHERE uid=$uid";
    mysql_x_query($sql);    
    $sql = "DELETE FROM u_item WHERE cid=$uid";
    mysql_x_query($sql);
    
    
    $sql = "UPDATE u_account SET pp_uid='DELETED' WHERE uid=$uid";
    mysql_x_query($sql);
    $sql = "UPDATE u_account SET pp_uid='DELETED',DOA=-1,DOA_zeit=$zeit WHERE uid=$uid";
    mysql_x_query($sql);
    
    delete_cache($uid,'user_base_info');
    delete_cache($uid,'user_extend_info');
    return;
}

function send_chat($typ,$uid,$pf,$uname,$data,$zeit){
    global  $zone_id;
    $new_data = array('typ'=>$typ,'uid'=>$uid,'pf'=>$pf,'uname'=>$uname,'data'=>$data,'zeit'=>$zeit,'zeit_show'=>format_date_time($zeit,3));    
    $chat_cache = get_cache($zone_id,'sys_chat_world',0);
    $chat_id = 1;
    if ($chat_cache == -1 || $chat_cache==-2){
        $chat_cache = array();
    } else {
        $chat_cache = $chat_cache['data'];
        $chat_count = count($chat_cache);
        $chat_id = $chat_cache[$chat_count-1]['chat_id']+1;
        if ($chat_count>=15){
            array_shift($chat_cache);
        }  
    }
    $new_data['chat_id'] = $chat_id;
    $chat_cache[] =  $new_data;
    
    set_cache($zone_id,'sys_chat_world',$chat_cache,0);
    return $chat_cache;
}

//$main_typ 10 各种下注赢，11各种下注输，20：收到赠送，21 赠送别人  30 取钱 31 存钱 40 系统赠送 50 购买 60使用（聊天）
//$typ: 101:诈金花 下注赢，102，下注输 103 炸金花 庄家赢 104 庄家输 105 拉霸机下注 106 拉霸机换牌 107拉霸机结算
//201，202:赠送
//301，302:取存保险箱
//401, 注册赠送，402，每日赠送
//501 充值
//601 聊天金币代喇叭消耗
//注意cost<0是花钱，>0是加钱！
function change_credits($uid,$main_typ,$typ,$cost,$mapping_id,$log_info=array()){
	if ($uid<=0){
		return -1;
	}
	global $zeit,$g_sunrise;
	$user_base = user_get_user_base($uid);
	if ($user_base==false){
		#报错处理TODO
		return -1;	
	}
	
	if ($cost<0 && $user_base['credits']<(0-$cost)) {
		return -2;
	}
	if($main_typ==31){
		if($user_base['credits_in_box']<-$cost){
			return -3;
		}
	}
	//if ($main_typ==31){
	//	if($user_base['credits_in_box']<$cost){
	//		return -3;
	//	}
	//}
	$user_base['credits'] +=$cost;
    $user_base['credits_locked'] = 0;
    $change['credits_locked'] = 0;
	$change['credits'] = $user_base['credits'];
	if($main_typ==30||$main_typ==31){
		$user_base['credits_in_box'] -= $cost;
		$change['credits_in_box'] = $user_base['credits_in_box'];
	}else{
		$user_base['total_credits'] = $user_base['credits_in_box']+$user_base['credits'];
		$change['total_credits'] = $user_base['total_credits'];
	}
	if($main_typ==40){
		$user_base['credits_from_sys'] += $cost;
		$change['credits_from_sys'] = $user_base['credits_from_sys'];
        st_ser_change("sys_send",$cost);
        
	}
	user_write_back_main_data($uid,$user_base,$change);
	
	$sql = "INSERT INTO st_change_real_credits
    (`uid`, `main_typ`, `typ`, `credits`, `rest_credits`, `mapping_id`, `sunrise`, `zeit`)
    VALUES
    ($uid,$main_typ,$typ,$cost,$user_base[credits],$mapping_id,$g_sunrise,$zeit)";
    mysql_x_query($sql);
	if($main_typ==10||$main_typ==11){
		$date = date('Ymd',$zeit);
		$sql = "INSERT INTO  u_win_log (`date`, `uid`, `credits`) VALUES($date, $uid, $cost)
		ON DUPLICATE KEY UPDATE credits=credits+$cost";
		mysql_w_query($sql);
	}

    return $user_base['credits'];
}

//前一天输赢榜
function rank_get_user_rank_bywinners(){
	global $zeit,$sys_id;
	$date = date('Ymd',strtotime("-1 day"));
	$rank_list = get_cache($sys_id,'rank_bywinners',0);
	$rank_list = -1;
	if($rank_list==-1||$rank_list==-2){
		$rank_list = rank_update_winners_rank($date);
	}else{
		$rank_list = $rank_list['data'];		
	}
	
	return $rank_list;
}

function rank_update_winners_rank($date){
	global $sys_id;
	$sql = "SELECT * FROM u_win_log ORDER BY credits DESC LIMIT 50";
	$rst = mysql_w_query($sql);
	$rank_list = array();
	while($row = mysql_fetch_assoc($rst)){
		$rank_list[] = $row;
	}
	$this_rank_list = array();
	if(!empty($rank_list)){
		
		$i=1;
		
		foreach($rank_list as $k=>$info){
			$op_user = user_get_user_show($info['uid']);
			if(empty($op_user)){
				continue;
			}
			$info['uname'] = $op_user['uname'];
			$info['level'] = $op_user['level'];
			$info['avatar_id'] = $op_user['avatar_id'];
			$info['avatar_url'] = $op_user['avatar_url'];
			$info['rank'] = $i++;
			$this_rank_list[] = $info;
			
		}
	}
	set_cache($sys_id,'rank_bywinners',$this_rank_list,0);
	return $this_rank_list;
}


//富豪榜 30 分钟左右一更新
function rank_get_user_rank_bycredits(){
	global $sys_id;
	$rank_list = get_cache($sys_id,'rank_bycredits',0);
	$rank_list = -1;
	if($rank_list==-1||$rank_list==-2){
		$rank_list = rank_update_credits_rank();
	}else{
		$rank_list = $rank_list['data'];		
	}	
	return $rank_list;
}

function rank_update_credits_rank(){
	global $sys_id;
	$sql = "SELECT uid,uname,level,total_credits AS credits FROM u_account ORDER BY total_credits DESC LIMIT 50";
	$rst = mysql_w_query($sql);
	$rank_list = array();
	$i = 1;
	while($row = mysql_fetch_assoc($rst)){
		$rank_list[] = $row;
	}
	$this_rank_list = array();
	foreach($rank_list as $k=>$info){
		$op_user = user_get_user_show($info['uid']);
		if(empty($op_user)){
			continue;
		}
		$info['uname'] = $op_user['uname'];
		$info['level'] = $op_user['level'];
		$info['avatar_id'] = $op_user['avatar_id'];
		$info['avatar_url'] = $op_user['avatar_url'];
		$info['rank'] = $i++;
		$this_rank_list[] = $info;
		
	}
	set_cache($sys_id,'rank_bycredits',$this_rank_list,0);
	return $this_rank_list;
}

function user_add_exp($uid,$exp){
    global $cfg_user_level_exp,$cfg_user_level_max;
    $user_info = user_get_user_base($uid);
    $now_level = $user_info['level'];
    $now_exp = $user_info['exp']+$exp;

    $user_info['exp'] = $now_exp;
    $changes = array('exp'=>1);
	if($now_level>=5){
		//5级解锁幸运宝箱
		if(date('w')==6){
			$date_start = date("Ymd");
		}else{
			$date_start = date("Ymd",strtotime("last Saturday"));
		}
		$info = array();
		$info = user_get_lucky_chest_info($uid,$date_start);
		if(empty($info)){
			$info['uid'] = $uid;
			$info['date_start'] = $date_start;
			$info['add_exp_all'] = $exp;
			$info['end_exp'] = $now_exp;
			$insert_or_update = 0;
		}else{
			$info['add_exp_all'] += $exp;
			$info['end_exp'] = $now_exp;
			$insert_or_update = 1;
		}
		user_set_lucky_chest_info($uid,$date_start,$info,$insert_or_update);		 
		
	}
	$temp_level = $now_level;
    if ($now_level<$cfg_user_level_max){ 
        for ($i=$now_level+1;$i<$cfg_user_level_max;$i++) {
            if ($now_exp<$cfg_user_level_exp[$i]){
                break;
            }
            $temp_level = $i;
        }
        if ($temp_level>$now_level){
            //升级了！
            $user_info['level'] = $temp_level;
            $changes['level'] = $temp_level;
        }
    }
    
    user_write_back_main_data($uid,$user_info,$changes);
	return $temp_level;

}

function user_get_strongboxlog($uid){
	$user_strongboxlog = get_cache($uid,'u_strongbox_log',1);
	if ($user_strongboxlog ==-1 || $user_strongboxlog ==-2) { 
	    $user_strongboxlog = user_update_user_strongboxlog($uid); 
	} else { 
	    $user_strongboxlog = $user_strongboxlog['data']; 
	}
	return $user_strongboxlog;
}

function user_update_user_strongboxlog($uid){
	$user_strongboxlog = array();
	$sql = "SELECT * FROM u_strongbox_log WHERE uid=$uid ORDER BY zeit DESC limit 20";
	$rst = mysql_w_query($sql);	
	while($row = mysql_fetch_assoc($rst)){
		$user_strongboxlog[] = $row;
	}
	set_cache($uid,'u_strongbox_log',$user_strongboxlog,1);
	return $user_strongboxlog;
}


function user_get_user_buddy_list($uid){
	$user_buddy = get_cache($uid,'u_buddy',1);
	$user_buddy = -1;
	if ($user_buddy ==-1 || $user_buddy ==-2) { 
	    $user_buddy = user_update_user_buddy_list($uid); 
	} else { 
	    $user_buddy = $user_buddy['data']; 
	}
	return $user_buddy;
}

function user_update_user_buddy_list($uid){
	$user_buddy = array();
	$sql = "SELECT * FROM u_buddy WHERE uid=$uid";
	$rst = mysql_w_query($sql);
	while($row = mysql_fetch_assoc($rst)){
		$user_buddy[] = $row['op_uid'];
	}
	set_cache($uid,'u_buddy',$user_buddy,1);
	return $user_buddy;
}

function user_add_friend($uid,$op_uid){
	$sql = "SELECT uid FROM u_buddy WHERE uid=$uid AND op_uid=$op_uid";
	$rst = mysql_w_query($sql);
	if(mysql_num_rows($rst)>0){
		return 0;//已经是你好友
	}
	$user_buddy = user_get_user_buddy_list($uid);
	if(!empty($user_buddy)){
		if(in_array($op_uid,$user_buddy)){
			return 0;//已经是你好友
		}
	}
	
	$user_buddy[] = $op_uid;
	set_cache($uid,'u_buddy',$user_buddy,1);
	$sql = "INSERT INTO u_buddy (uid,op_uid) VALUES ($uid,$op_uid)";
	mysql_w_query($sql);
	return 1;//添加好友成功
}
function user_del_friend($uid,$op_uid){
	$user_buddy = user_get_user_buddy_list($uid);
	if(!empty($user_buddy)){
		if(!in_array($op_uid,$user_buddy)){
			return 0;//已经是你好友
		}
	}else{
		return 0;
	}
	if(!empty($user_buddy)){
		foreach($user_buddy as $key=>$this_uid){
			if($this_uid!=$op_uid){
				$user_buddys[] = $this_uid;
			}		
		}
	}else{
		return 0;
	}
	
	set_cache($uid,'u_buddy',$user_buddys,1);
	$sql = "DELETE FROM u_buddy WHERE uid=$uid AND op_uid=$op_uid";
	mysql_w_query($sql);
	return 1;//添加好友成功
 
}
function user_buy_vip($uid,$typ){
	global $zeit;
	$g_sunrise = $zeit-($zeit+8*3600)%86400;
	$g_sunset = $g_sunrise + 86399;
	$user_base = user_get_user_base($uid);
	if($typ==1){
		//买铜牌
		$change_credits = 110000;
	}else if($typ==2){
		$change_credits = 1200000;
	}else if($typ==3){
		$change_credits =6250000;
	}
	if($user_base['vip_level']<$typ){
		$user_info_base['vip_level'] = $change['vip_level'] = $typ;		
	}
	if($user_base['vip_end_zeit']<$zeit){
		$user_base['vip_end_zeit'] = $change['vip_end_zeit'] = ($g_sunset + 7*86400);
	}else{
		$user_base['vip_end_zeit']+=7*86400;
		$change['vip_end_zeit'] = $user_base['vip_end_zeit'];
	}
	user_write_back_main_data($uid,$user_base,$change);
	change_credits($uid,50,501,$change_credits,$typ);
	return $change_credits;
}

function user_get_lucky_chest_info($uid,$date_start){
	$lucky_box_info = get_cache($uid.'_'.$date_start,'u_lucky_chest',1);
	$lucky_box_info =-1;
	if($lucky_box_info==-1||$lucky_box_info==-2){
		$lucky_box_info = user_update_lucky_chest_info($uid,$date_start);
	}else{
		$lucky_box_info = $lucky_box_info['data'];
	}
	return $lucky_box_info;
	
}

function user_update_lucky_chest_info($uid,$date_start){
	$lucky_box_info = array();
	$sql = "SELECT * FROM u_lucky_chest WHERE uid=$uid AND date_start=$date_start";
	$rst = mysql_w_query($sql);
	if($row = mysql_fetch_assoc($rst)){
		$lucky_box_info = $row;
	}
	set_cache($uid.'_'.$date_start,'u_lucky_chest',$lucky_box_info,1);
	return $lucky_box_info;
}

function user_set_lucky_chest_info($uid,$date_start,$info,$insert_or_update=1){
	if(!isset($info['status'])){
		$status = $info['status'] = 0;
	}else{
		$status = $info['status'];
	}
	$info['uid'] = $uid;
	$info['date_start'] = $date_start;
	set_cache($uid.'_'.$date_start,'u_lucky_chest',$info,1);
	if($insert_or_update==0){
		$sql = "INSERT INTO u_lucky_chest(uid,date_start,add_exp_all,end_exp,status) VALUES
				($uid,$date_start,{$info['add_exp_all']},{$info['end_exp']},$status)
				ON DUPLICATE KEY UPDATE add_exp_all={$info['add_exp_all']},end_exp={$info['end_exp']},status=$status";
		mysql_w_query($sql);
	}else{
		$sql = "UPDATE u_lucky_chest SET add_exp_all={$info['add_exp_all']},end_exp={$info['end_exp']},status=$status
				WHERE uid=$uid AND date_start=$date_start";
		mysql_w_query($sql);
	}
	//$sql = "INSERT INTO u_lucky_chest(uid,date_start,add_exp_all,end_exp,status) VALUES
	//			($uid,$date_start,{$info['add_exp_all']},{$info['end_exp']},$status)
	//			ON DUPLICATE KEY UPDATE add_exp_all={$info['add_exp_all']},end_exp={$info['end_exp']},status=$status";
	//mysql_w_query($sql);
}
//推广的伙伴
function user_get_user_intro_list($uid,$need_refresh=0){
	if($need_refresh==1){
		$intro_list = user_reload_user_intro_list($uid);
		return $intro_list;
	}
	global $g_user_intro_list;
	if(isset($g_user_intro_list[$uid])){
		return $g_user_intro_list[$uid];
	}
	$intro_list = get_cache($uid,'u_intro_list_by_intro',1);
	$intro_list = -1;
	if($intro_list==-1||$intro_list==-2){
		$intro_list = user_reload_user_intro_list($uid);
	}else{
		$intro_list = $intro_list['data'];
	}
	$g_user_intro_list[$uid] = $intro_list;
	return $intro_list;
}
//推广的伙伴
function user_reload_user_intro_list($uid){
	$intro_list = array();
	$sql = "SELECT * FROM  u_intro_list WHERE intro_uid=$uid";
	$rst = mysql_w_query($sql);
	while($row = mysql_fetch_assoc($rst)){
		$intro_list[] = $row;
	}
	set_cache($uid,'u_intro_list_by_intro',$intro_list,1);
	return $intro_list;
}

//计算个人幸运宝箱金币数量
function user_get_lucky_chest_credits($exp_first,$end_exp,$add_exp_all){
	global $cfg_user_level_max,$cfg_lucky_chest_rate,$cfg_user_level_exp;
        //$end_exp = $lucky_chest_info['end_exp'];
	if($exp_first>=$cfg_user_level_exp[$cfg_user_level_max]){
		$first_level = $cfg_user_level_max;
		$credits = round(($add_exp_all*$cfg_lucky_chest_rate[$first_level])/100);		
		return $credits;
	}else{
		$first_level = 5;
		for ($i=5;$i<$cfg_user_level_max;$i++) {
			if ($exp_first<$cfg_user_level_exp[$i+1]){
				break;
			}
			$first_level = $i;
		}
	}
	if($exp_first<$cfg_user_level_exp[5]){
		$exp_first = $cfg_user_level_exp[5];
	}
	if($end_exp>=$cfg_user_level_exp[$cfg_user_level_max]){
		$end_level = $cfg_user_level_max;
	}else{
		$end_level = $first_level;
		for ($i=$first_level;$i<$cfg_user_level_max;$i++) {
			if ($end_exp<$cfg_user_level_exp[$i+1]){
				break;
			}
			$end_level = $i;
		}
	}
   
	if($first_level==$end_level){            
		$credits = round(($add_exp_all*$cfg_lucky_chest_rate[$first_level])/100);
		return $credits;
	}
	$add_credits = 0;
	for($i=$first_level;$i<=$end_level;$i++){
		if($i==$first_level){
			$add_credits += ($cfg_user_level_exp[$first_level+1]-$exp_first)*$cfg_lucky_chest_rate[$i]/100;
		}else if($i==$end_level){
			$add_credits += ($end_exp-$cfg_user_level_exp[$end_level])*$cfg_lucky_chest_rate[$i]/100;
		}else{
			$add_credits += ($cfg_user_level_exp[$i+1]-$cfg_user_level_exp[$i])*$cfg_lucky_chest_rate[$i]/100;
		}
	}
	$credits = round($add_credits);
	return $credits;
}

function user_calculate_intro_credits($exp_first,$end_exp,$add_exp_all){
	global $cfg_user_level_max,$cfg_lucky_chest_rate,$cfg_user_level_exp;
	if($end_exp<$cfg_user_level_exp[8]){
		return 0;
	}else if($end_exp<$cfg_user_level_exp[10]){
		return 10000; //10级以前贡献 10000
	}else if($end_exp<=$cfg_user_level_exp[12]){
		return 50000; //12级以前贡献 50000
	}
	$level = 12;
	for ($i=12;$i<$cfg_user_level_max;$i++) {
		if ($end_exp<$cfg_user_level_exp[$i+1]){
			break;
		}
		$level = $i;
	}
	$all_credits = 0;
	if($level < 15){
		$all_credits_rat = 0.1;//15级以前
		$all_credits = $add_exp_all*$all_credits_rat;
	}else if($level < 18){
		$all_credits_rat = 0.12;//18级以前
		if($exp_first >= $cfg_user_level_exp[15]){
			$all_credits = $add_exp_all*$all_credits_rat;
		}else{
			$all_credits = ($end_exp-$cfg_user_level_exp[15])*0.12
							+ ($cfg_user_level_exp[15]-$exp_first)*0.1;
		}
	}else if($level < 20){
		$all_credits_rat = 0.15;
		if($exp_first >= $cfg_user_level_exp[18]){
			$all_credits = $add_exp_all*$all_credits_rat;
		}else if($exp_first >= $cfg_user_level_exp[15]){
			$all_credits = ($end_exp-$cfg_user_level_exp[18])*0.15
						+ ($cfg_user_level_exp[18]-$exp_first)*0.12;
		}else{
			$all_credits = ($end_exp-$cfg_user_level_exp[18])*0.15
						+ ($cfg_user_level_exp[18]-$cfg_user_level_exp[15])*0.12
						+ ($cfg_user_level_exp[15]-$exp_first)*0.1;
		}
	}else{
		$all_credits_rat = 0.2; //大于20级
		if($exp_first >= $cfg_user_level_exp[20]){
			$all_credits = $add_exp_all*$all_credits_rat;
		}else if($exp_first >= $cfg_user_level_exp[18]){
			$all_credits = ($end_exp-$cfg_user_level_exp[20])*0.2
						+ ($cfg_user_level_exp[20]-$exp_first)*0.15;
		}else if($exp_first >= $cfg_user_level_exp[15]){
			$all_credits = ($end_exp-$cfg_user_level_exp[20])*0.2
						+ ($cfg_user_level_exp[20]-$cfg_user_level_exp[18])*0.15
						+ ($cfg_user_level_exp[18]-$exp_first)*0.12;
		}else{
			$all_credits = ($end_exp-$cfg_user_level_exp[20])*0.2
						+ ($cfg_user_level_exp[20]-$cfg_user_level_exp[18])*0.15
						+ ($cfg_user_level_exp[18]-$cfg_user_level_exp[15])*0.12
						+ ($cfg_user_level_exp[15]-$exp_first)*0.1;
		}
	} 
    if($all_credits<50000){
        $all_credits = 50000;
    }
	$credits = round($all_credits);
	return $credits;
}

//
function user_login($uid,$uuid){
	global $public_key;
	$zeit = time(); 
    
    $g_sunrise = $zeit-($zeit+8*3600)%86400;
    $g_sunset = $g_sunrise + 86399;
    $user_extend = user_get_user_extend($uid);
    $last_login = $user_extend['last_login'];
    $online_keeps = $user_extend['online_keeps'];
	$user_info_base = user_get_user_base($uid);
    if($last_login<$g_sunrise){
        //今天第一次登陆
        if($last_login>$g_sunrise-86400){
            //是连续登陆
            $online_keeps = $online_keeps+1;            
        }else{
            $online_keeps = 1;
        }
        $user_extend['online_keeps']=$change_list['online_keeps']=$online_keeps;
        $user_extend['gen_online_gift']=$change_list['gen_online_gift']=0;
        
        if($user_info_base['vip_end_zeit']<$zeit){
            $change_user_base = array();
            $change_user_base['vip_level'] = $user_info_base['vip_level'] = 0;
            user_write_back_main_data($uid,$user_info_base,$change_user_base);
        }
    }
    $user_extend['last_login']=$change_list['last_login']=$zeit;
    $user_extend['last_online'] =$change_list['last_online']= $zeit;
    user_write_back_extend_data($uid,$user_extend,$change_list);
	if($user_info_base['level']>=8){
		user_reload_user_intro_list($uid);	
	}	
	$sid = gen_session_id($uid,$zeit,$public_key);
	$online_id = gen_online_id($uid,$sid,$zeit,$uuid);
	set_cookie($uid, $sid, $uid,$uuid,$online_id); 
	init_user_session_and_cache($uid,$sid);	
	return $sid;
}

function user_get_display_uid($uid){
	$uid +=100000;
	return common_alpha_id($uid);
}

function user_get_uid_by_display($display_uid){
	return common_alpha_id($display_uid,true)-100000;
}

function user_get_receive_send_credits($uid){
	$receive_send_credits = get_cache($uid,'u_send_money',1);
	$receive_send_credits =-1;
	if($receive_send_credits==-1||$receive_send_credits==-2){
		$receive_send_credits = user_update_receive_send_credits($uid);
	}else{
		$receive_send_credits = $receive_send_credits['data'];
	}
	return $receive_send_credits;
}
function user_update_receive_send_credits($uid){
	$sql = "SELECT * FROM u_send_money WHERE uid=$uid";
	$rst = mysql_w_query($sql);
	$receive_send_credits = array();
	while($row = mysql_fetch_assoc($rst)){
		$receive_send_credits[] = $row;
	}
	set_cache($uid,'u_send_money',$receive_send_credits,1);
	return $receive_send_credits;
}

//$typ = 0 系统各种广播 $typ=1 个人发信息 扣喇叭
function user_send_chat($uid,$typ,$msg){
	global $zeit;
	$user_base = user_get_user_base($uid);	
	$uname = $user_base['uname'];
	$msg_info = array('uid'=>$uid,'typ'=>$typ,'uname'=>$uname,'msg'=>$msg,'zeit'=>$zeit);
	$msg_list = chat_msg_get_msg_list();
	if(count($msg_list)>20){
		array_shift($msg_list);
	}
	$msg_list[] = $msg_info;
	uasort($msg_list,"sort_zeit");
	
	return array_values($msg_list); 
	
}
function sort_zeit($a,$b){
	return $a['zeit']-$b['zeit'];
}

function chat_msg_get_msg_list(){
	$msg_list = get_cache('','chat_msg',0);
	if($msg_list==-1||$msg_list==-2){
		$msg_list = array();
	}else{
		$msg_list = $msg_list['data'];
	}
	return $msg_list;
}

function user_get_zha_status($uid){
	$room_id = 0;
    $sql = "SELECT room_id FROM match_zha_zhuang WHERE uid=$uid";
    $rst = mysql_w_query($sql);
    if($row = mysql_fetch_assoc($rst)){
        $room_id = $row['room_id'];
    }
    return $room_id;
}

function pay_get_pay_status($out_trade_no){
    $sql = "SELECT uid FROM pay_payment WHERE out_trade_no='$out_trade_no'";
    $rst = mysql_w_query($sql);
    if(mysql_num_rows($rst)<=0){
        return 1;
    }
    return 0;
}
function pay_insert_pay_log($pay_uid,$out_trade_no,$pay_package_id,$total_fee,$gmt_payment,$typ=1){
    global $zeit;
    $gmt_payment = mysql_real_escape_string($gmt_payment);
    $out_trade_no = mysql_real_escape_string($out_trade_no);
    $sql = "INSERT INTO `pay_payment` ( `uid`, `item_id`, `price`, `gmt_payment`, `zeit`, `out_trade_no`,`typ`) VALUES
    ($pay_uid,$pay_package_id,$total_fee,'$gmt_payment',$zeit,'$out_trade_no',$typ)";
    mysql_w_query($sql);
}
function  pay_callback($uid,$pay_item_info){
    change_credits($uid,50,501,$pay_item_info['amount'],0);
    if(isset($pay_item_info['speaker_count'])&&$pay_item_info['speaker_count']>0){
        $user_extend_info = user_get_user_extend($uid);
        $user_extend_info['speaker_count'] += $pay_item_info['speaker_count'];
        $change['speaker_count'] = $user_extend_info['speaker_count'];
        user_write_back_extend_data($uid,$user_extend_info,$change);
    }
    
    
}

function st_ser_change($key,$value){

    	#	字段	类型	整理	属性	空	默认	额外	操作
	 	//date	sys_send sys_win sys_lost
    $date = (int)date("Ymd");
    $newdata = array('$inc' => array($key=>$value));
    mongoUpdate("st_date_srv",array("date"=>$date),$newdata);
}


function user_get_user_message_list($uid){
	$msg_list = get_cache($uid,'user_message_list',1);
	$msg_list = -1;
	if($msg_list==-1||$msg_list==-2){
		$msg_list = user_update_user_message_list($uid);
	}else{
		$msg_list = $msg_list['data'];
	}
	return $msg_list;		
}

function user_update_user_message_list($uid){
	$msg_list = array();
	$sql = "SELECT * FROM sys_message WHERE toUid=$uid";
	$rst = mysql_w_query($sql);
	while($row= mysql_fetch_assoc($rst)){
		$msg_list[] = $row;
	}
	set_cache($uid,'user_message_list',$msg_list,1);
	return $msg_list;		
}