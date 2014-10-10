<?php
include_once FR.'functions/zha/zha.func.php';
include_once FR.'functions/log/zha.log.php';
if (!isset($_GET['match_id']) || !isset($_GET['room_id'])|| !isset($_GET['table_id'])|| !isset($_POST['data'])){
    $json_rst['rstno'] = -1;
    return;
}

$match_id = $_GET['match_id'];
$room_id = $_GET['room_id'];
$table_id = $_GET['table_id'];
$bet_data = json_decode($_POST['data'],true);
//err_log(json_encode($bet_data));
//时间是场次关键字，room id是房间号关键字
//开牌算法，不管押注
for ($i = 0;$i<52;$i++){
    $target_card[] = $i;
}
shuffle($target_card);

$vernier = 0;
$flag = 0;

$zhuang = array($target_card[$vernier],$target_card[$vernier+1],$target_card[$vernier+2]);
uasort($zhuang,"abc_sort");
$zhuang = array_values($zhuang);
$vernier+=3;
$xian1 = array($target_card[$vernier],$target_card[$vernier+1],$target_card[$vernier+2]);
uasort($xian1,"abc_sort");
$xian1 = array_values($xian1);
$vernier+=3;
$xian2 = array($target_card[$vernier],$target_card[$vernier+1],$target_card[$vernier+2]);
uasort($xian2,"abc_sort");
$xian2 = array_values($xian2);
$vernier+=3;
$xian3 = array($target_card[$vernier],$target_card[$vernier+1],$target_card[$vernier+2]);
uasort($xian3,"abc_sort");
$xian3 = array_values($xian3);
$vernier+=3;
$xian4 = array($target_card[$vernier],$target_card[$vernier+1],$target_card[$vernier+2]);
uasort($xian4,"abc_sort");
$xian4 = array_values($xian4);

function abc_sort($a,$b){
    return $b%13-$a%13;    
}
 
$zhuang_pai = zha_analyse_typ($zhuang);
$xian1_pai = zha_analyse_typ($xian1);
$xian2_pai = zha_analyse_typ($xian2);
$xian3_pai = zha_analyse_typ($xian3);
$xian4_pai = zha_analyse_typ($xian4);

$result1 = get_win_loose($zhuang_pai,$xian1_pai);
$result2 = get_win_loose($zhuang_pai,$xian2_pai);
$result3 = get_win_loose($zhuang_pai,$xian3_pai);
$result4 = get_win_loose($zhuang_pai,$xian4_pai);
    
$json_rst['data']= array('pai'=>array($zhuang,$xian1,$xian2,$xian3,$xian4),
                        'paixing'=>array($zhuang_pai[0],$xian1_pai[0],$xian2_pai[0],$xian3_pai[0],$xian4_pai[0]),
                        'result'=>array($result1,$result2,$result3,$result4)
                        );

$zhuang_info = zha_get_zhuang($room_id,$table_id);
$json_rst['user_data'] = zha_open($room_id,$table_id,$match_id,$json_rst['data'],$bet_data,$zhuang_info);
$json_rst['zi'] = $json_rst['user_data'][-1]['c'];
$json_rst['zr'] = $json_rst['user_data'][-1]['r'];
//计算下庄
$json_rst['zhuang'] = $zhuang_info;
$json_rst['max_zha_zhuang_round'] = $cfg_max_zha_zhuang_round;
$json_rst['chang_robot'] = 0;
$do_num = zha_robot_do_count($room_id);
err_log("donum:".$do_num);
$do_num++;
if($do_num >=200+$room_id*10){
    
    $do_num = 0;
    $json_rst['chang_robot'] = 1;
    for ($i=0;$i<20;$i++){
        $robot_uid = robot_get_a_robot($room_id);
        $user_info = user_get_user_base($robot_uid);
        if(empty($user_info)){
            continue;
        }
        if($i<=9&&$room_id!=1){        
            if($room_id==2){
                if($user_info['credits']>800000000||$user_info['credits']<30000000){
                    $user_info['credits'] =  mt_rand(30000000,800000000);
                }
            }else if($room_id==3){
                if($user_info['credits']>300000000||$user_info['credits']<100000000){
                    $user_info['credits'] =  mt_rand(100000000,300000000);
                }
            }
            
            $change['credits'] = $user_info['credits'];
            user_write_back_main_data($robot_uid,$user_info,$change);
            $robot = user_get_user_for_sock($robot_uid);
            $json_rst['robotszhuang'][] = $robot;
        }else{
            if($room_id==1){
                $user_info['credits'] = mt_rand(3000,15000);
            }else if($room_id==2){
                $user_info['credits'] = 1000000 + mt_rand(1,4000000);
            }else if($room_id==3){
                if($user_info['credits']<100000000){
                    $user_info['credits'] =  mt_rand(10000000,50000000);
                }
            }
            $change['credits'] = $user_info['credits'];
            user_write_back_main_data($robot_uid,$user_info,$change);
            $robot = user_get_user_for_sock($robot_uid);
        } 
        $robot['is_zhuang'] = 0;
        $json_rst['robots'][$robot_uid] = $robot;
    }
    err_log(json_encode($json_rst['robots']));
    
}
set_cache($room_id,'zha_robot_do_count',$do_num,0);
function zha_robot_do_count($room_id){
    $num = get_cache($room_id,'zha_robot_do_count',0);
    if($num==-1||$num==-2){
        return 0;
    }else{
        $num = $num['data'];
    }
    return $num;
    
}
$json_rst['xia'] = zha_check_xiazhuang($room_id,$table_id,$zhuang_info);
    
?>