<?php
include_once FR.'config/define/define.Laba.php';
include_once FR."functions/Laba/laba.func.php";

//local result={nResult=0,nRemainChangeNum=2,cPos=1,oCard={cValue=14,cColor=0},cardType=6,currentMoney=32,gameMoney=self.data.gameMoney,money=1000}
$cPos = isset($_GET['cPos'])?(int)$_GET['cPos']:-1;
$json_rst['nResult'] = -1;
$json_rst['nRemainChangeNum'] = -1;
$json_rst['cPos'] = -1;
$json_rst['oCard'] = array();
$json_rst['cardType'] = 0;
$json_rst['currentMoney'] = 0;
$json_rst['gameMoney'] = 0;
$json_rst['money'] = 0;
if(!in_array($cPos,array(0,1,2))){
    $json_rst["money"] = -1;
    return;
}
$labaData = get_cache($uid,"labaBetData",1);

if ($labaData==-1||$labaData==-2||!isset($labaData['data'])){
     $json_rst["money"] = -2;
    return;
}
$labaData = $labaData['data'];
$json_rst["labaData"] = $labaData;
if(!isset($labaData['nbet'])){
    $json_rst["money"] = -3;
    return;
}
if ($labaData["nRemainChangeNum"] <= 0){
    $json_rst["money"] = -4;
    return;
}
if(!isset($configChangeCost[(3-$labaData["nRemainChangeNum"])])){
    $json_rst["money"] = -5;
    return;
}
$rate = $configChangeCost[(3-$labaData["nRemainChangeNum"])];

$cost = $labaData['nbet']*$rate/100;
if ($cost>$g_user_base["credits"]){
    $json_rst["money"] = -6;
     $json_rst['nResult'] = -2;
     return;
}
$rst = change_credits($uid,11,106,$cost,$configLaBagameId);
if ($rst<0){
    $json_rst["money"] = -7;
    $json_rst['nResult']=-2;
    return;
}
$cardList = array();
for($i=0;$i<=51;$i++){
    if(!in_array($i,$labaData['cards'])){
        $cardList[] = $i;
    }
    
}
$json_rst["nResult"] = 0;
shuffle($cardList);
$json_rst['cPos'] = $cPos;
$json_rst['oCard'] = array("cValue"=>$cardList[0]%13+2,"cColor"=>floor($cardList[0]/13));
$labaData['cards'][$cPos] = $cardList[0];
$cardType=laba_analyse_typ($labaData['cards'],$labaData["cColor"]);
$labaData["cardType"] = $cardType;
$json_rst['cardType'] = $cardType;
$user_base = user_get_user_base($uid);
$json_rst['currentMoney'] = $user_base["credits"];
$json_rst['gameMoney'] = 0;
$json_rst['money'] = 0;
$labaData["nRemainChangeNum"]--;
$json_rst["nRemainChangeNum"] = $labaData["nRemainChangeNum"];
set_cache($uid,"labaBetData",$labaData,1);
