<?php
include_once FR.'functions/user/robot.func.php';
include_once FR.'functions/match_tour/match_tour.func.php';
//经典球员事件初始化
$sql = "SELECT * FROM e_system WHERE typ=8 AND flag=0";
$rst = mysql_w_query($sql);
$legend_e_system = array();
while($row = mysql_fetch_assoc($rst)){
    $legend_e_system[] = $row;
}
if(count($legend_e_system)>1){
    exit("经典球员事件数据多于1条！");
}else{
    $e_time = isset($legend_e_system[0]['zeit']) ? $legend_e_system[0]['zeit'] : 0;
    if(!empty($e_time)){
        $legend_player_time = date('Y-m-d H:i:s',$e_time);
    }else{
        $legend_player_time = 0;
    }
}


//开服活动初始化
$end_time = time();
$sql = "SELECT * FROM feed_obt_act WHERE e_date>$end_time";
$rst = mysql_w_query($sql);
$feed_obt_act_list = array();
while($row = mysql_fetch_assoc($rst)){
    $feed_obt_act_list[$row['act_type']] = $row;
}
$sql = "SELECT * FROM e_system WHERE typ=12 AND flag=0";
$rst = mysql_w_query($sql);
if($row = mysql_fetch_assoc($rst)){
    $obt_act_system = $row;
}else{
    $obt_act_system = array();
}

//开服11天活动数据迁移事件
$open_game_e_sys_list = array();
$sql = "SELECT * FROM e_system WHERE typ=18 ORDER BY zeit ASC";
$rst = mysql_w_query($sql);
while($row = mysql_fetch_assoc($rst)){
    $open_game_e_sys_list[] =  $row;
}

//周赛初始化
$begin_tour_zeit = 0;
$has_event = array();
$sql = "SELECT * FROM e_system WHERE typ IN (13,14) AND flag=0";
$rst = mysql_w_query($sql);
while($row = mysql_fetch_assoc($rst)){
    if ($row['typ']==13){
        $begin_tour_zeit = $row['zeit'];
    }
    $has_event[] = $row;
}
$tour_info = match_tour_get_tour_list();
//机器人
$robots = robot_update_list();

//开服时间
$sql = "SELECT * FROM s_game_config WHERE `key`='open_game'";
$rst = mysql_w_query($sql);
$open_game= mysql_fetch_assoc($rst);