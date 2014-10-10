<?
include_once FR."functions/user/reg.func.php";
include_once FR."functions/user/robot.func.php"; 
include_once FR."config/define/define.wordslength.php";
include_once FR."config/define/define.reg.php";
include_once FR.'functions/player/player.func.php';
include_once FR.'functions/club/club.func.php';
include_once FR.'functions/instance/ins.func.php';
include_once FR.'functions/buddy/buddy.func.php';
$open_game_time = isset($_GET['open_game_time']) ? $_GET['open_game_time'] : 0;
$zeit = time();
if(empty($open_game_time)){
    $json_rst = array('rstno'=>-2,'error'=>'开服时间有误!');
    return;
}
$open_game_unixtime = strtotime($open_game_time);
//开放当天的日出时间
$open_game_sunrise = strtotime(date('Y-m-d',$open_game_unixtime));

if($open_game_unixtime<=$zeit){
    $json_rst = array('rstno'=>-3,'error'=>'开服时间小于当前时间!');
    return;
}

$sql = "SELECT * FROM s_game_config WHERE `key`='open_game'";
$rst = mysql_w_query($sql);
if($row = mysql_fetch_assoc($rst)){
    $json_rst = array('rstno'=>-1,'error'=>'已开服不能使用');
    return;
}else{
    $sql = "INSERT INTO s_game_config(`key`,`value`) VALUES ('open_game','$open_game_time')";
    mysql_w_query($sql);

    for($i=1;$i<=11;$i++){
        if($i==4 || $i==10){
            continue;
        }
        $begin_time = $open_game_sunrise + 86400 * $i;
        $sql = "INSERT INTO e_system (typ,zeit,flag) VALUES(18,$begin_time,0)";
        mysql_w_query($sql);
    }
}
//s_date 开始日期	e_date down_date
$e_date = $open_game_sunrise+7*86400-1;
$down_zeit = $open_game_sunrise+9*86400-1;
$sql = "UPDATE feed_obt_act SET s_date=$open_game_sunrise,e_date=$e_date,zeit=$down_zeit WHERE obt_act_id=15 AND act_type=5";
$rst = mysql_w_query($sql);

$e_date = $open_game_sunrise+10*86400-1;
$down_zeit = $e_date;
$sql = "UPDATE feed_obt_act SET s_date=$open_game_sunrise,e_date=$e_date,zeit=$down_zeit WHERE obt_act_id=39 AND act_type=9";
$rst = mysql_w_query($sql);

$e_date = $open_game_sunrise+11*86400-1;
$down_zeit = $open_game_sunrise+20*86400-1;
$sql = "UPDATE feed_obt_act SET s_date=$open_game_sunrise,e_date=$e_date,zeit=$down_zeit WHERE act_type=127";
$rst = mysql_w_query($sql);
_update_obt_act();

$sql = "DELETE FROM e_system WHERE typ=12 AND flag=0";
mysql_w_query($sql);

//经典球员
$next_begin_time = $open_game_unixtime+3600;
$sql = "SELECT * FROM e_system WHERE typ=8 AND flag=0";
$rst = mysql_w_query($sql);
if(mysql_num_rows($rst)<=0){
    $sql = "INSERT INTO e_system (typ,zeit,flag) VALUES(8,$next_begin_time,0)";
    //print $sql;
    mysql_w_query($sql);
}

//周赛
include_once FR.'functions/match_tour/match_tour.func.php';

$open_game_time_in_week = date('N', $open_game_unixtime);
if($open_game_time_in_week<3){
    $start_time = (3-$open_game_time_in_week)*86400 + $open_game_sunrise+4*60*60;
}else{
    $start_time = (7-$open_game_time_in_week)*86400+$open_game_sunrise+3*86400+4*60*60;
}
 
$sql = "DELETE FROM tour_cup_table";
$rst = mysql_x_query($sql);
$sql = "DELETE FROM tour_match_fixture";
$rst = mysql_x_query($sql);
$sql = "DELETE FROM tour_cup_system";
$rst = mysql_x_query($sql);
$sql = "DELETE FROM e_system WHERE typ IN (13,14)";
mysql_x_query($sql);
foreach ($s_tour_typ as $cup_typ_id=>$tour_cup_info){
    $tour_cup_info['counter_history']=1;
    //更新报名tour_id
    //取出应该给的传奇球星的rp_id
    $legend_rp_id = get_weekly_legend_player_rp_id();
    $rp = new real_player($legend_rp_id);
    $legend_rp_name = $rp->player_name;
    $sql = "INSERT INTO tour_cup_system
            (counter_history,cup_typ_id,status,stage,legend_rp_id,legend_rp_name)
            VALUES
            ($tour_cup_info[counter_history],$tour_cup_info[cup_typ_id],0,0,$legend_rp_id,'$legend_rp_name')";
    mysql_x_query($sql);
    $insert_id= mysql_insert_id();
    //$sql = "UPDATE tour_waiting_queue SET tour_id=$insert_id WHERE tour_id=$tour_id";
    //mysql_x_query($sql);
    if($legend_rp_id!=0){
        //更新该经典球员状态为周赛已用
        $rule_desc = '第'.$tour_cup_info['counter_history'].'届'.$tour_cup_info['cup_typ_name'].'夺冠';
        
        $sql = "UPDATE s_legend_player SET get_rule_desc='$rule_desc',is_open=1 WHERE rp_id=$legend_rp_id";
        mysql_w_query($sql);
        //更新当前经典球员缓存
        $legend_player_list = ins_get_legend_player_list();
        $legend_player_list[$legend_rp_id]['get_rule_desc'] = $rule_desc;
        $legend_player_list[$legend_rp_id]['is_open'] = 1;
        set_cache($sys_id,'legend_player_list',$legend_player_list,0);
        _update_legend_player_list();
        _update_unique_legend_player_list();
    }    
}
$sql = "INSERT INTO e_system (typ,zeit) VALUES (13,$start_time)";
mysql_x_query($sql);

$tour_list = match_tour_get_tour_list(1);

$json_rst = array('rstno'=>1,'error'=>'开服完毕，请检查机器人有没有创建，请保证至少创建了50个机器人！'); 
 
?>