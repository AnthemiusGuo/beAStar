<?php
//查询所有管理员
$manager_list = array();
$sql = "SELECT * FROM admin_editor";
$ret = mysql_w_query($sql);
while($row=mysql_fetch_assoc($ret)){
    $manager_list[$row['admin_uid']]=$row;
}
//权限
$admin_list = array(
    0=>"普通客服",
    1=>"超级管理员",
    2=>"礼包管理员",
    3=>"XXX",
    4=>"管理员"
);
?>