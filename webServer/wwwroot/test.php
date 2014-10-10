<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
</head>
<body>
<?php
/*
*  index.php
*  Controller for po-php-fwlite  框架核心路由文件
*  Guo Jia(Anthemius, NJ.weihang@gmail.com)
*  http://code.google.com/p/po-php-fwlite
*
*  Created by Guo Jia on 2008-3-12.
*  Copyright 2008-2012 Guo Jia All rights reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*      http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/
//$playerLevelFile = "cdk4399.txt";
//$file = fopen($playerLevelFile,"w+");
$all_str = '';
$public_key = 'xp';
$cdkey_typ = 'ZQ';
for($key_id=1;$key_id<=2;$key_id++){
	$this_key = str_pad($key_id, 5, '0', STR_PAD_LEFT);
	$str = $this_key.'-'.$cdkey_typ.'-'.strtoupper(substr(md5($cdkey_typ.$key_id.$public_key),2,3));
	$str = base64_encode($str);
	echo $str;
	echo "<br/>";
	$all_str .= $str."\n";
    
}
//fwrite($file,$all_str);
//$g_access_mode = -1;
//include_once 'processes/base_init.process.php';
//include_once FR.'config/server/'.$g_server_name.'.config.php';
//include_once FR.'processes/lang.init.process.php';
//include_once FR.'functions/common/base.func.php';
//include_once FR.'functions/common/db.func.php';
//$abc = 24;
//init_sss();

//$intro_cdk = 985462;
//$intro_cdk = base64_encode($intro_cdk);
//echo $intro_cdk;
echo "<br/>";
echo "true";
?>
</body>
</html>
    