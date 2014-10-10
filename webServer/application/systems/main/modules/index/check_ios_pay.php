<?
$IOS_SANDBOX = false;
$product_id = $_POST['productId'];
$recept = $_POST['recept'];
$check_uid = $_POST['uid'];
$verifyCode = $_POST['verifyCode'];
$publicKey = 'His*726';
if ($check_uid!=$uid){
	$json_rst['rstno'] = -1;
	$json_rst['error'] = '账户信息错误';
	return;
}
if ($verifyCode != md5($product_id.$recept.$check_uid.$publicKey)){
	$json_rst['rstno'] = -2;
	$json_rst['error'] = '支付信息错误';
	return;
}
if ($IOS_SANDBOX){
	$url = "https://sandbox.itunes.apple.com/verifyReceipt";
} else {
	$url = "https://buy.itunes.apple.com/verifyReceipt";
}
$post_data["receipt-data"] = $recept;

$post_string = json_encode($post_data);
$rst = call_remote_by_curl_post($url,$post_string);
$json_callback = json_decode($rst,true);

if ($json_callback['status']==0){
	$json_rst['rstno']=1;
	//$json_rst['espData'] = $json_callback['receipt'];
	// "original_purchase_date_pst":"2013-12-30 08:24:43 America\/Los_Angeles","purchase_date_ms":"1388420683003","unique_identifier":"c21ace27ac31565e5575985caa02ed69a9dc7485","original_transaction_id":"1000000097544882","bvrs":"1.0","transaction_id":"1000000097544882","quantity":"1","unique_vendor_identifier":"802712F3-9009-483B-BCE0-E354ED54FBE8","item_id":"776813388","product_id":"com.goushiqipai.zjh.pkg.03","purchase_date":"2013-12-30 16:24:43 Etc\/GMT","original_purchase_date":"2013-12-30 16:24:43 Etc\/GMT","purchase_date_pst":"2013-12-30 08:24:43 America\/Los_Angeles","bid":"com.goushiqipai.zjh","original_purchase_date_ms":"1388420683003"
	$out_trade_no = $json_callback['receipt']['transaction_id'];
	$trade_no = $json_callback['receipt']['original_transaction_id'];

	$pay_package = $json_callback['receipt']['product_id'];
	// if ($product_id != $pay_package){
	// 	//hack in!!!
	// 	$json_rst['rstno'] = -3;
	// 	$json_rst['error'] = '账户信息错误';
	// 	return;
	// }
	$pay_package_info = explode('.', $pay_package);

	$pay_package_id = (int)$pay_package_info[4];

	$trade_status = $json_callback['status'];

	$pay_uid = $check_uid;

    $pay_begin_datetime = $json_callback['receipt']['original_purchase_date_ms'];
    $pay_notify_zeit = $zeit;
    
    $gmt_payment = $json_callback['receipt']['purchase_date_pst'];//交易时间
    //price 单位是分
    //alipay 回调函数是 float 类型，单位是元
    //检查下是不是相等
    
    $cfg_pay = array(
    	"1"=>array("price"=>1200,"amount"=>130000,"speak_amount"=>1),
    	"2"=>array("price"=>9800,"amount"=>1200000,"speak_amount"=>10),
    	"3"=>array("price"=>48800,"amount"=>6100000,"speak_amount"=>50)
    );
    $total_fee = $cfg_pay[$pay_package_id]['price'];//钱 以分为单位
    if(pay_get_pay_status($out_trade_no)==1){//没有发货记录
        //加钱，加喇叭
        if($pay_package_id!=0&&isset($cfg_pay[$pay_package_id])){
            pay_callback($pay_uid,$cfg_pay[$pay_package_id]);
	    $typ = 2;
            pay_insert_pay_log($pay_uid,$out_trade_no,$pay_package_id,$total_fee,$gmt_payment,$typ);
            
        }
        $json_rst['credits'] = $g_user_base['credits'];
        
    } else {
    	$json_rst['rstno'] = -4;
		$json_rst['error'] = '订单号重复，您的游戏币是否已经到账?';
		return;
    }
} else {
	$json_rst['rstno'] = 0-$json_callback['status'];
	$json_rst['error'] = '账户信息错误';
	return;
}
?>