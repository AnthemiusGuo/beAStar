<?
$app_default_need_login = true;
$app_allow_nonLogin['main'] = array(
	'account'=>array('doLogin'=>1,'doRefresh'=>1,'login'=>1,'create'=>1),
	);
// |	0 = Disables logging, Error logging TURNED OFF
// |	1 = Error Messages (including PHP errors)
// |	2 = Debug Messages
// |	3 = Informational Messages
// |	4 = All Messages
$app_config['log_threshold'] = 1;
