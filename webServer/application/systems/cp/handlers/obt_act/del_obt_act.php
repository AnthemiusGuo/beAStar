<?php
$obt_act_id = isset($_GET['obt_act_id'])?(int)$_GET['obt_act_id']:0;

$sql = "SELECT * FROM feed_obt_act WHERE obt_act_id=$obt_act_id";
$rst = mysql_w_query($sql);
if($row = mysql_fetch_assoc($rst)){
    if($row['act_type']==14){
        $sql = "DELETE FROM e_system WHERE typ=16 AND flag=0";
        mysql_w_query($sql);
    }
}

//删除公测活动
$sql = "DELETE FROM feed_obt_act WHERE obt_act_id=$obt_act_id";
mysql_w_query($sql);


include_once FR.'functions/news/news.func.php';
_update_obt_act();
?>