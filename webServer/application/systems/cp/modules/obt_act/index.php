<?php
//查询所有公测活动
include_once FR."config/define/pf_server.config.php";
$obt_act_list = array();
$sql = "SELECT * FROM feed_obt_act";
$ret = mysql_w_query($sql);
while($row=mysql_fetch_assoc($ret)){    
     //	title 	r_title 内容标题	introducer 引导语	content url
    $row['title'] = stripslashes($row['title']);
    $row['r_title'] = stripslashes($row['r_title']);
    $row['introducer'] = stripslashes($row['introducer']);
    $row['content'] = stripslashes($row['content']);
    $row['url'] = stripslashes($row['url']);
    $obt_act_list[$row['obt_act_id']]=$row;
    $obt_act_list[$row['obt_act_id']]['status'] = '';
    if ($zeit>$row['s_date'] && $zeit>$row['up_date'] && $zeit<$row['e_date'] &&  $zeit<$row['zeit']){
        $obt_act_list[$row['obt_act_id']]['status'] = 'success';
    }
    else if ($zeit<$row['up_date']){
        $obt_act_list[$row['obt_act_id']]['status'] = 'warning';
    }
    else if ($zeit>$row['zeit']){
        $obt_act_list[$row['obt_act_id']]['status'] = 'error';
    }
    
    $obt_act_list[$row['obt_act_id']]['zeit_show'] = date("Y-m-d H:i:s",$obt_act_list[$row['obt_act_id']]['zeit']);
    $obt_act_list[$row['obt_act_id']]['s_date_show'] = date("Y-m-d H:i:s",$obt_act_list[$row['obt_act_id']]['s_date']);
    $obt_act_list[$row['obt_act_id']]['e_date_show'] = date("Y-m-d H:i:s",$obt_act_list[$row['obt_act_id']]['e_date']);
    $obt_act_list[$row['obt_act_id']]['up_date_show'] = date("Y-m-d H:i:s",$obt_act_list[$row['obt_act_id']]['up_date']);
}

//活动可选经典球员
$sql = "SELECT rp_id FROM s_legend_player WHERE hook_param=2 AND cid<=0 AND rp_id NOT IN('-15508','-15503','-15487')";
$rst = mysql_w_query($sql);
$legend_player_list = array();
while($row = mysql_fetch_assoc($rst)){
    $legend_player_list[$row['rp_id']]['rp_id'] = $row['rp_id'];
    $player_info= new real_player($row['rp_id']);
    $legend_player_list[$row['rp_id']]['name'] = $player_info->player_name;
}


?>