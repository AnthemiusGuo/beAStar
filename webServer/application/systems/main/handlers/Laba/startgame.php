<?php
include_once FR.'config/define/define.Laba.php';
include_once FR."functions/Laba/laba.func.php";
$nbet = isset($_GET['nbet'])?(int)$_GET['nbet']:0;
if ($g_user_base['level']<5){
    $nminBet = $configNminBet;
}else{
    $nminBet = $configNminBet1;
}
$json_rst['nResult'] = 0;
$json_rst['currentMoney'] = $g_user_base['credits'];
if ($nbet>$config_max_bet || $nbet<$nminBet){
    $json_rst["nbet"] = $nbet;
    $json_rst["config_max_bet"] = $config_max_bet;
    $json_rst["nminBet"] = $nminBet;
    $json_rst['nResult']=-1;
    return;
}
if ($nbet>$g_user_base['credits']){
    $json_rst['nResult']=-2;
    return;
}
$rst = change_credits($uid,11,105,0-$nbet,$configLaBagameId);
if ($rst<0){
    $json_rst['nResult']=-2;
    return;
}
$info = array();
//set_cache($uid,"LaBaBet",$nbet);
$cardList = range(0,51);
shuffle($cardList);
$vecCards = array();
$vecCards[] = array("cValue"=>$cardList[0]%13+2,"cColor"=>floor($cardList[0]/13));
$vecCards[] = array("cValue"=>$cardList[1]%13+2,"cColor"=>floor($cardList[1]/13));
$vecCards[] = array("cValue"=>$cardList[2]%13+2,"cColor"=>floor($cardList[2]/13));
$json_rst['vecCards'] = $vecCards;
$cColor = mt_rand(0,3);
$json_rst['cColor'] = $cColor;
//set_cache($uid,"LaBaBetcColor",$cColor);
$cards[] = $cardList[0];
$cards[] = $cardList[1];
$cards[] = $cardList[2];
$cardType=laba_analyse_typ($cards,$cColor);
$json_rst['cardType'] = $cardType;
$currentMoney = $g_user_base['credits']-$nbet;
$json_rst['currentMoney'] = $currentMoney;
$gameMoney = 0;
$json_rst['gameMoney'] = $gameMoney;
$money = 0;
if (isset($configwinBycardType[$cardType])){
    $money = $configwinBycardType[$cardType]*$nbet;
}
$json_rst['money'] = $money;
$info=array();
$info["nbet"] = $nbet;
$info["cColor"] = $cColor;
$info["cards"] = $cards;
$info["cardType"] = $cardType;
$info["nRemainChangeNum"] = 3;
set_cache($uid,"labaBetData",$info,1);

//local vecCards = {{cValue=14,cColor=1},{cValue=5,cColor=2},{cValue=7,cColor=3}}
		//local result = {nResult=0,cColor=1,cardType=8,currentMoney=80,gameMoney=self.ctrller.data.gameMoney,money=10000,vecCards=vecCards};
