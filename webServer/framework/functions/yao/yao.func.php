<?php
include_once FR.'config/define/define.zha.php';
include_once FR.'functions/user/robot.func.php';
include_once FR.'functions/game/gamebase.func.php';

function yao_set_bet($room_id,$table_id,$match_id,$uid,$men,$point){
    //高并发下MC无法保证数据完整性，用MC的意义何在？
    
    
    $sql = "INSERT INTO match_yao_bet
            (room_id,table_id,match_id,uid,men,point)
            VALUES
            ($room_id,$table_id,$match_id,$uid,$men,$point)
            ON DUPLICATE KEY UPDATE point=point+$point";
    mysql_x_query($sql);
}

function yao_anylyse_result($dices){
    //一共29门，分别是
/*
1 1 2 2 3 3 4 4 5 5 6 6
7 三个1   8 3个2   9 3个3   10 3个4  11 3个5  12 3个6
13 任意围骰
14 小    15 大
16 和4   17 和5   18 和6   19 和7   ......  29 和17
*/
//$name_typ:
// 4 4点 小
// 5 5点 小
// 10 10点 小
// 11 11点 大
// 17 17点 大
// 101 一豹子
// 106 六豹子
//
    $name_typ = -1;
    $ratio = array(
        1,1,1,1,1,1,//单骰
        210,210,210,210,210,210,35,//围骰
        1,1,//小大
        60,30,17,12,8,7,6,
        6,7,8,12,17,30,60
    );
    $all_results = array(0,0,0,0,0,
                     0,0,0,0,0,
                     0,0,0,0,0,
                     0,0,0,0,0,
                     0,0,0,0,0,
                     0,0,0,0);
    
    $sum = array_sum($dices);
    if ($dices[0]==$dices[1] && $dices[1]==$dices[2]){
        //围骰
        $all_results[13-1] = $ratio[13-1];
        $all_results[$dices[0]+5] = $ratio[$dices[0]+5];
        //单骰X15模式
        $all_results[$dices[0]-1] = 15;
        $name_typ = 100+$dices[0];
    } else {
        //围骰通吃大小
        if ($sum>=4 && $sum<=10){
            $all_results[14-1] = $ratio[14-1];
        }
        //看单押X2模式
        if ($dices[0]==$dices[1]){
            $all_results[$dices[0]-1] = 2;
            $all_results[$dices[2]-1] = 1;
        } elseif ($dices[0]==$dices[2]){
            $all_results[$dices[0]-1] = 2;
            $all_results[$dices[1]-1] = 1;
        } elseif ($dices[1]==$dices[2]){
            $all_results[$dices[1]-1] = 2;
            $all_results[$dices[0]-1] = 1;
        } else {
            //单押X1
            $all_results[$dices[0]-1] = 1;
            $all_results[$dices[1]-1] = 1;
            $all_results[$dices[2]-1] = 1;
        }
        $name_typ = $sum;
    }
    //然后看和
    if ($sum>=4 && $sum<=17){
        $all_results[$sum+11] = $ratio[$sum+11];
    }
    return array('result'=>$all_results,'name_typ'=>$name_typ);
}

function yao_open($room_id,$table_id,$match_id,$open,$bet_info){
    $log_id = yao_log_open($room_id,$table_id,$match_id,$open);
    $user_bet = array();
    $user_get = array();
    $user_result = array();
    $user_exp = array();

    foreach ($bet_info as $uid => $v) {
        foreach ($v as $men => $bet_point) {    
            $result = $open['result'][$men-1];
            
            if (!isset($user_result[$uid])){
                $user_result[$uid] = array('r'=>0);
            }
            if ($result==0){
                //庄家胜
                $change_credits = 0-$bet_point;
            } else {
                //闲家胜
                $change_credits = $bet_point*$result;
            }
            //经验是下注额
            if (isset($user_exp[$uid])){
                $user_exp[$uid]+=round($bet_point*0.05);
            } else {
                $user_exp[$uid] = round($bet_point*0.05);
            }
            if (isset($user_get[$uid])){
                $user_get[$uid] += $change_credits;
            } else {
                $user_get[$uid] = $change_credits;
            }
            
            
            // $sql = "UPDATE match_yao_bet
            // SET result = $result, change_credits = $change_credits
            // WHERE room_id=$room_id AND table_id = $table_id AND match_id = $match_id AND uid = $uid AND men=$men";
            // mysql_x_query($sql);
        }
    }
    foreach ($user_get as $uid=>$credits){
        if ($credits>0){
            $user_result[$uid]['r'] = change_credits($uid,10,101,$credits,$log_id);
        } else {
            $user_result[$uid]['r'] = change_credits($uid,11,102,$credits,$log_id);
        }
        $user_result[$uid]['cc'] = $credits;
        if (isset($user_exp[$uid]) && $user_exp[$uid]>0){
            user_add_exp($uid,$user_exp[$uid]);
        }
    }
    return $user_result;
}
?>