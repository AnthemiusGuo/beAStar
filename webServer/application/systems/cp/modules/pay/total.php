<?
include_once FR.'config/define/pay.config.php';
$config_rss = array(
    1=>4,//'升级装备',
    2=>4,//'装备冷却加速',
    3=>8,//'球迷爆棚',
    4=>7,//'加速挂机',
    5=>7,//'高级挂机',
    6=>99,//'俱乐部改名',
    7=>8,//'赛前恢复体力',
    8=>1,//'黑市刷球员',
    9=>2,//'结束特训',
    10=>3,//'青训球员改名',
    11=>2,//'转生',
    12=>2,//'开特训位',
    13=>2,//'洗点',
    14=>1,//'市场球探刷球员',
    15=>99,//'商城买道具',
    16=>6,//'战术位解锁',
    17=>3,//'加速青训留学',
    18=>3,//'刷青训球员',
    19=>1,//'玩家市场交易',
    20=>2,//'重复刷转生',
    21=>2,//'合成保护 代替幸运符',
    22=>2,//'经验转移',
    23=>10,//'每日活动buff',
    24=>99,//'公会捐献',
    25=>1,//'商城买球员包',
    26=>99,//'商城买其他',
    27=>2,//'快速特训',
    28=>8,//'两次打实况杯',
    29=>10,//'每日活动buff',
    30=>10,//'购买VIP',
    31=>1,//'7级球员包',
    32=>99,//'经典球员续约',
    33=>9,//'抽奖活动',
    34=>3,//'买DNA',
    35=>3,//'开青训位',
    36=>3,//'锁定青训DNA',
    37=>99,//'赞助商签约',
    38=>8,//'跳过比赛',
    39=>9,//'5元礼包',
    41=>99,//'个性球场',
    42=>8,//'建立杰宝杯',
    43=>5,//'购买技能石',
    101=>99,//'竞猜真实'
);
$config_rss_name = array(
    1=>'球员获取',
    2=>'球员成长',
    3=>'DNA及青训',
    4=>'装备',
    5=>'技能',
    6=>'战术',
    7=>'挂机休假',
    8=>'比赛相关',
    9=>'礼包道具抽奖',
    10=>'VIP',
    99=>'其他',
    
);
$sql = "SELECT sum(cost) as total_cost,count(*) as count_pay,typ FROM st_pay_real_credits GROUP BY typ ORDER BY total_cost DESC;";
$rst = mysql_w_query($sql);
$sum_all = 0;
$count_all = 0;
while ($row = mysql_fetch_assoc($rst)){
    $pay_total[$row['typ']] = $row;
    $sum_all+=$row['total_cost'];
    $count_all+=$row['count_pay'];
    if (!isset($config_rss[$row['typ']])){
        $rss_typ = 99;
    } else {
        $rss_typ = $config_rss[$row['typ']];
    }
    if (isset($total_rss[$rss_typ])){
        $total_rss[$rss_typ]['total_cost'] += $row['total_cost'];
        $total_rss[$rss_typ]['count_pay'] += $row['count_pay'];
    } else {
        $total_rss[$rss_typ]['total_cost'] = $row['total_cost'];
        $total_rss[$rss_typ]['count_pay'] = $row['count_pay'];
    }
}
if ($sum_all==0){
    $sum_all = 1;
}
if ($count_all==0){
    $count_all = 1;
}
?>