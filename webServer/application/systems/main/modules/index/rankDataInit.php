<?php
$rank_list = array();
$rank_list["pai1"]=rank_get_user_rank_bywinners();
$rank_list["pai2"]=rank_get_user_rank_bycredits();
$json_rst['ranklist'] = $rank_list;