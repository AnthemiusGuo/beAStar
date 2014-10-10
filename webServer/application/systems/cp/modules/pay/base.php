<?

$sql = "select count(*) as st from u_user_extend where last_online > UNIX_TIMESTAMP()-300";
$rst = mysql_x_query($sql);
$row=mysql_fetch_assoc($rst);
$base_info['5m_online'] = $row['st'];

$sql = "select count(*) as st from u_user_extend where last_online > UNIX_TIMESTAMP()-3600";
$rst = mysql_x_query($sql);
$row=mysql_fetch_assoc($rst);

$base_info['1h_online'] = $row['st'];

$sql = "select count(*) as st from u_user_extend where last_online > $g_sunrise";
$rst = mysql_x_query($sql);
$row=mysql_fetch_assoc($rst);

$base_info['1d_active'] = $row['st'];

$sql = "select count(*) as st from u_user where reg_zeit > $g_sunrise";
$rst = mysql_x_query($sql);
$row=mysql_fetch_assoc($rst);
$base_info['1d_reg'] = $row['st'];

$sql = "select count(*)  as st from u_user where newbie_stat =1";
$rst = mysql_x_query($sql);
$row=mysql_fetch_assoc($rst);
$base_info['finish_newbie'] = $row['st'];

$sql = "select count(*)  as st from u_user";
$rst = mysql_x_query($sql);
$row=mysql_fetch_assoc($rst);
$base_info['total_reg'] = $row['st'];

$sql = "select count(*)  as st from u_user WHERE DOA=-1";
$rst = mysql_x_query($sql);
$row=mysql_fetch_assoc($rst);
$base_info['total_del'] = $row['st'];

$sql = "select count(*) as st from c_fixture where flag=3";
$rst = mysql_x_query($sql);
$row=mysql_fetch_assoc($rst);
$base_info['now_match'] = $row['st'];

$sql = "select sum(cost_price) as st from st_pay_price";
$rst = mysql_x_query($sql);
$row=mysql_fetch_assoc($rst);
$base_info['total_pay'] = $row['st'];

$sql = "select sum(cost_price) as st from st_pay_price WHERE zeit>$g_sunrise";
$rst = mysql_x_query($sql);
$row=mysql_fetch_assoc($rst);
$base_info['today_pay'] = $row['st'];
?>