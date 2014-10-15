packetDefine = {
	RankItem = 
	{
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"index_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"ply_guid_",
			type = 	"guid",
			option = 	"required"
		},
		{
			name = 	"ply_nickname_",
			type = 	"string",
			option = 	"required"
		},
		{
			name = 	"ply_status_",
			type = 	"char",
			option = 	"required"
		},
		{
			name = 	"server_id_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"table_id_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"param1_",
			type = 	"float",
			option = 	"required"
		},
		{
			name = 	"param2_",
			type = 	"float",
			option = 	"required"
		}
    },
    MatchInfoNet =
    {
    	{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"match_id_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"match_order_id_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"match_type_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"match_game_id_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"match_begin_time_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"match_end_time_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"match_status_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"match_award_id_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"match_min_number_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"match_max_number_",
			type = 	"int",
			option = 	"required"
		},

		{
			name = 	"match_sign_cost_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"match_round_count_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"match_vip_limit_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"match_current_round_",
			type = 	"int",
			option = 	"required"
		},

		{
			name = 	"match_round_status_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"match_round_start_time_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"match_start_type_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"match_ticket_limit_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"match_vip_free_limit_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"match_sign_time_",
			type = 	"int",
			option = 	"required"
		}, 
		{
			name = 	"data",
			type = 	"ServerData2",
			option = 	"required"
		},
	},
-- NET_PACKET(MatchInfoNet)
-- {
--     int     match_id_;
--     int     match_order_id_;
--     int     match_type_;
--     int     match_game_id_;
--     int     match_begin_time_;
--     int     match_end_time_;
--     int     match_status_;
--     int     match_award_id_;
--     int     match_min_number_;
--     int     match_max_number_;
--     int     match_sign_cost_;
--     int     match_round_count_;
--     int     match_vip_limit_; 
--     int     match_current_round_;
--     int     match_round_status_;
--     int     match_round_start_time_;
--     int 	match_start_type_;
--     int		match_ticket_limit_;
--     int		match_vip_free_limit_;
--     int		match_sign_time_;
--     ServerData2 data_;
-- };
	AchieveData = 
	{
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"index_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"value_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"max_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"status_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"money_award_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"gift_award_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"name_",
			type = 	"string",
			option = 	"required"
		},
		{
			name = 	"desc_",
			type = 	"string",
			option = 	"required"
		} 
	},
	AchieveData2 = 
	{
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"index_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"value_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"max_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"status_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"money_award_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"gift_award_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"prop_1_award_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"prop_2_award_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"prop_3_award_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"prop_4_award_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"prop_5_award_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"name_",
			type = 	"string",
			option = 	"required"
		},
		{
			name = 	"desc_",
			type = 	"string",
			option = 	"required"
		} 
	},
	FriendMsg = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"rcv_ply_guid_",
			type = 	"guid",
			option = 	"required"
		},
		{
			name = 	"snd_ply_guid_",
			type = 	"guid",
			option = 	"required"
		},
		{
			name = 	"snd_nickname_",
			type = 	"string",
			option = 	"required"
		},
		{
			name = 	"message_",
			type = 	"string",
			option = 	"required"
		},
		{
			name = 	"type_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"time_",
			type = 	"int",
			option = 	"required"
		}		
	},
	VipData = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"level_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"nex_level_total_days_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"auto_upgrade_day_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"login_award_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"friend_count_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"next_level_due_days_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"remain_due_days_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"status_",
			type = 	"int",
			option = 	"required"
		}
	},
	PlayerStatus = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"ply_guid_",
			type = 	"guid",
			option = 	"required"
		},
		{
			name = 	"ply_nickname_",
			type = 	"string",
			option = 	"required"
		},
		{
			name = 	"ply_status_",
			type = 	"char",
			option = 	"required"
		},
		{
			name = 	"sex_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"game_id_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"game_server_id_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"table_id_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"money_",
			type = 	"int64",
			option = 	"required"
		},
		{
			name = 	"won_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"lost_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"money_rank_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"won_rank_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"param_1_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"param_2_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"latitude_",
			type = 	"float",
			option = 	"required"
		},
		{
			name = 	"longitude_",
			type = 	"float",
			option = 	"required"
		}
	},
  ServerData = {
    {
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
    {
			name = 	"game_id_",
			type = 	"int",
			option = 	"required"
		},
    {
			name = 	"server_id_",
			type = 	"int",
			option = 	"required"
		},
    {
			name = 	"server_name_",
			type = 	"string",
			option = 	"required"
		},
    {
			name = 	"server_key_",
			type = 	"string",
			option = 	"required"
		},
    {
			name = 	"server_addr_",
			type = 	"string",
			option = 	"required"
		},
    {
			name = 	"server_port_",
			type = 	"int",
			option = 	"required"
		},
    {
			name = 	"base_bet_",
			type = 	"int",
			option = 	"required"
		},
    {
			name = 	"min_money_",
			type = 	"int",
			option = 	"required"
		},
    {
			name = 	"online_player_num_",
			type = 	"int",
			option = 	"required"
		}
  },

	MatchPlayerData = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"ply_guid_",
			type = 	"guid",
			option = 	"required"
		},
		{
			name = 	"nick_name_",
			type = 	"string",
			option = 	"required"
		},
		{
			name = 	"current_score_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"relive_count_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"avoid_count_",
			type = 	"int",
			option = 	"required"
		}
	},

	MatchPlayerRank = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"rank_index_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"ply_guid_",
			type = 	"guid",
			option = 	"required"
		}
	},

  ServerData2 = 
{
	{
		name = 	"opcode",
		type = 	"short",
		option = 	"required"
	},
	{
		name = 	"game_id_",
		type = 	"int",
		option = 	"required"
	},
	{
		name = 	"server_id_",
		type = 	"int",
		option = 	"required"
	},	
	{
		name = 	"server_name_",
		type = 	"string",
		option = 	"required"
	},
	{
		name = 	"server_key_",
		type = 	"string",
		option = 	"required"
	},
	{
		name = 	"server_addr_",
		type = 	"string",
		option = 	"required"
	},
	{
		name = 	"server_port_",
		type = 	"int",
		option = 	"required"
	},
	{
		name = 	"base_bet_",
		type = 	"int",
		option = 	"required"
	},
	{
		name = 	"min_money_",
		type = 	"int",
		option = 	"required"
	},
	{
		name = 	"online_player_num_",
		type = 	"int",
		option = 	"required"
	},
	{
		name = 	"channel_id_",
		type = 	"int",
		option = 	"required"
	},
	{
		name = 	"ext_param_",
		type = 	"string",
		option = 	"required"
	}
},
  ServerStatus = {
    {
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"server_id_",
			type = 	"int",
			option = 	"required"
		},
    {
			name = 	"online_num_",
			type = 	"int",
			option = 	"required"
		}
  },
	LoginAward = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"login_days_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"money_",
			type = 	"int",
			option = 	"required"
		}
	},
	LoginAward2 = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"today_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"login_award_",
			type = 	"LoginAward",
			option = 	"repeated"
		}
	},
	PlyLobbyData = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"ply_guid_",
			type = 	"guid",
			option = 	"required"
		},
		{
			name = 	"nickname_",
			type = 	"string",
			option = 	"required"
		},
		{
			name = 	"sex_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"gift_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"money_",
			type = 	"int64",
			option = 	"required"
		},
		{
			name = 	"score_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"won_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"lost_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"money_rank_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"won_rank_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"param_1_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"param_2_",
			type = 	"int",
			option = 	"required"
		}
	},
	ItemData = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"index_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"num_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"game_id_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"param_1_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"param_2_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"name_",
			type = 	"string",
			option = 	"required"
		},
		{
			name = 	"url_",
			type = 	"string",
			option = 	"required"
		}
	},
	pt_lc_verity_ticket_ack = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"ret_",
			type = 	"char",
			option = 	"required"
		},
		{
			name = 	"ply_lobby_data_",
			type = 	"PlyLobbyData",
			option = 	"required"
		},
		{
			name = 	"ply_status_",
			type = 	"PlayerStatus",
			option = 	"required"
		},
		{
			name = 	"ply_login_award_",
			type = 	"LoginAward",
			option = 	"required"
		},
		{
			name = 	"ply_items_",
			type = 	"ItemData",
			option = 	"repeated"
		},
		{
			name = 	"ply_login_award2_",
			type = 	"LoginAward2",
			option = 	"required"
		},
		{
			name = 	"ply_vip_",
			type = 	"VipData",
			option = 	"required"
		}
	},
	pt_lc_get_friend_list_ack = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"friends_",
			type = 	"FriendData",
			option = 	"repeated"
		}
	},
	pt_lc_get_ply_status_ack = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"players_",
			type = 	"PlayerStatus",
			option = 	"repeated"
		}
	},
	pt_lc_send_user_data_change_not = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"ply_lobby_data_",
			type = 	"PlyLobbyData",
			option = 	"required"
		},
		{
			name = 	"ply_items_",
			type = 	"ItemData",
			option = 	"repeated"
		},
		{
			name = 	"ply_vip_",
			type = 	"VipData",
			option = 	"required"
		}
	},
	pt_lc_friend_loginout_tip_not = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"ply_guid_",
			type = 	"guid",
			option = 	"required"
		},
		{
			name = 	"type_",
			type = 	"int",
			option = 	"required"
		}
	},
	pt_ping = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"now_",
			type = 	"int",
			option = 	"required"
		}
	},
	pt_pong = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"now_",
			type = 	"int",
			option = 	"required"
		}
	},
	PlyLobbyData20121227 = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"ply_guid_",
			type = 	"guid",
			option = 	"required"
		},
		{
			name = 	"nickname_",
			type = 	"string",
			option = 	"required"
		},
		{
			name = 	"gift_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"money_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"score_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"won_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"lost_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"money_rank_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"won_rank_",
			type = 	"int",
			option = 	"required"
		}
	},
	ItemData20121227 = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"index_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"num_",
			type = 	"int",
			option = 	"required"
		}
	},
	Friendlist = {
		{
			name = 	"opcode",pt_cb_get_luck_draw_record_req = {
	    {
	      name = "opcode",
	      type = "short",
	      option = "required"
	    },
  	},
	pt_bc_get_luck_draw_record_ack = {
	    {
	      name = "opcode",
	      type = "short",
	      option = "required"
	    },
	    {
	      name = "ret_",
	      type = "int",
	      option = "required"
	    },
	    {
	      name = "index_",
	      type = "int",
	      option = "required"
	    },
	    {
	      name = "num_",
	      type = "int",
	      option = "required"
	    },
  	},
	pt_cb_get_luck_draw_req = {
	  {
	    name = "opcode",
	    type = "short",
	    option = "required",
	  },
	},
	LuckDrawItemData = {
	  {
	    name = "opcode",
	    type = "short",
	    option = "required",
	  },
	  {
	    name = "index_",
	    type = "int",
	    option = "required",
	  },
	  {
	    name = "number_",
	    type = "int",
	    option = "required",
	  },
	},
	pt_bc_get_luck_draw_ack = {
	  {
	    name = "opcode",
	    type = "short",
	    option = "required",
	  },
	  {
	    name = "ret_",
	    type = "char",
	    option = "required",
	  },
	  {
	    name = "items_",
	    type = "LuckDrawItemData",
	    option = "repeated",
	  },
	},
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"ply_guid_",
			type = 	"guid",
			option = 	"required"
		},
		{
			name = 	"frd_guid_",
			type = 	"guid",
			option = 	"required"
		}
	},
	pt_cl_verify_ticket_req = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"ply_guid_",
			type = 	"guid",
			option = 	"required"
		},
		{
			name = 	"ply_nickname_",
			type = 	"string",
			option = 	"required"
		},
		{
			name = 	"ply_ticket_",
			type = 	"string",
			option = 	"required"
		},
		{
			name = 	"game_id_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"version_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"ext_param_",
			type = 	"string",
			option = 	"required"
		},
		{
			name = 	"sex_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"packet_name_",
			type = 	"string",
			option = 	"required"
		}
	},
	pt_lc_verity_ticket_ack20121227 = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"ret_",
			type = 	"char",
			option = 	"required"
		},
		{
			name = 	"ply_lobby_data_",
			type = 	"PlyLobbyData20121227",
			option = 	"required"
		},
		{
			name = 	"ply_status_",
			type = 	"PlayerStatus20121227",
			option = 	"required"
		},
		{
			name = 	"ply_login_award_",
			type = 	"LoginAward",
			option = 	"required"
		},
		{
			name = 	"ply_items_",
			type = 	"ItemData20121227",
			option = 	"repeated"
		},
		{
			name = 	"ply_login_award2_",
			type = 	"LoginAward2",
			option = 	"required"
		}
	},
	pt_lc_server_data_not = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"server_datas_",
			type = 	"ServerData",
			option = 	"repeated"
		}
	},
	pt_lc_server_status_not = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"server_status_",
			type = 	"ServerStatus",
			option = 	"repeated"
		}
	},
	pt_cl_get_ply_status_req = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"players_",
			type = 	"guid",
			option = 	"repeated"
		}
	},
	pt_lc_get_ply_status_ack20121227 = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"players_",
			type = 	"PlayerStatus20121227",
			option = 	"repeated"
		}
	},
	pt_cl_get_rank_list_req = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"type_",
			type = 	"char",
			option = 	"required"
		},
		{
			name = 	"latitude_",
			type = 	"float",
			option = 	"required"
		},
		{
			name = 	"longitude_",
			type = 	"float",
			option = 	"required"
		}
	},
	pt_lc_get_rank_list_ack = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"rank_list_",
			type = 	"RankItem",
			option = 	"repeated"
		},
		{
			name = 	"type_",
			type = 	"char",
			option = 	"required"
		}
	},
	pt_cl_get_achieve_list_req = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		}
	},
	pt_lc_get_achieve_list_ack = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"items_",
			type = 	"AchieveData",
			option = 	"repeated"
		}
	},
	pt_cl_get_achieve_award_req = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"index_",
			type = 	"int",
			option = 	"required"
		}
	},
	pt_lc_get_achieve_award_ack = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"ret_",
			type = 	"char",
			option = 	"required"
		},
		{
			name = 	"money_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"gift_",
			type = 	"int",
			option = 	"required"
		}
	},
	pt_cl_trumpet_req = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"type_",
			type = 	"char",
			option = 	"required"
		},
		{
			name = 	"message_",
			type = 	"string",
			option = 	"required"
		}
	},
	pt_lc_trumpet_ack = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"ret_",
			type = 	"char",
			option = 	"required"
		},
		{
			name = 	"num_",
			type = 	"int",
			option = 	"required"
		}
	},
	pt_lc_trumpet_not = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"ply_guid_",
			type = 	"guid",
			option = 	"required"
		},
		{
			name = 	"ply_nickname_",
			type = 	"string",
			option = 	"required"
		},
		{
			name = 	"message_",
			type = 	"string",
			option = 	"required"
		}
	},
	pt_lc_server_data_not2 = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"server_datas_",
			type = 	"ServerData2",
			option = 	"repeated"
		}
	},
	pt_cl_op_friend_req = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"opcode_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"ply_guid_",
			type = 	"guid",
			option = 	"required"
		}
	},
	pt_lc_op_friend_ack = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"ret_",
			type = 	"char",
			option = 	"required"
		},
		{
			name = 	"opcode_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"ply_guid_",
			type = 	"guid",
			option = 	"required"
		}
	},
	FriendData20121227 = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"ply_guid_",
			type = 	"guid",
			option = 	"required"
		},
		{
			name = 	"ply_nickname_",
			type = 	"string",
			option = 	"required"
		},
		{
			name = 	"ply_money_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"ply_vip_lev_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"ply_unread_msg_num_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"ply_type_",
			type = 	"int",
			option = 	"required"
		}
	},
	pt_cl_get_friend_list_req = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		}
	},
	pt_lc_get_friend_list_ack20121227 = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"friends_",
			type = 	"FriendData20121227",
			option = 	"repeated"
		}
	},
	pt_cl_send_friend_msg_req = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"rcv_guid_",
			type = 	"guid",
			option = 	"required"
		},
		{
			name = 	"type_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"message_",
			type = 	"string",
			option = 	"required"
		}
	},
	pt_lc_send_friend_msg_not = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"content_",
			type = 	"FriendMsg",
			option = 	"repeated"
		}
	},
	pt_cl_get_unread_msg_req = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"snd_guid_",
			type = 	"guid",
			option = 	"required"
		},
		{
			name = 	"timestamp_",
			type = 	"int",
			option = 	"required"
		}
	},
	pt_cl_get_daily_task_list_req = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		}
	},
	pt_lc_get_daily_task_list_ack = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"items_",
			type = 	"AchieveData2",
			option = 	"repeated"
		}
	},
	pt_cl_get_daily_task_award_req = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"index_",
			type = 	"int",
			option = 	"required"
		}
	},
	pt_lc_get_daily_task_award_ack = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"ret_",
			type = 	"char",
			option = 	"required"
		},
		{
			name = 	"money_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"gift_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"prop_1_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"prop_2_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"prop_3_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"prop_4_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"prop_5_",
			type = 	"int",
			option = 	"required"
		}
	},
	pt_cl_friend_approve_ack = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"ret_",
			type = 	"char",
			option = 	"required"
		},
		{
			name = 	"snd_ply_guid_",
			type = 	"guid",
			option = 	"required"
		},
		{
			name = 	"message_",
			type = 	"string",
			option = 	"required"
		}
	},
	pt_cl_send_ply_position_info_req = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"ply_guid_",
			type = 	"guid",
			option = 	"required"
		},
		{
			name = 	"latitude_",
			type = 	"float",
			option = 	"required"
		},
		{
			name = 	"longitude_",
			type = 	"float",
			option = 	"required"
		}
	},
	pt_lc_send_ply_position_info_ack = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"ret_",
			type = 	"char",
			option = 	"required"
		},
		{
			name = 	"ply_guid_",
			type = 	"guid",
			option = 	"required"
		}
	},
	pt_cl_get_position_info_req = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"dst_guid_",
			type = 	"guid",
			option = 	"required"
		}
	},
	pt_lc_get_position_info_ack = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"ply_guid_",
			type = 	"guid",
			option = 	"required"
		},
		{
			name = 	"dst_guid_",
			type = 	"guid",
			option = 	"required"
		},
		{
			name = 	"latitude_",
			type = 	"float",
			option = 	"required"
		},
		{
			name = 	"longitude_",
			type = 	"float",
			option = 	"required"
		}
	},
	pt_cl_get_achieve_ext_list_req = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"type_",
			type = 	"int",
			option = 	"required"
		}
	},
	pt_lc_get_achieve_ext_list_ack = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"items_",
			type = 	"AchieveExtData",
			option = 	"repeated"
		}
	},
	pt_cl_get_achieve_ext_award_req = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"index_",
			type = 	"int",
			option = 	"required"
		}
	},
	pt_lc_get_achieve_ext_award_ack = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"ret_",
			type = 	"char",
			option = 	"required"
		},
		{
			name = 	"money_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"gift_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"prop_items_",
			type = 	"PROP_ITEM_DATA",
			option = 	"repeated"
		}
	},
	GameConfig = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"game_id_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"game_name_",
			type = 	"string",
			option = 	"required"
		}
	},
	pt_cl_get_game_config_req = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		}
	},
	pt_lc_get_game_config_ack = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"game_items_",
			type = 	"GameConfig",
			option = 	"repeated"
		}
	},
	pt_cl_get_assist_info_data_req = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"game_id_",
			type = 	"int",
			option = 	"required"
		}
	},
	pt_lc_get_assist_info_data_ack = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"ret_",
			type = 	"char",
			option = 	"required"
		},
		{
			name = 	"items_",
			type = 	"AssistInfoData",
			option = 	"repeated"
		}
	},
	pt_lc_integal_condition_noti = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"type_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"rule_id_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"rule_id_android_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"rule_desc_",
			type = 	"string",
			option = 	"required"
		}
	},
	pt_lc_send_friend_msg_ack = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"ret_",
			type = 	"char",
			option = 	"required"
		},
		{
			name = 	"content_",
			type = 	"FriendMsg",
			option = 	"repeated"
		}
	},
	pt_cl_set_password_safe_req = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"ply_guid_",
			type = 	"guid",
			option = 	"required"
		},
		{
			name = 	"password_",
			type = 	"string",
			option = 	"required"
		},
		{
			name = 	"mobile_",
			type = 	"string",
			option = 	"required"
		}
	},
	pt_lc_set_password_safe_ack = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"ret_",
			type = 	"char",
			option = 	"required"
		},
		{
			name = 	"ply_guid_",
			type = 	"guid",
			option = 	"required"
		}
	},
	pt_cl_store_safe_amount_req = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"ply_guid_",
			type = 	"guid",
			option = 	"required"
		},
		{
			name = 	"amount_",
			type = 	"int64",
			option = 	"required"
		}
	},
	pt_lc_store_safe_amount_ack = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"ret_",
			type = 	"char",
			option = 	"required"
		},
		{
			name = 	"ply_guid_",
			type = 	"guid",
			option = 	"required"
		}
	},
	pt_cl_remove_safe_amount_req = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"ply_guid_",
			type = 	"guid",
			option = 	"required"
		},
		{
			name = 	"amount_",
			type = 	"int64",
			option = 	"required"
		},
		{
			name = 	"password_",
			type = 	"string",
			option = 	"required"
		}
	},
	pt_lc_remove_safe_amount_ack = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"ret_",
			type = 	"char",
			option = 	"required"
		},
		{
			name = 	"ply_guid_",
			type = 	"guid",
			option = 	"required"
		},
		{
			name = 	"amount_",
			type = 	"int64",
			option = 	"required"
		},
		{
			name = 	"remaining_sum_",
			type = 	"int64",
			option = 	"required"
		}
	},
	pt_cl_modify_password_safe_req = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"ply_guid_",
			type = 	"guid",
			option = 	"required"
		},
		{
			name = 	"old_password_",
			type = 	"string",
			option = 	"required"
		},
		{
			name = 	"new_password_",
			type = 	"string",
			option = 	"required"
		}
	},
	pt_lc_modify_password_safe_ack = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"ret_",
			type = 	"char",
			option = 	"required"
		},
		{
			name = 	"ply_guid_",
			type = 	"guid",
			option = 	"required"
		}
	},
	SafeRecord = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"index_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"game_id_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"type_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"op_time_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"amount_",
			type = 	"int64",
			option = 	"required"
		},
		{
			name = 	"remaining_sum_",
			type = 	"int64",
			option = 	"required"
		}
	},
	pt_cl_get_safe_history_req = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"ply_guid_",
			type = 	"guid",
			option = 	"required"
		}
	},
	pt_lc_get_safe_history_ack = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"ret_",
			type = 	"char",
			option = 	"required"
		},
		{
			name = 	"ply_guid_",
			type = 	"guid",
			option = 	"required"
		},
		{
			name = 	"history_",
			type = 	"SafeRecord",
			option = 	"repeated"
		}
	},
	pt_cl_get_safe_data_req = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"ply_guid_",
			type = 	"guid",
			option = 	"required"
		}
	},
	pt_lc_get_safe_data_ack = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"ret_",
			type = 	"char",
			option = 	"required"
		},
		{
			name = 	"ply_guid_",
			type = 	"guid",
			option = 	"required"
		},
		{
			name = 	"amount_",
			type = 	"int64",
			option = 	"required"
		},
		{
			name = 	"money_",
			type = 	"int64",
			option = 	"required"
		},
		{
			name = 	"isBindMobile_",
			type = 	"int",
			option = 	"required"
		}
	},
	pt_cl_get_continuous_game_award_req = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		}
	},
	pt_lc_get_continuous_game_award_ack = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"ret_",
			type = 	"char",
			option = 	"required"
		},
		{
			name = 	"money_",
			type = 	"int64",
			option = 	"required"
		}
	},
	ServerKeyInfo = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"game_id_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"packet_name_",
			type = 	"string",
			option = 	"required"
		},
		{
			name = 	"version_",
			type = 	"int",
			option = 	"required"
		}
	},
	pt_cl_get_miniGame_req = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"ply_guid_",
			type = 	"guid",
			option = 	"required"
		},
		{
			name = 	"game_id_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"version_",
			type = 	"int",
			option = 	"required"
		}
	},
	pt_lc_get_miniGame_ack = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"result",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"server_datas_",
			type = 	"ServerData2",
			option = 	"repeated"
		}
	},
	pt_cb_login_req = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"ply_guid_",
			type = 	"guid",
			option = 	"required"
		},
		{
			name = 	"ply_ticket_",
			type = 	"string",
			option = 	"required"
		},
		{
			name = 	"version_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"ext_param_",
			type = 	"string",
			option = 	"required"
		}
	},
	pt_bc_login_ack = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"ret_",
			type = 	"char",
			option = 	"required"
		},
		{
			name = 	"ply_base_data_",
			type = 	"PlyBaseData",
			option = 	"required"
		},
		{
			name = 	"ply_status_",
			type = 	"PlayerStatus",
			option = 	"required"
		}
	},
	pt_cb_join_table_req = 
	{
		{
			name = "opcode", 
			type = "short", 
			option = "required"
		}, 
		{
			name = "table_id_", 
			type = "int", 
			option = "required"
		}, 
		{
			name = "password_", 
			type = "string", 
			option = "required"
		}
	}, 
	pt_bc_join_table_ack = 
	{
		{
			name = "opcode", 
			type = "short", 
			option = "required"
		}, 
		{
			name = "ret_", 
			type = "char", 
			option = "required"
		}, 
		{
			name = "table_attrs_", 
			type = "TableAttr", 
			option = "required"
		}, 
		{
			name = "errMsg_", 
			type = "string", 
			option = "required"
		}
	}, 
	pt_cb_leave_table_req = 
	{
		{
			name = "opcode", 
			type = "short", 
			option = "required"
		}
	}, 
	pt_bc_leave_table_ack = 
	{
		{
			name = "opcode", 
			type = "short", 
			option = "required"
		}, 
		{
			name = "ret_", 
			type = "char", 
			option = "required"
		}, 
		{
			name = "ply_nickname_", 
			type = "string", 
			option = "required"
		}
	}, 
	pt_bc_ply_join_not = 
	{
		{
			name = "opcode", 
			type = "short", 
			option = "required"
		}, 
		{
			name = "ply_data_", 
			type = "PlyBaseData", 
			option = "required"
		}
	}, 
	pt_bc_ply_leave_not = 
	{
		{
			name = "opcode", 
			type = "short", 
			option = "required"
		}, 
		{
			name = "ply_guid_", 
			type = "int64", 
			option = "required"
		}
	}, 
	pt_cb_ready_req = 
	{
		{
			name = "opcode", 
			type = "short", 
			option = "required"
		}
	}, 
	pt_bc_ready_not = 
	{
		{
			name = "opcode", 
			type = "short", 
			option = "required"
		}, 
		{
			name = "ply_guid_", 
			type = "int64", 
			option = "required"
		}
	}, 
	pt_cb_change_table_req = 
	{
		{
			name = "opcode", 
			type = "short", 
			option = "required"
		}
	}, 
	PlyBaseData = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"ply_guid_",
			type = 	"guid",
			option = 	"required"
		},
		{
			name = 	"nickname_",
			type = 	"string",
			option = 	"required"
		},
		{
			name = 	"sex_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"gift_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"money_",
			type = 	"int64",
			option = 	"required"
		},
		{
			name = 	"score_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"won_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"lost_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"dogfall_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"table_id_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"param_1_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"param_2_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"chair_id_",
			type = 	"char",
			option = 	"required"
		},
		{
			name = 	"ready_",
			type = 	"char",
			option = 	"required"
		},
		{
			name = 	"ply_vip_",
			type = 	"VipData",
			option = 	"required"
		}
	},
	TableAttr = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"table_id_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"name_",
			type = 	"string",
			option = 	"required"
		},
		{
			name = 	"lock_",
			type = 	"char",
			option = 	"required"
		},
		{
			name = 	"players_",
			type = 	"PlyBaseData",
			option = 	"repeated"
		}
	},pt_bc_update_ply_data_not = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"ply_guid_",
			type = 	"guid",
			option = 	"required"
		},
		{
			name = 	"upt_reason_",
			type = 	"char",
			option = 	"required"
		},
		{
			name = 	"upt_type_",
			type = 	"char",
			option = 	"required"
		},
		{
			name = 	"variant_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"amount_",
			type = 	"int64",
			option = 	"required"
		}
	},
	pt_cb_ready_req = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		}
	},
	pt_bc_ready_not = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"ply_guid_",
			type = 	"guid",
			option = 	"required"
		}
	},
	pt_cb_chat_req = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"type_",
			type = 	"char",
			option = 	"required"
		},
		{
			name = 	"message_",
			type = 	"string",
			option = 	"required"
		}
	},
	pt_bc_chat_not = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"ply_guid_",
			type = 	"guid",
			option = 	"required"
		},
		{
			name = 	"nickname_",
			type = 	"string",
			option = 	"required"
		},
		{
			name = 	"message_",
			type = 	"string",
			option = 	"required"
		}
	},
	pt_cb_change_table_req = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		}
	},
	pt_cb_visit_table_req = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"table_id_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"password_",
			type = 	"string",
			option = 	"required"
		}
	},
	pt_cb_get_online_award_req = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"type_",
			type = 	"char",
			option = 	"required"
		}
	},
	pt_bc_get_online_award_ack = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"ret_",
			type = 	"char",
			option = 	"required"
		},
		{
			name = 	"remain_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"money_",
			type = 	"int",
			option = 	"required"
		}
	},
	pt_cb_ply_place_not = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"latitude_",
			type = 	"float",
			option = 	"required"
		},
		{
			name = 	"longitude_",
			type = 	"float",
			option = 	"required"
		}
	},
	pt_bc_update_ply_data_not20121227 = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"ply_guid_",
			type = 	"guid",
			option = 	"required"
		},
		{
			name = 	"upt_reason_",
			type = 	"char",
			option = 	"required"
		},
		{
			name = 	"upt_type_",
			type = 	"char",
			option = 	"required"
		},
		{
			name = 	"variant_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"amount_",
			type = 	"int",
			option = 	"required"
		}
	},
	pt_bc_cli_timer_not = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"ply_guid_",
			type = 	"guid",
			option = 	"required"
		},
		{
			name = 	"idle_time_",
			type = 	"int",
			option = 	"required"
		}
	},
	pt_bc_message_not = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"type_",
			type = 	"char",
			option = 	"required"
		},
		{
			name = 	"message_",
			type = 	"string",
			option = 	"required"
		}
	},
	pt_cb_create_table_req = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"name_",
			type = 	"string",
			option = 	"required"
		},
		{
			name = 	"password_",
			type = 	"string",
			option = 	"required"
		},
		{
			name = 	"base_score_",
			type = 	"int",
			option = 	"required"
		}
	},
	pt_bc_create_table_ack = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"ret_",
			type = 	"char",
			option = 	"required"
		},
		{
			name = "table_attrs_", 
			type = "TableAttr", 
			option = "required"
		}
	},
	pt_cb_get_table_list_req = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		}
	},
	pt_bc_get_table_list_ack = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"items_",
			type = 	"TableItemAttr",
			option = 	"repeated"
		}
	},
	pt_cb_give_gift_req = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"dst_ply_guid_",
			type = 	"guid",
			option = 	"required"
		},
		{
			name = 	"amount_",
			type = 	"int",
			option = 	"required"
		}
	},
	pt_bc_give_gift_ack = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"ret_",
			type = 	"char",
			option = 	"required"
		},
		{
			name = 	"balance_",
			type = 	"int",
			option = 	"required"
		}
	},
	pt_bc_give_gift_not = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"src_ply_guid_",
			type = 	"guid",
			option = 	"required"
		},
		{
			name = 	"dst_ply_guid_",
			type = 	"guid",
			option = 	"required"
		},
		{
			name = 	"amount_",
			type = 	"int",
			option = 	"required"
		}
	},
	pt_cb_get_match_data_req = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		}
	},
	MatchRank = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"ply_guid_",
			type = 	"guid",
			option = 	"required"
		},
		{
			name = 	"ply_nickname_",
			type = 	"string",
			option = 	"required"
		},
		{
			name = 	"match_score_",
			type = 	"int",
			option = 	"required"
		}
	},
	pt_bc_get_match_data_ack = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"max_game_rounds_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"match_fee_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"ply_self_rank_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"score_rank_",
			type = 	"MatchRank",
			option = 	"repeated"
		},
		{
			name = 	"open_time_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"close_time_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"match_tip_",
			type = 	"string",
			option = 	"required"
		}
	},
	pt_cb_apply_match_req = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"pay_type_",
			type = 	"int",
			option = 	"required"
		}
	},
	pt_bc_apply_match_ack = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"ret_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"init_score_",
			type = 	"int",
			option = 	"required"
		}
	},
	pt_cb_reset_match_req = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		}
	},
	pt_bc_reset_match_ack = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"ret_",
			type = 	"char",
			option = 	"required"
		},
		{
			name = 	"match_score_",
			type = 	"int",
			option = 	"required"
		}
	},
	pt_cb_get_table_list_req2 = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		}
	},
	TableItemAttr2 = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"table_id_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"name_",
			type = 	"string",
			option = 	"required"
		},
		{
			name = 	"lock_",
			type = 	"char",
			option = 	"required"
		},
		{
			name = 	"status_",
			type = 	"char",
			option = 	"required"
		},
		{
			name = 	"base_score_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"cur_ply_num_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"ply_min_money_",
			type = 	"int",
			option = 	"required"
		}
	},
	pt_bc_get_table_list_ack2 = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"items_",
			type = 	"TableItemAttr2",
			option = 	"repeated"
		}
	},
	pt_cb_kickout_req = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"dst_ply_guid_",
			type = 	"guid",
			option = 	"required"
		},
		{
			name = 	"chair_id_",
			type = 	"int",
			option = 	"required"
		}
	},
	pt_bc_kickout_ack = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"ret_",
			type = 	"char",
			option = 	"required"
		},
		{
			name = 	"dst_ply_guid_",
			type = 	"guid",
			option = 	"required"
		},
		{
			name = 	"item_num_",
			type = 	"int",
			option = 	"required"
		}
	},
	pt_cb_send_prop_req = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"dst_ply_guid_",
			type = 	"guid",
			option = 	"required"
		},
		{
			name = 	"index_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"amount_",
			type = 	"int",
			option = 	"required"
		}
	},
	pt_bc_send_prop_ack = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"ret_",
			type = 	"char",
			option = 	"required"
		},
		{
			name = 	"dst_ply_guid_",
			type = 	"guid",
			option = 	"required"
		},
		{
			name = 	"index_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"item_num_",
			type = 	"int",
			option = 	"required"
		}
	},
	pt_bc_send_prop_not = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"src_ply_guid_",
			type = 	"guid",
			option = 	"required"
		},
		{
			name = 	"dst_ply_guid_",
			type = 	"guid",
			option = 	"required"
		},
		{
			name = 	"index_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"amount_",
			type = 	"int",
			option = 	"required"
		}
	},
	pt_cb_get_assist_info_data_req = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"dst_ply_guid_",
			type = 	"guid",
			option = 	"required"
		}
	},
	pt_bc_get_assist_info_data_ack = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"ret_",
			type = 	"char",
			option = 	"required"
		},
		{
			name = 	"dst_ply_guid_",
			type = 	"guid",
			option = 	"required"
		},
		{
			name = 	"items_",
			type = 	"AssistInfoData",
			option = 	"repeated"
		}
	},
	pt_bc_integal_condition_noti = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"type_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"rule_id_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"rule_id_android_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"rule_desc_",
			type = 	"string",
			option = 	"required"
		}
	},
	pt_bc_coupon_not = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"ret_",
			type = 	"char",
			option = 	"required"
		},
		{
			name = 	"num_",
			type = 	"int",
			option = 	"required"
		}
	},
	pt_br_need_send_robot_not = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"table_id_",
			type = 	"int",
			option = 	"required"
		}
	},
	pt_bc_common_message_not = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"type_",
			type = 	"char",
			option = 	"required"
		},
		{
			name = 	"message_",
			type = 	"string",
			option = 	"required"
		}
	},
	pt_bc_below_admission_limit_tip_not = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"type_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"money_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"message_",
			type = 	"string",
			option = 	"required"
		}
	},
	pt_bc_recharge_tip_not = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"type_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"money_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"message_",
			type = 	"string",
			option = 	"required"
		}
	},
	pt_bc_calc_player_round_count_not = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"num_",
			type = 	"int",
			option = 	"required"
		}
	},
	RoundAwardItem = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"rounds_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"money_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"status_",
			type = 	"int",
			option = 	"required"
		}
	},
	RoundAward = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"round_award_",
			type = 	"RoundAwardItem",
			option = 	"repeated"
		}
	},
	pt_bc_round_award_items_not = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"round_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"items_",
			type = 	"RoundAwardItem",
			option = 	"repeated"
		}
	},
	pt_cb_get_round_award_req = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"type_",
			type = 	"char",
			option = 	"required"
		}
	},
	pt_bc_get_round_award_ack = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"ret_",
			type = 	"char",
			option = 	"required"
		},
		{
			name = 	"round_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"award_round_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"money_",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"message_",
			type = 	"string",
			option = 	"required"
		}
	},
	pt_bc_award_type_not = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"type_",
			type = 	"int",
			option = 	"repeated"
		}
	},
	st_card_ex = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"cValue",
			type = 	"char",
			option = 	"required"
		},
		{
			name = 	"cColor",
			type = 	"char",
			option = 	"required"
		}
	},
	pt_sm_gamesetting_req = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		}
	},
	pt_sm_gamesetting_ack = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"nMinBet",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"nMaxBet",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"nMinAddBet",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"nMaxChangeCardNum",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"ChangeCost0",
			type = 	"float",
			option = 	"required"
		},
		{
			name = 	"ChangeCost1",
			type = 	"float",
			option = 	"required"
		},
		{
			name = 	"ChangeCost2",
			type = 	"float",
			option = 	"required"
		}
	},
	pt_sm_startgame_req = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"nbet",
			type = 	"int",
			option = 	"required"
		}
	},
	pt_sm_startgame_ack = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"nResult",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"cColor",
			type = 	"char",
			option = 	"required"
		},
		{
			name = 	"vecCards",
			type = 	"st_card_ex",
			option = 	"repeated"
		},
		{
			name = 	"cardType",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"currentMoney",
			type = 	"int64",
			option = 	"required"
		},
		{
			name = 	"gameMoney",
			type = 	"int64",
			option = 	"required"
		},
		{
			name = 	"money",
			type = 	"int64",
			option = 	"required"
		}
	},
	pt_sm_changecard_req = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"cPos",
			type = 	"char",
			option = 	"required"
		}
	},
	pt_sm_changecard_ack = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"nResult",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"nRemainChangeNum",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"cPos",
			type = 	"char",
			option = 	"required"
		},
		{
			name = 	"oCard",
			type = 	"st_card_ex",
			option = 	"required"
		},
		{
			name = 	"cardType",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"currentMoney",
			type = 	"int64",
			option = 	"required"
		},
		{
			name = 	"gameMoney",
			type = 	"int64",
			option = 	"required"
		},
		{
			name = 	"money",
			type = 	"int64",
			option = 	"required"
		}
	},
	pt_sm_gameresult_req = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		}
	},
	pt_sm_gameresult_ack = {
		{
			name = 	"opcode",
			type = 	"short",
			option = 	"required"
		},
		{
			name = 	"cCardType",
			type = 	"char",
			option = 	"required"
		},
		{
			name = 	"fBetScale",
			type = 	"float",
			option = 	"required"
		},
		{
			name = 	"nBonus",
			type = 	"int",
			option = 	"required"
		},
		{
			name = 	"currentMoney",
			type = 	"int64",
			option = 	"required"
		},
		{
			name = 	"gameMoney",
			type = 	"int64",
			option = 	"required"
		}
	},
	pt_bc_get_achieve_award_not = {
		{
			name = 	"opcode",
			type = 	"short",
			option = "required"
		},
		{
			name = 	"index_",
			type = 	"int",
			option = "required"
		},
		{
			name = 	"name_",
			type = 	"string",
			option = "required"
		},
		{
			name = 	"desc_",
			type = 	"string",
			option = "required"
		}
	},
	pt_bc_get_daily_task_award_not = {
		{
			name = 	"opcode",
			type = 	"short",
			option = "required"
		},
		{
			name = 	"index_",
			type = 	"int",
			option = "required"
		},
		{
			name = 	"name_",
			type = 	"string",
			option = "required"
		},
		{
			name = 	"desc_",
			type = 	"string",
			option = "required"
		}
	},
	
	pt_cb_get_task_system_req = {
		{
			name = 	"opcode",
			type = 	"short",
			option = "required"
		}
	},
	ItemAwardData = {
		{
			name = 	"opcode",
			type = 	"short",
			option = "required"
		},
		{
			name = 	"index_",
			type = 	"int",
			option = "required"
		},
		{
			name = 	"number_",
			type = 	"int",
			option = "required"
		}
	},
	RoundAwardData = {
		{
			name = 	"opcode",
			type = 	"short",
			option = "required"
		},
		{
			name = 	"task_type_",
			type = 	"int",
			option = "required"
		},
		{
			name = 	"task_index_",
			type = 	"int",
			option = "required"
		},
		{
			name = 	"award_round_",
			type = 	"int",
			option = "required"
		},
		{
			name = 	"award_name_",
			type = 	"string",
			option = "required"
		},
		{
			name = 	"items_",
			type = 	"ItemAwardData",
			option = "repeated"
		}
	},
	pt_bc_get_task_system_ack = {
		{
			name = 	"opcode",
			type = 	"short",
			option = "required"
		},
		{
			name = 	"ret_",
			type = 	"char",
			option = "required"
		},
		{
			name = 	"round_items_",
			type = 	"RoundAwardData",
			option = "repeated"
		}
	},
	pt_cb_get_task_award_req = {
		{
			name = 	"opcode",
			type = 	"short",
			option = "required"
		},
		{
			name = 	"type_",
			type = 	"char",
			option = "required"
		},
		{
			name = 	"task_type_",
			type = 	"int",
			option = "required"
		},
		{
			name = 	"last_task_index_",
			type = 	"int",
			option = "required"
		}
	},
	pt_bc_get_task_award_ack = {
		{
			name = 	"opcode",
			type = 	"short",
			option = "required"
		},
		{
			name = 	"ret_",
			type = 	"char",
			option = "required"
		},
		{
			name = 	"task_type_",
			type = 	"int",
			option = "required"
		},
		{
			name = 	"last_task_index_",
			type = 	"int",
			option = "required"
		},
		{
			name = 	"cur_val_",
			type = 	"int",
			option = "required"
		},
		{
			name = 	"config_round_",
			type = 	"int",
			option = "required"
		},
		{
			name = 	"luck_draw_times_",
			type = 	"int",
			option = "required"
		}
	},
	pt_bc_item_update_not = {
		{
			name = 	"opcode",
			type = 	"short",
			option = "required"
		},
		{
			name = 	"index_",
			type = 	"int",
			option = "required"
		},
		{
			name = 	"num_",
			type = 	"int",
			option = "required"
		}
	},
	pt_cb_get_player_level_req = {
		{
			name = 	"opcode",
			type = 	"short",
			option = "required"
		}
	},
	pt_bc_get_player_level_ack = {
		{
			name = 	"opcode",
			type = 	"short",
			option = "required"
		},
		{
			name = 	"ret_",
			type = 	"char",
			option = "required"
		},
		{
			name = 	"level_",
			type = 	"int",
			option = "required"
		}
	},
	pt_bc_common_award_not = {
		{
			name = 	"opcode",
			type = 	"short",
			option = "required"
		},
		{
			name = 	"type_",
			type = 	"int",
			option = "required"
		},
		{
			name = 	"param_1_",
			type = 	"int",
			option = "required"
		},
		{
			name = 	"param_2_",
			type = 	"int",
			option = "required"
		},
		{
			name = 	"param_3_",
			type = 	"int",
			option = "required"
		},
		{
			name = 	"name_",
			type = 	"string",
			option = "required"
		},
		{
			name = 	"desc_",
			type = 	"string",
			option = "required"
		}
	},
	pt_cb_get_win_round_score_req = {
		{
			name = 	"opcode",
			type = 	"short",
			option = "required"
		},
		{
			name = 	"ply_guid_",
			type = 	"guid",
			option = "required"
		}
	},
	pt_bc_get_win_round_score_ack = {
		{
			name = 	"opcode",
			type = 	"short",
			option = "required"
		},
		{
			name = 	"ret_",
			type = 	"char",
			option = "required"
		},
		{
			name = 	"ply_guid_",
			type = 	"guid",
			option = "required"
		},
		{
			name = 	"num_",
			type = 	"int",
			option = "required"
		},
		{
			name = 	"score_",
			type = 	"int64",
			option = "required"
		},
		{
			name = 	"max_num_",
			type = 	"int",
			option = "required"
		},
		{
			name = 	"max_score_",
			type = 	"int64",
			option = "required"
		}
	},

	PlayerTaskData = {
		{
			name = 	"opcode",
			type = 	"short",
			option = "required"
		},
		{
			name = 	"task_type_",
			type = 	"int",
			option = "required"
		},
		{
			name = 	"last_task_index_",
			type = 	"int",
			option = "required"
		},
		{
			name = 	"cur_val_",
			type = 	"int",
			option = "required"
		}
	},
	pt_cl_update_achieve_req = {
		{
			name = 	"opcode",
			type = 	"short",
			option = "required"
		},
		{
			name = 	"index_",
			type = 	"int",
			option = "required"
		}
	},
	pt_lc_update_achieve_award_not = {
		{
			name = 	"opcode",
			type = 	"short",
			option = "required"
		},
		{
			name = 	"index_",
			type = 	"int",
			option = "required"
		},
		{
			name = 	"name_",
			type = 	"string",
			option = "required"
		},
		{
			name = 	"desc_",
			type = 	"string",
			option = "required"
		}
	},
	ExtraLoginAward = {
		{
			name = 	"opcode",
			type = 	"short",
			option = "required"
		},
		{
			name = 	"type_",
			type = 	"int",
			option = "required"
		},
		{
			name = 	"status_",
			type = 	"int",
			option = "required"
		}
	},
	pt_lc_update_extra_login_award_not = {
		{
			name = 	"opcode",
			type = 	"short",
			option = "required"
		},
		{
			name = 	"items_",
			type = 	"ExtraLoginAward",
			option = "repeated"
		},
		{
			name = 	"msg_",
			type = 	"string",
			option = "required"
		}
	},
	pt_cl_get_player_level_req = {
		{
			name = 	"opcode",
			type = 	"short",
			option = "required"
		}
	},
	pt_lc_get_player_level_ack = {
		{
			name = 	"opcode",
			type = 	"short",
			option = "required"
		},
		{
			name = 	"ret_",
			type = 	"char",
			option = "required"
		},
		{
			name = 	"level_",
			type = 	"int",
			option = "required"
		}
	},
	pt_cl_get_win_round_score_req = {
		{
			name = 	"opcode",
			type = 	"short",
			option = "required"
		},
		{
			name = 	"ply_guid_",
			type = 	"guid",
			option = "required"
		}
	},
	pt_lc_get_win_round_score_ack = {
		{
			name = 	"opcode",
			type = 	"short",
			option = "required"
		},
		{
			name = 	"ret_",
			type = 	"char",
			option = "required"
		},
		{
			name = 	"ply_guid_",
			type = 	"guid",
			option = "required"
		},
		{
			name = 	"num_",
			type = 	"int",
			option = "required"
		},
		{
			name = 	"score_",
			type = 	"int64",
			option = "required"
		},
		{
			name = 	"max_num_",
			type = 	"int",
			option = "required"
		},
		{
			name = 	"max_score_",
			type = 	"int64",
			option = "required"
		}
	},
	OnlineAwardItems = {
		{
			name = 	"opcode",
			type = 	"short",
			option = "required"
		},
        {
			name = 	"award_time_",
			type = 	"int",
			option = "required"
		},
        {
			name = 	"money_award_",
			type = 	"int",
			option = "required"
		}
	},
	pt_cb_get_online_award_items_req = {
		{
			name = 	"opcode",
			type = 	"short",
			option = "required"
		}
	},

	pt_bc_get_online_award_items_ack = {
		{
			name = 	"opcode",
			type = 	"short",
			option = "required"
		},
        {
			name = 	"ret_",
			type = 	"char",
			option = "required"
		},
        {
			name = 	"items_",
			type = 	"OnlineAwardItems",
			option = "repeated"
		}
	},
	pt_cb_get_achieve_list_req = {
		{
			name = 	"opcode",
			type = 	"short",
			option = "required"
		},
        {
			name = 	"game_id_",
			type = 	"int",
			option = "required"
		},

	},
	pt_bc_get_achieve_list_ack = {
		{
			name = 	"opcode",
			type = 	"short",
			option = "required"
		},
        {
			name = 	"items_",
			type = 	"AchieveData",
			option = "repeated"
		},

	},
	pt_cb_get_achieve_award_req = {
		{
			name = 	"opcode",
			type = 	"short",
			option = "required"
		},
        {
			name = 	"index_",
			type = 	"int",
			option = "required"
		},

	},
	pt_bc_get_achieve_award_ack = {
		{
			name = 	"opcode",
			type = 	"short",
			option = "required"
		},
        {
			name = 	"ret_",
			type = 	"char",
			option = "required"
		},
		{
			name = 	"param_1_",
			type = 	"int",
			option = "required"
		},
		{
			name = 	"param_2_",
			type = 	"int",
			option = "required"
		},
		{
			name = 	"param_3_",
			type = 	"int",
			option = "required"
		},
		{
			name = 	"param_4_",
			type = 	"int",
			option = "required"
		},
		{
			name = 	"param_5_",
			type = 	"int",
			option = "required"
		},

	},
	pt_cb_get_luck_draw_record_req = {
	    {
	      name = "opcode",
	      type = "short",
	      option = "required"
	    },
  	},
	pt_bc_get_luck_draw_record_ack = {
	    {
	      name = "opcode",
	      type = "short",
	      option = "required"
	    },
	    {
	      name = "ret_",
	      type = "int",
	      option = "required"
	    },
	    {
	      name = "index_",
	      type = "int",
	      option = "required"
	    },
	    {
	      name = "num_",
	      type = "int",
	      option = "required"
	    },
  	},
	pt_cb_get_luck_draw_req = {
	  {
	    name = "opcode",
	    type = "short",
	    option = "required",
	  },
	},
	LuckDrawItemData = {
	  {
	    name = "opcode",
	    type = "short",
	    option = "required",
	  },
	  {
	    name = "index_",
	    type = "int",
	    option = "required",
	  },
	  {
	    name = "number_",
	    type = "int",
	    option = "required",
	  },
	},
	pt_bc_get_luck_draw_ack = {
	  {
	    name = "opcode",
	    type = "short",
	    option = "required",
	  },
	  {
	    name = "ret_",
	    type = "char",
	    option = "required",
	  },
	  {
	    name = "items_",
	    type = "LuckDrawItemData",
	    option = "repeated",
	  },
	},

}
opcodeDefine = {};
opcodeReverse = {};

opcodeDefine["pt_ping"] = 7200;
opcodeDefine["pt_pong"] = 7201;
opcodeDefine["pt_cl_verify_ticket_req"] = 7202;
opcodeDefine["pt_lc_verity_ticket_ack"] = 7203;
opcodeDefine["pt_lc_server_data_not"] = 7204;
opcodeDefine["pt_lc_server_status_not"] = 7205;
opcodeDefine["pt_cl_get_ply_status_req"] = 7206;
opcodeDefine["pt_lc_get_ply_status_ack"] = 7207;
opcodeDefine["pt_cl_get_rank_list_req"] = 7208;
opcodeDefine["pt_lc_get_rank_list_ack"] = 7209;
opcodeDefine["pt_cl_get_achieve_list_req"] = 7210;
opcodeDefine["pt_lc_get_achieve_list_ack"] = 7211;
opcodeDefine["pt_cl_get_achieve_award_req"] = 7212;
opcodeDefine["pt_lc_get_achieve_award_ack"] = 7213;
opcodeDefine["pt_cl_trumpet_req"] = 7214;
opcodeDefine["pt_lc_trumpet_ack"] = 7215;
opcodeDefine["pt_lc_trumpet_not"] = 7216;
opcodeDefine["pt_lc_server_data_not2"] = 7217;
opcodeDefine["pt_cl_op_friend_req"] = 7218;
opcodeDefine["pt_lc_op_friend_ack"] = 7219;
opcodeDefine["pt_cl_get_friend_list_req"] = 7220;
opcodeDefine["pt_lc_get_friend_list_ack"] = 7221;
opcodeDefine["pt_cl_send_friend_msg_req"] = 7222;
opcodeDefine["pt_lc_send_friend_msg_not"] = 7223;
opcodeDefine["pt_cl_get_unread_msg_req"] = 7224;
opcodeDefine["pt_cl_get_daily_task_list_req"] = 7225;
opcodeDefine["pt_lc_get_daily_task_list_ack"] = 7226;
opcodeDefine["pt_cl_get_daily_task_award_req"] = 7227;
opcodeDefine["pt_lc_get_daily_task_award_ack"] = 7228;
opcodeDefine["pt_lc_friend_approve_req"] = 7229;
opcodeDefine["pt_cl_friend_approve_ack"] = 7230;
opcodeDefine["pt_cl_send_ply_position_info_req"] = 7231;
opcodeDefine["pt_lc_send_ply_position_info_ack"] = 7232;
opcodeDefine["pt_cl_get_position_info_req"] = 7233;
opcodeDefine["pt_lc_get_position_info_ack"] = 7234;
opcodeDefine["pt_cl_get_achieve_ext_list_req"] = 7235;
opcodeDefine["pt_lc_get_achieve_ext_list_ack"] = 7236;
opcodeDefine["pt_cl_get_achieve_ext_award_req"] = 7237;
opcodeDefine["pt_lc_get_achieve_ext_award_ack"] = 7238;
opcodeDefine["pt_lc_send_user_data_change_not"] = 7239;
opcodeDefine["pt_lc_friend_loginout_tip_not"] = 7240;
opcodeDefine["pt_cl_get_game_config_req"] = 7241;
opcodeDefine["pt_lc_get_game_config_ack"] = 7242;
opcodeDefine["pt_cl_get_assist_info_data_req"] = 7243;
opcodeDefine["pt_lc_get_assist_info_data_ack"] = 7244;
opcodeDefine["pt_lc_integal_condition_noti"] = 7245;
opcodeDefine["pt_lc_send_friend_msg_ack"] = 7246;
opcodeDefine["pt_cl_set_password_safe_req"] = 7247;
opcodeDefine["pt_lc_set_password_safe_ack"] = 7248;
opcodeDefine["pt_cl_store_safe_amount_req"] = 7249;
opcodeDefine["pt_lc_store_safe_amount_ack"] = 7250;
opcodeDefine["pt_cl_remove_safe_amount_req"] = 7251;
opcodeDefine["pt_lc_remove_safe_amount_ack"] = 7252;
opcodeDefine["pt_cl_modify_password_safe_req"] = 7253;
opcodeDefine["pt_lc_modify_password_safe_ack"] = 7254;
opcodeDefine["pt_cl_get_safe_history_req"] = 7255;
opcodeDefine["pt_lc_get_safe_history_ack"] = 7256;
opcodeDefine["pt_cl_get_safe_data_req"] = 7257;
opcodeDefine["pt_lc_get_safe_data_ack"] = 7258;
opcodeDefine["pt_cl_get_continuous_game_award_req"] = 7259;
opcodeDefine["pt_lc_get_continuous_game_award_ack"] = 7260;
opcodeDefine["pt_cl_get_miniGame_req"] = 7261;
opcodeDefine["pt_lc_get_miniGame_ack"] = 7262;
opcodeDefine["pt_cl_update_achieve_req"] = 7263;
opcodeDefine["pt_lc_update_achieve_award_not"] = 7264;
opcodeDefine["pt_lc_update_extra_login_award_not"] = 7265;
opcodeDefine["pt_cl_get_player_level_req"] = 7266;
opcodeDefine["pt_lc_get_player_level_ack"] = 7267;
opcodeDefine["pt_cl_get_win_round_score_req"] = 7268;
opcodeDefine["pt_lc_get_win_round_score_ack"] = 7269;
opcodeReverse[7200] = "pt_ping";
opcodeReverse[7201] = "pt_pong";
opcodeReverse[7202] = "pt_cl_verify_ticket_req";
opcodeReverse[7203] = "pt_lc_verity_ticket_ack";
opcodeReverse[7204] = "pt_lc_server_data_not";
opcodeReverse[7205] = "pt_lc_server_status_not";
opcodeReverse[7206] = "pt_cl_get_ply_status_req";
opcodeReverse[7207] = "pt_lc_get_ply_status_ack";
opcodeReverse[7208] = "pt_cl_get_rank_list_req";
opcodeReverse[7209] = "pt_lc_get_rank_list_ack";
opcodeReverse[7210] = "pt_cl_get_achieve_list_req";
opcodeReverse[7211] = "pt_lc_get_achieve_list_ack";
opcodeReverse[7212] = "pt_cl_get_achieve_award_req";
opcodeReverse[7213] = "pt_lc_get_achieve_award_ack";
opcodeReverse[7214] = "pt_cl_trumpet_req";
opcodeReverse[7215] = "pt_lc_trumpet_ack";
opcodeReverse[7216] = "pt_lc_trumpet_not";
opcodeReverse[7217] = "pt_lc_server_data_not2";
opcodeReverse[7218] = "pt_cl_op_friend_req";
opcodeReverse[7219] = "pt_lc_op_friend_ack";
opcodeReverse[7220] = "pt_cl_get_friend_list_req";
opcodeReverse[7221] = "pt_lc_get_friend_list_ack";
opcodeReverse[7222] = "pt_cl_send_friend_msg_req";
opcodeReverse[7223] = "pt_lc_send_friend_msg_not";
opcodeReverse[7224] = "pt_cl_get_unread_msg_req";
opcodeReverse[7225] = "pt_cl_get_daily_task_list_req";
opcodeReverse[7226] = "pt_lc_get_daily_task_list_ack";
opcodeReverse[7227] = "pt_cl_get_daily_task_award_req";
opcodeReverse[7228] = "pt_lc_get_daily_task_award_ack";
opcodeReverse[7229] = "pt_lc_friend_approve_req";
opcodeReverse[7230] = "pt_cl_friend_approve_ack";
opcodeReverse[7231] = "pt_cl_send_ply_position_info_req";
opcodeReverse[7232] = "pt_lc_send_ply_position_info_ack";
opcodeReverse[7233] = "pt_cl_get_position_info_req";
opcodeReverse[7234] = "pt_lc_get_position_info_ack";
opcodeReverse[7235] = "pt_cl_get_achieve_ext_list_req";
opcodeReverse[7236] = "pt_lc_get_achieve_ext_list_ack";
opcodeReverse[7237] = "pt_cl_get_achieve_ext_award_req";
opcodeReverse[7238] = "pt_lc_get_achieve_ext_award_ack";
opcodeReverse[7239] = "pt_lc_send_user_data_change_not";
opcodeReverse[7240] = "pt_lc_friend_loginout_tip_not";
opcodeReverse[7241] = "pt_cl_get_game_config_req";
opcodeReverse[7242] = "pt_lc_get_game_config_ack";
opcodeReverse[7243] = "pt_cl_get_assist_info_data_req";
opcodeReverse[7244] = "pt_lc_get_assist_info_data_ack";
opcodeReverse[7245] = "pt_lc_integal_condition_noti";
opcodeReverse[7246] = "pt_lc_send_friend_msg_ack";
opcodeReverse[7247] = "pt_cl_set_password_safe_req";
opcodeReverse[7248] = "pt_lc_set_password_safe_ack";
opcodeReverse[7249] = "pt_cl_store_safe_amount_req";
opcodeReverse[7250] = "pt_lc_store_safe_amount_ack";
opcodeReverse[7251] = "pt_cl_remove_safe_amount_req";
opcodeReverse[7252] = "pt_lc_remove_safe_amount_ack";
opcodeReverse[7253] = "pt_cl_modify_password_safe_req";
opcodeReverse[7254] = "pt_lc_modify_password_safe_ack";
opcodeReverse[7255] = "pt_cl_get_safe_history_req";
opcodeReverse[7256] = "pt_lc_get_safe_history_ack";
opcodeReverse[7257] = "pt_cl_get_safe_data_req";
opcodeReverse[7258] = "pt_lc_get_safe_data_ack";
opcodeReverse[7259] = "pt_cl_get_continuous_game_award_req";
opcodeReverse[7260] = "pt_lc_get_continuous_game_award_ack";
opcodeReverse[7261] = "pt_cl_get_miniGame_req";
opcodeReverse[7262] = "pt_lc_get_miniGame_ack";
opcodeReverse[7263] = "pt_cl_update_achieve_req";
opcodeReverse[7264] = "pt_lc_update_achieve_award_not";
opcodeReverse[7265] = "pt_lc_update_extra_login_award_not";
opcodeReverse[7266] = "pt_cl_get_player_level_req";
opcodeReverse[7267] = "pt_lc_get_player_level_ack";
opcodeReverse[7268] = "pt_cl_get_win_round_score_req";
opcodeReverse[7269] = "pt_lc_get_win_round_score_ack";

opcodeReverse[7270] = "pt_lc_user_data_broadcast_msg_not";
opcodeDefine["pt_lc_user_data_broadcast_msg_not"] = 7270;
packetDefine["pt_lc_user_data_broadcast_msg_not"]	={
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
	name	=	"message_",
	type	=	"string",
	option	=	"required"
	}
};

opcodeReverse[7271] = "pt_cl_reload_user_data_req";
opcodeDefine["pt_cl_reload_user_data_req"] = 7271;
packetDefine["pt_cl_reload_user_data_req"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
};
opcodeReverse[7272] = "pt_lc_reload_user_data_ack";
opcodeDefine["pt_lc_reload_user_data_ack"] = 7272;
packetDefine["pt_lc_reload_user_data_ack"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"ret_",
	type		=	"char",
	option	=	"required"
	},
	{
	name	=	"money_",
	type		=	"int64",
	option	=	"required"
	},
	{
	name	=	"gift_",
	type		=	"int",
	option	=	"required"
	},
	{
	name	=	"level_",
	type		=	"int",
	option	=	"required"
	},
	{
	name	=	"param_",
	type		=	"string",
	option	=	"required"
	},
};
opcodeReverse[7281] = "pt_cl_get_user_already_login_days_req";
opcodeDefine["pt_cl_get_user_already_login_days_req"] = 7281;
packetDefine["pt_cl_get_user_already_login_days_req"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
};
opcodeReverse[7282] = "pt_lc_get_user_already_login_days_ack";
opcodeDefine["pt_lc_get_user_already_login_days_ack"] = 7282;
packetDefine["pt_lc_get_user_already_login_days_ack"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"days_",
	type		=	"int",
	option	=	"required"
	},
};
opcodeReverse[7283] = "pt_lc_auto_add_frd_not";
opcodeDefine["pt_lc_auto_add_frd_not"] = 7283;
packetDefine["pt_lc_auto_add_frd_not"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"ret_",
	type		=	"int",
	option	=	"required"
	},
	{
	name	=	"limit_guid_",
	type		=	"guid",
	option	=	"required"
	},
	
};

opcodeReverse[7284] = "pt_cl_get_relief_times_req";
opcodeDefine["pt_cl_get_relief_times_req"] = 7284;
packetDefine["pt_cl_get_relief_times_req"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	
};
opcodeReverse[7285] = "pt_lc_get_relief_times_ack";
opcodeDefine["pt_lc_get_relief_times_ack"] = 7285;
packetDefine["pt_lc_get_relief_times_ack"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"times_",
	type		=	"int",
	option	=	"required"
	},
	
};

packetDefine["SigninAward"] =
{
	{
		name = 	"opcode",
		type = 	"short",
		option = 	"required"
	},
	{
		name = 	"days_",
		type = 	"int",
		option = 	"required"
	},
	{
		name = 	"money_",
		type = 	"int",
		option = 	"required"
	},	
	{
		name = 	"gift_",
		type = 	"int",
		option = 	"required"
	},
	{
		name = 	"count_",
		type = 	"int",
		option = 	"required"
	},
	{
		name = 	"state_",
		type = 	"int",
		option = 	"required"
	},
	{
		name = 	"index_",
		type = 	"int",
		option = 	"required"
	},
	{
		name = 	"name_",
		type = 	"string",
		option = 	"required"
	},
} 
packetDefine["SigninAward2"] =
{
	{
		name = 	"opcode",
		type = 	"short",
		option = 	"required"
	},
	{
		name = 	"today_",
		type = 	"int",
		option = 	"required"
	},
	{
		name = 	"signin_award_",
		type = 	"SigninAward",
		option = 	"repeated"
	},
}
packetDefine["SigninInfo"]	={
	{
		name = 	"opcode",
		type = 	"short",
		option = 	"required"
	},
	{
		name = 	"signin_days_",
		type = 	"int",
		option = 	"repeated"
	},
	{
		name = 	"buqianka_",
		type = 	"int",
		option = 	"required"
	},
	{
		name = 	"signin_award_",
		type = 	"SigninAward2",
		option = 	"required"
	},
}
opcodeDefine["pt_cl_get_relief_req"] = 7290;
opcodeDefine["pt_lc_get_relief_ack"] = 7291;
opcodeReverse[7290] = "pt_cl_get_relief_req";
opcodeReverse[7291] = "pt_lc_get_relief_ack";
packetDefine["pt_cl_get_relief_req"] = {
	{
		name	=	"opcode",
		type	=	"short",
		option	=	"required"
	},
}

packetDefine["pt_lc_get_relief_ack"] = {
	{
		name	=	"opcode",
		type	=	"short",
		option	=	"required"
	},
	{
		name 	= 	"ret_",
		type 	= 	"char",
		option 	= 	"required"
	},
}
opcodeReverse[20000] = "pt_cl_get_user_signin_days_req";
opcodeDefine["pt_cl_get_user_signin_days_req"] = 20000;
packetDefine["pt_cl_get_user_signin_days_req"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
};
opcodeReverse[20001] = "pt_lc_get_user_signin_days_ack";
opcodeDefine["pt_lc_get_user_signin_days_ack"] = 20001;
packetDefine["pt_lc_get_user_signin_days_ack"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"ret",
	type		=	"int",
	option	=	"required"
	},	
	{
	name	=	"signin_info_",
	type		=	"SigninInfo",
	option	=	"required"
	},
	
};
opcodeReverse[20002] = "pt_cl_set_user_signin_days_req";
opcodeDefine["pt_cl_set_user_signin_days_req"] = 20002;
packetDefine["pt_cl_set_user_signin_days_req"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"day",
	type		=	"int",
	option	=	"required"
	},	
};

opcodeReverse[20003] = "pt_lc_set_user_signin_days_ack";
opcodeDefine["pt_lc_set_user_signin_days_ack"] = 20003;
packetDefine["pt_lc_set_user_signin_days_ack"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"ret",
	type		=	"int",
	option	=	"required"
	},	
	{
	name	=	"day",
	type		=	"int",
	option	=	"required"
	},
	{
	name	=	"totalday",
	type		=	"int",
	option	=	"required"
	},
	{
	name	=	"money_",
	type		=	"int",
	option	=	"required"
	},
};

opcodeReverse[20004] = "pt_cl_get_user_signin_award_info_req";
opcodeDefine["pt_cl_get_user_signin_award_info_req"] = 20004;
packetDefine["pt_cl_get_user_signin_award_info_req"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
};

opcodeReverse[20005] = "pt_lc_get_user_signin_award_info_ack";
opcodeDefine["pt_lc_get_user_signin_award_info_ack"] = 20005;
packetDefine["pt_lc_get_user_signin_award_info_ack"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"ret",
	type		=	"int",
	option	=	"required"
	},	
	{
	name	=	"signin_award_",
	type		=	"SigninAward2",
	option	=	"required"
	},
};

opcodeReverse[20006] = "pt_cl_get_user_signin_award_req";
opcodeDefine["pt_cl_get_user_signin_award_req"] = 20006;
packetDefine["pt_cl_get_user_signin_award_req"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"day",
	type		=	"int",
	option	=	"required"
	},
};

opcodeReverse[20007] = "pt_lc_get_user_signin_award_ack";
opcodeDefine["pt_lc_get_user_signin_award_ack"] = 20007;
packetDefine["pt_lc_get_user_signin_award_ack"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"ret",
	type		=	"int",
	option	=	"required"
	},	
	{
	name	=	"day",
	type		=	"int",
	option	=	"required"
	},
};
-- NET_PACKET(pt_lc_send_vip_data_change_not)		// ?ṹ?
-- {
-- 	int vipLevel		;
-- 	int vipRate	;
-- 	int nextVipneedMoney				;	// money
-- 	string param_ ;
-- };
opcodeReverse[20009] = "pt_lc_send_vip_data_change_not";
opcodeDefine["pt_lc_send_vip_data_change_not"] = 20009;
packetDefine["pt_lc_send_vip_data_change_not"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"vipLevel",
	type		=	"int",
	option	=	"required"
	},	
	{
	name	=	"vipRate",
	type		=	"int",
	option	=	"required"
	},
	{
	name	=	"nextVipneedMoney",
	type		=	"int",
	option	=	"required"
	},
	{
	name	=	"param_",
	type		=	"string",
	option	=	"required"
	},
};
opcodeReverse[20010] = "pt_cl_get_user_good_card_req";
opcodeDefine["pt_cl_get_user_good_card_req"] = 20010;
packetDefine["pt_cl_get_user_good_card_req"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"num_",
	type	=	"int",
	option	=	"required"
	},
};
opcodeReverse[20011] = "pt_lc_get_user_good_card_ack";
opcodeDefine["pt_lc_get_user_good_card_ack"] = 20011;
packetDefine["pt_lc_get_user_good_card_ack"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"ret",
	type	=	"int",
	option	=	"required"
	},
	{
	name	=	"num_",
	type	=	"int",
	option	=	"required"
	}
};


opcodeReverse[20020] = "pt_lc_item_config_not";
opcodeDefine["pt_lc_item_config_not"] = 20020;
packetDefine["pt_lc_item_config_not"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"item_list_",
	type	=	"int",
	option	=	"repeated"
	},
	
};
opcodeReverse[20021] = "pt_cl_server_data_req";
opcodeDefine["pt_cl_server_data_req"] = 20021;
packetDefine["pt_cl_server_data_req"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
};

 
opcodeReverse[7320] = "pt_bc_message_not";
opcodeDefine["pt_bc_message_not"] = 7320;
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
opcodeReverse[7313] = "pt_cb_change_table_req";

opcodeReverse[7321] = "pt_cb_create_table_req";
opcodeReverse[7322] = "pt_bc_create_table_ack";
opcodeReverse[7334] = "pt_cb_get_table_list_req2";
opcodeReverse[7335] = "pt_bc_get_table_list_ack2";

opcodeReverse[7354] = "pt_bc_award_type_not";
opcodeReverse[7355] = "pt_bc_get_achieve_award_not";
opcodeReverse[7356] = "pt_cb_get_task_system_req";
opcodeReverse[7357] = "pt_bc_get_task_system_ack";
opcodeReverse[7358] = "pt_cb_get_task_award_req";
opcodeReverse[7359] = "pt_bc_get_task_award_ack";
opcodeReverse[7360] = "pt_bc_item_update_not";
opcodeReverse[7361] = "pt_cb_get_player_level_req";
opcodeReverse[7362] = "pt_bc_get_player_level_ack";
opcodeReverse[7363] = "pt_cb_get_online_award_items_req";
opcodeReverse[7364] = "pt_bc_get_online_award_items_ack";
opcodeReverse[7365] = "pt_bc_common_award_not";
opcodeReverse[7366] = "pt_cb_get_win_round_score_req";
opcodeReverse[7367] = "pt_bc_get_win_round_score_ack";
opcodeReverse[7318] = "pt_bc_update_ply_data_not";
opcodeDefine["pt_bc_update_ply_data_not"] = 7318;
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
opcodeDefine["pt_cb_change_table_req"] = 7313;

opcodeDefine["pt_cb_create_table_req"] = 7321;
opcodeDefine["pt_bc_create_table_ack"] = 7322;
opcodeDefine["pt_cb_get_table_list_req2"] = 7334;
opcodeDefine["pt_bc_get_table_list_ack2"] = 7335;

opcodeDefine["pt_bc_award_type_not"] = 7354;
opcodeDefine["pt_bc_get_achieve_award_not"] = 7355;
opcodeDefine["pt_cb_get_task_system_req"] = 7356;
opcodeDefine["pt_bc_get_task_system_ack"] = 7357;
opcodeDefine["pt_cb_get_task_award_req"] = 7358;
opcodeDefine["pt_bc_get_task_award_ack"] = 7359;
opcodeDefine["pt_bc_item_update_not"] = 7360;
opcodeDefine["pt_cb_get_player_level_req"] = 7361;
opcodeDefine["pt_bc_get_player_level_ack"] = 7362;
opcodeDefine["pt_cb_get_online_award_items_req"] = 7363;
opcodeDefine["pt_bc_get_online_award_items_ack"] = 7364;
opcodeDefine["pt_bc_common_award_not"] = 7365;
opcodeDefine["pt_cb_get_win_round_score_req"] = 7366;
opcodeDefine["pt_bc_get_win_round_score_ack"] = 7367;

opcodeDefine["pt_cb_get_achieve_list_req"] = 7368;
opcodeDefine["pt_bc_get_achieve_list_ack"] = 7369;
opcodeDefine["pt_cb_get_achieve_award_req"] = 7370;
opcodeDefine["pt_bc_get_achieve_award_ack"] = 7371;

opcodeDefine["pt_bc_get_daily_task_award_not"] = 7379;
opcodeDefine["pt_bc_successive_victory_not"] = 7380;

opcodeDefine["pt_cb_get_daily_task_award_req"] = 7381;
opcodeDefine["pt_bc_get_daily_task_award_ack"] = 7382;

opcodeReverse[7368] = "pt_cb_get_achieve_list_req";
opcodeReverse[7369] = "pt_bc_get_achieve_list_ack";
opcodeReverse[7370] = "pt_cb_get_achieve_award_req";
opcodeReverse[7371] = "pt_bc_get_achieve_award_ack";


opcodeReverse[7379] = "pt_bc_get_daily_task_award_not";

opcodeReverse[7380] = "pt_bc_successive_victory_not";
opcodeReverse[7381] = "pt_cb_get_daily_task_award_req";
opcodeReverse[7382] = "pt_bc_get_daily_task_award_ack";
-- cb_get_successive_victory_award_req,// Request task award 
-- 	bc_get_successive_victory_award_ack,// Response task award

-- NET_GET(pt_bc_successive_victory_not)
-- {
-- 	return is >> pt.opcode >> pt.count_ >> pt.msg_;
-- }
packetDefine["pt_bc_successive_victory_not"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"count_",
	type	=	"int",
	option	=	"required"
	},
	{
	name	=	"msg_",
	type	=	"string",
	option	=	"required"
	}
};
packetDefine["pt_cb_get_daily_task_award_req"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"index_",
	type		=	"int",
	option	=	"required"
	},
	
};

packetDefine["pt_bc_get_daily_task_award_ack"]	={
	{
		name = 	"opcode",
		type = 	"short",
		option = 	"required"
	},
	{
		name = 	"ret_",
		type = 	"char",
		option = 	"required"
	},
	{
		name = 	"money_",
		type = 	"int",
		option = 	"required"
	},
	{
		name = 	"gift_",
		type = 	"int",
		option = 	"required"
	},
	{
		name = 	"prop_1_",
		type = 	"int",
		option = 	"required"
	},
	{
		name = 	"prop_2_",
		type = 	"int",
		option = 	"required"
	},
	{
		name = 	"prop_3_",
		type = 	"int",
		option = 	"required"
	},
	{
		name = 	"prop_4_",
		type = 	"int",
		option = 	"required"
	},
	{
		name = 	"prop_5_",
		type = 	"int",
		option = 	"required"
	}
	
};

opcodeReverse[7319] = "pt_bc_cli_timer_not";
opcodeDefine["pt_bc_cli_timer_not"] = 7319;
opcodeReverse[7320] = "pt_bc_message_not";
opcodeDefine["pt_bc_message_not"] = 7320;

itemDefine = {
	ITEM_TRUMPET			= 1,	--小喇叭
	ITEM_CARD_RECORD		= 2,	--记牌器
	ITEM_MATCH_TICKET		= 3,	--比赛卷
	ITEM_KICK_OUT 			= 4,	--踢人道具
	ITEM_EXPRESSION_PARCEL	= 5,	--招财猫表情包
	ITEM_RED_WINE			= 6,	--红酒
	ITEM_EGG				= 8,	--鸡蛋
	ITEM_FLOWER				= 9,	--鲜花
	ITEM_LABA_COIN			= 50,	--拉霸币
    ITEM_CHANGE_TASK		= 51,	--刷任务
    ITEM_CHANGE_BAO  		= 52,	--刷宝牌
    ITEM_CONTINUE_VICTORY	= 53,	--连胜卡

    WEEK_FAN_NUM_TYPE       = 0,    --一周番数
    WEEK_FAN_TYPE           = 1,    --一周番型
    CONTINUE_WIN_TYPE       = 2,    --连胜类型
    CONTINUE_WIN_ROUND_TYPE = 3,    --连胜局数
}


opcodeReverse[7383] = "pt_bc_ready_ack";
opcodeDefine["pt_bc_ready_ack"] = 7383;
packetDefine["pt_bc_ready_ack"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"ret_",
	type		=	"char",
	option	=	"required"
	},
	
};
opcodeReverse[7388] = "pt_cb_get_streak_task_req";
opcodeDefine["pt_cb_get_streak_task_req"] = 7388;
packetDefine["pt_cb_get_streak_task_req"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	
};
opcodeReverse[7389] = "pt_bc_get_streak_task_ack";
opcodeDefine["pt_bc_get_streak_task_ack"] = 7389;
packetDefine["pt_bc_get_streak_task_ack"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},
	{
	name	=	"ret_",
	type		=	"int",
	option	=	"required"
	},
	{
	name	=	"index_",
	type		=	"int",
	option	=	"required"
	},
	{
	name	=	"name_",
	type		=	"string",
	option	=	"required"
	},
	{
	name	=	"desc_",
	type		=	"string",
	option	=	"required"
	},
	{
	name	=	"speed_",
	type		=	"int",
	option	=	"required"
	},
	{
	name	=	"amount_",
	type		=	"int",
	option	=	"required"
	},
	
};
packetDefine["pt_cl_spec_trumpet_req"] = {
    {
      name =  "opcode",
      type =  "short",
      option = "required"
    },
    {
      name = "game_id_",
      type = "int",
      option = "required"
    },
    {
      name = "message_",
      type = "string",
      option = "required"
    },
    {
      name = "image_",
      type = "string",
      option = "required"
    },
  };
  
packetDefine["pt_lc_spec_trumpet_ack"] = {
    {
      name =  "opcode",
      type =  "short",
      option = "required"
    },
    {
      name = "ret_",
      type = "char",
      option = "required"
    },
    {
      name = "msg_",
      type = "string",
      option = "required"
    },
  };
  
packetDefine["pt_lc_spec_trumpet_not"] = {
    {
      name = "opcode",
      type = "short",
      option = "required"
    },
    {
      name = "game_id_",
      type = "int",
      option = "required"
    },
    {
      name = "ply_guid_",
      type = "guid",
      option = "required"
    },
    {
      name = "ply_nickname_",
      type = "string",
      option = "required"
    },
    {
      name = "message_",
      type = "string",
      option = "required"
    },
    {
      name = "image_",
      type = "string",
      option = "required"
    },
  };

opcodeDefine["pt_cl_spec_trumpet_req"] = 7294;
opcodeDefine["pt_lc_spec_trumpet_ack"] = 7295;
opcodeDefine["pt_lc_spec_trumpet_not"] = 7296;

opcodeReverse[7294] = "pt_cl_spec_trumpet_req";
opcodeReverse[7295] = "pt_lc_spec_trumpet_ack";
opcodeReverse[7296] = "pt_lc_spec_trumpet_not";


opcodeReverse[7392] = "pt_cb_get_luck_draw_req";
opcodeReverse[7393] = "pt_bc_get_luck_draw_ack";
opcodeReverse[7394] = "pt_cb_get_luck_draw_record_req";
opcodeReverse[7395] = "pt_bc_get_luck_draw_record_ack";
opcodeDefine["pt_cb_get_luck_draw_req"] = 7392;
opcodeDefine["pt_bc_get_luck_draw_ack"] = 7393;
opcodeDefine["pt_cb_get_luck_draw_record_req"] = 7394;
opcodeDefine["pt_bc_get_luck_draw_record_ack"] = 7395;

-- pt_cb_get_luck_data_list_req
-- pt_bc_get_luck_data_list_ack
opcodeReverse[7398] = "pt_cb_get_luck_data_list_req";
opcodeDefine["pt_cb_get_luck_data_list_req"] = 7398;
packetDefine["pt_cb_get_luck_data_list_req"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},	
};
opcodeReverse[7399] = "pt_bc_get_luck_data_list_ack";
opcodeDefine["pt_bc_get_luck_data_list_ack"] = 7399;
packetDefine["pt_bc_get_luck_data_list_ack"]	={
	{
	name	=	"opcode",
	type		=	"short",
	option	=	"required"
	},	
	{
	      name = "ret_",
	      type = "char",
	      option = "required"
	    },
	{
	    name = "items_",
	    type = "LuckDrawItemData",
	    option = "repeated",
	  },
};
opcodeDefine["pt_bc_get_luck_draw_record_ack"] = 7395;



packetDefine["pt_cl_do_sign_match_req"] = {
    {
      name = "opcode",
      type = "short",
      option = "required"
    },
    {
      name = "match_id_",
      type = "int",
      option = "required"
    },
    {
      name = "match_order_id_",
      type = "int",
      option = "required"
    },
    {
      name = "operate_type_",
      type = "int",
      option = "required"
    }
  };
packetDefine["pt_lc_do_sign_match_ack"] = {
    {
      name = "opcode",
      type = "short",
      option = "required"
    },
    {
      name = "ret_",
      type = "int",
      option = "required"
    },
    {
      name = "match_id_",
      type = "int",
      option = "required"
    },
    {
      name = "operate_type_",
      type = "int",
      option = "required"
    }
  };
packetDefine["pt_lc_match_perpare_notf"] = {
    {
      name = "opcode",
      type = "short",
      option = "required"
    },
    {
      name = "match_id_",
      type = "int",
      option = "required"
    },
    {
      name = "match_order_id_",
      type = "int",
      option = "required"
    },
    {
      name = "current_score_",
      type = "int",
      option = "required"
    },
    {
      name = "round_index_",
      type = "int",
      option = "required"
    },
    {
      name = "totoal_round_",
      type = "int",
      option = "required"
    },
    {
      name = "match_type_",
      type = "int",
      option = "required"
    },
    {
      name = "param_",
      type = "string",
      option = "required"
    },
    {
		name = 	"data_",
		type = 	"ServerData2",
		option = "required"
	}
  };

packetDefine["pt_lc_match_round_avoid_notf"] = {
    {
      name = "opcode",
      type = "short",
      option = "required"
    },
    {
      name = "ply_guid_",
      type = "guid",
      option = "required"
    },
    {
      name = "match_id_",
      type = "int",
      option = "required"
    },
    {
      name = "match_order_id_",
      type = "int",
      option = "required"
    },
    {
		name = 	"round_index_",
		type = 	"int",
		option = "required"
	},
	{
		name = 	"totoal_round_",
		type = 	"int",
		option = "required"
	}
  };


packetDefine["pt_lc_match_lost_notf"] = {
    {
      name = "opcode",
      type = "short",
      option = "required"
    },
    {
      name = "ply_guid_",
      type = "guid",
      option = "required"
    },
    {
      name = "can_relive_",
      type = "int",
      option = "required"
    },
    {
      name = "relive_count_",
      type = "int",
      option = "required"
    },
    {
      name = "match_id_",
      type = "int",
      option = "required"
    },
    {
      name = "match_order_id_",
      type = "int",
      option = "required"
    },
    {
		name = 	"round_index_",
		type = 	"int",
		option = "required"
	},
	{
		name = 	"totoal_round_",
		type = 	"int",
		option = "required"
	},
	 {
    	name = "match_type_",
      type = "int",
      option = "required"
    },
	{
		name = 	"data_",
		type = 	"MatchPlayerData",
		option = "required"
	}
  };

 packetDefine["pt_cl_match_reborn_req"] = {
    {
      name = "opcode",
      type = "short",
      option = "required"
    },
    {
      name = "ply_guid_",
      type = "guid",
      option = "required"
    },
    {
      name = "match_id_",
      type = "int",
      option = "required"
    },
    {
      name = "match_order_id_",
      type = "int",
      option = "required"
    },
    {
		name = 	"round_index_",
		type = 	"int",
		option = "required"
	}
  };
  packetDefine["pt_lc_match_reborn_ack"] = {
    {
      name = "opcode",
      type = "short",
      option = "required"
    },
    {
      name = "ret_",
      type = "int",
      option = "required"
    },
    {
      name = "match_id_",
      type = "int",
      option = "required"
    },
    {
      name = "match_order_id_",
      type = "int",
      option = "required"
    },
    {
		name = 	"data_",
		type = 	"MatchPlayerData",
		option = "required"
	}
  };
packetDefine["pt_lc_match_result_notf"] = {
    {
      name = "opcode",
      type = "short",
      option = "required"
    },
    {
      name = "match_id_",
      type = "int",
      option = "required"
    },
    {
      name = "match_name_",
      type = "string",
      option = "required"
    },
    {
      name = "rank_index_",
      type = "int",
      option = "required"
    },
    {
    	name = "match_type_",
      type = "int",
      option = "required"
    },
    {
		name = 	"ply_vec_",
		type = 	"MatchPlayerRank",
		option = "repeated"
	}
};
packetDefine["pt_lc_match_round_end_notf"] = {
 -- int match_id_;
 --    int match_order_id_;
 --    int round_index_;
 --    int next_start_time_
    {
      name = "opcode",
      type = "short",
      option = "required"
    },
    {
      name = "match_id_",
      type = "int",
      option = "required"
    },
    {
      name = "match_order_id_",
      type = "int",
      option = "required"
    },
    {
      name = "round_index_",
      type = "int",
      option = "required"
    },
    {
      name = "next_start_time_",
      type = "int",
      option = "required"
    },
    {
    	name = "match_type_",
      type = "int",
      option = "required"
    }
   
};
--[[
packetDefine["pt_cl_get_match_rank_req"] = {
    {
      name = "opcode",
      type = "short",
      option = "required"
    },
    {
      name = "match_id_",
      type = "int",
      option = "required"
    }
};
packetDefine["pt_lc_get_match_rank_ack"] = {
    {
      name = "opcode",
      type = "short",
      option = "required"
    },
    {
      name = "match_id_",
      type = "int",
      option = "required"
    },
    {
      name = "match_order_id_",
      type = "int",
      option = "required"
    },
    {
      name = "round_index_",
      type = "int",
      option = "required"
    },
    {
		name = 	"next_start_time_",
		type = 	"int",
		option = "required"
	}
};
--]]
opcodeDefine["pt_cl_do_sign_match_req"] = 20024;
opcodeDefine["pt_lc_do_sign_match_ack"] = 20025;
opcodeDefine["pt_lc_match_perpare_notf"] = 20026;
opcodeDefine["pt_lc_match_round_avoid_notf"] = 20027;
opcodeDefine["pt_lc_match_lost_notf"] = 20028;
opcodeDefine["pt_cl_match_reborn_req"] = 20029;
opcodeDefine["pt_lc_match_reborn_ack"] = 20030;
opcodeDefine["pt_lc_match_result_notf"] = 20031;
opcodeDefine["pt_lc_match_round_end_notf"] = 20032;
--opcodeDefine["pt_cl_get_match_rank_req"] = 20033;
--opcodeDefine["pt_lc_get_match_rank_ack"] = 20034;

opcodeReverse[20024] = "pt_cl_do_sign_match_req";
opcodeReverse[20025] = "pt_lc_do_sign_match_ack";
opcodeReverse[20026] = "pt_lc_match_perpare_notf";
opcodeReverse[20027] = "pt_lc_match_round_avoid_notf";
opcodeReverse[20028] = "pt_lc_match_lost_notf";
opcodeReverse[20029] = "pt_cl_match_reborn_req";
opcodeReverse[20030] = "pt_lc_match_reborn_ack";
opcodeReverse[20031] = "pt_lc_match_result_notf";
opcodeReverse[20032] = "pt_lc_match_round_end_notf";
--opcodeReverse[20033] = "pt_cl_get_match_rank_req";
--opcodeReverse[20034] = "pt_lc_get_match_rank_ack";

-- NET_PACKET(pt_cl_match_require_status_req)
-- {
--     int match_id_;
--     int match_order_id_;
--     int round_index_;
-- };
opcodeReverse[20033] = "pt_cl_match_require_status_req";
opcodeDefine["pt_cl_match_require_status_req"] = 20033;
packetDefine["pt_cl_match_require_status_req"] = {
    {
      name = "opcode",
      type = "short",
      option = "required"
    },
    {
      name = "match_id_",
      type = "int",
      option = "required"
    },
    {
      name = "match_order_id_",
      type = "int",
      option = "required"
    },
    {
		name = 	"round_index_",
		type = 	"int",
		option = "required"
	}
};

opcodeReverse[20034] = "pt_lc_match_require_status_ack";
opcodeDefine["pt_lc_match_require_status_ack"] = 20034;
packetDefine["pt_lc_match_require_status_ack"] = {
    {
      name = "opcode",
      type = "short",
      option = "required"
    },
    {
      name = "ret_",
      type = "int",
      option = "required"
    },
    
};
opcodeReverse[20035] = "pt_cl_match_require_info_req";
opcodeDefine["pt_cl_match_require_info_req"] = 20035;
packetDefine["pt_cl_match_require_info_req"] = {
    {
      name = "opcode",
      type = "short",
      option = "required"
    },
    {
      name = "match_id_",
      type = "int",
      option = "required"
    },
    {
      name = "match_order_id_",
      type = "int",
      option = "required"
    },
    
};
opcodeReverse[20036] = "pt_lc_match_require_info_ack";
opcodeDefine["pt_lc_match_require_info_ack"] = 20036;
packetDefine["pt_lc_match_require_info_ack"] = {
    {
      name = "opcode",
      type = "short",
      option = "required"
    },
    {
      name = "match_info_",
      type = "MatchInfoNet",
      option = "required"
    },
    
    
};

opcodeReverse[20037] = "pt_lc_match_unfinished_notf";
opcodeDefine["pt_lc_match_unfinished_notf"] = 20037;
packetDefine["pt_lc_match_unfinished_notf"] = {
    {
      name = "opcode",
      type = "short",
      option = "required"
    },
    {
      name = "match_info_",
      type = "MatchInfoNet",
      option = "required"
    },
    
    
};
-- NET_PACKET(pt_cl_match_require_info_req)
-- {
--     int match_id_;
--     int match_order_id_;
-- };
-- NET_PACKET(pt_lc_match_require_info_ack)
-- {
--     int ret_;
--     MatchInfoNet    data_;
-- };
-- NET_PACKET(pt_lc_match_unfinished_notf)
-- {
--     MatchInfoNet    data_;
-- };

packetDefine["pt_cb_player_join_match_req"] = {
    {
      name = "opcode",
      type = "short",
      option = "required"
    },
    {
      name = "match_id_",
      type = "int",
      option = "required"
    },
    {
      name = "match_order_id_",
      type = "int",
      option = "required"
    }
  };
 packetDefine["pt_bc_player_join_match_ack"] = {
    {
      name = "opcode",
      type = "short",
      option = "required"
    },
    {
      name = "ret_",
      type = "int",
      option = "required"
    }
  };
packetDefine["pt_bc_rematch_notf"] = {
    {
      name = "opcode",
      type = "short",
      option = "required"
    },
    {
      name = "match_id_",
      type = "int",
      option = "required"
    },
    {
      name = "match_order_id_",
      type = "int",
      option = "required"
    },
    {
      name = "param_",
      type = "string",
      option = "required"
    },
    {
      name = "current_score_",
      type = "int",
      option = "required"
    },
    {
      name = "round_index_",
      type = "int",
      option = "required"
    },
    {
      name = "totoal_round_",
      type = "int",
      option = "required"
    }
  };
opcodeDefine["pt_cb_player_join_match_req"] = 21100;
opcodeDefine["pt_bc_player_join_match_ack"] = 21101;
opcodeDefine["pt_bc_rematch_notf"] = 21102;

opcodeReverse[21100] = "pt_cb_player_join_match_req";
opcodeReverse[21101] = "pt_bc_player_join_match_ack";
opcodeReverse[21102] = "pt_bc_rematch_notf";
