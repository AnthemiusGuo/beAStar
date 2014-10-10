<?php
include_once FR.'config/define/define.Laba.php';

$nMinBet = $configNminBet;
if ($g_user_base['level']>=5){
    $nMinBet = $configNminBet1;
}
$json_rst['nMinBet'] = $nMinBet;
$json_rst['nMaxBet'] = $config_max_bet;
$json_rst['nMinAddBet']=$confignMinAddBet;
$json_rst['nMaxChangeCardNum']=$confignMaxChangeCardNum;
$json_rst['ChangeCost0']=$configChangeCost[0];
$json_rst['ChangeCost1']=$configChangeCost[1];
$json_rst['ChangeCost2']=$configChangeCost[2];
//pt_sm_gamesetting_ack = {
//		{
//			name = 	"opcode",
//			type = 	"short",
//			option = 	"required"
//		},
//		{
//			name = 	"nMinBet",
//			type = 	"int",
//			option = 	"required"
//		},
//		{
//			name = 	"nMaxBet",
//			type = 	"int",
//			option = 	"required"
//		},
//		{
//			name = 	"nMinAddBet",
//			type = 	"int",
//			option = 	"required"
//		},
//		{
//			name = 	"nMaxChangeCardNum",
//			type = 	"int",
//			option = 	"required"
//		},
//		{
//			name = 	"ChangeCost0",
//			type = 	"float",
//			option = 	"required"
//		},
//		{
//			name = 	"ChangeCost1",
//			type = 	"float",
//			option = 	"required"
//		},
//		{
//			name = 	"ChangeCost2",
//			type = 	"float",
//			option = 	"required"
//		}
//	}