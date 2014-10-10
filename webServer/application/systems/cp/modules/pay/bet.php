<?
include_once FR.'functions/club/bet.func.php';
db_news();
$bet_list = array();
$sum_bet_credits = array(1=>0,2=>0);
$sum_revenue_credits = array(1=>0,2=>0);
$sql = "SELECT *
        FROM bet_list ORDER BY bet_id DESC";
$rst = mysql_w_query($sql);
$bet_list = array();
while ($row = mysql_fetch_assoc($rst)){
    $bet_list[$row['bet_id']] = $row;
}
set_cache(0,'bet_list',$bet_list,0);
db_connect();
foreach ($bet_list as $this_bet){
    $bet_credits[$this_bet['bet_id']][1] = 0;
    $bet_credits[$this_bet['bet_id']][2] = 0;
    $revenue_creadits[$this_bet['bet_id']][1] = 0;
    $revenue_creadits[$this_bet['bet_id']][2] = 0;
    
    $sql = "SELECT bet_credits_typ,SUM(bet_credits) as sum_bet FROM u_bet_info WHERE bet_id=$this_bet[bet_id] GROUP BY bet_credits_typ";
    $rst = mysql_x_query($sql);
    while ($row = mysql_fetch_assoc($rst)){
        $bet_credits[$this_bet['bet_id']][$row['bet_credits_typ']] = $row['sum_bet'];
        $sum_bet_credits[$row['bet_credits_typ']] +=$row['sum_bet'];
    }
    $sql = "SELECT bet_credits_typ,SUM(bet_revenue) as sum_bet FROM u_bet_info WHERE bet_id=$this_bet[bet_id] AND award_state>2 GROUP BY bet_credits_typ";
    $rst = mysql_x_query($sql);
    while ($row = mysql_fetch_assoc($rst)){
        $revenue_creadits[$this_bet['bet_id']][$row['bet_credits_typ']] = $row['sum_bet'];
        $sum_revenue_credits[$row['bet_credits_typ']] +=$row['sum_bet'];
    }
    
}
