<?php
$gs_list = array();
$sql = "SELECT * FROM c_club_info WHERE is_robot = 3";
$rst = mysql_x_query($sql);
while ($row = mysql_fetch_assoc($rst)){
    $gs_list[] = $row;
}
