<?
$sql = "SELECT uid FROM u_user WHERE vip_typ>0 AND vip_end_zeit>$zeit-86400";
$rst = mysql_x_query($sql);
$vip_num = mysql_num_rows($rst);
?>