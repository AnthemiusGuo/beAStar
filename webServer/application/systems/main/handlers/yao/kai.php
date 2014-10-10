<?php
include_once FR.'functions/yao/yao.func.php';
include_once FR.'functions/log/yao.log.php';
if (!isset($_GET['match_id']) || !isset($_GET['room_id'])|| !isset($_GET['table_id']) || !isset($_POST['data'])){
    $json_rst['rstno'] = -1;
    return;
}
$match_id = $_GET['match_id'];
$room_id = $_GET['room_id'];
$table_id = $_GET['table_id'];
$bet_data = json_decode($_POST['data'],true);

//时间是场次关键字，room id是房间号关键字
//开牌算法，不管押注
mt_srand($zeit);
$dices = array(mt_rand(1,6),mt_rand(1,6),mt_rand(1,6));

$open_result = yao_anylyse_result($dices);
    
$json_rst['data']= array('dices'=>$dices,
                        'result'=>$open_result['result'],
                        'name_typ'=>$open_result['name_typ']
                        );
$json_rst['user_data'] = yao_open($room_id,$table_id,$match_id,$json_rst['data'],$bet_data);
?>