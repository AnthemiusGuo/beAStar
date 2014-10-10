<?php

global $g_sunrise;$zeit;


$typ = isset($_GET['typ']) ? $_GET['typ'] : 0;
if(empty($typ)){
    $json_rst = array('rstno'=>-1,'error'=>_('数据错误！'));
    return;
}

if($typ==1){
    $end_zeit =$g_sunrise+86400;
    //经典球员延时
    $sql = "SELECT count(1) as num FROM e_user WHERE typ=11 AND zeit>$g_sunrise AND zeit<$end_zeit;";
    $rst = mysql_w_query($sql);
    $row = mysql_fetch_assoc($rst);
    $recovering_num = isset($row['num']) ? $row['num'] : 0;

    if($recovering_num<=0){
        $json_rst = array('rstno'=>-2,'error'=>_('没有需要延长时间的经典球员数据！'));
        return;
    }

    //更新事件时间
    $sql = "UPDATE e_user SET zeit=zeit+86400 WHERE typ=11 AND zeit>$g_sunrise AND zeit<$end_zeit;";
    mysql_w_query($sql);

    //更新s_legend_player结束时间
    $sql = "UPDATE s_legend_player SET finish_zeit=finish_zeit+86400 WHERE finish_zeit>$g_sunrise AND finish_zeit<$end_zeit";
    mysql_w_query($sql);
    $json_rst = array('rstno'=>1,'error'=>_('经典球员时间已经延长！'));
}elseif($typ==2){
    //延时交易市场
    $sql = "SELECT count(1) as num FROM e_user WHERE typ=9";
    $rst = mysql_w_query($sql);
    $row = mysql_fetch_assoc($rst);
    $trading_num = isset($row['num']) ? $row['num'] : 0;
    if($trading_num<=0){
        $json_rst = array('rstno'=>-3,'error'=>_('没有交易数据！'));
        return;
    }
    $start_zeit = $zeit+3600*3-7200;
    $finish_zeit = $zeit+3600*3+7200;

    $sql = "UPDATE c_player_trade SET e_time=e_time+7200 WHERE e_time>=$start_zeit and e_time<=$finish_zeit";
    mysql_w_query($sql);

    $sql = "UPDATE e_user SET zeit=zeit+7200 WHERE typ=9 AND zeit>=$start_zeit and zeit<=$finish_zeit AND flag=0";
    mysql_w_query($sql);

    $json_rst = array('rstno'=>2,'error'=>_('交易市场时间已经延长2小时！'));
}

