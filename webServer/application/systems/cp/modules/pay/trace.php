<?
include_once FR.'config/define/pay.config.php';


//点券消耗 $typ 1:买道具支出 2：赌球支出 3：玩家交易支出 4：其他 5：爆棚支出,6:装备冷却支出 7：改名，8：代替道具使用,9:玩家市场预扣点劵,10:挂机 11 转生　12:升级装备
 // 13 合成代替幸运符 14 代替经验转移卡使用 15,每日活动 16 球员获取类 17 经典球员续约 18联盟捐献19联盟流派更换
 //1:买道具支出 2：赌球支出 3：玩家交易支出 4：其他 5：爆棚支出,6:装备冷却支出 7：改名，8：代替道具使用,9:玩家市场预扣点劵,10:挂机 11 转生　12:升级装备
 // 13 合成代替幸运符 14 代替经验转移卡使用 15,每日活动 16 球员获取类 17 经典球员续约 18联盟捐献 19联盟流派更换 20.抽奖活动 21购买dna 22,签约赞助商
 $config_change_real_credits[2] = array(    
    1=>"买道具支出 ",
    2=>"赌球支出 ",
    3=>"玩家交易支出",
    4=>"其他",
    5=>"爆棚支出",
    6=>"装备冷却支出 ",
    7=>"改名",
    8=>"代替道具使用",
    9=>"玩家市场预扣点劵",
    10=>"挂机",
    11=>"转生",
    12=>"升级装备",
    13=>"合成代替幸运符",
    14=>"代替经验转移卡使用 ",
    15=>"每日活动",
    16=>"球员获取类",
    17=>"经典球员续约",
    18=>"联盟捐献",
    19=>"联盟流派更换",
    20=>"抽奖活动",
    21=>'购买dna',
    22=>'签约赞助商',
    23=>'个性球场',
    24=>'火星抽奖',
    25=>'建立杰宝杯',
    38=>'跳过比赛'
 );
 
$user_uid = 0;
if (isset($_GET['user_uid'])){
    $user_uid = (int)$_GET['user_uid'];
}
$main_typ = -1;
$issql = '';
if (isset($_GET['main_typ'])){
    $main_typ = (int)$_GET['main_typ'];
    if($main_typ!=-1)
    {
        $issql = $issql.' AND main_typ = '.$main_typ; 
    }
}
$typ = -1;
if (isset($_GET['typ'])){
    $typ = (int)$_GET['typ'];
    if($typ!=-1)
    {
        $issql = $issql.' AND typ = '.$typ; 
    }
}
$pay_list = $pay_total = array();
if ($user_uid>0){
    $sql = "SELECT * FROM st_change_real_credits  WHERE cid = '$user_uid' $issql ORDER BY zeit DESC";
	$rst = mysql_w_query($sql);
	$club_info = _update_club_info($user_uid);
	while ($row = mysql_fetch_assoc($rst)){
	    $pay_list[] = $row;
	}
        
    $sql = "select sum(cost) as total_cost,typ from st_pay_real_credits where cid=$user_uid GROUP BY typ;";
    $rst = mysql_w_query($sql);
    while ($row = mysql_fetch_assoc($rst)){
        $pay_total[$row['typ']] = $row;
    }
    uasort($pay_total,'sort_by_total_cost');
}
function sort_by_total_cost($a,$b){
    return ($b['total_cost']-$a['total_cost']);
}
?>