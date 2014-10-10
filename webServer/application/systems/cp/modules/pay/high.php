<?
if (isset($_GET['lt'])){
    $lt = (int)$_GET['lt'] * 10;
} else {
    $lt = 1000;
}
$sql = "SELECT uid,total_pay,last_online FROM u_user_extend WHERE total_pay>=$lt ORDER BY total_pay DESC";
$rst = mysql_x_query($sql);
$high_players = array();
while ($row = mysql_fetch_assoc($rst)){
    $cid = $row['uid'];
    $info =  club_get_club_info($cid);
    $info['total_pay'] = $row['total_pay'];
    $info['last_online'] = $row['last_online'];
    $high_players[] = $info;
}
?>