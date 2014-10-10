<?
include_once FR.'config/define/pay.config.php';

$begin = $g_sunrise - 86400*14;
$sql = "SELECT * FROM st_pay_every_day WHERE zeit>=$begin";
$rst = mysql_x_query($sql);
$everyday_any = array();
while ($row = mysql_fetch_assoc($rst)){
    $row['json_data'] = json_decode($row['json_data'],true);
    $everyday_any[$row['zeit']][$row['typ']] = $row;
}

$sql = "SELECT SUM(real_credits) as sum_all,COUNT(cid) as c_cid FROM c_club_info WHERE real_credits>0 AND is_robot=0";
$rst = mysql_x_query($sql);
$sum_reverse_all = mysql_fetch_assoc($rst);

$sql = "SELECT count(distinct(cid)) as count_cid,count(*) as count_pay,sum(cost) as total_cost
        FROM st_pay_real_credits
        WHERE zeit = $g_sunrise";
$rst = mysql_x_query($sql);
$sum_today = mysql_fetch_assoc($rst);

$sql = "SELECT typ,count(distinct(cid)) as count_cid,count(*) as count_pay,sum(cost) as total_cost
        FROM st_pay_real_credits
        WHERE zeit = $g_sunrise
        GROUP BY typ";
$rst = mysql_x_query($sql);
$any_today = array();
while ($row = mysql_fetch_assoc($rst)){
    $any_today[$row['typ']] = $row;
}
?>