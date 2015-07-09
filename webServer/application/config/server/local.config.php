<?php
/*
include_once FR.'config/server/'.$g_server_name.'.config.php';:基础配置文件
author:
date:
使用说明：不同服务器的具体配置在这里配，缺省配置在default.config.php中
*/

//数据库配置

//$config['dbhost1'] =  '192.168.1.31';
$app_config['dbhost1'] =  '192.168.78.137';
$app_config['dbhost1'] =  '127.0.0.1';
$app_config['dbport1'] = '3306';

$app_config['dbdb1'] = 'card_game';
$app_config['dbuser'] = 'test';
$app_config['dbpwd'] = 'test';

$app_config['mongo']['host'] =  '127.0.0.1';
$app_config['mongo']['port'] = '27017';

$app_config['mongo']['db'] = 'beStar';
$app_config['mongo']['user'] = '';
$app_config['mongo']['pass'] = '';
/*
 * Defaults to FALSE. If FALSE, the program continues executing without waiting for a database response.
 * If TRUE, the program will wait for the database response and throw a MongoCursorException if the update did not succeed.
*/
$app_config['mongo']['query_safety'] = 1;

//If running in auth mode and the user does not have global read/write then set this to true
$app_config['mongo']['db_flag'] = TRUE;

$app_config['redis']['host'] = '127.0.0.1';
$app_config['redis']['port'] = '6379';


$app_config['mcache']['host'] =  '192.168.78.137';
$app_config['mcache']['host'] =  '127.0.0.1';
$app_config['mcache']['port'] = '11211';
$app_config['mcache']['version'] =  0;

$config['lobby'] = array(
	'lobby-server-1'=>	array("id"=>'lobby-server-1',
								"host"=>"127.0.0.1",
								"clientPort"=>3000),
);

define('SPEED',1);
define('VERSION',1.0);
//define('REGION','ASIA');
define('REGION','EURO');
$res_version = 'a.081302';
//开服时间1231836963
$config['game_start']=1239595200;
$config['maintain_work'] = false;
$config['maintain_open'] = '15:30';
$config['maintain_super_uid'] = array(795);
$sys_id = 1;
$zone_id = 0;
$g_server_id = 1;
$public_key = "XWR555";


$game_index_url = './';

$game_www_url = 'demo.php'; //英文登录页
//
define('COOKIE_DOMAIN','s3.app100640938.qqopenapp.com');
define("NOT_CONVERT_UID",true);

// 游戏配套论坛url
$game_bbs_url = " ";

// 测试功能
$is_testing = true;
$daily_gold = 15;
// 金币数量
$gold_count_init = 50;

$is_translation_server = 1;

$g_supply_lang = array('zh_CN', 'en_US', 'de');

$g_lang = 'zh_CN';

//预合服状态
$cfg_before_merge = false;

$g_lang = 'en_US';


$g_default_name_nid = 27;

$pay_public_key = 'sa7d3K';
$world_name = 's1';

$rank_delay = 3600*24;
$res_url_prefix = './';
$g_version_flag = 0;
$g_version_op = 0;
$g_banshu = 0;
$g_banben = 0;//0:内测；1；正式服
$g_pf = 'wanwan';

$g_is_public = 0;//0:本地，1：线上
$obt_online_gift_stats = 1; //公测消费礼包开关
$config_default_latlng = array(27,0,2);
$config_default_zoom = 2;

$qz_gift_open = 1;

define('TIME_ZONE',8);
define('QQ_APP_ID',100640938);
define('QQ_API_KEY','3bd83ce2e0f6a98eedb89cfe17ce9ef6');
define('KINGNET_RID',1039027);

$g_open_server_flag = 0;

$fb_config['appId'] = 'YOUR_APP_ID';
$fb_config['secret'] = 'YOUR_APP_SECRET';
$fb_config['fileUpload'] = false; // optional
?>
