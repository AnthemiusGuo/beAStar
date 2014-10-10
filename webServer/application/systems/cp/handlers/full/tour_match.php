<?php
include_once FR.'functions/match_tour/match_tour.func.php';
//时间戳
$start_time = isset($_GET['start']) ? (int)$_GET['start'] : 0;
if(empty($start_time)){
    $json_rst = array('rstno'=>-1,'error'=>_('请填写时间戳！'));
    return;
}elseif($start_time<time()){
    $json_rst = array('rstno'=>-2,'error'=>_('时间戳小于当前时间！'));
    return;
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
        $unique_legend_player_list = ins_get_unique_legend_player_list();
        $legend_player_id = $unique_legend_player_list[$legend_rp_id]['id'];
        $legend_player_list[$legend_player_id]['get_rule_desc'] = $rule_desc;
        $legend_player_list[$legend_player_id]['is_open'] = 1;
        set_cache($sys_id,'legend_player_list',$legend_player_list,0);
    }
    
}
$sql = "INSERT INTO e_system (typ,zeit) VALUES (13,$start_time)";
mysql_x_query($sql);

$tour_list = match_tour_get_tour_list(1);