<?
$item_id = $_GET['item_id'];
if($item_id>0)
{
    $sql = "DELETE FROM gift_package WHERE package_id=$item_id";
    mysql_x_query($sql);
    $sql = "DELETE FROM gift_package_content WHERE package_id=$item_id";
    mysql_x_query($sql);
    $sql = "DELETE FROM gift_voucher WHERE package_id=$item_id";
    mysql_x_query($sql);
}


?>