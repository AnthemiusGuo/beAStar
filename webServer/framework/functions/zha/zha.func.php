<?php
include_once FR.'config/define/define.zha.php';
include_once FR.'functions/zha/player.class.php';
include_once FR.'functions/zha/table.class.php';
include_once FR.'functions/user/robot.func.php';
include_once FR.'functions/game/gamebase.func.php';
include_once FR.'config/define/define.room.php';


function zha_enter_room($room_id){
    $table_list = get_cache($room_id,'room_table_list',0);
    if ($table_list ==-1 || $table_list ==-2) { 
	    $table_list = user_update_user_base($uid); 
	} else { 
	    $table_list = $table_list['data']; 
	}
    
}

function zha_enter_room_choose_table($room_id){
    global $room_table_list;
    //TODO 根据在线人数选择
    return $room_table_list[$room_id][1];
}

function zha_analyse_typ($cards){
    $huase = array();
    $dianshu = array();
    foreach ($cards as $card){
        $huase[] = (int)($card / 13);
        $dianshu[] = $card % 13;        
    }
    sort($dianshu);
    #豹子>同花顺>金花>顺子>对子>散牌
    if ($dianshu[0]==$dianshu[1] && $dianshu[1]==$dianshu[2]) {
        return array(6,$dianshu[0],0,0);
        #豹子
    }
    if ($huase[0]==$huase[1] && $huase[1]==$huase[2]) {
		if($dianshu[2]==12&&$dianshu[1]==1&&$dianshu[0]==0){
			return array(5,3,0,0);
		}else{
			if ($dianshu[0] == $dianshu[1]-1 && $dianshu[1]==$dianshu[2]-1){
				return array(5,$dianshu[0],0,0);
				#同花
			} else {
				return array(4,$dianshu[2],$dianshu[1],$dianshu[0]);
			}
		}
        
        
    }
	if($dianshu[2]==12&&$dianshu[1]==1&&$dianshu[0]==0){
		return array(3,3,0,0);
	}
    if ($dianshu[0] == $dianshu[1]-1 && $dianshu[1]==$dianshu[2]-1){
        return array(3,$dianshu[2],0,0);
        #顺子
    } 
    if ($dianshu[0]==$dianshu[1]) {
        return array(2,$dianshu[1],$dianshu[2],0);
        #对子
    }
    if ($dianshu[1]==$dianshu[2]) {
        return array(2,$dianshu[2],$dianshu[0],0);
        #对子
    }
    return array(1,$dianshu[2],$dianshu[1],$dianshu[0]);

}

function get_win_loose($z,$x){//$paixingx,$paixingy,$maxx,$maxy,$all_cardsx,$all_cardsy){
	for($i=0;$i<4;$i++){
		if($x[$i]>$z[$i]){
			return 1;
		}else if($x[$i]<$z[$i]){
			return 0;
		}
	}
	return 0;
    //if ($paixingx < $paixingy) {
    //    $rst = 0;
    //    return $rst;
    //} else if ($paixingx > $paixingy) {
    //    $rst = 1;
    //    return $rst;
    //}
    //#然后比大牌
    //if ($maxx < $maxy) {
    //    $rst = 0;
    //    return $rst;
    //} else if ($maxx > $maxy) {
    //    $rst = 1;
    //    return $rst;
    //}
    //#对子比单牌
    //if ($paixingx == 2) {
    //    if ($all_cardsx[2] < $all_cardsy[2]) {
    //        $rst = 0;
    //        return $rst;
    //    } else if ($all_cardsx[2] > $all_cardsy[2]) {
    //        $rst = 1;
    //        return $rst;
    //    }
    //}
    //#散牌挨个比
    //if ($paixingx == 1) {
    //    if ($all_cardsx[1] < $all_cardsy[1]) {
    //        $rst = 0;
    //        return $rst;
    //    } else if ($all_cardsx[1] > $all_cardsy[1]) {
    //        $rst = 1;
    //        return $rst;
    //    }
    //
    //    if ($all_cardsx[2] < $all_cardsy[2]) {
    //        $rst = 0;
    //        return $rst;
    //    } else if ($all_cardsx[2] > $all_cardsy[2]) {
    //        $rst = 1;
    //        return $rst;
    //    }
    //}
    #然后一律庄家赢
    //return 0;
}

function zha_set_bet($room_id,$table_id,$match_id,$uid,$men,$point){
    //高并发下MC无法保证数据完整性，用MC的意义何在？
    
    
    $sql = "INSERT INTO match_zha_bet
            (room_id,table_id,match_id,uid,men,point)
            VALUES
            ($room_id,$table_id,$match_id,$uid,$men,$point)
            ON DUPLICATE KEY UPDATE point=point+$point";
    mysql_x_query($sql);
}

function zha_open($room_id,$table_id,$match_id,$open,$bet_info,$zhuang_info){
    //对子	对应“门”下注额的2倍
    //顺子	对应“门”下注额的3倍
    //金花	对应“门”下注额的4倍
    //顺金	对应“门”下注额的6倍
    //豹子	对应“门”下注额的10倍
    global $config_zha_ratio;
    
    //抽水比例
    $room_info = gb_get_room_info($room_id);
    $room_water_ratio = $room_info['ratio'];

    $log_id = zha_log_open($room_id,$table_id,$match_id,$open);
    // $sql = "SELECT * FROM match_zha_bet WHERE table_id=$table_id AND match_id=$match_id";
    // $rst = mysql_x_query($sql);
    $user_get = array();
    $zhuang_get = 0;

    $user_result = array();

    $zhuang_result = array(0,0,0,0);
	//$user_result[-1]['cc'] = array(0,0,0,0);

    $user_exp = array();
    $zhuang_exp = 0;

    foreach ($bet_info as $uid=>$bets){
        if (!isset($user_get[$uid])){
            $user_get[$uid] = 0;
        }
        if (!isset($user_result[$uid])){
            $user_result[$uid] = array('cc'=>array(0,0,0,0),'r'=>0,'c'=>0);
        }
        foreach ($bets as $men => $point) {
            $result = $open['result'][$men-1];
            
            if ($result==0){
                //庄家胜

                $ratio = $config_zha_ratio[$open['paixing'][0]];
                $change_credits = round($point*$ratio);

                $user_result[$uid]['cc'][$men-1] = 0- $change_credits;
                $user_get[$uid] -= $change_credits;

                $zhuang_result[$men-1] += $change_credits;
                $zhuang_get += $change_credits;
            } else {
                //闲家胜
                $ratio = $config_zha_ratio[$open['paixing'][$men]];
                $change_credits = round($point*$ratio);
                //$change_credits = round($point*$ratio*(1-$room_water_ratio));
                $zhuang_get -= $change_credits;
                $zhuang_result[$men-1] -= $change_credits;

                $user_result[$uid]['cc'][$men-1] = $change_credits;
                $user_get[$uid] += $change_credits;
            }
        }
    }
    $player_win_credts = 0;
    foreach ($user_get as $uid=>$credits){
		$this_user = user_get_user_base($uid);
        //$is_robot = $this_user['is_robot'];
        if ($this_user['is_robot']!=1){
            $player_win_credts += $credits;
        }
        if ($credits>0){
            $real_credits = round($credits*(1-$room_water_ratio));
            user_add_exp($uid,($credits - $real_credits));			
            $user_result[$uid]['c'] = $real_credits;
            $user_result[$uid]['r'] = change_credits($uid,10,101,$real_credits,$log_id);
			$this_user = user_get_user_base($uid);
			$user_result[$uid]['exp'] = $this_user['exp'];
			$user_result[$uid]['level'] = $this_user['level'];
        } else {
            $user_result[$uid]['c'] = $credits;
            $user_result[$uid]['r'] = change_credits($uid,11,102,$credits,$log_id);
			$user_result[$uid]['exp'] = $this_user['exp'];
			$user_result[$uid]['level'] = $this_user['level'];
        }
    }
    
    //写入庄家TODO$zhuang_info
    $zhuang_uid = $zhuang_info['uid'];
	
	if ($zhuang_get>0){
		$zhuang_credits = round($zhuang_get*(1-$room_water_ratio));
		$zhuang_exp = round($zhuang_get*$room_water_ratio);

        $user_result[-1]['c'] = $zhuang_credits;
		if($room_id==1){
			$user_result[-1]['r'] = 0;
			$user_result[-1]['exp'] = 0;
			$user_result[-1]['level'] = 0;
		}else{
			$user_result[-1]['r'] = change_credits($zhuang_uid,10,101,$zhuang_credits,$log_id);
			user_add_exp($zhuang_uid,$zhuang_exp);
			$this_user = user_get_user_base($zhuang_uid);
            
			$user_result[-1]['exp'] = $this_user['exp'];
			$user_result[-1]['level'] = $this_user['level'];
		}
	} else {
		$zhuang_credits = $zhuang_get;
        $user_result[-1]['c'] = $zhuang_credits;
		if($room_id==1){
			$user_result[-1]['r'] = 0;
			$user_result[-1]['exp'] = 0;
			$user_result[-1]['level'] = 0;
		}else{
			$user_result[-1]['r'] = change_credits($zhuang_uid,11,102,$zhuang_credits,$log_id);
			$this_user = user_get_user_base($zhuang_uid);
			$user_result[-1]['exp'] = $this_user['exp'];
			$user_result[-1]['level'] = $this_user['level'];
		}
		
	}
    if($room_id!=1){
        $this_user = user_get_user_base($zhuang_uid);
        if($this_user['is_robot']!=1){
            $player_win_credts += $zhuang_get;
        }
    }
	$user_result[-1]['cc'] = $zhuang_result;
    if($player_win_credts<0){
        $player_win_credts = 0 - $player_win_credts;
        st_ser_change("sys_win",$player_win_credts);
    }else{
        st_ser_change("sys_lost",$player_win_credts);
    }
    //if($player_win_credts!=0){
    //    err_log($player_win_credts);
    //    err_log(json_encode($user_result));
    //}
    return $user_result;
}



function zha_get_zhuang($room_id,$table_id){
    $key = $room_id.'_'.$table_id;
    $zhuang_info = get_cache($key,'zha_zhuang',0);
        //$user_info_base = -1;
	if ($zhuang_info ==-1 || $zhuang_info ==-2) { 
	    $zhuang_info = zha_update_zhuang_cache($room_id,$table_id); 
	} else { 
	    $zhuang_info = $zhuang_info['data']; 
	}
    return $zhuang_info;
}

function zha_update_zhuang_cache($room_id,$table_id){
    $key = $room_id.'_'.$table_id;
    $sql = "SELECT * FROM match_zha_zhuang WHERE room_id = $room_id AND table_id=$table_id";
    $rst = mysql_x_query($sql);
    if ($zhuang = mysql_fetch_assoc($rst)){
        set_cache($key,'zha_zhuang',$zhuang,0);
    } else {

    }
    
    return $zhuang;
}

function zha_init_new_zhuang($room_id,$table_id,$is_robot,$zhuang_uid){
	
    $sql = "UPDATE match_zha_zhuang SET
	counter = 0, is_robot=$is_robot,uid=$zhuang_uid
	WHERE room_id = $room_id AND table_id = $table_id";
	
    $rst = mysql_x_query($sql);
	$zhuang = array(
		'room_id'=>$room_id,
		'table_id'=>$table_id,
		'uid'=>$zhuang_uid,
		'counter'=>0,
		'is_robot'=>$is_robot
	);
	$key = $room_id.'_'.$table_id;
	set_cache($key,'zha_zhuang',$zhuang,0);
	return $zhuang;
}

function zha_init_zhuang_robot($room_id,$table_id,$robot){
    $robot_id = $robot['uid'];
    $sql = "INSERT INTO match_zha_zhuang
    (room_id,table_id,uid,counter,is_robot)
    VALUES
    ($room_id,$table_id,$robot_id,0,1)
	ON DUPLICATE KEY UPDATE
	counter = 0, is_robot=1,uid=$robot_id";
    mysql_x_query($sql);
    $zhuang = array(
        'room_id'=>$room_id,
        'table_id'=>$table_id,
        'uid'=>$robot_id,
        'counter'=>0,
        'is_robot'=>1,
    );
    $key = $room_id.'_'.$table_id;
    set_cache($key,'zha_zhuang',$zhuang,0);
	//$user_info = user_get_user_base($robot_id);
	//if ($user_info['credits']<50000000*4){
	//	$user_info['credits'] = 50000000*4 + rand(0,100000000);
	//	$change['credits'] = $user_info['credits'];
	//	user_write_back_main_data($robot_id,$user_info,$change);
	//}
    return $zhuang;
}

function zha_check_xiazhuang($room_id,$table_id,$zhuang){
	global $room_list,$cfg_max_zha_zhuang_round;
	if($room_id==1){
		return 0;//初级场系统坐庄，不下庄
	}
    if ($zhuang['uid']<=0){
        return 2;
    }
    $zhuang['counter']++;
	//err_log(json_encode($zhuang));
	if ($zhuang['counter']>=$cfg_max_zha_zhuang_round){
		return 1;
	}
	
	#检查庄的钱
	$user_info = user_get_user_base($zhuang['uid']);
	#再次校验钱是不是够
	
	if ($user_info['credits']<$room_list[$room_id]['room_zhuang_limit_low']){
		return 2;
	}
	
	$sql = "UPDATE match_zha_zhuang SET
	counter = counter+1
	WHERE room_id = $room_id AND table_id = $table_id";
	
    $rst = mysql_x_query($sql);
	
	$key = $room_id.'_'.$table_id;
	set_cache($key,'zha_zhuang',$zhuang,0);
	return 0;
}

function zha_check_queue($room_id,$table_id){
    
}

function zha_get_user_rank($room_id,$table_id){
    $key = $room_id.'_'.$table_id;
    $user_list = get_cache($key,'user_rank',0);
    $user_list = -1;
    if ($user_list ==-1 || $user_list ==-2) { 
        $user_list = zha_update_user_rank($room_id,$table_id,array()); 
    } else { 
        $user_list = $user_list['data']; 
    }
    return $user_list;
}

function zha_update_user_rank($room_id,$table_id){
    $key = $room_id.'_'.$table_id;
    
    $user_list = zha_get_user_list($room_id,$table_id);

    $zhuang = zha_get_zhuang($room_id,$table_id);

    $user_list[] = user_get_user_show($zhuang['uid'],1);

    uasort($user_list, 'cmp_with_credits');
    $lenght = count($user_list);
    if ($lenght>10){
        array_splice($user_list, 0,10);

    }
    set_cache($key,'user_rank',$user_list,0);
    return $user_list;
}

function cmp_with_credits($a,$b){
    return $b['credits'] - $a['credits'];
}

function zha_get_user_list($room_id,$table_id){
    $key = $room_id.'_'.$table_id;
    $user_list = get_cache($key,'user_list',0);
	if ($user_list ==-1 || $user_list ==-2) { 
	    $user_list = zha_update_user_list($room_id,$table_id,array()); 
	} else { 
	    $user_list = $user_list['data']; 
	}
    return $user_list;
}

function zha_update_user_list($room_id,$table_id,$uid_list){
    $key = $room_id.'_'.$table_id;
    
    $user_list = array();
    foreach ($uid_list as $op_uid){
        $user_list[] = user_get_user_show($op_uid,1);
    }
    set_cache($key,'user_list',$user_list,0);
    return $user_list;
}
?>