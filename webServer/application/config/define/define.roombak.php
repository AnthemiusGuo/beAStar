<?php
//房间	玩家是否可以当庄	入场限制	提出场次限制	庄金	税率
//初级场	是	1000	1000	10w ~ 4399w	7.83%
//中级场	是	100w	10w	1000w  ~  1亿	4.67%
//高级场	是	500w	50w	5000w ~ 10亿	4.19%
$cfg_max_zha_zhuang_round = 5;//上庄轮数
$room_list = array (
  1 => 
  array (
    'room_id' => 1,
    'room_typ' => 1,
    'function' => 'enter_zha_room',
    'room_name' => '初级场',
    'room_limit_low' => 1000,
    'room_limit_kick' => 1000,
    'room_limit_high' => 200000,
    'room_zhuang_limit_low' => 100000,
    'room_zhuang_limit_high' => 43990000,
    'ratio' => 0.0783,
    'room_desc' => '1千',
  ),
  2 => 
  array (
    'room_id' => 2,
    'room_typ' => 1,
    'function' => 'enter_zha_room',
    'room_name' => '中级场',
    'room_limit_low' => 1000000,
    'room_limit_kick' => 100000,
    'room_limit_high' => 0,
    'room_zhuang_limit_low' =>  10000000,
    'room_zhuang_limit_high' => 100000000,
    'ratio' => 0.0467,
    'room_desc' => '100万',
  ),
  3=>
  array (
    'room_id' => 3,
    'room_typ' => 1,
    'function' => 'enter_zha_room',
    'room_name' => '高级场',
    'room_limit_low' => 5000000,
    'room_limit_kick' => 500000,
    'room_limit_high' => 0,
    'room_zhuang_limit_low' =>  50000000,
    'room_zhuang_limit_high' => 1000000000,
    'ratio' => 0.0419,
    'room_desc' => '500万',   
    ),
  4=>
  array (
    'room_id' => 4,
    'room_typ' => 2,
    'function' => 'enter_yao_room',
    'room_name' => '摇摇乐',
    'room_limit_low' => 1000,
    'room_limit_kick' => 1000,
    'room_limit_high' => 0,
    'room_zhuang_limit_low' =>  10000,
    'room_zhuang_limit_high' => 1000000000,
    'ratio' => 0.0783,
    'room_desc' => '1000',   
    ));
$room_table_list[1][1] = array('socket_ip'=>'42.62.56.41',
                               'port'=>4399,
                               'online'=>0,
                               'table_id'=>1);
$room_table_list[2][1] = array('socket_ip'=>'42.62.56.41',
                               'port'=>4399,
                               'online'=>0,
                               'table_id'=>3);
$room_table_list[3][1] = array('socket_ip'=>'42.62.56.41',
                               'port'=>4399,
                               'online'=>0,
                               'table_id'=>5);
$room_table_list[4][1] = array('socket_ip'=>'42.62.56.41',
                               'port'=>4399,
                               'online'=>0,
                               'table_id'=>7);
$chat_table_list[1] = array('socket_ip'=>'42.62.56.41',
                               'port'=>4300,
                               'online'=>0,
                               'table_id'=>0);
?>