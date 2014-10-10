<?php
include_once FR.'functions/item/item.func.php';

$verify_num = isset($_GET['cdk'])?mysql_real_escape_string(trim($_GET['cdk'])):'';
$verify_num = trim(strtoupper($verify_num));
$sp_vouchers = explode('-',$verify_num);
switch ($sp_vouchers[0]) {
    case 'A':
        break;
    case 'B':
        break;
    default:
        $json_rst = array('rstno'=>-1,'error'=>'验证码错误!');
        break;
}
?>