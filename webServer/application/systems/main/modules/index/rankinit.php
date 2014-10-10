<?php
$rank_list = array();
$rank_list[2]=rank_get_user_rank_bywinners();
$rank_list[1]=rank_get_user_rank_bycredits();
$json_rst['ranklist'] = $rank_list;