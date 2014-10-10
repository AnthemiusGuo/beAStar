<?php
include_once FR.'functions/player/legend_player.func.php';

global $g_sunrise;$zeit;
$end_zeit =$g_sunrise+86400;

//經典球員延時
$sql = "SELECT count(1) as num FROM e_user WHERE typ=11 AND zeit>$g_sunrise AND zeit<$end_zeit;";
$rst = mysql_w_query($sql);
$row = mysql_fetch_assoc($rst);
$recovering_num = isset($row['num']) ? $row['num'] : 0;

//玩家市場延時
$start_zeit = $zeit+3600*3-7200;
$finish_zeit = $zeit+3600*3+7200;
$sql = "SELECT count(1) as num FROM e_user WHERE typ=9 AND zeit>=$start_zeit and zeit<=$finish_zeit AND flag=0";
$rst = mysql_w_query($sql);
$row = mysql_fetch_assoc($rst);
$trading_num = isset($row['num']) ? $row['num'] : 0;

$real_zeit = floor($zeit/1000);
$begin_zeit = dechex($real_zeit);
$count = dechex(1000);
$verify_num = strtoupper(substr(md5($real_zeit.'1000'.'UX'),3,4));
$maintain_voucher = common_add_zero_left($begin_zeit,5).'-'.common_add_zero_left($count,4).'-'.$verify_num;