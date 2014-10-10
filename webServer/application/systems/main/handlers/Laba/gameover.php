<?php
include_once FR.'config/define/define.Laba.php';
include_once FR."functions/Laba/laba.func.php";
$labaData = get_cache($uid,"labaBetData",1);
if ($labaData==-1||$labaData==-2){
    $json_rst['fBetScale'] = 0;
    $json_rst['cCardType'] = -1;
    $json_rst['nBonus'] = -1;
    $json_rst['currentMoney'] = $g_user_base['credits'];
    $json_rst['gameMoney'] = 0;
    $json_rst['money'] = 0;
    return;
}
if(!isset($labaData['data'])){
    $json_rst['fBetScale'] = 0;
    $json_rst['cCardType'] = -1;
    $json_rst['nBonus'] = -1;
    $json_rst['currentMoney'] = $g_user_base['credits'];
    $json_rst['gameMoney'] = 0;
    $json_rst['money'] = 0;
    return;
}
$labaData = $labaData['data'];
$cardType = $labaData['cardType'];
$nbet = $labaData['nbet'];
$fBetScale = 0;
if (isset($configwinBycardType[$cardType])){
    $fBetScale = $configwinBycardType[$cardType];
}
$info = array();
set_cache($uid,"labaBetData",$info,1);
$json_rst['fBetScale'] = $fBetScale;
$json_rst['cCardType'] = $cardType;
$json_rst['nBonus'] = $fBetScale*$nbet;
$json_rst['currentMoney'] = $g_user_base['credits'];
$json_rst['gameMoney'] = 0;
$json_rst['money'] = 0;
//{fBetScale=25,nBonus=1000,cCardType=0,currentMoney=self.data.money_,gameMoney=self.data.gameMoney,money=10000}