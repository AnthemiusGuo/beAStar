packetDefine = packetDefine or {};
opcodeDefine = opcodeDefine or {};
opcodeReverse = opcodeReverse or {};
packetDefine["CCard"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"m_nColor",
type	=	"char",
	option	=	"required"
	},
	{
	name	=	"m_nValue",
type	=	"char",
	option	=	"required"
	},
	{
	name	=	"m_nCard_Baovalue",
type	=	"char",
	option	=	"required"
	}
};
packetDefine["CCardsType"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"m_nTypeBomb",
type	=	"int",
	option	=	"required"
	},
	{
	name	=	"m_nTypeNum",
type	=	"int",
	option	=	"required"
	},
	{
	name	=	"m_nTypeValue",
type	=	"int",
	option	=	"required"
	}
};
packetDefine["TaskItem"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"task_id_",
type	=	"int",
	option	=	"required"
	},
	{
	name	=	"task_desc_",
type	=	"string",
	option	=	"required"
	},
	{
	name	=	"task_mission_",
type	=	"string",
	option	=	"required"
	},
	{
	name	=	"task_money_type_",
type	=	"int",
	option	=	"required"
	},
	{
	name	=	"task_money_",
type	=	"int",
	option	=	"required"
	},
	{
	name	=	"task_rate_",
type	=	"char",
	option	=	"required"
	}
};
packetDefine["pt_gc_game_start_not"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"nGameMoney",
type	=	"int",
	option	=	"required"
	},
	{
	name	=	"nCardNum",
type	=	"int",
	option	=	"required"
	},
	{
	name	=	"nLordPos",
type	=	"int",
	option	=	"required"
	},
	{
	name	=	"cLordCard",
type	=	"CCard",
	option	=	"required"
	},
	{
	name	=	"nSerialID",
type	=	"int",
	option	=	"required"
	}
};
packetDefine["pt_cg_send_card_ok_ack"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"nSerialID",
type	=	"int",
	option	=	"required"
	}
};
packetDefine["pt_gc_refresh_card_not"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"cChairID",
type	=	"char",
	option	=	"required"
	},
	{
	name	=	"vecCards",
type	=	"CCard",
	option	=	"repeated"
	}
};
packetDefine["pt_gc_call_score_req"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"nScore",
type	=	"int",
	option	=	"required"
	},
	{
	name	=	"nSerialID",
type	=	"int",
	option	=	"required"
	}
};
packetDefine["pt_cg_call_score_ack"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"nScore",
type	=	"int",
	option	=	"required"
	},
	{
	name	=	"nSerialID",
type	=	"int",
	option	=	"required"
	}
};
packetDefine["pt_gc_rob_lord_req"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"cDefaultLord",
type	=	"char",
	option	=	"required"
	},
	{
	name	=	"nSerialID",
type	=	"int",
	option	=	"required"
	}
};
packetDefine["pt_cg_rob_lord_ack"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"cRob",
type	=	"char",
	option	=	"required"
	},
	{
	name	=	"nSerialID",
type	=	"int",
	option	=	"required"
	}
};
packetDefine["pt_gc_lord_card_not"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"cLord",
type	=	"char",
	option	=	"required"
	},
	{
	name	=	"vecCards",
type	=	"CCard",
	option	=	"repeated"
	}
};
packetDefine["pt_gc_play_card_req"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"cAuto",
type	=	"char",
	option	=	"required"
	},
	{
	name	=	"nSerialID",
type	=	"int",
	option	=	"required"
	}
};
packetDefine["pt_cg_play_card_ack"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"nSerialID",
type	=	"int",
	option	=	"required"
	},
	{
	name	=	"cTimeOut",
type	=	"char",
	option	=	"required"
	},
	{
	name	=	"vecCards",
type	=	"CCard",
	option	=	"repeated"
	}
};
packetDefine["pt_gc_play_card_not"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"cChairID",
type	=	"char",
	option	=	"required"
	},
	{
	name	=	"vecCards",
type	=	"CCard",
	option	=	"repeated"
	},
	{
	name	=	"cType",
type	=	"CCardsType",
	option	=	"required"
	}
};
packetDefine["pt_gc_common_not"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"nOp",
type	=	"int",
	option	=	"required"
	},
	{
	name	=	"cChairID",
type	=	"char",
	option	=	"required"
	}
};
packetDefine["stUserResult"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"nChairID",
type	=	"char",
	option	=	"required"
	},
	{
	name	=	"nScore",
type	=	"int",
	option	=	"required"
	}
};
packetDefine["pt_gc_game_result_not"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"bType",
type	=	"char",
	option	=	"required"
	},
	{
	name	=	"cDouble",
type	=	"int",
	option	=	"required"
	},
	{
	name	=	"cCallScore",
type	=	"char",
	option	=	"required"
	},
	{
	name	=	"bShowCard",
type	=	"char",
	option	=	"required"
	},
	{
	name	=	"nBombCount",
type	=	"char",
	option	=	"required"
	},
	{
	name	=	"bSpring",
type	=	"char",
	option	=	"required"
	},
	{
	name	=	"bReverseSpring",
type	=	"char",
	option	=	"required"
	},
	{
	name	=	"bRobLord",
type	=	"char",
	option	=	"required"
	},
	{
	name	=	"vecUserResult",
type	=	"stUserResult",
	option	=	"repeated"
	}
};
packetDefine["stUserResult1"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"nChairID",
type	=	"char",
	option	=	"required"
	},
	{
	name	=	"nScore",
type	=	"int",
	option	=	"required"
	},
	{
	name	=	"nJifen",
type	=	"int",
	option	=	"required"
	}
};
packetDefine["pt_gc_game_result_not1"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"bType",
type	=	"char",
	option	=	"required"
	},
	{
	name	=	"cDouble",
type	=	"int",
	option	=	"required"
	},
	{
	name	=	"cCallScore",
type	=	"char",
	option	=	"required"
	},
	{
	name	=	"bShowCard",
type	=	"char",
	option	=	"required"
	},
	{
	name	=	"nBombCount",
type	=	"char",
	option	=	"required"
	},
	{
	name	=	"bSpring",
type	=	"char",
	option	=	"required"
	},
	{
	name	=	"bReverseSpring",
type	=	"char",
	option	=	"required"
	},
	{
	name	=	"bRobLord",
type	=	"char",
	option	=	"required"
	},
	{
	name	=	"vecUserResult1",
type	=	"stUserResult1",
	option	=	"repeated"
	}
};
packetDefine["pt_gc_bomb_not"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"nDouble",
type	=	"int",
	option	=	"required"
	}
};
packetDefine["pt_cg_auto_req"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"cAuto",
type	=	"char",
	option	=	"required"
	}
};
packetDefine["pt_gc_auto_not"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"cChairID",
type	=	"char",
	option	=	"required"
	},
	{
	name	=	"cAuto",
type	=	"char",
	option	=	"required"
	}
};
packetDefine["stUserData"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"cChairID",
type	=	"char",
	option	=	"required"
	},
	{
	name	=	"vecHandCards",
type	=	"CCard",
	option	=	"repeated"
	},
	{
	name	=	"vecPutCards",
type	=	"CCard",
	option	=	"repeated"
	}
};
packetDefine["pt_cg_complete_data_req"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	}
};
packetDefine["pt_gc_complete_data_not"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"nGameMoney",
type	=	"int",
	option	=	"required"
	},
	{
	name	=	"nDouble",
type	=	"int",
	option	=	"required"
	},
	{
	name	=	"cLord",
type	=	"char",
	option	=	"required"
	},
	{
	name	=	"vecLordCards",
type	=	"CCard",
	option	=	"repeated"
	},
	{
	name	=	"vecData",
type	=	"stUserData",
	option	=	"repeated"
	}
};
packetDefine["pt_gc_show_card_req"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"nSerialID",
type	=	"int",
	option	=	"required"
	}
};
packetDefine["pt_cg_show_card_ack"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"cShowCard",
type	=	"char",
	option	=	"required"
	},
	{
	name	=	"nSerialID",
type	=	"int",
	option	=	"required"
	}
};
packetDefine["pt_gc_show_card_not"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"nChairID",
type	=	"int",
	option	=	"required"
	},
	{
	name	=	"vecCards",
type	=	"CCard",
	option	=	"repeated"
	}
};
packetDefine["pt_gc_clienttimer_not"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"chairId",
type	=	"int",
	option	=	"required"
	},
	{
	name	=	"sPeriod",
type	=	"int",
	option	=	"required"
	}
};
packetDefine["pt_gc_task_not"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"task_item_",
type	=	"TaskItem",
	option	=	"required"
	}
};
packetDefine["pt_gc_task_complete_not"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"chair_id_",
type	=	"int",
	option	=	"required"
	},
	{
	name	=	"task_status_",
type	=	"char",
	option	=	"required"
	}
};
packetDefine["pt_cg_card_count_req"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	}
};
packetDefine["pt_gc_card_count_ack1"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"counts_num_",
type	=	"int",
	option	=	"required"
	},
	{
	name	=	"m_vecPutCard",
type	=	"CCard",
	option	=	"repeated"
	}
};
packetDefine["pt_gc_card_count_ack"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"counts_num_",
type	=	"char",
	option	=	"required"
	},
	{
	name	=	"m_vecPutCard",
type	=	"CCard",
	option	=	"repeated"
	}
};
packetDefine["pt_gc_laizi_not"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"card_value",
type	=	"char",
	option	=	"required"
	}
};
packetDefine["pt_gc_counts_not"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"counts_num_",
type	=	"char",
	option	=	"required"
	}
};
packetDefine["pt_gc_counts_not1"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"counts_num_",
type	=	"int",
	option	=	"required"
	}
};
packetDefine["pt_gc_expression_not"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"expression_type_",
type	=	"int",
	option	=	"required"
	},
	{
	name	=	"expression_num_",
type	=	"int",
	option	=	"required"
	}
}
packetDefine["PlyBaseData"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"ply_guid_",
type	=	"guid",
	option	=	"required"
	},
	{
	name	=	"nickname_",
type	=	"string",
	option	=	"required"
	},
	{
	name	=	"sex_",
type	=	"int",
	option	=	"required"
	},
	{
	name	=	"gift_",
type	=	"int",
	option	=	"required"
	},
	{
	name	=	"money_",
type	=	"int64",
	option	=	"required"
	},
	{
	name	=	"score_",
type	=	"int",
	option	=	"required"
	},
	{
	name	=	"won_",
type	=	"int",
	option	=	"required"
	},
	{
	name	=	"lost_",
type	=	"int",
	option	=	"required"
	},
	{
	name	=	"dogfall_",
type	=	"int",
	option	=	"required"
	},
	{
	name	=	"table_id_",
type	=	"int",
	option	=	"required"
	},
	{
	name	=	"param_1_",
type	=	"int",
	option	=	"required"
	},
	{
	name	=	"param_2_",
type	=	"int",
	option	=	"required"
	},
	{
	name	=	"chair_id_",
type	=	"char",
	option	=	"required"
	},
	{
	name	=	"ready_",
type	=	"char",
	option	=	"required"
	},
	{
	name	=	"ply_vip_",
type	=	"VipData",
	option	=	"required"
	}
};
packetDefine["TableAttr"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"table_id_",
type	=	"int",
	option	=	"required"
	},
	{
	name	=	"name_",
type	=	"string",
	option	=	"required"
	},
	{
	name	=	"lock_",
type	=	"char",
	option	=	"required"
	},
	{
	name	=	"players_",
type	=	"PlyBaseData",
	option	=	"repeated"
	}
};
packetDefine["pt_bc_login_ack"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"ret_",
type	=	"char",
	option	=	"required"
	},
	{
	name	=	"ply_base_data_",
type	=	"PlyBaseData",
	option	=	"required"
	},
	{
	name	=	"ply_status_",
type	=	"PlayerStatus",
	option	=	"required"
	}
};
packetDefine["pt_bc_join_table_ack"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"ret_",
type	=	"char",
	option	=	"required"
	},
	{
	name	=	"table_attrs_",
type	=	"TableAttr",
	option	=	"required"
	},
	{
	name	=	"errMsg_",
type	=	"string",
	option	=	"required"
	}
};
packetDefine["pt_bc_ply_join_not"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"ply_data_",
type	=	"PlyBaseData",
	option	=	"required"
	}
};
packetDefine["pt_bc_create_table_ack"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"ret_",
type	=	"char",
	option	=	"required"
	},
	{
	name	=	"table_attrs_",
type	=	"TableAttr",
	option	=	"required"
	}
};
packetDefine["pt_bc_update_ply_data_not"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"ply_guid_",
type	=	"guid",
	option	=	"required"
	},
	{
	name	=	"upt_reason_",
type	=	"char",
	option	=	"required"
	},
	{
	name	=	"upt_type_",
type	=	"char",
	option	=	"required"
	},
	{
	name	=	"variant_",
type	=	"int",
	option	=	"required"
	},
	{
	name	=	"amount_",
type	=	"int64",
	option	=	"required"
	}
};
packetDefine["PlyBaseData20121227"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"ply_guid_",
type	=	"guid",
	option	=	"required"
	},
	{
	name	=	"nickname_",
type	=	"string",
	option	=	"required"
	},
	{
	name	=	"gift_",
type	=	"int",
	option	=	"required"
	},
	{
	name	=	"money_",
type	=	"int",
	option	=	"required"
	},
	{
	name	=	"score_",
type	=	"int",
	option	=	"required"
	},
	{
	name	=	"won_",
type	=	"int",
	option	=	"required"
	},
	{
	name	=	"lost_",
type	=	"int",
	option	=	"required"
	},
	{
	name	=	"dogfall_",
type	=	"int",
	option	=	"required"
	},
	{
	name	=	"table_id_",
type	=	"int",
	option	=	"required"
	},
	{
	name	=	"chair_id_",
type	=	"char",
	option	=	"required"
	},
	{
	name	=	"ready_",
type	=	"char",
	option	=	"required"
	}
};
packetDefine["TableAttr20121227"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"table_id_",
type	=	"int",
	option	=	"required"
	},
	{
	name	=	"name_",
type	=	"string",
	option	=	"required"
	},
	{
	name	=	"lock_",
type	=	"char",
	option	=	"required"
	},
	{
	name	=	"players_",
type	=	"PlyBaseData20121227",
	option	=	"repeated"
	}
};
packetDefine["TableItemAttr"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"table_id_",
type	=	"int",
	option	=	"required"
	},
	{
	name	=	"name_",
type	=	"string",
	option	=	"required"
	},
	{
	name	=	"lock_",
type	=	"char",
	option	=	"required"
	},
	{
	name	=	"status_",
type	=	"char",
	option	=	"required"
	},
	{
	name	=	"base_score_",
type	=	"int",
	option	=	"required"
	},
	{
	name	=	"cur_ply_num_",
type	=	"int",
	option	=	"required"
	}
};
packetDefine["TableItemAttr2"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"table_id_",
type	=	"int",
	option	=	"required"
	},
	{
	name	=	"name_",
type	=	"string",
	option	=	"required"
	},
	{
	name	=	"lock_",
type	=	"char",
	option	=	"required"
	},
	{
	name	=	"status_",
type	=	"char",
	option	=	"required"
	},
	{
	name	=	"base_score_",
type	=	"int",
	option	=	"required"
	},
	{
	name	=	"cur_ply_num_",
type	=	"int",
	option	=	"required"
	},
	{
	name	=	"ply_min_money_",
type	=	"int",
	option	=	"required"
	}
};
packetDefine["pt_cb_login_req"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"ply_guid_",
type	=	"guid",
	option	=	"required"
	},
	{
	name	=	"ply_ticket_",
type	=	"string",
	option	=	"required"
	},
	{
	name	=	"version_",
type	=	"int",
	option	=	"required"
	},
	{
	name	=	"ext_param_",
type	=	"string",
	option	=	"required"
	}
};
packetDefine["pt_bc_login_ack20121227"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"ret_",
type	=	"char",
	option	=	"required"
	},
	{
	name	=	"ply_base_data_",
type	=	"PlyBaseData20121227",
	option	=	"required"
	},
	{
	name	=	"ply_status_",
type	=	"PlayerStatus20121227",
	option	=	"required"
	}
};
packetDefine["pt_cb_join_table_req"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"table_id_",
type	=	"int",
	option	=	"required"
	},
	{
	name	=	"password_",
type	=	"string",
	option	=	"required"
	}
};
packetDefine["pt_bc_join_table_ack20121227"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"ret_",
type	=	"char",
	option	=	"required"
	},
	{
	name	=	"table_attrs_",
type	=	"TableAttr20121227",
	option	=	"required"
	}
};
packetDefine["pt_cb_leave_table_req"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	}
};
packetDefine["pt_bc_leave_table_ack"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"ret_",
type	=	"char",
	option	=	"required"
	},
	{
	name	=	"ply_nickname_",
type	=	"string",
	option	=	"required"
	}
};
packetDefine["pt_bc_ply_join_not20121227"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"ply_data_",
type	=	"PlyBaseData20121227",
	option	=	"required"
	}
};
packetDefine["pt_bc_ply_leave_not"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"ply_guid_",
type	=	"guid",
	option	=	"required"
	}
};
packetDefine["pt_cb_ready_req"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	}
};
packetDefine["pt_bc_ready_not"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"ply_guid_",
type	=	"guid",
	option	=	"required"
	}
};
packetDefine["pt_cb_chat_req"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"type_",
type	=	"char",
	option	=	"required"
	},
	{
	name	=	"message_",
type	=	"string",
	option	=	"required"
	}
};
packetDefine["pt_bc_chat_not"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"ply_guid_",
type	=	"guid",
	option	=	"required"
	},
	{
	name	=	"nickname_",
type	=	"string",
	option	=	"required"
	},
	{
	name	=	"message_",
type	=	"string",
	option	=	"required"
	}
};
packetDefine["pt_cb_change_table_req"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	}
};
packetDefine["pt_cb_visit_table_req"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"table_id_",
type	=	"int",
	option	=	"required"
	},
	{
	name	=	"password_",
type	=	"string",
	option	=	"required"
	}
};
packetDefine["pt_cb_get_online_award_req"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"type_",
type	=	"char",
	option	=	"required"
	}
};
packetDefine["pt_bc_get_online_award_ack"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"ret_",
type	=	"char",
	option	=	"required"
	},
	{
	name	=	"remain_",
type	=	"int",
	option	=	"required"
	},
	{
	name	=	"money_",
type	=	"int",
	option	=	"required"
	}
};
packetDefine["pt_cb_ply_place_not"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"latitude_",
type	=	"float",
	option	=	"required"
	},
	{
	name	=	"longitude_",
type	=	"float",
	option	=	"required"
	}
};
packetDefine["pt_bc_update_ply_data_not20121227"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"ply_guid_",
type	=	"guid",
	option	=	"required"
	},
	{
	name	=	"upt_reason_",
type	=	"char",
	option	=	"required"
	},
	{
	name	=	"upt_type_",
type	=	"char",
	option	=	"required"
	},
	{
	name	=	"variant_",
type	=	"int",
	option	=	"required"
	},
	{
	name	=	"amount_",
type	=	"int",
	option	=	"required"
	}
};
packetDefine["pt_bc_cli_timer_not"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"ply_guid_",
type	=	"guid",
	option	=	"required"
	},
	{
	name	=	"idle_time_",
type	=	"int",
	option	=	"required"
	}
};
packetDefine["pt_bc_message_not"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"type_",
type	=	"char",
	option	=	"required"
	},
	{
	name	=	"message_",
type	=	"string",
	option	=	"required"
	}
};
packetDefine["pt_cb_create_table_req"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"name_",
type	=	"string",
	option	=	"required"
	},
	{
	name	=	"password_",
type	=	"string",
	option	=	"required"
	},
	{
	name	=	"base_score_",
type	=	"int",
	option	=	"required"
	}
};
packetDefine["pt_bc_create_table_ack20121227"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"ret_",
type	=	"char",
	option	=	"required"
	},
	{
	name	=	"table_attrs_",
type	=	"TableAttr20121227",
	option	=	"required"
	}
};
packetDefine["pt_cb_get_table_list_req"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	}
};
packetDefine["pt_bc_get_table_list_ack"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"items_",
type	=	"TableItemAttr",
	option	=	"repeated"
	}
};
packetDefine["pt_cb_give_gift_req"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"dst_ply_guid_",
type	=	"guid",
	option	=	"required"
	},
	{
	name	=	"amount_",
type	=	"int",
	option	=	"required"
	}
};
packetDefine["pt_bc_give_gift_ack"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"ret_",
type	=	"char",
	option	=	"required"
	},
	{
	name	=	"balance_",
type	=	"int",
	option	=	"required"
	}
};
packetDefine["pt_bc_give_gift_not"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"src_ply_guid_",
type	=	"guid",
	option	=	"required"
	},
	{
	name	=	"dst_ply_guid_",
type	=	"guid",
	option	=	"required"
	},
	{
	name	=	"amount_",
type	=	"int",
	option	=	"required"
	}
};
packetDefine["pt_cb_get_match_data_req"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	}
};
packetDefine["MatchRank"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"ply_guid_",
type	=	"guid",
	option	=	"required"
	},
	{
	name	=	"ply_nickname_",
type	=	"string",
	option	=	"required"
	},
	{
	name	=	"match_score_",
type	=	"int",
	option	=	"required"
	}
};
packetDefine["pt_bc_get_match_data_ack"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"max_game_rounds_",
type	=	"int",
	option	=	"required"
	},
	{
	name	=	"match_fee_",
type	=	"int",
	option	=	"required"
	},
	{
	name	=	"ply_self_rank_",
type	=	"int",
	option	=	"required"
	},
	{
	name	=	"score_rank_",
type	=	"MatchRank",
	option	=	"repeated"
	},
	{
	name	=	"open_time_",
type	=	"int",
	option	=	"required"
	},
	{
	name	=	"close_time_",
type	=	"int",
	option	=	"required"
	},
	{
	name	=	"match_tip_",
type	=	"string",
	option	=	"required"
	}
};
packetDefine["pt_cb_apply_match_req"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"pay_type_",
type	=	"int",
	option	=	"required"
	}
};
packetDefine["pt_bc_apply_match_ack"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"ret_",
type	=	"int",
	option	=	"required"
	},
	{
	name	=	"init_score_",
type	=	"int",
	option	=	"required"
	}
};
packetDefine["pt_cb_reset_match_req"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	}
};
packetDefine["pt_bc_reset_match_ack"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"ret_",
type	=	"char",
	option	=	"required"
	},
	{
	name	=	"match_score_",
type	=	"int",
	option	=	"required"
	}
};
packetDefine["pt_cb_get_table_list_req2"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	}
};
packetDefine["pt_bc_get_table_list_ack2"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"items_",
type	=	"TableItemAttr2",
	option	=	"repeated"
	}
};
packetDefine["pt_cb_kickout_req"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"dst_ply_guid_",
type	=	"guid",
	option	=	"required"
	},
	{
	name	=	"chair_id_",
type	=	"int",
	option	=	"required"
	}
};
packetDefine["pt_bc_kickout_ack"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"ret_",
type	=	"char",
	option	=	"required"
	},
	{
	name	=	"dst_ply_guid_",
type	=	"guid",
	option	=	"required"
	},
	{
	name	=	"item_num_",
type	=	"int",
	option	=	"required"
	}
};
packetDefine["pt_cb_send_prop_req"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"dst_ply_guid_",
type	=	"guid",
	option	=	"required"
	},
	{
	name	=	"index_",
type	=	"int",
	option	=	"required"
	},
	{
	name	=	"amount_",
type	=	"int",
	option	=	"required"
	}
};
packetDefine["pt_bc_send_prop_ack"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"ret_",
type	=	"char",
	option	=	"required"
	},
	{
	name	=	"dst_ply_guid_",
type	=	"guid",
	option	=	"required"
	},
	{
	name	=	"index_",
type	=	"int",
	option	=	"required"
	},
	{
	name	=	"item_num_",
type	=	"int",
	option	=	"required"
	}
};
packetDefine["pt_bc_send_prop_not"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"src_ply_guid_",
type	=	"guid",
	option	=	"required"
	},
	{
	name	=	"dst_ply_guid_",
type	=	"guid",
	option	=	"required"
	},
	{
	name	=	"index_",
type	=	"int",
	option	=	"required"
	},
	{
	name	=	"amount_",
type	=	"int",
	option	=	"required"
	}
};
packetDefine["pt_cb_get_assist_info_data_req"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"dst_ply_guid_",
type	=	"guid",
	option	=	"required"
	}
};
packetDefine["pt_bc_get_assist_info_data_ack"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"ret_",
type	=	"char",
	option	=	"required"
	},
	{
	name	=	"dst_ply_guid_",
type	=	"guid",
	option	=	"required"
	},
	{
	name	=	"items_",
type	=	"AssistInfoData",
	option	=	"repeated"
	}
};
packetDefine["pt_bc_integal_condition_noti"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"type_",
type	=	"int",
	option	=	"required"
	},
	{
	name	=	"rule_id_",
type	=	"int",
	option	=	"required"
	},
	{
	name	=	"rule_id_android_",
type	=	"int",
	option	=	"required"
	},
	{
	name	=	"rule_desc_",
type	=	"string",
	option	=	"required"
	}
};
packetDefine["pt_bc_coupon_not"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"ret_",
type	=	"char",
	option	=	"required"
	},
	{
	name	=	"num_",
type	=	"int",
	option	=	"required"
	}
};
packetDefine["pt_br_need_send_robot_not"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"table_id_",
type	=	"int",
	option	=	"required"
	}
};
packetDefine["pt_bc_common_message_not"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"type_",
type	=	"char",
	option	=	"required"
	},
	{
	name	=	"message_",
type	=	"string",
	option	=	"required"
	}
};
packetDefine["pt_bc_below_admission_limit_tip_not"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"type_",
type	=	"int",
	option	=	"required"
	},
	{
	name	=	"money_",
type	=	"int",
	option	=	"required"
	},
	{
	name	=	"message_",
type	=	"string",
	option	=	"required"
	}
};
packetDefine["pt_bc_recharge_tip_not"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"type_",
type	=	"int",
	option	=	"required"
	},
	{
	name	=	"money_",
type	=	"int",
	option	=	"required"
	},
	{
	name	=	"message_",
type	=	"string",
	option	=	"required"
	}
};
packetDefine["pt_bc_calc_player_round_count_not"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"num_",
type	=	"int",
	option	=	"required"
	}
};
packetDefine["RoundAwardItem"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"rounds_",
type	=	"int",
	option	=	"required"
	},
	{
	name	=	"money_",
type	=	"int",
	option	=	"required"
	},
	{
	name	=	"status_",
type	=	"int",
	option	=	"required"
	}
};
packetDefine["RoundAward"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"round_award_",
type	=	"RoundAwardItem",
	option	=	"repeated"
	}
};
packetDefine["pt_bc_round_award_items_not"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"round_",
type	=	"int",
	option	=	"required"
	},
	{
	name	=	"items_",
type	=	"RoundAwardItem",
	option	=	"repeated"
	}
};
packetDefine["pt_cb_get_round_award_req"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"type_",
type	=	"char",
	option	=	"required"
	}
};
packetDefine["pt_bc_get_round_award_ack"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"ret_",
type	=	"char",
	option	=	"required"
	},
	{
	name	=	"round_",
type	=	"int",
	option	=	"required"
	},
	{
	name	=	"award_round_",
type	=	"int",
	option	=	"required"
	},
	{
	name	=	"money_",
type	=	"int",
	option	=	"required"
	},
	{
	name	=	"message_",
type	=	"string",
	option	=	"required"
	}
};
packetDefine["pt_bc_award_type_not"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"type_",
type	=	"int",
	option	=	"repeated"
	}
}

opcodeDefine["pt_cb_login_req"] = 7300;
opcodeDefine["pt_bc_login_ack"] = 7301;
opcodeDefine["pt_cb_join_table_req"] = 7302;
opcodeDefine["pt_bc_join_table_ack"] = 7303;
opcodeDefine["pt_cb_leave_table_req"] = 7304;
opcodeDefine["pt_bc_leave_table_ack"] = 7305;
opcodeDefine["pt_bc_ply_join_not"] = 7306;
opcodeDefine["pt_bc_ply_leave_not"] = 7307;
opcodeDefine["pt_cb_ready_req"] = 7308;
opcodeDefine["pt_bc_ready_not"] = 7309;
opcodeDefine["pt_bc_change_table_req"] = 7310;
opcodeDefine["pt_cb_chat_req"] = 7311;
opcodeDefine["pt_bc_chat_not"] = 7312;
opcodeDefine["pt_cb_change_table_req"] = 7313;
opcodeDefine["pt_cb_visit_table_req"] = 7314;
opcodeDefine["pt_cb_get_online_award_req"] = 7315;
opcodeDefine["pt_bc_get_online_award_ack"] = 7316;
opcodeDefine["pt_cb_ply_place_not"] = 7317;
opcodeDefine["pt_bc_update_ply_data_not"] = 7318;
opcodeDefine["pt_bc_cli_timer_not"] = 7319;
opcodeDefine["pt_bc_message_not"] = 7320;
opcodeDefine["pt_cb_create_table_req"] = 7321;
opcodeDefine["pt_bc_create_table_ack"] = 7322;
opcodeDefine["pt_cb_get_table_list_req"] = 7323;
opcodeDefine["pt_bc_get_table_list_ack"] = 7324;
opcodeDefine["pt_cb_give_gift_req"] = 7325;
opcodeDefine["pt_bc_give_gift_ack"] = 7326;
opcodeDefine["pt_bc_give_gift_not"] = 7327;
opcodeDefine["pt_cb_get_match_data_req"] = 7328;
opcodeDefine["pt_bc_get_match_data_ack"] = 7329;
opcodeDefine["pt_cb_apply_match_req"] = 7330;
opcodeDefine["pt_bc_apply_match_ack"] = 7331;
opcodeDefine["pt_cb_reset_match_req"] = 7332;
opcodeDefine["pt_bc_reset_match_ack"] = 7333;
opcodeDefine["pt_cb_get_table_list_req2"] = 7334;
opcodeDefine["pt_bc_get_table_list_ack2"] = 7335;
opcodeDefine["pt_cb_kickout_req"] = 7336;
opcodeDefine["pt_bc_kickout_ack"] = 7337;
opcodeDefine["pt_cb_send_prop_req"] = 7338;
opcodeDefine["pt_bc_send_prop_ack"] = 7339;
opcodeDefine["pt_bc_send_prop_not"] = 7340;
opcodeDefine["pt_cb_get_assist_info_data_req"] = 7341;
opcodeDefine["pt_bc_get_assist_info_data_ack"] = 7342;
opcodeDefine["pt_bc_integal_condition_noti"] = 7343;
opcodeDefine["pt_bc_coupon_not"] = 7344;
opcodeDefine["pt_br_need_send_robot_not"] = 7345;
opcodeDefine["pt_bc_common_message_not"] = 7346;
opcodeDefine["pt_bc_below_admission_limit_tip_not"] = 7347;
opcodeDefine["pt_bc_recharge_tip_not"] = 7348;
opcodeDefine["pt_bc_calc_player_round_count_not"] = 7349;
opcodeDefine["pt_bc_round_award_items_not"] = 7350;
opcodeDefine["pt_bc_player_round_not"] = 7351;
opcodeDefine["pt_cb_get_round_award_req"] = 7352;
opcodeDefine["pt_bc_get_round_award_ack"] = 7353;
opcodeDefine["pt_bc_award_type_not"] = 7354;
opcodeReverse[7300] = "pt_cb_login_req";
opcodeReverse[7301] = "pt_bc_login_ack";
opcodeReverse[7302] = "pt_cb_join_table_req";
opcodeReverse[7303] = "pt_bc_join_table_ack";
opcodeReverse[7304] = "pt_cb_leave_table_req";
opcodeReverse[7305] = "pt_bc_leave_table_ack";
opcodeReverse[7306] = "pt_bc_ply_join_not";
opcodeReverse[7307] = "pt_bc_ply_leave_not";
opcodeReverse[7308] = "pt_cb_ready_req";
opcodeReverse[7309] = "pt_bc_ready_not";
opcodeReverse[7310] = "pt_bc_change_table_req";
opcodeReverse[7311] = "pt_cb_chat_req";
opcodeReverse[7312] = "pt_bc_chat_not";
opcodeReverse[7313] = "pt_cb_change_table_req";
opcodeReverse[7314] = "pt_cb_visit_table_req";
opcodeReverse[7315] = "pt_cb_get_online_award_req";
opcodeReverse[7316] = "pt_bc_get_online_award_ack";
opcodeReverse[7317] = "pt_cb_ply_place_not";
opcodeReverse[7318] = "pt_bc_update_ply_data_not";
opcodeReverse[7319] = "pt_bc_cli_timer_not";
opcodeReverse[7320] = "pt_bc_message_not";
opcodeReverse[7321] = "pt_cb_create_table_req";
opcodeReverse[7322] = "pt_bc_create_table_ack";
opcodeReverse[7323] = "pt_cb_get_table_list_req";
opcodeReverse[7324] = "pt_bc_get_table_list_ack";
opcodeReverse[7325] = "pt_cb_give_gift_req";
opcodeReverse[7326] = "pt_bc_give_gift_ack";
opcodeReverse[7327] = "pt_bc_give_gift_not";
opcodeReverse[7328] = "pt_cb_get_match_data_req";
opcodeReverse[7329] = "pt_bc_get_match_data_ack";
opcodeReverse[7330] = "pt_cb_apply_match_req";
opcodeReverse[7331] = "pt_bc_apply_match_ack";
opcodeReverse[7332] = "pt_cb_reset_match_req";
opcodeReverse[7333] = "pt_bc_reset_match_ack";
opcodeReverse[7334] = "pt_cb_get_table_list_req2";
opcodeReverse[7335] = "pt_bc_get_table_list_ack2";
opcodeReverse[7336] = "pt_cb_kickout_req";
opcodeReverse[7337] = "pt_bc_kickout_ack";
opcodeReverse[7338] = "pt_cb_send_prop_req";
opcodeReverse[7339] = "pt_bc_send_prop_ack";
opcodeReverse[7340] = "pt_bc_send_prop_not";
opcodeReverse[7341] = "pt_cb_get_assist_info_data_req";
opcodeReverse[7342] = "pt_bc_get_assist_info_data_ack";
opcodeReverse[7343] = "pt_bc_integal_condition_noti";
opcodeReverse[7344] = "pt_bc_coupon_not";
opcodeReverse[7345] = "pt_br_need_send_robot_not";
opcodeReverse[7346] = "pt_bc_common_message_not";
opcodeReverse[7347] = "pt_bc_below_admission_limit_tip_not";
opcodeReverse[7348] = "pt_bc_recharge_tip_not";
opcodeReverse[7349] = "pt_bc_calc_player_round_count_not";
opcodeReverse[7350] = "pt_bc_round_award_items_not";
opcodeReverse[7351] = "pt_bc_player_round_not";
opcodeReverse[7352] = "pt_cb_get_round_award_req";
opcodeReverse[7353] = "pt_bc_get_round_award_ack";
opcodeReverse[7354] = "pt_bc_award_type_not";


opcodeDefine["pt_gc_game_start_not"] = 5100;
opcodeDefine["pt_cg_send_card_ok_ack"] = 5101;
opcodeDefine["pt_gc_refresh_card_not"] = 5102;
opcodeDefine["pt_gc_lord_card_not"] = 5103;
opcodeDefine["pt_gc_play_card_req"] = 5104;
opcodeDefine["pt_cg_play_card_ack"] = 5105;
opcodeDefine["pt_gc_play_card_not"] = 5106;
opcodeDefine["pt_gc_call_score_req"] = 5107;
opcodeDefine["pt_cg_call_score_ack"] = 5108;
opcodeDefine["pt_gc_rob_lord_req"] = 5109;
opcodeDefine["pt_cg_rob_lord_ack"] = 5110;
opcodeDefine["pt_gc_common_not"] = 5111;
opcodeDefine["pt_gc_game_result_not"] = 5112;
opcodeDefine["pt_gc_bomb_not"] = 5113;
opcodeDefine["pt_cg_auto_req"] = 5114;
opcodeDefine["pt_gc_auto_not"] = 5115;
opcodeDefine["pt_cg_complete_data_req"] = 5116;
opcodeDefine["pt_gc_complete_data_not"] = 5117;
opcodeDefine["pt_gc_show_card_req"] = 5118;
opcodeDefine["pt_cg_show_card_ack"] = 5119;
opcodeDefine["pt_gc_show_card_not"] = 5120;
opcodeDefine["pt_gc_clienttimer_not"] = 5121;
opcodeDefine["pt_gc_task_not"] = 5122;
opcodeDefine["pt_gc_task_complete_not"] = 5123;
opcodeDefine["pt_cg_card_count_req"] = 5124;
opcodeDefine["pt_gc_card_count_ack"] = 5125;
opcodeDefine["pt_gc_laizi_not"] = 5126;
opcodeDefine["pt_gc_counts_not"] = 5127;
opcodeDefine["pt_gc_counts_not1"] = 5128;
opcodeDefine["pt_gc_card_count_ack1"] = 5129;
opcodeDefine["pt_gc_game_result_not1"] = 5130;
opcodeDefine["pt_gc_expression_not"] = 5131;
opcodeReverse[5100] = "pt_gc_game_start_not";
opcodeReverse[5101] = "pt_cg_send_card_ok_ack";
opcodeReverse[5102] = "pt_gc_refresh_card_not";
opcodeReverse[5103] = "pt_gc_lord_card_not";
opcodeReverse[5104] = "pt_gc_play_card_req";
opcodeReverse[5105] = "pt_cg_play_card_ack";
opcodeReverse[5106] = "pt_gc_play_card_not";
opcodeReverse[5107] = "pt_gc_call_score_req";
opcodeReverse[5108] = "pt_cg_call_score_ack";
opcodeReverse[5109] = "pt_gc_rob_lord_req";
opcodeReverse[5110] = "pt_cg_rob_lord_ack";
opcodeReverse[5111] = "pt_gc_common_not";
opcodeReverse[5112] = "pt_gc_game_result_not";
opcodeReverse[5113] = "pt_gc_bomb_not";
opcodeReverse[5114] = "pt_cg_auto_req";
opcodeReverse[5115] = "pt_gc_auto_not";
opcodeReverse[5116] = "pt_cg_complete_data_req";
opcodeReverse[5117] = "pt_gc_complete_data_not";
opcodeReverse[5118] = "pt_gc_show_card_req";
opcodeReverse[5119] = "pt_cg_show_card_ack";
opcodeReverse[5120] = "pt_gc_show_card_not";
opcodeReverse[5121] = "pt_gc_clienttimer_not";
opcodeReverse[5122] = "pt_gc_task_not";
opcodeReverse[5123] = "pt_gc_task_complete_not";
opcodeReverse[5124] = "pt_cg_card_count_req";
opcodeReverse[5125] = "pt_gc_card_count_ack";
opcodeReverse[5126] = "pt_gc_laizi_not";
opcodeReverse[5127] = "pt_gc_counts_not";
opcodeReverse[5128] = "pt_gc_counts_not1";
opcodeReverse[5129] = "pt_gc_card_count_ack1";
opcodeReverse[5130] = "pt_gc_game_result_not1";
opcodeReverse[5131] = "pt_gc_expression_not";
