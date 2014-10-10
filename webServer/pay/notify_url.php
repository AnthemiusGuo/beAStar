<?php
/* *
 * 功能：支付宝服务器异步通知页面
 * 版本：3.3
 * 日期：2012-07-23
 * 说明：
 * 以下代码只是为了方便商户测试而提供的样例代码，商户可以根据自己网站的需要，按照技术文档编写,并非一定要使用该代码。
 * 该代码仅供学习和研究支付宝接口使用，只是提供一个参考。


 *************************页面功能说明*************************
 * 创建该页面文件时，请留心该页面文件中无任何HTML代码及空格。
 * 该页面不能在本机电脑测试，请到服务器上做测试。请确保外部可以访问该页面。
 * 该页面调试工具请使用写文本函数logResult，该函数已被默认关闭，见alipay_notify_class.php中的函数verifyNotify
 * 如果没有收到该页面返回的 success 信息，支付宝会在24小时内按一定的时间策略重发通知
 */
$g_access_mode = -2;
$g_server_name = 'local';

include_once '../processes/base_init.process.php';
include_once FR.'config/server/'.$g_server_name.'.config.php';
include_once FR.'functions/common/base.func.php';
include_once FR.'functions/common/db.func.php';
include_once FR.'functions/user/user_info.func.php';
base_prepare();
db_connect();

require_once("alipay.config.php");
require_once("lib/alipay_notify.class.php");
//计算得出通知验证结果
$mm = print_r($_POST,true);
logResult($mm);
$alipayNotify = new AlipayNotify($alipay_config);
$verify_result = $alipayNotify->verifyNotify();

if($verify_result) {//验证成功

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//请在这里加上商户的业务逻辑程序代

	
	//——请根据您的业务逻辑来编写程序（以下代码仅作参考）——
	
    //获取支付宝的通知返回参数，可参考技术文档中服务器异步通知参数列表
	
	//商户订单号

	$out_trade_no = $_POST['out_trade_no'];

	//支付宝交易号

	$trade_no = $_POST['trade_no'];

	//交易状态
	$trade_status = $_POST['trade_status'];


    if($_POST['trade_status'] == 'TRADE_FINISHED') {
		//判断该笔订单是否在商户网站中已经做过处理
			//如果没有做过处理，根据订单号（out_trade_no）在商户网站的订单系统中查到该笔订单的详细，并执行商户的业务程序
			//如果有做过处理，不执行商户的业务程序
				
		//注意：
		//该种交易状态只在两种情况下出现
		//1、开通了普通即时到账，买家付款成功后。
		//2、开通了高级即时到账，从该笔交易成功时间算起，过了签约时的可退款时限（如：三个月以内可退款、一年以内可退款等）后。

        //调试用，写文本函数记录程序运行情况是否正常
        //logResult("这里写入想要调试的代码变量值，或其他运行的结果记录");
        $out_trade_no = $_POST['out_trade_no'];
        $pay_info = explode('_', $out_trade_no);
        $pay_uid = $pay_info[0];
        $pay_package_id = $pay_info[1];
        $pay_begin_datetime = $pay_info[2];
        $pay_notify_zeit = $zeit;
        $total_fee = (int)(100*$_POST['total_fee']);//钱 以分为单位
        $gmt_payment = $_POST['gmt_payment'];//交易时间
        //price 单位是分
        //alipay 回调函数是 float 类型，单位是元
        //检查下是不是相等
        
        $cfg_pay = array(
        	"1"=>array("price"=>1200,"amount"=>130000,"speak_amount"=>1),
        	"2"=>array("price"=>9800,"amount"=>1200000,"speak_amount"=>10),
        	"3"=>array("price"=>48800,"amount"=>6100000,"speak_amount"=>50)
        );
        if(pay_get_pay_status($out_trade_no)==1){//没有发货记录
            //加钱，加喇叭
            if($pay_package_id!=0&&isset($cfg_pay[$pay_package_id])){
                pay_callback($pay_uid,$cfg_pay[$pay_package_id]);
		$typ = 1;
                pay_insert_pay_log($pay_uid,$out_trade_no,$pay_package_id,$total_fee,$gmt_payment,$typ);
                
            }
            
        }
        echo "success";	
        

    }
    else if ($_POST['trade_status'] == 'TRADE_SUCCESS') {
		//判断该笔订单是否在商户网站中已经做过处理
			//如果没有做过处理，根据订单号（out_trade_no）在商户网站的订单系统中查到该笔订单的详细，并执行商户的业务程序
			//如果有做过处理，不执行商户的业务程序
				
		//注意：
		//该种交易状态只在一种情况下出现——开通了高级即时到账，买家付款成功后。

        //调试用，写文本函数记录程序运行情况是否正常
        //logResult("这里写入想要调试的代码变量值，或其他运行的结果记录");
    }

	//——请根据您的业务逻辑来编写程序（以上代码仅作参考）——
        
	echo "success";		//请不要修改或删除
	
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
}
else {
    //验证失败
    echo "fail";

    //调试用，写文本函数记录程序运行情况是否正常
    //logResult("这里写入想要调试的代码变量值，或其他运行的结果记录");
}
?>