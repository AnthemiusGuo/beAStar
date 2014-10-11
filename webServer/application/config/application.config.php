<?
/*
全application不分服配置
*/
$app_config = array(
	'default_view' => JSON,
	'default_system' => 'main',
	);

$app_allow_system['main'] = 1;
$app_allow_system['cp'] = 1;



/*
全application分服配置，默认值，可以被分服配置覆盖
*/
$is_testing = false;
$g_lang = 'zh_CN';
$in_debug = 0;

$res_version = 'a.20130705';
$logic_version = 'b.20130705';

$config['maintain_work'] = false;
//$config['maintain_work'] = true;
$config['maintain_open'] = '13:59';

$config_open_reg = true;

$cfg_reg["credits"] = 0;
$cfg_reg["money"] = 1000;
$cfg_reg["voucher"] = 1000;
$cfg_reg["energy"] = 30;

