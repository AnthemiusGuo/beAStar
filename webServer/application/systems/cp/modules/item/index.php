<?php
//查询所有item
$item_list = array();
$sql = "SELECT * FROM gift_package ORDER BY package_id";
$ret = mysql_w_query($sql);
while($row=mysql_fetch_assoc($ret)){
    $item_list[$row['package_id']]=$row;
}
?>